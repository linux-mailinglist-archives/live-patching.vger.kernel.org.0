Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23F4225A60
	for <lists+live-patching@lfdr.de>; Mon, 20 Jul 2020 10:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728024AbgGTIvK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 Jul 2020 04:51:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30348 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728049AbgGTIvK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 Jul 2020 04:51:10 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06K8V6gI100133;
        Mon, 20 Jul 2020 04:51:01 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32d5h8kq9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 04:51:01 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 06K8ZQDA115095;
        Mon, 20 Jul 2020 04:51:01 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32d5h8kq98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 04:51:01 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06K8noHd021654;
        Mon, 20 Jul 2020 08:50:59 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma02fra.de.ibm.com with ESMTP id 32brq7tg8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Jul 2020 08:50:59 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06K8ouFh55574752
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Jul 2020 08:50:56 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D61A3A4055;
        Mon, 20 Jul 2020 08:50:56 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFA64A4040;
        Mon, 20 Jul 2020 08:50:46 +0000 (GMT)
Received: from JAVRIS.in.ibm.com (unknown [9.199.50.137])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 20 Jul 2020 08:50:45 +0000 (GMT)
Subject: Re: [PATCH] Revert "kbuild: use -flive-patching when CONFIG_LIVEPATCH
 is enabled"
To:     Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>
References: <696262e997359666afa053fe7d1a9fb2bb373964.1595010490.git.jpoimboe@redhat.com>
 <fc7d4932-a043-1adc-fd9b-96211c508f64@redhat.com>
From:   Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Message-ID: <9c53c755-a497-25f0-40ae-7e435be3269b@linux.vnet.ibm.com>
Date:   Mon, 20 Jul 2020 14:20:35 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fc7d4932-a043-1adc-fd9b-96211c508f64@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-20_04:2020-07-17,2020-07-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 impostorscore=0 suspectscore=0 clxscore=1011 phishscore=0 bulkscore=0
 mlxscore=0 priorityscore=1501 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007200060
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 20/07/20 9:05 am, Joe Lawrence wrote:
> On 7/17/20 2:29 PM, Josh Poimboeuf wrote:
>> Use of the new -flive-patching flag was introduced with the following
>> commit:
>>
>>    43bd3a95c98e ("kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled")
>>
>> This flag has several drawbacks:
>>
>> [ ... snip ... ]
>>
>> - While there *is* a distro which relies on this flag for their distro
>>    livepatch module builds, there's not a publicly documented way to
>>    create safe livepatch modules with it.  Its use seems to be based on
>>    tribal knowledge.  It serves no benefit to those who don't know how to
>>    use it.
>>
>>    (In fact, I believe the current livepatch documentation and samples
>>    are misleading and dangerous, and should be corrected.  Or at least
>>    amended with a disclaimer.  But I don't feel qualified to make such
>>    changes.)
> 
> FWIW, I'm not exactly qualified to document source-based creation either, however I have written a few of the samples and obviously the kselftest modules.
> 
> The samples should certainly include a disclaimer (ie, they are only for API demonstration purposes!) and eventually it would be great if the kselftest modules could guarantee their safety as well.  I don't know quite yet how we can automate that, but perhaps some kind of post-build sanity check could verify that they are in fact patching what they intend to patch.
> 
> As for a more general, long-form warning about optimizations, I grabbed Miroslav's LPC slides from a few years back and poked around at some IPA-optimized disassembly... Here are my notes that attempt to capture some common cases:
> 
> http://file.bos.redhat.com/~jolawren/klp-compiler-notes/livepatch/compiler-considerations.html

Hi Joe,

The notes link you shared is not accessible.

Regards,

-- 
Kamalesh
