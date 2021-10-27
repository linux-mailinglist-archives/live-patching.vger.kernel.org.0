Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B28A43BFC2
	for <lists+live-patching@lfdr.de>; Wed, 27 Oct 2021 04:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237772AbhJ0C2a convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Oct 2021 22:28:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236697AbhJ0C23 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Oct 2021 22:28:29 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 33D9B6023F;
        Wed, 27 Oct 2021 02:26:02 +0000 (UTC)
Date:   Tue, 26 Oct 2021 22:26:00 -0400
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
Message-ID: <20211026222600.7899126f@rorschach.local.home>
In-Reply-To: <3d897161-7b74-944a-f2a0-07311436fbd9@linux.alibaba.com>
References: <3ca92dc9-ea04-ddc2-71cd-524bfa5a5721@linux.alibaba.com>
        <333cecfe-3045-8e0a-0c08-64ff590845ab@linux.alibaba.com>
        <alpine.LSU.2.21.2110261128120.28494@pobox.suse.cz>
        <18ba2a71-e12d-33f7-63fe-2857b2db022c@linux.alibaba.com>
        <20211026080117.366137a5@gandalf.local.home>
        <3d897161-7b74-944a-f2a0-07311436fbd9@linux.alibaba.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 27 Oct 2021 09:54:13 +0800
王贇 <yun.wang@linux.alibaba.com> wrote:

> My apologize for the stupid comments... I'll send a v6 for this patch
> only to fix that, please let me know if this is not a good way to fix
> few lines of comments.

Actually, please resend both patches, as a new patch set, on its own thread.

Just replying here won't trigger my patchwork scripts.

And also, if you don't include the other patch, the scripts will drop
it.

Thanks,

-- Steve
