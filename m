Return-Path: <live-patching+bounces-1404-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D299AB1E28
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 569C7500CC5
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0557C299922;
	Fri,  9 May 2025 20:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UNg86nmL"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8A5298CDA;
	Fri,  9 May 2025 20:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821896; cv=none; b=OUiZDbVjb7sDAjgfP/ER1S+kHw1vHTtX1aCQA9i+tsDuTHjQvaYHHuRTmgB1mwYcmXEYD0Xs+iK+Vj1G55+B/eTiQ5TUDPj09r0tgGy1QqlMl3RP6r8i0LB0tehMm9MXKvEQqlCYvqHKewrCyeWO5RhdMPyqtMgPAmbxok1U278=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821896; c=relaxed/simple;
	bh=6Zot9E6ZFT2BtM6OWN9gJxNTDDNv77MxRe5bFHgepKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAcn9OhyUd98euABADiSzwzWc91cO49HqHWIxo9oknaR++9rND1xNnw8rjur7ECkpe+/T0zVcb79nitj53Bl6VM41IRrrmWxra9z4wLETTzKFDr0x8NpyDe7CTeJjPW0ReMAU4KhuI1pAL8RH8w8FtLl5/kMlPXWXLYaQ3mpAOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UNg86nmL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 268FCC4CEEE;
	Fri,  9 May 2025 20:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821896;
	bh=6Zot9E6ZFT2BtM6OWN9gJxNTDDNv77MxRe5bFHgepKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNg86nmLthG6r8CoN0b5Hoy+IMV+rcOoY2LVGBY0MLVhZvTXH72OSyuN98z/FqVBA
	 gMwSKo1dVqlyPryIPmG6NjIs0RA20QEPuzTFUtIGqpUyoFehRtASOoDBNy61OMd4No
	 RZy5oALjNtUSPleOD8S6IitH2exh/nqq3c4CKyD3LI64ID6h7+Q1nLIaDhWqE8uVik
	 xqPoHm312cMoN4p/m3ohzxUv0wsH5qz9mgIcQaCP6fS99ejvF7PS7uh6pOpE/svjIQ
	 YYRM78Gq1vTKvV70R+tI7n3noeax6MQ5wNI6dSA3eIw5WwUAjf0u76P9n1b7/dj0n4
	 aiAUk5lFSor1g==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org,
	Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	Song Liu <song@kernel.org>,
	laokz <laokz@foxmail.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Weinan Liu <wnliu@google.com>,
	Fazla Mehrab <a.mehrab@bytedance.com>,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>
Subject: [PATCH v2 45/62] x86/extable: Define ELF section entry size for exception tables
Date: Fri,  9 May 2025 13:17:09 -0700
Message-ID: <198cfbd12e54dfce1309828e146b90b1f7b200a5.1746821544.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746821544.git.jpoimboe@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for the objtool klp diff subcommand, define the entry
size for the __ex_table section in its ELF header.  This will allow
tooling to extract individual entries.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 arch/x86/include/asm/asm.h | 20 ++++++++++++--------
 kernel/extable.c           |  2 ++
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index f963848024a5..62dff336f206 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -138,15 +138,17 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 
 # include <asm/extable_fixup_types.h>
 
+#define EXTABLE_SIZE 12
+
 /* Exception table entry */
 #ifdef __ASSEMBLER__
 
-# define _ASM_EXTABLE_TYPE(from, to, type)			\
-	.pushsection "__ex_table","a" ;				\
-	.balign 4 ;						\
-	.long (from) - . ;					\
-	.long (to) - . ;					\
-	.long type ;						\
+# define _ASM_EXTABLE_TYPE(from, to, type)				\
+	.pushsection "__ex_table", "aM", @progbits, EXTABLE_SIZE;	\
+	.balign 4 ;							\
+	.long (from) - . ;						\
+	.long (to) - . ;						\
+	.long type ;							\
 	.popsection
 
 # ifdef CONFIG_KPROBES
@@ -189,7 +191,8 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 	".purgem extable_type_reg\n"
 
 # define _ASM_EXTABLE_TYPE(from, to, type)			\
-	" .pushsection \"__ex_table\",\"a\"\n"			\
+	" .pushsection __ex_table, \"aM\", @progbits, "		\
+		       __stringify(EXTABLE_SIZE) "\n"		\
 	" .balign 4\n"						\
 	" .long (" #from ") - .\n"				\
 	" .long (" #to ") - .\n"				\
@@ -197,7 +200,8 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
 	" .popsection\n"
 
 # define _ASM_EXTABLE_TYPE_REG(from, to, type, reg)				\
-	" .pushsection \"__ex_table\",\"a\"\n"					\
+	" .pushsection __ex_table, \"aM\", @progbits, "				\
+		       __stringify(EXTABLE_SIZE) "\n"				\
 	" .balign 4\n"								\
 	" .long (" #from ") - .\n"						\
 	" .long (" #to ") - .\n"						\
diff --git a/kernel/extable.c b/kernel/extable.c
index 71f482581cab..0ae3ee2ef266 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -55,6 +55,8 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
 {
 	const struct exception_table_entry *e;
 
+	BUILD_BUG_ON(EXTABLE_SIZE != sizeof(struct exception_table_entry));
+
 	e = search_kernel_exception_table(addr);
 	if (!e)
 		e = search_module_extables(addr);
-- 
2.49.0


