Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9352B5874F7
	for <lists+live-patching@lfdr.de>; Tue,  2 Aug 2022 03:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231731AbiHBBJP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>); Mon, 1 Aug 2022 21:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiHBBJP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Aug 2022 21:09:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A2E23BE5
        for <live-patching@vger.kernel.org>; Mon,  1 Aug 2022 18:09:13 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 271NFgRQ019146
        for <live-patching@vger.kernel.org>; Mon, 1 Aug 2022 18:09:12 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net (PPS) with ESMTPS id 3hn0av05m1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Mon, 01 Aug 2022 18:09:12 -0700
Received: from twshared7570.37.frc1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 1 Aug 2022 18:09:10 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 5815DB034343; Mon,  1 Aug 2022 18:09:03 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <live-patching@vger.kernel.org>
CC:     <jpoimboe@kernel.org>, <jikos@kernel.org>, <mbenes@suse.cz>,
        <pmladek@suse.com>, <joe.lawrence@redhat.com>,
        <kernel-team@fb.com>, Song Liu <song@kernel.org>
Subject: [PATCH v2 1/2] livepatch: add sysfs entry "patched" for each klp_object
Date:   Mon, 1 Aug 2022 18:08:56 -0700
Message-ID: <20220802010857.3574103-2-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220802010857.3574103-1-song@kernel.org>
References: <20220802010857.3574103-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: vX3GamOrL_BVImpN9uE0T21PmX6tGJWe
X-Proofpoint-ORIG-GUID: vX3GamOrL_BVImpN9uE0T21PmX6tGJWe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-01_12,2022-08-01_01,2022-06-22_01
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add per klp_object sysfs entry "patched". It makes it easier to debug
typos in the module name.

Signed-off-by: Song Liu <song@kernel.org>
---
I was debugging an issue that a livepatch appears to be attached, but
actually not. It turns out that there is a mismatch in module name
(abc-xyz vs. abc_xyz), klp_find_object_module failed to find the module.
---
 .../ABI/testing/sysfs-kernel-livepatch         |  8 ++++++++
 kernel/livepatch/core.c                        | 18 ++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
index bea7bd5a1d5f..ebe39a3cea39 100644
--- a/Documentation/ABI/testing/sysfs-kernel-livepatch
+++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
@@ -55,6 +55,14 @@ Description:
 		The object directory contains subdirectories for each function
 		that is patched within the object.
 
+What:		/sys/kernel/livepatch/<patch>/<object>/patched
+Date:		August 2022
+KernelVersion:	6.0.0
+Contact:	live-patching@vger.kernel.org
+Description:
+		An attribute which indicates whether the object is currently
+		patched.
+
 What:		/sys/kernel/livepatch/<patch>/<object>/<function,sympos>
 Date:		Nov 2014
 KernelVersion:	3.19.0
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index bc475e62279d..67eb9f9168f3 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -325,6 +325,7 @@ int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
  * /sys/kernel/livepatch/<patch>/transition
  * /sys/kernel/livepatch/<patch>/force
  * /sys/kernel/livepatch/<patch>/<object>
+ * /sys/kernel/livepatch/<patch>/<object>/patched
  * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
  */
 static int __klp_disable_patch(struct klp_patch *patch);
@@ -431,6 +432,22 @@ static struct attribute *klp_patch_attrs[] = {
 };
 ATTRIBUTE_GROUPS(klp_patch);
 
+static ssize_t patched_show(struct kobject *kobj,
+			    struct kobj_attribute *attr, char *buf)
+{
+	struct klp_object *obj;
+
+	obj = container_of(kobj, struct klp_object, kobj);
+	return sysfs_emit(buf, "%d\n", obj->patched);
+}
+
+static struct kobj_attribute patched_kobj_attr = __ATTR_RO(patched);
+static struct attribute *klp_object_attrs[] = {
+	&patched_kobj_attr.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(klp_object);
+
 static void klp_free_object_dynamic(struct klp_object *obj)
 {
 	kfree(obj->name);
@@ -576,6 +593,7 @@ static void klp_kobj_release_object(struct kobject *kobj)
 static struct kobj_type klp_ktype_object = {
 	.release = klp_kobj_release_object,
 	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = klp_object_groups,
 };
 
 static void klp_kobj_release_func(struct kobject *kobj)
-- 
2.30.2

