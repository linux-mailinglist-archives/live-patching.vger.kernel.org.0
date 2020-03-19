Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5EF18B175
	for <lists+live-patching@lfdr.de>; Thu, 19 Mar 2020 11:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgCSKbV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 19 Mar 2020 06:31:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:56756 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726589AbgCSKbV (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 19 Mar 2020 06:31:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 44D14B197;
        Thu, 19 Mar 2020 10:31:19 +0000 (UTC)
Date:   Thu, 19 Mar 2020 11:31:18 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Jan Beulich <jbeulich@suse.com>
cc:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, jpoimboe@redhat.com,
        andrew.cooper3@citrix.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        xen-devel@lists.xenproject.org, jslaby@suse.cz
Subject: Re: [PATCH v2 1/2] x86/xen: Make the boot CPU idle task reliable
In-Reply-To: <71c4eeaf-958a-b215-3033-c3e0d74a9cfa@suse.com>
Message-ID: <alpine.LSU.2.21.2003191129050.24428@pobox.suse.cz>
References: <20200319095606.23627-1-mbenes@suse.cz> <20200319095606.23627-2-mbenes@suse.cz> <71c4eeaf-958a-b215-3033-c3e0d74a9cfa@suse.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 19 Mar 2020, Jan Beulich wrote:

> On 19.03.2020 10:56, Miroslav Benes wrote:
> > The unwinder reports the boot CPU idle task's stack on XEN PV as
> > unreliable, which affects at least live patching. There are two reasons
> > for this. First, the task does not follow the x86 convention that its
> > stack starts at the offset right below saved pt_regs. It allows the
> > unwinder to easily detect the end of the stack and verify it. Second,
> > startup_xen() function does not store the return address before jumping
> > to xen_start_kernel() which confuses the unwinder.
> > 
> > Amend both issues by moving the starting point of initial stack in
> > startup_xen() and storing the return address before the jump, which is
> > exactly what call instruction does.
> > 
> > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > ---
> >  arch/x86/xen/xen-head.S | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> > index 1d0cee3163e4..edc776af0e0a 100644
> > --- a/arch/x86/xen/xen-head.S
> > +++ b/arch/x86/xen/xen-head.S
> > @@ -35,7 +35,11 @@ SYM_CODE_START(startup_xen)
> >  	rep __ASM_SIZE(stos)
> >  
> >  	mov %_ASM_SI, xen_start_info
> > -	mov $init_thread_union+THREAD_SIZE, %_ASM_SP
> > +#ifdef CONFIG_X86_64
> > +	mov initial_stack(%rip), %_ASM_SP
> > +#else
> > +	mov pa(initial_stack), %_ASM_SP
> > +#endif
> 
> If you need to distinguish the two anyway, why not use %rsp and
> %esp respectively?

I could, I just preferred the unification instead. Will change it if you 
think it would be better.

Miroslav
