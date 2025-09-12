Return-Path: <live-patching+bounces-1649-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 959B6B551B8
	for <lists+live-patching@lfdr.de>; Fri, 12 Sep 2025 16:35:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B49A58476E
	for <lists+live-patching@lfdr.de>; Fri, 12 Sep 2025 14:32:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 826D2322DC5;
	Fri, 12 Sep 2025 14:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CGBmyhhG"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE27324B05
	for <live-patching@vger.kernel.org>; Fri, 12 Sep 2025 14:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757687284; cv=none; b=JUd+4GB7bmTrGnExve+Jw57KxijGMaSqR9cJXQ1xJQ1/KTNRFmWlycJEeOGlTMXY/W7jQ0A5mkZ+8UhT43vC9R9nHhvZDRL0sgroHBEXSgjH2AmDoQtdBBAiNBp9geHo3tLhAiBcFNfJbBZOQGNplm95ekhxh6x/O+pIR/DUCsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757687284; c=relaxed/simple;
	bh=Tl6Xju4PYOiOY6ahG3QzcofUPWaEIq2cKe4TlqO3Cgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=K6/X/fYBYWz/7WRpFjMPnSXOkJfXfaJmpfiSbDwdgIvEm3REZlAGVcm0ueavvf/UVy/HFLPZ0VFe1tWLXpl8VQOa89pQHK7rmX4UWFCFdVal24jFbkPyI16rMMJiuz/tcRzH4ZqOv31SkqZesEFlNQeplq6kyVxBqaYQyicI5Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CGBmyhhG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757687281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+dEHsoW6rv9lhHPqGYaopsnJbjdZ8LscRXBGWnkIRTQ=;
	b=CGBmyhhGYIobPd+QPV0FkGPMkdwXakF3PitOZNvLa8pQt82DgNeI407YWIvdR4OKTnS5wO
	SingEW0TLYSQvRB9lha1DpsDU0aSh+w/5iSYy5CoD+N0iKJZc6uHQDwZCWSrgjjlRl0nY0
	cm9QDNNUQSZzgnrr1gQ+qVHtZPCeo7M=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-693-Kige88aJPO-f0WLa7VFVRA-1; Fri,
 12 Sep 2025 10:27:56 -0400
X-MC-Unique: Kige88aJPO-f0WLa7VFVRA-1
X-Mimecast-MFC-AGG-ID: Kige88aJPO-f0WLa7VFVRA_1757687275
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C2161800451;
	Fri, 12 Sep 2025 14:27:54 +0000 (UTC)
Received: from jolawren-thinkpadp1gen7.ibmlowe.csb (unknown [10.22.81.60])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D6C231800452;
	Fri, 12 Sep 2025 14:27:52 +0000 (UTC)
From: Joe Lawrence <joe.lawrence@redhat.com>
To: linuxppc-dev@lists.ozlabs.org,
	live-patching@vger.kernel.org
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Naveen N Rao <naveen@kernel.org>
Subject: [PATCH v2 3/3] powerpc64/modules: replace stub allocation sentinel with an explicit counter
Date: Fri, 12 Sep 2025 10:27:40 -0400
Message-ID: <20250912142740.3581368-4-joe.lawrence@redhat.com>
In-Reply-To: <20250912142740.3581368-1-joe.lawrence@redhat.com>
References: <20250912142740.3581368-1-joe.lawrence@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

The logic for allocating ppc64_stub_entry trampolines in the .stubs
section relies on an inline sentinel, where a NULL .funcdata member
indicates an available slot.

While preceding commits fixed the initialization bugs that led to ftrace
stub corruption, the sentinel-based approach remains fragile: it depends
on an implicit convention between subsystems modifying different
struct types in the same memory area.

Replace the sentinel with an explicit counter, module->arch.num_stubs.
Instead of iterating through memory to find a NULL marker, the module
loader uses this counter as the boundary for the next free slot.

This simplifies the allocation code, hardens it against future changes
to stub structures, and removes the need for an extra relocation slot
previously reserved to terminate the sentinel search.

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
index 0e45cac4de76..2a44bc8e2439 100644
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
-		if (patch_u32((void *)&stub[i].funcdata, PPC_RAW_NOP()))
-			return -1;
+	stub = (void *)sechdrs[me->arch.stubs_section].sh_addr;
+	me->arch.ool_stubs = (struct ftrace_ool_stub *)(stub + me->arch.stub_count);
+	me->arch.stub_count += num_stubs;
 #endif
 
 	return 0;
-- 
2.51.0


