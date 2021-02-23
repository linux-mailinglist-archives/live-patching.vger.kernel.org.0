Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655443223AA
	for <lists+live-patching@lfdr.de>; Tue, 23 Feb 2021 02:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhBWBZc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 22 Feb 2021 20:25:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:38280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229967AbhBWBYP (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 22 Feb 2021 20:24:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 661F860232;
        Tue, 23 Feb 2021 01:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614043415;
        bh=VQBJvAaPvVk3ewwCQ9qqE3Oyikga6Xw0ZOguULkFO0U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ct3gFvNnmoFf+fH0MuzKVyWNchfaSBuU8VO5TF42pVs7kTGWv9u5ZerxhLCveUkQz
         z+909UKLqMA3c9alZcAMivXemWqP97XoZ942HLtmTgzNpXt6bcqMVyIicdVOXxVxbj
         cNI0qhERdBPVeXNtfYWaQ5QQWOprxIXi8cuoXrFsjk5etB//VX3SLeBLZYGWzX8sD8
         cQ8i7RXhYd3RLRZHVIQKX30mxhwXTjFR5zYGxh/vcdLHY7A8joJtt0bSgNADNDVS6F
         KEHES3vgj4xVWu2q7t4PyxX2J4rYFX4JPm8B6cqqiASpMMK04W2Q7Axo8S6kHwGxkN
         qh6xrK/Atygkg==
Date:   Tue, 23 Feb 2021 10:23:31 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: Re: 'perf probe' and symbols from .text.<something>
Message-Id: <20210223102331.147d62de88886a75013c10e0@kernel.org>
In-Reply-To: <20210222175150.yxgw3sxxaqjqgq56@treble>
References: <09257fb8-3ded-07b0-b3cc-55d5431698d8@virtuozzo.com>
        <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
        <20210222175150.yxgw3sxxaqjqgq56@treble>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 22 Feb 2021 11:51:50 -0600
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> On Tue, Feb 23, 2021 at 12:05:08AM +0900, Masami Hiramatsu wrote:
> > > Of course, one could place probes using absolute addresses of the 
> > > functions but that would be less convenient.
> > > 
> > > This also affects many livepatch modules where the kernel code can be 
> > > compiled with -ffunction-sections and each function may end up in a 
> > > separate section .text.<function_name>. 'perf probe' cannot be used 
> > > there, except with the absolute addresses.
> > > 
> > > Moreover, if FGKASLR patches are merged 
> > > (https://lwn.net/Articles/832434/) and the kernel is built with FGKASLR 
> > > enabled, -ffunction-sections will be used too. 'perf probe' will be 
> > > unable to see the kernel functions then.
> > 
> > Hmm, if the FGKASLAR really randomizes the symbol address, perf-probe
> > should give up "_text-relative" probe for that kernel, and must fallback
> > to the "symbol-based" probe. (Are there any way to check the FGKASLR is on?)
> > The problem of "symbol-based" probe is that local (static) symbols
> > may share a same name sometimes. In that case, it can not find correct
> > symbol. (Maybe I can find a candidate from its size.)
> > Anyway, sometimes the security and usability are trade-off.
> 
> We had a similar issue with FGKASLR and live patching.  The proposed
> solution is a new linker flag which eliminates duplicates: -z
> unique-symbol.
> 
> https://sourceware.org/bugzilla/show_bug.cgi?id=26391

Interesting, but it might not be enough for perf-probe.
Since the perf-probe has to handle both dwarf and elf, both must be
changed. I think the problem is that the dwarf is generated while
compiling, but this -z seems converting elf symbols in linkage.
As far as I can see, this appends ".COUNT" suffix to the non-unique
symbols in the linkage phase. Is that also applied to dwarf too?

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
