Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29D0742DA63
	for <lists+live-patching@lfdr.de>; Thu, 14 Oct 2021 15:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbhJNNbA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 14 Oct 2021 09:31:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhJNNa7 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 14 Oct 2021 09:30:59 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D6B460E8B;
        Thu, 14 Oct 2021 13:28:52 +0000 (UTC)
Date:   Thu, 14 Oct 2021 09:28:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>,
        Guo Ren <guoren@kernel.org>, Ingo Molnar <mingo@redhat.com>,
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
Subject: Re: [PATCH v3 1/2] ftrace: disable preemption between
 ftrace_test_recursion_trylock/unlock()
Message-ID: <20211014092850.101ceaee@gandalf.local.home>
In-Reply-To: <alpine.LSU.2.21.2110141108150.23710@pobox.suse.cz>
References: <609b565a-ed6e-a1da-f025-166691b5d994@linux.alibaba.com>
        <7e4738b5-21d4-c4d0-3136-a096bbb5cd2c@linux.alibaba.com>
        <alpine.LSU.2.21.2110141108150.23710@pobox.suse.cz>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 14 Oct 2021 11:13:13 +0200 (CEST)
Miroslav Benes <mbenes@suse.cz> wrote:

> for the livepatch part of the patch.
> 
> I would also ask you not to submit new versions so often, so that the 
> other reviewers have time to actually review the patch set.
> 
> Quoting from Documentation/process/submitting-patches.rst:
> 
> "Wait for a minimum of one week before resubmitting or pinging reviewers - 
> possibly longer during busy times like merge windows."

Although, for updates on a small patch set, I would say just a couple of
days, instead of a week. It's annoying when you have a 15 patch set series,
that gets updated on a daily basis. But for something with only 2 patches,
wait just two days. At least, that's how I feel.

-- Steve
