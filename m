Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 991E4D83A3
	for <lists+live-patching@lfdr.de>; Wed, 16 Oct 2019 00:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732578AbfJOW1J (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Oct 2019 18:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732259AbfJOW1J (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Oct 2019 18:27:09 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCD4B2064A;
        Tue, 15 Oct 2019 22:27:06 +0000 (UTC)
Date:   Tue, 15 Oct 2019 18:27:05 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Jessica Yu <jeyu@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jpoimboe@redhat.com,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
Message-ID: <20191015182705.1aeec284@gandalf.local.home>
In-Reply-To: <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
References: <20191010092054.GR2311@hirez.programming.kicks-ass.net>
        <20191010091956.48fbcf42@gandalf.local.home>
        <20191010140513.GT2311@hirez.programming.kicks-ass.net>
        <20191010115449.22044b53@gandalf.local.home>
        <20191010172819.GS2328@hirez.programming.kicks-ass.net>
        <20191011125903.GN2359@hirez.programming.kicks-ass.net>
        <20191015130739.GA23565@linux-8ccs>
        <20191015135634.GK2328@hirez.programming.kicks-ass.net>
        <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz>
        <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
        <20191015153120.GA21580@linux-8ccs>
        <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 15 Oct 2019 18:17:43 -0400
Joe Lawrence <joe.lawrence@redhat.com> wrote:

> 
> Livepatching folks -- I don't have the LPC summary link (etherpad?) that 
> Jiri put together.  Does someone have that handy for Jessica?

Yes, and I'll be posting this on the LPC web site soon. But here's the
write up that Jiri sent me (with the etherpad link at the end):

Live patching miniconference covered 8 topics overall.

(1) First session, titled "What happened in kernel live patching over the last
year" was led by Miroslav Benes.  It was quite a natural followup to where we
ended at the LPC 2018 miniconf, summarizing which of the points that have been
agreed on back then have already been fully implemented, where obstacles have
been enounctered, etc.

The most prominent feature that has been merged during past year was "atomic
replace", which allows for easier stacking of patches. This is especially
useful for distros, as it naturally aligns with the way patches are being
distributed by them.
Another big step forward since LPC 2018 miniconf was addition of livepatching
selftests, which already tremendously helped in various cases, as it e.g.
helped to track down quite a few issues during development of reliable
stacktraces on s390. Proposal has been made that all major KLP features in the
future should be accompanied by accompanying selftest, which the audience
agreed on.
One of the last year's discussion topics / pain points were GCC optimizations
which are not compatible with livepatching. GCC upstream now has
-flive-patching option, which disables all those interfering optimizations.

(2) Second session, titled "Rethinking late module patching" was led by Miroslav
Benes again.
The problem statement is: in case when there is a patch loaded for module that
is yet to be loaded, it has to be patched before it starts executing. The
current solution relies on hooks in the module loader, and module is patched
when its being linked.  It gets a bit nasty with the arch-specifics of the
module loader handling all the relocations, patching of alternatives, etc. One
of the issues is that all the paravirt / jump label patching has to be done
after relocations are resolved, this is getting a bit fragile and not well
maintainable.
Miroslav sketched out the possible solutions:

	- livepatch would immediately load all the modules for which it has
	  patch via dependency; half-loading modules (not promoting to final
	  LIVE state)
	- splitting the currently one big monolithic livepatch to a per-object
	  structure; might cause issues with consistency model
	- "blue sky" idea from Joe Lawrence: livepatch loaded modules,
	  binary-patch .ko on disk, blacklist vulnerable version

Miroslav proposed to actually stick to the current solution, and improve
selftests coverage for all the considered-fragile arch-specific module linking
code hooks. The discussion then mostly focused, based on proposals from several
attendees (most prominently Steven Rostedt and Amit Shah), on expanding on the
"blue sky" idea.
The final proposal converged to having a separate .ko for livepatches that's
installed on the disk along with the module.  This addresses the module
signature issue (as signature does not actually change), as well as module
removal case (the case where a module was previously loaded while a livepatch
is applied, and then later unloaded and reloaded).  The slight downside is that
this will require changes to the module loader to also look for livepatches
when loading a module.  When unloading the module, the livepatch module will
also need to be unloaded.  Steven approved of this approach over his previous
suggestion.

(3) Third session, titled "Source-based livepatch creation tooling", was led by
Nicolai Stange.
The primary objective of the session was basing on the source-based creation
of livepatches, while avoiding the tedious (and error-prone task) of copying
a lot of kernel code around (from the source tree to the livepatch). Nicolai
spent par of last year writing a klp-ccp (KLP Copy and Paste) utility, which
automates a big chunk of the process.
Nicolai then presented the still open issues with the tool and with the process
around it, most promonent ones being:

	- obtaining original GCC commandline that was used to build the
	  original kernel
	- externalizability of static functions; we need to know whether GCC
	  emitted static function into the patched object

Miroslav proposed to extend existing IPA dumping capabiity of GCC to emit also
the information about dead code elimination; DWARF information is guaranteed
not to be reliable when it comes to IPA optimizations.

(4) Fourth session, titled "Objtool on power -- update", was led by Kamalesh
Babulal.
Kamalesh reported that as a followup to last year's miniconference, the objtool
support for powerpc actually came to life. It hasn't yet been posted upstream,
but is currently available on github [1].
Kamalesh further reported, that decoder has basic functionality (stack
operations + validation, branches, unreachable code, switch table (through gcc
plugin), conditional branches, prologue sequences). It turns out that stack
validation on powerpc is easier than on x86, as the ABI is much more strict
there; which leaves the validation phase to mostly focus on hand-written
assembly.
The next steps are basing on arm64 objtool code which already abstracted out
the arch-specific bits, and further optimizations can be stacked on top of that
(switch table detection, more testing, different gcc versions).

(5) Fifth session, titled "Do we need a Livepatch Developers Guide?", was led
by Joe Lawrence.
Joe postulated, that Current in-kernel documentation provides very good
documentation for individual features the infrastructure provides to the
livepatch author, but Joe further suggested to also include something along the
lines of what they currently have for kpatch, which takes a more general look
from the point of view of livepatch developer.

Proposals that have been brought up for discussion:
    - FAQ
    - collecting already existing CVE fixes and ammend them with a lot of
      commentary
    - creating a livepatch blog on people.kernel.org

Mark Brown asked for documenting what architectures need to implement in order
to support livepatching.
Amit Shah asked if the 'kpatch' and 'kpatch-build' script/program be renamed to
'livepatch'-friendly names so that kernel sources can also reference them for
the user docs part of it.
Both Mark's and Amit's remarks have been considered very valid and useful, and
agreement was reached that they will be taken care of.

(6) Sixth session, titled "API for state changes made by callbacks", was led
by Petr Mladek.

Petr described his proposal for API for changing, updating and disabling
patches (by callbacks). Example where this was needed: L1TF fix, which needed
to change PTE semantics (particular bits). This can't be done before all the
code understands this new PTE format/semantics. Therefore pre-patch and
post-patch callbacks had to do the actual modifications to all the existing
PTEs. What is also currently missing is tracking compatibilities / dependencies
between individual livepatches.
Petr's proposal (v2) is already on ML.
struct klp_state is being introduced which tracks the actual states of the
patch. klp_is_patch_compatible() checks the compatibility of the current states
to the states that the new livepatch is going to bring.
No principal issues / objections have been raised, and it's appreciated by the
patch author(s), so v3 will be submitted and pre-merge bikeshedding will start.

(7) Seventh session, titled "klp-convert and livepatch relocations", was led
by Joe Lawrence.

Joe started the session with problem statement: accessing non exported / static
symbols from inside the patch module. One possible workardound is manually via
kallsyms. Second workaround is klp-convert, which actually creates proper
relocations inside the livepatch module from the symbol database during the
final .ko link.
Currently module loader looks for special livepatch relocations and resolves
those during runtime; kernel support for these relocations have so far been
added for x86 only. Special livepatch relocations are supported and processed
also on other architectures. Special quirks/sections are not yet supported.
Plus klp-convert would still be needed even with late module patching update.
vmlinux or modules could have ambiguous static symbols.

It turns out that the features / bugs below have to be resolved before we
can claim the klp-convert support for relocation complete:
    - handle all the corner cases (jump labels, static keys, ...) properly and
      have a good regression tests in place
    - one day we might (or might not) add support for out-of-tree modules which
      need klp-convert
    - BFD bug 24456 (multiple relocations to the same .text section)

(8) Eight sesstion, titled "Making livepatching infrastructure better", was led
by Kamalesh Babulal.


The primary goal of the discussion as presented by Kamalesh was simple: how to
improve our testing coverage.  Currently we have sample modules + kselftests.
We seem to be currently missing specific unit cases and tests for corner cases.
What Kamalesh would also like to see would be more stress testing oriented
tests for the infrastructure. We should make sure that projects like kernelCI
are running with CONFIG_LIVEPATCH=y.
Another thing Kamalesh currently sees as missing are failure test cases too. 
It should be checked with sosreport and supportconfig guys whether those
diagnostic tools do provide necessary coverage of (at least) livepatching sysfs
state. This is especially a task for distro people to figure out.
Nicolai proposed as one of the testcases identity patching, as that should
reveal issues directly in the infrastructure.

(9) Last, ninth session, titled "Open sourcing live patching services", was led
by Alice Ferrazzi.
This session followed up on previous suggestion of having public repository for
livepatches against LTS kernel.
Alice reported on improviement of elivepatch since last year as having moved
everything to docker.
Alice proposed to more share livepatch sources; SUSE does publish those [2][3],
but it's important to mention that livepatches are very closely tied to
particular kernel version.

[1] https://github.com/kamalesh-babulal/linux/tree/objtool-v1
[2] On https://kernel.suse.com/
[3] Example source-based SUSE's livepatch is at https://kernel.suse.com/cgit/kernel-livepatch/tree/uname_patch/kgr_patch_uname.c?id=d4e00de0b0a3f858fec4e83640f12e1f17298667

Eherpad: https://etherpad.net/p/LPC2019_Live_Patching
