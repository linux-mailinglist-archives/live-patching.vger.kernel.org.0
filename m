Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 745D4183444
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2020 16:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgCLPRH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 12 Mar 2020 11:17:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:40160 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727455AbgCLPRH (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 12 Mar 2020 11:17:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A62CCABF4;
        Thu, 12 Mar 2020 15:17:05 +0000 (UTC)
Date:   Thu, 12 Mar 2020 16:17:04 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
cc:     boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, jpoimboe@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        xen-devel@lists.xenproject.org, jslaby@suse.cz
Subject: Re: [Xen-devel] [PATCH 1/2] x86/xen: Make the boot CPU idle task
 reliable
In-Reply-To: <dc55b23b-c0d2-3be0-222f-d104548c8cf4@citrix.com>
Message-ID: <alpine.LSU.2.21.2003121616190.28317@pobox.suse.cz>
References: <20200312142007.11488-1-mbenes@suse.cz> <20200312142007.11488-2-mbenes@suse.cz> <dc55b23b-c0d2-3be0-222f-d104548c8cf4@citrix.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1678380546-1273645187-1584026225=:28317"
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1678380546-1273645187-1584026225=:28317
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 12 Mar 2020, Andrew Cooper wrote:

> On 12/03/2020 14:20, Miroslav Benes wrote:
> > The unwinder reports the boot CPU idle task's stack on XEN PV as
> > unreliable, which affects at least live patching. There are two reasons
> > for this. First, the task does not follow the x86 convention that its
> > stack starts at the offset right below saved pt_regs. It allows the
> > unwinder to easily detect the end of the stack and verify it. Second,
> > startup_xen() function does not store the return address before jumping
> > to xen_start_kernel() which confuses the unwinder.
> >
> > Amend both issues by moving the starting point of initial stack in
> > startup_xen() and storing the return address before the jump.
> >
> > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > ---
> >  arch/x86/xen/xen-head.S | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> > index 1d0cee3163e4..642f346bfe02 100644
> > --- a/arch/x86/xen/xen-head.S
> > +++ b/arch/x86/xen/xen-head.S
> > @@ -35,7 +35,7 @@ SYM_CODE_START(startup_xen)
> >  	rep __ASM_SIZE(stos)
> >  
> >  	mov %_ASM_SI, xen_start_info
> > -	mov $init_thread_union+THREAD_SIZE, %_ASM_SP
> > +	mov $init_thread_union+THREAD_SIZE-SIZEOF_PTREGS, %_ASM_SP
> >  
> >  #ifdef CONFIG_X86_64
> >  	/* Set up %gs.
> > @@ -51,7 +51,9 @@ SYM_CODE_START(startup_xen)
> >  	wrmsr
> >  #endif
> >  
> > +	push $1f
> >  	jmp xen_start_kernel
> > +1:
> 
> Hang on.  Isn't this just a `call` instruction written in longhand?

It is (as far as I know). I wanted to keep it opencoded for a reason I 
don't remember now. I'll change it. Thanks.

Miroslav
--1678380546-1273645187-1584026225=:28317--
