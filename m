Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96D81CD1A6
	for <lists+live-patching@lfdr.de>; Mon, 11 May 2020 08:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgEKGK2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 11 May 2020 02:10:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:46490 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725916AbgEKGK1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 11 May 2020 02:10:27 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04B63TpP040288;
        Mon, 11 May 2020 02:10:25 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30ws5a0y4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 May 2020 02:10:25 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04B6ANXX002948;
        Mon, 11 May 2020 06:10:24 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 30wm55br6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 May 2020 06:10:23 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04B6ALbj58917006
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 May 2020 06:10:21 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE0E5A4068;
        Mon, 11 May 2020 06:10:21 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E8204A405C;
        Mon, 11 May 2020 06:10:20 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.85.92.33])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 11 May 2020 06:10:20 +0000 (GMT)
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To:     live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Update LIVE PATCHING file list
Date:   Mon, 11 May 2020 11:40:14 +0530
Message-Id: <20200511061014.308675-1-kamalesh@linux.vnet.ibm.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-11_01:2020-05-08,2020-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 priorityscore=1501 suspectscore=1 adultscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=830
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005110049
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

The current list of livepatching files is incomplete, update the list
with the missing files. Included files are ordered by the command:

./scripts/parse-maintainers.pl --input=MAINTAINERS --output=MAINTAINERS --order

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
The patch applies on top of livepatching/for-next

 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 7e0827670425..de4f6af03198 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9854,9 +9854,12 @@ S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git
 F:	Documentation/ABI/testing/sysfs-kernel-livepatch
 F:	Documentation/livepatch/
+F:	arch/powerpc/include/asm/livepatch.h
+F:	arch/s390/include/asm/livepatch.h
 F:	arch/x86/include/asm/livepatch.h
 F:	include/linux/livepatch.h
 F:	kernel/livepatch/
+F:	lib/livepatch/
 F:	samples/livepatch/
 F:	tools/testing/selftests/livepatch/
 

base-commit: f644e7bbd7c124cf08875200d447ce91441cd866
-- 
2.26.2

