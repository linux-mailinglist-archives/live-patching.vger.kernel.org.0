Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CBF30BDE4
	for <lists+live-patching@lfdr.de>; Tue,  2 Feb 2021 13:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhBBMOl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Feb 2021 07:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbhBBMOk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Feb 2021 07:14:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B28FC0613D6;
        Tue,  2 Feb 2021 04:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=d+RvHHepaZ/BO9t/Sofhl4osQy8aQseeLaFTeY79feo=; b=UFXUzoMnrYHFApA5h87LexqFa+
        foEjWfevlTzvzvNgdyFxOccwQp0QsfXh1HVg4rgqUZGFWeJSIhjwkFWEVhM0FCCZUXeIAYuHWr9zA
        J7pRt39JkHnnVGcFHYMVVjK+52uHeEsz0pI66KxpI0gFcCYiAM27eP/eLJ4qYP8OjXimXk72tNlD2
        hw78Ru5anrj28RpFxnxnko3+tKbRRM3SSeyJWt+2XvboA6/5CX+NYy9ps7aGaK5YkuB7Ysgj3LIdM
        w1v6Ron/0Xdoe/76EETL/k99oX6YNolyXOVsjguthSUa1+5VxPZiGacwSECy6Fl8XOl5YWcjkwCg+
        sEnFOl9Q==;
Received: from [2001:4bb8:198:6bf4:7f38:755e:a6e0:73e9] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l6uYx-00FALP-M3; Tue, 02 Feb 2021 12:13:44 +0000
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
Subject: [PATCH 03/13] module: unexport find_module and module_mutex
Date:   Tue,  2 Feb 2021 13:13:24 +0100
Message-Id: <20210202121334.1361503-4-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210202121334.1361503-1-hch@lst.de>
References: <20210202121334.1361503-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

find_module is not used by modular code any more, and random driver code
has no business calling it to start with.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
---
 kernel/module.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 4bf30e4b3eaaa1..981302f616b411 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -88,7 +88,6 @@
  * (delete and add uses RCU list operations).
  */
 DEFINE_MUTEX(module_mutex);
-EXPORT_SYMBOL_GPL(module_mutex);
 static LIST_HEAD(modules);
 
 /* Work queue for freeing init sections in success case */
@@ -672,7 +671,6 @@ struct module *find_module(const char *name)
 	module_assert_mutex();
 	return find_module_all(name, strlen(name), false);
 }
-EXPORT_SYMBOL_GPL(find_module);
 
 #ifdef CONFIG_SMP
 
-- 
2.29.2

