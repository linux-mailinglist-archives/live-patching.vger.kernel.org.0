Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A657C43B1C0
	for <lists+live-patching@lfdr.de>; Tue, 26 Oct 2021 14:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbhJZMDp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Oct 2021 08:03:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:34966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229786AbhJZMDp (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Oct 2021 08:03:45 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 425F3601FC;
        Tue, 26 Oct 2021 12:01:19 +0000 (UTC)
Date:   Tue, 26 Oct 2021 08:01:17 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
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
Subject: Re: [PATCH v5 1/2] ftrace: disable preemption when recursion locked
Message-ID: <20211026080117.366137a5@gandalf.local.home>
In-Reply-To: <18ba2a71-e12d-33f7-63fe-2857b2db022c@linux.alibaba.com>
References: <3ca92dc9-ea04-ddc2-71cd-524bfa5a5721@linux.alibaba.com>
        <333cecfe-3045-8e0a-0c08-64ff590845ab@linux.alibaba.com>
        <alpine.LSU.2.21.2110261128120.28494@pobox.suse.cz>
        <18ba2a71-e12d-33f7-63fe-2857b2db022c@linux.alibaba.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 26 Oct 2021 17:48:10 +0800
王贇 <yun.wang@linux.alibaba.com> wrote:

> > The two comments should be updated too since Steven removed the "bit == 0" 
> > trick.  
> 
> Could you please give more hint on how will it be correct?
> 
> I get the point that bit will no longer be 0, there are only -1 or > 0 now
> so trace_test_and_set_recursion() will disable preemption on bit > 0 and
> trace_clear_recursion() will enabled it since it should only be called when
> bit > 0 (I remember we could use a WARN_ON here now :-P).
> 
> >   
> >> @@ -178,7 +187,7 @@ static __always_inline void trace_clear_recursion(int bit)
> >>   * tracing recursed in the same context (normal vs interrupt),
> >>   *
> >>   * Returns: -1 if a recursion happened.
> >> - *           >= 0 if no recursion
> >> + *           > 0 if no recursion.
> >>   */
> >>  static __always_inline int ftrace_test_recursion_trylock(unsigned long ip,
> >>  							 unsigned long parent_ip)  
> > 
> > And this change would not be correct now.  
> 
> I thought it will no longer return 0 so I change it to > 0, isn't that correct?

No it is not. I removed the bit + 1 return value, which means it returns the
actual bit now. Which is 0 or more.

-- Steve
