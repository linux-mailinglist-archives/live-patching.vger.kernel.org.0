Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46646305B6C
	for <lists+live-patching@lfdr.de>; Wed, 27 Jan 2021 13:31:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237960AbhA0Ma7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 27 Jan 2021 07:30:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56866 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237961AbhA0M2x (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 27 Jan 2021 07:28:53 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10RC2o2o086614;
        Wed, 27 Jan 2021 07:27:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=yAL17kfc48Z4BiRbtL4ut6pvuFXm4N9KOyQ3CdCN/7M=;
 b=ozPAJihs0Pdnhajajx0Cx7EhJhDAHUudmsvS75PAuRTM+2LzoFr/lhMavxG9dbcBapEn
 vReMZ8rPB8JrqB70W1FKmFjEyHp/eJ/sq2w31fenKZej3q5QhvZeUgsQ+Syi90ASk7ZO
 x5R4poy+XGkZHw5L9X6NSZYnkqar61SJsOcxYNBHbawIdKQm2H/DWfgrcuZ3kJdA3Luj
 ra9tvfaKtWf7iPHkOycCLKWYaZP1d9N1lBYgYIeub9muzuHm4nsu3IINYWL+PbMGYhfU
 MN0PwGJUiCLdOpLHbyUhGP6qXcfK6tDJ8GprrAJ3wVp3m4eCyLMWXDDp2TZ7yAA7Lovj pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36b3kfr9uk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 07:27:39 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10RC3Ugb092531;
        Wed, 27 Jan 2021 07:27:39 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36b3kfr9tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 07:27:39 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10RCDt7T027459;
        Wed, 27 Jan 2021 12:27:37 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 368be89ybk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 12:27:36 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10RCRXq829688178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 12:27:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5C434204C;
        Wed, 27 Jan 2021 12:27:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2097F42045;
        Wed, 27 Jan 2021 12:27:33 +0000 (GMT)
Received: from localhost (unknown [9.171.68.8])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 27 Jan 2021 12:27:33 +0000 (GMT)
Date:   Wed, 27 Jan 2021 13:27:31 +0100
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, x86@kernel.org,
        linux-s390@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH] stacktrace: Move documentation for
 arch_stack_walk_reliable() to header
Message-ID: <your-ad-here.call-01611750451-ext-7215@work.hours>
References: <20210118211021.42308-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210118211021.42308-1-broonie@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_05:2021-01-27,2021-01-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 bulkscore=0
 phishscore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270067
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jan 18, 2021 at 09:10:21PM +0000, Mark Brown wrote:
> Currently arch_stack_wallk_reliable() is documented with an identical
> comment in both x86 and S/390 implementations which is a bit redundant.
> Move this to the header and convert to kerneldoc while we're at it.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Heiko Carstens <hca@linux.ibm.com>
> Cc: Vasily Gorbik <gor@linux.ibm.com>
> Cc: Christian Borntraeger <borntraeger@de.ibm.com>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Miroslav Benes <mbenes@suse.cz>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Joe Lawrence <joe.lawrence@redhat.com>
> Cc: x86@kernel.org
> Cc: linux-s390@vger.kernel.org
> Cc: live-patching@vger.kernel.org
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/s390/kernel/stacktrace.c |  6 ------
>  arch/x86/kernel/stacktrace.c  |  6 ------
>  include/linux/stacktrace.h    | 19 +++++++++++++++++++
>  3 files changed, 19 insertions(+), 12 deletions(-)

Acked-by: Vasily Gorbik <gor@linux.ibm.com>
