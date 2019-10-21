Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93956DF198
	for <lists+live-patching@lfdr.de>; Mon, 21 Oct 2019 17:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729473AbfJUPbl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Oct 2019 11:31:41 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:22167 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729377AbfJUPbl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Oct 2019 11:31:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571671899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3qdocgmdUHdqZl7Kfo7MiqDFe0rPwq+g9dSPJrCbOR4=;
        b=eW8YSRLUYdIqJ61sXdQh4dqjl7BZlOUY+vGhDEe+LeQLoROk0TBkN9kFbOoSQJsu9WBQDi
        JcJp4f4vgUoAtNFzaznxCtVHiFCzAG6uHj4nf3STEdm+4cyNPAO6zb34LG71olpo21T5Wq
        4xu6DGrWwyLHPqBgCH6U6EQUOt5VZhE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-VSz7me16NQGt3sdnTvIYmw-1; Mon, 21 Oct 2019 11:31:36 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DFF51005500;
        Mon, 21 Oct 2019 15:31:19 +0000 (UTC)
Received: from treble (ovpn-123-96.rdu2.redhat.com [10.10.123.96])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 51DBB60C5D;
        Mon, 21 Oct 2019 15:31:04 +0000 (UTC)
Date:   Mon, 21 Oct 2019 10:31:01 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jessica Yu <jeyu@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
Message-ID: <20191021153101.y6ik56564er6jra5@treble>
References: <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz>
 <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
 <20191015153120.GA21580@linux-8ccs>
 <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
 <20191015182705.1aeec284@gandalf.local.home>
 <20191016074951.GM2328@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.1910161216100.7750@pobox.suse.cz>
 <alpine.LSU.2.21.1910161521010.7750@pobox.suse.cz>
 <20191018130342.GA4625@linux-8ccs>
 <20191018134058.7zyls4746wpa7jy5@pathway.suse.cz>
MIME-Version: 1.0
In-Reply-To: <20191018134058.7zyls4746wpa7jy5@pathway.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: VSz7me16NQGt3sdnTvIYmw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Oct 18, 2019 at 03:40:58PM +0200, Petr Mladek wrote:
> On Fri 2019-10-18 15:03:42, Jessica Yu wrote:
> > +++ Miroslav Benes [16/10/19 15:29 +0200]:
> > > On Wed, 16 Oct 2019, Miroslav Benes wrote:
> > > Thinking about it more... crazy idea. I think we could leverage these=
 new
> > > ELF .text per vmlinux/module sections for the reinvention I was talki=
ng
> > > about. If we teach module loader to relocate (and apply alternatives =
and
> > > so on, everything in arch-specific module_finalize()) not the whole m=
odule
> > > in case of live patch modules, but separate ELF .text sections, it co=
uld
> > > solve the issue with late module patching we have. It is a variation =
on
> > > Steven's idea. When live patch module is loaded, only its section for
> > > present modules would be processed. Then whenever a to-be-patched mod=
ule
> > > is loaded, its .text section in all present patch module would be
> > > processed.
> > >=20
> > > The upside is that almost no work would be required on patch modules
> > > creation side. The downside is that klp_modinfo must stay. Module loa=
der
> > > needs to be hacked a lot in both cases. So it remains to be seen whic=
h
> > > idea is easier to implement.
> > >=20
> > > Jessica, do you think it would be feasible?
> >=20
> > I think that does sound feasible. I'm trying to visualize how that
> > would look. I guess there would need to be various livepatching hooks
> > called during the different stages (apply_relocate_add(),
> > module_finalize(), module_enable_ro/x()).
> >=20
> > So maybe something like the following?
> >=20
> > When a livepatch module loads:
> >    apply_relocate_add()
> >        klp hook: apply .klp.rela.$objname relocations *only* for
> >        already loaded modules
> >    module_finalize()
> >        klp hook: apply .klp.arch.$objname changes for already loaded mo=
dules
> >    module_enable_ro()
> >        klp hook: only enable ro/x for .klp.text.$objname for already
> >        loaded modules
>=20
> Just for record. We should also set ro for the not-yet used
> .klp.text.$objname at this stage so that it can't be modified
> easily "by accident".
>=20
>=20
> > When a to-be-patched module loads:
> >    apply_relocate_add()
> >        klp hook: for each patch module that patches the coming
> >        module, apply .klp.rela.$objname relocations for this object
> >    module_finalize()
> >        klp hook: for each patch module that patches the coming
> >        module, apply .klp.arch.$objname changes for this object
> >    module_enable_ro()
> >        klp hook: for each patch module, apply ro/x permissions for
> >        .klp.text.$objname for this object
> >=20
> > Then, in klp_module_coming, we only need to do the callbacks and
> > enable the patch, and get rid of the module_disable_ro->apply
> > relocs->module_enable_ro block.
> >=20
> > Does that sound like what you had in mind or am I totally off?
>=20
> Makes sense to me.
>=20
> Well, I wonder if it is really any better from what we have now.

AFAICT, this would still have a lot of the same problems we have today.
It has a lot of complexity.  It needs arch-specific livepatch code and
sections, and introduces special cases in the module code.

I'd much prefer the proposal from LPC to have per-module live patches.
It's simpler and has less things that can go wrong IMO.

--=20
Josh

