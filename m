Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D0945A715
	for <lists+live-patching@lfdr.de>; Tue, 23 Nov 2021 17:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236507AbhKWQGb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Nov 2021 11:06:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:37630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236114AbhKWQGb (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Nov 2021 11:06:31 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3204E60F6F;
        Tue, 23 Nov 2021 16:03:22 +0000 (UTC)
Date:   Tue, 23 Nov 2021 11:03:20 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Peter Zijlstra <peterz@infradead.org>, joao@overdrivepizza.com,
        nstange@suse.de, pmladek@suse.cz, jpoimboe@redhat.com,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        alexei.starovoitov@gmail.com
Subject: Re: CET/IBT support and live-patches
Message-ID: <20211123110320.75990e0b@gandalf.local.home>
In-Reply-To: <alpine.LSU.2.21.2111231237090.15177@pobox.suse.cz>
References: <70828ca9f840960c7a3f66cd8dc141f5@overdrivepizza.com>
        <alpine.LSU.2.21.2111231035460.15177@pobox.suse.cz>
        <YZzHE+Cze9AX6HCZ@hirez.programming.kicks-ass.net>
        <alpine.LSU.2.21.2111231237090.15177@pobox.suse.cz>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 23 Nov 2021 12:39:15 +0100 (CET)
Miroslav Benes <mbenes@suse.cz> wrote:

> +++ b/kernel/livepatch/patch.c
> @@ -127,15 +127,18 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>  /*
>   * Convert a function address into the appropriate ftrace location.
>   *
> - * Usually this is just the address of the function, but on some architectures
> - * it's more complicated so allow them to provide a custom behaviour.
> + * Usually this is just the address of the function, but there are some
> + * exceptions.
> + *
> + *   * PPC - live patch works only with -mprofile-kernel. In this case,
> + *     the ftrace location is always within the first 16 bytes.
> + *   * x86_64 with CET/IBT enabled - there is ENDBR instruction at +0 offset.
> + *     __fentry__ follows it.
>   */
> -#ifndef klp_get_ftrace_location
> -static unsigned long klp_get_ftrace_location(unsigned long faddr)
> +static inline unsigned long klp_get_ftrace_location(unsigned long faddr)

Why make this the default function? It should only do this for powerpc and
x86 *if* CET/IBT is enabled.

-- Steve


>  {
> -	return faddr;
> +	return ftrace_location_range(faddr, faddr + 16);
>  }
> -#endif
>  
