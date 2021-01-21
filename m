Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2A8D2FE46B
	for <lists+live-patching@lfdr.de>; Thu, 21 Jan 2021 08:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbhAUHzE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jan 2021 02:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727776AbhAUHyy (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jan 2021 02:54:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4C4C0613CF;
        Wed, 20 Jan 2021 23:54:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=GGrjojACjhG+8+TH5sgivGQzb3BJ/eSauJM3q5KfBTs=; b=Ktv0btKAweC7bgWiS0Tq9kQcDq
        lur3JwNvnp9BIFyDhZcmUI1H3pxmjd/ZLvA2pRyULJoTJauKkKBe3DSoBTDJQV1JqQkoFJq9Bggb/
        9fo/7N4p/S2mX+gKVtR2JCvftPc1c+niZwyH3x8iQYowJRjI1y9N55LbKj6NZXHZ9lNyh1bcQc0is
        82naw907YI2rbhBZ6CTkkzH9BFv9pwJu+HRnB8QYUDtNr1CDTSoaXl2Sx7RwAd218qaJbpAr0dal1
        UFAfSxVf8j/5ACKYD7rhFBOTJkxhehMlzgqP21VL+D/N0FubU73KdhAX/7mIcfo+iJ4E5TJ9qGcpg
        z/nWA2Ug==;
Received: from [2001:4bb8:188:1954:d5b3:2657:287:e45f] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l2Umc-00Gm60-80; Thu, 21 Jan 2021 07:53:35 +0000
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
Subject: [PATCH 03/13] livepatch: refactor klp_init_object
Date:   Thu, 21 Jan 2021 08:49:49 +0100
Message-Id: <20210121074959.313333-4-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210121074959.313333-1-hch@lst.de>
References: <20210121074959.313333-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Merge three calls to klp_is_module (including one hidden inside
klp_find_object_module) into a single one to simplify the code a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 kernel/livepatch/core.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index f76fdb9255323d..a7f625dc24add3 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -54,9 +54,6 @@ static void klp_find_object_module(struct klp_object *obj)
 {
 	struct module *mod;
 
-	if (!klp_is_module(obj))
-		return;
-
 	mutex_lock(&module_mutex);
 	/*
 	 * We do not want to block removal of patched modules and therefore
@@ -73,7 +70,6 @@ static void klp_find_object_module(struct klp_object *obj)
 	 */
 	if (mod && mod->klp_alive)
 		obj->mod = mod;
-
 	mutex_unlock(&module_mutex);
 }
 
@@ -823,15 +819,19 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
 	int ret;
 	const char *name;
 
-	if (klp_is_module(obj) && strlen(obj->name) >= MODULE_NAME_LEN)
-		return -EINVAL;
-
 	obj->patched = false;
 	obj->mod = NULL;
 
-	klp_find_object_module(obj);
+	if (klp_is_module(obj)) {
+		if (strlen(obj->name) >= MODULE_NAME_LEN)
+			return -EINVAL;
+		name = obj->name;
+
+		klp_find_object_module(obj);
+	} else {
+		name = "vmlinux";
+	}
 
-	name = klp_is_module(obj) ? obj->name : "vmlinux";
 	ret = kobject_add(&obj->kobj, &patch->kobj, "%s", name);
 	if (ret)
 		return ret;
-- 
2.29.2

