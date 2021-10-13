Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFB9342B374
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 05:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237326AbhJMD3G convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Oct 2021 23:29:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:59236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhJMD3G (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Oct 2021 23:29:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D494603E8;
        Wed, 13 Oct 2021 03:27:00 +0000 (UTC)
Date:   Tue, 12 Oct 2021 23:26:58 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc:     Guo Ren <guoren@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v2 0/2] fix & prevent the missing preemption disabling
Message-ID: <20211012232658.7dac3f43@oasis.local.home>
In-Reply-To: <1a8e8d73-b508-f90b-0d82-eb2da45a720e@linux.alibaba.com>
References: <8c7de46d-9869-aa5e-2bb9-5dbc2eda395e@linux.alibaba.com>
        <1a8e8d73-b508-f90b-0d82-eb2da45a720e@linux.alibaba.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Please start a new thread when sending new versions. v2 should not be a
reply to v1. If you want to reference v1, just add it to the cover
letter with a link tag:

Link: https://lore.kernel.org/all/8c7de46d-9869-aa5e-2bb9-5dbc2eda395e@linux.alibaba.com/

-- Steve


On Wed, 13 Oct 2021 11:16:56 +0800
王贇 <yun.wang@linux.alibaba.com> wrote:

> The testing show that perf_ftrace_function_call() are using smp_processor_id()
> with preemption enabled, all the checking on CPU could be wrong after preemption.
> 
> As Peter point out, the section between ftrace_test_recursion_trylock/unlock()
> pair require the preemption to be disabled as 'Documentation/trace/ftrace-uses.rst'
> explained, but currently the work is done outside of the helpers.
> 
> Patch 1/2 will make sure preemption disabled after trylock() succeed,
> patch 2/2 will do smp_processor_id() checking after trylock to address the
> issue.
> 
> Michael Wang (2):
>   ftrace: disable preemption between ftrace_test_recursion_trylock/unlock()
>   ftrace: do CPU checking after preemption disabled
> 
>  arch/csky/kernel/probes/ftrace.c     |  2 --
>  arch/parisc/kernel/ftrace.c          |  2 --
>  arch/powerpc/kernel/kprobes-ftrace.c |  2 --
>  arch/riscv/kernel/probes/ftrace.c    |  2 --
>  arch/x86/kernel/kprobes/ftrace.c     |  2 --
>  include/linux/trace_recursion.h      | 22 +++++++++++++++++++++-
>  kernel/livepatch/patch.c             |  6 ------
>  kernel/trace/trace_event_perf.c      |  6 +++---
>  kernel/trace/trace_functions.c       |  5 -----
>  9 files changed, 24 insertions(+), 25 deletions(-)
> 

