Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0794323840
	for <lists+live-patching@lfdr.de>; Wed, 24 Feb 2021 09:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhBXICG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 24 Feb 2021 03:02:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234069AbhBXIBM (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 24 Feb 2021 03:01:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E93964DA1;
        Wed, 24 Feb 2021 08:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614153630;
        bh=63Zmf/E3b/3bpOMZyuG6pJsv9DRPtP/oIUJnTF/QqYI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oGHIh0Fe4jWkEqJCDIsBsuArSbgDWm5HIiNJNjqqhQHQA1ltO+pZPkqfCiAl7uTTT
         E5ecZHjhEhmzfvvLGPpsR5RoQ81H1lVuSQ8MDG9jeJk8ORiLHh1gapRgxj2coC47bm
         91ZbfPIFhJyVtCYLeQivUqHhxVlJfnoI45nShZPXt9Qxfw1pNEg0XhOuy5520OBnew
         BOfkKu/Xxlb1uFgwavjlDo5T38EMKfg4y4LxAaAeqw6srLJKsgHTlF9CSQtvSUwy4U
         377fWijOnqc+wFVfRHQrfpbI0Y1/w7oaLKpRTmm8oxQAxCOyx3GFk/oNfsrblwBJ0x
         tiJKxpvKTLMKw==
Date:   Wed, 24 Feb 2021 17:00:24 +0900
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
Message-Id: <20210224170024.cf1ec706aab9b1f5f0f9db7b@kernel.org>
In-Reply-To: <20210223194546.dhejf4mpugyw3nqq@treble>
References: <09257fb8-3ded-07b0-b3cc-55d5431698d8@virtuozzo.com>
        <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
        <20210222175150.yxgw3sxxaqjqgq56@treble>
        <20210223102331.147d62de88886a75013c10e0@kernel.org>
        <20210223163619.0cd580a4290165208c8aa7bb@kernel.org>
        <20210223194546.dhejf4mpugyw3nqq@treble>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 23 Feb 2021 13:45:46 -0600
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> On Tue, Feb 23, 2021 at 04:36:19PM +0900, Masami Hiramatsu wrote:
> > On Tue, 23 Feb 2021 10:23:31 +0900
> > Masami Hiramatsu <mhiramat@kernel.org> wrote:
> > 
> > > On Mon, 22 Feb 2021 11:51:50 -0600
> > > Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > > 
> > > > On Tue, Feb 23, 2021 at 12:05:08AM +0900, Masami Hiramatsu wrote:
> > > > > > Of course, one could place probes using absolute addresses of the 
> > > > > > functions but that would be less convenient.
> > > > > > 
> > > > > > This also affects many livepatch modules where the kernel code can be 
> > > > > > compiled with -ffunction-sections and each function may end up in a 
> > > > > > separate section .text.<function_name>. 'perf probe' cannot be used 
> > > > > > there, except with the absolute addresses.
> > > > > > 
> > > > > > Moreover, if FGKASLR patches are merged 
> > > > > > (https://lwn.net/Articles/832434/) and the kernel is built with FGKASLR 
> > > > > > enabled, -ffunction-sections will be used too. 'perf probe' will be 
> > > > > > unable to see the kernel functions then.
> > > > > 
> > > > > Hmm, if the FGKASLAR really randomizes the symbol address, perf-probe
> > > > > should give up "_text-relative" probe for that kernel, and must fallback
> > > > > to the "symbol-based" probe. (Are there any way to check the FGKASLR is on?)
> > > > > The problem of "symbol-based" probe is that local (static) symbols
> > > > > may share a same name sometimes. In that case, it can not find correct
> > > > > symbol. (Maybe I can find a candidate from its size.)
> > > > > Anyway, sometimes the security and usability are trade-off.
> > > > 
> > > > We had a similar issue with FGKASLR and live patching.  The proposed
> > > > solution is a new linker flag which eliminates duplicates: -z
> > > > unique-symbol.
> > > > 
> > > > https://sourceware.org/bugzilla/show_bug.cgi?id=26391
> > > 
> > > Interesting, but it might not be enough for perf-probe.
> > > Since the perf-probe has to handle both dwarf and elf, both must be
> > > changed. I think the problem is that the dwarf is generated while
> > > compiling, but this -z seems converting elf symbols in linkage.
> > > As far as I can see, this appends ".COUNT" suffix to the non-unique
> > > symbols in the linkage phase. Is that also applied to dwarf too?
> > 
> > Ah, OK. If there is an offline elf binary with symbol map, I can convert
> > DWARF symbol -> address -> offline elf symbol (unique name)-> kallsyms.
> > Currently, it directly converts address by kallsyms, so I will change it
> > to find elf-symbol and solve address by kallsyms in post processing.
> 
> DWARF sections have references to the ELF symbols, which are renamed by
> the linker.  So DWARF should automatically show the new symbol name.

OK, I'll check what elfutils provides about that information.
> 
> And kallsyms is generated after the kernel is linked.  So I'm not sure I
> understand the problem.

Actually, perf-probe currently uses subprogram DIE(Dwarf node) name for
the symbol name and post-process tries to find correct symbol name
from kallsyms by the address.
So I have to change it to find the ELF symbol name from DIE itself.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
