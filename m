Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41946DD844
	for <lists+live-patching@lfdr.de>; Sat, 19 Oct 2019 13:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbfJSLCE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 19 Oct 2019 07:02:04 -0400
Received: from verein.lst.de ([213.95.11.211]:52128 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfJSLCE (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sat, 19 Oct 2019 07:02:04 -0400
Received: by verein.lst.de (Postfix, from userid 107)
        id 872B068CEC; Sat, 19 Oct 2019 13:02:01 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.3.1 (2010-03-16) on verein.lst.de
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=5.0 tests=ALL_TRUSTED,BAYES_50
        autolearn=disabled version=3.3.1
Received: from blackhole.lan (p5B0D886C.dip0.t-ipconnect.de [91.13.136.108])
        by verein.lst.de (Postfix) with ESMTPSA id 5448D68B05;
        Sat, 19 Oct 2019 13:01:40 +0200 (CEST)
Date:   Sat, 19 Oct 2019 13:01:35 +0200
From:   Torsten Duwe <duwe@lst.de>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     Jiri Kosina <jikos@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Julien Thierry <julien.thierry@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Ingo Molnar <mingo@redhat.com>,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        live-patching@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 0/5] arm64: ftrace with regs
Message-ID: <20191019130135.10de9324@blackhole.lan>
In-Reply-To: <20191018174100.GC18838@lakrids.cambridge.arm.com>
References: <20190208150826.44EBC68DD2@newverein.lst.de>
        <0f8d2e77-7e51-fba8-b179-102318d9ff84@arm.com>
        <20190311114945.GA5625@lst.de>
        <20190408153628.GL6139@lakrids.cambridge.arm.com>
        <20190409175238.GE9255@fuggles.cambridge.arm.com>
        <CAB=otbRXuDHSmh9NrGYoep=hxOKkXVsy6R84ACZ9xELwNr=4AA@mail.gmail.com>
        <20190724161500.GG2624@lakrids.cambridge.arm.com>
        <nycvar.YFH.7.76.1910161341520.13160@cbobk.fhfr.pm>
        <20191016175841.GF46264@lakrids.cambridge.arm.com>
        <20191018174100.GC18838@lakrids.cambridge.arm.com>
Organization: LST e.V.
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Mark!

On Fri, 18 Oct 2019 18:41:02 +0100 Mark Rutland
<mark.rutland@arm.com> wrote:

> In the process of reworking this I spotted some issues that will get
> in the way of livepatching. Notably:
> 
> * When modules can be loaded far away from the kernel, we'll
> potentially need a PLT for each function within a module, if each can
> be patched to a unique function. Currently we have a fixed number,
> which is only sufficient for the two ftrace entry trampolines.
> 
>   IIUC, the new code being patched in is itself a module, in which
> case we'd need a PLT for each function in the main kernel image.

When no live patching is involved, obviously all cases need to have
been handled so far. And when a live patching module comes in, there
are calls in and out of the new patch code:

Calls going into the live patch are not aware of this. They are caught
by an active ftrace intercept, and the actual call into the LP module
is done in klp_arch_set_pc, by manipulating the intercept (call site)
return address (in case thread lives in the "new world", for
completeness' sake). This is an unsigned long write in C.

All calls going _out_ from the KLP module are newly generated, as part
of the KLP module building process, and are thus aware of them being
"extern" -- a PLT entry should be generated and accounted for in the
KLP module.

>   We have a few options here, e.g. changing which memory size model we
>   use, or reserving space for a PLT before each function using
>   -f patchable-function-entry=N,M.

Nonetheless I'm happy I once added the ,M option here. You never know :)

> * There are windows where backtracing will miss the callsite's caller,
>   as its address is not live in the LR or existing chain of frame
>   records. Thus we cannot claim to have a reliable stacktrace.
> 
>   I suspect we'll have to teach the stacktrace code to handle this as
> a special-case.

Yes, that's where I had to step back. The unwinder needs to stop where
the chain is even questionable. In _all_ cases. Missing only one race
condition means a lurking inconsistency.

OTOH it's not a problem to report "not reliable" when in doubt; the
thread in question will then get woken up and unwind itself.
It is only an optimisation to let all kernel threads which are
guaranteed to not contain any patched functions sleep on.

>   I'll try to write these up, as similar probably applies to other
>   architectures with a link register.

I thought I'd quickly give you my feedback upfront here.

	Torsten

