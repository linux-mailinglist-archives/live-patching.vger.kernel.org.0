Return-Path: <live-patching+bounces-21-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93A157E29BA
	for <lists+live-patching@lfdr.de>; Mon,  6 Nov 2023 17:27:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1BC4FB20C66
	for <lists+live-patching@lfdr.de>; Mon,  6 Nov 2023 16:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9BBE29411;
	Mon,  6 Nov 2023 16:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="muMZ/PdM";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="f/pEvAUi"
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CE129406
	for <live-patching@vger.kernel.org>; Mon,  6 Nov 2023 16:26:55 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D59F10DA;
	Mon,  6 Nov 2023 08:26:48 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 89D202006A;
	Mon,  6 Nov 2023 16:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1699288006; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=toIsN5YluhK1lr5tb8LU9OIiJH3LReIfnzzttfHELBo=;
	b=muMZ/PdMzdEGYdrBzSbc2tfO3CG+/H4jXg+MByNR1BMW3inVuBkxNhAP9CrjYTXhM6mhyX
	82mYFyNwTL55Gmod2ZynXNvGYF7t4RyJVn22qK3jpYRVqSqej5xpALDanmby0LWA+kTOMs
	yOg7pFb0cr9Z9HqV5NwG3l0aYzhTk9Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1699288006;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=toIsN5YluhK1lr5tb8LU9OIiJH3LReIfnzzttfHELBo=;
	b=f/pEvAUiGss8lhQB+Y1NdLrRfy1Dq2lf2bHRITC0GOxjtBiDFcRFemCiAujmj4TtKz16cr
	Rah/sGF/A6DqLGBg==
Received: from localhost.cz (lhruska.udp.ovpn2.prg.suse.de [10.100.204.118])
	by relay2.suse.de (Postfix) with ESMTP id 2A5092C1C7;
	Mon,  6 Nov 2023 16:26:46 +0000 (UTC)
From: Lukas Hruska <lhruska@suse.cz>
To: Petr Mladek <pmladek@suse.com>,
	Miroslav Benes <mbenes@suse.cz>,
	Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Lukas Hruska <lhruska@suse.cz>
Subject: [PATCH v1 5/5] documentation: Update on livepatch elf format
Date: Mon,  6 Nov 2023 17:25:13 +0100
Message-ID: <20231106162513.17556-6-lhruska@suse.cz>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106162513.17556-1-lhruska@suse.cz>
References: <20231106162513.17556-1-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a section to Documentation/livepatch/module-elf-format.rst
describing how klp-convert works for fixing relocations.

Signed-off-by: Lukas Hruska <lhruska@suse.cz>
---
 Documentation/livepatch/module-elf-format.rst | 67 +++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
index a03ed02ec57e..2aa9b11cd806 100644
--- a/Documentation/livepatch/module-elf-format.rst
+++ b/Documentation/livepatch/module-elf-format.rst
@@ -300,3 +300,70 @@ symbol table, and relocation section indices, ELF information is preserved for
 livepatch modules and is made accessible by the module loader through
 module->klp_info, which is a :c:type:`klp_modinfo` struct. When a livepatch module
 loads, this struct is filled in by the module loader.
+
+6. klp-convert tool
+===================
+The livepatch relocation sections might be created using
+scripts/livepatch/klp-convert. It is called automatically during
+the build as part of a module post processing.
+
+The tool is not able to find the symbols and all the metadata
+automatically. Instead, all needed information must already be
+part of rela entry for the given symbol. Such a rela can
+be created easily by using KLP_RELOC_SYMBOL() macro after
+the symbol declaration.
+
+KLP_RELOC_SYMBOL causes that the relocation entries for
+the given symbol will be created in the following format::
+
+  .klp.sym.rela.lp_object.sym_object.sym_name,sympos
+  ^           ^ ^       ^ ^        ^ ^      ^   ^
+  |___________| |_______| |________| |______|   |
+       [A]         [B]        [C]       [D]    [E]
+
+[A]
+  The symbol name is prefixed with the string ".klp.sym.rela."
+
+[B]
+  The name of the object (i.e. "vmlinux" or name of module) which
+  is livepatched.
+
+[C]
+  The name of the object (i.e. "vmlinux" or name of module) to
+  which the symbol belongs follows immediately after the prefix.
+
+[D]
+  The actual name of the symbol.
+
+[E]
+  The position of the symbol in the object (as according to kallsyms)
+  This is used to differentiate duplicate symbols within the same
+  object. The symbol position is expressed numerically (0, 1, 2...).
+  The symbol position of a unique symbol is 0.
+
+Example:
+--------
+**Livepatch source code:**
+
+::
+
+  extern char *saved_command_line \
+                 KLP_RELOC_SYMBOL(vmlinux, vmlinux, saved_command_line, 0);
+
+**`readelf -r -W` output of compiled module:**
+
+::
+
+  Relocation section '.rela.text' at offset 0x32e60 contains 10 entries:
+      Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
+  ...
+  0000000000000068  0000003c00000002 R_X86_64_PC32          0000000000000000 .klp.sym.rela.vmlinux.vmlinux.saved_command_line,0 - 4
+  ...
+
+**`readelf -r -W` output of transformed module by klp-convert:**
+
+::
+
+  Relocation section '.klp.rela.vmlinux.text' at offset 0x5cb60 contains 1 entry:
+      Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
+      0000000000000068  0000003c00000002 R_X86_64_PC32          0000000000000000 .klp.sym.vmlinux.saved_command_line,0 - 4
-- 
2.42.0


