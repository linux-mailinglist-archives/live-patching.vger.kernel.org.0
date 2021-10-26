Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3F243BB27
	for <lists+live-patching@lfdr.de>; Tue, 26 Oct 2021 21:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238907AbhJZTne (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Oct 2021 15:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237071AbhJZTnc (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Oct 2021 15:43:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D92C061570;
        Tue, 26 Oct 2021 12:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=6rfHuZsBNMziMsqcuQ1ZvaqRNzhO0dLy0a/xN09cyHY=; b=GNO9pHnS7oYlpU+YWWUI0EPiCI
        L8a3PkUz8rH3KNan5t4wQ3gzsaU23Be4c1hiTdkgitcsl/96tzZdGz0BoVLnbcB/ZKL5YO/Tp5ge8
        x5bGbIFqZ/xoouafMKd6AenJQV3I/gAYN89IswX2y9+osvAwCUKhQmEQbbxY73JaZJT0+a0bMl0cd
        O6LG0DEiOIhnT0Q1Rta8+5TyGTRU5xseip5XulLOl+lWf9RlI7aXpQQPbWyl+4g+CKR62MZQHGSma
        +IojYOcfbM7GxqOTl1SOTS52Pu13iFPvGVynVxaSsBw8q2sMwu//bqSxBwzg94JD7B02e1zLsY4Zs
        tqVHYXIg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mfSH0-00H79p-Mi; Tue, 26 Oct 2021 19:38:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3C4163002AE;
        Tue, 26 Oct 2021 21:38:13 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 27EB72BC9DBD8; Tue, 26 Oct 2021 21:38:13 +0200 (CEST)
Date:   Tue, 26 Oct 2021 21:38:13 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [RFC][PATCH v2 11/11] context_tracking,x86: Fix text_poke_sync()
 vs NOHZ_FULL
Message-ID: <YXhZJZmUHVGa1aUr@hirez.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152429.186930629@infradead.org>
 <20211021183935.GA9071@fuller.cnet>
 <20211021192543.GV174703@worktop.programming.kicks-ass.net>
 <20211021195709.GA22422@fuller.cnet>
 <20211021201859.GX174703@worktop.programming.kicks-ass.net>
 <20211026181911.GA178890@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026181911.GA178890@fuller.cnet>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Oct 26, 2021 at 03:19:11PM -0300, Marcelo Tosatti wrote:
> On Thu, Oct 21, 2021 at 10:18:59PM +0200, Peter Zijlstra wrote:
> > On Thu, Oct 21, 2021 at 04:57:09PM -0300, Marcelo Tosatti wrote:
> > > > Pretty much everything in noinstr is magical, we just have to think
> > > > harder there (and possibly start writing more comments there).
> > > 
> > > mds_user_clear_cpu_buffers happens after sync_core, in your patchset, 
> > > if i am not mistaken.
> > 
> > Of course it does, mds_user_clear_cpu_buffers() is on exit, the
> > sync_core() is on entry.
> 
>                                                                   static_key enable/disable
> 
> __exit_to_user_mode ->                                            context_tracking_set_cpu_work(cpu, work)
>    user_enter_irqoff ->                                                  preempt_disable();
>    __context_tracking_enter(CONTEXT_USER);                               seq = atomic_read(&ct->seq);
>       ct_seq_user_enter(raw_cpu_ptr(&context_tracking));                 if (__context_tracking_seq_in_user(seq)) {
>       {                                                                          /* ctrl-dep */
>         arch_atomic_set(&ct->work, 0);                                           atomic_or(work, &ct->work);
>         return arch_atomic_add_return(CT_SEQ_USER, &ct->seq);                    ret = atomic_try_cmpxchg(&ct->seq, &seq, seq|CT_SEQ_WORK);
>                                                                          }
>       }                                                                  preempt_enable();
>    arch_exit_to_user_mode()
>    mds_user_clear_cpu_buffers();  <--- sync_core work queued,
>                                        but not executed.
>                                        i-cache potentially stale?
> 
> ct_seq_user_enter should happen _after_ all possible static_key users?

Right, so this one is actually okay, because that branch is *never*
changed after boot.

I'm not quite sure why it isn't an alternative(). At some point I
proposed static_call_lock() [1] and the corrolary is static_branch_lock(),
which I suppose could be employed here. But I'm not sure that actually
helps much with auditing all that.


[1] https://lkml.kernel.org/r/20210904105529.GA5106@worktop.programming.kicks-ass.net
