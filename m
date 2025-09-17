Return-Path: <live-patching+bounces-1679-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2723B80DA0
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:08:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 743013AEEDE
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7C373002AF;
	Wed, 17 Sep 2025 16:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d1/Ik75i"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BEE3002A1;
	Wed, 17 Sep 2025 16:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125073; cv=none; b=kRri3gQX3X7qlyUkzDf9HtaSBG7D9y637yoHXE7ZKcApCsK/VaKjBr3yZjEAOea2ogHgOAPpUqEl9xyM2c/KbqXbaxI/DFC9O19BK7kMlMYuVMirIzGcVnEl1MGyIGbDfqfwovhUC8cunhvAN/ESNiJXMa8o6V5tXj7jLzJxhmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125073; c=relaxed/simple;
	bh=ZThyuj0Z0x55UTEFu74FWWZsr/C5qTZVWLaw6vk2Et8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UBG+eIR7Kb+kA8pnR55qGKvhw89+IRDA2KtajGko17OmLyhuLxu3QSO2WJpZVMA1jaK6jtEz1iHyh/rmDHNjRbf0iMXo6J5YFbC5ZNgu2cjRFJZtKpHKC9qxeUC+3WyNyagRDkM6Uk8jFUH96jblj5UbXr62kKjaJuFo7AIKFQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d1/Ik75i; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DC0C4CEE7;
	Wed, 17 Sep 2025 16:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125073;
	bh=ZThyuj0Z0x55UTEFu74FWWZsr/C5qTZVWLaw6vk2Et8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1/Ik75i9LamPf0rM1SnT88B90L87sUmlVdEQXREEHbsdKod5e9Jso5hIIoaIdm2X
	 ns9x9X6bnVMhXGCjPVFdLlbp4ZYPdqXJy/Yk7OyIg9tswTpobIMSz7+0TuObWLHSnn
	 9gllErCYIQPXfqszsMT2Pw0pLe/1KktLo7u+SeCoi3i+uEX34L5+7QHtw3LPXMuSgg
	 MBUdFBbUq21Creax5hqN43+3zozazC13blRn8VoRhXO2i0CvWr/4mOC0/0Y3XWyBx3
	 mqhB0wu556HP8bROWzp6Q+N1lX9FUAXLCdigxmXxylf4EsytIGgXpInTM+uoDgMZM/
	 U6V2RMdahyQAg==
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
	Puranjay Mohan <puranjay@kernel.org>,
	Dylan Hatch <dylanbhatch@google.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH v4 24/63] objtool: Const string cleanup
Date: Wed, 17 Sep 2025 09:03:32 -0700
Message-ID: <0c4bf64e8c5bfcc9ffb1f6bcfdb7db66596aee4b.1758067943.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <cover.1758067942.git.jpoimboe@kernel.org>
References: <cover.1758067942.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use 'const char *' where applicable.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/arch/loongarch/decode.c | 2 +-
 tools/objtool/arch/powerpc/decode.c   | 2 +-
 tools/objtool/arch/x86/decode.c       | 2 +-
 tools/objtool/elf.c                   | 6 +++---
 tools/objtool/include/objtool/arch.h  | 2 +-
 tools/objtool/include/objtool/elf.h   | 6 +++---
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/objtool/arch/loongarch/decode.c b/tools/objtool/arch/loongarch/decode.c
index 330671d88c590..7b38718d782a7 100644
--- a/tools/objtool/arch/loongarch/decode.c
+++ b/tools/objtool/arch/loongarch/decode.c
@@ -7,7 +7,7 @@
 #include <linux/objtool_types.h>
 #include <arch/elf.h>
 
-int arch_ftrace_match(char *name)
+int arch_ftrace_match(const char *name)
 {
 	return !strcmp(name, "_mcount");
 }
diff --git a/tools/objtool/arch/powerpc/decode.c b/tools/objtool/arch/powerpc/decode.c
index 9b17885e6cba6..d4cb02120a6bd 100644
--- a/tools/objtool/arch/powerpc/decode.c
+++ b/tools/objtool/arch/powerpc/decode.c
@@ -9,7 +9,7 @@
 #include <objtool/builtin.h>
 #include <objtool/endianness.h>
 
-int arch_ftrace_match(char *name)
+int arch_ftrace_match(const char *name)
 {
 	return !strcmp(name, "_mcount");
 }
diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index b10200cc50c99..6bb46d9981533 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -23,7 +23,7 @@
 #include <objtool/builtin.h>
 #include <arch/elf.h>
 
-int arch_ftrace_match(char *name)
+int arch_ftrace_match(const char *name)
 {
 	return !strcmp(name, "__fentry__");
 }
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index d7fb3d0b05cf1..2ea6d591c3c29 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -853,7 +853,7 @@ elf_create_section_symbol(struct elf *elf, struct section *sec)
 	return sym;
 }
 
-static int elf_add_string(struct elf *elf, struct section *strtab, char *str);
+static int elf_add_string(struct elf *elf, struct section *strtab, const char *str);
 
 struct symbol *
 elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, long size)
@@ -1086,7 +1086,7 @@ struct elf *elf_open_read(const char *name, int flags)
 	return NULL;
 }
 
-static int elf_add_string(struct elf *elf, struct section *strtab, char *str)
+static int elf_add_string(struct elf *elf, struct section *strtab, const char *str)
 {
 	Elf_Data *data;
 	Elf_Scn *s;
@@ -1111,7 +1111,7 @@ static int elf_add_string(struct elf *elf, struct section *strtab, char *str)
 		return -1;
 	}
 
-	data->d_buf = str;
+	data->d_buf = strdup(str);
 	data->d_size = strlen(str) + 1;
 	data->d_align = 1;
 
diff --git a/tools/objtool/include/objtool/arch.h b/tools/objtool/include/objtool/arch.h
index 68664625a4671..a4502947307a4 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -71,7 +71,7 @@ struct stack_op {
 
 struct instruction;
 
-int arch_ftrace_match(char *name);
+int arch_ftrace_match(const char *name);
 
 void arch_initial_func_cfi_state(struct cfi_init_state *state);
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index df8434d3b7440..74ce454790f4d 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -40,7 +40,7 @@ struct section {
 	struct section *base, *rsec;
 	struct symbol *sym;
 	Elf_Data *data;
-	char *name;
+	const char *name;
 	int idx;
 	bool _changed, text, rodata, noinstr, init, truncate;
 	struct reloc *relocs;
@@ -53,7 +53,7 @@ struct symbol {
 	struct elf_hash_node name_hash;
 	GElf_Sym sym;
 	struct section *sec;
-	char *name;
+	const char *name;
 	unsigned int idx, len;
 	unsigned long offset;
 	unsigned long __subtree_last;
@@ -88,7 +88,7 @@ struct elf {
 	GElf_Ehdr ehdr;
 	int fd;
 	bool changed;
-	char *name;
+	const char *name;
 	unsigned int num_files;
 	struct list_head sections;
 	unsigned long num_relocs;
-- 
2.50.0


