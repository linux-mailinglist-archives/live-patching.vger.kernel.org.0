Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3904F13165E
	for <lists+live-patching@lfdr.de>; Mon,  6 Jan 2020 17:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgAFQ5Q (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Jan 2020 11:57:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43152 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAFQ5P (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Jan 2020 11:57:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KtA6VhFyLFqi7kWb+PYao12HEhPZ8hVXP/AvLkDg57w=; b=a5X7Xgvn+fusWiITMXIBJxch6
        EibH0GZfsBa2Tv9KJ+ZrJeS+EMTFUA37iCHDQ/323udgQbtuCpXVVvBd2Cb47R25VSxG2xSyKYPoH
        Mg4HVzLO1jpMtvDH/YH0NMqO8phqEKdv8gwhGNdVwRb5rVIcSf0XB5xLWl1Wgd+Ifl16JA37EXwaS
        aAJOJnW0/B1z9hvPB6HziekS9RhBQ/qb1DMlJIqpu1mONgo4IEaaiUsFfub1LuVbNUtWf/DolglDm
        KaEVL1bzv8juBkJM4P1B8MhCoMUPZwSewjJRJLwdhjw8AtT9mr6JESczMhgynMp9FsMRptO6rtteP
        gu+7D+CfA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ioVgY-00046W-7E; Mon, 06 Jan 2020 16:56:58 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id CC2CF3012DC;
        Mon,  6 Jan 2020 17:55:22 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E06D12B2844FC; Mon,  6 Jan 2020 17:56:54 +0100 (CET)
Date:   Mon, 6 Jan 2020 17:56:54 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jann Horn <jannh@google.com>
Cc:     bpf@vger.kernel.org, live-patching@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        KP Singh <kpsingh@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: BPF tracing trampoline synchronization between update/freeing
 and execution?
Message-ID: <20200106165654.GP2844@hirez.programming.kicks-ass.net>
References: <CAG48ez2gDDRtKaOcGdKLREd7RGtVzCypXiBMHBguOGSpxQFk3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2gDDRtKaOcGdKLREd7RGtVzCypXiBMHBguOGSpxQFk3w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jan 06, 2020 at 05:39:30PM +0100, Jann Horn wrote:
> Hi!
> 
> I was chatting with kpsingh about BPF trampolines, and I noticed that
> it looks like BPF trampolines (as of current bpf-next/master) seem to
> be missing synchronization between trampoline code updates and
> trampoline execution. Or maybe I'm missing something?
> 
> If I understand correctly, trampolines are executed directly from the
> fentry placeholders at the start of arbitrary kernel functions, so
> they can run without any locks held. So for example, if task A starts
> executing a trampoline on entry to sys_open(), then gets preempted in
> the middle of the trampoline, and then task B quickly calls
> BPF_RAW_TRACEPOINT_OPEN twice, and then task A continues execution,
> task A will end up executing the middle of newly-written machine code,
> which can probably end up crashing the kernel somehow?
> 
> I think that at least to synchronize trampoline text freeing with
> concurrent trampoline execution, it is necessary to do something
> similar to what the livepatching code does with klp_check_stack(), and
> then either use a callback from the scheduler to periodically re-check
> tasks that were in the trampoline or let the trampoline tail-call into
> a cleanup helper that is part of normal kernel text. And you'd
> probably have to gate BPF trampolines on
> CONFIG_HAVE_RELIABLE_STACKTRACE.

ftrace uses synchronize_rcu_tasks() to flip between trampolines iirc.
