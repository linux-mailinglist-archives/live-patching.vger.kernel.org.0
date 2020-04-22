Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC1291B477E
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2020 16:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgDVOkr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Apr 2020 10:40:47 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12750 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726138AbgDVOkq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Apr 2020 10:40:46 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03MEXcHM053355
        for <live-patching@vger.kernel.org>; Wed, 22 Apr 2020 10:40:45 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gfecuhd5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Wed, 22 Apr 2020 10:40:45 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <live-patching@vger.kernel.org> from <gerald.schaefer@de.ibm.com>;
        Wed, 22 Apr 2020 15:39:49 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 22 Apr 2020 15:39:46 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03MEedH659375906
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 14:40:39 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 574CF11C058;
        Wed, 22 Apr 2020 14:40:39 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0847111C05E;
        Wed, 22 Apr 2020 14:40:39 +0000 (GMT)
Received: from thinkpad (unknown [9.145.91.245])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Apr 2020 14:40:38 +0000 (GMT)
Date:   Wed, 22 Apr 2020 16:40:37 +0200
From:   Gerald Schaefer <gerald.schaefer@de.ibm.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Jessica Yu <jeyu@kernel.org>, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: Re: [PATCH v2 6/9] s390/module: Use s390_kernel_write() for late
 relocations
In-Reply-To: <18266eb2c2c9a2ce0033426837d89dcb363a85d3.1587131959.git.jpoimboe@redhat.com>
References: <cover.1587131959.git.jpoimboe@redhat.com>
        <18266eb2c2c9a2ce0033426837d89dcb363a85d3.1587131959.git.jpoimboe@redhat.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20042214-0020-0000-0000-000003CC96C8
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042214-0021-0000-0000-000022259353
Message-Id: <20200422164037.7edd21ea@thinkpad>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_06:2020-04-22,2020-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220116
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 17 Apr 2020 09:04:31 -0500
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> From: Peter Zijlstra <peterz@infradead.org>
> 
> Because of late module patching, a livepatch module needs to be able to
> apply some of its relocations well after it has been loaded.  Instead of
> playing games with module_{dis,en}able_ro(), use existing text poking
> mechanisms to apply relocations after module loading.
> 
> So far only x86, s390 and Power have HAVE_LIVEPATCH but only the first
> two also have STRICT_MODULE_RWX.
> 
> This will allow removal of the last module_disable_ro() usage in
> livepatch.  The ultimate goal is to completely disallow making
> executable mappings writable.
> 
> Also, for the late patching case, use text_mutex, which is supposed to
> be held for all runtime text patching operations.
> 
> [ jpoimboe: Split up patches.  Use mod state to determine whether
> 	    memcpy() can be used.  Add text_mutex.  Make it build. ]
> 
> Cc: linux-s390@vger.kernel.org
> Cc: heiko.carstens@de.ibm.com
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
>  arch/s390/kernel/module.c | 125 ++++++++++++++++++++++++--------------
>  1 file changed, 79 insertions(+), 46 deletions(-)

Sorry, just noticed this. Heiko will return next month, and I'm not
really familiar with s390 livepatching. Adding Vasily, he might
have some more insight.

So, I might be completely wrong here, but using s390_kernel_write()
for writing to anything other than 1:1 mapped kernel, should go
horribly wrong, as that runs w/o DAT. It would allow to bypass
DAT write protection, which I assume is why you want to use it,
but it should not work on module text section, as that would be
in vmalloc space and not 1:1 mapped kernel memory.

Not quite sure how to test / trigger this, did this really work for
you on s390?

Regards,
Gerald

