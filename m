Return-Path: <live-patching+bounces-1502-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A7E2AD24B8
	for <lists+live-patching@lfdr.de>; Mon,  9 Jun 2025 19:07:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB31116D7DF
	for <lists+live-patching@lfdr.de>; Mon,  9 Jun 2025 17:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32483217654;
	Mon,  9 Jun 2025 17:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vH2M/C69"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8D18633F;
	Mon,  9 Jun 2025 17:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749488860; cv=none; b=WqnlBdEjXKhLWhNAfHl9q/fQK8kYArxaTvDlX9v7KRdNRk7K6QJqCkn6bpGjKL8tfe9zBnEGSalUyhM2A9gLWClnfNTmSRV9cNv2tlnWewdfzBwB6UsOpYPHW7oN8MrObOctc3ffy6vRi2TkGCxGal65vBbBfh6j+82nKyJzT8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749488860; c=relaxed/simple;
	bh=Ch2C2f0dQROPaS1DTJtHEKlSNL+mBdUuhKgHhovymg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I8P/X6WswUdw36e+GlI7zfZLoh/BaUVM1eB00uohXV2n9OIlcn+OLk1yU1j+uTqXdFtygxWTWCVqZThzJ/vVRLm7cLcHOpukkwScqm+03uoMu25Vq2cGo6vTtFvj0wuhysaztkC5JAIibSfa1V2vg51Ce7Z0CsJM/MYy7mgnu+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vH2M/C69; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8588DC4CEEB;
	Mon,  9 Jun 2025 17:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749488859;
	bh=Ch2C2f0dQROPaS1DTJtHEKlSNL+mBdUuhKgHhovymg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vH2M/C69bemRwZtTpWGOQO2awZinpECNdTHXCQlGpERQVQ6kmFmQN5+pz02+kDsgd
	 2HCOFM6A0azkIR5ASADe60WIgHthdjpUQU7NuHzBnOlaiwFHXkTWJjh+FcK/2eM12U
	 k7QL7Tcsr04MeTTIbr50z4VWJ+TtmMQMZw9a6GBqNo5uQyJ8F4LSimavzvJ33FUeX+
	 bTGg8dKujmfsNgFDFGfGXSAL+8uggG/EXuu1t15On7wT3/H9qx3sj/d7deeS0MfWFc
	 cqGW3PyTcIoOWTEOjZcq+FRCIUfQUq4B0D7vRV7cl9GW3oLE2ZzFOjGtuPfgsVJT6c
	 PZVop9vFKFJmA==
Date: Mon, 9 Jun 2025 10:07:36 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>, 
	Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org, Song Liu <song@kernel.org>, 
	laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>, 
	Fazla Mehrab <a.mehrab@bytedance.com>, Chen Zhongjin <chenzhongjin@huawei.com>, 
	Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 45/62] x86/extable: Define ELF section entry size for
 exception tables
Message-ID: <zsvgiietkr4qwrlnmvsov7xmgqe7khqmgluvr6f6hsqaw3sp4q@drakq47ntmhr>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <198cfbd12e54dfce1309828e146b90b1f7b200a5.1746821544.git.jpoimboe@kernel.org>
 <CAMzpN2jbdRJWhAWOKWzYczMjXqadg_braRgaxyA080K9G=xp0g@mail.gmail.com>
 <goiggh4js4t3g54fpcs6gugmp26uoumucszrx3e5cdrqdl7336@qijkbpy747jb>
 <CAMzpN2gmbgts1fFm2x=Ao=X-9g0U000+fPk_i7mMA-f0AQsQYg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMzpN2gmbgts1fFm2x=Ao=X-9g0U000+fPk_i7mMA-f0AQsQYg@mail.gmail.com>

On Fri, Jun 06, 2025 at 09:26:30PM -0400, Brian Gerst wrote:
> On Fri, Jun 6, 2025 at 3:48 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >
> > On Thu, Jun 05, 2025 at 11:58:23PM -0400, Brian Gerst wrote:
> > > On Fri, May 9, 2025 at 4:51 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > > >
> > > > In preparation for the objtool klp diff subcommand, define the entry
> > > > size for the __ex_table section in its ELF header.  This will allow
> > > > tooling to extract individual entries.
> > > >
> > > > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > > > ---
> > > >  arch/x86/include/asm/asm.h | 20 ++++++++++++--------
> > > >  kernel/extable.c           |  2 ++
> > > >  2 files changed, 14 insertions(+), 8 deletions(-)
> > > >
> > > > diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
> > > > index f963848024a5..62dff336f206 100644
> > > > --- a/arch/x86/include/asm/asm.h
> > > > +++ b/arch/x86/include/asm/asm.h
> > > > @@ -138,15 +138,17 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
> > > >
> > > >  # include <asm/extable_fixup_types.h>
> > > >
> > > > +#define EXTABLE_SIZE 12
> > >
> > > Put this in asm-offsets.c instead.
> >
> > But that's only for .S code right?  This is also needed for inline asm.
> 
> <asm/asm-offsets.h> can be used in C code too.  Normally it wouldn't
> be needed but the inline asm case is a valid use.

Ah, nice.  This is much better.  Thanks!

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index e206e0f96568..eb24d9ba30d7 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -16,8 +16,6 @@
 #define ALT_DIRECT_CALL(feature) ((ALT_FLAG_DIRECT_CALL << ALT_FLAGS_SHIFT) | (feature))
 #define ALT_CALL_ALWAYS		ALT_DIRECT_CALL(X86_FEATURE_ALWAYS)
 
-#define ALTINSTR_SIZE		14
-
 #ifndef __ASSEMBLER__
 
 #include <linux/stddef.h>
@@ -200,7 +198,7 @@ static inline int alternatives_text_reserved(void *start, void *end)
 
 #define ALTINSTR_ENTRY(ft_flags)					      \
 	".pushsection .altinstructions, \"aM\", @progbits, "		      \
-		      __stringify(ALTINSTR_SIZE) "\n"			      \
+		      __stringify(ALT_INSTR_SIZE) "\n"			      \
 	" .long 771b - .\n"				/* label           */ \
 	" .long 774f - .\n"				/* new instruction */ \
 	" .4byte " __stringify(ft_flags) "\n"		/* feature + flags */ \
@@ -363,7 +361,7 @@ void nop_func(void);
 741:									\
 	.skip -(((744f-743f)-(741b-740b)) > 0) * ((744f-743f)-(741b-740b)),0x90	;\
 742:									\
-	.pushsection .altinstructions, "aM", @progbits, ALTINSTR_SIZE ;	\
+	.pushsection .altinstructions, "aM", @progbits, ALT_INSTR_SIZE ;\
 	altinstr_entry 740b,743f,flag,742b-740b,744f-743f ;		\
 	.popsection ;							\
 	.pushsection .altinstr_replacement,"ax"	;			\
diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 62dff336f206..eb0b33f02be3 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -138,7 +138,9 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 
 # include <asm/extable_fixup_types.h>
 
-#define EXTABLE_SIZE 12
+#ifndef COMPILE_OFFSETS
+#include <asm/asm-offsets.h>
+#endif
 
 /* Exception table entry */
 #ifdef __ASSEMBLER__
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index d01ab5fa631f..4888e1c8be6a 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -593,8 +593,6 @@ void __init_or_module noinline apply_alternatives(struct alt_instr *start,
 	u8 *instr, *replacement;
 	struct alt_instr *a, *b;
 
-	BUILD_BUG_ON(ALTINSTR_SIZE != sizeof(struct alt_instr));
-
 	DPRINTK(ALT, "alt table %px, -> %px", start, end);
 
 	/*
diff --git a/arch/x86/kernel/asm-offsets.c b/arch/x86/kernel/asm-offsets.c
index 6259b474073b..805da27854ee 100644
--- a/arch/x86/kernel/asm-offsets.c
+++ b/arch/x86/kernel/asm-offsets.c
@@ -123,4 +123,8 @@ static void __used common(void)
 	OFFSET(ARIA_CTX_rounds, aria_ctx, rounds);
 #endif
 
+	BLANK();
+	DEFINE(EXTABLE_SIZE,	 sizeof(struct exception_table_entry));
+	DEFINE(UNWIND_HINT_SIZE, sizeof(struct unwind_hint));
+	DEFINE(ALT_INSTR_SIZE,	 sizeof(struct alt_instr));
 }
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 4624d6d916a2..977ee75e047c 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -199,8 +199,6 @@ static struct orc_entry *orc_find(unsigned long ip)
 {
 	static struct orc_entry *orc;
 
-	BUILD_BUG_ON(UNWIND_HINT_SIZE != sizeof(struct unwind_hint));
-
 	if (ip == 0)
 		return &null_orc_entry;
 
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index d4aae98b3739..bf8dab18be97 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -303,8 +303,6 @@ int fixup_exception(struct pt_regs *regs, int trapnr, unsigned long error_code,
 	const struct exception_table_entry *e;
 	int type, reg, imm;
 
-	BUILD_BUG_ON(EXTABLE_SIZE != sizeof(struct exception_table_entry));
-
 #ifdef CONFIG_PNPBIOS
 	if (unlikely(SEGMENT_IS_PNP_CODE(regs->cs))) {
 		extern u32 pnp_bios_fault_eip, pnp_bios_fault_esp;
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index d4137a46ee70..e93f0c28b54b 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -8,8 +8,6 @@
 
 #include <asm/asm.h>
 
-#define UNWIND_HINT_SIZE 12
-
 #ifndef __ASSEMBLY__
 
 #define UNWIND_HINT(type, sp_reg, sp_offset, signal)		\
diff --git a/kernel/bounds.c b/kernel/bounds.c
index 29b2cd00df2c..02b619eb6106 100644
--- a/kernel/bounds.c
+++ b/kernel/bounds.c
@@ -6,6 +6,7 @@
  */
 
 #define __GENERATING_BOUNDS_H
+#define COMPILE_OFFSETS
 /* Include headers that define the enum constants of interest */
 #include <linux/page-flags.h>
 #include <linux/mmzone.h>
diff --git a/scripts/mod/devicetable-offsets.c b/scripts/mod/devicetable-offsets.c
index d3d00e85edf7..ef2ffb68f69d 100644
--- a/scripts/mod/devicetable-offsets.c
+++ b/scripts/mod/devicetable-offsets.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#define COMPILE_OFFSETS
 #include <linux/kbuild.h>
 #include <linux/mod_devicetable.h>
 


