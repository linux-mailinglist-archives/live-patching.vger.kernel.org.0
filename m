Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B024150AC
	for <lists+live-patching@lfdr.de>; Wed, 22 Sep 2021 21:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237243AbhIVTty (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Sep 2021 15:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbhIVTtu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Sep 2021 15:49:50 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042C4C061574;
        Wed, 22 Sep 2021 12:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=1YATyr10hFKsEJyvlpPeeKxTucU8KD0HwbL0+C+7uQk=; b=jeWIYoP2uKYq5WeKPu8DnDeYnr
        rwd7Pn7gCthcDCndOfxADAFLUP9es9gLdBpu+klkOhiwbuMTZqQwnEA5Pmrl70WyYiX9lC2sa+SvA
        pcu1tFRRT40TNN8PCjrC1zx5E9igQyyC6+QaDSGIgXsWFVAtjKhdCzVY8FK7f3ssE3tVgvflRDCFT
        efnDqHETPgT412VUR5q5qt/IpFikXIj0B0usRmHzPYtnMf7vqg3mXfBWuaFFeDBvgXpV/6VbqVnd2
        gHSAyZR66ypzIYcRw37h8EEetF0rpqgq6lKuQAw8Fn1G2grGTW8jRKzECqWB1CdJRdYkzcabydK+Y
        rRRWkMoA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mT8Do-005484-Px; Wed, 22 Sep 2021 19:48:01 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id E449B3001CD;
        Wed, 22 Sep 2021 21:47:59 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id C86E62D7CF342; Wed, 22 Sep 2021 21:47:59 +0200 (CEST)
Date:   Wed, 22 Sep 2021 21:47:59 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org
Subject: Re: [RFC][PATCH 6/7] context_tracking: Provide SMP ordering using RCU
Message-ID: <YUuIb12XCQlBfIQW@hirez.programming.kicks-ass.net>
References: <20210922110506.703075504@infradead.org>
 <20210922110836.244770922@infradead.org>
 <20210922151721.GZ880162@paulmck-ThinkPad-P17-Gen-1>
 <YUuFF8+H2PE9m4wy@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUuFF8+H2PE9m4wy@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 22, 2021 at 09:33:43PM +0200, Peter Zijlstra wrote:

> Anyway, lemme see if I get your proposal; lets say the counter starts at
> 0 and is in kernel space.
> 
>  0x00(0) - kernel
>  0x02(2) - user
>  0x04(0) - kernel
> 
> So far so simple, then NMI on top of that goes:
> 
>  0x00(0) - kernel
>  0x03(3) - kernel + nmi
>  0x04(0) - kernel
>  0x06(2) - user
>  0x09(1) - user + nmi
>  0x0a(2) - user
> 
> Which then gives us:
> 
>  (0) := kernel
>  (1) := nmi-from-user
>  (2) := user
>  (3) := nmi-from-kernel
> 
> Which should work I suppose. But like I said above, I'd be happier if
> this counter would live in context_tracking rather than RCU.

Furthermore, if we have this counter, the we can also do things like:

  seq = context_tracking_seq_cpu(that_cpu);
  if ((seq & 3) != USER)
    // nohz_fail, do something
  set_tsk_thread_flag(curr_task(that_cpu), TIF_DO_SOME_WORK);
  if (seq == context_tracking_seq_cpu(that_cpu))
    // success!!

To remotely set pending state. Allowing yet more NOHZ_FULL fixes, like,
for example, eliding the text_poke IPIs.
