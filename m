Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C68313032
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2019 16:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfECO3F (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 3 May 2019 10:29:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37518 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbfECO3F (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 3 May 2019 10:29:05 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5063258599;
        Fri,  3 May 2019 14:29:04 +0000 (UTC)
Received: from redhat.com (dhcp-17-208.bos.redhat.com [10.18.17.208])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80E697BA09;
        Fri,  3 May 2019 14:29:02 +0000 (UTC)
Date:   Fri, 3 May 2019 10:29:00 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Jessica Yu <jeyu@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Joao Moreira <jmoreira@suse.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michael Matz <matz@suse.de>, Nicolai Stange <nstange@suse.de>,
        Petr Mladek <pmladek@suse.com>,
        Jason Baron <jbaron@akamai.com>,
        Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Subject: Re: [PATCH v3 0/9] klp-convert livepatch build tooling
Message-ID: <20190503142900.GB24094@redhat.com>
References: <20190412212654.GA21627@redhat.com>
 <alpine.LSU.2.21.1904161323230.17836@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1904161323230.17836@pobox.suse.cz>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 03 May 2019 14:29:04 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Apr 16, 2019 at 01:37:13PM +0200, Miroslav Benes wrote:
>
> [ ... snip ... ]
>
> Quick look, but it seems quite similar to the problem we had with
> apply_alternatives(). See arch/x86/kernel/livepatch.c and the commit which
> introduced it.

That was an interesting diversion :)  I think I grok the idea as:

The kernel supports a few different code-patching methods:

  - SMP locks
  - alternatives
  - paravirt
  - jump labels

and we need to ensure that they do not prematurely operate on unresolved
klp-relocations.  The solution that led to arch/x86/kernel/livepatch.c
introduces "klp.arch" sections that rename such klp-relocations *and*
their associated special section data structures.  Processing is then
deferred until after a relevant klp_object is loaded.

> I think, we should do the same for jump labels. Add
> jump_label_apply_nops() from module_finalize() to
> arch_klp_init_object_loaded() and convert jump_table ELF section so its
> processing is delayed.

Nod.  Tthat sounds about right.  There may be some more work yet in the
static keys API as well, but I'm not 100%.

> Which leads me another TODO... klp-convert does not convert even
> .altinstructions and .parainstructions sections, so it has that problem as
> well. If I remember, it was on Josh's TODO list when he first introduced
> klp-convert. See cover.1477578530.git.jpoimboe@redhat.com.

In the RFC, Josh highlights a somewhat difficult problem regarding these
special sections -- how to associate these special section data
structures and their relocations to a specific klp_object.

If I understand his suggestion, he proposed annotating livepatch module
replacement functions as to stuff them into specially named ELF sections
(which would include the klp_object name) and then bypass the existing
livepatch registration API.  No minor change.

With that in mind, I'm starting to think of a game plan for klp-convert
like:

  - phase 1: detect /abort unsupported sections

  - phase 2: manual annotations in livepatch modules (like
             KLP_MODULE_RELOC / SYMPOS, but for special sections) so
             that klp-convert can start building "klp.arch" sections

  - phase 3: livepatch API change above to support somewhat more
             automatic generation of phase 2 annotations

> The selftest for the alternatives would be appreciated too. One day.

In the course of understanding the background behind
arch/x86/kernel/livepatch.c, I wrote a bunch of livepatch selftests that
try out simple examples of those special sections.

For alternatives, I did something like:

  /* TODO: find reliably true/false features */
  #define TRUE_FEATURE	(X86_FEATURE_FPU)
  #define FALSE_FEATURE	(X86_FEATURE_VME)

  ...

  klp_function1()
  klp_function2()
  klp_new_function()

  	asm (ALTERNATIVE("call klp_function1", "call klp_function2", TRUE_FEATURE));
  	asm (ALTERNATIVE("call klp_function1", "call klp_function2", FALSE_FEATURE));

  	asm (ALTERNATIVE("call mod_function1", "call mod_function2", TRUE_FEATURE));
  	asm (ALTERNATIVE("call mod_function1", "call mod_function2", FALSE_FEATURE));
  	asm (ALTERNATIVE("call mod_function2", "call mod_function1", TRUE_FEATURE));
  	asm (ALTERNATIVE("call mod_function2", "call mod_function1", FALSE_FEATURE));

so that I could see what kind of relocations were generated for default
and non-default instructions as well as module-local and then
unexported-extern functions.

Once we have klp-convert supporting these conversions, I think something
like that would suffice.  In the meantime, I'm not sure how to create
"klp.arch" sectioned ELFs without something like kpatch-build.

> And of course we should look at the other supported architectures and
> their module_finalize() functions. I have it on my TODO list somewhere,
> but you know how it works with those :/. I am sure there are more hidden
> surprises there.

Hmm, well powerpc and s390 do appear to have processing for special
sections as well ... but for the moment, I'm going to focus on x86 as
that seems like enough work for now :)

> > Detection
> > ---------
> >
> > I can post ("livepatch/klp-convert: abort on static key conversion")
> > here as a follow commit if it looks reasonable and folks wish to review
> > it... or we can try and tackle static keys before merging klp-convert.
>
> Good idea. I'd rather fix it, but I think it could be a lot of work, so
> something like this patch seems to be a good idea.

I'm thinking of adding this in a commit so klp-convert can intercept
these sections:

  static bool is_section_supported(char *sname)
  {
          if (strcmp(sname, ".rela.altinstructions") == 0)
                  return false;
          if (strcmp(sname, ".rela.parainstructions") == 0)
                  return false;
          if (strcmp(sname, ".rela__jump_table") == 0)
                  return false;
          return true;
  }

Right now my v4 collection has a bunch of small fixups and nitpick
corrections.  It feels like a good resting place for now before
embarking on special section support, what do you think?

-- Joe
