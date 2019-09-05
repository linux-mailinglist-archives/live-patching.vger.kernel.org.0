Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C76E2AA28C
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 14:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732583AbfIEMDv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Sep 2019 08:03:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:41912 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730872AbfIEMDu (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Sep 2019 08:03:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AC131AC8C;
        Thu,  5 Sep 2019 12:03:48 +0000 (UTC)
Date:   Thu, 5 Sep 2019 14:03:34 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>, jikos@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <20190905025055.36loaatxtkhdo4q5@treble>
Message-ID: <alpine.LSU.2.21.1909051355240.25712@pobox.suse.cz>
References: <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz> <20190814151244.5xoaxib5iya2qjco@treble> <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz> <20190822223649.ptg6e7qyvosrljqx@treble> <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz>
 <20190826145449.wyo7avwpqyriem46@treble> <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz> <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com> <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz> <20190904084932.gndrtewubqiaxmzy@pathway.suse.cz>
 <20190905025055.36loaatxtkhdo4q5@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 4 Sep 2019, Josh Poimboeuf wrote:

> On Wed, Sep 04, 2019 at 10:49:32AM +0200, Petr Mladek wrote:
> > On Tue 2019-09-03 15:02:34, Miroslav Benes wrote:
> > > On Mon, 2 Sep 2019, Joe Lawrence wrote:
> > > 
> > > > On 9/2/19 12:13 PM, Miroslav Benes wrote:
> > > > >> I can easily foresee more problems like those in the future.  Going
> > > > >> forward we have to always keep track of which special sections are
> > > > >> needed for which architectures.  Those special sections can change over
> > > > >> time, or can simply be overlooked for a given architecture.  It's
> > > > >> fragile.
> > > > > 
> > > > > Indeed. It bothers me a lot. Even x86 "port" is not feature complete in
> > > > > this regard (jump labels, alternatives,...) and who knows what lurks in
> > > > > the corners of the other architectures we support.
> > > > > 
> > > > > So it is in itself reason enough to do something about late module
> > > > > patching.
> > > > > 
> > > > 
> > > > Hi Miroslav,
> > > > 
> > > > I was tinkering with the "blue-sky" ideas that I mentioned to Josh the other
> > > > day.
> > > 
> > > > I dunno if you had a chance to look at what removing that code looks
> > > > like, but I can continue to flesh out that idea if it looks interesting:
> > > 
> > > Unfortunately no and I don't think I'll come up with something useful 
> > > before LPC, so anything is really welcome.
> > > 
> > > > 
> > > >   https://github.com/joe-lawrence/linux/tree/blue-sky
> > > > 
> > > > A full demo would require packaging up replacement .ko's with a livepatch, as
> > > > well as "blacklisting" those deprecated .kos, etc.  But that's all I had time
> > > > to cook up last week before our holiday weekend here.
> > > 
> > > Frankly, I'm not sure about this approach. I'm kind of torn. The current 
> > > solution is far from ideal, but I'm not excited about the other options 
> > > either. It seems like the choice is basically between "general but 
> > > technically complicated fragile solution with nontrivial maintenance 
> > > burden", or "something safer and maybe cleaner, but limiting for 
> > > users/distros". Of course it depends on whether the limitation is even 
> > > real and how big it is. Unfortunately we cannot quantify it much and that 
> > > is probably why our opinions (in the email thread) differ.
> > 
> > I wonder what is necessary for a productive discussion on Plumbers:
> > 
> >   + Josh would like to see what code can get removed when late
> >     handling of modules gets removed. I think that it might be
> >     partially visible from Joe's blue-sky patches.
> 
> Yes, and I like what I see.  Especially the removal of the .klp.arch
> nastiness!
> 
> >   + I would like to better understand the scope of the current
> >     problems. It is about modifying code in the livepatch that
> >     depends on position of the related code:
> > 
> >       + relocations are rather clear; we will need them anyway
> > 	to access non-public (static) API from the original code.
> > 
> >       + What are the other changes?
> 
> I think the .klp.arch sections are the big ones:
> 
>   .klp.arch.altinstructions
>   .klp.arch.parainstructions
>   .klp.arch.jump_labels (doesn't exist yet)
> 
> And that's just x86...

I may misunderstand, but we have .klp.arch sections because para and 
alternatives have to be processed after relocations. And if we cannot get 
rid of relocations completely, because of static symbols, then we cannot 
get rid of .klp.arch sections either.
 
> And then of course there's the klp coming/going notifiers which have
> also been an additional source of complexity.

True, but I think we (me and Petr) do not consider it as much of a problem 
as you.

> I'd like to hear more specific negatives about Joe's recent patches,
> which IMO, are the best option we've discussed so far.

I'll reply elsewhere...

Miroslav
