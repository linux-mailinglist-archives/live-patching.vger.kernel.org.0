Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 803F65261FA
	for <lists+live-patching@lfdr.de>; Fri, 13 May 2022 14:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380282AbiEMMdp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 May 2022 08:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380327AbiEMMdk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 May 2022 08:33:40 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A2E674C2;
        Fri, 13 May 2022 05:33:39 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A42C721A28;
        Fri, 13 May 2022 12:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652445217; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Djcq6OteRPEfJn//KjLPsXwBBDlJy1Icla/0iyhv198=;
        b=RtoFWSjaH5iSe8BXb79GYjey9O/UmVHeoV/3jkOlbZvLgsgUSLUBe16bayG8d7VxDxL8qT
        d25mAxBYg6g2M0NdK5e1HU3ETaY5+Zhn6efOh+Obifua/+CIYSmnJaFdHuayfDBka/ehfD
        cwQ+3BvUI8+lQ25c5+spYKDD+d6sGsg=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7DC822C141;
        Fri, 13 May 2022 12:33:37 +0000 (UTC)
Date:   Fri, 13 May 2022 14:33:34 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, Rik van Riel <riel@fb.com>,
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
Message-ID: <Yn5QHpc9YlAbP1li@alley>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78DFED12-571B-489C-A662-DA333555266B@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-05-11 16:33:57, Song Liu wrote:
> 
> 
> > On May 11, 2022, at 2:24 AM, Petr Mladek <pmladek@suse.com> wrote:
> > 
> > On Tue 2022-05-10 17:33:31, Josh Poimboeuf wrote:
> >> On Tue, May 10, 2022 at 11:57:04PM +0000, Song Liu wrote:
> >>>> If it's a real bug, we should fix it everywhere, not just for Facebook.
> >>>> Otherwise CONFIG_PREEMPT and/or non-x86 arches become second-class
> >>>> citizens.
> >>> 
> >>> I think "is it a real bug?" is the top question for me. So maybe we 
> >>> should take a step back.
> >>> 
> >>> The behavior we see is: A busy kernel thread blocks klp transition 
> >>> for more than a minute. But the transition eventually succeeded after 
> >>> < 10 retries on most systems. The kernel thread is well-behaved, as 
> >>> it calls cond_resched() at a reasonable frequency, so this is not a 
> >>> deadlock. 
> >>> 
> >>> If I understand Petr correctly, this behavior is expected, and thus 
> >>> is not a bug or issue for the livepatch subsystem. This is different
> >>> to our original expectation, but if this is what we agree on, we 
> >>> will look into ways to incorporate long wait time for patch 
> >>> transition in our automations. 
> >> 
> >> That's how we've traditionally looked at it, though apparently Red Hat
> >> and SUSE have implemented different ideas of what a long wait time is.
> >> 
> >> In practice, one minute has always been enough for all of kpatch's users
> >> -- AFAIK, everybody except SUSE -- up until now.
> > 
> > I am actually surprised that nobody met the problem yet. There are
> > "only" 60 attempts to transition the pending tasks.
> 
> Maybe we should consider increase the frequency we try? Say to 10 times
> per second? I guess this will solve most of the failures we are seeing
> in current case. 

My concern is that klp_try_complete_transition() checks all processes
under read_lock(&tasklist_lock). It might create some contention
on this lock. I am not sure if this lock is fair. It might slow down
block writers (creating/deleting tasks).

Best Regards,
Petr
