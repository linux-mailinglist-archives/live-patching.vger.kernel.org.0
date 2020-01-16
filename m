Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3847F13DED1
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2020 16:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgAPPcO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Jan 2020 10:32:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:53736 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726812AbgAPPcO (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Jan 2020 10:32:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id E6C216A2E2;
        Thu, 16 Jan 2020 15:32:11 +0000 (UTC)
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
Subject: [PATCH 1/4] livepatch/sample: Use the right type for the leaking data pointer
Date:   Thu, 16 Jan 2020 16:31:42 +0100
Message-Id: <20200116153145.2392-2-pmladek@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200116153145.2392-1-pmladek@suse.com>
References: <20200116153145.2392-1-pmladek@suse.com>
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The "leak" pointer, in the sample of shadow variable API, is allocated
as sizeof(int). Let's help developers and static analyzers with
understanding the code by using the appropriate pointer type.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 samples/livepatch/livepatch-shadow-fix1.c | 12 ++++++------
 samples/livepatch/livepatch-shadow-fix2.c |  4 ++--
 samples/livepatch/livepatch-shadow-mod.c  |  4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/samples/livepatch/livepatch-shadow-fix1.c b/samples/livepatch/livepatch-shadow-fix1.c
index e89ca4546114..bab12bdb753f 100644
--- a/samples/livepatch/livepatch-shadow-fix1.c
+++ b/samples/livepatch/livepatch-shadow-fix1.c
@@ -52,8 +52,8 @@ struct dummy {
  */
 static int shadow_leak_ctor(void *obj, void *shadow_data, void *ctor_data)
 {
-	void **shadow_leak = shadow_data;
-	void *leak = ctor_data;
+	int **shadow_leak = shadow_data;
+	int *leak = ctor_data;
 
 	*shadow_leak = leak;
 	return 0;
@@ -62,7 +62,7 @@ static int shadow_leak_ctor(void *obj, void *shadow_data, void *ctor_data)
 static struct dummy *livepatch_fix1_dummy_alloc(void)
 {
 	struct dummy *d;
-	void *leak;
+	int *leak;
 
 	d = kzalloc(sizeof(*d), GFP_KERNEL);
 	if (!d)
@@ -76,7 +76,7 @@ static struct dummy *livepatch_fix1_dummy_alloc(void)
 	 * variable.  A patched dummy_free routine can later fetch this
 	 * pointer to handle resource release.
 	 */
-	leak = kzalloc(sizeof(int), GFP_KERNEL);
+	leak = kzalloc(sizeof(*leak), GFP_KERNEL);
 	if (!leak) {
 		kfree(d);
 		return NULL;
@@ -94,7 +94,7 @@ static struct dummy *livepatch_fix1_dummy_alloc(void)
 static void livepatch_fix1_dummy_leak_dtor(void *obj, void *shadow_data)
 {
 	void *d = obj;
-	void **shadow_leak = shadow_data;
+	int **shadow_leak = shadow_data;
 
 	kfree(*shadow_leak);
 	pr_info("%s: dummy @ %p, prevented leak @ %p\n",
@@ -103,7 +103,7 @@ static void livepatch_fix1_dummy_leak_dtor(void *obj, void *shadow_data)
 
 static void livepatch_fix1_dummy_free(struct dummy *d)
 {
-	void **shadow_leak;
+	int **shadow_leak;
 
 	/*
 	 * Patch: fetch the saved SV_LEAK shadow variable, detach and
diff --git a/samples/livepatch/livepatch-shadow-fix2.c b/samples/livepatch/livepatch-shadow-fix2.c
index 50d223b82e8b..29fe5cd42047 100644
--- a/samples/livepatch/livepatch-shadow-fix2.c
+++ b/samples/livepatch/livepatch-shadow-fix2.c
@@ -59,7 +59,7 @@ static bool livepatch_fix2_dummy_check(struct dummy *d, unsigned long jiffies)
 static void livepatch_fix2_dummy_leak_dtor(void *obj, void *shadow_data)
 {
 	void *d = obj;
-	void **shadow_leak = shadow_data;
+	int **shadow_leak = shadow_data;
 
 	kfree(*shadow_leak);
 	pr_info("%s: dummy @ %p, prevented leak @ %p\n",
@@ -68,7 +68,7 @@ static void livepatch_fix2_dummy_leak_dtor(void *obj, void *shadow_data)
 
 static void livepatch_fix2_dummy_free(struct dummy *d)
 {
-	void **shadow_leak;
+	int **shadow_leak;
 	int *shadow_count;
 
 	/* Patch: copy the memory leak patch from the fix1 module. */
diff --git a/samples/livepatch/livepatch-shadow-mod.c b/samples/livepatch/livepatch-shadow-mod.c
index ecfe83a943a7..7e753b0d2fa6 100644
--- a/samples/livepatch/livepatch-shadow-mod.c
+++ b/samples/livepatch/livepatch-shadow-mod.c
@@ -95,7 +95,7 @@ struct dummy {
 static __used noinline struct dummy *dummy_alloc(void)
 {
 	struct dummy *d;
-	void *leak;
+	int *leak;
 
 	d = kzalloc(sizeof(*d), GFP_KERNEL);
 	if (!d)
@@ -105,7 +105,7 @@ static __used noinline struct dummy *dummy_alloc(void)
 		msecs_to_jiffies(1000 * EXPIRE_PERIOD);
 
 	/* Oops, forgot to save leak! */
-	leak = kzalloc(sizeof(int), GFP_KERNEL);
+	leak = kzalloc(sizeof(*leak), GFP_KERNEL);
 	if (!leak) {
 		kfree(d);
 		return NULL;
-- 
2.16.4

