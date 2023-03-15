Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59976BA407
	for <lists+live-patching@lfdr.de>; Wed, 15 Mar 2023 01:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjCOA0Q (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Mar 2023 20:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCOA0P (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Mar 2023 20:26:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EFA13DD5;
        Tue, 14 Mar 2023 17:26:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1086B81C20;
        Wed, 15 Mar 2023 00:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7450C433D2;
        Wed, 15 Mar 2023 00:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678839971;
        bh=/XAQ8rJt3lGOaB1E/YthUanR+sbcNEkijl/oe8YCtZ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uy+4w2F0tBaxVtF5+IeMp90ZEN1/sa8G+DZvW8BDgHPfErqM4omjPFdjXdQDBQQPG
         91YMajIgSoMKaPQXMZlWRD7D1IeH3CZJ+cjqlhpqkWJaNh7VcPWvnC343XK9h0BvED
         rSb6D+F8ZrfhYPqVSnyAisgWrFB/eTdX8hc/CZxhtmKptlYvFrpoCCBVQB8xQAHSPy
         Fyrvm14+OIkV3bO8aaNZchvFxh4hSS+7SMeiKv1WAgnKboJSxdeuP7ns+jrcP9pvA7
         dBittKfBqsYAzEWBKZum4ECjKUL1tfPd4aRg47TOHGPeJqgMUIc8PttJ/sOWxGrY8I
         2nSTU7/t7wDNw==
Date:   Tue, 14 Mar 2023 17:26:08 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH 0.5/3] livepatch: Convert stack entries array to percpu
Message-ID: <20230315002608.sulru3taycwrmvki@treble>
References: <cover.1677257135.git.jpoimboe@kernel.org>
 <4ae981466b7814ec221014fc2554b2f86f3fb70b.1677257135.git.jpoimboe@kernel.org>
 <Y/zSgw5LOpbp7e/A@alley>
 <20230228165608.kumgxziaietsjaz3@treble>
 <ZAH9baGIOVL4/OHM@alley>
 <20230313233346.kayh4t2lpicjkpsv@treble>
 <ZBBRbfAL5+ZI77XN@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZBBRbfAL5+ZI77XN@alley>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Mar 14, 2023 at 11:50:21AM +0100, Petr Mladek wrote:
> >  static int klp_check_stack(struct task_struct *task, const char **oldname)
> >  {
> > -	static unsigned long entries[MAX_STACK_ENTRIES];
> > +	unsigned long *entries = this_cpu_ptr(klp_stack_entries);
> >  	struct klp_object *obj;
> >  	struct klp_func *func;
> >  	int ret, nr_entries;
> >  
> > -	ret = stack_trace_save_tsk_reliable(task, entries, ARRAY_SIZE(entries));
> > +	/* Protect 'klp_stack_entries' */
> > +	lockdep_assert_preemption_disabled();
> 
> I think about adding:
> 
> 	/*
> 	 * Stay on the safe side even when cond_resched() is called from
> 	 * an IRQ context by mistake.
> 	 */
> 	if (!in_task())
> 		return -EINVAL;
> 
> Or is this prevented another way, please?

An IRQ handler trying to schedule would be a pretty major bug, no?

I think there are already several different checks for that.  For
example, the __might_resched() call in cond_resched().

-- 
Josh
