Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81587433A7D
	for <lists+live-patching@lfdr.de>; Tue, 19 Oct 2021 17:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhJSPed (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Oct 2021 11:34:33 -0400
Received: from alexa-out.qualcomm.com ([129.46.98.28]:43056 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhJSPec (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Oct 2021 11:34:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1634657540; x=1666193540;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9k1DtCLnVq8onijKayfDBwbvoGq8mjdO5uaTCO13EY8=;
  b=VUdr2YWzIRcr4NgjiCT6UTpG9D9T4JQkzyPL9zIWBVS4KxKSLqFq6+mZ
   qetZ40vx3+mL0zO9J1hP3fFHSlFW1SONETbo5SIkiltcuiiNYQmF+0WG6
   +rPSNWrbxg2CLqhRbjveN5EFRXA2cFg6j2rV30KEZ2OrmwW/CwtfDdJdZ
   Y=;
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 19 Oct 2021 08:32:20 -0700
X-QCInternal: smtphost
Received: from nalasex01a.na.qualcomm.com ([10.47.209.196])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 08:32:19 -0700
Received: from [10.111.162.88] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.7; Tue, 19 Oct 2021
 08:32:16 -0700
Message-ID: <468c435b-192b-790b-2a2d-8f7ddfb4a061@quicinc.com>
Date:   Tue, 19 Oct 2021 11:32:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 04/11] sched: Simplify wake_up_*idle*()
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
CC:     <gor@linux.ibm.com>, <jpoimboe@redhat.com>, <jikos@kernel.org>,
        <mbenes@suse.cz>, <pmladek@suse.com>, <mingo@kernel.org>,
        <linux-kernel@vger.kernel.org>, <joe.lawrence@redhat.com>,
        <fweisbec@gmail.com>, <tglx@linutronix.de>, <hca@linux.ibm.com>,
        <svens@linux.ibm.com>, <sumanthk@linux.ibm.com>,
        <live-patching@vger.kernel.org>, <paulmck@kernel.org>,
        <rostedt@goodmis.org>, <x86@kernel.org>
References: <20210929151723.162004989@infradead.org>
 <20210929152428.769328779@infradead.org>
 <ba4ca17f-100e-bef7-6d7b-4de0f5a515b9@quicinc.com>
 <a354fadd-268f-8119-d37a-102e5efa1437@quicinc.com>
 <YW6IUIRZsBAZ+6hK@hirez.programming.kicks-ass.net>
 <YW6LgO4OK+YPy90S@hirez.programming.kicks-ass.net>
From:   Qian Cai <quic_qiancai@quicinc.com>
In-Reply-To: <YW6LgO4OK+YPy90S@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 10/19/2021 5:10 AM, Peter Zijlstra wrote:
> Here, hows this then?
> 
> ---
> diff --git a/kernel/smp.c b/kernel/smp.c
> index ad0b68a3a3d3..61ddc7a3bafa 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -1170,14 +1170,12 @@ void wake_up_all_idle_cpus(void)
>  {
>  	int cpu;
>  
> -	cpus_read_lock();
> -	for_each_online_cpu(cpu) {
> -		if (cpu == raw_smp_processor_id())
> -			continue;
> -
> -		wake_up_if_idle(cpu);
> +	for_each_cpu(cpu) {
> +		preempt_disable();
> +		if (cpu != smp_processor_id() && cpu_online(cpu))
> +			wake_up_if_idle(cpu);
> +		preempt_enable();
>  	}
> -	cpus_read_unlock();
>  }
>  EXPORT_SYMBOL_GPL(wake_up_all_idle_cpus);

This does not compile.

kernel/smp.c:1173:18: error: macro "for_each_cpu" requires 2 arguments, but only 1 given
