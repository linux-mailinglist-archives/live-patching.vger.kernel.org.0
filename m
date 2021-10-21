Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E98436BA4
	for <lists+live-patching@lfdr.de>; Thu, 21 Oct 2021 21:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbhJUT7n (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Oct 2021 15:59:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22011 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230020AbhJUT7m (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Oct 2021 15:59:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634846246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dxGaxjMR4kumyiXpYeJ2CbIw2HnzcdghR3vKPB/jYmw=;
        b=gngzKhI4cZFoO8/F+cui09/cTwswKAxrByFy+9JIRcPowpwnfJu3KF25DmaCY3/1eSaq70
        +UopsNx4mxgGLNSX3IzPHbaJ8UM/F8yJseJBhqUerg9+0Hky9fa2gm2Ee2DQL63Vp8fz5b
        Z0P+e5wOkZ+fdOoekhoPwVQnG//9VTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-J5lU4CVOOA-xODeFmepg_w-1; Thu, 21 Oct 2021 15:57:23 -0400
X-MC-Unique: J5lU4CVOOA-xODeFmepg_w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 922C31006AA2;
        Thu, 21 Oct 2021 19:57:20 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-3.gru2.redhat.com [10.97.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 109615BAE3;
        Thu, 21 Oct 2021 19:57:14 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 94BD8416C8AE; Thu, 21 Oct 2021 16:57:09 -0300 (-03)
Date:   Thu, 21 Oct 2021 16:57:09 -0300
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
Message-ID: <20211021195709.GA22422@fuller.cnet>
References: <20210929151723.162004989@infradead.org>
 <20210929152429.186930629@infradead.org>
 <20211021183935.GA9071@fuller.cnet>
 <20211021192543.GV174703@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021192543.GV174703@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Oct 21, 2021 at 09:25:43PM +0200, Peter Zijlstra wrote:
> On Thu, Oct 21, 2021 at 03:39:35PM -0300, Marcelo Tosatti wrote:
> > Peter,
> > 
> > static __always_inline void arch_exit_to_user_mode(void)
> > {
> >         mds_user_clear_cpu_buffers();
> > }
> > 
> > /**
> >  * mds_user_clear_cpu_buffers - Mitigation for MDS and TAA vulnerability
> >  *
> >  * Clear CPU buffers if the corresponding static key is enabled
> >  */
> > static __always_inline void mds_user_clear_cpu_buffers(void)
> > {
> >         if (static_branch_likely(&mds_user_clear))
> >                 mds_clear_cpu_buffers();
> > }
> > 
> > We were discussing how to perform objtool style validation 
> > that no code after the check for 
> 
> I'm not sure what the point of the above is... Were you trying to ask
> for validation that nothing runs after the mds_user_clear_cpu_buffer()?
> 
> That isn't strictly true today, there's lockdep code after it. I can't
> recall why that order is as it is though.
> 
> Pretty much everything in noinstr is magical, we just have to think
> harder there (and possibly start writing more comments there).

mds_user_clear_cpu_buffers happens after sync_core, in your patchset, 
if i am not mistaken.

> > > +             /* NMI happens here and must still do/finish CT_WORK_n */
> > > +             sync_core();
> > 
> > But after the discussion with you, it seems doing the TLB checking 
> > and (also sync_core) checking very late/very early on exit/entry 
> > makes things easier to review.
> 
> I don't know about late, it must happen *very* early in entry. The
> sync_core() must happen before any self-modifying code gets called
> (static_branch, static_call, etc..) with possible exception of the
> context_tracking static_branch.
> 
> The TLBi must also happen super early, possibly while still on the
> entry stack (since the task stack is vmap'ed).

But will it be ever be freed/remapped from other CPUs while the task
is running?

> We currently don't run C
> code on the entry stack, that needs quite a bit of careful work to make
> happen.

Was thinking of coding in ASM after (as early as possible) the write to 
switch to kernel CR3:

 Kernel entry:
 -------------

       cpu = smp_processor_id();

       if (isolation_enabled(cpu)) {
               reqs = atomic_xchg(&percpudata->user_kernel_state, IN_KERNEL_MODE);
               if (reqs & CPU_REQ_FLUSH_TLB)
			flush_tlb_all();
               if (reqs & CPU_REQ_SYNC_CORE)
			sync_core();
       }                           

Exit to userspace (as close to write to CR3 with user pagetable
pointer):
 -----------------

       cpu = smp_processor_id();

       if (isolation_enabled(cpu)) {
               atomic_or(IN_USER_MODE, &percpudata->user_kernel_state);
       }

You think that is a bad idea (in ASM, not C) ? 
And request side can be in C:

 Request side:
 -------------

       int targetcpu;

       do {
               struct percpudata *pcpudata = per_cpu(&percpudata, targetcpu);

               old_state = pcpudata->user_kernel_state;

               /* in kernel mode ? */
               if (!(old_state & IN_USER_MODE)) {
                       smp_call_function_single(request_fn, targetcpu, 1);
                       break;
               }                                                                                                                         
               new_state = remote_state | CPU_REQ_FLUSH_TLB; // (or CPU_REQ_INV_ICACHE)
       } while (atomic_cmpxchg(&pcpudata->user_kernel_state, old_state, new_state) != old_state);   

(need logic to protect from atomic_cmpxchg always failing, but shouldnt
be difficult).

> > Can then use a single atomic variable with USER/KERNEL state and cmpxchg
> > loops.
> 
> We're not going to add an atomic to context tracking. There is one, we
> just got to extract/share it with RCU.

Again, to avoid kernel TLB flushes you'd have to ensure:

kernel entry:
	instrA addr1,addr2,addr3
	instrB addr2,addr3,addr4  <--- that no address here has TLBs
				       modified and flushed
	instrC addr5,addr6,addr7
        reqs = atomic_xchg(&percpudata->user_kernel_state, IN_KERNEL_MODE);
        if (reqs & CPU_REQ_FLUSH_TLB)
        	flush_tlb_all();

kernel exit:

        atomic_or(IN_USER_MODE, &percpudata->user_kernel_state);
	instrA addr1,addr2,addr3
	instrB addr2,addr3,addr4  <--- that no address here has TLBs
				       modified and flushed

This could be conditional on "task isolated mode" enabled (would be 
better if it didnt, though).

			

