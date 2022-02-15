Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336A34B6DC7
	for <lists+live-patching@lfdr.de>; Tue, 15 Feb 2022 14:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233465AbiBONkF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Feb 2022 08:40:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiBONkE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Feb 2022 08:40:04 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B18865179;
        Tue, 15 Feb 2022 05:39:55 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E569C1480;
        Tue, 15 Feb 2022 05:39:54 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.89.173])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 186353F718;
        Tue, 15 Feb 2022 05:39:52 -0800 (PST)
Date:   Tue, 15 Feb 2022 13:39:48 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     madvenka@linux.microsoft.com
Cc:     broonie@kernel.org, jpoimboe@redhat.com, ardb@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, jmorris@namei.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 06/11] arm64: Use stack_trace_consume_fn and rename
 args to unwind()
Message-ID: <YgutJKqYe8ss8LLd@FVFF77S0Q05N>
References: <95691cae4f4504f33d0fc9075541b1e7deefe96f>
 <20220117145608.6781-1-madvenka@linux.microsoft.com>
 <20220117145608.6781-7-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220117145608.6781-7-madvenka@linux.microsoft.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jan 17, 2022 at 08:56:03AM -0600, madvenka@linux.microsoft.com wrote:
> From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
> 
> Rename the arguments to unwind() for better consistency. Also, use the
> typedef stack_trace_consume_fn for the consume_entry function as it is
> already defined in linux/stacktrace.h.
>
> Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>

How about: 

| arm64: align with common stracktrace naming
|
| For historical reasons, the naming of parameters and their types in the arm64
| stacktrace code differs from that used in generic code and other
| architectures, even though the types are equivalent.
|
| For consistency and clarity, use the generic names.

Either way:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> ---
>  arch/arm64/kernel/stacktrace.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
> index 1b32e55735aa..f772dac78b11 100644
> --- a/arch/arm64/kernel/stacktrace.c
> +++ b/arch/arm64/kernel/stacktrace.c
> @@ -181,12 +181,12 @@ static int notrace unwind_next(struct unwind_state *state)
>  NOKPROBE_SYMBOL(unwind_next);
>  
>  static void notrace unwind(struct unwind_state *state,
> -			   bool (*fn)(void *, unsigned long), void *data)
> +			   stack_trace_consume_fn consume_entry, void *cookie)
>  {
>  	while (1) {
>  		int ret;
>  
> -		if (!fn(data, state->pc))
> +		if (!consume_entry(cookie, state->pc))
>  			break;
>  		ret = unwind_next(state);
>  		if (ret < 0)
> -- 
> 2.25.1
> 
