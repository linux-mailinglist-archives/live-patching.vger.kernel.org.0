Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70EEC486753
	for <lists+live-patching@lfdr.de>; Thu,  6 Jan 2022 17:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240846AbiAFQHN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 Jan 2022 11:07:13 -0500
Received: from foss.arm.com ([217.140.110.172]:55934 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240926AbiAFQHN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 Jan 2022 11:07:13 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B9E91042;
        Thu,  6 Jan 2022 08:07:12 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.10.56])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9E4C53F5A1;
        Thu,  6 Jan 2022 08:07:10 -0800 (PST)
Date:   Thu, 6 Jan 2022 16:07:07 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 01/10] arm64: Remove NULL task check from
 unwind_frame()
Message-ID: <YdcTq8sk/q1zW8va@FVFF77S0Q05N>
References: <0d0eb36f348fb5a6af6eb592c0525f6e94007328>
 <20220103165212.9303-1-madvenka@linux.microsoft.com>
 <20220103165212.9303-2-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103165212.9303-2-madvenka@linux.microsoft.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jan 03, 2022 at 10:52:03AM -0600, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Currently, there is a check for a NULL task in unwind_frame(). It is not
> needed since all current consumers pass a non-NULL task.
> 
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
> Reviewed-by: Mark Brown <broonie@kernel.org>

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/kernel/stacktrace.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 0fb58fed54cb..5f5bb35b7b41 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -69,9 +69,6 @@ static int notrace unwind_frame(struct task_struct *tsk,
>  	unsigned long fp = frame->fp;
>  	struct stack_info info;
>  
> -	if (!tsk)
> -		tsk = current;
> -
>  	/* Final frame; nothing to unwind */
>  	if (fp == (unsigned long)task_pt_regs(tsk)->stackframe)
>  		return -ENOENT;
> -- 
> 2.25.1
> 
