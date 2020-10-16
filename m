Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60CE2903E1
	for <lists+live-patching@lfdr.de>; Fri, 16 Oct 2020 13:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394771AbgJPLOh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Oct 2020 07:14:37 -0400
Received: from foss.arm.com ([217.140.110.172]:34764 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394676AbgJPLOh (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Oct 2020 07:14:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68658D6E;
        Fri, 16 Oct 2020 04:14:36 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.53.7])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 784FC3F719;
        Fri, 16 Oct 2020 04:14:34 -0700 (PDT)
Date:   Fri, 16 Oct 2020 12:14:31 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Mark Brown <broonie@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] arm64: Implement reliable stack trace
Message-ID: <20201016111431.GB84361@C02TD0UTHF1T.local>
References: <20201012172605.10715-1-broonie@kernel.org>
 <alpine.LSU.2.21.2010151533490.14094@pobox.suse.cz>
 <20201015141612.GC50416@C02TD0UTHF1T.local>
 <20201015154951.GD4390@sirena.org.uk>
 <20201015212931.mh4a5jt7pxqlzxsg@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015212931.mh4a5jt7pxqlzxsg@treble>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Josh,

On Thu, Oct 15, 2020 at 04:29:31PM -0500, Josh Poimboeuf wrote:
> > > AFAICT, existing architectures don't always handle all of the above in
> > > arch_stack_walk_reliable(). For example, it looks like x86 assumes
> > > unwiding through exceptions is reliable for !CONFIG_FRAME_POINTER, but I
> > > think this might not always be true.
> 
> Why not?

Mark B's reply dropped this, but the next paragraph covered that:

| I was planning to send a mail once I've finished writing a test, but
| IIUC there are some windows where ftrace/kretprobes
| detection/repainting may not work, e.g. if preempted after
| ftrace_return_to_handler() decrements curr_ret_stack, but before the
| arch trampoline asm restores the original return addr. So we might
| need something like an in_return_trampoline() to detect and report
| that reliably.

... so e.g. for a callchain A->B->C, where C is instrumented there are
windows where B might be missing from the trace, but the trace is
reported as reliable.

I'll start a new thread on this (with a more fleshed-out example), with
the full set of livepatch folk, lkml, etc. I just want to write a test
case first, since it's entirely possible something I've missed is
catching this already.

Thanks,
Mark.
