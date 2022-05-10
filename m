Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393895221CC
	for <lists+live-patching@lfdr.de>; Tue, 10 May 2022 18:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347745AbiEJQ4y (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 12:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347707AbiEJQ4w (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 12:56:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16F7727E3E7;
        Tue, 10 May 2022 09:52:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2EF0B81E6F;
        Tue, 10 May 2022 16:52:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C331C385C9;
        Tue, 10 May 2022 16:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652201566;
        bh=gOv/6M6fxAvAGRiLfh4MAxrmUxOE18lSG6X5RxF3Cbs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VgqgWZ+rw3KKzHV8X9AqpTE0mS+vuLT4wrKmevMO5m3+BrZY8Gy682PcC9HY+SgRQ
         YcKu+CMNXtWBtti+PkI4i6QUC4KGwu8m72FlN7QnD12bXtuRMnsDF3nDh6Md5TQdxO
         rfGjKN9YUzjIYiJd3DIkSYkjjmwUg+BrbWDaiECaDhcO8VWCgpi3G+bTlUMxo42EQd
         S+MNfucozgVRRtJr9SCr0jBSM4tmdZFqvOLZyNmI3se8gbneU0PM7qAEGt8RAulb0/
         JAtAIuyQl5JcMu9mkxgbnOmjz38qk0Q3XKoBkGTX69XMWrp54M+QBoMFTGDVI2AL5w
         ng2WHS7tnFyLA==
Date:   Tue, 10 May 2022 09:52:44 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Rik van Riel <riel@fb.com>
Cc:     "pmladek@suse.com" <pmladek@suse.com>,
        "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Message-ID: <20220510165244.ikfh64ertnvodxb4@treble>
References: <20220507174628.2086373-1-song@kernel.org>
 <YnkuFrm1YR46OFx/@alley>
 <9C7DF147-5112-42E7-9F7C-7159EFDFB766@fb.com>
 <YnoawYtoCSvrK7lb@alley>
 <3a9bfb4a52b715bd8739d8834409c9549ec7f22f.camel@fb.com>
 <YnqIcw+dYsWz/w7g@alley>
 <6bf85ff908377508a5f5bcc7c4e75d598b96f388.camel@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6bf85ff908377508a5f5bcc7c4e75d598b96f388.camel@fb.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 10, 2022 at 04:07:42PM +0000, Rik van Riel wrote:
> On Tue, 2022-05-10 at 17:44 +0200, Petr Mladek wrote:
> > On Tue 2022-05-10 13:33:13, Rik van Riel wrote:
> > > On Tue, 2022-05-10 at 09:56 +0200, Petr Mladek wrote:
> > > 
> > 
> > > I think the best approach for us might be to just track what
> > > is causing the transition failures, and send in trivial patches
> > > to make the outer loop in such kernel threads do the same KLP
> > > transition the idle task already does.
> > 
> > I am afraid that is a way to hell. We might end up in doing
> > really crazy things if we want to complete the transition
> > in one minute.
> > 
> Now I wonder if we could just hook up a preempt notifier
> for kernel live patches. All the distro kernels already
> need the preempt notifier for KVM, anyway...
> 
> Is it crazy? Maybe a little.
> 
> Is it self contained, and something that could be done
> without inserting any extra code into a hot path while
> not in the middle of a KLP transition? Yes.
> 
> I'd be happy to come up with a patch that does that,
> unless anybody has good reasons I should not :)

I wouldn't be opposed to that, but how does it solve this problem?  If
as Peter said cond_resched() can be a NOP, then preemption would have to
be from an interrupt, in which case frame pointers aren't reliable.

-- 
Josh
