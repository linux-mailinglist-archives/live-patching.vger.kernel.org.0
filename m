Return-Path: <live-patching+bounces-1553-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EFCCAEAB36
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 02:01:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC4A03BBCFB
	for <lists+live-patching@lfdr.de>; Fri, 27 Jun 2025 00:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D12B4270568;
	Thu, 26 Jun 2025 23:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gI9aAE/o"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66AB26D4EB;
	Thu, 26 Jun 2025 23:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750982187; cv=none; b=ADJqI+OBXSfwmBtz7BoQ/77EDR7DCmp5/aU9JZCXzEyUN2J4yp4H8+vcGpmCh439e8JZomlCvkIS5i+uWJAnLXeJyRQ7svXwsZiji83+3emzXh6pDaijwMZnbSk7UpUZg8xkB//zs8OnNzXxjUZW9JLI1m3wRDOel5CocSX3r18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750982187; c=relaxed/simple;
	bh=D7DiDKaDV1RbYiMbn94UAIgKZwUJSlyL+1289xYyOKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyY+QfML9O2vOElRP2iREINpQuP5Maj1sXlHm8LBx1t9xUMWWwoB5KBl9SBAt4SB7EjxZ7izhcAXOpH9Ezy2XVlHcU505mDop4QJY/sy9mxF8R+gXfjQ5E+09usSvgjjH37vC33HLbyblfSowLZJCRQR3BzPacxxJqIDDYk1lME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gI9aAE/o; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BFDC4CEF4;
	Thu, 26 Jun 2025 23:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750982187;
	bh=D7DiDKaDV1RbYiMbn94UAIgKZwUJSlyL+1289xYyOKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gI9aAE/oDSFI85Ktt03ONukA6fQXyKyJXH0hmGxktxFKuadbuhP+MzZwh1oEFObNE
	 jMC8xT9LEH7LYvW/7BKa4thxE2JFW5/1M0GrFTqQCkCm+Ok6tz1HjrCFhP64xIUMoh
	 4JtMLP9CpPoleS2P963G7nSttg+TsXYwObLyPpv6qfLTHK9GKPtYcqHsikrmFKOBnq
	 WYvPL6hoPVPJNFYJyYL6P2y5qAoRCSp/h8/5zekpr8sMNuXysmUuZkdcfxJMig7r4h
	 73mtM0Y1vYHm//HdoRF9o7Fs1IFiio9wO/sBaFvxh+oc6QdlRtj998+yfnnr0H5c8f
	 t+06kiXadoz7w==
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
	Dylan Hatch <dylanbhatch@google.com>
Subject: [PATCH v3 23/64] objtool: Clean up compiler flag usage
Date: Thu, 26 Jun 2025 16:55:10 -0700
Message-ID: <6c22915a4ef67a05c64dd0855021d1d7426409f8.1750980517.git.jpoimboe@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750980516.git.jpoimboe@kernel.org>
References: <cover.1750980516.git.jpoimboe@kernel.org>
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
index fe18f9f5dbef..4e779bf8fcae 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -460,7 +460,7 @@ static int decode_instructions(struct objtool_file *file)
 
 		for (offset = 0; offset < sec->sh.sh_size; offset += insn->len) {
 			if (!insns || idx == INSN_CHUNK_MAX) {
-				insns = calloc(sizeof(*insn), INSN_CHUNK_SIZE);
+				insns = calloc(INSN_CHUNK_SIZE, sizeof(*insn));
 				if (!insns) {
 					ERROR_GLIBC("calloc");
 					return -1;
@@ -606,7 +606,7 @@ static int init_pv_ops(struct objtool_file *file)
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


