Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF4899A30D
	for <lists+live-patching@lfdr.de>; Fri, 23 Aug 2019 00:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391114AbfHVWgz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 22 Aug 2019 18:36:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35878 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391054AbfHVWgz (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 22 Aug 2019 18:36:55 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC31D3083392;
        Thu, 22 Aug 2019 22:36:54 +0000 (UTC)
Received: from treble (ovpn-121-55.rdu2.redhat.com [10.10.121.55])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 873906DA80;
        Thu, 22 Aug 2019 22:36:51 +0000 (UTC)
Date:   Thu, 22 Aug 2019 17:36:49 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, jikos@kernel.org,
        joe.lawrence@redhat.com, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190822223649.ptg6e7qyvosrljqx@treble>
References: <20190719122840.15353-1-mbenes@suse.cz>
 <20190719122840.15353-3-mbenes@suse.cz>
 <20190728200427.dbrojgu7hafphia7@treble>
 <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz>
 <20190814151244.5xoaxib5iya2qjco@treble>
 <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Thu, 22 Aug 2019 22:36:55 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Aug 16, 2019 at 11:46:08AM +0200, Petr Mladek wrote:
> On Wed 2019-08-14 10:12:44, Josh Poimboeuf wrote:
> > On Wed, Aug 14, 2019 at 01:06:09PM +0200, Miroslav Benes wrote:
> > > > Really, we should be going in the opposite direction, by creating module
> > > > dependencies, like all other kernel modules do, ensuring that a module
> > > > is loaded *before* we patch it.  That would also eliminate this bug.
> > > 
> > > Yes, but it is not ideal either with cumulative one-fixes-all patch 
> > > modules. It would load also modules which are not necessary for a 
> > > customer and I know that at least some customers care about this. They 
> > > want to deploy only things which are crucial for their systems.
> > 
> > If you frame the question as "do you want to destabilize the live
> > patching infrastucture" then the answer might be different.
> > 
> > We should look at whether it makes sense to destabilize live patching
> > for everybody, for a small minority of people who care about a small
> > minority of edge cases.
> 
> I do not see it that simple. Forcing livepatched modules to be
> loaded would mean loading "random" new modules when updating
> livepatches:

I don't want to start a long debate on this, because this idea isn't
even my first choice.  But we shouldn't dismiss it outright.

<devils-advocate>

>   + It means more actions and higher risk to destabilize
>     the system. Different modules have different quality.

Maybe the distro shouldn't ship modules which would destabilize the
system.

>   + It might open more security holes that are not fixed by
>     the livepatch.

Following the same line of thinking, the livepatch infrastructure might
open security holes because of the inherent complexity of late module
patching.

>   + It might require some extra configuration actions to handle
>     the newly opened interfaces (devices). For example, updating
>     SELinux policies.

I assume you mean user-created policies, not distro ones?  Is this even
a realistic concern?

>   + Are there conflicting modules that might need to get
>     livepatched?

Again is this realistic?

> This approach has a strong no-go from my side.

</devils-advocate>

I agree it's not ideal, but nothing is ideal at this point.  Let's not
to rule it out prematurely.  I do feel that our current approach is not
the best.  It will continue to create problems for us until we fix it.

>
> > Or maybe there's some other solution we haven't thought about, which
> > fits more in the framework of how kernel modules already work.
> >
> > > We could split patch modules as you proposed in the past, but that have 
> > > issues as well.
> 
> > Right, I'm not really crazy about that solution either.
> 
> Yes, this would just move the problem somewhere else.
> 
> 
> > Here's another idea: per-object patch modules.  Patches to vmlinux are
> > in a vmlinux patch module.  Patches to kvm.ko are in a kvm patch module.
> > That would require:
> > 
> > - Careful management of dependencies between object-specific patches.
> >   Maybe that just means that exported function ABIs shouldn't change.
> > 
> > - Some kind of hooking into modprobe to ensure the patch module gets
> >   loaded with the real one.
> 
> I see this just as a particular approach how to split livepatches
> per-object. The above points suggest how to handle dependencies
> on the kernel side.

Yes, they would need to be done on the distro / patch creation /
operational side.  They probably wouldn't affect livepatch code.

> > - Changing 'atomic replace' to allow patch modules to be per-object.
> 
> The problem might be how to transition all loaded objects atomically
> when the needed code is loaded from different modules.

I'm not sure what you mean.

My idea was that each patch module would be specific to an object, with
no inter-module change dependencies.  So when using atomic replace, if
the patch module is only targeted to vmlinux, then only vmlinux-targeted
patch modules would be replaced.

In other words, 'atomic replace' would be object-specific.

> Alternative would be to support only per-object consitency. But it
> might reduce the number of supported scenarios too much. Also it
> would make livepatching more error-prone.

Again, I don't follow.

-- 
Josh
