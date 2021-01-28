Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EEA307DB1
	for <lists+live-patching@lfdr.de>; Thu, 28 Jan 2021 19:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231861AbhA1SR5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 28 Jan 2021 13:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231829AbhA1SPw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 28 Jan 2021 13:15:52 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFC7C0613ED;
        Thu, 28 Jan 2021 10:15:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=0PLW/Fa3jZYHwDqK+8TeRrW7s0mvQirSQmldMFP6fgw=; b=FbDbTpTKwN2+U/znUzueFLSor/
        bZDiPljN5K0NDUtuVKgPFHeyvLjIy00tUE4nvWCq8eMo6bEkgYcXYFeKwPRgXPuDOnDEF1G1qSL32
        g9OnDsuenwVOm8ycy4dHMsCRLbmjoDFB6SpNFs/NhoXJI6Wh/NMSew47JWEJUazc1s/1KqMiFStMC
        I3eWj20LpLMmLLSo9Oi3glxmGRE6akSC7q12Fsk+6nRxMqFzlO4u+F8tanyQtXSiarl3htLqKas9m
        S+KYMo7/nAdHqfZO3nlv5zZjnTyfyj9vogwHRdQGBg4Z4/wr4XdhAUPDvST5NqY8jwAHlZbEu7SV2
        BKH3mhSw==;
Received: from [2001:4bb8:198:6bf4:e052:196b:7e32:37d9] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l5Bob-008nrW-1e; Thu, 28 Jan 2021 18:14:47 +0000
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
Date:   Thu, 28 Jan 2021 19:14:11 +0100
Message-Id: <20210128181421.2279-4-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128181421.2279-1-hch@lst.de>
References: <20210128181421.2279-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

find_module is not used by modular code any more, and random driver code
has no business calling it to start with.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

