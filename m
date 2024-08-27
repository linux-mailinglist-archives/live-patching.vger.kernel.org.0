Return-Path: <live-patching+bounces-520-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 783EC960A54
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 14:31:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 221D41F23613
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2024 12:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C2281BA875;
	Tue, 27 Aug 2024 12:30:58 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48331BA29C;
	Tue, 27 Aug 2024 12:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724761858; cv=none; b=iOb0mydyeZFDX2Y2gaaXDjanKTEeFwpyt2msFypwHKR+QhnZGKwJJXs/RqXipB81dO/SoshjJo0RiREfP+MEaU3aSeldVOy0H/aRCQqDOl202sPiFwbO+JB+kSYLHEhYxEVu1UOzf17umMi+1ff0p6FKxd6Kepwbd3JEHs+rRIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724761858; c=relaxed/simple;
	bh=ZpQI0lK85F20Mh/bfYndtMl6hMyeTCxB6agL6l8+aoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPxoBWjxlWnMJe3tRohBO7W9UDM+ilRXeQXACMjeEBE925IFq72KAe47P4rwcsa80WiGCbv+vI+jKW7gGfqDddOmm5smK3U1W5G8pKPxC9/ivUTuUjjz2kdQhZM6tYoc9FLshsL7ZVr5VokjnjsvOXNj6ecFe2qWYPVBCkpqT1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2CEAE21B0E;
	Tue, 27 Aug 2024 12:30:55 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2402A13724;
	Tue, 27 Aug 2024 12:30:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lwnJCP/GzWa2YwAAD6G6ig
	(envelope-from <lhruska@suse.cz>); Tue, 27 Aug 2024 12:30:55 +0000
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
Subject: [PATCH v3 1/6] livepatch: Create and include UAPI headers
Date: Tue, 27 Aug 2024 14:30:46 +0200
Message-ID: <20240827123052.9002-2-lhruska@suse.cz>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240827123052.9002-1-lhruska@suse.cz>
References: <20240827123052.9002-1-lhruska@suse.cz>
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
X-Spam-Level: 
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Spam-Score: -4.00
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 2CEAE21B0E
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org

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
index 878dcd23b331..31d809797241 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13053,6 +13053,7 @@ F:	Documentation/ABI/testing/sysfs-kernel-livepatch
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
index 3c21c31796db..81c248c577e3 100644
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
2.46.0


