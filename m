Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00D444EC21
	for <lists+live-patching@lfdr.de>; Fri, 12 Nov 2021 18:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233843AbhKLRrG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 12 Nov 2021 12:47:06 -0500
Received: from foss.arm.com ([217.140.110.172]:42522 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235122AbhKLRrF (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 12 Nov 2021 12:47:05 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71C45D6E;
        Fri, 12 Nov 2021 09:44:14 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.58.79])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EA14B3F718;
        Fri, 12 Nov 2021 09:44:11 -0800 (PST)
Date:   Fri, 12 Nov 2021 17:44:05 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [PATCH v10 01/11] arm64: Select STACKTRACE in arch/arm64/Kconfig
Message-ID: <20211112174405.GA5977@C02TD0UTHF1T.local>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-2-madvenka@linux.microsoft.com>
 <20211022180243.GL86184@C02TD0UTHF1T.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211022180243.GL86184@C02TD0UTHF1T.local>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Oct 22, 2021 at 07:02:43PM +0100, Mark Rutland wrote:
> On Thu, Oct 14, 2021 at 09:58:37PM -0500, madvenka@linux.microsoft.com wrote:
> > From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> > 
> > Currently, there are multiple functions in ARM64 code that walk the
> > stack using start_backtrace() and unwind_frame() or start_backtrace()
> > and walk_stackframe(). They should all be converted to use
> > arch_stack_walk(). This makes maintenance easier.
> > 
> > To do that, arch_stack_walk() must always be defined. arch_stack_walk()
> > is within #ifdef CONFIG_STACKTRACE. So, select STACKTRACE in
> > arch/arm64/Kconfig.
> 
> I'd prefer if we could decouple ARCH_STACKWALK from STACKTRACE, so that
> we don't have to expose /proc/*/stack unconditionally, which Peter
> Zijlstra has a patch for:
> 
>   https://lore.kernel.org/lkml/20211022152104.356586621@infradead.org/
> 
> ... but regardless the rest of the series looks pretty good, so I'll go
> review that, and we can figure out how to queue the bits and pieces in
> the right order.

FWIW, it looks like the direction of travel there is not go and unify
the various arch unwinders, but I would like to not depend on
STACKTRACE. Regardless, the initial arch_stack_walk() cleanup patches
all look good, so I reckon we should try to get those out of the way and
queue those for arm64 soon even if we need some more back-and-forth over
the later part of the series.

With that in mind, I've picked up Peter's patch decoupling
ARCH_STACKWALK from STACKTRACE, and rebased the initial patches from
this series atop. Since there's some subtltety in a few cases (and this
was easy to miss while reviewing), I've expanded the commit messages
with additional rationale as to why each transformation is safe.
I've pushed that to:

  https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/stacktrace/arch-stack-walk

There's a dependency on:

  https://lore.kernel.org/r/20211029162245.39761-1-mark.rutland@arm.com

... which was queued for v5.16-rc1, but got dropped due to a conflict,
and I'm expecting it to be re-queued as a fix for v5.16-rc2 shortly
after v5.16-rc1 is tagged. Hopefully that means we have a table base by
v5.16-rc2.

I'll send the preparatory series as I've prepared it shortly after
v5.16-rc1 so that people can shout if I've messed something up.

Hopefully it's easy enough to use that as a base for the more involved
rework later in this series.

Thanks,
Mark.

> Thanks,
> Mark.
> 
> > 
> > Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> > ---
> >  arch/arm64/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index fdcd54d39c1e..bfb0ce60d820 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -35,6 +35,7 @@ config ARM64
> >  	select ARCH_HAS_SET_DIRECT_MAP
> >  	select ARCH_HAS_SET_MEMORY
> >  	select ARCH_STACKWALK
> > +	select STACKTRACE
> >  	select ARCH_HAS_STRICT_KERNEL_RWX
> >  	select ARCH_HAS_STRICT_MODULE_RWX
> >  	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
> > -- 
> > 2.25.1
> > 
