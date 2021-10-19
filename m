Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5B8B4331F8
	for <lists+live-patching@lfdr.de>; Tue, 19 Oct 2021 11:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbhJSJRt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 19 Oct 2021 05:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234511AbhJSJRq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 19 Oct 2021 05:17:46 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B1EC061768;
        Tue, 19 Oct 2021 02:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M74+/if23OdvvyA6a/gJ9u3knPoaJ8QASoM6JWUmAfg=; b=vYHOQbqwa8BG777Qm7rqJzKO0w
        vkvU8IjgOjvSIJwmaEWntGl+X0usNC6/NqijaY6z9GczT6VgIlVYE+mcs0I7wc+rf0i6jDU8Qifx/
        Donz7RFxenTlsZVs2mXjt0UPmkvuQdMQ9Edn4Tumq/r78A7zXHO+BenWdvnS2nNybPE4eTv1G4UxR
        dE5Hn3fQbDwVHrP1RGjH5SU8NbJKqoZwUKc1ku69PZBQiIJUxCw37eEq2NqRG2gtu+l3rsAB++AXL
        AqV7zz/GG2plIOYjN19IuYFkEIBt/e0wPIp5RhTxoG/vbfiYcdDnHSbDVv5PVwy0vMzDp7R/uVTfR
        XjrmaEqA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mcl8a-00BeBf-Ny; Tue, 19 Oct 2021 09:11:33 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A78FD300221;
        Tue, 19 Oct 2021 11:10:24 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8E7A52C6A7ABD; Tue, 19 Oct 2021 11:10:24 +0200 (CEST)
Date:   Tue, 19 Oct 2021 11:10:24 +0200
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
Message-ID: <YW6LgO4OK+YPy90S@hirez.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152428.769328779@infradead.org>
 <ba4ca17f-100e-bef7-6d7b-4de0f5a515b9@quicinc.com>
 <a354fadd-268f-8119-d37a-102e5efa1437@quicinc.com>
 <YW6IUIRZsBAZ+6hK@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YW6IUIRZsBAZ+6hK@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Oct 19, 2021 at 10:56:48AM +0200, Peter Zijlstra wrote:
> On Mon, Oct 18, 2021 at 11:47:32PM -0400, Qian Cai wrote:
> > Peter, any thoughts? I did confirm that reverting the commit fixed the issue.
> > 
> > On 10/13/2021 10:32 AM, Qian Cai wrote:
> > > 
> > > 
> > > On 9/29/2021 11:17 AM, Peter Zijlstra wrote:
> > >> --- a/kernel/smp.c
> > >> +++ b/kernel/smp.c
> > >> @@ -1170,14 +1170,14 @@ void wake_up_all_idle_cpus(void)
> > >>  {
> > >>  	int cpu;
> > >>  
> > >> -	preempt_disable();
> > >> +	cpus_read_lock();
> > >>  	for_each_online_cpu(cpu) {
> > >> -		if (cpu == smp_processor_id())
> > >> +		if (cpu == raw_smp_processor_id())
> > >>  			continue;
> > >>  
> > >>  		wake_up_if_idle(cpu);
> > >>  	}
> > >> -	preempt_enable();
> > >> +	cpus_read_unlock();
> 
> Right, so yesterday I thought: YW2KGrvvv/vSA+97@hirez.programming.kicks-ass.net
> but today I might have another idea, lemme go prod at this a bit more.

Here, hows this then?

---
diff --git a/kernel/smp.c b/kernel/smp.c
index ad0b68a3a3d3..61ddc7a3bafa 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -1170,14 +1170,12 @@ void wake_up_all_idle_cpus(void)
 {
 	int cpu;
 
-	cpus_read_lock();
-	for_each_online_cpu(cpu) {
-		if (cpu == raw_smp_processor_id())
-			continue;
-
-		wake_up_if_idle(cpu);
+	for_each_cpu(cpu) {
+		preempt_disable();
+		if (cpu != smp_processor_id() && cpu_online(cpu))
+			wake_up_if_idle(cpu);
+		preempt_enable();
 	}
-	cpus_read_unlock();
 }
 EXPORT_SYMBOL_GPL(wake_up_all_idle_cpus);
 
