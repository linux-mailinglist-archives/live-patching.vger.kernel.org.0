Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D675243CB
	for <lists+live-patching@lfdr.de>; Thu, 12 May 2022 06:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345522AbiELD7f (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 11 May 2022 23:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345540AbiELD7a (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 11 May 2022 23:59:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE8F387A9;
        Wed, 11 May 2022 20:59:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E1116199F;
        Thu, 12 May 2022 03:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87E1C34100;
        Thu, 12 May 2022 03:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652327967;
        bh=FHnlCKo4OJfwf9iDndv7NNBoXfgXo4izsk7Sb0eh2eY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MkGuGZ6ew0pLiv7fckOOiPj/57hPM1NUowfWK+QiNFX6AnDxgBoom07tVYUN0hZ+W
         O5FWEGcQK1BfVi7f0ot2sjzD3W9FdZelrMxiyNy7cRqKnuRBLtw4jB5O6buHdbHzM5
         JwqxvkPKqL505/PHZF+/QCtd1X7SdT8LZGJfa8LEdiU1OQ2PDi4P8uLY2rtxQdU8N3
         u0/DhbuVW1ngJ26y4sEFLohfKCRWq1FM0bpSdtO2+qSy1O0QTw1+3FtUD8ybQzYK4b
         AYzz3G0MwunY+wRaIZ9Dqxzaj9nyAT0+hGeHVNHptohw4Bbt7LjbX5AUB7kdotf8Oq
         PHFyn92SVEBWQ==
Date:   Wed, 11 May 2022 20:59:24 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Rik van Riel <riel@fb.com>
Cc:     "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pmladek@suse.com" <pmladek@suse.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Message-ID: <20220512035924.mn42wqwtqzparafc@treble>
References: <1bd15361edfd4db9fc9271d35e7bbe5edad1b87a.camel@fb.com>
 <20220510184213.l3gjweeleyg7obca@treble>
 <47440502-930F-4CBD-B859-3AC9BBFF8FC6@fb.com>
 <20220510230402.e5ymkwt45sg7bd35@treble>
 <D298A3F1-43A5-4FD5-B198-906364BF4B79@fb.com>
 <6c36c09fbf426280d13f6025f41aed4c65c042d6.camel@fb.com>
 <20220511003716.2lo6gkluwycvauda@treble>
 <bf682c8874a044a643becbb8704a4dfedadc3321.camel@fb.com>
 <20220511011235.f7cdkc6xn7redqa3@treble>
 <5c146997c0ae4869b55aa1b846e96005cda72949.camel@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c146997c0ae4869b55aa1b846e96005cda72949.camel@fb.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, May 11, 2022 at 06:09:28PM +0000, Rik van Riel wrote:
> On Tue, 2022-05-10 at 18:12 -0700, Josh Poimboeuf wrote:
> > On Wed, May 11, 2022 at 12:46:32AM +0000, Rik van Riel wrote:
> > > On Tue, 2022-05-10 at 17:37 -0700, Josh Poimboeuf wrote:
> > > > On Wed, May 11, 2022 at 12:35:11AM +0000, Rik van Riel wrote:
> > > > > On Tue, 2022-05-10 at 23:57 +0000, Song Liu wrote:
> > > > > > 
> > > > > > So, if we come back to the same question: is this a bug (or a
> > > > > > suboptimal
> > > > > > behavior that worth fixing)? If so, we are open to any
> > > > > > solution
> > > > > > that 
> > > > > > would also help PREEMPT and/or non-x86 arches. 
> > > > > > 
> > > > > Using the preempt notifiers during KLP transition should
> > > > > work equally well for PREEMPT and !PREEMPT. It also does
> > > > > not insert any additional code into the scheduler while
> > > > > there is no KLP transition going on.
> > > > 
> > > > As I've been saying, this is not going to work for PREEMPT
> > > > because,
> > > > without ORC, we can't reliably unwind from an IRQ handler, so the
> > > > kthread won't get patched.
> > > > 
> > > Isn't the sched_out preempt notifier always run in
> > > process context?
> > > 
> > > What am I missing?
> > 
> > Maybe it's technically process context at that point.  But the
> > important
> > point is that the call to the scheduler via preempt_schedule_irq()
> > originates from the "return from interrupt" path.
> 
> Ahhhh, I think I understand.
> 
> Does that mean if the scheduling of the kernel thread originated
> from an IRQ, the KLP transition will fail probably?

It will fail definitely, unless you have the ORC unwinder.

> However, if the call to schedule came from a voluntary preemption,
> for example through a cond_resched() or due to the thread going
> to sleep a little bit, the stack walk will be reliable, and the
> KLP transition may succeed?

Right.

-- 
Josh
