Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE8942C300
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 16:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbhJMO0Y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Wed, 13 Oct 2021 10:26:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236942AbhJMO0X (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 13 Oct 2021 10:26:23 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C6F26101D;
        Wed, 13 Oct 2021 14:24:17 +0000 (UTC)
Date:   Wed, 13 Oct 2021 10:24:15 -0400
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
Subject: Re: [RESEND PATCH v2 1/2] ftrace: disable preemption between
 ftrace_test_recursion_trylock/unlock()
Message-ID: <20211013102415.10788200@gandalf.local.home>
In-Reply-To: <861d81d6-e202-09f3-f0be-6c77205f9d34@linux.alibaba.com>
References: <b1d7fe43-ce84-0ed7-32f7-ea1d12d0b716@linux.alibaba.com>
        <75ee86ac-02f2-d687-ab1e-9c8c33032495@linux.alibaba.com>
        <alpine.LSU.2.21.2110130948120.5647@pobox.suse.cz>
        <d5fbd49a-55c5-a9f5-6600-707c8d749312@linux.alibaba.com>
        <alpine.LSU.2.21.2110131022590.5647@pobox.suse.cz>
        <861d81d6-e202-09f3-f0be-6c77205f9d34@linux.alibaba.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 13 Oct 2021 16:34:53 +0800
王贇 <yun.wang@linux.alibaba.com> wrote:

> On 2021/10/13 下午4:25, Miroslav Benes wrote:
> >>> Side note... the comment will eventually conflict with peterz's 
> >>> https://lore.kernel.org/all/20210929152429.125997206@infradead.org/.  
> >>
> >> Steven, would you like to share your opinion on this patch?
> >>
> >> If klp_synchronize_transition() will be removed anyway, the comments
> >> will be meaningless and we can just drop it :-P  
> > 
> > The comment will still be needed in some form. We will handle it depending 
> > on what gets merged first. peterz's patches are not ready yet.  
> 
> Ok, then I'll move it before trylock() inside klp_ftrace_handler() anyway.

+1

-- Steve
