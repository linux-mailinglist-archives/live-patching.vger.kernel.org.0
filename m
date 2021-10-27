Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5ABA43BFCE
	for <lists+live-patching@lfdr.de>; Wed, 27 Oct 2021 04:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237898AbhJ0CbT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Oct 2021 22:31:19 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:46483 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233064AbhJ0CbR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Oct 2021 22:31:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=30;SR=0;TI=SMTPD_---0Utq-lV5_1635301725;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Utq-lV5_1635301725)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 10:28:47 +0800
Subject: Re: [PATCH v5 1/2] ftrace: disable preemption when recursion locked
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Miroslav Benes <mbenes@suse.cz>, Guo Ren <guoren@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
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
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
References: <3ca92dc9-ea04-ddc2-71cd-524bfa5a5721@linux.alibaba.com>
 <333cecfe-3045-8e0a-0c08-64ff590845ab@linux.alibaba.com>
 <alpine.LSU.2.21.2110261128120.28494@pobox.suse.cz>
 <18ba2a71-e12d-33f7-63fe-2857b2db022c@linux.alibaba.com>
 <20211026080117.366137a5@gandalf.local.home>
 <3d897161-7b74-944a-f2a0-07311436fbd9@linux.alibaba.com>
 <20211026222600.7899126f@rorschach.local.home>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <f1bea3e5-005a-3109-d95c-d754530baeb2@linux.alibaba.com>
Date:   Wed, 27 Oct 2021 10:28:45 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211026222600.7899126f@rorschach.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2021/10/27 上午10:26, Steven Rostedt wrote:
> On Wed, 27 Oct 2021 09:54:13 +0800
> 王贇 <yun.wang@linux.alibaba.com> wrote:
> 
>> My apologize for the stupid comments... I'll send a v6 for this patch
>> only to fix that, please let me know if this is not a good way to fix
>> few lines of comments.
> 
> Actually, please resend both patches, as a new patch set, on its own thread.
> 
> Just replying here won't trigger my patchwork scripts.
> 
> And also, if you don't include the other patch, the scripts will drop
> it.

Got it~

Regards,
Michael Wang

> 
> Thanks,
> 
> -- Steve
> 
