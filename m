Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A38314D86A
	for <lists+live-patching@lfdr.de>; Thu, 30 Jan 2020 10:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgA3Jxv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 30 Jan 2020 04:53:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:33068 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbgA3Jxv (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 30 Jan 2020 04:53:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D4B6FAC4B;
        Thu, 30 Jan 2020 09:53:47 +0000 (UTC)
Date:   Thu, 30 Jan 2020 10:53:46 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, live-patching@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, nstange@suse.de
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
Message-ID: <20200130095346.6buhb3reehijbamz@pathway.suse.cz>
References: <alpine.LSU.2.21.2001210922060.6036@pobox.suse.cz>
 <20200121161045.dhihqibnpyrk2lsu@treble>
 <alpine.LSU.2.21.2001221052331.15957@pobox.suse.cz>
 <20200122214239.ivnebi7hiabi5tbs@treble>
 <alpine.LSU.2.21.2001281014280.14030@pobox.suse.cz>
 <20200128150014.juaxfgivneiv6lje@treble>
 <20200128154046.trkpkdaz7qeovhii@pathway.suse.cz>
 <20200128170254.igb72ib5n7lvn3ds@treble>
 <alpine.LSU.2.21.2001291249430.28615@pobox.suse.cz>
 <20200129155951.qvf3tjsv2qvswciw@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200129155951.qvf3tjsv2qvswciw@treble>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2020-01-29 09:59:51, Josh Poimboeuf wrote:
> In retrospect, the prerequisites for merging it should have been:

OK, let me do one more move in this game.


> 1) Document how source-based patches can be safely generated;

I agree that the information are really scattered over many files
in Documentation/livepatch/. Anyway, there is a lot of useful
hints:

   + structure and behavior of the livepatch module, link
     to a sample, limitations, are described in livepatch.rst

   + many other catches are described in the other files:
     callbacks, module-elf-fomat, cumulative-patches,
     system-state.

Yes, it would be great to have a better structure, more information.
But do not get me wrong. Anyone, Joe definitely, is able to create
livepatch from sources by this information.

Anyone could play with it, ask questions, and improve the
documentation. Better documentation would help but it is
not a blocker, definitely.


> 2) Fix the scheduler performance regression;

The optimizations are disabled only when livepatching is enabled.
I would consider this as a prize for the feature. There are
many things like this.

As it was said. It was 1-3 percent in scheduler microbenchmark.
It would make sense to fix it only when it causes such a regression
in real workloads. Do you have any?


> 3) Figure out if there are any other regressions by detecting which
>    function interfaces are affected by the flag and seeing if they're
>    hot path;

IMHO, benchmarks are much more effective and we spent non-trivial
resources when running them.


> 4) Provide a way for the N-1 users to opt-out

AFAIK, the only prize is the 1-3 percent scheduler performance degradation.
If you really do not want to pay this prize, let's make it configurable.

But the option is definitely needed when source livepatches are used.
There is no other reasonable way to detect and workaround these
problems. For this, it has to be in upstream kernel. It is in line
with the effort to make livepatching less and less error prone.

And please, let's stop playing this multi-user games. There is at least
one known user of source based livepatches. By coincidence, it is also
a big contributor to this subsystem. Adding an extra option into
CFLAGS is quite error prone. You can imagine how complicated is
a kernel rpm spec file for more kernel flavors. The only safe way
is to have the optimization tight with the CONFIG option in
kernel sources.


> 5) Fix the objtool warnings (or is it a GCC bug)

Nobody was aware of them. I wonder if they even existed at that time.
We have a simple fix now. Let's continue in the thread started by
Jikos if we could get a better solution.


> 6) Make -flive-patching compatible with LTO (or at least acknowledge
>    that it should and will be done soon)

Is LTO officially supported upstream?
Are all patches, features tested for LTO compactibility?
Is there any simple way to build and run LTO kernel?


> 7) At least make it build- or runtime-incompatible with Clang-built
>    kernels to prevent people from assuming it's safe.

Same questions as for LTO.


> If you don't want to revert the patch, then address my concerns instead
> of minimizing and deflecting at every opportunity.

I would really like to keep focusing on realistic problems and
realistic solutions:

   + make the optimization configurable if you resist on it
   + fix the objtool warnings

Anything else is out of scope of this thread from my POV.

Best Regards,
Petr
