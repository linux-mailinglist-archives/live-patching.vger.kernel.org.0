Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845F32938CD
	for <lists+live-patching@lfdr.de>; Tue, 20 Oct 2020 12:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731637AbgJTKEC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Oct 2020 06:04:02 -0400
Received: from foss.arm.com ([217.140.110.172]:49004 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727589AbgJTKEC (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Oct 2020 06:04:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 111A3101E;
        Tue, 20 Oct 2020 03:04:02 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.53.249])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A730C3F66E;
        Tue, 20 Oct 2020 03:03:59 -0700 (PDT)
Date:   Tue, 20 Oct 2020 11:03:52 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Mark Brown <broonie@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] arm64: Implement reliable stack trace
Message-ID: <20201020100352.GA48360@C02TD0UTHF1T.local>
References: <20201012172605.10715-1-broonie@kernel.org>
 <alpine.LSU.2.21.2010151533490.14094@pobox.suse.cz>
 <20201015141612.GC50416@C02TD0UTHF1T.local>
 <20201015154951.GD4390@sirena.org.uk>
 <20201015212931.mh4a5jt7pxqlzxsg@treble>
 <20201016111431.GB84361@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016111431.GB84361@C02TD0UTHF1T.local>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Oct 16, 2020 at 12:14:31PM +0100, Mark Rutland wrote:
> Mark B's reply dropped this, but the next paragraph covered that:
> 
> | I was planning to send a mail once I've finished writing a test, but
> | IIUC there are some windows where ftrace/kretprobes
> | detection/repainting may not work, e.g. if preempted after
> | ftrace_return_to_handler() decrements curr_ret_stack, but before the
> | arch trampoline asm restores the original return addr. So we might
> | need something like an in_return_trampoline() to detect and report
> | that reliably.
> 
> ... so e.g. for a callchain A->B->C, where C is instrumented there are
> windows where B might be missing from the trace, but the trace is
> reported as reliable.

I'd missed a couple of details, and I think I see how each existing
architecture prevents this case now.

Josh, just to confirm the x86 case, am I right in thinking that the ORC
unwinder will refuse to unwind from the return_to_handler and
kretprobe_trampoline asm? IIRC objtool shouldn't build unwind info for
those as return_to_handler is marked with SYM_CODE_{START,END}() and
kretprobe_trampoline is marked with STACK_FRAME_NON_STANDARD().

Both powerpc and s390 refuse to reliably unwind through exceptions, so
they can rely on function call boundaries to keep the callchain in a
sane state.

Thanks,
Mark.
