Return-Path: <live-patching+bounces-568-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 19C2F9696CF
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 10:18:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C66642834E3
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 08:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98A7E201267;
	Tue,  3 Sep 2024 08:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LU13z+lT"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1421A19C562;
	Tue,  3 Sep 2024 08:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725351480; cv=none; b=qxYYwWlBhTBW/u+R0A9/Le7ddjnxvgojTFENxReIXCMGnHFs87S6shda5iy2Aa7a2iwmHFwymlzwXhytbInMK+aLt9ocS9SAkw9Kfy9x0l1a2M0TNwLg911+7mUCW1g8wUN2b4hNp7MQD47/FKAfAubHeja++ctCqewAHcz1rsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725351480; c=relaxed/simple;
	bh=AQhppktbbZw8K7eRyW+h9veW+56yTVjAbjapNw99muc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JRqCeuYJ7SNNBWgl5WBh+8IgOaFhpDowqp00xpxBB23kBqkQ+HQ+IMVcRcg+2zp4HxF1pDtR5Cu8dq/25H1UIIs+JSE02PaPNFQ9yCRGR+Sy9bMy7S7YeH2M1hqoBWRK5GVwSWnF/IaqHgEZVpjzJhRqGEVw24yxsG4krPmcTWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LU13z+lT; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tnmA712TBvDVDuU0YzHSaAeX23CstHAex5aTrADPY3Y=; b=LU13z+lTvJYmpLSYT4ZXlyeXUy
	iFywzKCqTAAEIK5xyYLk31rdZaqUk4nVzQ0y/vtEs96ECm/DaqFhv0QXeLMsg5tDW0my/3IoVcH2U
	4BK1eGuT0OaAJFrLYzmn5YddWuPdvruBF9+66sbd5wiHA05c8ONDfIsbnl08rVaxhZQVsyW30qvm5
	/cw4HSoe+PwN0gPWSahqyJu7AjDGJTp6iqeP52gh24ThrB99fGdb4ARMCseViXw1Nx2HUyx92Gope
	e/4eC8keNa814tz40SdBU+zRRYaSsTgUA2GqI0D8jXp8sWAy6A1jMD8MNfiQP2HjqYsjnMkI33aXj
	f73h/H+Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1slOjV-00000007wHd-3eyD;
	Tue, 03 Sep 2024 08:17:49 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E92D8300390; Tue,  3 Sep 2024 10:17:48 +0200 (CEST)
Date: Tue, 3 Sep 2024 10:17:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 20/31] objtool: Add UD1 detection
Message-ID: <20240903081748.GN4723@noisy.programming.kicks-ass.net>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <20e0e2662239a042a10196e8f240ce596b250ae8.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20e0e2662239a042a10196e8f240ce596b250ae8.1725334260.git.jpoimboe@kernel.org>

On Mon, Sep 02, 2024 at 09:00:03PM -0700, Josh Poimboeuf wrote:
> A UD1 isn't a BUG and shouldn't be treated like one.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  tools/objtool/arch/x86/decode.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
> index 6b34b058a821..72d55dcd3d7f 100644
> --- a/tools/objtool/arch/x86/decode.c
> +++ b/tools/objtool/arch/x86/decode.c
> @@ -528,11 +528,19 @@ int arch_decode_instruction(struct objtool_file *file, const struct section *sec
>  			/* sysenter, sysret */
>  			insn->type = INSN_CONTEXT_SWITCH;
>  
> -		} else if (op2 == 0x0b || op2 == 0xb9) {
> +		} else if (op2 == 0x0b) {
>  
>  			/* ud2 */
>  			insn->type = INSN_BUG;
>  
> +		} else if (op2 == 0xb9) {
> +
> +			/*
> +			 * ud1 - only used for the static call trampoline to
> +			 * stop speculation.  Basically used like an int3.
> +			 */
> +			insn->type = INSN_TRAP;
> +
>  		} else if (op2 == 0x0d || op2 == 0x1f) {
>  
>  			/* nopl/nopw */

We recently grew more UD1 usage...

---
commit 7424fc6b86c8980a87169e005f5cd4438d18efe6
Author: Gatlin Newhouse <gatlin.newhouse@gmail.com>
Date:   Wed Jul 24 00:01:55 2024 +0000

    x86/traps: Enable UBSAN traps on x86
    
    Currently ARM64 extracts which specific sanitizer has caused a trap via
    encoded data in the trap instruction. Clang on x86 currently encodes the
    same data in the UD1 instruction but x86 handle_bug() and
    is_valid_bugaddr() currently only look at UD2.
    
    Bring x86 to parity with ARM64, similar to commit 25b84002afb9 ("arm64:
    Support Clang UBSAN trap codes for better reporting"). See the llvm
    links for information about the code generation.
    
    Enable the reporting of UBSAN sanitizer details on x86 compiled with clang
    when CONFIG_UBSAN_TRAP=y by analysing UD1 and retrieving the type immediate
    which is encoded by the compiler after the UD1.
    
    [ tglx: Simplified it by moving the printk() into handle_bug() ]
    
    Signed-off-by: Gatlin Newhouse <gatlin.newhouse@gmail.com>
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
    Cc: Kees Cook <keescook@chromium.org>
    Link: https://lore.kernel.org/all/20240724000206.451425-1-gatlin.newhouse@gmail.com
    Link: https://github.com/llvm/llvm-project/commit/c5978f42ec8e9#diff-bb68d7cd885f41cfc35843998b0f9f534adb60b415f647109e597ce448e92d9f
    Link: https://github.com/llvm/llvm-project/blob/main/llvm/lib/Target/X86/X86InstrSystem.td#L27

diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index a3ec87d198ac..806649c7f23d 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -13,6 +13,18 @@
 #define INSN_UD2	0x0b0f
 #define LEN_UD2		2
 
+/*
+ * In clang we have UD1s reporting UBSAN failures on X86, 64 and 32bit.
+ */
+#define INSN_ASOP		0x67
+#define OPCODE_ESCAPE		0x0f
+#define SECOND_BYTE_OPCODE_UD1	0xb9
+#define SECOND_BYTE_OPCODE_UD2	0x0b
+
+#define BUG_NONE		0xffff
+#define BUG_UD1			0xfffe
+#define BUG_UD2			0xfffd
+
 #ifdef CONFIG_GENERIC_BUG
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 4fa0b17e5043..415881607c5d 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -42,6 +42,7 @@
 #include <linux/hardirq.h>
 #include <linux/atomic.h>
 #include <linux/iommu.h>
+#include <linux/ubsan.h>
 
 #include <asm/stacktrace.h>
 #include <asm/processor.h>
@@ -91,6 +92,47 @@ __always_inline int is_valid_bugaddr(unsigned long addr)
 	return *(unsigned short *)addr == INSN_UD2;
 }
 
+/*
+ * Check for UD1 or UD2, accounting for Address Size Override Prefixes.
+ * If it's a UD1, get the ModRM byte to pass along to UBSan.
+ */
+__always_inline int decode_bug(unsigned long addr, u32 *imm)
+{
+	u8 v;
+
+	if (addr < TASK_SIZE_MAX)
+		return BUG_NONE;
+
+	v = *(u8 *)(addr++);
+	if (v == INSN_ASOP)
+		v = *(u8 *)(addr++);
+	if (v != OPCODE_ESCAPE)
+		return BUG_NONE;
+
+	v = *(u8 *)(addr++);
+	if (v == SECOND_BYTE_OPCODE_UD2)
+		return BUG_UD2;
+
+	if (!IS_ENABLED(CONFIG_UBSAN_TRAP) || v != SECOND_BYTE_OPCODE_UD1)
+		return BUG_NONE;
+
+	/* Retrieve the immediate (type value) for the UBSAN UD1 */
+	v = *(u8 *)(addr++);
+	if (X86_MODRM_RM(v) == 4)
+		addr++;
+
+	*imm = 0;
+	if (X86_MODRM_MOD(v) == 1)
+		*imm = *(u8 *)addr;
+	else if (X86_MODRM_MOD(v) == 2)
+		*imm = *(u32 *)addr;
+	else
+		WARN_ONCE(1, "Unexpected MODRM_MOD: %u\n", X86_MODRM_MOD(v));
+
+	return BUG_UD1;
+}
+
+
 static nokprobe_inline int
 do_trap_no_signal(struct task_struct *tsk, int trapnr, const char *str,
 		  struct pt_regs *regs,	long error_code)
@@ -216,6 +258,8 @@ static inline void handle_invalid_op(struct pt_regs *regs)
 static noinstr bool handle_bug(struct pt_regs *regs)
 {
 	bool handled = false;
+	int ud_type;
+	u32 imm;
 
 	/*
 	 * Normally @regs are unpoisoned by irqentry_enter(), but handle_bug()
@@ -223,7 +267,8 @@ static noinstr bool handle_bug(struct pt_regs *regs)
 	 * irqentry_enter().
 	 */
 	kmsan_unpoison_entry_regs(regs);
-	if (!is_valid_bugaddr(regs->ip))
+	ud_type = decode_bug(regs->ip, &imm);
+	if (ud_type == BUG_NONE)
 		return handled;
 
 	/*
@@ -236,10 +281,14 @@ static noinstr bool handle_bug(struct pt_regs *regs)
 	 */
 	if (regs->flags & X86_EFLAGS_IF)
 		raw_local_irq_enable();
-	if (report_bug(regs->ip, regs) == BUG_TRAP_TYPE_WARN ||
-	    handle_cfi_failure(regs) == BUG_TRAP_TYPE_WARN) {
-		regs->ip += LEN_UD2;
-		handled = true;
+	if (ud_type == BUG_UD2) {
+		if (report_bug(regs->ip, regs) == BUG_TRAP_TYPE_WARN ||
+		    handle_cfi_failure(regs) == BUG_TRAP_TYPE_WARN) {
+			regs->ip += LEN_UD2;
+			handled = true;
+		}
+	} else if (IS_ENABLED(CONFIG_UBSAN_TRAP)) {
+		pr_crit("%s at %pS\n", report_ubsan_failure(regs, imm), (void *)regs->ip);
 	}
 	if (regs->flags & X86_EFLAGS_IF)
 		raw_local_irq_disable();
diff --git a/include/linux/ubsan.h b/include/linux/ubsan.h
index bff7445498de..d8219cbe09ff 100644
--- a/include/linux/ubsan.h
+++ b/include/linux/ubsan.h
@@ -4,6 +4,11 @@
 
 #ifdef CONFIG_UBSAN_TRAP
 const char *report_ubsan_failure(struct pt_regs *regs, u32 check_type);
+#else
+static inline const char *report_ubsan_failure(struct pt_regs *regs, u32 check_type)
+{
+	return NULL;
+}
 #endif
 
 #endif
diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
index bdda600f8dfb..1d4aa7a83b3a 100644
--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -29,8 +29,8 @@ config UBSAN_TRAP
 
 	  Also note that selecting Y will cause your kernel to Oops
 	  with an "illegal instruction" error with no further details
-	  when a UBSAN violation occurs. (Except on arm64, which will
-	  report which Sanitizer failed.) This may make it hard to
+	  when a UBSAN violation occurs. (Except on arm64 and x86, which
+	  will report which Sanitizer failed.) This may make it hard to
 	  determine whether an Oops was caused by UBSAN or to figure
 	  out the details of a UBSAN violation. It makes the kernel log
 	  output less useful for bug reports.

