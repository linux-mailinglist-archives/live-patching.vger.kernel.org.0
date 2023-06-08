Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667EE727BE3
	for <lists+live-patching@lfdr.de>; Thu,  8 Jun 2023 11:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233490AbjFHJvA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Jun 2023 05:51:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232759AbjFHJu7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Jun 2023 05:50:59 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 11B8C26B0;
        Thu,  8 Jun 2023 02:50:57 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34FEAAB6;
        Thu,  8 Jun 2023 02:51:42 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.24.103])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B0B0E3F71E;
        Thu,  8 Jun 2023 02:50:54 -0700 (PDT)
Date:   Thu, 8 Jun 2023 10:50:51 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>, live-patching@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] ftrace: Allow inline functions not inlined to be traced
Message-ID: <ZIGkezEx87zehzJr@FVFF77S0Q05N>
References: <20230502164102.1a51cdb4@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502164102.1a51cdb4@gandalf.local.home>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 02, 2023 at 04:41:02PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Over 10 years ago there were many bugs that caused function tracing to
> crash because some inlined function was not inlined and should not have
> been traced. This made it hard to debug because when the developer tried
> to reproduce it, if their compiler still inlined the function, the bug
> would not trigger. The solution back then was simply to add "notrace" to
> "inline" which would make sure all functions that are marked inline are
> never traced even when the compiler decides to not inline them.
> 
> A lot has changed over the last 10 years.
> 
> 1) ftrace_test_recursion_trylock() is now used by all ftrace hooks which
>    will prevent the recursive crashes from happening that was caused by
>    inlined functions being traced.
> 
> 2) noinstr is now used to mark pretty much all functions that would also
>    cause problems if they are traced.
> 
> Today, it is no longer a problem if an inlined function is not inlined and
> is traced. Removing notrace from inline has been requested several times
> over the years. I believe it is now safe to do so.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Unfortunately, from a quick build-test of arm64 there are a bunch of places
that are currently inline that need to be __always_inline for this to be safe.
Notably we have a few low-level helpers like is_kernel_in_hyp_mode() that are
only inlines, and those get used in the bowels of our entry code before we've
restored some HW state (e.g. in arch_nmi_enter()).

I'm happy to go audit and fixup arm64, but that will take some work.

Maybe it's worth having something like:

#ifdef ARCH_CAN_TRACE_INLINE
#define __notrace_inline
#else
#define __notrace_inline	notrace
#endif

... so that we can opt-in where this is safe, (e.g. on x86)?

Thanks,
Mark.

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
>  
>  /*
>   * gcc provides both __inline__ and __inline as alternate spellings of
> @@ -230,7 +229,7 @@ struct ftrace_likely_data {
>   *     https://gcc.gnu.org/bugzilla/show_bug.cgi?id=67368
>   * '__maybe_unused' allows us to avoid defined-but-not-used warnings.
>   */
> -# define __no_kasan_or_inline __no_sanitize_address notrace __maybe_unused
> +# define __no_kasan_or_inline __no_sanitize_address __maybe_unused
>  # define __no_sanitize_or_inline __no_kasan_or_inline
>  #else
>  # define __no_kasan_or_inline __always_inline
> @@ -247,7 +246,7 @@ struct ftrace_likely_data {
>   * disable all instrumentation. See Kconfig.kcsan where this is mandatory.
>   */
>  # define __no_kcsan __no_sanitize_thread __disable_sanitizer_instrumentation
> -# define __no_sanitize_or_inline __no_kcsan notrace __maybe_unused
> +# define __no_sanitize_or_inline __no_kcsan __maybe_unused
>  #else
>  # define __no_kcsan
>  #endif
> -- 
> 2.39.2
> 
