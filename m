Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5722FF57C
	for <lists+live-patching@lfdr.de>; Thu, 21 Jan 2021 21:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbhAUUIw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jan 2021 15:08:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727926AbhAUHzo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jan 2021 02:55:44 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2889AC061575;
        Wed, 20 Jan 2021 23:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=YWgFZHETTCocNHaS6Y+o9EUn4aXGnKZkK4G71oX+tnQ=; b=qwvFW7akNvNlY4Pjg/pPm41zoq
        3nvwK7iVvg4bXfNII+oY0Po9cCPHz/XI2rxzSOgIq6flWF4ChGiTtkuOCwrZBwg0yiELa1271URzN
        52N4SAlXlShIyiHo2LQsK6mmUwDhgh2KOnKEzAoXhrkFebe0VYX8tYuT1ct5dQCCyv9Y/BVmBa6fG
        Pnllh+kJ5usexM6s61uQxtU4EBFzRFdn8pKJ+4mitTUr5IncxDu7rSqlmYI2VgX1Iv0Em7UXOi1f1
        eKJi12+bb6H76GpSAMHrZpmrgrA40DprgjSLFW+91B2Jc010XpckXn+Xg+LAkGc//cFDpB1ns8I4p
        L0hCKdGA==;
Received: from [2001:4bb8:188:1954:d5b3:2657:287:e45f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l2Umw-00Gm7M-Pm; Thu, 21 Jan 2021 07:53:59 +0000
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
Subject: [PATCH 05/13] kallsyms: refactor {,module_}kallsyms_on_each_symbol
Date:   Thu, 21 Jan 2021 08:49:51 +0100
Message-Id: <20210121074959.313333-6-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074959.313333-1-hch@lst.de>
References: <20210121074959.313333-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Require an explicit cll to module_kallsyms_on_each_symbol to look
for symbols in modules instead of the call from kallsyms_on_each_symbol,
and acquire module_mutex inside of module_kallsyms_on_each_symbol instead
of leaving that up to the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/kallsyms.c       | 6 +++++-
 kernel/livepatch/core.c | 6 +-----
 kernel/module.c         | 8 ++++----
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index fe9de067771c34..a0d3f0865916f9 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -177,6 +177,10 @@ unsigned long kallsyms_lookup_name(const char *name)
 	return module_kallsyms_lookup_name(name);
 }
 
+/*
+ * Iterate over all symbols in vmlinux.  For symbols from modules use
+ * module_kallsyms_on_each_symbol instead.
+ */
 int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 				      unsigned long),
 			    void *data)
@@ -192,7 +196,7 @@ int kallsyms_on_each_symbol(int (*fn)(void *, const char *, struct module *,
 		if (ret != 0)
 			return ret;
 	}
-	return module_kallsyms_on_each_symbol(fn, data);
+	return 0;
 }
 
 static unsigned long get_symbol_pos(unsigned long addr,
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 878759baadd81c..8063b9089bd2f8 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -135,12 +135,8 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 		.pos = sympos,
 	};
 
-	mutex_lock(&module_mutex);
-	if (objname)
+	if (objname || !kallsyms_on_each_symbol(klp_find_callback, &args))
 		module_kallsyms_on_each_symbol(klp_find_callback, &args);
-	else
-		kallsyms_on_each_symbol(klp_find_callback, &args);
-	mutex_unlock(&module_mutex);
 
 	/*
 	 * Ensure an address was found. If sympos is 0, ensure symbol is unique;
diff --git a/kernel/module.c b/kernel/module.c
index 299cbac0775cf2..885feec64c1b6f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4407,8 +4407,7 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 	unsigned int i;
 	int ret;
 
-	module_assert_mutex();
-
+	mutex_lock(&module_mutex);
 	list_for_each_entry(mod, &modules, list) {
 		/* We hold module_mutex: no need for rcu_dereference_sched */
 		struct mod_kallsyms *kallsyms = mod->kallsyms;
@@ -4424,10 +4423,11 @@ int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
 			ret = fn(data, kallsyms_symbol_name(kallsyms, i),
 				 mod, kallsyms_symbol_value(sym));
 			if (ret != 0)
-				return ret;
+				break;
 		}
 	}
-	return 0;
+	mutex_unlock(&module_mutex);
+	return ret;
 }
 #endif /* CONFIG_KALLSYMS */
 
-- 
2.29.2

