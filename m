Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582015874F5
	for <lists+live-patching@lfdr.de>; Tue,  2 Aug 2022 03:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbiHBBJM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>); Mon, 1 Aug 2022 21:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbiHBBJL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Aug 2022 21:09:11 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D9423BE5
        for <live-patching@vger.kernel.org>; Mon,  1 Aug 2022 18:09:10 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 271NFYPT017454
        for <live-patching@vger.kernel.org>; Mon, 1 Aug 2022 18:09:09 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3hn057r2bv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Mon, 01 Aug 2022 18:09:09 -0700
Received: from twshared34609.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 1 Aug 2022 18:09:08 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 23871B034338; Mon,  1 Aug 2022 18:09:02 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <live-patching@vger.kernel.org>
CC:     <jpoimboe@kernel.org>, <jikos@kernel.org>, <mbenes@suse.cz>,
        <pmladek@suse.com>, <joe.lawrence@redhat.com>,
        <kernel-team@fb.com>, Song Liu <song@kernel.org>
Subject: [PATCH v2 0/2] add sysfs entry "patched" for each klp_object
Date:   Mon, 1 Aug 2022 18:08:55 -0700
Message-ID: <20220802010857.3574103-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: COyTuGhAmGPkZD4fDEHaqEcdqsoQx4fM
X-Proofpoint-ORIG-GUID: COyTuGhAmGPkZD4fDEHaqEcdqsoQx4fM
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

I was debugging an issue that a livepatch appears to be attached, but
actually not. It turns out that there is a mismatch in module name
(abc-xyz vs. abc_xyz), klp_find_object_module failed to find the module.

Changes v1 => v2:
1. Add selftest. (Petr Mladek)
2. Update documentation. (Petr Mladek)
3. Use sysfs_emit. (Petr Mladek)

Song Liu (2):
  livepatch: add sysfs entry "patched" for each klp_object
  selftests/livepatch: add sysfs test

 .../ABI/testing/sysfs-kernel-livepatch        |  8 ++++
 kernel/livepatch/core.c                       | 18 +++++++++
 tools/testing/selftests/livepatch/Makefile    |  3 +-
 .../testing/selftests/livepatch/test-sysfs.sh | 40 +++++++++++++++++++
 4 files changed, 68 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/livepatch/test-sysfs.sh

--
2.30.2
