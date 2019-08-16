Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 496AE8FF56
	for <lists+live-patching@lfdr.de>; Fri, 16 Aug 2019 11:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfHPJqP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Aug 2019 05:46:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:34290 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726839AbfHPJqO (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Aug 2019 05:46:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C33F5B64A;
        Fri, 16 Aug 2019 09:46:12 +0000 (UTC)
Date:   Fri, 16 Aug 2019 11:46:08 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, jikos@kernel.org,
        joe.lawrence@redhat.com, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
References: <20190719122840.15353-1-mbenes@suse.cz>
 <20190719122840.15353-3-mbenes@suse.cz>
 <20190728200427.dbrojgu7hafphia7@treble>
 <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz>
 <20190814151244.5xoaxib5iya2qjco@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814151244.5xoaxib5iya2qjco@treble>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2019-08-14 10:12:44, Josh Poimboeuf wrote:
> On Wed, Aug 14, 2019 at 01:06:09PM +0200, Miroslav Benes wrote:
> > > Really, we should be going in the opposite direction, by creating module
> > > dependencies, like all other kernel modules do, ensuring that a module
> > > is loaded *before* we patch it.  That would also eliminate this bug.
> > 
> > Yes, but it is not ideal either with cumulative one-fixes-all patch 
> > modules. It would load also modules which are not necessary for a 
> > customer and I know that at least some customers care about this. They 
> > want to deploy only things which are crucial for their systems.
> 
> If you frame the question as "do you want to destabilize the live
> patching infrastucture" then the answer might be different.
> 
> We should look at whether it makes sense to destabilize live patching
> for everybody, for a small minority of people who care about a small
> minority of edge cases.

I do not see it that simple. Forcing livepatched modules to be
loaded would mean loading "random" new modules when updating
livepatches:

  + It means more actions and higher risk to destabilize
    the system. Different modules have different quality.

  + It might open more security holes that are not fixed by
    the livepatch.

  + It might require some extra configuration actions to handle
    the newly opened interfaces (devices). For example, updating
    SELinux policies.

  + Are there conflicting modules that might need to get
    livepatched?

This approach has a strong no-go from my side.


> Or maybe there's some other solution we haven't thought about, which
> fits more in the framework of how kernel modules already work.
>
> > We could split patch modules as you proposed in the past, but that have 
> > issues as well.

> Right, I'm not really crazy about that solution either.

Yes, this would just move the problem somewhere else.


> Here's another idea: per-object patch modules.  Patches to vmlinux are
> in a vmlinux patch module.  Patches to kvm.ko are in a kvm patch module.
> That would require:
> 
> - Careful management of dependencies between object-specific patches.
>   Maybe that just means that exported function ABIs shouldn't change.
> 
> - Some kind of hooking into modprobe to ensure the patch module gets
>   loaded with the real one.

I see this just as a particular approach how to split livepatches
per-object. The above points suggest how to handle dependencies
on the kernel side.

> - Changing 'atomic replace' to allow patch modules to be per-object.

The problem might be how to transition all loaded objects atomically
when the needed code is loaded from different modules.

Alternative would be to support only per-object consitency. But it
might reduce the number of supported scenarios too much. Also it
would make livepatching more error-prone.


I would like to see updated variant of this patch to see how much
arch-specific code is really necessary.

IMHO, if reverting relocations is too complicated then the least painful
compromise is to "deny the patched modules to be removed".

> > Anyway, that is why I proposed "Rethinking late module patching" talk at 
> > LPC and we should try to come up with a solution there.
>
> Thanks, I saw that.  It's definitely worthy of more discussion.  The
> talk may be more productive if there were code to look at.  For example,
> a patch which removes all the "late module patching" gunk, so we can at
> least quantify the cost of the current approach.

+1

Best Regards,
Petr
