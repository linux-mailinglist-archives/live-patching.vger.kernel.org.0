Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 268DA10D1ED
	for <lists+live-patching@lfdr.de>; Fri, 29 Nov 2019 08:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfK2Hl6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 Nov 2019 02:41:58 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51078 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726709AbfK2Hl5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 Nov 2019 02:41:57 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAT7fsiO063197
        for <live-patching@vger.kernel.org>; Fri, 29 Nov 2019 02:41:57 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2wjvfg4jy0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Fri, 29 Nov 2019 02:41:56 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <gor@linux.ibm.com>;
        Fri, 29 Nov 2019 07:41:54 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 29 Nov 2019 07:41:51 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAT7foan53280810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Nov 2019 07:41:50 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2DD3F4203F;
        Fri, 29 Nov 2019 07:41:50 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8B1BF42041;
        Fri, 29 Nov 2019 07:41:49 +0000 (GMT)
Received: from localhost (unknown [9.145.76.153])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 29 Nov 2019 07:41:49 +0000 (GMT)
Date:   Fri, 29 Nov 2019 08:41:48 +0100
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     heiko.carstens@de.ibm.com, borntraeger@de.ibm.com,
        jpoimboe@redhat.com, joe.lawrence@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        live-patching@vger.kernel.org
Subject: [PATCH v4 1/2] s390/unwind: add stack pointer alignment sanity checks
References: <20191106095601.29986-5-mbenes@suse.cz>
 <cover.thread-a0061f.your-ad-here.call-01575012971-ext-9115@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.thread-a0061f.your-ad-here.call-01575012971-ext-9115@work.hours>
X-TM-AS-GCONF: 00
x-cbid: 19112907-0008-0000-0000-00000339C37D
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112907-0009-0000-0000-00004A58D255
Message-Id: <patch-1.thread-a0061f.git-617139935cc4.your-ad-here.call-01575012971-ext-9115@work.hours>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-29_01:2019-11-29,2019-11-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=859
 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501 suspectscore=1
 lowpriorityscore=0 phishscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1911290066
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Miroslav Benes <mbenes@suse.cz>

ABI requires SP to be aligned 8 bytes, report unwinding error otherwise.

Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
---
 arch/s390/kernel/dumpstack.c | 4 ++++
 arch/s390/kernel/unwind_bc.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/s390/kernel/dumpstack.c b/arch/s390/kernel/dumpstack.c
index d74e21a23703..d306fe04489a 100644
--- a/arch/s390/kernel/dumpstack.c
+++ b/arch/s390/kernel/dumpstack.c
@@ -94,6 +94,10 @@ int get_stack_info(unsigned long sp, struct task_struct *task,
 	if (!sp)
 		goto unknown;
 
+	/* Sanity check: ABI requires SP to be aligned 8 bytes. */
+	if (sp & 0x7)
+		goto unknown;
+
 	/* Check per-task stack */
 	if (in_task_stack(sp, task, info))
 		goto recursion_check;
diff --git a/arch/s390/kernel/unwind_bc.c b/arch/s390/kernel/unwind_bc.c
index ef42d5f77ce7..da2d4d4c5b0e 100644
--- a/arch/s390/kernel/unwind_bc.c
+++ b/arch/s390/kernel/unwind_bc.c
@@ -92,6 +92,10 @@ bool unwind_next_frame(struct unwind_state *state)
 		}
 	}
 
+	/* Sanity check: ABI requires SP to be aligned 8 bytes. */
+	if (sp & 0x7)
+		goto out_err;
+
 	ip = ftrace_graph_ret_addr(state->task, &state->graph_idx, ip, (void *) sp);
 
 	/* Update unwind state */
-- 
2.21.0

