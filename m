Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BBF13DED3
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2020 16:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgAPPcR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Jan 2020 10:32:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:53794 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbgAPPcQ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Jan 2020 10:32:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3971B6A2E4;
        Thu, 16 Jan 2020 15:32:15 +0000 (UTC)
From:   Petr Mladek <pmladek@suse.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.com>
Subject: [PATCH 4/4] livepatch: Handle allocation failure in the sample of shadow variable API
Date:   Thu, 16 Jan 2020 16:31:45 +0100
Message-Id: <20200116153145.2392-5-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200116153145.2392-1-pmladek@suse.com>
References: <20200116153145.2392-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

klp_shadow_alloc() is not handled in the sample of shadow variable API.
It is not strictly necessary because livepatch_fix1_dummy_free() is
able to handle the potential failure. But it is an example and it should
use the API a clean way.

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 samples/livepatch/livepatch-shadow-fix1.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/samples/livepatch/livepatch-shadow-fix1.c b/samples/livepatch/livepatch-shadow-fix1.c
index de0363b288a7..918ce17b43fd 100644
--- a/samples/livepatch/livepatch-shadow-fix1.c
+++ b/samples/livepatch/livepatch-shadow-fix1.c
@@ -66,6 +66,7 @@ static struct dummy *livepatch_fix1_dummy_alloc(void)
 {
 	struct dummy *d;
 	int *leak;
+	int **shadow_leak;
 
 	d = kzalloc(sizeof(*d), GFP_KERNEL);
 	if (!d)
@@ -80,18 +81,27 @@ static struct dummy *livepatch_fix1_dummy_alloc(void)
 	 * pointer to handle resource release.
 	 */
 	leak = kzalloc(sizeof(*leak), GFP_KERNEL);
-	if (!leak) {
-		kfree(d);
-		return NULL;
+	if (!leak)
+		goto err_leak;
+
+	shadow_leak = klp_shadow_alloc(d, SV_LEAK, sizeof(leak), GFP_KERNEL,
+				       shadow_leak_ctor, &leak);
+	if (!shadow_leak) {
+		pr_err("%s: failed to allocate shadow variable for the leaking pointer: dummy @ %p, leak @ %p\n",
+		       __func__, d, leak);
+		goto err_shadow;
 	}
 
-	klp_shadow_alloc(d, SV_LEAK, sizeof(leak), GFP_KERNEL,
-			 shadow_leak_ctor, &leak);
-
 	pr_info("%s: dummy @ %p, expires @ %lx\n",
 		__func__, d, d->jiffies_expire);
 
 	return d;
+
+err_shadow:
+	kfree(leak);
+err_leak:
+	kfree(d);
+	return NULL;
 }
 
 static void livepatch_fix1_dummy_leak_dtor(void *obj, void *shadow_data)
-- 
2.16.4

