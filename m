Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4AA736565
	for <lists+live-patching@lfdr.de>; Tue, 20 Jun 2023 09:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjFTHyK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Jun 2023 03:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbjFTHxj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Jun 2023 03:53:39 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D802810D0;
        Tue, 20 Jun 2023 00:53:17 -0700 (PDT)
Received: from loongson.cn (unknown [113.200.148.30])
        by gateway (Coremail) with SMTP id _____8AxHuurWpFkLhwHAA--.14682S3;
        Tue, 20 Jun 2023 15:52:11 +0800 (CST)
Received: from bogon.localdomain (unknown [113.200.148.30])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8AxauWoWpFkdmghAA--.28374S3;
        Tue, 20 Jun 2023 15:52:09 +0800 (CST)
From:   Youling Tang <tangyouling@loongson.cn>
To:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        madvenka@linux.microsoft.com
Cc:     chenzhongjin@huawei.com, WANG Xuerui <kernel@xen0n.name>,
        Xi Ruoyao <xry111@xry111.site>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
        tangyouling00@gmail.com, youling.tang@outlook.com,
        Jinyang He <hejinyang@loongson.cn>
Subject: [RFC PATCH v1 16/23] LoongArch: Add ORC unwinder support
Date:   Tue, 20 Jun 2023 15:52:03 +0800
Message-Id: <1687247526-32258-2-git-send-email-tangyouling@loongson.cn>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1687247526-32258-1-git-send-email-tangyouling@loongson.cn>
References: <1687247526-32258-1-git-send-email-tangyouling@loongson.cn>
X-CM-TRANSID: AQAAf8AxauWoWpFkdmghAA--.28374S3
X-CM-SenderInfo: 5wdqw5prxox03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj9fXoWfJry3XFWfuF1xCr1UKFy7twc_yoW8WF45Wo
        WayF4jgr48CrZxt3yYyr1UtFWjqr4jyF4DA3yavw43WF47A345XrWUKa9xtFyIqrn5KrWx
        CFWSqrsYva1xJFn7l-sFpf9Il3svdjkaLaAFLSUrUUUUnb8apTn2vfkv8UJUUUU8wcxFpf
        9Il3svdxBIdaVrn0xqx4xG64xvF2IEw4CE5I8CrVC2j2Jv73VFW2AGmfu7bjvjm3AaLaJ3
        UjIYCTnIWjp_UUUOI7kC6x804xWl14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI
        8IcIk0rVWrJVCq3wAFIxvE14AKwVWUXVWUAwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
        Y2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14
        v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x02
        67AKxVW8Jr0_Cr1UM2kKe7AKxVWUAVWUtwAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
        CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
        xVW8Xw0E3s1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y4
        8IcxkI7VAKI48JM4x0Y40E4IxF1VCIxcxG6Fyj6r4UJwCY1x0262kKe7AKxVWUAVWUtwCF
        04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUAVWUtw
        C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
        wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWDJVCq3wCI42IY6xIIjx
        v20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
        z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2Kf
        nxnUUI43ZEXa7IUYyMKtUUUUU==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

With a blatant copy of some x86, we introduce the another unwinder named
"orc unwinder" to unwind stack with custom data created by objtool.

Before vmlinux created, we check all metadata, find the stack operation,
note stack state and create orc data. Objtool insert two sections into
vmlinux. '.orc_unwind_ip' and '.orc_unwind'. (For modules, insert
'.rela.orc_unwind_ip' to relocate '.orc_unwind_ip'.) Each insn has only
one stack state in .orc_unwind and orc_unwind_ip hint its pc address.
Through unwinding orc data, we can get stack info both kernel and module.

Do not like x86, we add ra_reg and ra_offset into orc_entry so that we
can get ra info before ra saved into stack. At present, the unwind ability
has not been fully reflected, because it has not been annotated in the
assembly code.

Co-developed-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Youling Tang <tangyouling@loongson.cn>
---
 arch/loongarch/Kconfig.debug        |  11 +
 arch/loongarch/include/asm/module.h |   7 +
 arch/loongarch/include/asm/unwind.h |  17 +-
 arch/loongarch/kernel/Makefile      |   1 +
 arch/loongarch/kernel/module.c      |  11 +-
 arch/loongarch/kernel/setup.c       |   2 +
 arch/loongarch/kernel/stacktrace.c  |   1 +
 arch/loongarch/kernel/unwind_orc.c  | 301 ++++++++++++++++++++++++++++
 arch/loongarch/kernel/vmlinux.lds.S |   3 +
 9 files changed, 351 insertions(+), 3 deletions(-)
 create mode 100644 arch/loongarch/kernel/unwind_orc.c

diff --git a/arch/loongarch/Kconfig.debug b/arch/loongarch/Kconfig.debug
index 8d36aab53008..98d60630c3d4 100644
--- a/arch/loongarch/Kconfig.debug
+++ b/arch/loongarch/Kconfig.debug
@@ -26,4 +26,15 @@ config UNWINDER_PROLOGUE
 	  Some of the addresses it reports may be incorrect (but better than the
 	  Guess unwinder).
 
+config UNWINDER_ORC
+	bool "ORC unwinder"
+	select OBJTOOL
+	help
+	  This option enables the ORC (Oops Rewind Capability) unwinder for
+	  unwinding kernel stack traces.  It uses a custom data format which is
+	  a simplified version of the DWARF Call Frame Information standard.
+
+	  Enabling this option will increase the kernel's runtime memory usage
+	  by roughly 2-4MB, depending on your kernel config.
+
 endchoice
diff --git a/arch/loongarch/include/asm/module.h b/arch/loongarch/include/asm/module.h
index 12a0f1e66916..0f654108d1ee 100644
--- a/arch/loongarch/include/asm/module.h
+++ b/arch/loongarch/include/asm/module.h
@@ -7,6 +7,7 @@
 
 #include <asm/inst.h>
 #include <asm-generic/module.h>
+#include <asm/orc_types.h>
 
 #define RELA_STACK_DEPTH 16
 
@@ -23,6 +24,12 @@ struct mod_arch_specific {
 
 	/* For CONFIG_DYNAMIC_FTRACE */
 	struct plt_entry *ftrace_trampolines;
+
+#ifdef CONFIG_UNWINDER_ORC
+	unsigned int num_orcs;
+	int *orc_unwind_ip;
+	struct orc_entry *orc_unwind;
+#endif
 };
 
 struct got_entry {
diff --git a/arch/loongarch/include/asm/unwind.h b/arch/loongarch/include/asm/unwind.h
index b9dce87afd2e..da92211c8595 100644
--- a/arch/loongarch/include/asm/unwind.h
+++ b/arch/loongarch/include/asm/unwind.h
@@ -16,6 +16,7 @@
 enum unwinder_type {
 	UNWINDER_GUESS,
 	UNWINDER_PROLOGUE,
+	UNWINDER_ORC,
 };
 
 struct unwind_state {
@@ -24,7 +25,7 @@ struct unwind_state {
 	struct task_struct *task;
 	bool first, error, reset;
 	int graph_idx;
-	unsigned long sp, pc, ra;
+	unsigned long sp, pc, ra, fp;
 };
 
 bool default_next_frame(struct unwind_state *state);
@@ -34,6 +35,12 @@ void unwind_start(struct unwind_state *state,
 bool unwind_next_frame(struct unwind_state *state);
 unsigned long unwind_get_return_address(struct unwind_state *state);
 
+#ifdef CONFIG_UNWINDER_ORC
+void unwind_init(void);
+#else
+static inline void unwind_init(void) {}
+#endif
+
 static inline bool unwind_done(struct unwind_state *state)
 {
 	return state->stack_info.type == STACK_TYPE_UNKNOWN;
@@ -61,14 +68,17 @@ static __always_inline void __unwind_start(struct unwind_state *state,
 		state->sp = regs->regs[3];
 		state->pc = regs->csr_era;
 		state->ra = regs->regs[1];
+		state->fp = regs->regs[22];
 	} else if (task && task != current) {
 		state->sp = thread_saved_fp(task);
 		state->pc = thread_saved_ra(task);
 		state->ra = 0;
+		state->fp = 0;
 	} else {
 		state->sp = (unsigned long)__builtin_frame_address(0);
 		state->pc = (unsigned long)__builtin_return_address(0);
 		state->ra = 0;
+		state->fp = 0;
 	}
 	state->task = task;
 	get_stack_info(state->sp, state->task, &state->stack_info);
@@ -77,6 +87,9 @@ static __always_inline void __unwind_start(struct unwind_state *state,
 
 static __always_inline unsigned long __unwind_get_return_address(struct unwind_state *state)
 {
-	return unwind_done(state) ? 0 : state->pc;
+	if (unwind_done(state))
+		return 0;
+
+	return __kernel_text_address(state->pc) ? state->pc : 0;
 }
 #endif /* _ASM_UNWIND_H */
diff --git a/arch/loongarch/kernel/Makefile b/arch/loongarch/kernel/Makefile
index 78d4e3384305..fcbfa0f38b53 100644
--- a/arch/loongarch/kernel/Makefile
+++ b/arch/loongarch/kernel/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 
 obj-$(CONFIG_UNWINDER_GUESS)	+= unwind_guess.o
 obj-$(CONFIG_UNWINDER_PROLOGUE) += unwind_prologue.o
+obj-$(CONFIG_UNWINDER_ORC)	+= unwind_orc.o
 
 obj-$(CONFIG_PERF_EVENTS)	+= perf_event.o perf_regs.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT)	+= hw_breakpoint.o
diff --git a/arch/loongarch/kernel/module.c b/arch/loongarch/kernel/module.c
index b8b86088b2dd..44f31b1958b1 100644
--- a/arch/loongarch/kernel/module.c
+++ b/arch/loongarch/kernel/module.c
@@ -20,6 +20,7 @@
 #include <linux/kernel.h>
 #include <asm/alternative.h>
 #include <asm/inst.h>
+#include <asm-generic/orc_lookup.h>
 
 static int rela_stack_push(s64 stack_value, s64 *rela_stack, size_t *rela_stack_top)
 {
@@ -495,7 +496,7 @@ static void module_init_ftrace_plt(const Elf_Ehdr *hdr,
 int module_finalize(const Elf_Ehdr *hdr,
 		    const Elf_Shdr *sechdrs, struct module *mod)
 {
-	const Elf_Shdr *s, *se;
+	const Elf_Shdr *s, *se, *orc = NULL, *orc_ip = NULL;
 	const char *secstrs = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
 
 	for (s = sechdrs, se = sechdrs + hdr->e_shnum; s < se; s++) {
@@ -503,7 +504,15 @@ int module_finalize(const Elf_Ehdr *hdr,
 			apply_alternatives((void *)s->sh_addr, (void *)s->sh_addr + s->sh_size);
 		if (!strcmp(".ftrace_trampoline", secstrs + s->sh_name))
 			module_init_ftrace_plt(hdr, s, mod);
+		if (!strcmp(".orc_unwind", secstrs + s->sh_name))
+			orc = s;
+		if (!strcmp(".orc_unwind_ip", secstrs + s->sh_name))
+			orc_ip = s;
 	}
 
+	if (orc && orc_ip)
+		orc_lookup_module_init(mod, (void *)orc_ip->sh_addr, orc_ip->sh_size,
+				       (void *)orc->sh_addr, orc->sh_size);
+
 	return 0;
 }
diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
index bae84ccf6d36..698024922e09 100644
--- a/arch/loongarch/kernel/setup.c
+++ b/arch/loongarch/kernel/setup.c
@@ -48,6 +48,7 @@
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/time.h>
+#include <asm/unwind.h>
 
 #define SMBIOS_BIOSSIZE_OFFSET		0x09
 #define SMBIOS_BIOSEXTERN_OFFSET	0x13
@@ -568,6 +569,7 @@ static void __init prefill_possible_map(void)
 
 void __init setup_arch(char **cmdline_p)
 {
+	unwind_init();
 	cpu_probe();
 
 	init_environ();
diff --git a/arch/loongarch/kernel/stacktrace.c b/arch/loongarch/kernel/stacktrace.c
index 3a690f96f00c..3872925375c4 100644
--- a/arch/loongarch/kernel/stacktrace.c
+++ b/arch/loongarch/kernel/stacktrace.c
@@ -29,6 +29,7 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 	}
 
 	regs->regs[1] = 0;
+	regs->regs[22] = 0;
 	for (unwind_start(&state, task, regs);
 	      !unwind_done(&state); unwind_next_frame(&state)) {
 		addr = unwind_get_return_address(&state);
diff --git a/arch/loongarch/kernel/unwind_orc.c b/arch/loongarch/kernel/unwind_orc.c
new file mode 100644
index 000000000000..0cdf4a56a9ba
--- /dev/null
+++ b/arch/loongarch/kernel/unwind_orc.c
@@ -0,0 +1,301 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/objtool.h>
+#include <linux/module.h>
+#include <linux/sort.h>
+#include <asm/ptrace.h>
+#include <asm/setup.h>
+#include <asm/stacktrace.h>
+#include <asm/unwind.h>
+#include <asm/orc_types.h>
+#include <asm-generic/orc_lookup.h>
+
+extern asmlinkage void handle_ade(void);
+extern asmlinkage void handle_ale(void);
+extern asmlinkage void handle_sys(void);
+extern asmlinkage void handle_bp(void);
+extern asmlinkage void handle_ri(void);
+extern asmlinkage void handle_fpu(void);
+extern asmlinkage void handle_fpe(void);
+extern asmlinkage void handle_lbt(void);
+extern asmlinkage void handle_lsx(void);
+extern asmlinkage void handle_lasx(void);
+extern asmlinkage void handle_reserved(void);
+extern asmlinkage void handle_watch(void);
+extern asmlinkage void handle_vint(void);
+extern asmlinkage void handle_tlb_load(void);
+extern asmlinkage void handle_tlb_store(void);
+extern asmlinkage void handle_tlb_modify(void);
+extern asmlinkage void handle_tlb_protect(void);
+
+/* Fake frame pointer entry -- used as a fallback for generated code */
+static struct orc_entry orc_fp_entry = {
+	.type		= UNWIND_HINT_TYPE_CALL,
+	.sp_reg		= ORC_REG_BP,
+	.sp_offset	= 16,
+	.bp_reg		= ORC_REG_PREV_SP,
+	.bp_offset	= -16,
+	.ra_reg		= ORC_REG_PREV_SP,
+	.ra_offset	= -8,
+	.end		= 0,
+};
+
+void __init unwind_init(void)
+{
+	orc_lookup_init();
+}
+
+static inline bool on_stack(struct stack_info *info, unsigned long addr, size_t len)
+{
+	unsigned long begin = info->begin;
+	unsigned long end   = info->end;
+
+	return (info->type != STACK_TYPE_UNKNOWN &&
+		addr >= begin && addr < end &&
+		addr + len > begin && addr + len <= end);
+}
+
+static bool stack_access_ok(struct unwind_state *state, unsigned long addr,
+			    size_t len)
+{
+	struct stack_info *info = &state->stack_info;
+
+	if (on_stack(info, addr, len))
+		return true;
+
+	return !get_stack_info(addr, state->task, info) &&
+		on_stack(info, addr, len);
+}
+
+unsigned long unwind_get_return_address(struct unwind_state *state)
+{
+	return __unwind_get_return_address(state);
+}
+EXPORT_SYMBOL_GPL(unwind_get_return_address);
+
+void unwind_start(struct unwind_state *state, struct task_struct *task,
+		    struct pt_regs *regs)
+{
+	__unwind_start(state, task, regs);
+	if (!unwind_done(state) && !__kernel_text_address(state->pc))
+		unwind_next_frame(state);
+}
+EXPORT_SYMBOL_GPL(unwind_start);
+
+
+static bool is_entry_func(unsigned long addr)
+{
+	extern u32 kernel_entry;
+	extern u32 kernel_entry_end;
+
+	return addr >= (unsigned long)&kernel_entry &&
+		addr < (unsigned long)&kernel_entry_end;
+}
+
+static inline unsigned long bt_address(unsigned long ra)
+{
+	extern unsigned long eentry;
+
+	if (__kernel_text_address(ra))
+		return ra;
+
+	/* We are in preempt_disable() here */
+	if (__module_text_address(ra))
+		return ra;
+
+	if (ra >= eentry && ra < eentry +  EXCCODE_INT_END * VECSIZE) {
+		unsigned long type = (ra - eentry) / VECSIZE;
+		unsigned long offset = (ra - eentry) % VECSIZE;
+		unsigned long func;
+
+		switch (type) {
+		case EXCCODE_TLBL:
+		case EXCCODE_TLBI:
+			func = (unsigned long)handle_tlb_load;
+			break;
+		case EXCCODE_TLBS:
+			func = (unsigned long)handle_tlb_store;
+			break;
+		case EXCCODE_TLBM:
+			func = (unsigned long)handle_tlb_modify;
+			break;
+		case EXCCODE_TLBNR:
+		case EXCCODE_TLBNX:
+		case EXCCODE_TLBPE:
+			func = (unsigned long)handle_tlb_protect;
+			break;
+		case EXCCODE_ADE:
+			func = (unsigned long)handle_ade;
+			break;
+		case EXCCODE_ALE:
+			func = (unsigned long)handle_ale;
+			break;
+		case EXCCODE_SYS:
+			func = (unsigned long)handle_sys;
+			break;
+		case EXCCODE_BP:
+			func = (unsigned long)handle_bp;
+			break;
+		case EXCCODE_INE:
+		case EXCCODE_IPE:
+			func = (unsigned long)handle_ri;
+			break;
+		case EXCCODE_FPDIS:
+			func = (unsigned long)handle_fpu;
+			break;
+		case EXCCODE_LSXDIS:
+			func = (unsigned long)handle_lsx;
+			break;
+		case EXCCODE_LASXDIS:
+			func = (unsigned long)handle_lasx;
+			break;
+		case EXCCODE_FPE:
+			func = (unsigned long)handle_fpe;
+			break;
+		case EXCCODE_BTDIS:
+			func = (unsigned long)handle_lbt;
+			break;
+		case EXCCODE_WATCH:
+			func = (unsigned long)handle_watch;
+			break;
+		case EXCCODE_INT_START ... EXCCODE_INT_END - 1:
+			func = (unsigned long)handle_vint;
+			break;
+		default:
+
+			func = (unsigned long)handle_reserved;
+			break;
+		}
+
+		return func + offset;
+	}
+
+	return ra;
+}
+
+bool unwind_next_frame(struct unwind_state *state)
+{
+	struct stack_info *info = &state->stack_info;
+	struct orc_entry *orc;
+	struct pt_regs *regs;
+	unsigned long *p, pc;
+
+	if (unwind_done(state))
+		return false;
+
+	/* Don't let modules unload while we're reading their ORC data. */
+	preempt_disable();
+
+	if (is_entry_func(state->pc))
+		goto end;
+
+	orc = orc_find(state->pc);
+	if (!orc) {
+		orc = &orc_fp_entry;
+		state->error = true;
+	}
+
+	switch (orc->sp_reg) {
+	case ORC_REG_SP:
+		state->sp = state->sp + orc->sp_offset;
+		break;
+	case ORC_REG_BP:
+		state->sp = state->fp;
+		break;
+	default:
+		orc_warn("unknown SP base reg %d at %pB\n",
+			orc->sp_reg, (void *)state->pc);
+		goto err;
+	}
+
+	switch (orc->bp_reg) {
+	case ORC_REG_PREV_SP:
+		p = (unsigned long *)(state->sp + orc->bp_offset);
+		if (!stack_access_ok(state, (unsigned long)p, sizeof(unsigned long)))
+			goto err;
+
+		state->fp = *p;
+		break;
+	case ORC_REG_UNDEFINED:
+		/* Nothing. */
+		break;
+	default:
+		orc_warn("unknown FP base reg %d at %pB\n",
+			orc->bp_reg, (void *)state->pc);
+		goto err;
+	}
+
+	switch (orc->type) {
+	case UNWIND_HINT_TYPE_CALL:
+		if (orc->ra_reg == ORC_REG_PREV_SP) {
+			p = (unsigned long *)(state->sp + orc->ra_offset);
+			if (!stack_access_ok(state, (unsigned long)p, sizeof(unsigned long)))
+				goto err;
+
+			pc = unwind_graph_addr(state, *p, state->sp);
+			pc -= LOONGARCH_INSN_SIZE;
+		} else if (orc->ra_reg == ORC_REG_UNDEFINED) {
+			if (!state->ra || state->ra == state->pc)
+				goto err;
+
+			pc = unwind_graph_addr(state, state->ra, state->sp);
+			pc -=  LOONGARCH_INSN_SIZE;
+			state->ra = 0;
+		} else {
+			orc_warn("unknown ra base reg %d at %pB\n",
+				orc->ra_reg, (void *)state->pc);
+			goto err;
+		}
+		break;
+	case UNWIND_HINT_TYPE_REGS:
+		if (state->stack_info.type == STACK_TYPE_IRQ && state->sp == info->end)
+			regs = (struct pt_regs *)info->next_sp;
+		else
+			regs = (struct pt_regs *)state->sp;
+
+		if (!stack_access_ok(state, (unsigned long)regs, sizeof(*regs)))
+			goto err;
+
+		if ((info->end == (unsigned long)regs + sizeof(*regs)) &&
+		    !regs->regs[3] && !regs->regs[1])
+			goto end;
+
+		if (user_mode(regs))
+			goto end;
+
+		pc = regs->csr_era;
+		if (!__kernel_text_address(pc))
+			goto err;
+
+		state->sp = regs->regs[3];
+		state->ra = regs->regs[1];
+		state->fp = regs->regs[22];
+		get_stack_info(state->sp, state->task, info);
+
+		break;
+	default:
+		orc_warn("unknown .orc_unwind entry type %d at %pB\n",
+			 orc->type, (void *)state->pc);
+		goto err;
+	}
+
+	state->pc = bt_address(pc);
+	if (!state->pc) {
+		pr_err("cannot find unwind pc at %pK\n", (void *)pc);
+		goto err;
+	}
+
+	if (!__kernel_text_address(state->pc))
+		goto err;
+
+	preempt_enable();
+	return true;
+
+err:
+	state->error = true;
+
+end:
+	preempt_enable();
+	state->stack_info.type = STACK_TYPE_UNKNOWN;
+	return false;
+}
+EXPORT_SYMBOL_GPL(unwind_next_frame);
diff --git a/arch/loongarch/kernel/vmlinux.lds.S b/arch/loongarch/kernel/vmlinux.lds.S
index 0c7b041be9d8..ca19b83a2c8b 100644
--- a/arch/loongarch/kernel/vmlinux.lds.S
+++ b/arch/loongarch/kernel/vmlinux.lds.S
@@ -13,6 +13,7 @@
 #define BSS_FIRST_SECTIONS *(.bss..swapper_pg_dir)
 
 #include <asm-generic/vmlinux.lds.h>
+#include <asm-generic/orc_lookup.h>
 #include "image-vars.h"
 
 /*
@@ -74,6 +75,8 @@ SECTIONS
 	}
 #endif
 
+	ORC_UNWIND_TABLE
+
 	.got : ALIGN(16) { *(.got) }
 	.plt : ALIGN(16) { *(.plt) }
 	.got.plt : ALIGN(16) { *(.got.plt) }
-- 
2.39.2

