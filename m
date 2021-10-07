Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C04424FE6
	for <lists+live-patching@lfdr.de>; Thu,  7 Oct 2021 11:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240517AbhJGJU5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 Oct 2021 05:20:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7848 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232659AbhJGJU5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 Oct 2021 05:20:57 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1977W7Xp009635;
        Thu, 7 Oct 2021 05:18:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=Wzrukczw15LK8HvZd99FOkvgp0owYAsdfSKcwdhl9QE=;
 b=UskT+SZFdZHLvhu+UdQiQfMvH7TvrOwHspcSv9hxPiLJAAE1RXA1mgt7jfDJN5lCHIuo
 XHNiQfGu8dkIMWYhNA/zRE+cqqIaHUF29uxMhKDwiSnnO+qqyV4hb2KNJsGzdpGWqYO9
 n+vGlkXx4eXBvEbK1abF0zCfrCy02uicRFO/YLfbwEv+sWlOjPZgb5IMeiWvF36Ats9M
 VvmuTr4SRQuSl3vwVCekzSlHtJhFZiO58ZYC1lIOSMRdhqnzsd4jlfp01yFsGzMZt+XB
 BkxWIMYQmCy2LDisN9nHYdlZ1hZ5hJMeaEkrhmKry6IaZwsmhAZpwdMBy0oo8Cdaw/eT mA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhh5qgfb9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 05:18:23 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1977wOdT010665;
        Thu, 7 Oct 2021 05:18:22 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bhh5qgfab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 05:18:22 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1979BtE2010609;
        Thu, 7 Oct 2021 09:18:20 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03fra.de.ibm.com with ESMTP id 3bef2a2y5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Oct 2021 09:18:19 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1979CtXd55378266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Oct 2021 09:12:55 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF72042041;
        Thu,  7 Oct 2021 09:18:15 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECD7F42049;
        Thu,  7 Oct 2021 09:18:14 +0000 (GMT)
Received: from localhost (unknown [9.171.37.112])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  7 Oct 2021 09:18:14 +0000 (GMT)
Date:   Thu, 7 Oct 2021 11:18:13 +0200
From:   Vasily Gorbik <gor@linux.ibm.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     jpoimboe@redhat.com, jikos@kernel.org, pmladek@suse.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [PATCH v2 05/11] sched,livepatch: Use wake_up_if_idle()
Message-ID: <your-ad-here.call-01633598293-ext-3109@work.hours>
References: <20210929151723.162004989@infradead.org>
 <20210929152428.828064133@infradead.org>
 <alpine.LSU.2.21.2110061115270.2311@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2110061115270.2311@pobox.suse.cz>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: H3nbL9NBVejCAmW2NK7LNKwaSQ_dFsh7
X-Proofpoint-ORIG-GUID: NzHNG0KrNIKfvbs4_8kSr5N_ZUEnx6Wc
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-10-06_04,2021-10-07_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1011 malwarescore=0 spamscore=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109230001 definitions=main-2110070063
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 06, 2021 at 11:16:21AM +0200, Miroslav Benes wrote:
> On Wed, 29 Sep 2021, Peter Zijlstra wrote:
> 
> > Make sure to prod idle CPUs so they call klp_update_patch_state().
> > 
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > ---
> >  kernel/livepatch/transition.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > --- a/kernel/livepatch/transition.c
> > +++ b/kernel/livepatch/transition.c
> > @@ -413,8 +413,11 @@ void klp_try_complete_transition(void)
> >  	for_each_possible_cpu(cpu) {
> >  		task = idle_task(cpu);
> >  		if (cpu_online(cpu)) {
> > -			if (!klp_try_switch_task(task))
> > +			if (!klp_try_switch_task(task)) {
> >  				complete = false;
> > +				/* Make idle task go through the main loop. */
> > +				wake_up_if_idle(cpu);
> > +			}
> 
> Right, it should be enough.
> 
> Acked-by: Miroslav Benes <mbenes@suse.cz>
> 
> It would be nice to get Vasily's Tested-by tag on this one.

I gave patches a spin on s390 with livepatch kselftest as well as with
https://github.com/lpechacek/qa_test_klp.git

BTW, commit 43c79fbad385 ("klp_tc_17: Avoid running the test on
s390x") is no longer required, since s390 implements HAVE_KPROBES_ON_FTRACE
since v5.6, so I just reverted test disablement.

Patches 1-6 work nicely, for them

Acked-by: Vasily Gorbik <gor@linux.ibm.com>
Tested-by: Vasily Gorbik <gor@linux.ibm.com> # on s390

Thanks a lot!

Starting with patch 8 is where I start seeing this with my config:

Oct 07 10:46:00 kernel: Freeing unused kernel image (initmem) memory: 6524K
Oct 07 10:46:00 kernel: INFO: task swapper/0:1 blocked for more than 122 seconds.
Oct 07 10:46:00 kernel:       Not tainted 5.15.0-rc4-69810-ga714851e1aad-dirty #74
Oct 07 10:46:00 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Oct 07 10:46:00 kernel: task:swapper/0       state:D stack:10648 pid:    1 ppid:     0 flags:0x00000000
Oct 07 10:46:00 kernel: Call Trace:
Oct 07 10:46:00 kernel:  [<0000000000e164b6>] __schedule+0x36e/0x8b0
Oct 07 10:46:00 kernel:  [<0000000000e16a4e>] schedule+0x56/0x128
Oct 07 10:46:00 kernel:  [<0000000000e1e426>] schedule_timeout+0x106/0x160
Oct 07 10:46:00 kernel:  [<0000000000e18316>] wait_for_completion+0xc6/0x118
Oct 07 10:46:00 kernel:  [<000000000020a15c>] rcu_barrier.part.0+0x17c/0x2c0
Oct 07 10:46:00 kernel:  [<0000000000e0fcc0>] kernel_init+0x60/0x168
Oct 07 10:46:00 kernel:  [<000000000010390c>] __ret_from_fork+0x3c/0x58
Oct 07 10:46:00 kernel:  [<0000000000e2094a>] ret_from_fork+0xa/0x30
Oct 07 10:46:00 kernel: 1 lock held by swapper/0/1:
Oct 07 10:46:00 kernel:  #0: 0000000001469600 (rcu_state.barrier_mutex){+.+.}-{3:3}, at: rcu_barrier+0x42/0x80
Oct 07 10:46:00 kernel:
                        Showing all locks held in the system:
Oct 07 10:46:00 kernel: 1 lock held by swapper/0/1:
Oct 07 10:46:00 kernel:  #0: 0000000001469600 (rcu_state.barrier_mutex){+.+.}-{3:3}, at: rcu_barrier+0x42/0x80
Oct 07 10:46:00 kernel: 2 locks held by kworker/u680:0/8:
Oct 07 10:46:00 kernel:  #0: 000000008013cd48 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work+0x222/0x738
Oct 07 10:46:00 kernel:  #1: 0000038000043dc8 ((kfence_timer).work){+.+.}-{0:0}, at: process_one_work+0x222/0x738
Oct 07 10:46:00 kernel: 1 lock held by khungtaskd/413:
Oct 07 10:46:00 kernel:  #0: 000000000145c980 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire.constprop.0+0x0/0x50
Oct 07 10:46:00 kernel:
Oct 07 10:46:00 kernel: =============================================

So, will keep an eye on the rest of these patches and re-test in future, thanks!
