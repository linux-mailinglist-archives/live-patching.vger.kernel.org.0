Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0635B521FA4
	for <lists+live-patching@lfdr.de>; Tue, 10 May 2022 17:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346277AbiEJPuq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 11:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243874AbiEJPu2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 11:50:28 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E84952802F8;
        Tue, 10 May 2022 08:44:53 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 553A21F8B2;
        Tue, 10 May 2022 15:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652197492; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D94f5ARMrLCZ+JVe2Vf8yz6MNGDaxHLJphnyqhro/vw=;
        b=frs11VzdorCMe355yWFZX7IzHbf0FqqKt4GDqUp4yd+GG3ZxRqJqI0bRQ2j5JBYCyo1TWN
        uzeDxE6LKWQWUzyo3c8EUfW44e2c3+xK4sx4B1gh7YfWz9vGPC0O3NIDA4sY66p9omkVxG
        oQQjVjdEmvhL35mery3MjEHAMym3QWg=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 355482C141;
        Tue, 10 May 2022 15:44:52 +0000 (UTC)
Date:   Tue, 10 May 2022 17:44:51 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Rik van Riel <riel@fb.com>
Cc:     Song Liu <songliubraving@fb.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "song@kernel.org" <song@kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Message-ID: <YnqIcw+dYsWz/w7g@alley>
References: <20220507174628.2086373-1-song@kernel.org>
 <YnkuFrm1YR46OFx/@alley>
 <9C7DF147-5112-42E7-9F7C-7159EFDFB766@fb.com>
 <YnoawYtoCSvrK7lb@alley>
 <3a9bfb4a52b715bd8739d8834409c9549ec7f22f.camel@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3a9bfb4a52b715bd8739d8834409c9549ec7f22f.camel@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2022-05-10 13:33:13, Rik van Riel wrote:
> On Tue, 2022-05-10 at 09:56 +0200, Petr Mladek wrote:
> > 
> > IMHO, the problem is that klp_transition_work_fn() tries the
> > transition "only" once per second, see
> > 
> > void klp_try_complete_transition(void)
> > {
> > [...]
> >                 schedule_delayed_work(&klp_transition_work,
> >                                       round_jiffies_relative(HZ));
> > [...]
> > }
> > 
> > It means that there are "only" 60 attempts to migrate the busy
> > process.
> > It fails when the process is in the running state or sleeping in a
> > livepatched function. There is a _non-zero_ chance of a bad luck.
> > 
> 
> We are definitely hitting that non-zero chance :)
> 
> > Anyway, the limit 60s looks like a bad idea to me. It is too low.
> 
> That has its own issues, though. System management software
> tracks whether kpatch succeeds, and a run of the system
> management software will not complete until all of the commands
> it has run have completed.
> 
> One reason for this is that allowing system management software
> to just fork more and more things that might potentially get
> stuck is that you never want your system management software
> to come even close to resembling a fork bomb :)
> 
> Rollout of the next config change to a system should not be
> blocked on KLP completion.

Makes sense.

> I think the best approach for us might be to just track what
> is causing the transition failures, and send in trivial patches
> to make the outer loop in such kernel threads do the same KLP
> transition the idle task already does.

I am afraid that is a way to hell. We might end up in doing
really crazy things if we want to complete the transition
in one minute.

The great thing about the current approach is that it tries
to livepatch the system without too much disruption. The
more we try to speed up the transition the more we might
disrupt the system. Not to say about the code complexity
and potential bugs.

IMHO a better approach is to fix your management system.
The task is done when the livepatch module is loaded.

If you want to know that there is some problem. Then the
livepatch code might write some warning when the transition
has not finished within some reasonable time frame
(1 hour or so). It might be monitored the same way
as the messages from various watchdogs, ...

Best Regards,
Petr
