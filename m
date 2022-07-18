Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACC8577AB1
	for <lists+live-patching@lfdr.de>; Mon, 18 Jul 2022 07:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233407AbiGRFzN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Jul 2022 01:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233399AbiGRFzM (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Jul 2022 01:55:12 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91171057B
        for <live-patching@vger.kernel.org>; Sun, 17 Jul 2022 22:55:10 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26HEMWZm013484
        for <live-patching@vger.kernel.org>; Sun, 17 Jul 2022 22:55:10 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hbu1keqcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <live-patching@vger.kernel.org>; Sun, 17 Jul 2022 22:55:10 -0700
Received: from twshared30313.14.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Sun, 17 Jul 2022 22:55:08 -0700
Received: by devbig932.frc1.facebook.com (Postfix, from userid 4523)
        id 87035A4C01FF; Sun, 17 Jul 2022 22:54:57 -0700 (PDT)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>
CC:     <daniel@iogearbox.net>, <kernel-team@fb.com>, <jolsa@kernel.org>,
        <rostedt@goodmis.org>, Song Liu <song@kernel.org>
Subject: [PATCH v4 bpf-next 3/4] bpf, x64: Allow to use caller address from stack
Date:   Sun, 17 Jul 2022 22:54:48 -0700
Message-ID: <20220718055449.3960512-4-song@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220718055449.3960512-1-song@kernel.org>
References: <20220718055449.3960512-1-song@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 1ijInvrCRsodEUfsWK9FwqN-V3SxEIRv
X-Proofpoint-GUID: 1ijInvrCRsodEUfsWK9FwqN-V3SxEIRv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_04,2022-07-15_01,2022-06-22_01
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Currently we call the original function by using the absolute address
given at the JIT generation. That's not usable when having trampoline
attached to multiple functions, or the target address changes dynamically
(in case of live patch). In such cases we need to take the return address
from the stack.

Adding support to retrieve the original function address from the stack
by adding new BPF_TRAMP_F_ORIG_STACK flag for arch_prepare_bpf_trampoline
function.

Basically we take the return address of the 'fentry' call:

   function + 0: call fentry    # stores 'function + 5' address on stack
   function + 5: ...

The 'function + 5' address will be used as the address for the
original function to call.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Song Liu <song@kernel.org>
---
 arch/x86/net/bpf_jit_comp.c | 13 +++++++++----
 include/linux/bpf.h         |  5 +++++
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 54c7f46c453f..e1b0c5ed0b7c 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -2119,10 +2119,15 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
 	if (flags & BPF_TRAMP_F_CALL_ORIG) {
 		restore_regs(m, &prog, nr_args, regs_off);
 
-		/* call original function */
-		if (emit_call(&prog, orig_call, prog)) {
-			ret = -EINVAL;
-			goto cleanup;
+		if (flags & BPF_TRAMP_F_ORIG_STACK) {
+			emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
+			EMIT2(0xff, 0xd0); /* call *rax */
+		} else {
+			/* call original function */
+			if (emit_call(&prog, orig_call, prog)) {
+				ret = -EINVAL;
+				goto cleanup;
+			}
 		}
 		/* remember return value in a stack for bpf prog to access */
 		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index a5bf00649995..7496842a4671 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -751,6 +751,11 @@ struct btf_func_model {
 /* Return the return value of fentry prog. Only used by bpf_struct_ops. */
 #define BPF_TRAMP_F_RET_FENTRY_RET	BIT(4)
 
+/* Get original function from stack instead of from provided direct address.
+ * Makes sense for trampolines with fexit or fmod_ret programs.
+ */
+#define BPF_TRAMP_F_ORIG_STACK		BIT(5)
+
 /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
  * bytes on x86.
  */
-- 
2.30.2

