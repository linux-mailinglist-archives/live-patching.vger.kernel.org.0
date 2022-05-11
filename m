Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1108152287F
	for <lists+live-patching@lfdr.de>; Wed, 11 May 2022 02:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbiEKAdj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 20:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiEKAdh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 20:33:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D08F27BC67;
        Tue, 10 May 2022 17:33:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0649EB80E7B;
        Wed, 11 May 2022 00:33:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4F6C385CC;
        Wed, 11 May 2022 00:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652229213;
        bh=ysnlGX7zF/bsKYFpLB45z+ORre2t36cMPtH5tLe1FCA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mNWsoI+7gjSAh0cJTJZ8fZANpw4IZvWP4A+7kd/Qa4CF1qvbOj28mAOaZXxmjZGXV
         WtM3zNdzLjKQRei7yXzNqQuxOu16TX1EW+i8uiVIm+FdB0P2ZrbsZULswJMFxTMhj7
         jQo/UpinjfC4I1We6qpUyIMbfPBRVEbhvzVNEv1t65cetz/CuTXGUyBeE9gBTDrJBf
         Hs9m0azVuVvO4jSw1nd1VpwF1cG3ZNk60XDztH4M0rOQODr6Rr8/mCmAsb11OiM4lv
         Jo7GffZlN+4Sb3p29dLbhb+r7cGOQCV81VoHYf5rK99z1bOebLx937yCfApHbY9T9i
         TOAfR/O2slAIw==
Date:   Tue, 10 May 2022 17:33:31 -0700
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
Message-ID: <20220511003331.clfvwfgpmbr5yx6n@treble>
References: <YnoawYtoCSvrK7lb@alley>
 <3a9bfb4a52b715bd8739d8834409c9549ec7f22f.camel@fb.com>
 <YnqIcw+dYsWz/w7g@alley>
 <6bf85ff908377508a5f5bcc7c4e75d598b96f388.camel@fb.com>
 <20220510165244.ikfh64ertnvodxb4@treble>
 <1bd15361edfd4db9fc9271d35e7bbe5edad1b87a.camel@fb.com>
 <20220510184213.l3gjweeleyg7obca@treble>
 <47440502-930F-4CBD-B859-3AC9BBFF8FC6@fb.com>
 <20220510230402.e5ymkwt45sg7bd35@treble>
 <D298A3F1-43A5-4FD5-B198-906364BF4B79@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D298A3F1-43A5-4FD5-B198-906364BF4B79@fb.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 10, 2022 at 11:57:04PM +0000, Song Liu wrote:
> > If it's a real bug, we should fix it everywhere, not just for Facebook.
> > Otherwise CONFIG_PREEMPT and/or non-x86 arches become second-class
> > citizens.
> 
> I think "is it a real bug?" is the top question for me. So maybe we 
> should take a step back.
> 
> The behavior we see is: A busy kernel thread blocks klp transition 
> for more than a minute. But the transition eventually succeeded after 
> < 10 retries on most systems. The kernel thread is well-behaved, as 
> it calls cond_resched() at a reasonable frequency, so this is not a 
> deadlock. 
> 
> If I understand Petr correctly, this behavior is expected, and thus 
> is not a bug or issue for the livepatch subsystem. This is different
> to our original expectation, but if this is what we agree on, we 
> will look into ways to incorporate long wait time for patch 
> transition in our automations. 

That's how we've traditionally looked at it, though apparently Red Hat
and SUSE have implemented different ideas of what a long wait time is.

In practice, one minute has always been enough for all of kpatch's users
-- AFAIK, everybody except SUSE -- up until now.

That timeout is not set in stone, and can be extended if needed, either
with "kpatch load" waiting longer, or with it returning immediately and
instead reporting livepatch stalls via WARN().

The latter option is a bigger change in behavior, since any errors will
be delayed and reported in a different way, but if other users are ok
with that, it's fine with me.

Though, these options might be considered workarounds, as it's
theoretically possible for a kthread to be CPU-bound indefinitely,
beyond any arbitrarily chosen timeout.  But maybe that's not realistic
beyond a certain timeout value of X and we don't care?  I dunno.

> OTOH, if we think this is a suboptimal behavior (not necessarily a 
> bug, IIUC), we should consider improve it. I personally don’t think 
> shipping an improvement to one configuration makes other configurations
> second-class citizens. And, it is possible PREEMPT kernel does NOT
> even have such suboptimal behavior, right? (I really don't know.)

No, PREEMPT will have the same problem.  Preempting a kthread doesn't
patch it unless the task happens to still be blocked during the next
invocation of klp_transition_work_fn().

> So, if we come back to the same question: is this a bug (or a suboptimal
> behavior that worth fixing)? If so, we are open to any solution that 
> would also help PREEMPT and/or non-x86 arches. 

You're obviously trying to fix a real world problem.  Whether you call
that issue a bug, or "suboptimal behavior", it's still a problem.

As you said, the kthread is acting within the allowed parameters of how
a kthread should behave.  But "kpatch load" will fail.  That sounds
broken to me.  We need to figure out a way to fix that for all
configs/arches.

> Lastly, maybe a really naive question: does the following also helps
> PREEMPT=y configurations?

As I have been trying to say, that won't work for PREEMPT+!ORC, because,
when the kthread gets preempted, the stack trace will be attempted from
an IRQ and will be reported as unreliable.

Ideally we'd have the ORC unwinder for all arches, that would make this
much easier.  But we're not there yet.

-- 
Josh
