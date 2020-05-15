Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4531D47D4
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2020 10:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgEOILw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 May 2020 04:11:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:51034 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726714AbgEOILv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 May 2020 04:11:51 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04F82MB8142346;
        Fri, 15 May 2020 04:11:35 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 310x56wnxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 04:11:34 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04F82Y7Q148621;
        Fri, 15 May 2020 04:11:34 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 310x56wnw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 04:11:34 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 04F8B6FY010452;
        Fri, 15 May 2020 08:11:31 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3100ubd70b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 May 2020 08:11:31 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04F8BTOo26935298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 May 2020 08:11:29 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E29A11C052;
        Fri, 15 May 2020 08:11:29 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 725EB11C050;
        Fri, 15 May 2020 08:11:27 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.199.53.165])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 15 May 2020 08:11:27 +0000 (GMT)
Subject: Re: [PATCH] MAINTAINERS: adjust to livepatch .klp.arch removal
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, Joe Perches <joe@perches.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200509073258.5970-1-lukas.bulwahn@gmail.com>
 <bfe91b2d-e319-bf12-6a15-4f200d0e8ea4@linux.vnet.ibm.com>
 <nycvar.YFH.7.76.2005142344230.25812@cbobk.fhfr.pm>
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Message-ID: <509c316f-5b34-2859-49aa-e4fe4a407428@linux.vnet.ibm.com>
Date:   Fri, 15 May 2020 13:41:25 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <nycvar.YFH.7.76.2005142344230.25812@cbobk.fhfr.pm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-15_02:2020-05-14,2020-05-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=824 impostorscore=0
 adultscore=0 clxscore=1015 cotscore=-2147483648 lowpriorityscore=0
 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005150066
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 5/15/20 3:15 AM, Jiri Kosina wrote:
> On Sat, 9 May 2020, Kamalesh Babulal wrote:
> 
>>> Commit 1d05334d2899 ("livepatch: Remove .klp.arch") removed
>>> arch/x86/kernel/livepatch.c, but missed to adjust the LIVE PATCHING entry
>>> in MAINTAINERS.
>>>
>>> Since then, ./scripts/get_maintainer.pl --self-test=patterns complains:
>>>
>>>   warning: no file matches  F:  arch/x86/kernel/livepatch.c
>>>
>>> So, drop that obsolete file entry in MAINTAINERS.
>>
>> Patch looks good to me,  you probably want to add following architecture
>> specific livepatching header files to the list:
>>
>> arch/s390/include/asm/livepatch.h
>> arch/powerpc/include/asm/livepatch.h
> 
> Good point, thanks for spotting it Kamalesh. I've queued the patch below 
> on top.
> 
> 

Thanks, Jiri. I realized later, that the lib/livepatch directory also needs
to be included in the list of files maintained under livepatch. Earlier, this
week I had sent a patch to the mailing list that includes both arch
headers and lib/livepatch to the list of files, the link to the patch is:

https://lore.kernel.org/live-patching/20200511061014.308675-1-kamalesh@linux.vnet.ibm.com/


-- 
Kamalesh
