Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEE72FF5BE
	for <lists+live-patching@lfdr.de>; Thu, 21 Jan 2021 21:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbhAUUVv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jan 2021 15:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbhAUHyj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jan 2021 02:54:39 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD727C061757;
        Wed, 20 Jan 2021 23:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=CBn0nIvzF4lsJIlmcNwvI6PwAlNBtY57zO+JFTdIDBA=; b=wILKHrE7zJ5ukZC9RHuI0Uk3fe
        EiDCI/52xf99CaCWMXlzY0E74cAz6IXo4v2Mu6qm6hpykxhDEoPz4TqKYKZxGxXpznewjH7NJXIhm
        3wwDBW9PxX/8Ls3odBp8+swR/7BGL44uzxP4UCWiIBU1t0Gniwi5nL/pVazEPwP3ucRVGnz8LH3JS
        aRn0VX7Ip3Hx9YvdI1cdwznnGnyhpjrLbdLbHLOnDc49Eu3Mc+6a4xIuxYiCHUjyxDVBBBE+HRSZD
        MI38XZRZXTIz9bbpTPfhcUyG6pEQ08XubgPMvqPcgIgikuuTk5lY4R3EhePGY35H1ubDwdprJFg10
        D6cBk3ag==;
Received: from [2001:4bb8:188:1954:d5b3:2657:287:e45f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l2UmN-00Gm5Z-VJ; Thu, 21 Jan 2021 07:53:25 +0000
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
Subject: [PATCH 02/13] module: add a module_loaded helper
Date:   Thu, 21 Jan 2021 08:49:48 +0100
Message-Id: <20210121074959.313333-3-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074959.313333-1-hch@lst.de>
References: <20210121074959.313333-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add a helper that takes modules_mutex and uses find_module to check if a
given module is loaded.  This provides a better abstraction for the two
callers, and allows to unexport modules_mutex and find_module.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/gpu/drm/drm_fb_helper.c |  7 +------
 include/linux/module.h          |  3 +++
 kernel/module.c                 | 14 ++++++++++++--
 kernel/trace/trace_kprobe.c     |  4 +---
 4 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 4b81195106875d..ce6d63ca75c32a 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -2508,13 +2508,8 @@ int __init drm_fb_helper_modinit(void)
 {
 #if defined(CONFIG_FRAMEBUFFER_CONSOLE_MODULE) && !defined(CONFIG_EXPERT)
 	const char name[] = "fbcon";
-	struct module *fbcon;
 
-	mutex_lock(&module_mutex);
-	fbcon = find_module(name);
-	mutex_unlock(&module_mutex);
-
-	if (!fbcon)
+	if (!module_loaded(name))
 		request_module_nowait(name);
 #endif
 	return 0;
diff --git a/include/linux/module.h b/include/linux/module.h
index 7a0bcb5b1ffccd..b4654f8a408134 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -589,6 +589,9 @@ static inline bool within_module(unsigned long addr, const struct module *mod)
 /* Search for module by name: must hold module_mutex. */
 struct module *find_module(const char *name);
 
+/* Check if a module is loaded. */
+bool module_loaded(const char *name);
+
 struct symsearch {
 	const struct kernel_symbol *start, *stop;
 	const s32 *crcs;
diff --git a/kernel/module.c b/kernel/module.c
index 4bf30e4b3eaaa1..619ea682e64cd1 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -88,7 +88,6 @@
  * (delete and add uses RCU list operations).
  */
 DEFINE_MUTEX(module_mutex);
-EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
 
 /* Work queue for freeing init sections in success case */
@@ -672,7 +671,18 @@ struct module *find_module(const char *name)
 	module_assert_mutex();
 	return find_module_all(name, strlen(name), false);
 }
-EXPORT_SYMBOL_GPL(find_module);
+
+bool module_loaded(const char *name)
+{
+	bool ret;
+
+	mutex_lock(&module_mutex);
+	ret = !!find_module(name);
+	mutex_unlock(&module_mutex);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(module_loaded);
 
 #ifdef CONFIG_SMP
 
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index e6fba1798771b4..c2e453f88bce70 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -124,9 +124,7 @@ static nokprobe_inline bool trace_kprobe_module_exist(struct trace_kprobe *tk)
 	if (!p)
 		return true;
 	*p = '\0';
-	mutex_lock(&module_mutex);
-	ret = !!find_module(tk->symbol);
-	mutex_unlock(&module_mutex);
+	ret = module_loaded(tk->symbol);
 	*p = ':';
 
 	return ret;
-- 
2.29.2

