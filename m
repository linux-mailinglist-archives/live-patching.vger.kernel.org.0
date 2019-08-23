Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1C39A9DD
	for <lists+live-patching@lfdr.de>; Fri, 23 Aug 2019 10:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733287AbfHWINJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 23 Aug 2019 04:13:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:41782 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730979AbfHWINJ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 23 Aug 2019 04:13:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E9547AE00;
        Fri, 23 Aug 2019 08:13:06 +0000 (UTC)
Date:   Fri, 23 Aug 2019 10:13:06 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     jikos@kernel.org, joe.lawrence@redhat.com,
        Miroslav Benes <mbenes@suse.cz>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz>
References: <20190719122840.15353-1-mbenes@suse.cz>
 <20190719122840.15353-3-mbenes@suse.cz>
 <20190728200427.dbrojgu7hafphia7@treble>
 <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz>
 <20190814151244.5xoaxib5iya2qjco@treble>
 <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
 <20190822223649.ptg6e7qyvosrljqx@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822223649.ptg6e7qyvosrljqx@treble>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2019-08-22 17:36:49, Josh Poimboeuf wrote:
> On Fri, Aug 16, 2019 at 11:46:08AM +0200, Petr Mladek wrote:
> > On Wed 2019-08-14 10:12:44, Josh Poimboeuf wrote:
> > > On Wed, Aug 14, 2019 at 01:06:09PM +0200, Miroslav Benes wrote:
> > > > > Really, we should be going in the opposite direction, by creating module
> > > > > dependencies, like all other kernel modules do, ensuring that a module
> > > > > is loaded *before* we patch it.  That would also eliminate this bug.
> > > 
> > > We should look at whether it makes sense to destabilize live patching
> > > for everybody, for a small minority of people who care about a small
> > > minority of edge cases.
> > 
> > I do not see it that simple. Forcing livepatched modules to be
> > loaded would mean loading "random" new modules when updating
> > livepatches:
> 
> I don't want to start a long debate on this, because this idea isn't
> even my first choice.  But we shouldn't dismiss it outright.

I am glad to hear that this is not your first choice.


> >   + It means more actions and higher risk to destabilize
> >     the system. Different modules have different quality.
> 
> Maybe the distro shouldn't ship modules which would destabilize the
> system.

Is this realistic? Even the best QA could not check all scenarios.
My point is that the more actions we do the bigger the risk is.

Anyway, this approach might cause loading modules that are never
or rarely loaded together. Real life systems have limited number of
peripherals.

I wonder if it might actually break certification of some
hardware. It is just an idea. I do not know how certifications
are done and what is the scope or limits.


> >   + It might open more security holes that are not fixed by
> >     the livepatch.
> 
> Following the same line of thinking, the livepatch infrastructure might
> open security holes because of the inherent complexity of late module
> patching.

Could you be more specific, please?
Has there been any known security hole in the late module
livepatching code?


> >   + It might require some extra configuration actions to handle
> >     the newly opened interfaces (devices). For example, updating
> >     SELinux policies.
> 
> I assume you mean user-created policies, not distro ones?  Is this even
> a realistic concern?

Honestly, I do not know. I am not familiar with this area. There are
also containers. They are going to be everywhere. They also need a lot
of rules to keep stuff separated. And it is another area where I have
no idea if newly loaded and unexpectedly modules might need special
handling.


> >   + Are there conflicting modules that might need to get
> >     livepatched?
> 
> Again is this realistic?

I do not know. But I could imagine it.


> > This approach has a strong no-go from my side.
> 
> </devils-advocate>
> 
> I agree it's not ideal, but nothing is ideal at this point.  Let's not
> to rule it out prematurely.  I do feel that our current approach is not
> the best.  It will continue to create problems for us until we fix it.

I am sure that we could do better. I just think that forcibly loading
modules is opening too huge can of worms. Basically all other
approaches have more limited or better defined effects.

For example, the newly added code that clears the relocations
is something that can be tested. Behavior of "random" mix of
loaded modules opens possibilities that have never been
discovered before.


> > > - Changing 'atomic replace' to allow patch modules to be per-object.
> > 
> > The problem might be how to transition all loaded objects atomically
> > when the needed code is loaded from different modules.
> 
> I'm not sure what you mean.
> 
> My idea was that each patch module would be specific to an object, with
> no inter-module change dependencies.  So when using atomic replace, if
> the patch module is only targeted to vmlinux, then only vmlinux-targeted
> patch modules would be replaced.
> 
> In other words, 'atomic replace' would be object-specific.
> 
> > Alternative would be to support only per-object consitency. But it
> > might reduce the number of supported scenarios too much. Also it
> > would make livepatching more error-prone.

By per-object consistency I mean the same as you with "each patch
module would be specific to an object, with no inter-module change
dependencies".

My concern is that it would prevent semantic changes in a shared code.
Semantic changes are rare. But changes in shared code are not.

If we reduce the consistency to per-object consistency. Will the
consistency still make sense then? We might want to go back to
trees, I mean immediate mode.

Best Regards,
Petr
