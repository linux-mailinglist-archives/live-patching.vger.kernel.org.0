Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF682E1537
	for <lists+live-patching@lfdr.de>; Wed, 23 Oct 2019 11:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390394AbfJWJEV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 23 Oct 2019 05:04:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:52210 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390380AbfJWJEV (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 23 Oct 2019 05:04:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4FDFFB365;
        Wed, 23 Oct 2019 09:04:18 +0000 (UTC)
Date:   Wed, 23 Oct 2019 11:04:04 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Jessica Yu <jeyu@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, live-patching@vger.kernel.org,
        pmladek@suse.com
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
In-Reply-To: <20191022143107.xkymboxgcgojc5b5@treble>
Message-ID: <alpine.LSU.2.21.1910231057270.4266@pobox.suse.cz>
References: <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz> <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com> <20191015153120.GA21580@linux-8ccs> <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com> <20191015182705.1aeec284@gandalf.local.home>
 <20191016074951.GM2328@hirez.programming.kicks-ass.net> <alpine.LSU.2.21.1910161216100.7750@pobox.suse.cz> <alpine.LSU.2.21.1910161521010.7750@pobox.suse.cz> <20191018130342.GA4625@linux-8ccs> <alpine.LSU.2.21.1910221022590.28918@pobox.suse.cz>
 <20191022143107.xkymboxgcgojc5b5@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 22 Oct 2019, Josh Poimboeuf wrote:

> On Tue, Oct 22, 2019 at 10:27:49AM +0200, Miroslav Benes wrote:
> > > Does that sound like what you had in mind or am I totally off?
> > 
> > Sort of. What I had in mind was that we could get rid of all special .klp 
> > ELF section if module loader guarantees that only sections for loaded 
> > modules are processed. Then .klp.rela.$objname is not needed and proper 
> > .rela.text.$objname (or whatever its text section is named) should be 
> > sufficient. The same for the rest (.klp.arch).
> 
> If I understand correctly, using kvm as an example to-be-patched module,
> we'd have:
> 
>   .text.kvm
>   .rela.text.kvm
>   .altinstructions.kvm
>   .rela.altinstructions.kvm
>   __jump_table.kvm
>   .rela__jump_table.kvm
> 
> etc.  i.e. any "special" sections would need to be renamed.
> 
> Is that right?

Yes.
 
> But also I think *any* sections which need relocations would need to be
> renamed, for example:
> 
>   .rodata.kvm
>   .rela.rodata.kvm
>   .orc_unwind_ip.kvm
>   .rela.orc_unwind_ip.kvm

Correct.
 
> It's an interesting idea.
> 
> We'd have to be careful about ordering issues.  For example, there are
> module-specific jump labels stored in mod->jump_entries.  Right now
> that's just a pointer to the module's __jump_table section.  With late
> module patching, when kvm is loaded we'd have to insert the klp module's
> __jump_table.kvm entries into kvm's mod->jump_entries list somehow.

Yes.
 
> Presumably we'd also have that issue for other sections.  Handling that
> _might_ be as simple as just hacking up find_module_sections() to
> re-allocate sections and append "patched sections" to them.
>
> But then you still have to worry about when to apply the relocations.
> If you apply them before patching the sections, then relative
> relocations would have the wrong values.  If you apply them after, then
> you have to figure out where the appended relocations are.

Ah, right. That is a valid remark.
 
> And if we allow unpatching then we'd presumably have to be able to
> remove entries from the module specific section lists.

Correct.

> So I get the feeling a lot of complexity would creep in.  Even just
> thinking about it requires more mental gymnastics than the
> one-patch-per-module idea, so I view that as a bad sign.

Yes, the devil is in the details. It would be better if the approach 
helped even someone/something else in the kernel. Without it, it is 
probably better to stick to Steven's proposal and handle the complexity 
elsewhere.

Thanks
Miroslav
