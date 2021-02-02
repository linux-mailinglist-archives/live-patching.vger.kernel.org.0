Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B34430BE02
	for <lists+live-patching@lfdr.de>; Tue,  2 Feb 2021 13:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhBBMQz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Feb 2021 07:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhBBMPU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Feb 2021 07:15:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E19C06178C;
        Tue,  2 Feb 2021 04:14:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=8NxK820uFUydC9QGaqCC8FKN2i1E7yLrklCQP+JUF/Y=; b=Nvd24owxzlLlfxwU5CdyHv0gP6
        v2r+G5RzDJ0QgLCJJp3dS/1GGIXWUJPZb5TyM3Ju2IKb6tFlgAZFLmNdfDUNgQ4GLdNKrf1AaelKe
        A5RRzqmBjgw624Cttt1t5foDV45qMKnN5Ccz/g95NIrz3jZCzd394/KpbkWzMgrqdCUlaotFstKaP
        g7IEuLkgfi3mpPFsh6+vpVczTsSPYnFUQVp4ugAsNDaO6cX7kZWj1XUxTEO4AuqwidwhMDGuESv/U
        1q3xWs5eqwYIFNjb+wOyT9V3PIA/oyWAdDF6yHKB6WQO4pKWPRxl+ggc479VBRGUtNLPP3EDR/iP0
        mCSF3Qjg==;
Received: from [2001:4bb8:198:6bf4:7f38:755e:a6e0:73e9] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6uZB-00FAMg-7C; Tue, 02 Feb 2021 12:13:57 +0000
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
Subject: [PATCH 08/13] module: remove each_symbol_in_section
Date:   Tue,  2 Feb 2021 13:13:29 +0100
Message-Id: <20210202121334.1361503-9-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202121334.1361503-1-hch@lst.de>
References: <20210202121334.1361503-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

each_symbol_in_section just contains a trivial loop over its arguments.
Just open code the loop in the two callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/module.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 1635656d47654a..b050c836a0061f 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -428,30 +428,13 @@ extern const s32 __start___kcrctab_unused_gpl[];
 #define symversion(base, idx) ((base != NULL) ? ((base) + (idx)) : NULL)
 #endif
 
-static bool each_symbol_in_section(const struct symsearch *arr,
-				   unsigned int arrsize,
-				   struct module *owner,
-				   bool (*fn)(const struct symsearch *syms,
-					      struct module *owner,
-					      void *data),
-				   void *data)
-{
-	unsigned int j;
-
-	for (j = 0; j < arrsize; j++) {
-		if (fn(&arr[j], owner, data))
-			return true;
-	}
-
-	return false;
-}
-
 /* Returns true as soon as fn returns true, otherwise false. */
 static bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
 				    struct module *owner,
 				    void *data),
 			 void *data)
 {
+	unsigned int i;
 	struct module *mod;
 	static const struct symsearch arr[] = {
 		{ __start___ksymtab, __stop___ksymtab, __start___kcrctab,
@@ -474,8 +457,9 @@ static bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
 
 	module_assert_mutex_or_preempt();
 
-	if (each_symbol_in_section(arr, ARRAY_SIZE(arr), NULL, fn, data))
-		return true;
+	for (i = 0; i < ARRAY_SIZE(arr); i++)
+		if (fn(&arr[i], NULL, data))
+			return true;
 
 	list_for_each_entry_rcu(mod, &modules, list,
 				lockdep_is_held(&module_mutex)) {
@@ -504,8 +488,9 @@ static bool each_symbol_section(bool (*fn)(const struct symsearch *arr,
 		if (mod->state == MODULE_STATE_UNFORMED)
 			continue;
 
-		if (each_symbol_in_section(arr, ARRAY_SIZE(arr), mod, fn, data))
-			return true;
+		for (i = 0; i < ARRAY_SIZE(arr); i++)
+			if (fn(&arr[i], mod, data))
+				return true;
 	}
 	return false;
 }
-- 
2.29.2

