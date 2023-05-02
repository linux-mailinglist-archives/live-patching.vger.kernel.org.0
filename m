Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361C76F4B7E
	for <lists+live-patching@lfdr.de>; Tue,  2 May 2023 22:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjEBUlN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 May 2023 16:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjEBUlL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 May 2023 16:41:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7DB1FD7;
        Tue,  2 May 2023 13:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0061D622AA;
        Tue,  2 May 2023 20:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5B0C433EF;
        Tue,  2 May 2023 20:41:04 +0000 (UTC)
Date:   Tue, 2 May 2023 16:41:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Song Liu <song@kernel.org>, live-patching@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] ftrace: Allow inline functions not inlined to be traced
Message-ID: <20230502164102.1a51cdb4@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Over 10 years ago there were many bugs that caused function tracing to
crash because some inlined function was not inlined and should not have
been traced. This made it hard to debug because when the developer tried
to reproduce it, if their compiler still inlined the function, the bug
would not trigger. The solution back then was simply to add "notrace" to
"inline" which would make sure all functions that are marked inline are
never traced even when the compiler decides to not inline them.

A lot has changed over the last 10 years.

1) ftrace_test_recursion_trylock() is now used by all ftrace hooks which
   will prevent the recursive crashes from happening that was caused by
   inlined functions being traced.

2) noinstr is now used to mark pretty much all functions that would also
   cause problems if they are traced.

Today, it is no longer a problem if an inlined function is not inlined and
is traced. Removing notrace from inline has been requested several times
over the years. I believe it is now safe to do so.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/linux/compiler_types.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 547ea1ff806e..c8f23ba1c339 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -182,9 +182,8 @@ struct ftrace_likely_data {
  * externally visible function. This makes extern inline behave as per gnu89
  * semantics rather than c99. This prevents multiple symbol definition errors
  * of extern inline functions at link time.
- * A lot of inline functions can cause havoc with function tracing.
  */
-#define inline inline __gnu_inline __inline_maybe_unused notrace
+#define inline inline __gnu_inline __inline_maybe_unused
 
 /*
  * gcc provides both __inline__ and __inline as alternate spellings of
@@ -230,7 +229,7 @@ struct ftrace_likely_data {
  *     https://gcc.gnu.org/bugzilla/show_bug.cgi?id=67368
  * '__maybe_unused' allows us to avoid defined-but-not-used warnings.
  */
-# define __no_kasan_or_inline __no_sanitize_address notrace __maybe_unused
+# define __no_kasan_or_inline __no_sanitize_address __maybe_unused
 # define __no_sanitize_or_inline __no_kasan_or_inline
 #else
 # define __no_kasan_or_inline __always_inline
@@ -247,7 +246,7 @@ struct ftrace_likely_data {
  * disable all instrumentation. See Kconfig.kcsan where this is mandatory.
  */
 # define __no_kcsan __no_sanitize_thread __disable_sanitizer_instrumentation
-# define __no_sanitize_or_inline __no_kcsan notrace __maybe_unused
+# define __no_sanitize_or_inline __no_kcsan __maybe_unused
 #else
 # define __no_kcsan
 #endif
-- 
2.39.2

