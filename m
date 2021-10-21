Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DA8436ABA
	for <lists+live-patching@lfdr.de>; Thu, 21 Oct 2021 20:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhJUSnW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Oct 2021 14:43:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29479 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230381AbhJUSnW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Oct 2021 14:43:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634841666;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MWY1FdmcMYWp+TWFMNf9eB2WE06zN3EgHR6gfHOm49I=;
        b=VmKDDETVnlTvrWOepPIL0ermPMU/gkHTs+AbbBTEhoip5ZWw9mUV4sRa247HF6aQ3eZ1gF
        l9bUWsn7pPtkvQ/mxKctfCNzhWnHchbPif2YfuYg31Gj+hf0RNfZoZxmridZaCTjLpkJzK
        BhYDFPHaXnqlLXotLM2gpFDWfMntt+A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-toGDsN4ZPaqlIe-RlPs61g-1; Thu, 21 Oct 2021 14:41:02 -0400
X-MC-Unique: toGDsN4ZPaqlIe-RlPs61g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72CAF87950C;
        Thu, 21 Oct 2021 18:41:00 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-3.gru2.redhat.com [10.97.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 17F13100238C;
        Thu, 21 Oct 2021 18:40:46 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 8D488416C8AE; Thu, 21 Oct 2021 15:40:42 -0300 (-03)
Date:   Thu, 21 Oct 2021 15:40:42 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [RFC][PATCH v2 11/11] context_tracking,x86: Fix text_poke_sync()
 vs NOHZ_FULL
Message-ID: <20211021184042.GA19307@fuller.cnet>
References: <20210929151723.162004989@infradead.org>
 <20210929152429.186930629@infradead.org>
 <20211021183935.GA9071@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211021183935.GA9071@fuller.cnet>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+CC Nicolas.

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
> 
> > +             /* NMI happens here and must still do/finish CT_WORK_n */
> > +             sync_core();
> 
> But after the discussion with you, it seems doing the TLB checking 
> and (also sync_core) checking very late/very early on exit/entry 
> makes things easier to review.
> 
> Can then use a single atomic variable with USER/KERNEL state and cmpxchg
> loops.
> 
> On Wed, Sep 29, 2021 at 05:17:34PM +0200, Peter Zijlstra wrote:
> > Use the new context_tracking infrastructure to avoid disturbing
> > userspace tasks when we rewrite kernel code.
> > 
> > XXX re-audit the entry code to make sure only the context_tracking
> > static_branch is before hitting this code.
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  arch/x86/include/asm/sync_core.h |    2 ++
> >  arch/x86/kernel/alternative.c    |    8 +++++++-
> >  include/linux/context_tracking.h |    1 +
> >  kernel/context_tracking.c        |   12 ++++++++++++
> >  4 files changed, 22 insertions(+), 1 deletion(-)
> > 
> > --- a/arch/x86/include/asm/sync_core.h
> > +++ b/arch/x86/include/asm/sync_core.h
> > @@ -87,6 +87,8 @@ static inline void sync_core(void)
> >  	 */
> >  	iret_to_self();
> >  }
> > +#define sync_core sync_core
> > +
> >  
> >  /*
> >   * Ensure that a core serializing instruction is issued before returning
> > --- a/arch/x86/kernel/alternative.c
> > +++ b/arch/x86/kernel/alternative.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/mmu_context.h>
> >  #include <linux/bsearch.h>
> >  #include <linux/sync_core.h>
> > +#include <linux/context_tracking.h>
> >  #include <asm/text-patching.h>
> >  #include <asm/alternative.h>
> >  #include <asm/sections.h>
> > @@ -924,9 +925,14 @@ static void do_sync_core(void *info)
> >  	sync_core();
> >  }
> >  
> > +static bool do_sync_core_cond(int cpu, void *info)
> > +{
> > +	return !context_tracking_set_cpu_work(cpu, CT_WORK_SYNC);
> > +}
> > +
> >  void text_poke_sync(void)
> >  {
> > -	on_each_cpu(do_sync_core, NULL, 1);
> > +	on_each_cpu_cond(do_sync_core_cond, do_sync_core, NULL, 1);
> >  }
> >  
> >  struct text_poke_loc {
> > --- a/include/linux/context_tracking.h
> > +++ b/include/linux/context_tracking.h
> > @@ -11,6 +11,7 @@
> >  
> >  enum ct_work {
> >  	CT_WORK_KLP = 1,
> > +	CT_WORK_SYNC = 2,
> >  };
> >  
> >  /*
> > --- a/kernel/context_tracking.c
> > +++ b/kernel/context_tracking.c
> > @@ -51,6 +51,10 @@ static __always_inline void context_trac
> >  	__this_cpu_dec(context_tracking.recursion);
> >  }
> >  
> > +#ifndef sync_core
> > +static inline void sync_core(void) { }
> > +#endif
> > +
> >  /* CT_WORK_n, must be noinstr, non-blocking, NMI safe and deal with spurious calls */
> >  static noinstr void ct_exit_user_work(struct context_tracking *ct)
> >  {
> > @@ -64,6 +68,14 @@ static noinstr void ct_exit_user_work(struct
> >  		arch_atomic_andnot(CT_WORK_KLP, &ct->work);
> >  	}
> >  
> > +	if (work & CT_WORK_SYNC) {
> > +		/* NMI happens here and must still do/finish CT_WORK_n */
> > +		sync_core();
> > +
> > +		smp_mb__before_atomic();
> > +		arch_atomic_andnot(CT_WORK_SYNC, &ct->work);
> > +	}
> > +
> >  	smp_mb__before_atomic();
> >  	arch_atomic_andnot(CT_SEQ_WORK, &ct->seq);
> >  }
> > 
> > 
> > 

