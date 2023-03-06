Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC6576AC352
	for <lists+live-patching@lfdr.de>; Mon,  6 Mar 2023 15:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjCFOcs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Mar 2023 09:32:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbjCFOcq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Mar 2023 09:32:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E519576B4
        for <live-patching@vger.kernel.org>; Mon,  6 Mar 2023 06:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678113019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+xIRykpdRJE+DsCK9N+IP6zxk5kG+sp7fs6Ep7aFl78=;
        b=BdBGA1AQJEH6B92LnxRJtwuU1LHgdYVE/5swy/YbqX/1Bo90v4AqynvJwWOXtZoXrMRQ5U
        3AjBfR8NOPONcg3PJamQ1D3p0B/8gpZx8y54mHMqHBrMz3jICWQjDYZSXm9KxEcqiUyu3K
        xm9CBZRsHO7tXhg1PPjLFux+0Mg7Rzo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-388-rIh6hJ_zPrWPtqFeHy2cTQ-1; Mon, 06 Mar 2023 09:08:27 -0500
X-MC-Unique: rIh6hJ_zPrWPtqFeHy2cTQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F6603810B07;
        Mon,  6 Mar 2023 14:08:27 +0000 (UTC)
Received: from jlaw-desktop.redhat.com (unknown [10.22.17.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5B3140ED76C;
        Mon,  6 Mar 2023 14:08:26 +0000 (UTC)
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: [PATCH v7 01/10] livepatch: Create and include UAPI headers
Date:   Mon,  6 Mar 2023 09:08:15 -0500
Message-Id: <20230306140824.3858543-2-joe.lawrence@redhat.com>
In-Reply-To: <20230306140824.3858543-1-joe.lawrence@redhat.com>
References: <20230306140824.3858543-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

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
index 135d93368d36..5bdf333fb1f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12069,6 +12069,7 @@ F:	Documentation/ABI/testing/sysfs-kernel-livepatch
 F:	Documentation/livepatch/
 F:	arch/powerpc/include/asm/livepatch.h
 F:	include/linux/livepatch.h
+F:	include/uapi/linux/livepatch.h
 F:	kernel/livepatch/
 F:	kernel/module/livepatch.c
 F:	lib/livepatch/
diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 293e29960c6e..46da4c0df6c1 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -13,6 +13,7 @@
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
index 201f0c0482fb..c565d33db582 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -234,7 +234,7 @@ static int klp_resolve_symbols(Elf_Shdr *sechdrs, const char *strtab,
 
 		/* Format: .klp.sym.sym_objname.sym_name,sympos */
 		cnt = sscanf(strtab + sym->st_name,
-			     ".klp.sym.%55[^.].%511[^,],%lu",
+			     KLP_SYM_PREFIX "%55[^.].%511[^,],%lu",
 			     sym_objname, sym_name, &sympos);
 		if (cnt != 3) {
 			pr_err("symbol %s has an incorrectly formatted name\n",
@@ -305,7 +305,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
 	 * See comment in klp_resolve_symbols() for an explanation
 	 * of the selected field width value.
 	 */
-	cnt = sscanf(shstrtab + sec->sh_name, ".klp.rela.%55[^.]",
+	cnt = sscanf(shstrtab + sec->sh_name, KLP_RELA_PREFIX "%55[^.]",
 		     sec_objname);
 	if (cnt != 1) {
 		pr_err("section %s has an incorrectly formatted name\n",
-- 
2.39.2

