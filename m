Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F6DDCCF5
	for <lists+live-patching@lfdr.de>; Fri, 18 Oct 2019 19:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405493AbfJRRlb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 18 Oct 2019 13:41:31 -0400
Received: from [217.140.110.172] ([217.140.110.172]:47744 "EHLO foss.arm.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S2405459AbfJRRlb (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 18 Oct 2019 13:41:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 195971534;
        Fri, 18 Oct 2019 10:41:06 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 15C613F718;
        Fri, 18 Oct 2019 10:41:03 -0700 (PDT)
Date:   Fri, 18 Oct 2019 18:41:02 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Julien Thierry <julien.thierry@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Ingo Molnar <mingo@redhat.com>, Torsten Duwe <duwe@lst.de>,
        Ruslan Bilovol <ruslan.bilovol@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        live-patching@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 0/5] arm64: ftrace with regs
Message-ID: <20191018174100.GC18838@lakrids.cambridge.arm.com>
References: <20190208150826.44EBC68DD2@newverein.lst.de>
 <0f8d2e77-7e51-fba8-b179-102318d9ff84@arm.com>
 <20190311114945.GA5625@lst.de>
 <20190408153628.GL6139@lakrids.cambridge.arm.com>
 <20190409175238.GE9255@fuggles.cambridge.arm.com>
 <CAB=otbRXuDHSmh9NrGYoep=hxOKkXVsy6R84ACZ9xELwNr=4AA@mail.gmail.com>
 <20190724161500.GG2624@lakrids.cambridge.arm.com>
 <nycvar.YFH.7.76.1910161341520.13160@cbobk.fhfr.pm>
 <20191016175841.GF46264@lakrids.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016175841.GF46264@lakrids.cambridge.arm.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 16, 2019 at 06:58:42PM +0100, Mark Rutland wrote:
> I've just done the core (non-arm64) bits today, and pushed that out:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/ftrace-with-regs
> 
> ... I'll fold the remainging bits of patches 4 and 5 together tomorrow
> atop of that.

I've just force-pushed an updated version with the actual arm64
FTRACE_WITH_REGS bits. There are a couple of bits I still need to
verify, but I'm hoping that I can send this out for real next week.

In the process of reworking this I spotted some issues that will get in
the way of livepatching. Notably:

* When modules can be loaded far away from the kernel, we'll potentially
  need a PLT for each function within a module, if each can be patched
  to a unique function. Currently we have a fixed number, which is only
  sufficient for the two ftrace entry trampolines.

  IIUC, the new code being patched in is itself a module, in which case
  we'd need a PLT for each function in the main kernel image.

  We have a few options here, e.g. changing which memory size model we
  use, or reserving space for a PLT before each function using
  -f patchable-function-entry=N,M.

* There are windows where backtracing will miss the callsite's caller,
  as its address is not live in the LR or existing chain of frame
  records. Thus we cannot claim to have a reliable stacktrace.

  I suspect we'll have to teach the stacktrace code to handle this as a
  special-case.

  I'll try to write these up, as similar probably applies to other
  architectures with a link register.

Thanks,
Mark.
