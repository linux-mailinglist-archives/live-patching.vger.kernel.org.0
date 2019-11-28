Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E8310CD3E
	for <lists+live-patching@lfdr.de>; Thu, 28 Nov 2019 17:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfK1Qv6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 28 Nov 2019 11:51:58 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5252 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726582AbfK1Qv5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 28 Nov 2019 11:51:57 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xASGldbj015293
        for <live-patching@vger.kernel.org>; Thu, 28 Nov 2019 11:51:56 -0500
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2whcy94sfa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Thu, 28 Nov 2019 11:51:56 -0500
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <gor@linux.ibm.com>;
        Thu, 28 Nov 2019 16:51:54 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 28 Nov 2019 16:51:50 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xASGpmKa46006438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Nov 2019 16:51:48 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A437E52050;
        Thu, 28 Nov 2019 16:51:48 +0000 (GMT)
Received: from localhost (unknown [9.152.212.112])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 4B1C052057;
        Thu, 28 Nov 2019 16:51:48 +0000 (GMT)
Date:   Thu, 28 Nov 2019 17:51:47 +0100
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     heiko.carstens@de.ibm.com, borntraeger@de.ibm.com,
        jpoimboe@redhat.com, joe.lawrence@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        jikos@kernel.org, pmladek@suse.com, nstange@suse.de,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v3 1/4] s390/unwind: drop unnecessary code around calling
 ftrace_graph_ret_addr()
References: <20191106095601.29986-1-mbenes@suse.cz>
 <20191106095601.29986-2-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191106095601.29986-2-mbenes@suse.cz>
X-TM-AS-GCONF: 00
x-cbid: 19112816-0028-0000-0000-000003C135A0
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19112816-0029-0000-0000-00002484414C
Message-Id: <your-ad-here.call-01574959907-ext-0700@work.hours>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-28_05:2019-11-28,2019-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 spamscore=0 mlxlogscore=701 impostorscore=0 malwarescore=0 adultscore=0
 priorityscore=1501 phishscore=0 suspectscore=1 lowpriorityscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911280142
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Nov 06, 2019 at 10:55:58AM +0100, Miroslav Benes wrote:
> The current code around calling ftrace_graph_ret_addr() is ifdeffed and
> also tests if ftrace redirection is present on stack.
> ftrace_graph_ret_addr() however performs the test internally and there
> is a version for !CONFIG_FUNCTION_GRAPH_TRACER as well. The unnecessary
> code can thus be dropped.
> 
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> ---
>  arch/s390/kernel/unwind_bc.c | 16 ++++------------
>  1 file changed, 4 insertions(+), 12 deletions(-)

This patch has been picked up from v2 already. It's in Linus tree.

