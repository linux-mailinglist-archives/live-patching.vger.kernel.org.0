Return-Path: <live-patching+bounces-1699-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BFA93B80E7B
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 562D32A2ACE
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D348336206D;
	Wed, 17 Sep 2025 16:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EthIHSoW"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94A635CEC9;
	Wed, 17 Sep 2025 16:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125087; cv=none; b=XHuMRoO977i4bmd6zOoMuVy51dyjnDpQY8eXeViWULTQHeFfcooeV8PBqmVU/JGsbMYKEQeMKMtXEOxxRM0N0aKR0a76GuE7jPh6aa14kdIYueBLbY19K+bU1sDl/6kGDbdkgTehroITlF3mWuNpJQk9Phx8DOYbNoKmFvoXLlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125087; c=relaxed/simple;
	bh=XG/neY8Lsx5tZNRrMqxY/hqrjdtRd2zrKN4ICcu3A7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I/I9ZwtCqJMSyluO+RhZ0cOk1UrgxsPeEip1Ct8x7HLDVst36KcW2vVVd1MEjVCkSkyasjcYbY+xHfL3Ubcemv3EEHQLKb6/HlxcVpRKoNleeiaJ7wHvUGd/3+vm3nfA9Df9JI5dRn1B5ex2OEMPAFXtjRvj547YjOY8abdHOnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EthIHSoW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049E1C4CEFB;
	Wed, 17 Sep 2025 16:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125087;
	bh=XG/neY8Lsx5tZNRrMqxY/hqrjdtRd2zrKN4ICcu3A7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EthIHSoWcTz60z/SG3nBzxWABv7YIjCB7PbmHS1Lkt/FmUpQFBHYKqzwWyeggvnHl
	 Lekc8hPRoLET+xrMeNX9/wupLtDzuMFxhaglXUTItIZrM9HA1H1QW9TVaavV6FuB0L
	 erMJxl0QpIUMM58bnOgZD7jkPwziKzYi+Rkv4ijNujMCteOZjbeKw6fMh6H1KukWmU
	 rfzsOQ7oLsSEY1AI86MQAyXATq7JnU9EhLyXn+VqnCC/QQlAuszvxq5+cy+z/I/HeZ
	 UPqov1+rIcZZBcEGQHEV7YRsB7RhhuOcsSQBzWBXTyoBAvnR3NQEQGSgiDHTslyh/R
	 oGDZjPdtsQR9w==
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
Subject: [PATCH v4 44/63] objtool: Add annotype() helper
Date: Wed, 17 Sep 2025 09:03:52 -0700
Message-ID: <6575e76e737521d3ff352dc9867613f33abd3116.1758067943.git.jpoimboe@kernel.org>
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

... for reading annotation types.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/arch/loongarch/orc.c         |  1 -
 tools/objtool/arch/powerpc/decode.c        |  1 -
 tools/objtool/arch/x86/decode.c            |  1 -
 tools/objtool/arch/x86/orc.c               |  1 -
 tools/objtool/check.c                      |  5 +----
 tools/objtool/include/objtool/elf.h        | 13 +++++++++++++
 tools/objtool/include/objtool/endianness.h |  9 ++++-----
 tools/objtool/orc_dump.c                   |  1 -
 tools/objtool/orc_gen.c                    |  1 -
 tools/objtool/special.c                    |  1 -
 10 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/tools/objtool/arch/loongarch/orc.c b/tools/objtool/arch/loongarch/orc.c
index b58c5ff443c92..ffd3a3c858ae7 100644
--- a/tools/objtool/arch/loongarch/orc.c
+++ b/tools/objtool/arch/loongarch/orc.c
@@ -5,7 +5,6 @@
 #include <objtool/check.h>
 #include <objtool/orc.h>
 #include <objtool/warn.h>
-#include <objtool/endianness.h>
 
 int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruction *insn)
 {
diff --git a/tools/objtool/arch/powerpc/decode.c b/tools/objtool/arch/powerpc/decode.c
index d4cb02120a6bd..3a9b748216edc 100644
--- a/tools/objtool/arch/powerpc/decode.c
+++ b/tools/objtool/arch/powerpc/decode.c
@@ -7,7 +7,6 @@
 #include <objtool/arch.h>
 #include <objtool/warn.h>
 #include <objtool/builtin.h>
-#include <objtool/endianness.h>
 
 int arch_ftrace_match(const char *name)
 {
diff --git a/tools/objtool/arch/x86/decode.c b/tools/objtool/arch/x86/decode.c
index 6bb46d9981533..b2c320f701f94 100644
--- a/tools/objtool/arch/x86/decode.c
+++ b/tools/objtool/arch/x86/decode.c
@@ -19,7 +19,6 @@
 #include <objtool/elf.h>
 #include <objtool/arch.h>
 #include <objtool/warn.h>
-#include <objtool/endianness.h>
 #include <objtool/builtin.h>
 #include <arch/elf.h>
 
diff --git a/tools/objtool/arch/x86/orc.c b/tools/objtool/arch/x86/orc.c
index 7176b9ec5b058..735e150ca6b73 100644
--- a/tools/objtool/arch/x86/orc.c
+++ b/tools/objtool/arch/x86/orc.c
@@ -5,7 +5,6 @@
 #include <objtool/check.h>
 #include <objtool/orc.h>
 #include <objtool/warn.h>
-#include <objtool/endianness.h>
 
 int init_orc_entry(struct orc_entry *orc, struct cfi_state *cfi, struct instruction *insn)
 {
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 6d21b83b9377a..969a61766f4a6 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -14,7 +14,6 @@
 #include <objtool/check.h>
 #include <objtool/special.h>
 #include <objtool/warn.h>
-#include <objtool/endianness.h>
 
 #include <linux/objtool_types.h>
 #include <linux/hashtable.h>
@@ -2273,9 +2272,7 @@ static int read_annotate(struct objtool_file *file,
 	}
 
 	for_each_reloc(sec->rsec, reloc) {
-		type = *(u32 *)(sec->data->d_buf + (reloc_idx(reloc) * sec->sh.sh_entsize) + 4);
-		type = bswap_if_needed(file->elf, type);
-
+		type = annotype(file->elf, sec, reloc);
 		offset = reloc->sym->offset + reloc_addend(reloc);
 		insn = find_insn(file, reloc->sym->sec, offset);
 
diff --git a/tools/objtool/include/objtool/elf.h b/tools/objtool/include/objtool/elf.h
index 9f135c262659e..814cfc0bbf16b 100644
--- a/tools/objtool/include/objtool/elf.h
+++ b/tools/objtool/include/objtool/elf.h
@@ -13,10 +13,14 @@
 #include <linux/hashtable.h>
 #include <linux/rbtree.h>
 #include <linux/jhash.h>
+
+#include <objtool/endianness.h>
 #include <arch/elf.h>
 
 #define SYM_NAME_LEN		512
 
+#define bswap_if_needed(elf, val) __bswap_if_needed(&elf->ehdr, val)
+
 #ifdef LIBELF_USE_DEPRECATED
 # define elf_getshdrnum    elf_getshnum
 # define elf_getshdrstrndx elf_getshstrndx
@@ -401,6 +405,15 @@ static inline void set_reloc_type(struct elf *elf, struct reloc *reloc, unsigned
 	mark_sec_changed(elf, reloc->sec, true);
 }
 
+static inline unsigned int annotype(struct elf *elf, struct section *sec,
+				    struct reloc *reloc)
+{
+	unsigned int type;
+
+	type = *(u32 *)(sec->data->d_buf + (reloc_idx(reloc) * 8) + 4);
+	return bswap_if_needed(elf, type);
+}
+
 #define RELOC_JUMP_TABLE_BIT 1UL
 
 /* Does reloc mark the beginning of a jump table? */
diff --git a/tools/objtool/include/objtool/endianness.h b/tools/objtool/include/objtool/endianness.h
index 4d2aa9b0fe2fd..aebcd23386685 100644
--- a/tools/objtool/include/objtool/endianness.h
+++ b/tools/objtool/include/objtool/endianness.h
@@ -4,7 +4,6 @@
 
 #include <linux/kernel.h>
 #include <endian.h>
-#include <objtool/elf.h>
 
 /*
  * Does a byte swap if target file endianness doesn't match the host, i.e. cross
@@ -12,16 +11,16 @@
  * To be used for multi-byte values conversion, which are read from / about
  * to be written to a target native endianness ELF file.
  */
-static inline bool need_bswap(struct elf *elf)
+static inline bool need_bswap(GElf_Ehdr *ehdr)
 {
 	return (__BYTE_ORDER == __LITTLE_ENDIAN) ^
-	       (elf->ehdr.e_ident[EI_DATA] == ELFDATA2LSB);
+	       (ehdr->e_ident[EI_DATA] == ELFDATA2LSB);
 }
 
-#define bswap_if_needed(elf, val)					\
+#define __bswap_if_needed(ehdr, val)					\
 ({									\
 	__typeof__(val) __ret;						\
-	bool __need_bswap = need_bswap(elf);				\
+	bool __need_bswap = need_bswap(ehdr);				\
 	switch (sizeof(val)) {						\
 	case 8:								\
 		__ret = __need_bswap ? bswap_64(val) : (val); break;	\
diff --git a/tools/objtool/orc_dump.c b/tools/objtool/orc_dump.c
index 1dd9fc18fe624..5a979f52425ab 100644
--- a/tools/objtool/orc_dump.c
+++ b/tools/objtool/orc_dump.c
@@ -8,7 +8,6 @@
 #include <objtool/objtool.h>
 #include <objtool/orc.h>
 #include <objtool/warn.h>
-#include <objtool/endianness.h>
 
 int orc_dump(const char *filename)
 {
diff --git a/tools/objtool/orc_gen.c b/tools/objtool/orc_gen.c
index 9d380abc2ed35..1045e1380ffde 100644
--- a/tools/objtool/orc_gen.c
+++ b/tools/objtool/orc_gen.c
@@ -12,7 +12,6 @@
 #include <objtool/check.h>
 #include <objtool/orc.h>
 #include <objtool/warn.h>
-#include <objtool/endianness.h>
 
 struct orc_list_entry {
 	struct list_head list;
diff --git a/tools/objtool/special.c b/tools/objtool/special.c
index fc2cf8dba1c03..e262af9171436 100644
--- a/tools/objtool/special.c
+++ b/tools/objtool/special.c
@@ -15,7 +15,6 @@
 #include <objtool/builtin.h>
 #include <objtool/special.h>
 #include <objtool/warn.h>
-#include <objtool/endianness.h>
 
 struct special_entry {
 	const char *sec;
-- 
2.50.0


