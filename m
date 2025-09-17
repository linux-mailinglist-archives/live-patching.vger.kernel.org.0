Return-Path: <live-patching+bounces-1680-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D77C5B80DEB
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 18:10:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57212543968
	for <lists+live-patching@lfdr.de>; Wed, 17 Sep 2025 16:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C29F5301009;
	Wed, 17 Sep 2025 16:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BVqJ/5fA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1C33009EC;
	Wed, 17 Sep 2025 16:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758125074; cv=none; b=i4+yIX+TyCszeHXwLXhwfGeH4gVT2XrYMlKfyiObuIWO2UICNlA6Ais+EVL6oT6X5fFsn/V5oqHKK+ZftlIKAD97hIeR725xKJQ2I6BLEOuMsdmm+86ajkgJVXPM2XazF8ASJuwgSO3ATLhiYgRUn2SBpAUMSaS3HuUilphq058=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758125074; c=relaxed/simple;
	bh=FTxybcThi5vYfb5XSgbsYyJB7Ht+qk9yhtA80X+8Gk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ockX8+8zE5ag8CHDTwG6whcd447zRMtp5gRvRmuIKg9Yz3zY7XKG7KINgnKZXuRJwyHkxamPcjvbkArpehWDccEKjKN+nkgxynxBiTK5YutVpLLVxMIZPasXCbcayTv039JTuCWqoQxihhiPCv4pd7aUm9MOFIn7bJzGDW/ngck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BVqJ/5fA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89234C4CEFB;
	Wed, 17 Sep 2025 16:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758125074;
	bh=FTxybcThi5vYfb5XSgbsYyJB7Ht+qk9yhtA80X+8Gk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVqJ/5fADHcWBTMYanXWfEgdmPKtJ0mKgUgiR2I0Mgs35z5cDf9pwRVXuNKyxMy1y
	 S+SlMvLyLw8Ki+nHopYY93gIv+hjr9b0EeiGw/qGrSUISnqBf/QWCziCO6B8PxYSX0
	 YOdb4YhzW6itWunXS1uqrqdCccLbSMijpeLM/1kwVy6KbRKkBXWYJKTGQUCHZ6+35L
	 D4BaIqXhtq5SUP0yIaJJOMWI4tN30pUixHC823QXGEbqreh9n2WiEvwO3Pfyx8EYS6
	 D7/lxXbaV4aBXjKPemt7rQflNX11+xesTmENDj+JfgmCJYwvocT00GXWbzU4Rh31Qp
	 XVp1jhyp+oacw==
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
Subject: [PATCH v4 25/63] objtool: Clean up compiler flag usage
Date: Wed, 17 Sep 2025 09:03:33 -0700
Message-ID: <1bea2722fd6c636d2d81363d9c41abd8d37d6d97.1758067943.git.jpoimboe@kernel.org>
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
index 8c20361dd100e..fc82d47f2b9a7 100644
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
index fdb83a0a592a3..48b90836ed4a5 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -461,7 +461,7 @@ static int decode_instructions(struct objtool_file *file)
 
 		for (offset = 0; offset < sec->sh.sh_size; offset += insn->len) {
 			if (!insns || idx == INSN_CHUNK_MAX) {
-				insns = calloc(sizeof(*insn), INSN_CHUNK_SIZE);
+				insns = calloc(INSN_CHUNK_SIZE, sizeof(*insn));
 				if (!insns) {
 					ERROR_GLIBC("calloc");
 					return -1;
@@ -607,7 +607,7 @@ static int init_pv_ops(struct objtool_file *file)
 		return 0;
 
 	nr = sym->len / sizeof(unsigned long);
-	file->pv_ops = calloc(sizeof(struct pv_state), nr);
+	file->pv_ops = calloc(nr, sizeof(struct pv_state));
 	if (!file->pv_ops) {
 		ERROR_GLIBC("calloc");
 		return -1;
diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
index 2ea6d591c3c29..c27edeed2dd03 100644
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
2.50.0


