Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB57718D80
	for <lists+live-patching@lfdr.de>; Wed, 31 May 2023 23:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjEaVuT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 31 May 2023 17:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjEaVuT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 31 May 2023 17:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E873A0;
        Wed, 31 May 2023 14:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B21A63F71;
        Wed, 31 May 2023 21:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0004BC433D2;
        Wed, 31 May 2023 21:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685569817;
        bh=8S5pQOjcMMxdneL9UZGt2N8SWAwT3unke6T0NY8khZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=smcGeboWJKtD+WCSPuWQbH2aJC6CaODIDT/k4aAmfCr77+jKwJrzHsHnhtFBpPF2L
         2jAdn0M9z2XIKYul8utY1932KPpjw6iQ5SNG0spZ0oYOHh7EX8lbmihqRMl31YPuOk
         qkAMmsNuw1aJfFcvLKRWR4fEsyx6P0iOlK6bkg1QzjL5GFQk0uhn0MhzgRs0OWS/v9
         9bsTlSZyJuS+FpeWAxRb8YezAmefnL0jeli9WGu/jhSq2xdBr6VppNjc1ALasiqbvS
         smIlYGh1vCKCS+5lrMs02SAxwsEEGVPh4jRAi58WaEAcsHmt1XTB4ZRbfRsHYYrQBv
         WpZwTCc37HpfQ==
Date:   Wed, 31 May 2023 14:50:15 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Song Liu <song@kernel.org>, live-patching@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] ftrace: Allow inline functions not inlined to be traced
Message-ID: <20230531215015.dxmkaouhdcat3hoe@treble>
References: <20230502164102.1a51cdb4@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230502164102.1a51cdb4@gandalf.local.home>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 02, 2023 at 04:41:02PM -0400, Steven Rostedt wrote:
> Today, it is no longer a problem if an inlined function is not inlined and
> is traced. Removing notrace from inline has been requested several times
> over the years. I believe it is now safe to do so.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/linux/compiler_types.h | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
> index 547ea1ff806e..c8f23ba1c339 100644
> --- a/include/linux/compiler_types.h
> +++ b/include/linux/compiler_types.h
> @@ -182,9 +182,8 @@ struct ftrace_likely_data {
>   * externally visible function. This makes extern inline behave as per gnu89
>   * semantics rather than c99. This prevents multiple symbol definition errors
>   * of extern inline functions at link time.
> - * A lot of inline functions can cause havoc with function tracing.
>   */
> -#define inline inline __gnu_inline __inline_maybe_unused notrace
> +#define inline inline __gnu_inline __inline_maybe_unused

Yes!!!  I've been wanting to do this for many years.  This will help
live patching a lot.

Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>

-- 
Josh
