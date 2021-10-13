Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F2E42B2C3
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 04:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbhJMCkj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Oct 2021 22:40:39 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:43903 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229980AbhJMCkj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Oct 2021 22:40:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=yun.wang@linux.alibaba.com;NM=1;PH=DS;RN=31;SR=0;TI=SMTPD_---0Urdkez0_1634092708;
Received: from testdeMacBook-Pro.local(mailfrom:yun.wang@linux.alibaba.com fp:SMTPD_---0Urdkez0_1634092708)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 Oct 2021 10:38:30 +0800
Subject: Re: [PATCH 1/2] ftrace: disable preemption on the testing of
 recursion
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
 <a8756482-024c-c858-b3d1-1ffa9a5eb3f7@linux.alibaba.com>
 <20211012084331.06b8dd23@gandalf.local.home>
 <1eab20c1-d69b-f94b-92ff-4329d0aff6a2@linux.alibaba.com>
 <20211012223039.78099c24@oasis.local.home>
From:   =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Message-ID: <40a6e16f-6335-c271-c91b-622c8d7f6521@linux.alibaba.com>
Date:   Wed, 13 Oct 2021 10:38:28 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211012223039.78099c24@oasis.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 2021/10/13 上午10:30, Steven Rostedt wrote:
> On Wed, 13 Oct 2021 10:04:52 +0800
> 王贇 <yun.wang@linux.alibaba.com> wrote:
> 
>> I see, while the user can still check smp_processor_id() after trylock
>> return bit 0...
> 
> But preemption would have already been disabled. That's because a bit 0
> means that a recursion check has already been made by a previous
> caller and this one is nested, thus preemption is already disabled.
> If bit is 0, then preemption had better be disabled as well.

Thanks for the explain, now I get your point :-)

Let's make bit 0 an exemption then.

Regards,
Michael Wang

> 
> -- Steve
> 
