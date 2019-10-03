Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870F2C9A98
	for <lists+live-patching@lfdr.de>; Thu,  3 Oct 2019 11:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbfJCJSB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Oct 2019 05:18:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:54936 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728767AbfJCJSB (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Oct 2019 05:18:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E74DBAD73;
        Thu,  3 Oct 2019 09:17:59 +0000 (UTC)
Date:   Thu, 3 Oct 2019 11:17:35 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
        nstange@suse.de, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/3] livepatch: Clear relocation targets on a
 module removal
In-Reply-To: <20191002181817.xpiqiisg5ybtwhru@treble>
Message-ID: <alpine.LSU.2.21.1910031110440.9011@pobox.suse.cz>
References: <20190905124514.8944-1-mbenes@suse.cz> <20190905124514.8944-2-mbenes@suse.cz> <20191002181817.xpiqiisg5ybtwhru@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 2 Oct 2019, Josh Poimboeuf wrote:

> On Thu, Sep 05, 2019 at 02:45:12PM +0200, Miroslav Benes wrote:
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
> > 
> > Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> 
> Since we decided to fix late module patching at LPC, the commit message
> and clear_relocate_add() should both probably clarify that these
> functions are hacks which are relatively temporary, until we fix the
> root cause.

It was the plan, but thanks for pointing it out explicitly. I could 
forget.
 
> But this patch gives me a bad feeling :-/  Not that I have a better
> idea.

I know what you are talking about.

> Has anybody seen this problem in the real world?  If not, maybe we'd be
> better off just pretending the problem doesn't exist for now.

I don't think so. You reported the issue originally and I guess it 
happened during the testing. Then there is a report from Huawei, but it 
suggests testing environment too. Reloading modules seems artificial to 
me.

So I agree, we can pretend the issue does not exist and wait for the real 
solution.

Miroslav
