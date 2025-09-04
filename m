Return-Path: <live-patching+bounces-1622-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A2B72B42FBE
	for <lists+live-patching@lfdr.de>; Thu,  4 Sep 2025 04:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E00D3B4701
	for <lists+live-patching@lfdr.de>; Thu,  4 Sep 2025 02:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1CB1145B27;
	Thu,  4 Sep 2025 02:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W8g0N0sR"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077EE18B12
	for <live-patching@vger.kernel.org>; Thu,  4 Sep 2025 02:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756953020; cv=none; b=f+LTznW/iHumKg4LuUKgahel8akTCAHglGLUinE26+4MzcAjVRe4oIbz1dxVVK8fq01fkCEdmdycEE3sOuyvuDuYWgJ0ua2T6H+eQchUPT6LLV0iEyoBht/QlTGW5n6/SWIuo8ck3rwyqez+OwdRJxqZrs0DnSpvwFjQmkaXkls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756953020; c=relaxed/simple;
	bh=c1ysbv7gn5eOCV5DUXAoPjY1JOp3vgQi7PfrZtOqnRo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=H+xpRkdBG2U46SZvMVi9aYAiDLPxb7+wkoeNDCA3HQGgpvDjchULEjjH1i6zfY7WKSNpgrqDLTWZ+mNnenqLEIZZOsQbz0dFDUY5HXYH9pJfaLlfsV9qQa2l5t3LWR9jq0q3Y4v4jqt+iw4vq1Ycn8N/AQH2W9WJvmc+kUMyU80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W8g0N0sR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756953017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=d9d0qR7kdpBDGnSSt5NKtI3LOAZpt19g7mKuK9CIaxI=;
	b=W8g0N0sRkS2ICM4tzmhcV7VBTXZMULFf5T3HHFYi3ga/uEfsqC+OO4w+VSTul/daWYLOCW
	u4miSVgxyOhnQ/yL1fUAi3qtO/2npPJF1Z5NffOGQfQiAMGHZptdbyAD22/NJ5aeBUwjn/
	6bF+QgQqdUZubdqrisFWR0bAZ2wgBlk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-156-P5Dsf6L0PKCxL2PHZBzv7w-1; Wed,
 03 Sep 2025 22:30:10 -0400
X-MC-Unique: P5Dsf6L0PKCxL2PHZBzv7w-1
X-Mimecast-MFC-AGG-ID: P5Dsf6L0PKCxL2PHZBzv7w_1756953006
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 78B94180048E;
	Thu,  4 Sep 2025 02:30:05 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.64.201])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A118A1800446;
	Thu,  4 Sep 2025 02:30:03 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: linuxppc-dev@lists.ozlabs.org,
	live-patching@vger.kernel.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>
Subject: [PATCH] powerpc64/modules: fix ool-ftrace-stub vs. livepatch relocation corruption
Date: Wed,  3 Sep 2025 22:29:50 -0400
Message-ID: <20250904022950.3004112-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

The powerpc64 module .stubs section holds ppc64_stub_entry[] code
trampolines that are generated at module load time. These stubs are
necessary for function calls to external symbols that are too far away
for a simple relative branch.

Logic for finding an available ppc64_stub_entry has relied on a sentinel
value in the funcdata member to indicate a used slot. Code iterates
through the array, inspecting .funcdata to find the first unused (zeroed)
entry:

  for (i = 0; stub_func_addr(stubs[i].funcdata); i++)

To support CONFIG_PPC_FTRACE_OUT_OF_LINE, a new setup_ftrace_ool_stubs()
function extended the .stubs section by adding an array of
ftrace_ool_stub structures for each patchable function. A side effect
of writing these smaller structures is that the funcdata sentinel
convention is not maintained. This is not a problem for an ordinary
kernel module, as this occurs in module_finalize(), after which no
further .stubs updates are needed.

However, when loading a livepatch module that contains klp-relocations,
apply_relocate_add() is executed a second time, after the out-of-line
ftrace stubs have been set up.

When apply_relocate_add() then calls stub_for_addr() to handle a
klp-relocation, its search for the next available ppc64_stub_entry[]
slot may stop prematurely in the middle of the ftrace_ool_stub array. A
full ppc64_stub_entry is then written, corrupting the ftrace stubs.

Fix this by explicitly tracking the count of used ppc64_stub_entrys.
Rather than relying on an inline funcdata sentinel value, a new
stub_count is used as the explicit boundary for searching and allocating
stubs. This simplifies the code, eliminates the "one extra reloc" that
was required for the sentinel check, and resolves the memory corruption.

Fixes: eec37961a56a ("powerpc64/ftrace: Move ftrace sequence out of line")
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 arch/powerpc/include/asm/module.h |  1 +
 arch/powerpc/kernel/module_64.c   | 26 ++++++++------------------
 2 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/include/asm/module.h b/arch/powerpc/include/asm/module.h
index e1ee5026ac4a..864e22deaa2c 100644
--- a/arch/powerpc/include/asm/module.h
+++ b/arch/powerpc/include/asm/module.h
@@ -27,6 +27,7 @@ struct ppc_plt_entry {
 struct mod_arch_specific {
 #ifdef __powerpc64__
 	unsigned int stubs_section;	/* Index of stubs section in module */
+	unsigned int stub_count;	/* Number of stubs used */
 #ifdef CONFIG_PPC_KERNEL_PCREL
 	unsigned int got_section;	/* What section is the GOT? */
 	unsigned int pcpu_section;	/* .data..percpu section */
diff --git a/arch/powerpc/kernel/module_64.c b/arch/powerpc/kernel/module_64.c
index 126bf3b06ab7..2a44bc8e2439 100644
--- a/arch/powerpc/kernel/module_64.c
+++ b/arch/powerpc/kernel/module_64.c
@@ -209,8 +209,7 @@ static unsigned long get_stubs_size(const Elf64_Ehdr *hdr,
 				    char *secstrings,
 				    struct module *me)
 {
-	/* One extra reloc so it's always 0-addr terminated */
-	unsigned long relocs = 1;
+	unsigned long relocs = 0;
 	unsigned i;
 
 	/* Every relocated section... */
@@ -705,7 +704,7 @@ static unsigned long stub_for_addr(const Elf64_Shdr *sechdrs,
 
 	/* Find this stub, or if that fails, the next avail. entry */
 	stubs = (void *)sechdrs[me->arch.stubs_section].sh_addr;
-	for (i = 0; stub_func_addr(stubs[i].funcdata); i++) {
+	for (i = 0; i < me->arch.stub_count; i++) {
 		if (WARN_ON(i >= num_stubs))
 			return 0;
 
@@ -716,6 +715,7 @@ static unsigned long stub_for_addr(const Elf64_Shdr *sechdrs,
 	if (!create_stub(sechdrs, &stubs[i], addr, me, name))
 		return 0;
 
+	me->arch.stub_count++;
 	return (unsigned long)&stubs[i];
 }
 
@@ -1118,29 +1118,19 @@ int module_trampoline_target(struct module *mod, unsigned long addr,
 static int setup_ftrace_ool_stubs(const Elf64_Shdr *sechdrs, unsigned long addr, struct module *me)
 {
 #ifdef CONFIG_PPC_FTRACE_OUT_OF_LINE
-	unsigned int i, total_stubs, num_stubs;
+	unsigned int total_stubs, num_stubs;
 	struct ppc64_stub_entry *stub;
 
 	total_stubs = sechdrs[me->arch.stubs_section].sh_size / sizeof(*stub);
 	num_stubs = roundup(me->arch.ool_stub_count * sizeof(struct ftrace_ool_stub),
 			    sizeof(struct ppc64_stub_entry)) / sizeof(struct ppc64_stub_entry);
 
-	/* Find the next available entry */
-	stub = (void *)sechdrs[me->arch.stubs_section].sh_addr;
-	for (i = 0; stub_func_addr(stub[i].funcdata); i++)
-		if (WARN_ON(i >= total_stubs))
-			return -1;
-
-	if (WARN_ON(i + num_stubs > total_stubs))
+	if (WARN_ON(me->arch.stub_count + num_stubs > total_stubs))
 		return -1;
 
-	stub += i;
-	me->arch.ool_stubs = (struct ftrace_ool_stub *)stub;
-
-	/* reserve stubs */
-	for (i = 0; i < num_stubs; i++)
-		if (patch_u32((void *)&stub->funcdata, PPC_RAW_NOP()))
-			return -1;
+	stub = (void *)sechdrs[me->arch.stubs_section].sh_addr;
+	me->arch.ool_stubs = (struct ftrace_ool_stub *)(stub + me->arch.stub_count);
+	me->arch.stub_count += num_stubs;
 #endif
 
 	return 0;
-- 
2.50.1


