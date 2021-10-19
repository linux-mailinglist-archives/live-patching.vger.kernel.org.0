Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63059433B2A
	for <lists+live-patching@lfdr.de>; Tue, 19 Oct 2021 17:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234319AbhJSPxV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Oct 2021 11:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233588AbhJSPxI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Oct 2021 11:53:08 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B70C06174E;
        Tue, 19 Oct 2021 08:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=o/7RP25S1GW09p0QWgcOavQHuiJrMZ36lgHo059V56M=; b=kxAK98dsJlnCofDf1Iu8vh1tS1
        u7xng5tcJee5/FuXH6f6TZ5llbfZXOgUZS31ySN/R6PTXuN+zIHuToISfwbG6/9Duyw12JvgnP/8I
        GQ3cMYiw4i+GqO8uh4PWY5wokKwqUevM0xA8swDHHQuO17XGXksIKqJTOUIGNoJgMf3xs5RwA6leh
        iMCDKeekwrIYuPacl/CZHNhjAO00M91lNdcEmgZKNdRDCj/J0ZOcS0hTNkKX10hhmLYTGuFdCGXso
        JGk8rPn2tuaOZGE+0c8k/dL8bE0C9tflBAZpMvfahP1+JGvVB6acXS33eDtaoDV1rjiYzmLt+sMGm
        XtulvDaw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mcrNc-00AnJE-1X; Tue, 19 Oct 2021 15:50:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 18D3B300288;
        Tue, 19 Oct 2021 17:50:18 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F13BD2025616C; Tue, 19 Oct 2021 17:50:17 +0200 (CEST)
Date:   Tue, 19 Oct 2021 17:50:17 +0200
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
Message-ID: <YW7pOTqMT49cIsKz@hirez.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152428.769328779@infradead.org>
 <ba4ca17f-100e-bef7-6d7b-4de0f5a515b9@quicinc.com>
 <a354fadd-268f-8119-d37a-102e5efa1437@quicinc.com>
 <YW6IUIRZsBAZ+6hK@hirez.programming.kicks-ass.net>
 <YW6LgO4OK+YPy90S@hirez.programming.kicks-ass.net>
 <468c435b-192b-790b-2a2d-8f7ddfb4a061@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468c435b-192b-790b-2a2d-8f7ddfb4a061@quicinc.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Oct 19, 2021 at 11:32:15AM -0400, Qian Cai wrote:
> 
> 
> On 10/19/2021 5:10 AM, Peter Zijlstra wrote:
> > Here, hows this then?
> > 
> > ---
> > diff --git a/kernel/smp.c b/kernel/smp.c
> > index ad0b68a3a3d3..61ddc7a3bafa 100644
> > --- a/kernel/smp.c
> > +++ b/kernel/smp.c
> > @@ -1170,14 +1170,12 @@ void wake_up_all_idle_cpus(void)
> >  {
> >  	int cpu;
> >  
> > -	cpus_read_lock();
> > -	for_each_online_cpu(cpu) {
> > -		if (cpu == raw_smp_processor_id())
> > -			continue;
> > -
> > -		wake_up_if_idle(cpu);
> > +	for_each_cpu(cpu) {
> > +		preempt_disable();
> > +		if (cpu != smp_processor_id() && cpu_online(cpu))
> > +			wake_up_if_idle(cpu);
> > +		preempt_enable();
> >  	}
> > -	cpus_read_unlock();
> >  }
> >  EXPORT_SYMBOL_GPL(wake_up_all_idle_cpus);
> 
> This does not compile.
> 
> kernel/smp.c:1173:18: error: macro "for_each_cpu" requires 2 arguments, but only 1 given

Bah, for_each_possible_cpu(), lemme update the patch, I'm sure the
robots will scream bloody murder on that too.
