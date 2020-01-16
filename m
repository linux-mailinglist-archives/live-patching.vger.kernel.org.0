Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B00D13DED8
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2020 16:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgAPPc3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Jan 2020 10:32:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:53756 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgAPPcQ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Jan 2020 10:32:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 289C86A2E5;
        Thu, 16 Jan 2020 15:32:13 +0000 (UTC)
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
Subject: [PATCH 2/4] livepatch/selftest: Clean up shadow variable names and type
Date:   Thu, 16 Jan 2020 16:31:43 +0100
Message-Id: <20200116153145.2392-3-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200116153145.2392-1-pmladek@suse.com>
References: <20200116153145.2392-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The shadow variable selftest is quite tricky. Especially it is problematic
to understand what values are stored, returned, and printed.

Make it easier to understand by using "int *var, **sv" variables
consistently everywhere instead of the generic "void *", "ret",
and "ctor_data".

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 lib/livepatch/test_klp_shadow_vars.c | 93 ++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 41 deletions(-)

diff --git a/lib/livepatch/test_klp_shadow_vars.c b/lib/livepatch/test_klp_shadow_vars.c
index fe5c413efe96..4e94f46234e8 100644
--- a/lib/livepatch/test_klp_shadow_vars.c
+++ b/lib/livepatch/test_klp_shadow_vars.c
@@ -60,36 +60,43 @@ static int ptr_id(void *ptr)
  */
 static void *shadow_get(void *obj, unsigned long id)
 {
-	void *ret = klp_shadow_get(obj, id);
+	int **sv;
 
+	sv = klp_shadow_get(obj, id);
 	pr_info("klp_%s(obj=PTR%d, id=0x%lx) = PTR%d\n",
-		__func__, ptr_id(obj), id, ptr_id(ret));
+		__func__, ptr_id(obj), id, ptr_id(sv));
 
-	return ret;
+	return sv;
 }
 
 static void *shadow_alloc(void *obj, unsigned long id, size_t size,
 			  gfp_t gfp_flags, klp_shadow_ctor_t ctor,
 			  void *ctor_data)
 {
-	void *ret = klp_shadow_alloc(obj, id, size, gfp_flags, ctor,
-				     ctor_data);
+	int *var = ctor_data;
+	int **sv;
+
+	sv = klp_shadow_alloc(obj, id, size, gfp_flags, ctor, var);
 	pr_info("klp_%s(obj=PTR%d, id=0x%lx, size=%zx, gfp_flags=%pGg), ctor=PTR%d, ctor_data=PTR%d = PTR%d\n",
 		__func__, ptr_id(obj), id, size, &gfp_flags, ptr_id(ctor),
-		ptr_id(ctor_data), ptr_id(ret));
-	return ret;
+		ptr_id(var), ptr_id(sv));
+
+	return sv;
 }
 
 static void *shadow_get_or_alloc(void *obj, unsigned long id, size_t size,
 				 gfp_t gfp_flags, klp_shadow_ctor_t ctor,
 				 void *ctor_data)
 {
-	void *ret = klp_shadow_get_or_alloc(obj, id, size, gfp_flags, ctor,
-					    ctor_data);
+	int *var = ctor_data;
+	int **sv;
+
+	sv = klp_shadow_get_or_alloc(obj, id, size, gfp_flags, ctor, var);
 	pr_info("klp_%s(obj=PTR%d, id=0x%lx, size=%zx, gfp_flags=%pGg), ctor=PTR%d, ctor_data=PTR%d = PTR%d\n",
 		__func__, ptr_id(obj), id, size, &gfp_flags, ptr_id(ctor),
-		ptr_id(ctor_data), ptr_id(ret));
-	return ret;
+		ptr_id(var), ptr_id(sv));
+
+	return sv;
 }
 
 static void shadow_free(void *obj, unsigned long id, klp_shadow_dtor_t dtor)
@@ -110,18 +117,22 @@ static void shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
 /* Shadow variable constructor - remember simple pointer data */
 static int shadow_ctor(void *obj, void *shadow_data, void *ctor_data)
 {
-	int **shadow_int = shadow_data;
-	*shadow_int = ctor_data;
+	int **sv = shadow_data;
+	int *var = ctor_data;
+
+	*sv = var;
 	pr_info("%s: PTR%d -> PTR%d\n",
-		__func__, ptr_id(shadow_int), ptr_id(ctor_data));
+		__func__, ptr_id(sv), ptr_id(var));
 
 	return 0;
 }
 
 static void shadow_dtor(void *obj, void *shadow_data)
 {
+	int **sv = shadow_data;
+
 	pr_info("%s(obj=PTR%d, shadow_data=PTR%d)\n",
-		__func__, ptr_id(obj), ptr_id(shadow_data));
+		__func__, ptr_id(obj), ptr_id(sv));
 }
 
 static int test_klp_shadow_vars_init(void)
@@ -134,7 +145,7 @@ static int test_klp_shadow_vars_init(void)
 	int var1, var2, var3, var4;
 	int **sv1, **sv2, **sv3, **sv4;
 
-	void *ret;
+	int **sv;
 
 	ptr_id(NULL);
 	ptr_id(&var1);
@@ -146,8 +157,8 @@ static int test_klp_shadow_vars_init(void)
 	 * With an empty shadow variable hash table, expect not to find
 	 * any matches.
 	 */
-	ret = shadow_get(obj, id);
-	if (!ret)
+	sv = shadow_get(obj, id);
+	if (!sv)
 		pr_info("  got expected NULL result\n");
 
 	/*
@@ -169,23 +180,23 @@ static int test_klp_shadow_vars_init(void)
 	 * Verify we can find our new shadow variables and that they point
 	 * to expected data.
 	 */
-	ret = shadow_get(obj, id);
-	if (!ret)
+	sv = shadow_get(obj, id);
+	if (!sv)
 		return -EINVAL;
-	if (ret == sv1 && *sv1 == &var1)
+	if (sv == sv1 && *sv1 == &var1)
 		pr_info("  got expected PTR%d -> PTR%d result\n",
 			ptr_id(sv1), ptr_id(*sv1));
 
-	ret = shadow_get(obj + 1, id);
-	if (!ret)
+	sv = shadow_get(obj + 1, id);
+	if (!sv)
 		return -EINVAL;
-	if (ret == sv2 && *sv2 == &var2)
+	if (sv == sv2 && *sv2 == &var2)
 		pr_info("  got expected PTR%d -> PTR%d result\n",
 			ptr_id(sv2), ptr_id(*sv2));
-	ret = shadow_get(obj, id + 1);
-	if (!ret)
+	sv = shadow_get(obj, id + 1);
+	if (!sv)
 		return -EINVAL;
-	if (ret == sv3 && *sv3 == &var3)
+	if (sv == sv3 && *sv3 == &var3)
 		pr_info("  got expected PTR%d -> PTR%d result\n",
 			ptr_id(sv3), ptr_id(*sv3));
 
@@ -197,10 +208,10 @@ static int test_klp_shadow_vars_init(void)
 	if (!sv4)
 		return -ENOMEM;
 
-	ret = shadow_get_or_alloc(obj + 2, id, size, gfp_flags, shadow_ctor, &var4);
-	if (!ret)
+	sv = shadow_get_or_alloc(obj + 2, id, size, gfp_flags, shadow_ctor, &var4);
+	if (!sv)
 		return -EINVAL;
-	if (ret == sv4 && *sv4 == &var4)
+	if (sv == sv4 && *sv4 == &var4)
 		pr_info("  got expected PTR%d -> PTR%d result\n",
 			ptr_id(sv4), ptr_id(*sv4));
 
@@ -209,27 +220,27 @@ static int test_klp_shadow_vars_init(void)
 	 * longer find them.
 	 */
 	shadow_free(obj, id, shadow_dtor);			/* sv1 */
-	ret = shadow_get(obj, id);
-	if (!ret)
+	sv = shadow_get(obj, id);
+	if (!sv)
 		pr_info("  got expected NULL result\n");
 
 	shadow_free(obj + 1, id, shadow_dtor);			/* sv2 */
-	ret = shadow_get(obj + 1, id);
-	if (!ret)
+	sv = shadow_get(obj + 1, id);
+	if (!sv)
 		pr_info("  got expected NULL result\n");
 
 	shadow_free(obj + 2, id, shadow_dtor);			/* sv4 */
-	ret = shadow_get(obj + 2, id);
-	if (!ret)
+	sv = shadow_get(obj + 2, id);
+	if (!sv)
 		pr_info("  got expected NULL result\n");
 
 	/*
 	 * We should still find an <id+1> variable.
 	 */
-	ret = shadow_get(obj, id + 1);
-	if (!ret)
+	sv = shadow_get(obj, id + 1);
+	if (!sv)
 		return -EINVAL;
-	if (ret == sv3 && *sv3 == &var3)
+	if (sv == sv3 && *sv3 == &var3)
 		pr_info("  got expected PTR%d -> PTR%d result\n",
 			ptr_id(sv3), ptr_id(*sv3));
 
@@ -237,8 +248,8 @@ static int test_klp_shadow_vars_init(void)
 	 * Free all the <id+1> variables, too.
 	 */
 	shadow_free_all(id + 1, shadow_dtor);			/* sv3 */
-	ret = shadow_get(obj, id);
-	if (!ret)
+	sv = shadow_get(obj, id);
+	if (!sv)
 		pr_info("  shadow_get() got expected NULL result\n");
 
 
-- 
2.16.4

