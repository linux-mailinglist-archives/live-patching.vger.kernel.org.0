Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D97B4331A5
	for <lists+live-patching@lfdr.de>; Tue, 19 Oct 2021 10:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhJSI7b (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Oct 2021 04:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhJSI7a (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Oct 2021 04:59:30 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41ADC06161C;
        Tue, 19 Oct 2021 01:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AePeC9nA2QI6mWSGX2S/0MTDQgzbvo7+Ukm6tKpOg5I=; b=HxaWCe95q0/3cE+7mOP3m/kEfH
        Y2+gVJAGq+7bjltDYOYzZMWn/PGR+LaIaVowHT1i1QYrAzPvaivHI3OuVqqRIbneHA5pZwIZB8QU6
        focq0fcKVEX9QyPd/lsA1RnilWQa8iHlsZP2NB5Y/ujI49B8AVEnDdlikDhUCFwQJWI0cpyprJKFS
        ND+jYxE6mdi6iePTFjhHBHEMVoqxBEKVm/G1om5wfdXe8HrQpatjn8pIFA0sf+wsjlS6ROzQalk+E
        GP90/eIUMybnDPG6lOC7hRjKZX0M/9iw/1dEUVFoBDUy/MbYTkNZkZ/Ci7rJv1l3lmsSp6GrZELGu
        QewadT/A==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mckvR-00AkJc-Kb; Tue, 19 Oct 2021 08:56:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 62AFF30024D;
        Tue, 19 Oct 2021 10:56:48 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3C1622C7C11E1; Tue, 19 Oct 2021 10:56:48 +0200 (CEST)
Date:   Tue, 19 Oct 2021 10:56:48 +0200
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
Message-ID: <YW6IUIRZsBAZ+6hK@hirez.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152428.769328779@infradead.org>
 <ba4ca17f-100e-bef7-6d7b-4de0f5a515b9@quicinc.com>
 <a354fadd-268f-8119-d37a-102e5efa1437@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a354fadd-268f-8119-d37a-102e5efa1437@quicinc.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Oct 18, 2021 at 11:47:32PM -0400, Qian Cai wrote:
> Peter, any thoughts? I did confirm that reverting the commit fixed the issue.
> 
> On 10/13/2021 10:32 AM, Qian Cai wrote:
> > 
> > 
> > On 9/29/2021 11:17 AM, Peter Zijlstra wrote:
> >> --- a/kernel/smp.c
> >> +++ b/kernel/smp.c
> >> @@ -1170,14 +1170,14 @@ void wake_up_all_idle_cpus(void)
> >>  {
> >>  	int cpu;
> >>  
> >> -	preempt_disable();
> >> +	cpus_read_lock();
> >>  	for_each_online_cpu(cpu) {
> >> -		if (cpu == smp_processor_id())
> >> +		if (cpu == raw_smp_processor_id())
> >>  			continue;
> >>  
> >>  		wake_up_if_idle(cpu);
> >>  	}
> >> -	preempt_enable();
> >> +	cpus_read_unlock();

Right, so yesterday I thought: YW2KGrvvv/vSA+97@hirez.programming.kicks-ass.net
but today I might have another idea, lemme go prod at this a bit more.
