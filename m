Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5EF140680
	for <lists+live-patching@lfdr.de>; Fri, 17 Jan 2020 10:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgAQJlh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Jan 2020 04:41:37 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61358 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726196AbgAQJlh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Jan 2020 04:41:37 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00H9b6Wh097776
        for <live-patching@vger.kernel.org>; Fri, 17 Jan 2020 04:41:35 -0500
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2xk0qspmxm-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Fri, 17 Jan 2020 04:41:35 -0500
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <kamalesh@linux.vnet.ibm.com>;
        Fri, 17 Jan 2020 09:41:33 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 Jan 2020 09:41:31 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 00H9fUGv49807500
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Jan 2020 09:41:30 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 382B652057;
        Fri, 17 Jan 2020 09:41:30 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.199.56.246])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id A8A7052050;
        Fri, 17 Jan 2020 09:41:20 +0000 (GMT)
Subject: Re: [PATCH 0/4] livepatch/samples/selftest: Clean up show variables
 handling
To:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Nicolai Stange <nstange@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200116153145.2392-1-pmladek@suse.com>
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date:   Fri, 17 Jan 2020 15:11:18 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200116153145.2392-1-pmladek@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20011709-0020-0000-0000-000003A18536
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20011709-0021-0000-0000-000021F907A5
Message-Id: <ed600fec-ac75-980e-078a-cdb60fb021a4@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-17_02:2020-01-16,2020-01-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 clxscore=1015 adultscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001170074
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 1/16/20 9:01 PM, Petr Mladek wrote:
> Dan Carpenter reported suspicious allocations of shadow variables
> in the sample module, see
> https://lkml.kernel.org/r/20200107132929.ficffmrm5ntpzcqa@kili.mountain
> 
> The code did not cause a real problem. But it was indeed misleading
> and semantically wrong. I got confused several times when cleaning it.
> So I decided to split the change into few steps. I hope that
> it will help reviewers and future readers.
> 
> The changes of the sample module are basically the same as in the RFC.
> In addition, there is a clean up of the module used by the selftest.
> 
> 
> Petr Mladek (4):
>   livepatch/sample: Use the right type for the leaking data pointer
>   livepatch/selftest: Clean up shadow variable names and type
>   livepatch/samples/selftest: Use klp_shadow_alloc() API correctly
>   livepatch: Handle allocation failure in the sample of shadow variable
>     API
> 
>  lib/livepatch/test_klp_shadow_vars.c      | 119 +++++++++++++++++-------------
>  samples/livepatch/livepatch-shadow-fix1.c |  39 ++++++----
>  samples/livepatch/livepatch-shadow-fix2.c |   4 +-
>  samples/livepatch/livepatch-shadow-mod.c  |   4 +-
>  4 files changed, 99 insertions(+), 67 deletions(-)
> 

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

-- 
Kamalesh

