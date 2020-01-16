Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B697113DED4
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2020 16:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgAPPcS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Jan 2020 10:32:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:53782 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726928AbgAPPcS (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Jan 2020 10:32:18 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3964C6A2E3;
        Thu, 16 Jan 2020 15:32:14 +0000 (UTC)
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
Subject: [PATCH 3/4] livepatch/samples/selftest: Use klp_shadow_alloc() API correctly
Date:   Thu, 16 Jan 2020 16:31:44 +0100
Message-Id: <20200116153145.2392-4-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200116153145.2392-1-pmladek@suse.com>
References: <20200116153145.2392-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The commit e91c2518a5d22a ("livepatch: Initialize shadow variables
safely by a custom callback") leads to the following static checker
warning:

  samples/livepatch/livepatch-shadow-fix1.c:86 livepatch_fix1_dummy_alloc()
  error: 'klp_shadow_alloc()' 'leak' too small (4 vs 8)

It is because klp_shadow_alloc() is used a wrong way:

  int *leak;
  shadow_leak = klp_shadow_alloc(d, SV_LEAK, sizeof(leak), GFP_KERNEL,
				 shadow_leak_ctor, leak);

The code is supposed to store the "leak" pointer into the shadow variable.
3rd parameter correctly passes size of the data (size of pointer). But
the 5th parameter is wrong. It should pass pointer to the data (pointer
to the pointer) but it passes the pointer directly.

It works because shadow_leak_ctor() handle "ctor_data" as the data
instead of pointer to the data. But it is semantically wrong and
confusing.

The same problem is also in the module used by selftests. In this case,
"pvX" variables are introduced. They represent the data stored in
the shadow variables.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 lib/livepatch/test_klp_shadow_vars.c      | 52 ++++++++++++++++++-------------
 samples/livepatch/livepatch-shadow-fix1.c |  9 ++++--
 2 files changed, 36 insertions(+), 25 deletions(-)

diff --git a/lib/livepatch/test_klp_shadow_vars.c b/lib/livepatch/test_klp_shadow_vars.c
index 4e94f46234e8..f0b5a1d24e55 100644
--- a/lib/livepatch/test_klp_shadow_vars.c
+++ b/lib/livepatch/test_klp_shadow_vars.c
@@ -73,13 +73,13 @@ static void *shadow_alloc(void *obj, unsigned long id, size_t size,
 			  gfp_t gfp_flags, klp_shadow_ctor_t ctor,
 			  void *ctor_data)
 {
-	int *var = ctor_data;
+	int **var = ctor_data;
 	int **sv;
 
 	sv = klp_shadow_alloc(obj, id, size, gfp_flags, ctor, var);
 	pr_info("klp_%s(obj=PTR%d, id=0x%lx, size=%zx, gfp_flags=%pGg), ctor=PTR%d, ctor_data=PTR%d = PTR%d\n",
 		__func__, ptr_id(obj), id, size, &gfp_flags, ptr_id(ctor),
-		ptr_id(var), ptr_id(sv));
+		ptr_id(*var), ptr_id(sv));
 
 	return sv;
 }
@@ -88,13 +88,13 @@ static void *shadow_get_or_alloc(void *obj, unsigned long id, size_t size,
 				 gfp_t gfp_flags, klp_shadow_ctor_t ctor,
 				 void *ctor_data)
 {
-	int *var = ctor_data;
+	int **var = ctor_data;
 	int **sv;
 
 	sv = klp_shadow_get_or_alloc(obj, id, size, gfp_flags, ctor, var);
 	pr_info("klp_%s(obj=PTR%d, id=0x%lx, size=%zx, gfp_flags=%pGg), ctor=PTR%d, ctor_data=PTR%d = PTR%d\n",
 		__func__, ptr_id(obj), id, size, &gfp_flags, ptr_id(ctor),
-		ptr_id(var), ptr_id(sv));
+		ptr_id(*var), ptr_id(sv));
 
 	return sv;
 }
@@ -118,11 +118,14 @@ static void shadow_free_all(unsigned long id, klp_shadow_dtor_t dtor)
 static int shadow_ctor(void *obj, void *shadow_data, void *ctor_data)
 {
 	int **sv = shadow_data;
-	int *var = ctor_data;
+	int **var = ctor_data;
 
-	*sv = var;
+	if (!var)
+		return -EINVAL;
+
+	*sv = *var;
 	pr_info("%s: PTR%d -> PTR%d\n",
-		__func__, ptr_id(sv), ptr_id(var));
+		__func__, ptr_id(sv), ptr_id(*var));
 
 	return 0;
 }
@@ -139,19 +142,24 @@ static int test_klp_shadow_vars_init(void)
 {
 	void *obj			= THIS_MODULE;
 	int id			= 0x1234;
-	size_t size		= sizeof(int *);
 	gfp_t gfp_flags		= GFP_KERNEL;
 
 	int var1, var2, var3, var4;
+	int *pv1, *pv2, *pv3, *pv4;
 	int **sv1, **sv2, **sv3, **sv4;
 
 	int **sv;
 
+	pv1 = &var1;
+	pv2 = &var2;
+	pv3 = &var3;
+	pv4 = &var4;
+
 	ptr_id(NULL);
-	ptr_id(&var1);
-	ptr_id(&var2);
-	ptr_id(&var3);
-	ptr_id(&var4);
+	ptr_id(pv1);
+	ptr_id(pv2);
+	ptr_id(pv3);
+	ptr_id(pv4);
 
 	/*
 	 * With an empty shadow variable hash table, expect not to find
@@ -164,15 +172,15 @@ static int test_klp_shadow_vars_init(void)
 	/*
 	 * Allocate a few shadow variables with different <obj> and <id>.
 	 */
-	sv1 = shadow_alloc(obj, id, size, gfp_flags, shadow_ctor, &var1);
+	sv1 = shadow_alloc(obj, id, sizeof(pv1), gfp_flags, shadow_ctor, &pv1);
 	if (!sv1)
 		return -ENOMEM;
 
-	sv2 = shadow_alloc(obj + 1, id, size, gfp_flags, shadow_ctor, &var2);
+	sv2 = shadow_alloc(obj + 1, id, sizeof(pv2), gfp_flags, shadow_ctor, &pv2);
 	if (!sv2)
 		return -ENOMEM;
 
-	sv3 = shadow_alloc(obj, id + 1, size, gfp_flags, shadow_ctor, &var3);
+	sv3 = shadow_alloc(obj, id + 1, sizeof(pv3), gfp_flags, shadow_ctor, &pv3);
 	if (!sv3)
 		return -ENOMEM;
 
@@ -183,20 +191,20 @@ static int test_klp_shadow_vars_init(void)
 	sv = shadow_get(obj, id);
 	if (!sv)
 		return -EINVAL;
-	if (sv == sv1 && *sv1 == &var1)
+	if (sv == sv1 && *sv1 == pv1)
 		pr_info("  got expected PTR%d -> PTR%d result\n",
 			ptr_id(sv1), ptr_id(*sv1));
 
 	sv = shadow_get(obj + 1, id);
 	if (!sv)
 		return -EINVAL;
-	if (sv == sv2 && *sv2 == &var2)
+	if (sv == sv2 && *sv2 == pv2)
 		pr_info("  got expected PTR%d -> PTR%d result\n",
 			ptr_id(sv2), ptr_id(*sv2));
 	sv = shadow_get(obj, id + 1);
 	if (!sv)
 		return -EINVAL;
-	if (sv == sv3 && *sv3 == &var3)
+	if (sv == sv3 && *sv3 == pv3)
 		pr_info("  got expected PTR%d -> PTR%d result\n",
 			ptr_id(sv3), ptr_id(*sv3));
 
@@ -204,14 +212,14 @@ static int test_klp_shadow_vars_init(void)
 	 * Allocate or get a few more, this time with the same <obj>, <id>.
 	 * The second invocation should return the same shadow var.
 	 */
-	sv4 = shadow_get_or_alloc(obj + 2, id, size, gfp_flags, shadow_ctor, &var4);
+	sv4 = shadow_get_or_alloc(obj + 2, id, sizeof(pv4), gfp_flags, shadow_ctor, &pv4);
 	if (!sv4)
 		return -ENOMEM;
 
-	sv = shadow_get_or_alloc(obj + 2, id, size, gfp_flags, shadow_ctor, &var4);
+	sv = shadow_get_or_alloc(obj + 2, id, sizeof(pv4), gfp_flags, shadow_ctor, &pv4);
 	if (!sv)
 		return -EINVAL;
-	if (sv == sv4 && *sv4 == &var4)
+	if (sv == sv4 && *sv4 == pv4)
 		pr_info("  got expected PTR%d -> PTR%d result\n",
 			ptr_id(sv4), ptr_id(*sv4));
 
@@ -240,7 +248,7 @@ static int test_klp_shadow_vars_init(void)
 	sv = shadow_get(obj, id + 1);
 	if (!sv)
 		return -EINVAL;
-	if (sv == sv3 && *sv3 == &var3)
+	if (sv == sv3 && *sv3 == pv3)
 		pr_info("  got expected PTR%d -> PTR%d result\n",
 			ptr_id(sv3), ptr_id(*sv3));
 
diff --git a/samples/livepatch/livepatch-shadow-fix1.c b/samples/livepatch/livepatch-shadow-fix1.c
index bab12bdb753f..de0363b288a7 100644
--- a/samples/livepatch/livepatch-shadow-fix1.c
+++ b/samples/livepatch/livepatch-shadow-fix1.c
@@ -53,9 +53,12 @@ struct dummy {
 static int shadow_leak_ctor(void *obj, void *shadow_data, void *ctor_data)
 {
 	int **shadow_leak = shadow_data;
-	int *leak = ctor_data;
+	int **leak = ctor_data;
 
-	*shadow_leak = leak;
+	if (!ctor_data)
+		return -EINVAL;
+
+	*shadow_leak = *leak;
 	return 0;
 }
 
@@ -83,7 +86,7 @@ static struct dummy *livepatch_fix1_dummy_alloc(void)
 	}
 
 	klp_shadow_alloc(d, SV_LEAK, sizeof(leak), GFP_KERNEL,
-			 shadow_leak_ctor, leak);
+			 shadow_leak_ctor, &leak);
 
 	pr_info("%s: dummy @ %p, expires @ %lx\n",
 		__func__, d, d->jiffies_expire);
-- 
2.16.4

