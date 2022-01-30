Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EB574A3A87
	for <lists+live-patching@lfdr.de>; Sun, 30 Jan 2022 22:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356693AbiA3Vdi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 30 Jan 2022 16:33:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1356573AbiA3Vc3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 30 Jan 2022 16:32:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643578349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RJ3wtlLtaJBB+rGMcpTUIkLwDhDnJi3iDHMFvemCFL0=;
        b=EBdFXK1dO2h0iYMra49eKFx5C00EX6cegbqeUzz/rEua1Sb8/k4MPj38MJD0pN8xuE46u3
        +Wa+qDWRUgYmcDjBssIAC1M1F7St5kVOIjOnWTiJw0C3avpbAdf6TPCvPw2iJiv+now+/d
        hpOwrhDbRFNjo5PePJVjXV4q7b8zepU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-479-ADabKFJWMOC7jPpMt9f_Jg-1; Sun, 30 Jan 2022 16:32:27 -0500
X-MC-Unique: ADabKFJWMOC7jPpMt9f_Jg-1
Received: by mail-wr1-f72.google.com with SMTP id i25-20020adfaad9000000b001e01f5804abso1362229wrc.2
        for <live-patching@vger.kernel.org>; Sun, 30 Jan 2022 13:32:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RJ3wtlLtaJBB+rGMcpTUIkLwDhDnJi3iDHMFvemCFL0=;
        b=z1deMhZg5mi8EF5bMM23PXf78GCjz1DOQNMw4yR53qn+U6h+giuRavf5wpLr/uuum8
         09fjVVIiQXkvNaTNGt9EWYzlT/VwZ2S5cLdziwEWGsj37Th10akWiDMEx6R+jOBDNhRi
         yGCpNp3+eGkofqui0PUozjBhSBCkDUbtkZoJzavOTH5Y7dwc6FJvbbIwAHgsjUpTPCCz
         U631ckdf2sWzIDXTzkT9eKPsqx8wMwSsQEXWLw58R0sJNfSAfkMn1hEgJWj73xIlAKrv
         WPPKVjNd7rOJe+twc1X23unCeKHihlWvuqOMnycI4L/q6ffts0AxfnTY85z7xVTd8XSC
         Ga8Q==
X-Gm-Message-State: AOAM533PvLbTsgoJEPAGuFfIAyZ20IcxxuNLr/MMLU42A/Xrfb8f1iH9
        qblBzhTQJBPVD+O9N8mxvPkj6LKG+Cy0YKyeJOalZaZ86rI5zQXKHoBWy8957g8/ohOf2OLN+NY
        6cN+O1B/SUoDXAxsZyBzeuvYl
X-Received: by 2002:a7b:ca55:: with SMTP id m21mr25031014wml.114.1643578346415;
        Sun, 30 Jan 2022 13:32:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz8yo00K8umZij8wpGoKor3DR0Q5lrqw7AuO7i/8XAPVAsVqsIdoHyV/SKYbZG/stHDtrR7hw==
X-Received: by 2002:a7b:ca55:: with SMTP id m21mr25031003wml.114.1643578346169;
        Sun, 30 Jan 2022 13:32:26 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id bg26sm7691200wmb.48.2022.01.30.13.32.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 13:32:25 -0800 (PST)
From:   Aaron Tomlin <atomlin@redhat.com>
To:     mcgrof@kernel.org
Cc:     cl@linux.com, pmladek@suse.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, atomlin@atomlin.com,
        ghalat@redhat.com, allen.lkml@gmail.com, void@manifault.com,
        joe@perches.com
Subject: [RFC PATCH v4 07/13] module: Move extra signature support out of core code
Date:   Sun, 30 Jan 2022 21:32:08 +0000
Message-Id: <20220130213214.1042497-8-atomlin@redhat.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220130213214.1042497-1-atomlin@redhat.com>
References: <20220130213214.1042497-1-atomlin@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

No functional change.

This patch migrates additional module signature check
code from core module code into kernel/module/signing.c.

Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
---
 include/linux/module.h   |  5 ++-
 kernel/module/internal.h |  9 +++++
 kernel/module/main.c     | 87 ----------------------------------------
 kernel/module/signing.c  | 75 ++++++++++++++++++++++++++++++++++
 4 files changed, 87 insertions(+), 89 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 520c0f4bb968..15ba2ebbca3e 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -720,8 +720,8 @@ static inline bool set_livepatch_module(struct module *mod)
 	return false;
 }
 
-bool is_module_sig_enforced(void);
-void set_module_sig_enforced(void);
+extern bool is_module_sig_enforced(void);
+extern void set_module_sig_enforced(void);
 
 #else /* !CONFIG_MODULES... */
 
@@ -911,6 +911,7 @@ static inline bool module_sig_ok(struct module *module)
 {
 	return true;
 }
+#define sig_enforce false
 #endif	/* CONFIG_MODULE_SIG */
 
 int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
diff --git a/kernel/module/internal.h b/kernel/module/internal.h
index de28d6bb7b5b..2ec2a1d9dd9f 100644
--- a/kernel/module/internal.h
+++ b/kernel/module/internal.h
@@ -114,3 +114,12 @@ static struct module *mod_find(unsigned long addr)
 	return NULL;
 }
 #endif /* CONFIG_MODULES_TREE_LOOKUP */
+
+#ifdef CONFIG_MODULE_SIG
+extern int module_sig_check(struct load_info *info, int flags);
+#else /* !CONFIG_MODULE_SIG */
+static int module_sig_check(struct load_info *info, int flags)
+{
+	return 0;
+}
+#endif /* !CONFIG_MODULE_SIG */
diff --git a/kernel/module/main.c b/kernel/module/main.c
index 1a0e659a27bc..90c7266087d7 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -22,7 +22,6 @@
 #include <linux/vmalloc.h>
 #include <linux/elf.h>
 #include <linux/proc_fs.h>
-#include <linux/security.h>
 #include <linux/seq_file.h>
 #include <linux/syscalls.h>
 #include <linux/fcntl.h>
@@ -123,28 +122,6 @@ static void module_assert_mutex_or_preempt(void)
 #endif
 }
 
-#ifdef CONFIG_MODULE_SIG
-static bool sig_enforce = IS_ENABLED(CONFIG_MODULE_SIG_FORCE);
-module_param(sig_enforce, bool_enable_only, 0644);
-
-void set_module_sig_enforced(void)
-{
-	sig_enforce = true;
-}
-#else
-#define sig_enforce false
-#endif
-
-/*
- * Export sig_enforce kernel cmdline parameter to allow other subsystems rely
- * on that instead of directly to CONFIG_MODULE_SIG_FORCE config.
- */
-bool is_module_sig_enforced(void)
-{
-	return sig_enforce;
-}
-EXPORT_SYMBOL(is_module_sig_enforced);
-
 /* Block module loading/unloading? */
 int modules_disabled = 0;
 core_param(nomodule, modules_disabled, bint, 0);
@@ -2525,70 +2502,6 @@ static inline void kmemleak_load_module(const struct module *mod,
 }
 #endif
 
-#ifdef CONFIG_MODULE_SIG
-static int module_sig_check(struct load_info *info, int flags)
-{
-	int err = -ENODATA;
-	const unsigned long markerlen = sizeof(MODULE_SIG_STRING) - 1;
-	const char *reason;
-	const void *mod = info->hdr;
-	bool mangled_module = flags & (MODULE_INIT_IGNORE_MODVERSIONS |
-				       MODULE_INIT_IGNORE_VERMAGIC);
-	/*
-	 * Do not allow mangled modules as a module with version information
-	 * removed is no longer the module that was signed.
-	 */
-	if (!mangled_module &&
-	    info->len > markerlen &&
-	    memcmp(mod + info->len - markerlen, MODULE_SIG_STRING, markerlen) == 0) {
-		/* We truncate the module to discard the signature */
-		info->len -= markerlen;
-		err = mod_verify_sig(mod, info);
-		if (!err) {
-			info->sig_ok = true;
-			return 0;
-		}
-	}
-
-	/*
-	 * We don't permit modules to be loaded into the trusted kernels
-	 * without a valid signature on them, but if we're not enforcing,
-	 * certain errors are non-fatal.
-	 */
-	switch (err) {
-	case -ENODATA:
-		reason = "unsigned module";
-		break;
-	case -ENOPKG:
-		reason = "module with unsupported crypto";
-		break;
-	case -ENOKEY:
-		reason = "module with unavailable key";
-		break;
-
-	default:
-		/*
-		 * All other errors are fatal, including lack of memory,
-		 * unparseable signatures, and signature check failures --
-		 * even if signatures aren't required.
-		 */
-		return err;
-	}
-
-	if (is_module_sig_enforced()) {
-		pr_notice("Loading of %s is rejected\n", reason);
-		return -EKEYREJECTED;
-	}
-
-	return security_locked_down(LOCKDOWN_MODULE_SIGNATURE);
-}
-#else /* !CONFIG_MODULE_SIG */
-static int module_sig_check(struct load_info *info, int flags)
-{
-	return 0;
-}
-#endif /* !CONFIG_MODULE_SIG */
-
 static int validate_section_offset(struct load_info *info, Elf_Shdr *shdr)
 {
 #if defined(CONFIG_64BIT)
diff --git a/kernel/module/signing.c b/kernel/module/signing.c
index 8aeb6d2ee94b..ff41541e982a 100644
--- a/kernel/module/signing.c
+++ b/kernel/module/signing.c
@@ -11,9 +11,28 @@
 #include <linux/module_signature.h>
 #include <linux/string.h>
 #include <linux/verification.h>
+#include <linux/security.h>
 #include <crypto/public_key.h>
 #include "internal.h"
 
+static bool sig_enforce = IS_ENABLED(CONFIG_MODULE_SIG_FORCE);
+module_param(sig_enforce, bool_enable_only, 0644);
+
+/*
+ * Export sig_enforce kernel cmdline parameter to allow other subsystems rely
+ * on that instead of directly to CONFIG_MODULE_SIG_FORCE config.
+ */
+bool is_module_sig_enforced(void)
+{
+	return sig_enforce;
+}
+EXPORT_SYMBOL(is_module_sig_enforced);
+
+void set_module_sig_enforced(void)
+{
+	sig_enforce = true;
+}
+
 /*
  * Verify the signature on a module.
  */
@@ -43,3 +62,59 @@ int mod_verify_sig(const void *mod, struct load_info *info)
 				      VERIFYING_MODULE_SIGNATURE,
 				      NULL, NULL);
 }
+
+int module_sig_check(struct load_info *info, int flags)
+{
+	int err = -ENODATA;
+	const unsigned long markerlen = sizeof(MODULE_SIG_STRING) - 1;
+	const char *reason;
+	const void *mod = info->hdr;
+
+	/*
+	 * Require flags == 0, as a module with version information
+	 * removed is no longer the module that was signed
+	 */
+	if (flags == 0 &&
+	    info->len > markerlen &&
+	    memcmp(mod + info->len - markerlen, MODULE_SIG_STRING, markerlen) == 0) {
+		/* We truncate the module to discard the signature */
+		info->len -= markerlen;
+		err = mod_verify_sig(mod, info);
+		if (!err) {
+			info->sig_ok = true;
+			return 0;
+		}
+	}
+
+	/*
+	 * We don't permit modules to be loaded into the trusted kernels
+	 * without a valid signature on them, but if we're not enforcing,
+	 * certain errors are non-fatal.
+	 */
+	switch (err) {
+	case -ENODATA:
+		reason = "unsigned module";
+		break;
+	case -ENOPKG:
+		reason = "module with unsupported crypto";
+		break;
+	case -ENOKEY:
+		reason = "module with unavailable key";
+		break;
+
+	default:
+		/*
+		 * All other errors are fatal, including lack of memory,
+		 * unparseable signatures, and signature check failures --
+		 * even if signatures aren't required.
+		 */
+		return err;
+	}
+
+	if (is_module_sig_enforced()) {
+		pr_notice("Loading of %s is rejected\n", reason);
+		return -EKEYREJECTED;
+	}
+
+	return security_locked_down(LOCKDOWN_MODULE_SIGNATURE);
+}
-- 
2.34.1

