Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12EF404762
	for <lists+live-patching@lfdr.de>; Thu,  9 Sep 2021 10:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhIIIza (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 Sep 2021 04:55:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3856 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231281AbhIIIza (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 Sep 2021 04:55:30 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1898ZCpJ043292;
        Thu, 9 Sep 2021 04:54:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=ZNPgUb+FZS502qe86XeIfSN1mu1UWdqhVXXKCo5YQX0=;
 b=pk67WyVobk4YCWkn+3Yis6IONyL1TkHhe22vwY+N0F/DfDuRwMFaDGCNCpWYDGzmcaRs
 Ni9WT5PWj3x/z34ty+IhoFPfyoJlkTPCKv+68UekQXzV5L6776xWO15LBBMKYfBW42w/
 KvBXPLGg+Bl7KtK2IuGpFxPYMHtT+Doi/BdOpDy0Wc1/RvNOA3Od6ZiaZXa/hnRw5JJo
 H489xLpM4tamLRkTsOtLYei/6JdSw/tBKYV9l6ZM/yH+ekJ+FztIEpIAgpQk2IB4swfB
 mWDC+cQOy57T/1wgBT++gjVUaHI3vKeaJW8UrVCoKwX6R0RwJX/jU2B9avMDitwxDTmu DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3axmeqwnv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 04:54:14 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1898ZGZH043653;
        Thu, 9 Sep 2021 04:54:14 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3axmeqwnun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 04:54:13 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1898rUcf032723;
        Thu, 9 Sep 2021 08:54:11 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 3axcnpj9hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 08:54:11 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1898s8jn45351326
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Sep 2021 08:54:08 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22F7C4C04E;
        Thu,  9 Sep 2021 08:54:08 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7FE774C04A;
        Thu,  9 Sep 2021 08:54:07 +0000 (GMT)
Received: from localhost (unknown [9.171.95.89])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  9 Sep 2021 08:54:07 +0000 (GMT)
Date:   Thu, 9 Sep 2021 10:54:05 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] livepatch: Kick idle cpu's tasks to perform
 transition
Message-ID: <your-ad-here.call-01631177645-ext-9742@work.hours>
References: <patch.git-b76842ceb035.your-ad-here.call-01625661932-ext-1304@work.hours>
 <YSjgj+ZzOutFxevl@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YSjgj+ZzOutFxevl@alley>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: x32Yu9QNCUVE6WArPSnYlIAfhind990_
X-Proofpoint-ORIG-GUID: GNJDJNBK3QlDS7wssBt2CGxKlh81urPM
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-09_02:2021-09-07,2021-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=972
 priorityscore=1501 clxscore=1011 lowpriorityscore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109090050
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Aug 27, 2021 at 02:54:39PM +0200, Petr Mladek wrote:
> On Wed 2021-07-07 14:49:38, Vasily Gorbik wrote:
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -415,8 +415,11 @@ void klp_try_complete_transition(void)
> >  	for_each_possible_cpu(cpu) {
> >  		task = idle_task(cpu);
> >  		if (cpu_online(cpu)) {
> > -			if (!klp_try_switch_task(task))
> > +			if (!klp_try_switch_task(task)) {
> >  				complete = false;
> > +				set_tsk_need_resched(task);
> 
> Is this really needed?

Yes, otherwise the inner idle loop is not left and
klp_update_patch_state() is not reached. Only waking up idle
cpus is not enough.

> > +				kick_process(task);
> 
> This would probably do the job. Well, I wonder if the following is
> a bit cleaner.
> 
> 		wake_up_if_idle(cpu);

wake_up_if_idle() is nice way to identify idle cpus, but it does not
force idle task rescheduling in our case.

> Also, please do this in klp_send_signals(). We kick there all other
> tasks that block the transition for too long.

#define SIGNALS_TIMEOUT 15

Hm, kicking the idle threads in klp_send_signals() means extra 15 seconds
delay for every transition in our case and failing kselftests:

# --- expected
# +++ result
...
#  livepatch: 'test_klp_livepatch': starting patching transition
# +livepatch: signaling remaining tasks
#  livepatch: 'test_klp_livepatch': completing patching transition

BTW, for x86 I made a lousy tests with 128 cpus in kvm. With default
CONFIG_NO_HZ_IDLE=y kselftests are failing the same way. Sometimes
transition times out as well, despite NO_HZ options configurations.

Jul 09 11:43:33 q.q kernel: livepatch: 'test_klp_livepatch': starting patching transition
Jul 09 11:44:37 q.q kernel: livepatch: 'test_klp_livepatch': starting unpatching transition
Jul 09 11:45:40 q.q ERROR: failed to disable livepatch test_klp_livepatch

I understand this 15 seconds delay for loaded system and tasks doing real
work is good, but those lazy idle "running" tasks could be kicked right
away with no harm done, right? Given we are able to identify them reliably.
I'll send another patch version.
