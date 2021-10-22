Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF57437CC0
	for <lists+live-patching@lfdr.de>; Fri, 22 Oct 2021 20:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhJVSyR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 22 Oct 2021 14:54:17 -0400
Received: from foss.arm.com ([217.140.110.172]:57856 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229463AbhJVSyQ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 22 Oct 2021 14:54:16 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A9AE61063;
        Fri, 22 Oct 2021 11:51:58 -0700 (PDT)
Received: from C02TD0UTHF1T.local (unknown [10.57.73.6])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3D4D83F73D;
        Fri, 22 Oct 2021 11:51:56 -0700 (PDT)
Date:   Fri, 22 Oct 2021 19:51:48 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 04/11] arm64: Make return_address() use
 arch_stack_walk()
Message-ID: <20211022185148.GA91654@C02TD0UTHF1T.local>
References: <c05ce30dcc9be1bd6b5e24a2ca8fe1d66246980b>
 <20211015025847.17694-1-madvenka@linux.microsoft.com>
 <20211015025847.17694-5-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015025847.17694-5-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Oct 14, 2021 at 09:58:40PM -0500, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Currently, return_address() in ARM64 code walks the stack using
> start_backtrace() and walk_stackframe(). Make it use arch_stack_walk()
> instead. This makes maintenance easier.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> ---
>  arch/arm64/kernel/return_address.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kernel/return_address.c b/arch/arm64/kernel/return_address.c
> index a6d18755652f..92a0f4d434e4 100644
> --- a/arch/arm64/kernel/return_address.c
> +++ b/arch/arm64/kernel/return_address.c
> @@ -35,15 +35,11 @@ NOKPROBE_SYMBOL(save_return_addr);
>  void *return_address(unsigned int level)
>  {
>  	struct return_address_data data;
> -	struct stackframe frame;
>  
>  	data.level = level + 2;
>  	data.addr = NULL;
>  
> -	start_backtrace(&frame,
> -			(unsigned long)__builtin_frame_address(0),
> -			(unsigned long)return_address);
> -	walk_stackframe(current, &frame, save_return_addr, &data);
> +	arch_stack_walk(save_return_addr, &data, current, NULL);

This looks equivalent to me. Previously the arguments to
start_backtrace() meant that walk_stackframe would report
return_address(), then the caller of return_address(), and so on. As
arch_stack_walk() starts from its immediate caller (i.e.
return_address()), that should result in the same trace.

It would be nice if we could note something to that effect in the commit
message.

I had a play with ftrace, which uses return_address(), and that all
looks sound.

>  
>  	if (!data.level)
>  		return data.addr;

The end of this function currently does:

	if (!data.level)
		return data.addr;
	else
		return NULL;

... but since we initialize data.addr to NULL, and save_return_addr()
only writes to data.addr when called at the correct level, we can
simplify that to:

	return data.addr;

Regardles of that cleanup:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>

I'll continue reviewing the series next week.

Thanks,
Mark.
