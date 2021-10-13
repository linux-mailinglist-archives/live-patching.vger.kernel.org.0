Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477E142B2A0
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 04:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235216AbhJMCaI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Oct 2021 22:30:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233316AbhJMCaH (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Oct 2021 22:30:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17A2560F11;
        Wed, 13 Oct 2021 02:28:00 +0000 (UTC)
Date:   Tue, 12 Oct 2021 22:27:58 -0400
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
        Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Jisheng Zhang <jszhang@kernel.org>, linux-csky@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 1/2] ftrace: disable preemption on the testing of
 recursion
Message-ID: <20211012222758.1a029157@oasis.local.home>
In-Reply-To: <74090798-7d93-0713-982c-6f0247118d20@linux.alibaba.com>
References: <8c7de46d-9869-aa5e-2bb9-5dbc2eda395e@linux.alibaba.com>
        <a8756482-024c-c858-b3d1-1ffa9a5eb3f7@linux.alibaba.com>
        <alpine.LSU.2.21.2110121421260.3394@pobox.suse.cz>
        <74090798-7d93-0713-982c-6f0247118d20@linux.alibaba.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 13 Oct 2021 09:50:17 +0800
王贇 <yun.wang@linux.alibaba.com> wrote:

> >> -	preempt_enable_notrace();
> >>  	ftrace_test_recursion_unlock(bit);
> >>  }  
> > 
> > I don't like this change much. We have preempt_disable there not because 
> > of ftrace_test_recursion, but because of RCU. ftrace_test_recursion was 
> > added later. Yes, it would work with the change, but it would also hide 
> > things which should not be hidden in my opinion.  
> 
> Not very sure about the backgroup stories, but just found this in
> 'Documentation/trace/ftrace-uses.rst':
> 
>   Note, on success,
>   ftrace_test_recursion_trylock() will disable preemption, and the
>   ftrace_test_recursion_unlock() will enable it again (if it was previously
>   enabled).

Right that part is to be fixed by what you are adding here.

The point that Miroslav is complaining about is that the preemption
disabling is special in this case, and not just from the recursion
point of view, which is why the comment is still required.

-- Steve


> 
> Seems like this lock pair was supposed to take care the preemtion itself?
