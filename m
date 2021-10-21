Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA4E436B55
	for <lists+live-patching@lfdr.de>; Thu, 21 Oct 2021 21:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbhJUTaf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Oct 2021 15:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhJUTaf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Oct 2021 15:30:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E547C061764;
        Thu, 21 Oct 2021 12:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ah6tJ/K8JoWRacdQOxgJTH6v5sbKB3uRhwOaTR5QYnk=; b=TO+qex53zPoyAR+dMR11e+TjFj
        o4lCRfpIQYOyED3lI6hhQl10wl/nygsONIRve2T5WHWCEqR/qEjyE5FsQeUKDmWenDTrZElks2S+m
        0aiwwonrE+9nhU44MH6i9mhGx5iaQaTwgjekceN6lc7yKlwe8rtGgVfO8CVZQaluahUDcTxfxpWn7
        BJF4X5pjBuZBeDo2V/7AqzcL47m95OfitnfwmqL5f80BJZwmZiNrjzfYBPrgKvyt4AfsEuCp03tLr
        jeg4kBZtc8GZ1Rz5uXSVezdnFFUmV0K2ewnVM7xOi3o/veaN7RcByi6zcYQK6zDmfnQLGo2N/yl6A
        QlHe5vfw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mddhA-00DUhc-EN; Thu, 21 Oct 2021 19:26:01 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id A0593986DD9; Thu, 21 Oct 2021 21:25:43 +0200 (CEST)
Date:   Thu, 21 Oct 2021 21:25:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [RFC][PATCH v2 11/11] context_tracking,x86: Fix text_poke_sync()
 vs NOHZ_FULL
Message-ID: <20211021192543.GV174703@worktop.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152429.186930629@infradead.org>
 <20211021183935.GA9071@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021183935.GA9071@fuller.cnet>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Oct 21, 2021 at 03:39:35PM -0300, Marcelo Tosatti wrote:
> Peter,
> 
> static __always_inline void arch_exit_to_user_mode(void)
> {
>         mds_user_clear_cpu_buffers();
> }
> 
> /**
>  * mds_user_clear_cpu_buffers - Mitigation for MDS and TAA vulnerability
>  *
>  * Clear CPU buffers if the corresponding static key is enabled
>  */
> static __always_inline void mds_user_clear_cpu_buffers(void)
> {
>         if (static_branch_likely(&mds_user_clear))
>                 mds_clear_cpu_buffers();
> }
> 
> We were discussing how to perform objtool style validation 
> that no code after the check for 

I'm not sure what the point of the above is... Were you trying to ask
for validation that nothing runs after the mds_user_clear_cpu_buffer()?

That isn't strictly true today, there's lockdep code after it. I can't
recall why that order is as it is though.

Pretty much everything in noinstr is magical, we just have to think
harder there (and possibly start writing more comments there).

> > +             /* NMI happens here and must still do/finish CT_WORK_n */
> > +             sync_core();
> 
> But after the discussion with you, it seems doing the TLB checking 
> and (also sync_core) checking very late/very early on exit/entry 
> makes things easier to review.

I don't know about late, it must happen *very* early in entry. The
sync_core() must happen before any self-modifying code gets called
(static_branch, static_call, etc..) with possible exception of the
context_tracking static_branch.

The TLBi must also happen super early, possibly while still on the
entry stack (since the task stack is vmap'ed). We currently don't run C
code on the entry stack, that needs quite a bit of careful work to make
happen.

> Can then use a single atomic variable with USER/KERNEL state and cmpxchg
> loops.

We're not going to add an atomic to context tracking. There is one, we
just got to extract/share it with RCU.
