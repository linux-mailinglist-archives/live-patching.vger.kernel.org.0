Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A58ED926F
	for <lists+live-patching@lfdr.de>; Wed, 16 Oct 2019 15:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391844AbfJPN3V (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Oct 2019 09:29:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:58888 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730142AbfJPN3V (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Oct 2019 09:29:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0CA19B583;
        Wed, 16 Oct 2019 13:29:19 +0000 (UTC)
Date:   Wed, 16 Oct 2019 15:29:17 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Peter Zijlstra <peterz@infradead.org>
cc:     Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jpoimboe@redhat.com,
        live-patching@vger.kernel.org, pmladek@suse.com
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
In-Reply-To: <alpine.LSU.2.21.1910161216100.7750@pobox.suse.cz>
Message-ID: <alpine.LSU.2.21.1910161521010.7750@pobox.suse.cz>
References: <20191010115449.22044b53@gandalf.local.home> <20191010172819.GS2328@hirez.programming.kicks-ass.net> <20191011125903.GN2359@hirez.programming.kicks-ass.net> <20191015130739.GA23565@linux-8ccs> <20191015135634.GK2328@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz> <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com> <20191015153120.GA21580@linux-8ccs> <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com> <20191015182705.1aeec284@gandalf.local.home>
 <20191016074951.GM2328@hirez.programming.kicks-ass.net> <alpine.LSU.2.21.1910161216100.7750@pobox.suse.cz>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 16 Oct 2019, Miroslav Benes wrote:

> On Wed, 16 Oct 2019, Peter Zijlstra wrote:
> 
> > On Tue, Oct 15, 2019 at 06:27:05PM -0400, Steven Rostedt wrote:
> > 
> > > (7) Seventh session, titled "klp-convert and livepatch relocations", was led
> > > by Joe Lawrence.
> > > 
> > > Joe started the session with problem statement: accessing non exported / static
> > > symbols from inside the patch module. One possible workardound is manually via
> > > kallsyms. Second workaround is klp-convert, which actually creates proper
> > > relocations inside the livepatch module from the symbol database during the
> > > final .ko link.
> > > Currently module loader looks for special livepatch relocations and resolves
> > > those during runtime; kernel support for these relocations have so far been
> > > added for x86 only. Special livepatch relocations are supported and processed
> > > also on other architectures. Special quirks/sections are not yet supported.
> > > Plus klp-convert would still be needed even with late module patching update.
> > > vmlinux or modules could have ambiguous static symbols.
> > > 
> > > It turns out that the features / bugs below have to be resolved before we
> > > can claim the klp-convert support for relocation complete:
> > >     - handle all the corner cases (jump labels, static keys, ...) properly and
> > >       have a good regression tests in place
> > 
> > I suppose all the patches in this series-of-series here will make life
> > harder for KLP, static_call() and 2 byte jumps etc..
> 
> Yes, I think so. We'll have to deal with that once it lands. That is why 
> we want to get rid of all this arch-specific code in livepatch and 
> reinvent the late module patching. So it is perhaps better to start 
> working on it sooner than later. Adding Petr, who hesitantly signed up for 
> the task...

Thinking about it more... crazy idea. I think we could leverage these new 
ELF .text per vmlinux/module sections for the reinvention I was talking 
about. If we teach module loader to relocate (and apply alternatives and 
so on, everything in arch-specific module_finalize()) not the whole module 
in case of live patch modules, but separate ELF .text sections, it could 
solve the issue with late module patching we have. It is a variation on 
Steven's idea. When live patch module is loaded, only its section for 
present modules would be processed. Then whenever a to-be-patched module 
is loaded, its .text section in all present patch module would be 
processed.

The upside is that almost no work would be required on patch modules 
creation side. The downside is that klp_modinfo must stay. Module loader 
needs to be hacked a lot in both cases. So it remains to be seen which 
idea is easier to implement.

Jessica, do you think it would be feasible?

Petr, Joe, Josh, am I missing something or would it work?

Miroslav
