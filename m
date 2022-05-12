Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43A55243D6
	for <lists+live-patching@lfdr.de>; Thu, 12 May 2022 06:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343716AbiELEIG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 12 May 2022 00:08:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbiELEIF (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 12 May 2022 00:08:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0421C1944;
        Wed, 11 May 2022 21:07:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C9A1B826EB;
        Thu, 12 May 2022 04:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9DBC385B8;
        Thu, 12 May 2022 04:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652328476;
        bh=nToCYq4DpbQJGzgxLKbxS08A3TEqWAxzTo6AdzETI/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pnyzTZPV0KHLm1PzsbwJPizzvHeVHP2MhHeBLOxpQbNY3/5lwkmSbs4XPsvIJkla7
         EGT6amNGEP2JYeF/4E/FB7nWLHXZyawMsM5YwsqBsSvuBY8ZDys6XyFdFu6KgAXIA/
         MGjnP/9HazBbe3k9kChXuQ6Dbuf/E8JvxpzpJRdEwaxDy8x4+10xejVf28ZzMqa52r
         jcw54bZiITfexxCVXF153RAcerOfO59enG8GvxFKVM/bfDfvqwXCLgik68o0sUvgTl
         Q+MViQYmuzdAwYtGy140V6+wjbSPGSGGNXT8uGE0giieWkp2CdieG0sIsOSZ3m0cLA
         c4miDokqgQPSA==
Date:   Wed, 11 May 2022 21:07:54 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Petr Mladek <pmladek@suse.com>, Rik van Riel <riel@fb.com>,
        "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Message-ID: <20220512040754.hcnip7d2rhp4ldgg@treble>
References: <6bf85ff908377508a5f5bcc7c4e75d598b96f388.camel@fb.com>
 <20220510165244.ikfh64ertnvodxb4@treble>
 <1bd15361edfd4db9fc9271d35e7bbe5edad1b87a.camel@fb.com>
 <20220510184213.l3gjweeleyg7obca@treble>
 <47440502-930F-4CBD-B859-3AC9BBFF8FC6@fb.com>
 <20220510230402.e5ymkwt45sg7bd35@treble>
 <D298A3F1-43A5-4FD5-B198-906364BF4B79@fb.com>
 <20220511003331.clfvwfgpmbr5yx6n@treble>
 <20220511092433.GA26047@pathway.suse.cz>
 <78DFED12-571B-489C-A662-DA333555266B@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <78DFED12-571B-489C-A662-DA333555266B@fb.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, May 11, 2022 at 04:33:57PM +0000, Song Liu wrote:
> >> Ideally we'd have the ORC unwinder for all arches, that would make this
> >> much easier.  But we're not there yet.
> > 
> > The alternative solution is that the process has to migrate itself
> > on some safe location.
> > 
> > One crazy idea. It still might be possible to find the called
> > functions on the stack even when it is not reliable. Then it
> > might be possible to add another ftrace handler on
> > these found functions. This other ftrace handler might migrate
> > the task when it calls this function again.
> > 
> > It assumes that the task will call the same functions again
> > and again. Also it might require that the tasks checks its
> > own stack from the ftrace handler. I am not sure if this
> > is possible.
> > 
> > There might be other variants of this approach.
> 
> This might be the ultimate solution! As ftrace allows filtering based
> on pid (/sys/kernel/tracing/set_ftrace_pid), we can technically trigger
> klp_try_switch_task() on every function of the pending tasks. If this 
> works, we should finish most of the transition in seconds. And the only
> failure there would be threads with being patched function at the very 
> sottom of its stack. Am I too optimistic here? 

It's a crazy idea, but I kind of like it ;-)  Especially this variant of
tracing all functions for the task.  We'd have to make sure unwinding
from an ftrace handler works for all arches/unwinders.

-- 
Josh
