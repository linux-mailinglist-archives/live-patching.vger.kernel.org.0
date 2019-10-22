Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4261EE0671
	for <lists+live-patching@lfdr.de>; Tue, 22 Oct 2019 16:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfJVObZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 22 Oct 2019 10:31:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47554 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726702AbfJVObZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 22 Oct 2019 10:31:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571754684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uQINK4WAab2a12o9SHlK/upMXG8ZGLD6Q9Wbn9V1iMw=;
        b=hH+8tRk9V1z6FMZbYVcThekFC9ViWQgz0MdULNXdgg3HTJMKlML4sywFdbVjWKn3gfXlhk
        dC/H5gVIS+1MzTBI4Jib50u+cm8Wxtnp1DqkDkv31U8af8FhC6tEkpmwfAohsrtH3whstb
        Yo0JU/fXzTZPBqU8/0RNYSKPAndM3Mw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-SjCmvh6LOxCAPrxBPRs7jQ-1; Tue, 22 Oct 2019 10:31:20 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 308C61005500;
        Tue, 22 Oct 2019 14:31:18 +0000 (UTC)
Received: from treble (ovpn-124-213.rdu2.redhat.com [10.10.124.213])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C6353608C0;
        Tue, 22 Oct 2019 14:31:09 +0000 (UTC)
Date:   Tue, 22 Oct 2019 09:31:07 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Jessica Yu <jeyu@kernel.org>,
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
Message-ID: <20191022143107.xkymboxgcgojc5b5@treble>
References: <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz>
 <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
 <20191015153120.GA21580@linux-8ccs>
 <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
 <20191015182705.1aeec284@gandalf.local.home>
 <20191016074951.GM2328@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.1910161216100.7750@pobox.suse.cz>
 <alpine.LSU.2.21.1910161521010.7750@pobox.suse.cz>
 <20191018130342.GA4625@linux-8ccs>
 <alpine.LSU.2.21.1910221022590.28918@pobox.suse.cz>
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.1910221022590.28918@pobox.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: SjCmvh6LOxCAPrxBPRs7jQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Oct 22, 2019 at 10:27:49AM +0200, Miroslav Benes wrote:
> > Does that sound like what you had in mind or am I totally off?
>=20
> Sort of. What I had in mind was that we could get rid of all special .klp=
=20
> ELF section if module loader guarantees that only sections for loaded=20
> modules are processed. Then .klp.rela.$objname is not needed and proper=
=20
> .rela.text.$objname (or whatever its text section is named) should be=20
> sufficient. The same for the rest (.klp.arch).

If I understand correctly, using kvm as an example to-be-patched module,
we'd have:

  .text.kvm
  .rela.text.kvm
  .altinstructions.kvm
  .rela.altinstructions.kvm
  __jump_table.kvm
  .rela__jump_table.kvm

etc.  i.e. any "special" sections would need to be renamed.

Is that right?

But also I think *any* sections which need relocations would need to be
renamed, for example:

  .rodata.kvm
  .rela.rodata.kvm
  .orc_unwind_ip.kvm
  .rela.orc_unwind_ip.kvm


It's an interesting idea.

We'd have to be careful about ordering issues.  For example, there are
module-specific jump labels stored in mod->jump_entries.  Right now
that's just a pointer to the module's __jump_table section.  With late
module patching, when kvm is loaded we'd have to insert the klp module's
__jump_table.kvm entries into kvm's mod->jump_entries list somehow.

Presumably we'd also have that issue for other sections.  Handling that
_might_ be as simple as just hacking up find_module_sections() to
re-allocate sections and append "patched sections" to them.

But then you still have to worry about when to apply the relocations.
If you apply them before patching the sections, then relative
relocations would have the wrong values.  If you apply them after, then
you have to figure out where the appended relocations are.

And if we allow unpatching then we'd presumably have to be able to
remove entries from the module specific section lists.

So I get the feeling a lot of complexity would creep in.  Even just
thinking about it requires more mental gymnastics than the
one-patch-per-module idea, so I view that as a bad sign.

--=20
Josh

