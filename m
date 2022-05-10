Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8969A522756
	for <lists+live-patching@lfdr.de>; Wed, 11 May 2022 01:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237671AbiEJXEL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 19:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237704AbiEJXEJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 19:04:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322C1C5E7F;
        Tue, 10 May 2022 16:04:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79EB5B81FA8;
        Tue, 10 May 2022 23:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8E5C385CE;
        Tue, 10 May 2022 23:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652223844;
        bh=iCYV15DfR+BEr5RvtEavvwo6ovTlC0z54Wr3xrFZk40=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c2ExLq+Hps5wHasqSR4RCet/Pw28c6/rgvxFwmGH7SGyvXFE6sWGN+LiH6JOeUISK
         5wqMxB4cAll3gOCVsmo+qzZVDCa4GptpfzUjTlXd8RYWe+wBwCowb9raXpRG0YPZBD
         YQdcmXsdQU2hiBDf4hBWwA0yjkH0irq16my8vvGL0q5UytEpn8bWkU61ec20cXvNlz
         eWNULDVAmcI689lCzsAViNNs69XHhXyxKPOJrjz7rVz9PokIQ3jMQxEnsYKzdlDFt/
         G/7WUcMFptDJ/ItBXaleqO+q+725tzHo2g/UAHxT9ihlYHAlk2XIUjFnkb9dCP2pXY
         6C1Yq22tr8oaw==
Date:   Tue, 10 May 2022 16:04:02 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Rik van Riel <riel@fb.com>, "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Message-ID: <20220510230402.e5ymkwt45sg7bd35@treble>
References: <YnkuFrm1YR46OFx/@alley>
 <9C7DF147-5112-42E7-9F7C-7159EFDFB766@fb.com>
 <YnoawYtoCSvrK7lb@alley>
 <3a9bfb4a52b715bd8739d8834409c9549ec7f22f.camel@fb.com>
 <YnqIcw+dYsWz/w7g@alley>
 <6bf85ff908377508a5f5bcc7c4e75d598b96f388.camel@fb.com>
 <20220510165244.ikfh64ertnvodxb4@treble>
 <1bd15361edfd4db9fc9271d35e7bbe5edad1b87a.camel@fb.com>
 <20220510184213.l3gjweeleyg7obca@treble>
 <47440502-930F-4CBD-B859-3AC9BBFF8FC6@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47440502-930F-4CBD-B859-3AC9BBFF8FC6@fb.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 10, 2022 at 07:45:49PM +0000, Song Liu wrote:
> >> A KLP transition preempt notifier would help those
> >> kernel threads transition to the new KLP version at
> >> any time they reschedule.
> > 
> > ... unless cond_resched() is a no-op due to CONFIG_PREEMPT?
> 
> Based on my understanding (and a few other folks we chatted with),
> a kernel thread can legally run for extended time, as long as it 
> calls cond_resched() at a reasonable frequency. Therefore, I 
> think we should be able to patch such thread easily, unless it 
> calls cond_resched() with being-patched function in the stack, 
> of course.

But again, with CONFIG_PREEMPT, that doesn't work.

> OTOH, Petr's mindset of allowing many minutes for the patch 
> transition is new to me. I need to think more about it. 
> Josh, what’s you opinion on this? IIUC, kpatch is designed to 
> only wait up to 60 seconds (no option to overwrite the time). 

I wouldn't be necessarily opposed to changing the kpatch timeout to
something bigger, or eliminating it altogether in favor of a WARN()
after x minutes.

> >> How much it will help is hard to predict, but I should
> >> be able to get results from a fairly large sample size
> >> of systems within a few weeks :)
> > 
> > As Peter said, keep in mind that we will need to fix other cases beyond
> > Facebook, i.e., CONFIG_PREEMPT combined with non-x86 arches which don't
> > have ORC so they can't reliably unwind from an IRQ.
> 
> I think livepatch transition may fail in different cases, and we
> don't need to address all of them in one shoot. Fixing some cases
> is an improvement as long as we don't slow down other cases. I 
> understand that adding tiny overhead to __cond_resched() may end 
> up as a visible regression. But maybe adding it to 
> preempt_schedule_common() is light enough?
> 
> Did I miss/misunderstand something?

If it's a real bug, we should fix it everywhere, not just for Facebook.
Otherwise CONFIG_PREEMPT and/or non-x86 arches become second-class
citizens.

-- 
Josh
