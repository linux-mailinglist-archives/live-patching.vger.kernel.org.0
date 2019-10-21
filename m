Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10B37DEB15
	for <lists+live-patching@lfdr.de>; Mon, 21 Oct 2019 13:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbfJULiE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Oct 2019 07:38:04 -0400
Received: from [217.140.110.172] ([217.140.110.172]:50154 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1727725AbfJULiE (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Oct 2019 07:38:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AE0CEBD;
        Mon, 21 Oct 2019 04:37:32 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 16AFE3F718;
        Mon, 21 Oct 2019 04:37:29 -0700 (PDT)
Date:   Mon, 21 Oct 2019 12:37:25 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Torsten Duwe <duwe@lst.de>
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
Message-ID: <20191021113724.GA56589@lakrids.cambridge.arm.com>
References: <0f8d2e77-7e51-fba8-b179-102318d9ff84@arm.com>
 <20190311114945.GA5625@lst.de>
 <20190408153628.GL6139@lakrids.cambridge.arm.com>
 <20190409175238.GE9255@fuggles.cambridge.arm.com>
 <CAB=otbRXuDHSmh9NrGYoep=hxOKkXVsy6R84ACZ9xELwNr=4AA@mail.gmail.com>
 <20190724161500.GG2624@lakrids.cambridge.arm.com>
 <nycvar.YFH.7.76.1910161341520.13160@cbobk.fhfr.pm>
 <20191016175841.GF46264@lakrids.cambridge.arm.com>
 <20191018174100.GC18838@lakrids.cambridge.arm.com>
 <20191019130135.10de9324@blackhole.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191019130135.10de9324@blackhole.lan>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat, Oct 19, 2019 at 01:01:35PM +0200, Torsten Duwe wrote:
> Hi Mark!

Hi Torsten!
 
> On Fri, 18 Oct 2019 18:41:02 +0100 Mark Rutland
> <mark.rutland@arm.com> wrote:
> 
> > In the process of reworking this I spotted some issues that will get
> > in the way of livepatching. Notably:
> > 
> > * When modules can be loaded far away from the kernel, we'll
> > potentially need a PLT for each function within a module, if each can
> > be patched to a unique function. Currently we have a fixed number,
> > which is only sufficient for the two ftrace entry trampolines.
> > 
> >   IIUC, the new code being patched in is itself a module, in which
> > case we'd need a PLT for each function in the main kernel image.
> 
> When no live patching is involved, obviously all cases need to have
> been handled so far. And when a live patching module comes in, there
> are calls in and out of the new patch code:
> 
> Calls going into the live patch are not aware of this. They are caught
> by an active ftrace intercept, and the actual call into the LP module
> is done in klp_arch_set_pc, by manipulating the intercept (call site)
> return address (in case thread lives in the "new world", for
> completeness' sake). This is an unsigned long write in C.

I was under the impression that (at some point) the patch site would be
patched to call the LP code directly. From the above I understand that's
not the case, and it will always be directed via the regular ftrace
entry code -- have I got that right?

Assuming that is the case, that sounds fine to me, and sorry for the
noise.

> All calls going _out_ from the KLP module are newly generated, as part
> of the KLP module building process, and are thus aware of them being
> "extern" -- a PLT entry should be generated and accounted for in the
> KLP module.

Yup; understood.

> >   We have a few options here, e.g. changing which memory size model we
> >   use, or reserving space for a PLT before each function using
> >   -f patchable-function-entry=N,M.
> 
> Nonetheless I'm happy I once added the ,M option here. You never know :)

Yup; we may have other reasons to need this in future (and I see parisc
uses this today).

> > * There are windows where backtracing will miss the callsite's caller,
> >   as its address is not live in the LR or existing chain of frame
> >   records. Thus we cannot claim to have a reliable stacktrace.
> > 
> >   I suspect we'll have to teach the stacktrace code to handle this as
> > a special-case.
> 
> Yes, that's where I had to step back. The unwinder needs to stop where
> the chain is even questionable. In _all_ cases. Missing only one race
> condition means a lurking inconsistency.

Sure. I'm calling this out now so that we don't miss this in future.
I've added comments to the ftrace entry asm to this effect for now.

> OTOH it's not a problem to report "not reliable" when in doubt; the
> thread in question will then get woken up and unwind itself.
> It is only an optimisation to let all kernel threads which are
> guaranteed to not contain any patched functions sleep on.

I just want to make it clear that some care will be needed if/when
adding CONFIG_HAVE_RELIABLE_STACKTRACE so that we handle this case
correctly.
 
> >   I'll try to write these up, as similar probably applies to other
> >   architectures with a link register.
> 
> I thought I'd quickly give you my feedback upfront here.

Thanks; it's much appreciated!

Mark.
