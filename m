Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605A372A559
	for <lists+live-patching@lfdr.de>; Fri,  9 Jun 2023 23:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjFIV3I (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Jun 2023 17:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjFIV3I (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Jun 2023 17:29:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A2C1AE;
        Fri,  9 Jun 2023 14:29:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E37660BBB;
        Fri,  9 Jun 2023 21:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA5CC433EF;
        Fri,  9 Jun 2023 21:29:04 +0000 (UTC)
Date:   Fri, 9 Jun 2023 17:29:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Mark Rutland <mark.rutland@arm.com>
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
Message-ID: <20230609172902.1d386ed7@gandalf.local.home>
In-Reply-To: <ZIGkezEx87zehzJr@FVFF77S0Q05N>
References: <20230502164102.1a51cdb4@gandalf.local.home>
        <ZIGkezEx87zehzJr@FVFF77S0Q05N>
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

On Thu, 8 Jun 2023 10:50:51 +0100
Mark Rutland <mark.rutland@arm.com> wrote:


> Unfortunately, from a quick build-test of arm64 there are a bunch of places
> that are currently inline that need to be __always_inline for this to be safe.
> Notably we have a few low-level helpers like is_kernel_in_hyp_mode() that are
> only inlines, and those get used in the bowels of our entry code before we've
> restored some HW state (e.g. in arch_nmi_enter()).

Sounds like you also need to add noinstr ;-)

> 
> I'm happy to go audit and fixup arm64, but that will take some work.
> 
> Maybe it's worth having something like:
> 
> #ifdef ARCH_CAN_TRACE_INLINE
> #define __notrace_inline
> #else
> #define __notrace_inline	notrace
> #endif
> 
> ... so that we can opt-in where this is safe, (e.g. on x86)?

I guess I can do that.

-- Steve

