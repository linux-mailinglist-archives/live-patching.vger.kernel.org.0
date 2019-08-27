Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD7E99EF15
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2019 17:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfH0Ph5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 27 Aug 2019 11:37:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58596 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727219AbfH0Ph5 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 27 Aug 2019 11:37:57 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AF1442A09A5;
        Tue, 27 Aug 2019 15:37:56 +0000 (UTC)
Received: from treble (ovpn-121-55.rdu2.redhat.com [10.10.121.55])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E942A5D6B0;
        Tue, 27 Aug 2019 15:37:52 +0000 (UTC)
Date:   Tue, 27 Aug 2019 10:37:48 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>, jikos@kernel.org,
        Miroslav Benes <mbenes@suse.cz>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190827153748.i7at4wysu5v5k5aw@treble>
References: <20190719122840.15353-1-mbenes@suse.cz>
 <20190719122840.15353-3-mbenes@suse.cz>
 <20190728200427.dbrojgu7hafphia7@treble>
 <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz>
 <20190814151244.5xoaxib5iya2qjco@treble>
 <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
 <20190822223649.ptg6e7qyvosrljqx@treble>
 <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz>
 <20190826145449.wyo7avwpqyriem46@treble>
 <5efd9f4e-eccb-cbe0-ec2e-0e2a6a34c0ea@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5efd9f4e-eccb-cbe0-ec2e-0e2a6a34c0ea@redhat.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 27 Aug 2019 15:37:56 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Aug 27, 2019 at 11:05:51AM -0400, Joe Lawrence wrote:
> > Sure, it introduces risk.  But we have to compare that risk (which only
> > affects rare edge cases) with the ones introduced by the late module
> > patching code.  I get the feeling that "late module patching" introduces
> > risk to a broader range of use cases than "occasional loading of unused
> > modules".
> > 
> > The latter risk could be minimized by introducing a disabled state for
> > modules - load it in memory, but don't expose it to users until
> > explicitly loaded.  Just a brainstormed idea; not sure whether it would
> > work in practice.
> > 
> 
> Interesting idea.  We would need to ensure consistency between the
> loaded-but-not-enabled module and the version on disk.  Does module init run
> when it's enabled?  Etc.

I don't think there can be a mismatch unless somebody is mucking with
the .ko files directly -- and anyway that would already be a problem
today, because the patch module already assumes that the runtime version
of the module matches what the patch module was built against.

> <blue sky ideas>
> 
> What about folding this the other way?  ie, if a livepatch targets unloaded
> module foo, loaded module bar, and vmlinux ... it effectively patches bar
> and vmlinux, but the foo changes are dropped. Responsibility is placed on
> the admin to install an updated foo before loading it (in which case,
> livepatching core will again ignore foo.)
> 
> Building on this idea, perhaps loading that livepatch would also blacklist
> specific, known vulnerable (unloaded) module versions.  If the admin tries
> to load one, a debug msg is generated explaining why it can't be loaded by
> default.
> 
> </blue sky ideas>

I like this.

One potential tweak: the updated modules could be delivered with the
patch module, and either replaced on disk or otherwise hooked into
modprobe.

> > > > >    + It might open more security holes that are not fixed by
> > > > >      the livepatch.
> > > > 
> > > > Following the same line of thinking, the livepatch infrastructure might
> > > > open security holes because of the inherent complexity of late module
> > > > patching.
> > > 
> > > Could you be more specific, please?
> > > Has there been any known security hole in the late module
> > > livepatching code?
> > 
> > Just off the top of my head, I can think of two recent bugs which can be
> > blamed on late module patching:
> > 
> > 1) There was a RHEL-only bug which caused arch_klp_init_object_loaded()
> >     to not be loaded.  This resulted in a panic when certain patched code
> >     was executed.
> > 
> > 2) arch_klp_init_object_loaded() currently doesn't have any jump label
> >     specific code.  This has recently caused panics for patched code
> >     which relies on static keys.  The workaround is to not use jump
> >     labels in patched code.  The real fix is to add support for them in
> >     arch_klp_init_object_loaded().
> > 
> > I can easily foresee more problems like those in the future.  Going
> > forward we have to always keep track of which special sections are
> > needed for which architectures.  Those special sections can change over
> > time, or can simply be overlooked for a given architecture.  It's
> > fragile.
> 
> FWIW, the static keys case is more involved than simple deferred relocations
> -- those keys are added to lists and then the static key code futzes with
> them when it needs to update code sites.  That means the code managing the
> data structures, kernel/jump_label.c, will need to understand livepatch's
> strangely loaded-but-not-initialized variants.
> 
> I don't think the other special sections will require such invasive changes,
> but it's something to keep in mind with respect to late module patching.

Maybe it could be implemented in a way that such differences are
transparent (insert lots of hand-waving).

So as far as I can tell, we currently have three feasible options:

1) drop unloaded module changes (and blacklist the old .ko and/or replace it)
2) use per-object patches (with no exported function changes)
3) half-load unloaded modules so we can patch them

I think I like #1, if we could figure out a simple way to do it.

-- 
Josh
