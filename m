Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4D351F1A8
	for <lists+live-patching@lfdr.de>; Sun,  8 May 2022 22:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbiEHUpL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 8 May 2022 16:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232305AbiEHUpK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 8 May 2022 16:45:10 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5FFAE58;
        Sun,  8 May 2022 13:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AIZdv4JTMV0tgr/rdLMJ0LJYPCllAVNxOvYbroKKttk=; b=EhpxzdTqTZVDEObCACw4pmLjm/
        CXj0vEyT5BCwwOo6auvsgFAgrALxJoWM9Hf5JJFIJ1NAOBGdDDUJ8gG3E6BZYmC3HlbHzvUuS7cni
        8EuKaD9bWXzUWyTuu7RsG9bnPpETLSeF8UpIxIQdeUrUcnFT06/LQOF5bPdLdAZOGAMQjOUAWoyyi
        byeqBh248UwyLwqZ7yJVX33xq8E/lozf1vd9ukWF5+xvRkeTdn++UqtUlABdJraGccaRMWiDYo8rt
        z3e5xEO0z4yDfqrNKH5FAA1PwtYp9KjsaIY6oZDoTvrAzMuFfs/r82XTkzg51Rloid3yw4tfZjmrR
        j579v5cQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nnniA-00CMYT-6R; Sun, 08 May 2022 20:41:04 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3ED26980D51; Sun,  8 May 2022 22:41:01 +0200 (CEST)
Date:   Sun, 8 May 2022 22:41:01 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Rik van Riel <riel@fb.com>
Cc:     Song Liu <songliubraving@fb.com>,
        "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Message-ID: <20220508204101.GB76023@worktop.programming.kicks-ass.net>
References: <20220507174628.2086373-1-song@kernel.org>
 <1b7f0b76b6060b6a0ccd04fec2be6c0323907c8e.camel@fb.com>
 <36BA01F0-F2B7-4290-AB23-E61989262AB3@fb.com>
 <901aa9a48ef02eeec73dedf051dd0b14436ac22f.camel@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <901aa9a48ef02eeec73dedf051dd0b14436ac22f.camel@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat, May 07, 2022 at 07:18:51PM +0000, Rik van Riel wrote:
> Huh, I just looked at that, and the x86 should_resched()
> only seems to check that we _can_ resched, not whether
> we should...
> 
> 
> /*
>  * Returns true when we need to resched and can (barring IRQ state).
>  */
> static __always_inline bool should_resched(int preempt_offset)
> {
>         return unlikely(raw_cpu_read_4(__preempt_count) ==
> preempt_offset);
> }
> 
> I wonder if that was intended, and why, or whether
> the x86 should_resched should also be checking for
> TIF_NEED_RESCHED?

No, it does what you think it should do, you're just getting confused by
the inverted PREEMPT_NEED_RESCHED bit :-)
