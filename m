Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB439D200
	for <lists+live-patching@lfdr.de>; Mon, 26 Aug 2019 16:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbfHZOyz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 26 Aug 2019 10:54:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727692AbfHZOyz (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 26 Aug 2019 10:54:55 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A937F3082E61;
        Mon, 26 Aug 2019 14:54:54 +0000 (UTC)
Received: from treble (ovpn-121-55.rdu2.redhat.com [10.10.121.55])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 120D260925;
        Mon, 26 Aug 2019 14:54:50 +0000 (UTC)
Date:   Mon, 26 Aug 2019 09:54:49 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     jikos@kernel.org, joe.lawrence@redhat.com,
        Miroslav Benes <mbenes@suse.cz>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190826145449.wyo7avwpqyriem46@treble>
References: <20190719122840.15353-1-mbenes@suse.cz>
 <20190719122840.15353-3-mbenes@suse.cz>
 <20190728200427.dbrojgu7hafphia7@treble>
 <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz>
 <20190814151244.5xoaxib5iya2qjco@treble>
 <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
 <20190822223649.ptg6e7qyvosrljqx@treble>
 <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 26 Aug 2019 14:54:54 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Aug 23, 2019 at 10:13:06AM +0200, Petr Mladek wrote:
> On Thu 2019-08-22 17:36:49, Josh Poimboeuf wrote:
> > On Fri, Aug 16, 2019 at 11:46:08AM +0200, Petr Mladek wrote:
> > > On Wed 2019-08-14 10:12:44, Josh Poimboeuf wrote:
> > > > On Wed, Aug 14, 2019 at 01:06:09PM +0200, Miroslav Benes wrote:
> > > > > > Really, we should be going in the opposite direction, by creating module
> > > > > > dependencies, like all other kernel modules do, ensuring that a module
> > > > > > is loaded *before* we patch it.  That would also eliminate this bug.
> > > > 
> > > > We should look at whether it makes sense to destabilize live patching
> > > > for everybody, for a small minority of people who care about a small
> > > > minority of edge cases.
> > > 
> > > I do not see it that simple. Forcing livepatched modules to be
> > > loaded would mean loading "random" new modules when updating
> > > livepatches:
> > 
> > I don't want to start a long debate on this, because this idea isn't
> > even my first choice.  But we shouldn't dismiss it outright.
> 
> I am glad to hear that this is not your first choice.
> 
> 
> > >   + It means more actions and higher risk to destabilize
> > >     the system. Different modules have different quality.
> > 
> > Maybe the distro shouldn't ship modules which would destabilize the
> > system.
> 
> Is this realistic? Even the best QA could not check all scenarios.
> My point is that the more actions we do the bigger the risk is.

Sure, it introduces risk.  But we have to compare that risk (which only
affects rare edge cases) with the ones introduced by the late module
patching code.  I get the feeling that "late module patching" introduces
risk to a broader range of use cases than "occasional loading of unused
modules".

The latter risk could be minimized by introducing a disabled state for
modules - load it in memory, but don't expose it to users until
explicitly loaded.  Just a brainstormed idea; not sure whether it would
work in practice.

> Anyway, this approach might cause loading modules that are never
> or rarely loaded together. Real life systems have limited number of
> peripherals.
> 
> I wonder if it might actually break certification of some
> hardware. It is just an idea. I do not know how certifications
> are done and what is the scope or limits.
> 
> 
> > >   + It might open more security holes that are not fixed by
> > >     the livepatch.
> > 
> > Following the same line of thinking, the livepatch infrastructure might
> > open security holes because of the inherent complexity of late module
> > patching.
> 
> Could you be more specific, please?
> Has there been any known security hole in the late module
> livepatching code?

Just off the top of my head, I can think of two recent bugs which can be
blamed on late module patching:

1) There was a RHEL-only bug which caused arch_klp_init_object_loaded()
   to not be loaded.  This resulted in a panic when certain patched code
   was executed.

2) arch_klp_init_object_loaded() currently doesn't have any jump label
   specific code.  This has recently caused panics for patched code
   which relies on static keys.  The workaround is to not use jump
   labels in patched code.  The real fix is to add support for them in
   arch_klp_init_object_loaded().

I can easily foresee more problems like those in the future.  Going
forward we have to always keep track of which special sections are
needed for which architectures.  Those special sections can change over
time, or can simply be overlooked for a given architecture.  It's
fragile.

Not to mention that most of the bugs we've fixed over the years seem to
be related to klp_init_object_loaded() and klp_module_coming/going().
I would expect that to continue given the hackish nature of late module
loading.  With live patching, almost any bug can be a security bug.


> > >   + It might require some extra configuration actions to handle
> > >     the newly opened interfaces (devices). For example, updating
> > >     SELinux policies.
> > 
> > I assume you mean user-created policies, not distro ones?  Is this even
> > a realistic concern?
> 
> Honestly, I do not know. I am not familiar with this area. There are
> also containers. They are going to be everywhere. They also need a lot
> of rules to keep stuff separated. And it is another area where I have
> no idea if newly loaded and unexpectedly modules might need special
> handling.
> 
> 
> > >   + Are there conflicting modules that might need to get
> > >     livepatched?
> > 
> > Again is this realistic?
> 
> I do not know. But I could imagine it.
> 
> 
> > > This approach has a strong no-go from my side.
> > 
> > </devils-advocate>
> > 
> > I agree it's not ideal, but nothing is ideal at this point.  Let's not
> > to rule it out prematurely.  I do feel that our current approach is not
> > the best.  It will continue to create problems for us until we fix it.
> 
> I am sure that we could do better. I just think that forcibly loading
> modules is opening too huge can of worms. Basically all other
> approaches have more limited or better defined effects.
> 
> For example, the newly added code that clears the relocations
> is something that can be tested. Behavior of "random" mix of
> loaded modules opens possibilities that have never been
> discovered before.

I'd just ask that you not be so quick to shut down ideas.  Ideas can be
iterated.  If you're sure we can do better, propose something better.
Shooting down ideas without trying to improve them (or find better ones)
doesn't help.

Our late module patching architecture is too fragile to be acceptable.
It's time to find something better.

> > > > - Changing 'atomic replace' to allow patch modules to be per-object.
> > > 
> > > The problem might be how to transition all loaded objects atomically
> > > when the needed code is loaded from different modules.
> > 
> > I'm not sure what you mean.
> > 
> > My idea was that each patch module would be specific to an object, with
> > no inter-module change dependencies.  So when using atomic replace, if
> > the patch module is only targeted to vmlinux, then only vmlinux-targeted
> > patch modules would be replaced.
> > 
> > In other words, 'atomic replace' would be object-specific.
> > 
> > > Alternative would be to support only per-object consitency. But it
> > > might reduce the number of supported scenarios too much. Also it
> > > would make livepatching more error-prone.
> 
> By per-object consistency I mean the same as you with "each patch
> module would be specific to an object, with no inter-module change
> dependencies".
> 
> My concern is that it would prevent semantic changes in a shared code.
> Semantic changes are rare. But changes in shared code are not.
> 
> If we reduce the consistency to per-object consistency. Will the
> consistency still make sense then? We might want to go back to
> trees, I mean immediate mode.

I still don't follow your logic.  Why wouldn't per-object consistency
make sense?  Most patches are per-object anyway.

We just have to make sure not to change exported interfaces.  (But
that's already an issue for our distros anyway because of kABI.)

-- 
Josh
