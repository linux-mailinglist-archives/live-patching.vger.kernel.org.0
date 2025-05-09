Return-Path: <live-patching+bounces-1382-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6973DAB1DF9
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 22:22:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 184A6188E4BD
	for <lists+live-patching@lfdr.de>; Fri,  9 May 2025 20:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DAC826A0E5;
	Fri,  9 May 2025 20:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q4lfrQ4s"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD77726A0CC;
	Fri,  9 May 2025 20:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746821880; cv=none; b=NbTYR0Q0PlA6DGnmN4sJhzicRfdMzWYP28sDCitPUjFqCPUsdt14XLVJbHLJ+MzY+sMI7UXfw40CC0NjhUgohh/3y8p50YjxY/pWDzlVM18rJEqz+6YN7vQoDPpD0M3we8VdbgDsSOQVXoZpMq3FjXcAbdem3+k9vzozix/ME28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746821880; c=relaxed/simple;
	bh=ATnjVeDvFHZYfIgFa9Cjs6eAsIVU/U1FXzQfK6EwYZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhpkbAqSKIi0gXoprxTR3OjGkstAhcCiwTxNlmBxWJD6TwSo46bO/SnbFGfnF+JfgLK4ITNUoN4XQa7SpsQ7TYjCkgoHnw5i8wtZLrI6wym7Bh+FKDPSnM3gxBlrJNqKsDnn/x6QTQ+h1/i0XhkoY3JKJqI+4AVTP4rxT32o7Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q4lfrQ4s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC73C4CEF0;
	Fri,  9 May 2025 20:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746821880;
	bh=ATnjVeDvFHZYfIgFa9Cjs6eAsIVU/U1FXzQfK6EwYZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q4lfrQ4sn+DkONUip8khR8lUOW1y9hSoHIu9c5VDGJJUVNgQvSKnMP2srG/rDOeDB
	 X9dIVQezhuWHks6PBRF2Sq05D+QnL/Ga+ZsdOKnb4OkPu6PFa2W9YIq73CUB+wiIAo
	 AY9EPb9WfNdw6XOOwPSEaAwkKFOrtdp+bUCiUYxHN9lohzQHssvTF+tnVyM6x2SlGP
	 ENVwTrwbHvwGSkWKtSXmFjL3OLcm60mVPn6ERF0Z2F1IHJPAHyRY5nKGjII2SRLvbS
	 WVasM5D+j30kiPLZ7gwqKYOf7usw7wEoqZcA685A+WQ3NoWpVGZvx0zVgalG5h+ALM
	 AZBKRxFvpdUSQ==
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
Subject: [PATCH v2 23/62] objtool: Clean up compiler flag usage
Date: Fri,  9 May 2025 13:16:47 -0700
Message-ID: <23a069d2e00c6b0c9305f05282bad7ea6f8bed07.1746821544.git.jpoimboe@kernel.org>
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

KBUILD_HOSTCFLAGS and KBUILD_HOSTLDFLAGS aren't defined when objtool is
built standalone.  Also, the EXTRA_WARNINGS flags are rather arbitrary.

Make things simpler and more consistent by specifying compiler flags
explicitly and tweaking the warnings.  Also make a few code tweaks to
make the new warnings happy.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
---
 tools/objtool/Makefile | 15 ++++++++++-----
 tools/objtool/check.c  |  4 ++--
 tools/objtool/elf.c    |  2 +-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index 8c20361dd100..fc82d47f2b9a 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -23,6 +23,11 @@ LIBELF_LIBS  := $(shell $(HOSTPKG_CONFIG) libelf --libs 2>/dev/null || echo -lel
 
 all: $(OBJTOOL)
 
+WARNINGS := -Werror -Wall -Wextra -Wmissing-prototypes			\
+	    -Wmissing-declarations -Wwrite-strings			\
+	    -Wno-implicit-fallthrough -Wno-sign-compare			\
+	    -Wno-unused-parameter
+
 INCLUDES := -I$(srctree)/tools/include \
 	    -I$(srctree)/tools/include/uapi \
 	    -I$(srctree)/tools/arch/$(HOSTARCH)/include/uapi \
@@ -30,11 +35,11 @@ INCLUDES := -I$(srctree)/tools/include \
 	    -I$(srctree)/tools/objtool/include \
 	    -I$(srctree)/tools/objtool/arch/$(SRCARCH)/include \
 	    -I$(LIBSUBCMD_OUTPUT)/include
-# Note, EXTRA_WARNINGS here was determined for CC and not HOSTCC, it
-# is passed here to match a legacy behavior.
-WARNINGS := $(EXTRA_WARNINGS) -Wno-switch-default -Wno-switch-enum -Wno-packed -Wno-nested-externs
-OBJTOOL_CFLAGS := -Werror $(WARNINGS) $(KBUILD_HOSTCFLAGS) -g $(INCLUDES) $(LIBELF_FLAGS)
-OBJTOOL_LDFLAGS := $(LIBELF_LIBS) $(LIBSUBCMD) $(KBUILD_HOSTLDFLAGS)
+
+OBJTOOL_CFLAGS  := -std=gnu11 -fomit-frame-pointer -O2 -g \
+		   $(WARNINGS) $(INCLUDES) $(LIBELF_FLAGS) $(HOSTCFLAGS)
+
+OBJTOOL_LDFLAGS := $(LIBSUBCMD) $(LIBELF_LIBS) $(HOSTLDFLAGS)
 
 # Allow old libelf to be used:
 elfshdr := $(shell echo '$(pound)include <libelf.h>' | $(HOSTCC) $(OBJTOOL_CFLAGS) -x c -E - 2>/dev/null | grep elf_getshdr)
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 0cdc2fc85439..5e62d3ce3cc6 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -459,7 +459,7 @@ static int decode_instructions(struct objtool_file *file)
 
 		for (offset = 0; offset < sec->sh.sh_size; offset += insn->len) {
 			if (!insns || idx == INSN_CHUNK_MAX) {
-				insns = calloc(sizeof(*insn), INSN_CHUNK_SIZE);
+				insns = calloc(INSN_CHUNK_SIZE, sizeof(*insn));
 				if (!insns) {
 					ERROR_GLIBC("calloc");
 					return -1;
@@ -608,7 +608,7 @@ static int init_pv_ops(struct objtool_file *file)
 		return 0;
 
 	nr = sym->len / sizeof(unsigned long);
-	file->pv_ops = calloc(sizeof(struct pv_state), nr);
+	file->pv_ops = calloc(nr, sizeof(struct pv_state));
 	if (!file->pv_ops) {
 		ERROR_GLIBC("calloc");
 		return -1;
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 2ea6d591c3c2..c27edeed2dd0 100644
--- a/tools/objtool/elf.c
+++ b/tools/objtool/elf.c
@@ -736,7 +736,7 @@ static int elf_update_symbol(struct elf *elf, struct section *symtab,
 	}
 
 	/* setup extended section index magic and write the symbol */
-	if ((shndx >= SHN_UNDEF && shndx < SHN_LORESERVE) || is_special_shndx) {
+	if (shndx < SHN_LORESERVE || is_special_shndx) {
 		sym->sym.st_shndx = shndx;
 		if (!shndx_data)
 			shndx = 0;
-- 
2.49.0


