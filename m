Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C1BF76D
	for <lists+live-patching@lfdr.de>; Tue, 30 Apr 2019 13:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfD3L5G (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 30 Apr 2019 07:57:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49492 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727351AbfD3L5F (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 30 Apr 2019 07:57:05 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3UBql7k029829
        for <live-patching@vger.kernel.org>; Tue, 30 Apr 2019 07:57:04 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2s6mqs3g1v-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Tue, 30 Apr 2019 07:57:04 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <kamalesh@linux.vnet.ibm.com>;
        Tue, 30 Apr 2019 12:57:02 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 30 Apr 2019 12:56:59 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x3UBuwXV54132838
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 11:56:58 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 806A1AE045;
        Tue, 30 Apr 2019 11:56:58 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C9EFCAE04D;
        Tue, 30 Apr 2019 11:56:56 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.85.97.254])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 30 Apr 2019 11:56:56 +0000 (GMT)
Date:   Tue, 30 Apr 2019 17:26:51 +0530
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] livepatch: Remove duplicate warning about missing
 reliable stacktrace support
References: <20190430091049.30413-1-pmladek@suse.com>
 <20190430091049.30413-2-pmladek@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430091049.30413-2-pmladek@suse.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-TM-AS-GCONF: 00
x-cbid: 19043011-0016-0000-0000-00000276DC19
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19043011-0017-0000-0000-000032D366D7
Message-Id: <20190430115651.GA18595@JAVRIS.in.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=949 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904300078
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 30, 2019 at 11:10:48AM +0200, Petr Mladek wrote:
> WARN_ON_ONCE() could not be called safely under rq lock because
> of console deadlock issues. Fortunately, there is another check
> for the reliable stacktrace support in klp_enable_patch().
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

