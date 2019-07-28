Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 074D878161
	for <lists+live-patching@lfdr.de>; Sun, 28 Jul 2019 22:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfG1UEd (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 28 Jul 2019 16:04:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39462 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbfG1UEd (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sun, 28 Jul 2019 16:04:33 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CA0BA3082E44;
        Sun, 28 Jul 2019 20:04:32 +0000 (UTC)
Received: from treble (ovpn-120-102.rdu2.redhat.com [10.10.120.102])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C0C991001B17;
        Sun, 28 Jul 2019 20:04:29 +0000 (UTC)
Date:   Sun, 28 Jul 2019 15:04:28 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190728200427.dbrojgu7hafphia7@treble>
References: <20190719122840.15353-1-mbenes@suse.cz>
 <20190719122840.15353-3-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190719122840.15353-3-mbenes@suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Sun, 28 Jul 2019 20:04:32 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jul 19, 2019 at 02:28:40PM +0200, Miroslav Benes wrote:
> Josh reported a bug:
> 
>   When the object to be patched is a module, and that module is
>   rmmod'ed and reloaded, it fails to load with:
> 
>   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> 
>   The livepatch module has a relocation which references a symbol
>   in the _previous_ loading of nfsd. When apply_relocate_add()
>   tries to replace the old relocation with a new one, it sees that
>   the previous one is nonzero and it errors out.
> 
>   On ppc64le, we have a similar issue:
> 
>   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> 
> He also proposed three different solutions. We could remove the error
> check in apply_relocate_add() introduced by commit eda9cec4c9a1
> ("x86/module: Detect and skip invalid relocations"). However the check
> is useful for detecting corrupted modules.
> 
> We could also deny the patched modules to be removed. If it proved to be
> a major drawback for users, we could still implement a different
> approach. The solution would also complicate the existing code a lot.
> 
> We thus decided to reverse the relocation patching (clear all relocation
> targets on x86_64, or return back nops on powerpc). The solution is not
> universal and is too much arch-specific, but it may prove to be simpler
> in the end.

Thanks for the patch Miroslav.

However, I really don't like it.  All this extra convoluted
arch-specific code, just so users can unload a patched module.

Remind me why we didn't do the "deny the patched modules to be removed"
option?

Really, we should be going in the opposite direction, by creating module
dependencies, like all other kernel modules do, ensuring that a module
is loaded *before* we patch it.  That would also eliminate this bug.

And I think it would also help us remove a lot of nasty code, like the
coming/going notifiers and the .klp.arch mess.  Which, BTW, seem to be
the sources of most of our bugs...

Yes, there's the "but it's less flexible!" argument.  Does anybody
really need the flexibility?  I strongly doubt it.  I would love to see
an RFC patch which enforces that restriction, to see all the nasty code
we could remove.  I would much rather live patching be stable than
flexible.

-- 
Josh
