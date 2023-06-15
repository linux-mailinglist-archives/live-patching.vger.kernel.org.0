Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE811731E99
	for <lists+live-patching@lfdr.de>; Thu, 15 Jun 2023 19:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbjFORBS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Jun 2023 13:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjFORBQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Jun 2023 13:01:16 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9112695
        for <live-patching@vger.kernel.org>; Thu, 15 Jun 2023 10:01:02 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35FFpmRd024170
        for <live-patching@vger.kernel.org>; Thu, 15 Jun 2023 10:01:02 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3r85ncrjjb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Thu, 15 Jun 2023 10:01:01 -0700
Received: from twshared29562.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 10:01:00 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id E18201F5A0EE3; Thu, 15 Jun 2023 10:00:49 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <live-patching@vger.kernel.org>
CC:     <jpoimboe@kernel.org>, <jikos@kernel.org>, <mbenes@suse.cz>,
        <pmladek@suse.com>, <joe.lawrence@redhat.com>,
        <kernel-team@meta.com>, <thunder.leizhen@huawei.com>,
        <mcgrof@kernel.org>, Song Liu <song@kernel.org>
Subject: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match symbols exactly
Date:   Thu, 15 Jun 2023 10:00:48 -0700
Message-ID: <20230615170048.2382735-1-song@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: VGwh4_IXagXQJtLFAx7MbWr-Iqedugwv
X-Proofpoint-ORIG-GUID: VGwh4_IXagXQJtLFAx7MbWr-Iqedugwv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-15_13,2023-06-15_01,2023-05-22_02
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

Make kallsyms_on_each_match_symbol() to match symbols exactly. Since
livepatch is the only user of kallsyms_on_each_match_symbol(), this
change is safe.

Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/kallsyms.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 77747391f49b..2ab459b43084 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -187,7 +187,7 @@ static bool cleanup_symbol_name(char *s)
 	return false;
 }
 
-static int compare_symbol_name(const char *name, char *namebuf)
+static int compare_symbol_name(const char *name, char *namebuf, bool match_exactly)
 {
 	int ret;
 
@@ -195,7 +195,7 @@ static int compare_symbol_name(const char *name, char *namebuf)
 	if (!ret)
 		return ret;
 
-	if (cleanup_symbol_name(namebuf) && !strcmp(name, namebuf))
+	if (!match_exactly && cleanup_symbol_name(namebuf) && !strcmp(name, namebuf))
 		return 0;
 
 	return ret;
@@ -213,7 +213,8 @@ static unsigned int get_symbol_seq(int index)
 
 static int kallsyms_lookup_names(const char *name,
 				 unsigned int *start,
-				 unsigned int *end)
+				 unsigned int *end,
+				 bool match_exactly)
 {
 	int ret;
 	int low, mid, high;
@@ -228,7 +229,7 @@ static int kallsyms_lookup_names(const char *name,
 		seq = get_symbol_seq(mid);
 		off = get_symbol_offset(seq);
 		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-		ret = compare_symbol_name(name, namebuf);
+		ret = compare_symbol_name(name, namebuf, match_exactly);
 		if (ret > 0)
 			low = mid + 1;
 		else if (ret < 0)
@@ -245,7 +246,7 @@ static int kallsyms_lookup_names(const char *name,
 		seq = get_symbol_seq(low - 1);
 		off = get_symbol_offset(seq);
 		kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-		if (compare_symbol_name(name, namebuf))
+		if (compare_symbol_name(name, namebuf, match_exactly))
 			break;
 		low--;
 	}
@@ -257,7 +258,7 @@ static int kallsyms_lookup_names(const char *name,
 			seq = get_symbol_seq(high + 1);
 			off = get_symbol_offset(seq);
 			kallsyms_expand_symbol(off, namebuf, ARRAY_SIZE(namebuf));
-			if (compare_symbol_name(name, namebuf))
+			if (compare_symbol_name(name, namebuf, match_exactly))
 				break;
 			high++;
 		}
@@ -277,7 +278,7 @@ unsigned long kallsyms_lookup_name(const char *name)
 	if (!*name)
 		return 0;
 
-	ret = kallsyms_lookup_names(name, &i, NULL);
+	ret = kallsyms_lookup_names(name, &i, NULL, false);
 	if (!ret)
 		return kallsyms_sym_address(get_symbol_seq(i));
 
@@ -312,7 +313,7 @@ int kallsyms_on_each_match_symbol(int (*fn)(void *, unsigned long),
 	int ret;
 	unsigned int i, start, end;
 
-	ret = kallsyms_lookup_names(name, &start, &end);
+	ret = kallsyms_lookup_names(name, &start, &end, true);
 	if (ret)
 		return 0;
 
-- 
2.34.1

