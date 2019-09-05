Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 679B9A9893
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 04:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbfIECvB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 Sep 2019 22:51:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbfIECvA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 Sep 2019 22:51:00 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 56697C0578F8;
        Thu,  5 Sep 2019 02:51:00 +0000 (UTC)
Received: from treble (ovpn-121-98.rdu2.redhat.com [10.10.121.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 051B11001958;
        Thu,  5 Sep 2019 02:50:56 +0000 (UTC)
Date:   Wed, 4 Sep 2019 21:50:55 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>, jikos@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190905025055.36loaatxtkhdo4q5@treble>
References: <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz>
 <20190814151244.5xoaxib5iya2qjco@treble>
 <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
 <20190822223649.ptg6e7qyvosrljqx@treble>
 <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz>
 <20190826145449.wyo7avwpqyriem46@treble>
 <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz>
 <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com>
 <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz>
 <20190904084932.gndrtewubqiaxmzy@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190904084932.gndrtewubqiaxmzy@pathway.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 05 Sep 2019 02:51:00 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 04, 2019 at 10:49:32AM +0200, Petr Mladek wrote:
> On Tue 2019-09-03 15:02:34, Miroslav Benes wrote:
> > On Mon, 2 Sep 2019, Joe Lawrence wrote:
> > 
> > > On 9/2/19 12:13 PM, Miroslav Benes wrote:
> > > >> I can easily foresee more problems like those in the future.  Going
> > > >> forward we have to always keep track of which special sections are
> > > >> needed for which architectures.  Those special sections can change over
> > > >> time, or can simply be overlooked for a given architecture.  It's
> > > >> fragile.
> > > > 
> > > > Indeed. It bothers me a lot. Even x86 "port" is not feature complete in
> > > > this regard (jump labels, alternatives,...) and who knows what lurks in
> > > > the corners of the other architectures we support.
> > > > 
> > > > So it is in itself reason enough to do something about late module
> > > > patching.
> > > > 
> > > 
> > > Hi Miroslav,
> > > 
> > > I was tinkering with the "blue-sky" ideas that I mentioned to Josh the other
> > > day.
> > 
> > > I dunno if you had a chance to look at what removing that code looks
> > > like, but I can continue to flesh out that idea if it looks interesting:
> > 
> > Unfortunately no and I don't think I'll come up with something useful 
> > before LPC, so anything is really welcome.
> > 
> > > 
> > >   https://github.com/joe-lawrence/linux/tree/blue-sky
> > > 
> > > A full demo would require packaging up replacement .ko's with a livepatch, as
> > > well as "blacklisting" those deprecated .kos, etc.  But that's all I had time
> > > to cook up last week before our holiday weekend here.
> > 
> > Frankly, I'm not sure about this approach. I'm kind of torn. The current 
> > solution is far from ideal, but I'm not excited about the other options 
> > either. It seems like the choice is basically between "general but 
> > technically complicated fragile solution with nontrivial maintenance 
> > burden", or "something safer and maybe cleaner, but limiting for 
> > users/distros". Of course it depends on whether the limitation is even 
> > real and how big it is. Unfortunately we cannot quantify it much and that 
> > is probably why our opinions (in the email thread) differ.
> 
> I wonder what is necessary for a productive discussion on Plumbers:
> 
>   + Josh would like to see what code can get removed when late
>     handling of modules gets removed. I think that it might be
>     partially visible from Joe's blue-sky patches.

Yes, and I like what I see.  Especially the removal of the .klp.arch
nastiness!

>   + I would like to better understand the scope of the current
>     problems. It is about modifying code in the livepatch that
>     depends on position of the related code:
> 
>       + relocations are rather clear; we will need them anyway
> 	to access non-public (static) API from the original code.
> 
>       + What are the other changes?

I think the .klp.arch sections are the big ones:

  .klp.arch.altinstructions
  .klp.arch.parainstructions
  .klp.arch.jump_labels (doesn't exist yet)

And that's just x86...

And then of course there's the klp coming/going notifiers which have
also been an additional source of complexity.

>       + Do we use them in livepatches? How often?

I don't have a number, but it's very common to patch a function which
uses jump labels or alternatives.

>       + How often new problematic features appear?

I'm not exactly sure what you mean, but it seems that anytime we add a
new feature, we have to try to wrap our heads around how it interacts
with the weirdness of late module patching.

>       + Would be possible to detect potential problems, for example
> 	by comparing the code in the binary and in memory when
> 	the module is loaded the normal way?

Perhaps, though I assume this would be some out-of-band testing thing.

>       + Would be possible to reset the livepatch code in memory
> 	when the related module is unloaded and safe us half
> 	of the troubles?

Maybe, but I think that would solve a much lower percentage of our
troubles than half :-/

>     + It might be useful to prepare overview of the existing proposals
>       and agree on the positives and negatives. I am afraid that some
>       of them might depend on the customer base and
>       use cases. Sometimes we might not have enough information.
>       But it might be good to get on the same page where possible.

I think we've already done that for the existing proposals.  Maybe
Miroslav can summarize them at the LPC session.

>       Anyway, it might rule out some variants so that we could better
>       concentrate on the acceptable ones. Or come with yet another
>       proposal that would avoid the real blockers.

I'd like to hear more specific negatives about Joe's recent patches,
which IMO, are the best option we've discussed so far.

-- 
Josh
