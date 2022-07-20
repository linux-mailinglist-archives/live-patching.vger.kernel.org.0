Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6522A57AAE5
	for <lists+live-patching@lfdr.de>; Wed, 20 Jul 2022 02:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235832AbiGTAVv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Jul 2022 20:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235970AbiGTAVu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Jul 2022 20:21:50 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537095D0DC
        for <live-patching@vger.kernel.org>; Tue, 19 Jul 2022 17:21:49 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26JI5DRA031376
        for <live-patching@vger.kernel.org>; Tue, 19 Jul 2022 17:21:49 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hdyj6b7s6-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Tue, 19 Jul 2022 17:21:48 -0700
Received: from twshared34609.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 19 Jul 2022 17:21:45 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 53FF5A6298E1; Tue, 19 Jul 2022 17:21:39 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>
CC:     <daniel@iogearbox.net>, <kernel-team@fb.com>, <jolsa@kernel.org>,
        <rostedt@goodmis.org>, Song Liu <song@kernel.org>
Subject: [PATCH v5 bpf-next 0/4] ftrace: host klp and bpf trampoline together
Date:   Tue, 19 Jul 2022 17:21:22 -0700
Message-ID: <20220720002126.803253-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: FYCy5TRijAsFvQ0U3Sr4Vyxg8ImF3Z98
X-Proofpoint-ORIG-GUID: FYCy5TRijAsFvQ0U3Sr4Vyxg8ImF3Z98
Content-Transfer-Encoding: 8BIT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-19_10,2022-07-19_01,2022-06-22_01
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Changes v4 => v5:
1. Cleanup direct_mutex handling in register_ftrace_function.
   (Steven Rostedt, Petr Mladek).
2. Various smallish fixes. (Steven Rostedt, Petr Mladek).

Changes v3 => v4:
1. Fix build errors for different config. (kernel test robot)

Changes v2 => v3:
1. Major rewrite after discussions with Steven Rostedt. [1]
2. Remove SHARE_IPMODIFY flag from ftrace code. Instead use the callback
   function to communicate this information. (Steven)
3. Add cleanup_direct_functions_after_ipmodify() to clear SHARE_IPMODIFY
   on the DIRECT ops when the IPMODIFY ops is removed.

Changes v1 => v2:
1. Fix build errors for different config. (kernel test robot)

Kernel Live Patch (livepatch, or klp) and bpf trampoline are important
features for modern systems. This set allows the two to work on the same
kernel function as the same time.

live patch uses ftrace with IPMODIFY, while bpf trampoline use direct
ftrace. Existing policy does not allow the two to attach to the same kernel
function. This is changed by fine tuning ftrace IPMODIFY policy, and allows
one IPMODIFY ftrace_ops and one DIRECT ftrace_ops on the same kernel
function at the same time. Please see patch 2 and 4 for more details.

Note that, one of the constraint here is to let bpf trampoline use direct
call when it is not working on the same function as live patch. This is
achieved by allowing ftrace code to ask bpf trampoline to make changes.

[1] https://lore.kernel.org/all/20220602193706.2607681-2-song@kernel.org/

Jiri Olsa (1):
  bpf, x64: Allow to use caller address from stack

Song Liu (3):
  ftrace: Add modify_ftrace_direct_multi_nolock
  ftrace: Allow IPMODIFY and DIRECT ops on the same function
  bpf: Support bpf_trampoline on functions with IPMODIFY (e.g.
    livepatch)

 arch/x86/net/bpf_jit_comp.c |  13 +-
 include/linux/bpf.h         |  13 ++
 include/linux/ftrace.h      |  43 +++++
 kernel/bpf/trampoline.c     | 158 +++++++++++++++--
 kernel/trace/ftrace.c       | 328 ++++++++++++++++++++++++++++++------
 5 files changed, 484 insertions(+), 71 deletions(-)

--
2.30.2
