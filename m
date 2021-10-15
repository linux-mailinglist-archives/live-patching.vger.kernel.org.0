Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A793C42E803
	for <lists+live-patching@lfdr.de>; Fri, 15 Oct 2021 06:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234795AbhJOErk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 15 Oct 2021 00:47:40 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:59924 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230186AbhJOErk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 15 Oct 2021 00:47:40 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0Us3oYXy_1634273127;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Us3oYXy_1634273127)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 15 Oct 2021 12:45:29 +0800
Subject: Re: [PATCH v3 1/2] ftrace: disable preemption between
 ftrace_test_recursion_trylock/unlock()
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Guo Ren <guoren@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
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
        Joe Lawrence <joe.lawrence@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
References: <609b565a-ed6e-a1da-f025-166691b5d994@linux.alibaba.com>
 <7e4738b5-21d4-c4d0-3136-a096bbb5cd2c@linux.alibaba.com>
 <YWhJP41cNwDphYsv@alley>
 <5e907ed3-806b-b0e5-518d-d2f3b265377f@linux.alibaba.com>
Message-ID: <a5bae9a5-9ab7-2660-caa6-facecb1dba32@linux.alibaba.com>
Date:   Fri, 15 Oct 2021 12:45:27 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <5e907ed3-806b-b0e5-518d-d2f3b265377f@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2021/10/15 上午11:13, 王贇 wrote:
[snip]
>>  # define do_ftrace_record_recursion(ip, pip)	do { } while (0)
>>  #endif
>>  
>> +/*
>> + * trace_test_and_set_recursion() is called on several layers
>> + * of the ftrace code when handling the same ftrace entry.
>> + * These calls might be nested/recursive.
>> + *
>> + * It uses TRACE_LIST_*BITs to distinguish between this
>> + * internal recursion and recursion caused by calling
>> + * the traced function by the ftrace code.
>> + *
>> + * Returns: > 0 when no recursion
>> + *          0 when called recursively internally (safe)
> 
> The 0 can also happened when ftrace handler recursively called trylock()
> under the same context, or not?
> 

Never mind... you're right about this.

Regards,
Michael Wang

> Regards,
> Michael Wang
> 
>> + *	    -1 when the traced function was called recursively from
>> + *             the ftrace handler (unsafe)
>> + */
>>  static __always_inline int trace_test_and_set_recursion(unsigned long ip, unsigned long pip,
>>  							int start, int max)
>>  {
>>  	unsigned int val = READ_ONCE(current->trace_recursion);
>>  	int bit;
>>  
>> -	/* A previous recursion check was made */
>> +	/* Called recursively internally by different ftrace code layers? */
>>  	if ((val & TRACE_CONTEXT_MASK) > max)
>>  		return 0;
> 
>>  
>>
