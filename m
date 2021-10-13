Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB05842B3A5
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 05:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235927AbhJMDfi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Oct 2021 23:35:38 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:56708 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233169AbhJMDfh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Oct 2021 23:35:37 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0Ure8YWn_1634096007;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Ure8YWn_1634096007)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Oct 2021 11:33:29 +0800
Subject: Re: [PATCH v2 0/2] fix & prevent the missing preemption disabling
To:     Steven Rostedt <rostedt@goodmis.org>
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
References: <8c7de46d-9869-aa5e-2bb9-5dbc2eda395e@linux.alibaba.com>
 <1a8e8d73-b508-f90b-0d82-eb2da45a720e@linux.alibaba.com>
 <20211012232658.7dac3f43@oasis.local.home>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <69e9cf98-883c-0016-4b07-12afbf138094@linux.alibaba.com>
Date:   Wed, 13 Oct 2021 11:33:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211012232658.7dac3f43@oasis.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2021/10/13 上午11:26, Steven Rostedt wrote:
> Please start a new thread when sending new versions. v2 should not be a
> reply to v1. If you want to reference v1, just add it to the cover
> letter with a link tag:
> 
> Link: https://lore.kernel.org/all/8c7de46d-9869-aa5e-2bb9-5dbc2eda395e@linux.alibaba.com/

Ok, I'll resend it with link then.

Regards,
Michael Wang


> 
> -- Steve
> 
> 
> On Wed, 13 Oct 2021 11:16:56 +0800
> 王贇 <yun.wang@linux.alibaba.com> wrote:
> 
>> The testing show that perf_ftrace_function_call() are using smp_processor_id()
>> with preemption enabled, all the checking on CPU could be wrong after preemption.
>>
>> As Peter point out, the section between ftrace_test_recursion_trylock/unlock()
>> pair require the preemption to be disabled as 'Documentation/trace/ftrace-uses.rst'
>> explained, but currently the work is done outside of the helpers.
>>
>> Patch 1/2 will make sure preemption disabled after trylock() succeed,
>> patch 2/2 will do smp_processor_id() checking after trylock to address the
>> issue.
>>
>> Michael Wang (2):
>>   ftrace: disable preemption between ftrace_test_recursion_trylock/unlock()
>>   ftrace: do CPU checking after preemption disabled
>>
>>  arch/csky/kernel/probes/ftrace.c     |  2 --
>>  arch/parisc/kernel/ftrace.c          |  2 --
>>  arch/powerpc/kernel/kprobes-ftrace.c |  2 --
>>  arch/riscv/kernel/probes/ftrace.c    |  2 --
>>  arch/x86/kernel/kprobes/ftrace.c     |  2 --
>>  include/linux/trace_recursion.h      | 22 +++++++++++++++++++++-
>>  kernel/livepatch/patch.c             |  6 ------
>>  kernel/trace/trace_event_perf.c      |  6 +++---
>>  kernel/trace/trace_functions.c       |  5 -----
>>  9 files changed, 24 insertions(+), 25 deletions(-)
>>
