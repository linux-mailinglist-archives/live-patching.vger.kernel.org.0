Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0737D432963
	for <lists+live-patching@lfdr.de>; Mon, 18 Oct 2021 23:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhJRV5g (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 18 Oct 2021 17:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233919AbhJRV5a (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 18 Oct 2021 17:57:30 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E68B610A1;
        Mon, 18 Oct 2021 21:55:16 +0000 (UTC)
Date:   Mon, 18 Oct 2021 17:55:14 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>, Ingo Molnar <mingo@redhat.com>,
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
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-riscv@lists.infradead.org, live-patching@vger.kernel.org,
        =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>
Subject: Re: [PATCH v2] tracing: Have all levels of checks prevent recursion
Message-ID: <20211018175505.3e19155a@gandalf.local.home>
In-Reply-To: <20211018154412.09fcad3c@gandalf.local.home>
References: <20211018154412.09fcad3c@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 18 Oct 2021 15:44:12 -0400
Steven Rostedt <rostedt@goodmis.org> (by way of Steven Rostedt
<rostedt@goodmis.org>) wrote:

> [
>    Linus,
>      I have patches that clean this up that are not marked for stable, but
>      will depend on this patch. As I already have commits in my next queue,
>      I can do one of the following:
> 
>     1. Cherry pick this from my urgent tree, and build everything on top.
>     2. Add this on top of the mainline tag my next branch is based on and
>        merge it.
>     3. Add this to my next branch, and have it go in at the next merge
>        window.

Hmm, I take this back. Although the clean up affects the same code block,
the updates don't actually conflict. (Although, if I do update the comment
that Petr asked, that will conflict. But nothing you can't handle ;-)

I'll start running this change through my tests and post it separately.

-- Steve



> ]

