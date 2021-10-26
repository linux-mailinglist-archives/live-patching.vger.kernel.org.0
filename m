Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 718A843B94E
	for <lists+live-patching@lfdr.de>; Tue, 26 Oct 2021 20:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238209AbhJZSVx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Oct 2021 14:21:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:47947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238193AbhJZSVw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Oct 2021 14:21:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635272367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dWX6fvkzSDQgKu3VrjYNBZqwEZ/48vhRdGouru0gtXo=;
        b=fbqBq/3Qa8PUSeRZ5bp4xLArLcToSDaUZu7p4b6swXvn3YDg2Ax9Eft7Hh+WiQboyTbWrZ
        DFbzJNFQvdOVGpmFE3hTZTf+GGtN6o6BgCyxPIQp4j5rWlyVNloweU6VGAJmqdtFzO/jg9
        y7KLl3WGhPrFB+lcyd54h6ifNWZsgbE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-2ZMsfo8wOwmeczkJuWhaHA-1; Tue, 26 Oct 2021 14:19:21 -0400
X-MC-Unique: 2ZMsfo8wOwmeczkJuWhaHA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35A80802B52;
        Tue, 26 Oct 2021 18:19:19 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BE8CF1002EE2;
        Tue, 26 Oct 2021 18:19:15 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 9F0D14172ED8; Tue, 26 Oct 2021 15:19:11 -0300 (-03)
Date:   Tue, 26 Oct 2021 15:19:11 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [RFC][PATCH v2 11/11] context_tracking,x86: Fix text_poke_sync()
 vs NOHZ_FULL
Message-ID: <20211026181911.GA178890@fuller.cnet>
References: <20210929151723.162004989@infradead.org>
 <20210929152429.186930629@infradead.org>
 <20211021183935.GA9071@fuller.cnet>
 <20211021192543.GV174703@worktop.programming.kicks-ass.net>
 <20211021195709.GA22422@fuller.cnet>
 <20211021201859.GX174703@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021201859.GX174703@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Oct 21, 2021 at 10:18:59PM +0200, Peter Zijlstra wrote:
> On Thu, Oct 21, 2021 at 04:57:09PM -0300, Marcelo Tosatti wrote:
> > > Pretty much everything in noinstr is magical, we just have to think
> > > harder there (and possibly start writing more comments there).
> > 
> > mds_user_clear_cpu_buffers happens after sync_core, in your patchset, 
> > if i am not mistaken.
> 
> Of course it does, mds_user_clear_cpu_buffers() is on exit, the
> sync_core() is on entry.

                                                                  static_key enable/disable

__exit_to_user_mode ->                                            context_tracking_set_cpu_work(cpu, work)
   user_enter_irqoff ->                                                  preempt_disable();
   __context_tracking_enter(CONTEXT_USER);                               seq = atomic_read(&ct->seq);
      ct_seq_user_enter(raw_cpu_ptr(&context_tracking));                 if (__context_tracking_seq_in_user(seq)) {
      {                                                                          /* ctrl-dep */
        arch_atomic_set(&ct->work, 0);                                           atomic_or(work, &ct->work);
        return arch_atomic_add_return(CT_SEQ_USER, &ct->seq);                    ret = atomic_try_cmpxchg(&ct->seq, &seq, seq|CT_SEQ_WORK);
                                                                         }
      }                                                                  preempt_enable();
   arch_exit_to_user_mode()
   mds_user_clear_cpu_buffers();  <--- sync_core work queued,
                                       but not executed.
                                       i-cache potentially stale?

ct_seq_user_enter should happen _after_ all possible static_key users?

(or recheck that there is no pending work after any possible
rewritable code/static_key user).

> 
> > > > > +             /* NMI happens here and must still do/finish CT_WORK_n */
> > > > > +             sync_core();
> > > > 
> > > > But after the discussion with you, it seems doing the TLB checking 
> > > > and (also sync_core) checking very late/very early on exit/entry 
> > > > makes things easier to review.
> > > 
> > > I don't know about late, it must happen *very* early in entry. The
> > > sync_core() must happen before any self-modifying code gets called
> > > (static_branch, static_call, etc..) with possible exception of the
> > > context_tracking static_branch.
> > > 
> > > The TLBi must also happen super early, possibly while still on the
> > > entry stack (since the task stack is vmap'ed).
> > 
> > But will it be ever be freed/remapped from other CPUs while the task
> > is running?
> 
> Probably not, still something we need to be really careful with.
> > 
> > > We currently don't run C
> > > code on the entry stack, that needs quite a bit of careful work to make
> > > happen.
> > 
> > Was thinking of coding in ASM after (as early as possible) the write to 
> > switch to kernel CR3:
> 
> No, we're not going to add new feature to ASM. You'll just have to wait
> until all that gets lifted to C.
> 
> >  Kernel entry:
> >  -------------
> > 
> >        cpu = smp_processor_id();
> > 
> >        if (isolation_enabled(cpu)) {
> >                reqs = atomic_xchg(&percpudata->user_kernel_state, IN_KERNEL_MODE);
> >                if (reqs & CPU_REQ_FLUSH_TLB)
> > 			flush_tlb_all();
> >                if (reqs & CPU_REQ_SYNC_CORE)
> > 			sync_core();
> >        }                           
> > 
> > Exit to userspace (as close to write to CR3 with user pagetable
> > pointer):
> >  -----------------
> > 
> >        cpu = smp_processor_id();
> > 
> >        if (isolation_enabled(cpu)) {
> >                atomic_or(IN_USER_MODE, &percpudata->user_kernel_state);
> >        }
> > 
> > You think that is a bad idea (in ASM, not C) ? 
> 
> Those atomics are a bad idea and not goig to happen.
> 
> > > We're not going to add an atomic to context tracking. There is one, we
> > > just got to extract/share it with RCU.
> > 
> > Again, to avoid kernel TLB flushes you'd have to ensure:
> 
> I know how it works, but we're not going to add a second atomic to
> entry/exit. RCU has one in there, that's going to be it. Again, we just
> got to extract/share.

