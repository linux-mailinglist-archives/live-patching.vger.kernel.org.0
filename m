Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82B9230BDF5
	for <lists+live-patching@lfdr.de>; Tue,  2 Feb 2021 13:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhBBMPs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Feb 2021 07:15:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbhBBMP0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Feb 2021 07:15:26 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A30C061797;
        Tue,  2 Feb 2021 04:14:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=xtOBHx8u/yIi0h5QA3AKNqpliwP+YVemoVRuq3Ek/8o=; b=Px22+N3ZKzyz9x77FQBhRCZGqX
        S1YwbXLHPbMYYe8n3loAymRJDpw49O8TCW77f12htkWSE1WgJZi+MDZaQjlrAm4Xfp0ayrdgLfYY3
        udyLpJTNWDUYtWOMgEtNoeBhlFVkwHRdP9f7J8hVQ/bpvtrlKyd8zCinCDri4udXTlFRfnuYDUkP+
        wI08k43KEKZ71rMkqGxPwIDjt2g5OQFmpgaW1GCrHwnAWPzPEdSWGYrJMA40P51yUBGpRP3mv+jvH
        AcF4HUQLtuz47iCxAao9JbUf42q14lxqkTnA3C5woO8wIgh8MpfUAglt4o8LeYAs5tO0+cRYGYcOx
        hj22v0iQ==;
Received: from [2001:4bb8:198:6bf4:7f38:755e:a6e0:73e9] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6uZI-00FANT-Fx; Tue, 02 Feb 2021 12:14:05 +0000
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
Subject: [PATCH 11/13] module: move struct symsearch to module.c
Date:   Tue,  2 Feb 2021 13:13:32 +0100
Message-Id: <20210202121334.1361503-12-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202121334.1361503-1-hch@lst.de>
References: <20210202121334.1361503-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

struct symsearch is only used inside of module.h, so move the definition
out of module.h.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/module.h | 11 -----------
 kernel/module.c        | 11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 0f360c48fe92a6..da0f5966ee80c9 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -587,17 +587,6 @@ static inline bool within_module(unsigned long addr, const struct module *mod)
 /* Search for module by name: must be in a RCU-sched critical section. */
 struct module *find_module(const char *name);
 
-struct symsearch {
-	const struct kernel_symbol *start, *stop;
-	const s32 *crcs;
-	enum mod_license {
-		NOT_GPL_ONLY,
-		GPL_ONLY,
-		WILL_BE_GPL_ONLY,
-	} license;
-	bool unused;
-};
-
 /* Returns 0 and fills in value, defined and namebuf, or -ERANGE if
    symnum out of range. */
 int module_get_kallsym(unsigned int symnum, unsigned long *value, char *type,
diff --git a/kernel/module.c b/kernel/module.c
index 02d1dd9bfc0a90..7a4bce8507b96f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -428,6 +428,17 @@ extern const s32 __start___kcrctab_unused_gpl[];
 #define symversion(base, idx) ((base != NULL) ? ((base) + (idx)) : NULL)
 #endif
 
+struct symsearch {
+	const struct kernel_symbol *start, *stop;
+	const s32 *crcs;
+	enum mod_license {
+		NOT_GPL_ONLY,
+		GPL_ONLY,
+		WILL_BE_GPL_ONLY,
+	} license;
+	bool unused;
+};
+
 struct find_symbol_arg {
 	/* Input */
 	const char *name;
-- 
2.29.2

