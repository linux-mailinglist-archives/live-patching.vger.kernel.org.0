Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08E2BDC5AF
	for <lists+live-patching@lfdr.de>; Fri, 18 Oct 2019 15:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389066AbfJRNDu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 18 Oct 2019 09:03:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732402AbfJRNDu (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 18 Oct 2019 09:03:50 -0400
Received: from linux-8ccs (charybdis-ext.suse.de [195.135.221.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 629022089C;
        Fri, 18 Oct 2019 13:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571403828;
        bh=lL8Za+mOfGulu5d9ptAB5Ims459ZMBbh69VwNRLPf3I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2PiFZp/ttMIY0FneBPAgdpZDNxHFqsWozEphWvtfDcs97tJtvEztr1vZP3g5ZMMuy
         5HyfKb5d65lgzxLvRCKTXY9XjZPaYTmEJhMmds0R9KCaiYqOV2Ftg9Sgl3EYieVKdZ
         T0ca42vumyRuk9azSYRFw5DgGUVRMYvGeXM9cvHg=
Date:   Fri, 18 Oct 2019 15:03:42 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jpoimboe@redhat.com,
        live-patching@vger.kernel.org, pmladek@suse.com
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
Message-ID: <20191018130342.GA4625@linux-8ccs>
References: <20191015130739.GA23565@linux-8ccs>
 <20191015135634.GK2328@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz>
 <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
 <20191015153120.GA21580@linux-8ccs>
 <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
 <20191015182705.1aeec284@gandalf.local.home>
 <20191016074951.GM2328@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.1910161216100.7750@pobox.suse.cz>
 <alpine.LSU.2.21.1910161521010.7750@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1910161521010.7750@pobox.suse.cz>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.28-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Miroslav Benes [16/10/19 15:29 +0200]:
>On Wed, 16 Oct 2019, Miroslav Benes wrote:
>
>> On Wed, 16 Oct 2019, Peter Zijlstra wrote:
>>
>> > On Tue, Oct 15, 2019 at 06:27:05PM -0400, Steven Rostedt wrote:
>> >
>> > > (7) Seventh session, titled "klp-convert and livepatch relocations", was led
>> > > by Joe Lawrence.
>> > >
>> > > Joe started the session with problem statement: accessing non exported / static
>> > > symbols from inside the patch module. One possible workardound is manually via
>> > > kallsyms. Second workaround is klp-convert, which actually creates proper
>> > > relocations inside the livepatch module from the symbol database during the
>> > > final .ko link.
>> > > Currently module loader looks for special livepatch relocations and resolves
>> > > those during runtime; kernel support for these relocations have so far been
>> > > added for x86 only. Special livepatch relocations are supported and processed
>> > > also on other architectures. Special quirks/sections are not yet supported.
>> > > Plus klp-convert would still be needed even with late module patching update.
>> > > vmlinux or modules could have ambiguous static symbols.
>> > >
>> > > It turns out that the features / bugs below have to be resolved before we
>> > > can claim the klp-convert support for relocation complete:
>> > >     - handle all the corner cases (jump labels, static keys, ...) properly and
>> > >       have a good regression tests in place
>> >
>> > I suppose all the patches in this series-of-series here will make life
>> > harder for KLP, static_call() and 2 byte jumps etc..
>>
>> Yes, I think so. We'll have to deal with that once it lands. That is why
>> we want to get rid of all this arch-specific code in livepatch and
>> reinvent the late module patching. So it is perhaps better to start
>> working on it sooner than later. Adding Petr, who hesitantly signed up for
>> the task...
>
>Thinking about it more... crazy idea. I think we could leverage these new
>ELF .text per vmlinux/module sections for the reinvention I was talking
>about. If we teach module loader to relocate (and apply alternatives and
>so on, everything in arch-specific module_finalize()) not the whole module
>in case of live patch modules, but separate ELF .text sections, it could
>solve the issue with late module patching we have. It is a variation on
>Steven's idea. When live patch module is loaded, only its section for
>present modules would be processed. Then whenever a to-be-patched module
>is loaded, its .text section in all present patch module would be
>processed.
>
>The upside is that almost no work would be required on patch modules
>creation side. The downside is that klp_modinfo must stay. Module loader
>needs to be hacked a lot in both cases. So it remains to be seen which
>idea is easier to implement.
>
>Jessica, do you think it would be feasible?

I think that does sound feasible. I'm trying to visualize how that
would look. I guess there would need to be various livepatching hooks
called during the different stages (apply_relocate_add(),
module_finalize(), module_enable_ro/x()).

So maybe something like the following?

When a livepatch module loads:
    apply_relocate_add()
        klp hook: apply .klp.rela.$objname relocations *only* for
        already loaded modules
    module_finalize()
        klp hook: apply .klp.arch.$objname changes for already loaded modules
    module_enable_ro()
        klp hook: only enable ro/x for .klp.text.$objname for already
        loaded modules

When a to-be-patched module loads:
    apply_relocate_add()
        klp hook: for each patch module that patches the coming
        module, apply .klp.rela.$objname relocations for this object
    module_finalize()
        klp hook: for each patch module that patches the coming
        module, apply .klp.arch.$objname changes for this object
    module_enable_ro()
        klp hook: for each patch module, apply ro/x permissions for
        .klp.text.$objname for this object

Then, in klp_module_coming, we only need to do the callbacks and
enable the patch, and get rid of the module_disable_ro->apply
relocs->module_enable_ro block.

Does that sound like what you had in mind or am I totally off?

Thanks!

Jessica

