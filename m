Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4401E43C08D
	for <lists+live-patching@lfdr.de>; Wed, 27 Oct 2021 05:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238943AbhJ0DMD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Oct 2021 23:12:03 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:54044 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238941AbhJ0DMC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Oct 2021 23:12:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R991e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0UtqSqrG_1635304169;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0UtqSqrG_1635304169)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 11:09:31 +0800
Subject: Re: [PATCH v6 1/2] ftrace: disable preemption when recursion locked
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
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
References: <df8e9b3e-504c-635d-4e92-99cdf9f05479@linux.alibaba.com>
 <78c95844-16b7-8904-b48d-3b2ccd76a352@linux.alibaba.com>
 <20211026225552.72a7ee79@rorschach.local.home>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <e8bb4220-4895-e55d-4aea-cdd265fdfd38@linux.alibaba.com>
Date:   Wed, 27 Oct 2021 11:09:29 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211026225552.72a7ee79@rorschach.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2021/10/27 上午10:55, Steven Rostedt wrote:
> On Wed, 27 Oct 2021 10:34:13 +0800
> 王贇 <yun.wang@linux.alibaba.com> wrote:
> 
>> +/*
>> + * Preemption will be enabled (if it was previously enabled).
>> + */
>>  static __always_inline void trace_clear_recursion(int bit)
>>  {
>> +	WARN_ON_ONCE(bit < 0);
> 
> Can you send a v7 without the WARN_ON.
> 
> This is an extremely hot path, and this will cause noticeable overhead.
> 
> If something were to call this with bit < 0, then it would crash and
> burn rather quickly.

I see, if the problem will be notified anyway then it's fine, v7 on the way.

Regards,
Michael Wang

> 
> -- Steve
> 
> 
>> +
>> +	preempt_enable_notrace();
>>  	barrier();
>>  	trace_recursion_clear(bit);
>>  }
