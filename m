Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6391B69C9
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2020 01:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgDWX1K (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Apr 2020 19:27:10 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36745 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725936AbgDWX1K (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Apr 2020 19:27:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587684428;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MfgBjVJT8Qe4F9Avigjfw4aMMKJ+gS3Qr1hPwvgYRjU=;
        b=YyYJf1yf44cb+RYuUFBvSSqYjb29sOIQohyJraysbGsE9ixVdXRMuFNwCkNrkeEWevWhzk
        qc5X0cbfP37tFdt0rp2Y8W2jBVq4DKGlRZMW2bthJBENDZNLMbFhz8NKmmnZycPX2+bKA5
        qqowv8m0Fd+jgXbsf+eEH8AS9o6hLho=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-7clzXQH4Nf6_jK0lzXRdvw-1; Thu, 23 Apr 2020 19:27:06 -0400
X-MC-Unique: 7clzXQH4Nf6_jK0lzXRdvw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 785901895A2E;
        Thu, 23 Apr 2020 23:27:04 +0000 (UTC)
Received: from treble (ovpn-118-207.rdu2.redhat.com [10.10.118.207])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 562396084A;
        Thu, 23 Apr 2020 23:27:00 +0000 (UTC)
Date:   Thu, 23 Apr 2020 18:26:57 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, Vasily Gorbik <gor@linux.ibm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v2 6/9] s390/module: Use s390_kernel_write() for late
 relocations
Message-ID: <20200423232657.7minzcsysnhp474w@treble>
References: <cover.1587131959.git.jpoimboe@redhat.com>
 <18266eb2c2c9a2ce0033426837d89dcb363a85d3.1587131959.git.jpoimboe@redhat.com>
 <20200422164037.7edd21ea@thinkpad>
 <20200422172126.743908f5@thinkpad>
 <20200422194605.n77t2wtx5fomxpyd@treble>
 <20200423141834.234ed0bc@thinkpad>
 <alpine.LSU.2.21.2004231513250.6520@pobox.suse.cz>
 <20200423141228.sjvnxwdqlzoyqdwg@treble>
 <20200423181030.b5mircvgc7zmqacr@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200423181030.b5mircvgc7zmqacr@treble>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Apr 23, 2020 at 01:10:30PM -0500, Josh Poimboeuf wrote:
> On Thu, Apr 23, 2020 at 09:12:28AM -0500, Josh Poimboeuf wrote:
> > > > this is strange. While I would have expected an exception similar to
> > > > this, it really should have happened on the "sturg" instruction which
> > > > does the DAT-off store in s390_kernel_write(), and certainly not with
> > > > an ID of 0004 (protection). However, in your case, it happens on a
> > > > normal store instruction, with 0004 indicating a protection exception.
> > > > 
> > > > This is more like what I would expect e.g. in the case where you do
> > > > _not_ use the s390_kernel_write() function for RO module text patching,
> > > > but rather normal memory access. So I am pretty sure that this is not
> > > > related to the s390_kernel_write(), but some other issue, maybe some
> > > > place left where you still use normal memory access?
> > > 
> > > The call trace above also suggests that it is not a late relocation, no? 
> > > The path is from KLP module init function through klp_enable_patch. It should 
> > > mean that the to-be-patched object is loaded (it must be a module thanks 
> > > to a check klp_init_object_loaded(), vmlinux relocations were processed 
> > > earlier in apply_relocations()).
> > > 
> > > However, the KLP module state here must be COMING, so s390_kernel_write() 
> > > should be used. What are we missing?
> > 
> > I'm also scratching my head.  It _should_ be using s390_kernel_write()
> > based on the module state, but I don't see that on the stack trace.
> > 
> > This trace (and Gerald's comment) seem to imply it's using
> > __builtin_memcpy(), which might expected for UNFORMED state.
> > 
> > Weird...
> 
> Mystery solved:
> 
>   $ CROSS_COMPILE=s390x-linux-gnu- scripts/faddr2line vmlinux apply_rela+0x16a/0x520
>   apply_rela+0x16a/0x520:
>   apply_rela at arch/s390/kernel/module.c:336
> 
> which corresponds to the following code in apply_rela():
> 
> 
> 	case R_390_PLTOFF64:	/* 16 bit offset from GOT to PLT. */
> 		if (info->plt_initialized == 0) {
> 			unsigned int *ip;
> 			ip = me->core_layout.base + me->arch.plt_offset +
> 				info->plt_offset;
> 			ip[0] = 0x0d10e310;	/* basr 1,0  */
> 			ip[1] = 0x100a0004;	/* lg	1,10(1) */
> 
> 
> Notice how it's writing directly to text... oops.

Here's a fix, using write() for the PLT and the GOT.

diff --git a/arch/s390/kernel/module.c b/arch/s390/kernel/module.c
index 2798329ebb74..fe446f42818f 100644
--- a/arch/s390/kernel/module.c
+++ b/arch/s390/kernel/module.c
@@ -297,7 +297,7 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
 
 			gotent = me->core_layout.base + me->arch.got_offset +
 				info->got_offset;
-			*gotent = val;
+			write(gotent, &val, sizeof(*gotent));
 			info->got_initialized = 1;
 		}
 		val = info->got_offset + rela->r_addend;
@@ -330,25 +330,29 @@ static int apply_rela(Elf_Rela *rela, Elf_Addr base, Elf_Sym *symtab,
 	case R_390_PLTOFF32:	/* 32 bit offset from GOT to PLT. */
 	case R_390_PLTOFF64:	/* 16 bit offset from GOT to PLT. */
 		if (info->plt_initialized == 0) {
-			unsigned int *ip;
+			unsigned int *ip, insn[5];
+
 			ip = me->core_layout.base + me->arch.plt_offset +
 				info->plt_offset;
-			ip[0] = 0x0d10e310;	/* basr 1,0  */
-			ip[1] = 0x100a0004;	/* lg	1,10(1) */
+
+			insn[0] = 0x0d10e310;	/* basr 1,0  */
+			insn[1] = 0x100a0004;	/* lg	1,10(1) */
 			if (IS_ENABLED(CONFIG_EXPOLINE) && !nospec_disable) {
 				unsigned int *ij;
 				ij = me->core_layout.base +
 					me->arch.plt_offset +
 					me->arch.plt_size - PLT_ENTRY_SIZE;
-				ip[2] = 0xa7f40000 +	/* j __jump_r1 */
+				insn[2] = 0xa7f40000 +	/* j __jump_r1 */
 					(unsigned int)(u16)
 					(((unsigned long) ij - 8 -
 					  (unsigned long) ip) / 2);
 			} else {
-				ip[2] = 0x07f10000;	/* br %r1 */
+				insn[2] = 0x07f10000;	/* br %r1 */
 			}
-			ip[3] = (unsigned int) (val >> 32);
-			ip[4] = (unsigned int) val;
+			insn[3] = (unsigned int) (val >> 32);
+			insn[4] = (unsigned int) val;
+
+			write(ip, insn, sizeof(insn));
 			info->plt_initialized = 1;
 		}
 		if (r_type == R_390_PLTOFF16 ||

