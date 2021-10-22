Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376E3437C68
	for <lists+live-patching@lfdr.de>; Fri, 22 Oct 2021 20:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhJVSFI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 22 Oct 2021 14:05:08 -0400
Received: from foss.arm.com ([217.140.110.172]:57394 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232258AbhJVSFH (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 22 Oct 2021 14:05:07 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 310F81063;
        Fri, 22 Oct 2021 11:02:49 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.73.6])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4B6C73F73D;
        Fri, 22 Oct 2021 11:02:46 -0700 (PDT)
Date:   Fri, 22 Oct 2021 19:02:43 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [PATCH v10 01/11] arm64: Select STACKTRACE in arch/arm64/Kconfig
Message-ID: <20211022180243.GL86184@C02TD0UTHF1T.local>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015025847.17694-2-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Madhavan,

Apolgoies for the delay in getting round to this.

On Thu, Oct 14, 2021 at 09:58:37PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Currently, there are multiple functions in ARM64 code that walk the
> stack using start_backtrace() and unwind_frame() or start_backtrace()
> and walk_stackframe(). They should all be converted to use
> arch_stack_walk(). This makes maintenance easier.
> 
> To do that, arch_stack_walk() must always be defined. arch_stack_walk()
> is within #ifdef CONFIG_STACKTRACE. So, select STACKTRACE in
> arch/arm64/Kconfig.

I'd prefer if we could decouple ARCH_STACKWALK from STACKTRACE, so that
we don't have to expose /proc/*/stack unconditionally, which Peter
Zijlstra has a patch for:

  https://lore.kernel.org/lkml/20211022152104.356586621@infradead.org/

... but regardless the rest of the series looks pretty good, so I'll go
review that, and we can figure out how to queue the bits and pieces in
the right order.

Thanks,
Mark.

> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index fdcd54d39c1e..bfb0ce60d820 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -35,6 +35,7 @@ config ARM64
>  	select ARCH_HAS_SET_DIRECT_MAP
>  	select ARCH_HAS_SET_MEMORY
>  	select ARCH_STACKWALK
> +	select STACKTRACE
>  	select ARCH_HAS_STRICT_KERNEL_RWX
>  	select ARCH_HAS_STRICT_MODULE_RWX
>  	select ARCH_HAS_SYNC_DMA_FOR_DEVICE
> -- 
> 2.25.1
> 
