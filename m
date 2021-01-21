Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8899E2FE47B
	for <lists+live-patching@lfdr.de>; Thu, 21 Jan 2021 08:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbhAUH5i (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jan 2021 02:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbhAUH5T (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jan 2021 02:57:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E30C061757;
        Wed, 20 Jan 2021 23:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Jxciaq9zC3OnLkf25fj3jgcT3nYCygACKof0U/Q8da8=; b=NggpydQ4JHjd0mN+Wn4BaQ4jqq
        t1mcwRctZyVmUXMZl0H/LDFec5K0BL40m2HPD2GgXxLixDUsadmtinjemP2y6WubeLdsqvy7QmAfv
        S74Q3m7EtyKsR0S7kQcC5qEiukl7DmuM7IPPDyU++9GUfBr+KM9VN9I5IAa4kg6pn8v7vjE5i3bf0
        qbOM3wdrTmsJqbZgZf9umvW8XzapL0Pcm1YUIHYlE0RKkmyD2+PmHMCnXjAzHAZ1Y5hBer53mXqD3
        B8xu4+7n39BxQYyOBuPZrtS4Se9nwv66vGYdwd8mN02CeSwN8fJLO6QH0uZ1qXMnsv3Xrzie3LmKb
        gdYYfoPA==;
Received: from [2001:4bb8:188:1954:d5b3:2657:287:e45f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l2UoN-00GmFC-0u; Thu, 21 Jan 2021 07:55:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Jessica Yu <jeyu@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: [PATCH 10/13] module: merge each_symbol_section into find_symbol
Date:   Thu, 21 Jan 2021 08:49:56 +0100
Message-Id: <20210121074959.313333-11-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074959.313333-1-hch@lst.de>
References: <20210121074959.313333-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

each_symbol_section is only called by find_symbol, so merge the two
functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/module.c | 148 ++++++++++++++++++++++--------------------------
 1 file changed, 69 insertions(+), 79 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index a9d092765c4eab..644dda52dae38c 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -433,73 +433,6 @@ extern const s32 __start___kcrctab_unused_gpl[];
 #define symversion(base, idx) ((base != NULL) ? ((base) + (idx)) : NULL)
 #endif
 
-/* Returns true as soon as fn returns true, otherwise false. */
-static bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
-				    struct module *owner,
-				    void *data),
-			 void *data)
-{
-	unsigned int i;
-	struct module *mod;
-	static const struct symsearch arr[] = {
-		{ __start___ksymtab, __stop___ksymtab, __start___kcrctab,
-		  NOT_GPL_ONLY, false },
-		{ __start___ksymtab_gpl, __stop___ksymtab_gpl,
-		  __start___kcrctab_gpl,
-		  GPL_ONLY, false },
-		{ __start___ksymtab_gpl_future, __stop___ksymtab_gpl_future,
-		  __start___kcrctab_gpl_future,
-		  WILL_BE_GPL_ONLY, false },
-#ifdef CONFIG_UNUSED_SYMBOLS
-		{ __start___ksymtab_unused, __stop___ksymtab_unused,
-		  __start___kcrctab_unused,
-		  NOT_GPL_ONLY, true },
-		{ __start___ksymtab_unused_gpl, __stop___ksymtab_unused_gpl,
-		  __start___kcrctab_unused_gpl,
-		  GPL_ONLY, true },
-#endif
-	};
-
-	module_assert_mutex_or_preempt();
-
-	for (i = 0; i < ARRAY_SIZE(arr); i++)
-		if (fn(&arr[i], NULL, data))
-			return true;
-
-	list_for_each_entry_rcu(mod, &modules, list,
-				lockdep_is_held(&module_mutex)) {
-		struct symsearch arr[] = {
-			{ mod->syms, mod->syms + mod->num_syms, mod->crcs,
-			  NOT_GPL_ONLY, false },
-			{ mod->gpl_syms, mod->gpl_syms + mod->num_gpl_syms,
-			  mod->gpl_crcs,
-			  GPL_ONLY, false },
-			{ mod->gpl_future_syms,
-			  mod->gpl_future_syms + mod->num_gpl_future_syms,
-			  mod->gpl_future_crcs,
-			  WILL_BE_GPL_ONLY, false },
-#ifdef CONFIG_UNUSED_SYMBOLS
-			{ mod->unused_syms,
-			  mod->unused_syms + mod->num_unused_syms,
-			  mod->unused_crcs,
-			  NOT_GPL_ONLY, true },
-			{ mod->unused_gpl_syms,
-			  mod->unused_gpl_syms + mod->num_unused_gpl_syms,
-			  mod->unused_gpl_crcs,
-			  GPL_ONLY, true },
-#endif
-		};
-
-		if (mod->state == MODULE_STATE_UNFORMED)
-			continue;
-
-		for (i = 0; i < ARRAY_SIZE(arr); i++)
-			if (fn(&arr[i], mod, data))
-				return true;
-	}
-	return false;
-}
-
 struct find_symbol_arg {
 	/* Input */
 	const char *name;
@@ -610,24 +543,81 @@ static const struct kernel_symbol *find_symbol(const char *name,
 					bool gplok,
 					bool warn)
 {
-	struct find_symbol_arg fsa;
+	static const struct symsearch arr[] = {
+		{ __start___ksymtab, __stop___ksymtab, __start___kcrctab,
+		  NOT_GPL_ONLY, false },
+		{ __start___ksymtab_gpl, __stop___ksymtab_gpl,
+		  __start___kcrctab_gpl,
+		  GPL_ONLY, false },
+		{ __start___ksymtab_gpl_future, __stop___ksymtab_gpl_future,
+		  __start___kcrctab_gpl_future,
+		  WILL_BE_GPL_ONLY, false },
+#ifdef CONFIG_UNUSED_SYMBOLS
+		{ __start___ksymtab_unused, __stop___ksymtab_unused,
+		  __start___kcrctab_unused,
+		  NOT_GPL_ONLY, true },
+		{ __start___ksymtab_unused_gpl, __stop___ksymtab_unused_gpl,
+		  __start___kcrctab_unused_gpl,
+		  GPL_ONLY, true },
+#endif
+	};
+	struct find_symbol_arg fsa = {
+		.name = name,
+		.gplok = gplok,
+		.warn = warn,
+	};
+	struct module *mod;
+	unsigned int i;
+
+	module_assert_mutex_or_preempt();
+
+	for (i = 0; i < ARRAY_SIZE(arr); i++)
+		if (find_exported_symbol_in_section(&arr[i], NULL, &fsa))
+			goto found;
 
-	fsa.name = name;
-	fsa.gplok = gplok;
-	fsa.warn = warn;
+	list_for_each_entry_rcu(mod, &modules, list,
+				lockdep_is_held(&module_mutex)) {
+		struct symsearch arr[] = {
+			{ mod->syms, mod->syms + mod->num_syms, mod->crcs,
+			  NOT_GPL_ONLY, false },
+			{ mod->gpl_syms, mod->gpl_syms + mod->num_gpl_syms,
+			  mod->gpl_crcs,
+			  GPL_ONLY, false },
+			{ mod->gpl_future_syms,
+			  mod->gpl_future_syms + mod->num_gpl_future_syms,
+			  mod->gpl_future_crcs,
+			  WILL_BE_GPL_ONLY, false },
+#ifdef CONFIG_UNUSED_SYMBOLS
+			{ mod->unused_syms,
+			  mod->unused_syms + mod->num_unused_syms,
+			  mod->unused_crcs,
+			  NOT_GPL_ONLY, true },
+			{ mod->unused_gpl_syms,
+			  mod->unused_gpl_syms + mod->num_unused_gpl_syms,
+			  mod->unused_gpl_crcs,
+			  GPL_ONLY, true },
+#endif
+		};
 
-	if (each_symbol_section(find_exported_symbol_in_section, &fsa)) {
-		if (owner)
-			*owner = fsa.owner;
-		if (crc)
-			*crc = fsa.crc;
-		if (license)
-			*license = fsa.license;
-		return fsa.sym;
+		if (mod->state == MODULE_STATE_UNFORMED)
+			continue;
+
+		for (i = 0; i < ARRAY_SIZE(arr); i++)
+			if (find_exported_symbol_in_section(&arr[i], mod, &fsa))
+				goto found;
 	}
 
 	pr_debug("Failed to find symbol %s\n", name);
 	return NULL;
+
+found:
+	if (owner)
+		*owner = fsa.owner;
+	if (crc)
+		*crc = fsa.crc;
+	if (license)
+		*license = fsa.license;
+	return fsa.sym;
 }
 
 /*
-- 
2.29.2

