Return-Path: <live-patching+bounces-542-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 06A4396927A
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 06:01:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 856801F23715
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 04:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38B281CFECC;
	Tue,  3 Sep 2024 04:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OUqqo7Uy"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115281CFEBB;
	Tue,  3 Sep 2024 04:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725336034; cv=none; b=m7S1rA0gY5DdvqEIilQWqGQKiYIQF2f6+0Y8yAVE4z84IhIrsFCF7ZZyvecQ6Hv1zVlv9RGOfVKnh3NfZsnnOzhvphYzh6IcWcISG6oTqYmMBdijMOxz0b2wCsxgkHomvgz4MEnRlXw5iJs/jmp/Nd1uffs9ddZkb0X8/F0BfBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725336034; c=relaxed/simple;
	bh=hOnZJQAIf7DMQw4XeYc5i9YjThTL4d34Ct/XPnL/qk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGV/Yw/cDMZdvM8koqUXuOJAGzc238Zqj/vGwbT/6ABWU1m6cRWk0I19Jwix1ZJZQbjgaGxfjVDDBtHTONXGgeaCMMY7I252hLIOOzsVCAV1jEOVUAcwEgX0bJApdwrIf9yhe255CiEQFNBSWoaARjpExw+0PsxdauNwh/RdK4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OUqqo7Uy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C87EC4CED0;
	Tue,  3 Sep 2024 04:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725336033;
	bh=hOnZJQAIf7DMQw4XeYc5i9YjThTL4d34Ct/XPnL/qk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUqqo7UyX0Vrh5wpavxgKqfl3R2LyrgGZ1yhtNDnPoLAqMbmyO2yM34BAW9zRsZ0V
	 uP0KWte615CepuEs9mk/+nyezt9G1PlbImt8k1fSjHjlG0OvhKK39WK7ZIEcd9JETM
	 Hsz5P/pln5XDg+9S+8cbYyHBQzwJ176M4KjVXAR+WdelHXb5MfR5hh2gy8sZAn5LFO
	 q+HkWN9J5xnkuX20B5gsMnIT1AWszAbxqGxDYqZxGB7Ndnplj6feB4rP3G4bnY6qHg
	 L0ILSISsD/PnbYS/K9arnm+eOwkZgkybkky75E/qfruUhgkWU75oe8t/g5uEwMLacp
	 z7BOKccYJ8tgQ==
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: live-patching@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: [RFC 09/31] objtool: Const string cleanup
Date: Mon,  2 Sep 2024 20:59:52 -0700
Message-ID: <d0dd2ba346caaa57394d4b13949e107b61b742cf.1725334260.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725334260.git.jpoimboe@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
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
index aee479d2191c..ef09996c772e 100644
--- a/tools/objtool/arch/loongarch/decode.c
+++ b/tools/objtool/arch/loongarch/decode.c
@@ -10,7 +10,7 @@
 #define EM_LOONGARCH	258
 #endif
 
-int arch_ftrace_match(char *name)
+int arch_ftrace_match(const char *name)
 {
 	return !strcmp(name, "_mcount");
 }
diff --git a/tools/objtool/arch/powerpc/decode.c b/tools/objtool/arch/powerpc/decode.c
index 53b55690f320..29e05ad1b8b6 100644
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
index 3a1d80a7878d..1b24b05eff09 100644
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
index 3d27983dc908..b42ee4ef7015 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -814,7 +814,7 @@ elf_create_section_symbol(struct elf *elf, struct section *sec)
 	return sym;
 }
 
-static int elf_add_string(struct elf *elf, struct section *strtab, char *str);
+static int elf_add_string(struct elf *elf, struct section *strtab, const char *str);
 
 struct symbol *
 elf_create_prefix_symbol(struct elf *elf, struct symbol *orig, long size)
@@ -1048,7 +1048,7 @@ struct elf *elf_open_read(const char *name, int flags)
 	return NULL;
 }
 
-static int elf_add_string(struct elf *elf, struct section *strtab, char *str)
+static int elf_add_string(struct elf *elf, struct section *strtab, const char *str)
 {
 	Elf_Data *data;
 	Elf_Scn *s;
@@ -1073,7 +1073,7 @@ static int elf_add_string(struct elf *elf, struct section *strtab, char *str)
 		return -1;
 	}
 
-	data->d_buf = str;
+	data->d_buf = strdup(str);
 	data->d_size = strlen(str) + 1;
 	data->d_align = 1;
 
diff --git a/tools/objtool/include/objtool/arch.h b/tools/objtool/include/objtool/arch.h
index 0b303eba660e..f48f5109abb1 100644
--- a/tools/objtool/include/objtool/arch.h
+++ b/tools/objtool/include/objtool/arch.h
@@ -69,7 +69,7 @@ struct stack_op {
 
 struct instruction;
 
-int arch_ftrace_match(char *name);
+int arch_ftrace_match(const char *name);
 
 void arch_initial_func_cfi_state(struct cfi_init_state *state);
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 2b8a69de4db8..a027fc34d605 100644
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
@@ -84,7 +84,7 @@ struct elf {
 	GElf_Ehdr ehdr;
 	int fd;
 	bool changed;
-	char *name;
+	const char *name;
 	unsigned int num_files;
 	struct list_head sections;
 	unsigned long num_relocs;
-- 
2.45.2


