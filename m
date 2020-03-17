Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA67C187BCD
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2020 10:16:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgCQJQV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 17 Mar 2020 05:16:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:55206 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgCQJQV (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 17 Mar 2020 05:16:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 69A5BAC67;
        Tue, 17 Mar 2020 09:16:19 +0000 (UTC)
Date:   Tue, 17 Mar 2020 10:16:18 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     =?ISO-8859-15?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>,
        boris.ostrovsky@oracle.com, sstabellini@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jslaby@suse.cz, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 2/2] x86/xen: Make the secondary CPU idle tasks
 reliable
In-Reply-To: <20200316203514.qm7so7b55jbmskgg@treble>
Message-ID: <alpine.LSU.2.21.2003171014470.21109@pobox.suse.cz>
References: <20200312142007.11488-1-mbenes@suse.cz> <20200312142007.11488-3-mbenes@suse.cz> <75224ad1-f160-802a-9d72-b092ba864fb7@suse.com> <alpine.LSU.2.21.2003131048110.30076@pobox.suse.cz> <alpine.LSU.2.21.2003161642450.15518@pobox.suse.cz>
 <20200316203514.qm7so7b55jbmskgg@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 16 Mar 2020, Josh Poimboeuf wrote:

> On Mon, Mar 16, 2020 at 04:51:12PM +0100, Miroslav Benes wrote:
> > > diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
> > > index 6b88cdcbef8f..39afd88309cb 100644
> > > --- a/arch/x86/xen/smp_pv.c
> > > +++ b/arch/x86/xen/smp_pv.c
> > > @@ -92,6 +92,7 @@ asmlinkage __visible void cpu_bringup_and_idle(void)
> > >  {
> > >         cpu_bringup();
> > >         boot_init_stack_canary();
> > > +       asm volatile (UNWIND_HINT(ORC_REG_UNDEFINED, 0, ORC_TYPE_CALL, 1));
> > >         cpu_startup_entry(CPUHP_AP_ONLINE_IDLE);
> > >  }
> > > 
> > > and that seems to work. I need to properly verify and test, but the 
> > > explanation is that as opposed to the above, cpu_startup_entry() is on the 
> > > idle task's stack and the hint is then taken into account. The unwound 
> > > stack seems to be complete, so it could indeed be the fix.
> > 
> > Not the correct one though. Objtool rightfully complains with
> > 
> > arch/x86/xen/smp_pv.o: warning: objtool: cpu_bringup_and_idle()+0x6a: undefined stack state
> > 
> > and all the other hacks I tried ended up in the same dead alley. It seems 
> > to me the correct fix is that all orc entries for cpu_bringup_and_idle() 
> > should have "end" property set to 1, since it is the first function on the 
> > stack. I don't know how to achieve that without the assembly hack in the 
> > patch I sent. If I am not missing something, of course.
> > 
> > Josh, any idea?
> 
> Yeah, I think mucking with the unwind hints in C code is going to be
> precarious.  You could maybe have something like
> 
> 	asm("
> 	  UNWIND_HINT_EMPTY\n
> 	  mov $CPUHP_AP_ONLINE_IDLE, %rdi\n
> 	  call cpu_startup_entry\n
> 	)"
> 	unreachable();
> 
> but that's pretty ugly (and it might not work anyway).
> 
> I suppose we could add a new facility to mark an entire C function as an
> "end" point.

I think it would be an overkill for what I perceive as one-off scenario. 
Maybe if there are more use cases in the future, but I doubt it.
 
> But I think it would be cleanest to just do something like your patch
> and have the entry code be asm which then calls cpu_bringup_and_idle().
> That would make it consistent with all other entry code, which all lives
> in asm.

Ack.

Thanks
Miroslav
