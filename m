Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5405E6F4CD8
	for <lists+live-patching@lfdr.de>; Wed,  3 May 2023 00:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbjEBWZa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 May 2023 18:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjEBWZ3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 May 2023 18:25:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EB610E7;
        Tue,  2 May 2023 15:25:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 399C062916;
        Tue,  2 May 2023 22:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3A9C433A4;
        Tue,  2 May 2023 22:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683066327;
        bh=p6tGDs6cfabXvT/biu59cKim9mysMg3Q5CdtBG9oN3U=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VnvGj4y0t06kGlOynnuR4B5RpXXLAZtmaEP39DSRpE8zgeDNVN4Yg62o4Y0NB9Sn5
         6bnGvHLxJiq2RI8I5KBQVbZI4qhIBVBrFFzA/Otx3mmfUkh3cpNZd0R9ycEgFqEIfW
         wpS1cIJyE9uffrTCCUL56y52GznK68OJAcdzGfzcdtprgWSXCWrWFcBsjQQXTd1Vcz
         LFQ9HuVd9EQXMAl9VRNWyQXs9b6DH3bpJ8pVYuQo6oCy91VjIn5DF5q9K9ITbB+nkh
         qBDD0SeRV7FUc8PscJd/nWOnwtYahMr0R3cksIezVqXSXgijzV9ezCP55beJvahWnO
         O+6qkHVdd6+Iw==
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2a8c51ba511so43413541fa.1;
        Tue, 02 May 2023 15:25:27 -0700 (PDT)
X-Gm-Message-State: AC+VfDwl5TYpJdROPp5Ui/1hCrZmE3Et/nKVlRFT8VZIIO7STccht3x1
        2+kklkplD2tR7XPtDqJubvCVsy/8zgRHOFAqZ6A=
X-Google-Smtp-Source: ACHHUZ4avdpthadjO3gTttNI6hwHrd0BY/FTJBOc8OGJj8VI9BZbqcEwFzhqWiZTr4yxUlkxlDBcL/zfsHuzd1eGp1k=
X-Received: by 2002:ac2:5608:0:b0:4ef:f64b:65b4 with SMTP id
 v8-20020ac25608000000b004eff64b65b4mr380429lfd.26.1683066325488; Tue, 02 May
 2023 15:25:25 -0700 (PDT)
MIME-Version: 1.0
References: <20230502164102.1a51cdb4@gandalf.local.home>
In-Reply-To: <20230502164102.1a51cdb4@gandalf.local.home>
From:   Song Liu <song@kernel.org>
Date:   Tue, 2 May 2023 15:25:13 -0700
X-Gmail-Original-Message-ID: <CAPhsuW76--qgbEWn8YZY7Hj1GjB9__kfSjWnHz=WNBSV8GyCXQ@mail.gmail.com>
Message-ID: <CAPhsuW76--qgbEWn8YZY7Hj1GjB9__kfSjWnHz=WNBSV8GyCXQ@mail.gmail.com>
Subject: Re: [PATCH] ftrace: Allow inline functions not inlined to be traced
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        live-patching@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 2, 2023 at 1:41=E2=80=AFPM Steven Rostedt <rostedt@goodmis.org>=
 wrote:
>
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
> Today, it is no longer a problem if an inlined function is not inlined an=
d
> is traced. Removing notrace from inline has been requested several times
> over the years. I believe it is now safe to do so.
>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Acked-by: Song Liu <song@kernel.org>

Thanks!
Song

> ---
>  include/linux/compiler_types.h | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/compiler_types.h b/include/linux/compiler_type=
s.h
> index 547ea1ff806e..c8f23ba1c339 100644
> --- a/include/linux/compiler_types.h
> +++ b/include/linux/compiler_types.h
> @@ -182,9 +182,8 @@ struct ftrace_likely_data {
>   * externally visible function. This makes extern inline behave as per g=
nu89
>   * semantics rather than c99. This prevents multiple symbol definition e=
rrors
>   * of extern inline functions at link time.
> - * A lot of inline functions can cause havoc with function tracing.
>   */
> -#define inline inline __gnu_inline __inline_maybe_unused notrace
> +#define inline inline __gnu_inline __inline_maybe_unused
>
>  /*
>   * gcc provides both __inline__ and __inline as alternate spellings of
> @@ -230,7 +229,7 @@ struct ftrace_likely_data {
>   *     https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D67368
>   * '__maybe_unused' allows us to avoid defined-but-not-used warnings.
>   */
> -# define __no_kasan_or_inline __no_sanitize_address notrace __maybe_unus=
ed
> +# define __no_kasan_or_inline __no_sanitize_address __maybe_unused
>  # define __no_sanitize_or_inline __no_kasan_or_inline
>  #else
>  # define __no_kasan_or_inline __always_inline
> @@ -247,7 +246,7 @@ struct ftrace_likely_data {
>   * disable all instrumentation. See Kconfig.kcsan where this is mandator=
y.
>   */
>  # define __no_kcsan __no_sanitize_thread __disable_sanitizer_instrumenta=
tion
> -# define __no_sanitize_or_inline __no_kcsan notrace __maybe_unused
> +# define __no_sanitize_or_inline __no_kcsan __maybe_unused
>  #else
>  # define __no_kcsan
>  #endif
> --
> 2.39.2
>
