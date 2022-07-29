Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415245855A0
	for <lists+live-patching@lfdr.de>; Fri, 29 Jul 2022 21:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238020AbiG2Tl0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 Jul 2022 15:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237057AbiG2Tl0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 Jul 2022 15:41:26 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E4F16D2DD
        for <live-patching@vger.kernel.org>; Fri, 29 Jul 2022 12:41:25 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26THAKWh028069
        for <live-patching@vger.kernel.org>; Fri, 29 Jul 2022 12:41:24 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hkxjjgna1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Fri, 29 Jul 2022 12:41:24 -0700
Received: from twshared22413.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 29 Jul 2022 12:41:23 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 2B984AD80AAB; Fri, 29 Jul 2022 12:41:13 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>
CC:     <daniel@iogearbox.net>, <kernel-team@fb.com>, <jolsa@kernel.org>,
        <rostedt@goodmis.org>, Song Liu <song@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH bpf-next] bpf: fix test_progs -j error with fentry/fexit tests
Date:   Fri, 29 Jul 2022 12:41:06 -0700
Message-ID: <20220729194106.1207472-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: Yqy7wfWVXxPGJktvvCezm1y5GJSSHFR4
X-Proofpoint-ORIG-GUID: Yqy7wfWVXxPGJktvvCezm1y5GJSSHFR4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-29_19,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Then multiple threads are attaching/detaching fentry/fexit programs to
the same trampoline, we may call register_fentry on the same trampoline
twice: register_fentry(), unregister_fentry(), then register_fentry again.
This causes ftrace_set_filter_ip() for the same ip on tr->fops twice,
which leaves duplicated ip in tr->fops. The extra ip is not cleaned up
properly on unregister and thus causes failures with further register in
register_ftrace_direct_multi():

register_ftrace_direct_multi()
{
        ...
        for (i = 0; i < size; i++) {
                hlist_for_each_entry(entry, &hash->buckets[i], hlist) {
                        if (ftrace_find_rec_direct(entry->ip))
                                goto out_unlock;
                }
        }
        ...
}

This can be triggered with parallel fentry/fexit tests with test_progs:

  ./test_progs -t fentry,fexit -j

Fix this by resetting tr->fops in ftrace_set_filter_ip(), so that there
will never be duplicated entries in tr->fops.

Fixes: 00963a2e75a8 ("bpf: Support bpf_trampoline on functions with IPMODIFY (e.g. livepatch)")
Reported-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Song Liu <song@kernel.org>
---
 kernel/bpf/trampoline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 42e387a12694..7ec7e23559ad 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -255,7 +255,7 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
 		return -ENOENT;
 
 	if (tr->func.ftrace_managed) {
-		ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 0);
+		ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 1);
 		ret = register_ftrace_direct_multi(tr->fops, (long)new_addr);
 	} else {
 		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
-- 
2.30.2

