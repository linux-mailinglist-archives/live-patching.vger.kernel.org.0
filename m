Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78FC442B2A6
	for <lists+live-patching@lfdr.de>; Wed, 13 Oct 2021 04:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbhJMCcr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Tue, 12 Oct 2021 22:32:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232245AbhJMCcq (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 12 Oct 2021 22:32:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE40C6101D;
        Wed, 13 Oct 2021 02:30:40 +0000 (UTC)
Date:   Tue, 12 Oct 2021 22:30:39 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     =?UTF-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
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
Subject: Re: [PATCH 1/2] ftrace: disable preemption on the testing of
 recursion
Message-ID: <20211012223039.78099c24@oasis.local.home>
In-Reply-To: <1eab20c1-d69b-f94b-92ff-4329d0aff6a2@linux.alibaba.com>
References: <8c7de46d-9869-aa5e-2bb9-5dbc2eda395e@linux.alibaba.com>
        <a8756482-024c-c858-b3d1-1ffa9a5eb3f7@linux.alibaba.com>
        <20211012084331.06b8dd23@gandalf.local.home>
        <1eab20c1-d69b-f94b-92ff-4329d0aff6a2@linux.alibaba.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 13 Oct 2021 10:04:52 +0800
王贇 <yun.wang@linux.alibaba.com> wrote:

> I see, while the user can still check smp_processor_id() after trylock
> return bit 0...

But preemption would have already been disabled. That's because a bit 0
means that a recursion check has already been made by a previous
caller and this one is nested, thus preemption is already disabled.
If bit is 0, then preemption had better be disabled as well.

-- Steve
