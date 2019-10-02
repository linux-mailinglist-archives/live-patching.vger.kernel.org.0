Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06663C90A3
	for <lists+live-patching@lfdr.de>; Wed,  2 Oct 2019 20:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfJBSSX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Oct 2019 14:18:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50130 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbfJBSSX (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Oct 2019 14:18:23 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BBDAD18CB8F3;
        Wed,  2 Oct 2019 18:18:22 +0000 (UTC)
Received: from treble (ovpn-121-106.rdu2.redhat.com [10.10.121.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A00160A97;
        Wed,  2 Oct 2019 18:18:19 +0000 (UTC)
Date:   Wed, 2 Oct 2019 13:18:17 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
        nstange@suse.de, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/3] livepatch: Clear relocation targets on a
 module removal
Message-ID: <20191002181817.xpiqiisg5ybtwhru@treble>
References: <20190905124514.8944-1-mbenes@suse.cz>
 <20190905124514.8944-2-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190905124514.8944-2-mbenes@suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Wed, 02 Oct 2019 18:18:22 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Sep 05, 2019 at 02:45:12PM +0200, Miroslav Benes wrote:
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
> 
> Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>

Since we decided to fix late module patching at LPC, the commit message
and clear_relocate_add() should both probably clarify that these
functions are hacks which are relatively temporary, until we fix the
root cause.

But this patch gives me a bad feeling :-/  Not that I have a better
idea.

Has anybody seen this problem in the real world?  If not, maybe we'd be
better off just pretending the problem doesn't exist for now.

-- 
Josh
