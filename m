Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F3513215E
	for <lists+live-patching@lfdr.de>; Tue,  7 Jan 2020 09:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgAGI2p (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 Jan 2020 03:28:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:45134 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbgAGI2p (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 Jan 2020 03:28:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0A8EBAAA6;
        Tue,  7 Jan 2020 08:28:43 +0000 (UTC)
Date:   Tue, 7 Jan 2020 09:28:42 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jann Horn <jannh@google.com>, bpf@vger.kernel.org,
        live-patching@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <20200107082842.5w6zjgxy56wiftmm@pathway.suse.cz>
References: <CAG48ez2gDDRtKaOcGdKLREd7RGtVzCypXiBMHBguOGSpxQFk3w@mail.gmail.com>
 <20200106165654.GP2844@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200106165654.GP2844@hirez.programming.kicks-ass.net>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2020-01-06 17:56:54, Peter Zijlstra wrote:
> On Mon, Jan 06, 2020 at 05:39:30PM +0100, Jann Horn wrote:
> > Hi!
> > 
> > I was chatting with kpsingh about BPF trampolines, and I noticed that
> > it looks like BPF trampolines (as of current bpf-next/master) seem to
> > be missing synchronization between trampoline code updates and
> > trampoline execution. Or maybe I'm missing something?
> > 
> > If I understand correctly, trampolines are executed directly from the
> > fentry placeholders at the start of arbitrary kernel functions, so
> > they can run without any locks held. So for example, if task A starts
> > executing a trampoline on entry to sys_open(), then gets preempted in
> > the middle of the trampoline, and then task B quickly calls
> > BPF_RAW_TRACEPOINT_OPEN twice, and then task A continues execution,
> > task A will end up executing the middle of newly-written machine code,
> > which can probably end up crashing the kernel somehow?
> > 
> > I think that at least to synchronize trampoline text freeing with
> > concurrent trampoline execution, it is necessary to do something
> > similar to what the livepatching code does with klp_check_stack(), and
> > then either use a callback from the scheduler to periodically re-check
> > tasks that were in the trampoline or let the trampoline tail-call into
> > a cleanup helper that is part of normal kernel text. And you'd
> > probably have to gate BPF trampolines on
> > CONFIG_HAVE_RELIABLE_STACKTRACE.
> 
> ftrace uses synchronize_rcu_tasks() to flip between trampolines iirc.

ftrace calls also schedule_on_each_cpu(ftrace_sync) to handle
situations where RCU is not watching, see rcu_is_watching().

The following is called in ftrace_shutdown():

	schedule_on_each_cpu(ftrace_sync);

	if (IS_ENABLED(CONFIG_PREEMPTION))
		synchronize_rcu_tasks();

	arch_ftrace_trampoline_free(ops);

Best Regards,
Petr
