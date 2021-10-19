Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055C7433FCD
	for <lists+live-patching@lfdr.de>; Tue, 19 Oct 2021 22:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbhJSUac (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Oct 2021 16:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234444AbhJSUab (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Oct 2021 16:30:31 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D156C06161C;
        Tue, 19 Oct 2021 13:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6b7foEorV/Dtu12KPrPdRAzqTPK/SNBhqPyk2+pmXVs=; b=Aw4pRq232YhNc2sooEgK3oomLw
        1C2IgWp0J0idwG1WvNLQmuTcRSpKW4PjgDw61D0SVxjv+PmvmEGNtKUn0aHsKzTlToR0hshUoPfYf
        v9D2taPRYc6jGAhwZcdJLtCbUtuyeDHot16bH52O2bfsiMPxFqT+ICs8ItNGCejvN98PZ1DrpO6Ln
        CY62BaQKv8bZ2F5ymq+md6hVcrZ7zjg62ZXacVweY7Q8OsAJ6Mm7Kt9yDDNn8KcHUz9X735ClDUg4
        IDZiqjyEvEA1RG7DyWykwAHCOx4qr/2bsjlsA0HjRth/OAYUQboG+Zx7Q+5po2UtFeETY3jd/ORTf
        PjtIGFcA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mcviG-00ApE1-1v; Tue, 19 Oct 2021 20:27:56 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 28A22986E12; Tue, 19 Oct 2021 22:27:55 +0200 (CEST)
Date:   Tue, 19 Oct 2021 22:27:55 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Qian Cai <quic_qiancai@quicinc.com>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [PATCH v2 04/11] sched: Simplify wake_up_*idle*()
Message-ID: <20211019202755.GO174703@worktop.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152428.769328779@infradead.org>
 <ba4ca17f-100e-bef7-6d7b-4de0f5a515b9@quicinc.com>
 <a354fadd-268f-8119-d37a-102e5efa1437@quicinc.com>
 <YW6IUIRZsBAZ+6hK@hirez.programming.kicks-ass.net>
 <YW6LgO4OK+YPy90S@hirez.programming.kicks-ass.net>
 <468c435b-192b-790b-2a2d-8f7ddfb4a061@quicinc.com>
 <YW7pOTqMT49cIsKz@hirez.programming.kicks-ass.net>
 <80919fdc-0f36-2f8a-627d-c1a97f1830fb@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80919fdc-0f36-2f8a-627d-c1a97f1830fb@quicinc.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Oct 19, 2021 at 03:22:43PM -0400, Qian Cai wrote:
> 
> 
> On 10/19/21 11:50 AM, Peter Zijlstra wrote:
> >>> diff --git a/kernel/smp.c b/kernel/smp.c
> >>> index ad0b68a3a3d3..61ddc7a3bafa 100644
> >>> --- a/kernel/smp.c
> >>> +++ b/kernel/smp.c
> >>> @@ -1170,14 +1170,12 @@ void wake_up_all_idle_cpus(void)
> >>>  {
> >>>  	int cpu;
> >>>  
> >>> -	cpus_read_lock();
> >>> -	for_each_online_cpu(cpu) {
> >>> -		if (cpu == raw_smp_processor_id())
> >>> -			continue;
> >>> -
> >>> -		wake_up_if_idle(cpu);
> >>> +	for_each_cpu(cpu) {
> >>> +		preempt_disable();
> >>> +		if (cpu != smp_processor_id() && cpu_online(cpu))
> >>> +			wake_up_if_idle(cpu);
> >>> +		preempt_enable();
> >>>  	}
> >>> -	cpus_read_unlock();
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(wake_up_all_idle_cpus);
> >>
> >> This does not compile.
> >>
> >> kernel/smp.c:1173:18: error: macro "for_each_cpu" requires 2 arguments, but only 1 given
> > 
> > Bah, for_each_possible_cpu(), lemme update the patch, I'm sure the
> > robots will scream bloody murder on that too.
> 
> This survived the regression tests here.

Thanks!
