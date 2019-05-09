Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B8218C12
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 16:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfEIOjJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 10:39:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48852 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726743AbfEIOjJ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 10:39:09 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B0E56308FF32;
        Thu,  9 May 2019 14:39:08 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (ovpn-123-90.rdu2.redhat.com [10.10.123.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F24AC17AEA;
        Thu,  9 May 2019 14:39:07 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH v4 01/10] livepatch: Create and include UAPI headers
Date:   Thu,  9 May 2019 10:38:50 -0400
Message-Id: <20190509143859.9050-2-joe.lawrence@redhat.com>
In-Reply-To: <20190509143859.9050-1-joe.lawrence@redhat.com>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 09 May 2019 14:39:08 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

Define klp prefixes in include/uapi/linux/livepatch.h, and use them for
replacing hard-coded values in kernel/livepatch/core.c.

Update MAINTAINERS.

Note: Add defines to uapi as these are also to be used by a newly
introduced klp-convert script.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Joao Moreira <jmoreira@suse.de>
Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 MAINTAINERS                    |  1 +
 include/linux/livepatch.h      |  1 +
 include/uapi/linux/livepatch.h | 15 +++++++++++++++
 kernel/livepatch/core.c        |  4 ++--
 4 files changed, 19 insertions(+), 2 deletions(-)
 create mode 100644 include/uapi/linux/livepatch.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 09f43f1bdd15..52842fa37261 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9016,6 +9016,7 @@ R:	Joe Lawrence <joe.lawrence@redhat.com>
 S:	Maintained
 F:	kernel/livepatch/
 F:	include/linux/livepatch.h
+F:	include/uapi/linux/livepatch.h
 F:	arch/x86/include/asm/livepatch.h
 F:	arch/x86/kernel/livepatch.c
 F:	Documentation/livepatch/
diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 53551f470722..16b48e8b29a2 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -25,6 +25,7 @@
 #include <linux/ftrace.h>
 #include <linux/completion.h>
 #include <linux/list.h>
+#include <uapi/linux/livepatch.h>
 
 #if IS_ENABLED(CONFIG_LIVEPATCH)
 
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
index eb0ee10a1981..3d9ed895b252 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -235,7 +235,7 @@ static int klp_resolve_symbols(Elf_Shdr *relasec, struct module *pmod)
 
 		/* Format: .klp.sym.objname.symname,sympos */
 		cnt = sscanf(strtab + sym->st_name,
-			     ".klp.sym.%55[^.].%127[^,],%lu",
+			     KLP_SYM_PREFIX "%55[^.].%127[^,],%lu",
 			     objname, symname, &sympos);
 		if (cnt != 3) {
 			pr_err("symbol %s has an incorrectly formatted name\n",
@@ -281,7 +281,7 @@ static int klp_write_object_relocations(struct module *pmod,
 		 * See comment in klp_resolve_symbols() for an explanation
 		 * of the selected field width value.
 		 */
-		cnt = sscanf(secname, ".klp.rela.%55[^.]", sec_objname);
+		cnt = sscanf(secname, KLP_RELA_PREFIX "%55[^.]", sec_objname);
 		if (cnt != 1) {
 			pr_err("section %s has an incorrectly formatted name\n",
 			       secname);
-- 
2.20.1

