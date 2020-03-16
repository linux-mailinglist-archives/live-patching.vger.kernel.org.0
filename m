Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7912018742C
	for <lists+live-patching@lfdr.de>; Mon, 16 Mar 2020 21:41:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732542AbgCPUld (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 16 Mar 2020 16:41:33 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:42837 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732537AbgCPUld (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 16 Mar 2020 16:41:33 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2020 16:41:31 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584391291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rNP0mmhYO3ZkBwa0TVYh9YRT8v7S/Igc0A+3yqdKcRw=;
        b=FWZf+oiqO6acoUfpLi8ArLBsxzbMlV0/NKBJYyiISjKdhzuGWCEVaEjsR/YtClVA059qQv
        9HYjjPI4v3GXccLBIRw5Jk/OXzP90Bjm8PBokc/RoO0fCN/3JEWcZ3jK4K8tuJCWzVHwvk
        u1Nb6YVE4BQVLc9fwznDPyqGnwD0QF0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-yXlxTpiMOSaQPrYogFg8ag-1; Mon, 16 Mar 2020 16:35:21 -0400
X-MC-Unique: yXlxTpiMOSaQPrYogFg8ag-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 39A0918AB2C0;
        Mon, 16 Mar 2020 20:35:19 +0000 (UTC)
Received: from treble (ovpn-121-192.rdu2.redhat.com [10.10.121.192])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 852049CA3;
        Mon, 16 Mar 2020 20:35:16 +0000 (UTC)
Date:   Mon, 16 Mar 2020 15:35:14 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     =?utf-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        boris.ostrovsky@oracle.com, sstabellini@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        x86@kernel.org, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        jslaby@suse.cz, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 2/2] x86/xen: Make the secondary CPU idle tasks
 reliable
Message-ID: <20200316203514.qm7so7b55jbmskgg@treble>
References: <20200312142007.11488-1-mbenes@suse.cz>
 <20200312142007.11488-3-mbenes@suse.cz>
 <75224ad1-f160-802a-9d72-b092ba864fb7@suse.com>
 <alpine.LSU.2.21.2003131048110.30076@pobox.suse.cz>
 <alpine.LSU.2.21.2003161642450.15518@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2003161642450.15518@pobox.suse.cz>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Mar 16, 2020 at 04:51:12PM +0100, Miroslav Benes wrote:
> > diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
> > index 6b88cdcbef8f..39afd88309cb 100644
> > --- a/arch/x86/xen/smp_pv.c
> > +++ b/arch/x86/xen/smp_pv.c
> > @@ -92,6 +92,7 @@ asmlinkage __visible void cpu_bringup_and_idle(void)
> >  {
> >         cpu_bringup();
> >         boot_init_stack_canary();
> > +       asm volatile (UNWIND_HINT(ORC_REG_UNDEFINED, 0, ORC_TYPE_CALL, 1));
> >         cpu_startup_entry(CPUHP_AP_ONLINE_IDLE);
> >  }
> > 
> > and that seems to work. I need to properly verify and test, but the 
> > explanation is that as opposed to the above, cpu_startup_entry() is on the 
> > idle task's stack and the hint is then taken into account. The unwound 
> > stack seems to be complete, so it could indeed be the fix.
> 
> Not the correct one though. Objtool rightfully complains with
> 
> arch/x86/xen/smp_pv.o: warning: objtool: cpu_bringup_and_idle()+0x6a: undefined stack state
> 
> and all the other hacks I tried ended up in the same dead alley. It seems 
> to me the correct fix is that all orc entries for cpu_bringup_and_idle() 
> should have "end" property set to 1, since it is the first function on the 
> stack. I don't know how to achieve that without the assembly hack in the 
> patch I sent. If I am not missing something, of course.
> 
> Josh, any idea?

Yeah, I think mucking with the unwind hints in C code is going to be
precarious.  You could maybe have something like

	asm("
	  UNWIND_HINT_EMPTY\n
	  mov $CPUHP_AP_ONLINE_IDLE, %rdi\n
	  call cpu_startup_entry\n
	)"
	unreachable();

but that's pretty ugly (and it might not work anyway).

I suppose we could add a new facility to mark an entire C function as an
"end" point.

But I think it would be cleanest to just do something like your patch
and have the entry code be asm which then calls cpu_bringup_and_idle().
That would make it consistent with all other entry code, which all lives
in asm.

-- 
Josh

