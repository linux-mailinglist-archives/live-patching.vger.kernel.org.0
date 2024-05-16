Return-Path: <live-patching+bounces-267-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4CEA8C779F
	for <lists+live-patching@lfdr.de>; Thu, 16 May 2024 15:30:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6FE2D283F96
	for <lists+live-patching@lfdr.de>; Thu, 16 May 2024 13:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2D2A1482EE;
	Thu, 16 May 2024 13:30:27 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411351482E4;
	Thu, 16 May 2024 13:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715866227; cv=none; b=Iv0CHL6QJGg211jr+i2RDaPoOE4ce088TDzJoir1yzZlXW2AsR601kvd0e1H7Dkz6wLSu9fs13dJNt9sW9cgs/6C9QcN4Cf1gtSqVLij9lzJzv9xRDc80BPTbVIU8ogFJyUkPuy/LkT/p0lHI8xV/rUFN/D+4xl+9m+LRMVrarE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715866227; c=relaxed/simple;
	bh=yqUPjCa6qT94bXk2HmJIf+EMfPI7fuUeq+yoIITcYSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8B27Q4peiQY4cPKtikXvC4ytkOjkd/S7jcMX1tG/PT2Fiogm9wX9wk+8UUaWXRXP0r5ZTKQc7Z9DpbOfMwbcU0yqQZtNwfJ6Tv462HmR7umRhbWz2AG2HZCjcICD3pgfAa+QvoYPutMLdUXt6gbUBuipPZZs1AcZOWKlBOxenA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7F39A349E8;
	Thu, 16 May 2024 13:30:23 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7183F13991;
	Thu, 16 May 2024 13:30:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SVQmG28KRmYDCAAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Thu, 16 May 2024 13:30:23 +0000
From: Lukas Hruska <lhruska@suse.cz>
To: pmladek@suse.com,
	mbenes@suse.cz,
	jpoimboe@kernel.org
Cc: joe.lawrence@redhat.com,
	live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	mpdesouza@suse.com,
	lhruska@suse.cz,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH v2 1/6] livepatch: Create and include UAPI headers
Date: Thu, 16 May 2024 15:30:04 +0200
Message-ID: <20240516133009.20224-2-lhruska@suse.cz>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240516133009.20224-1-lhruska@suse.cz>
References: <20240516133009.20224-1-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: 7F39A349E8

From: Josh Poimboeuf <jpoimboe@redhat.com>

Define klp prefixes in include/uapi/linux/livepatch.h, and use them for
replacing hard-coded values in kernel/livepatch/core.c.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Lukas Hruska <lhruska@suse.cz>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>
---
 MAINTAINERS                    |  1 +
 include/uapi/linux/livepatch.h | 15 +++++++++++++++
 kernel/livepatch/core.c        |  5 +++--
 3 files changed, 19 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/livepatch.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 28e20975c26f..130b8b0bd4f7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12614,6 +12614,7 @@ F:	Documentation/ABI/testing/sysfs-kernel-livepatch
 F:	Documentation/livepatch/
 F:	arch/powerpc/include/asm/livepatch.h
 F:	include/linux/livepatch.h
+F:	include/uapi/linux/livepatch.h
 F:	kernel/livepatch/
 F:	kernel/module/livepatch.c
 F:	samples/livepatch/
diff --git a/include/uapi/linux/livepatch.h b/include/uapi/linux/livepatch.h
new file mode 100644
index 000000000000..e19430918a07
--- /dev/null
+++ b/include/uapi/linux/livepatch.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+/*
+ * livepatch.h - Kernel Live Patching Core
+ *
+ * Copyright (C) 2016 Josh Poimboeuf <jpoimboe@redhat.com>
+ */
+
+#ifndef _UAPI_LIVEPATCH_H
+#define _UAPI_LIVEPATCH_H
+
+#define KLP_RELA_PREFIX		".klp.rela."
+#define KLP_SYM_PREFIX		".klp.sym."
+
+#endif /* _UAPI_LIVEPATCH_H */
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index ecbc9b6aba3a..8bde84d85263 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -20,6 +20,7 @@
 #include <linux/completion.h>
 #include <linux/memory.h>
 #include <linux/rcupdate.h>
+#include <uapi/linux/livepatch.h>
 #include <asm/cacheflush.h>
 #include "core.h"
 #include "patch.h"
@@ -226,7 +227,7 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
 
 		/* Format: .klp.sym.sym_objname.sym_name,sympos */
 		cnt = sscanf(strtab + sym->st_name,
-			     ".klp.sym.%55[^.].%511[^,],%lu",
+			     KLP_SYM_PREFIX "%55[^.].%511[^,],%lu",
 			     sym_objname, sym_name, &sympos);
 		if (cnt != 3) {
 			pr_err("symbol %s has an incorrectly formatted name\n",
@@ -305,7 +306,7 @@ static int klp_write_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
 	 * See comment in klp_resolve_symbols() for an explanation
 	 * of the selected field width value.
 	 */
-	cnt = sscanf(shstrtab + sec->sh_name, ".klp.rela.%55[^.]",
+	cnt = sscanf(shstrtab + sec->sh_name, KLP_RELA_PREFIX "%55[^.]",
 		     sec_objname);
 	if (cnt != 1) {
 		pr_err("section %s has an incorrectly formatted name\n",
-- 
2.45.0


