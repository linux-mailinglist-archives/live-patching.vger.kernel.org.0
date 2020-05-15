Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89711D48C0
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2020 10:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgEOIoa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 May 2020 04:44:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:3334 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727097AbgEOIoa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 May 2020 04:44:30 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04F8WHoh126164;
        Fri, 15 May 2020 04:44:26 -0400
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 310x56yedu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 04:44:25 -0400
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04F8e6kf020136;
        Fri, 15 May 2020 08:44:24 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3100uc24jr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 08:44:23 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04F8iLW457540794
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 08:44:21 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8130911C04A;
        Fri, 15 May 2020 08:44:21 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6918E11C052;
        Fri, 15 May 2020 08:44:20 +0000 (GMT)
Received: from JAVRIS.in.ibm.com.com (unknown [9.199.53.165])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 15 May 2020 08:44:20 +0000 (GMT)
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>
Subject: [PATCH] MAINTAINERS: add lib/livepatch to LIVE PATCHING
Date:   Fri, 15 May 2020 14:14:10 +0530
Message-Id: <20200515084410.67821-1-kamalesh@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_02:2020-05-14,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=574 impostorscore=0
 adultscore=0 clxscore=1015 cotscore=-2147483648 lowpriorityscore=0
 suspectscore=1 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150071
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Add lib/livepatch to list of livepatching F: patterns in MAINTAINERS.

Suggested-by: Jiri Kosina <jikos@kernel.org>
Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8e14444eb98d..de4f6af03198 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9859,6 +9859,7 @@ F:	arch/s390/include/asm/livepatch.h
 F:	arch/x86/include/asm/livepatch.h
 F:	include/linux/livepatch.h
 F:	kernel/livepatch/
+F:	lib/livepatch/
 F:	samples/livepatch/
 F:	tools/testing/selftests/livepatch/
 

base-commit: 1a0601ade9e132a03fd3e957f6f27e1ed89c1b2e
-- 
2.26.2

