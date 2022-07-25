Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EFE580707
	for <lists+live-patching@lfdr.de>; Tue, 26 Jul 2022 00:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiGYWCx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Mon, 25 Jul 2022 18:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiGYWCw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 25 Jul 2022 18:02:52 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5D313F72
        for <live-patching@vger.kernel.org>; Mon, 25 Jul 2022 15:02:50 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26PK2LU5027240
        for <live-patching@vger.kernel.org>; Mon, 25 Jul 2022 15:02:50 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hj1usgs10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Mon, 25 Jul 2022 15:02:49 -0700
Received: from twshared5413.23.frc3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 15:02:49 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id DD025AA5DBDE; Mon, 25 Jul 2022 15:02:37 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <live-patching@vger.kernel.org>
CC:     <jpoimboe@kernel.org>, <jikos@kernel.org>, <mbenes@suse.cz>,
        <pmladek@suse.com>, <joe.lawrence@redhat.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH RFC] livepatch: add sysfs entry "patched" for each klp_object
Date:   Mon, 25 Jul 2022 15:02:31 -0700
Message-ID: <20220725220231.3273447-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: YRFN7wiflapop5AHPC3iXIK3SQ3z26wa
X-Proofpoint-ORIG-GUID: YRFN7wiflapop5AHPC3iXIK3SQ3z26wa
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-25_13,2022-07-25_03,2022-06-22_01
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

I was debugging an issue that a livepatch appears to be attached, but
actually not. It turns out that there is a mismatch in module name
(abc-xyz vs. abc_xyz), klp_find_object_module failed to find the module.

Add per klp_object sysfs entry "patched" to make it easier to debug such
issues.

Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/livepatch/core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 5c0d8a4eba13..a9e20c561fef 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -364,6 +364,7 @@ static void klp_clear_object_relocations(struct module *pmod,
  * /sys/kernel/livepatch/<patch>/transition
  * /sys/kernel/livepatch/<patch>/force
  * /sys/kernel/livepatch/<patch>/<object>
+ * /sys/kernel/livepatch/<patch>/<object>/patched
  * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
  */
 static int __klp_disable_patch(struct klp_patch *patch);
@@ -470,6 +471,22 @@ static struct attribute *klp_patch_attrs[] = {
 };
 ATTRIBUTE_GROUPS(klp_patch);
 
+static ssize_t patched_show(struct kobject *kobj,
+			    struct kobj_attribute *attr, char *buf)
+{
+	struct klp_object *obj;
+
+	obj = container_of(kobj, struct klp_object, kobj);
+	return snprintf(buf, PAGE_SIZE, "%d\n", obj->patched);
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
@@ -615,6 +632,7 @@ static void klp_kobj_release_object(struct kobject *kobj)
 static struct kobj_type klp_ktype_object = {
 	.release = klp_kobj_release_object,
 	.sysfs_ops = &kobj_sysfs_ops,
+	.default_groups = klp_object_groups,
 };
 
 static void klp_kobj_release_func(struct kobject *kobj)
-- 
2.30.2

