Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D834A8D1B2
	for <lists+live-patching@lfdr.de>; Wed, 14 Aug 2019 13:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfHNLGR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Aug 2019 07:06:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:33460 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725800AbfHNLGQ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Aug 2019 07:06:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F07B2AE5A;
        Wed, 14 Aug 2019 11:06:14 +0000 (UTC)
Date:   Wed, 14 Aug 2019 13:06:09 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <20190728200427.dbrojgu7hafphia7@treble>
Message-ID: <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz>
References: <20190719122840.15353-1-mbenes@suse.cz> <20190719122840.15353-3-mbenes@suse.cz> <20190728200427.dbrojgu7hafphia7@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun, 28 Jul 2019, Josh Poimboeuf wrote:

> On Fri, Jul 19, 2019 at 02:28:40PM +0200, Miroslav Benes wrote:
> > Josh reported a bug:
> > 
> >   When the object to be patched is a module, and that module is
> >   rmmod'ed and reloaded, it fails to load with:
> > 
> >   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > 
> >   The livepatch module has a relocation which references a symbol
> >   in the _previous_ loading of nfsd. When apply_relocate_add()
> >   tries to replace the old relocation with a new one, it sees that
> >   the previous one is nonzero and it errors out.
> > 
> >   On ppc64le, we have a similar issue:
> > 
> >   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
> >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > 
> > He also proposed three different solutions. We could remove the error
> > check in apply_relocate_add() introduced by commit eda9cec4c9a1
> > ("x86/module: Detect and skip invalid relocations"). However the check
> > is useful for detecting corrupted modules.
> > 
> > We could also deny the patched modules to be removed. If it proved to be
> > a major drawback for users, we could still implement a different
> > approach. The solution would also complicate the existing code a lot.
> > 
> > We thus decided to reverse the relocation patching (clear all relocation
> > targets on x86_64, or return back nops on powerpc). The solution is not
> > universal and is too much arch-specific, but it may prove to be simpler
> > in the end.
> 
> Thanks for the patch Miroslav.
> 
> However, I really don't like it.  All this extra convoluted
> arch-specific code, just so users can unload a patched module.

Yes, it is unfortunate.
 
> Remind me why we didn't do the "deny the patched modules to be removed"
> option?

Petr came with a couple of issues in the patch. Nothing unfixable, but it 
would complicate the code a bit, so we wanted to explore arch-specific 
approach first. I'll return to it, fix it and we'll see the outcome.

> Really, we should be going in the opposite direction, by creating module
> dependencies, like all other kernel modules do, ensuring that a module
> is loaded *before* we patch it.  That would also eliminate this bug.

Yes, but it is not ideal either with cumulative one-fixes-all patch 
modules. It would load also modules which are not necessary for a 
customer and I know that at least some customers care about this. They 
want to deploy only things which are crucial for their systems.

We could split patch modules as you proposed in the past, but that have 
issues as well.

Anyway, that is why I proposed "Rethinking late module patching" talk at 
LPC and we should try to come up with a solution there.

> And I think it would also help us remove a lot of nasty code, like the
> coming/going notifiers and the .klp.arch mess.  Which, BTW, seem to be
> the sources of most of our bugs...

Yes.

> Yes, there's the "but it's less flexible!" argument.  Does anybody
> really need the flexibility?  I strongly doubt it.  I would love to see
> an RFC patch which enforces that restriction, to see all the nasty code
> we could remove.  I would much rather live patching be stable than
> flexible.

I agree that unloading a module does not make sense much (famous last 
words), so we could try.

Miroslav
