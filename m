Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59D8720C52
	for <lists+live-patching@lfdr.de>; Sat,  3 Jun 2023 01:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236369AbjFBXYa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>); Fri, 2 Jun 2023 19:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236840AbjFBXY1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 2 Jun 2023 19:24:27 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0ADA185
        for <live-patching@vger.kernel.org>; Fri,  2 Jun 2023 16:24:25 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 352MgiBi004627
        for <live-patching@vger.kernel.org>; Fri, 2 Jun 2023 16:24:25 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3qykxj3fut-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Fri, 02 Jun 2023 16:24:25 -0700
Received: from twshared52232.38.frc1.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 2 Jun 2023 16:24:23 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 9FF421EA969DE; Fri,  2 Jun 2023 16:24:08 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <live-patching@vger.kernel.org>
CC:     <jpoimboe@kernel.org>, <jikos@kernel.org>, <mbenes@suse.cz>,
        <pmladek@suse.com>, <joe.lawrence@redhat.com>,
        <kernel-team@meta.com>, Song Liu <song@kernel.org>
Subject: [PATCH] livepatch: match symbols exactly in klp_find_object_symbol()
Date:   Fri, 2 Jun 2023 16:24:01 -0700
Message-ID: <20230602232401.3938285-1-song@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: UD-wxZUzLEDa_93QVOxteJxcJDYkTS2T
X-Proofpoint-ORIG-GUID: UD-wxZUzLEDa_93QVOxteJxcJDYkTS2T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_17,2023-06-02_02,2023-05-22_02
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

With CONFIG_LTO_CLANG, kallsyms.c:cleanup_symbol_name() removes symbols
suffixes during comparison. This is problematic for livepatch, as
kallsyms_on_each_match_symbol may find multiple matches for the same
symbol, and fail with:

  livepatch: unresolvable ambiguity for symbol 'xxx' in object 'yyy'

Fix this by using kallsyms_on_each_symbol instead, and matching symbols
exactly.

Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/livepatch/core.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 61328328c474..507e1e2e4290 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -125,10 +125,13 @@ struct klp_find_arg {
 	unsigned long pos;
 };
 
-static int klp_match_callback(void *data, unsigned long addr)
+static int klp_find_callback(void *data, const char *name, unsigned long addr)
 {
 	struct klp_find_arg *args = data;
 
+	if (strcmp(args->name, name))
+		return 0;
+
 	args->addr = addr;
 	args->count++;
 
@@ -143,16 +146,6 @@ static int klp_match_callback(void *data, unsigned long addr)
 	return 0;
 }
 
-static int klp_find_callback(void *data, const char *name, unsigned long addr)
-{
-	struct klp_find_arg *args = data;
-
-	if (strcmp(args->name, name))
-		return 0;
-
-	return klp_match_callback(data, addr);
-}
-
 static int klp_find_object_symbol(const char *objname, const char *name,
 				  unsigned long sympos, unsigned long *addr)
 {
@@ -166,7 +159,7 @@ static int klp_find_object_symbol(const char *objname, const char *name,
 	if (objname)
 		module_kallsyms_on_each_symbol(objname, klp_find_callback, &args);
 	else
-		kallsyms_on_each_match_symbol(klp_match_callback, name, &args);
+		kallsyms_on_each_symbol(klp_find_callback, &args);
 
 	/*
 	 * Ensure an address was found. If sympos is 0, ensure symbol is unique;
-- 
2.34.1

