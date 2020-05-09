Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8578C1CC1A3
	for <lists+live-patching@lfdr.de>; Sat,  9 May 2020 15:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgEINLY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 9 May 2020 09:11:24 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726370AbgEINLY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 9 May 2020 09:11:24 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 049D2H4B033546;
        Sat, 9 May 2020 09:11:05 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ws22cerg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 09 May 2020 09:11:05 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 049D2O3I034043;
        Sat, 9 May 2020 09:11:04 -0400
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30ws22ceqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 09 May 2020 09:11:04 -0400
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 049DB2RM021530;
        Sat, 9 May 2020 13:11:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma01fra.de.ibm.com with ESMTP id 30wm558a45-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 09 May 2020 13:11:01 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 049DAxgU60948762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 9 May 2020 13:10:59 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADA9242045;
        Sat,  9 May 2020 13:10:59 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2ED042041;
        Sat,  9 May 2020 13:10:56 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.199.41.60])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sat,  9 May 2020 13:10:56 +0000 (GMT)
Subject: Re: [PATCH] MAINTAINERS: adjust to livepatch .klp.arch removal
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, Joe Perches <joe@perches.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200509073258.5970-1-lukas.bulwahn@gmail.com>
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Message-ID: <bfe91b2d-e319-bf12-6a15-4f200d0e8ea4@linux.vnet.ibm.com>
Date:   Sat, 9 May 2020 18:40:54 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200509073258.5970-1-lukas.bulwahn@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-09_03:2020-05-08,2020-05-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 suspectscore=0 bulkscore=0 adultscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=771 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005090111
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 5/9/20 1:02 PM, Lukas Bulwahn wrote:
> Commit 1d05334d2899 ("livepatch: Remove .klp.arch") removed
> arch/x86/kernel/livepatch.c, but missed to adjust the LIVE PATCHING entry
> in MAINTAINERS.
> 
> Since then, ./scripts/get_maintainer.pl --self-test=patterns complains:
> 
>   warning: no file matches  F:  arch/x86/kernel/livepatch.c
> 
> So, drop that obsolete file entry in MAINTAINERS.

Patch looks good to me,  you probably want to add following architecture
specific livepatching header files to the list:

arch/s390/include/asm/livepatch.h
arch/powerpc/include/asm/livepatch.h

> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> ---
> Jiri, please take this minor non-urgent patch for livepatching/for-next.
> Peter, please ack.
> 
> applies cleanly on next-20200508
> 
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 92657a132417..642f55c4b556 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9909,7 +9909,6 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.g
>  F:	Documentation/ABI/testing/sysfs-kernel-livepatch
>  F:	Documentation/livepatch/
>  F:	arch/x86/include/asm/livepatch.h
> -F:	arch/x86/kernel/livepatch.c
>  F:	include/linux/livepatch.h
>  F:	kernel/livepatch/
>  F:	samples/livepatch/
> 


-- 
Kamalesh
