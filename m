Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74337307DAD
	for <lists+live-patching@lfdr.de>; Thu, 28 Jan 2021 19:19:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbhA1SRY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 28 Jan 2021 13:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbhA1SPv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 28 Jan 2021 13:15:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9663C061573;
        Thu, 28 Jan 2021 10:15:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=Dfm4t6IzWCBDJPMpGdSuNSi4QcgFqA2qDwRcbyxPWlk=; b=sFeJTQ+OTqxF4TXdv47v917Xko
        yfzTFhv4KsYROvCFzVPjUyIE0EwT/HTki4yYi66S+qKtBalhaWPqLCWBMrhi3oc7Y83hXNBJbhLrW
        G/N/8oTfQxS1ZxRjbclpOKvBL5OZT5mgni2tJpTeVZXUnQlJk/LEEktpeN+Aoyj0N0ua4fbUnULS4
        pRhm7yB9zVzOcWwHGgi1sUiyPO8V8iq5UcBaJ8/KE2/ww09oIuceqAIt4R9vG/W7Pg2PRhR9/6t8G
        Xt0cLBiQNSHSW8MzGboNTD45wVOqSrSOown2jBXWeftN/UbhIkOQVJrtyXv220uzQfAv1+wbDMcps
        ZVMnkxrw==;
Received: from [2001:4bb8:198:6bf4:e052:196b:7e32:37d9] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1l5BoN-008nqv-6F; Thu, 28 Jan 2021 18:14:32 +0000
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
Subject: [PATCH 01/13] powerpc/powernv: remove get_cxl_module
Date:   Thu, 28 Jan 2021 19:14:09 +0100
Message-Id: <20210128181421.2279-2-hch@lst.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128181421.2279-1-hch@lst.de>
References: <20210128181421.2279-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The static inline get_cxl_module function is entirely unused since commit
8bf6b91a5125a ("Revert "powerpc/powernv: Add support for the cxl kernel
api on the real phb"), so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
---
 arch/powerpc/platforms/powernv/pci-cxl.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-cxl.c b/arch/powerpc/platforms/powernv/pci-cxl.c
index 8c739c94ed28d6..53172862d23bd3 100644
--- a/arch/powerpc/platforms/powernv/pci-cxl.c
+++ b/arch/powerpc/platforms/powernv/pci-cxl.c
@@ -150,25 +150,3 @@ int pnv_cxl_ioda_msi_setup(struct pci_dev *dev, unsigned int hwirq,
 	return 0;
 }
 EXPORT_SYMBOL(pnv_cxl_ioda_msi_setup);
-
-#if IS_MODULE(CONFIG_CXL)
-static inline int get_cxl_module(void)
-{
-	struct module *cxl_module;
-
-	mutex_lock(&module_mutex);
-
-	cxl_module = find_module("cxl");
-	if (cxl_module)
-		__module_get(cxl_module);
-
-	mutex_unlock(&module_mutex);
-
-	if (!cxl_module)
-		return -ENODEV;
-
-	return 0;
-}
-#else
-static inline int get_cxl_module(void) { return 0; }
-#endif
-- 
2.29.2

