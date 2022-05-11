Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA8C522886
	for <lists+live-patching@lfdr.de>; Wed, 11 May 2022 02:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiEKAhW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 20:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239740AbiEKAhV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 20:37:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F925996E;
        Tue, 10 May 2022 17:37:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5CA5B82025;
        Wed, 11 May 2022 00:37:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8691C385D3;
        Wed, 11 May 2022 00:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652229438;
        bh=3T6cBgwabf4aPjN1IrgddLYYT34QeO/5btyzIA6tnwI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UZlVvKAUL0dnOeHau5tUQdxel5K7Nv/+5EKqK3i1Jz0RRFvHXGkoVRFfYZg8YmB3I
         L27LkwNtcqJ14HdPt/Rc/8C5QpxMinzo8jv9vqPs/whnyeohVYV+m05J8GQAp904UM
         aq81Jk/xOEVJDNpmmEb1JHn/PslZLJ9CYgpY4PbFHDZss0iUw8WjGFFvQdXvdDFW01
         wD3eYyctD9T1c8xobb3C4OYvSqgIpdL9J2sxoDsZFK9QUflr09Xcc0eZ9r5BUT3gLd
         /A+RN9vKCR9gyjGIRtGdO82ubHQUN4QrhJV+BoXyR18n4gzJh8oUSrE67BkJeGXYzX
         RL1as20mnvDIg==
Date:   Tue, 10 May 2022 17:37:16 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Rik van Riel <riel@fb.com>
Cc:     Song Liu <songliubraving@fb.com>,
        "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Message-ID: <20220511003716.2lo6gkluwycvauda@treble>
References: <3a9bfb4a52b715bd8739d8834409c9549ec7f22f.camel@fb.com>
 <YnqIcw+dYsWz/w7g@alley>
 <6bf85ff908377508a5f5bcc7c4e75d598b96f388.camel@fb.com>
 <20220510165244.ikfh64ertnvodxb4@treble>
 <1bd15361edfd4db9fc9271d35e7bbe5edad1b87a.camel@fb.com>
 <20220510184213.l3gjweeleyg7obca@treble>
 <47440502-930F-4CBD-B859-3AC9BBFF8FC6@fb.com>
 <20220510230402.e5ymkwt45sg7bd35@treble>
 <D298A3F1-43A5-4FD5-B198-906364BF4B79@fb.com>
 <6c36c09fbf426280d13f6025f41aed4c65c042d6.camel@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6c36c09fbf426280d13f6025f41aed4c65c042d6.camel@fb.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, May 11, 2022 at 12:35:11AM +0000, Rik van Riel wrote:
> On Tue, 2022-05-10 at 23:57 +0000, Song Liu wrote:
> > 
> > So, if we come back to the same question: is this a bug (or a
> > suboptimal
> > behavior that worth fixing)? If so, we are open to any solution that 
> > would also help PREEMPT and/or non-x86 arches. 
> > 
> Using the preempt notifiers during KLP transition should
> work equally well for PREEMPT and !PREEMPT. It also does
> not insert any additional code into the scheduler while
> there is no KLP transition going on.

As I've been saying, this is not going to work for PREEMPT because,
without ORC, we can't reliably unwind from an IRQ handler, so the
kthread won't get patched.

-- 
Josh
