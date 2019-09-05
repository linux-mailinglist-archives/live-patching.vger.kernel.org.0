Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE50AAA0FE
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 13:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388250AbfIELKB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Sep 2019 07:10:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:49696 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732051AbfIELJ5 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Sep 2019 07:09:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A9FA2B6AD;
        Thu,  5 Sep 2019 11:09:55 +0000 (UTC)
Date:   Thu, 5 Sep 2019 13:09:55 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     jikos@kernel.org, Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190905110955.wl4lwjbnpqybhkcn@pathway.suse.cz>
References: <20190814151244.5xoaxib5iya2qjco@treble>
 <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
 <20190822223649.ptg6e7qyvosrljqx@treble>
 <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz>
 <20190826145449.wyo7avwpqyriem46@treble>
 <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz>
 <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com>
 <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz>
 <20190904084932.gndrtewubqiaxmzy@pathway.suse.cz>
 <20190905025055.36loaatxtkhdo4q5@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905025055.36loaatxtkhdo4q5@treble>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2019-09-04 21:50:55, Josh Poimboeuf wrote:
> On Wed, Sep 04, 2019 at 10:49:32AM +0200, Petr Mladek wrote:
> > I wonder what is necessary for a productive discussion on Plumbers:
> > 
> >   + Josh would like to see what code can get removed when late
> >     handling of modules gets removed. I think that it might be
> >     partially visible from Joe's blue-sky patches.
> 
> Yes, and I like what I see.  Especially the removal of the .klp.arch
> nastiness!

Could we get rid of it?

Is there any other way to get access to static variables
and functions from the livepatched code?

> I think the .klp.arch sections are the big ones:
> 
>   .klp.arch.altinstructions
>   .klp.arch.parainstructions
>   .klp.arch.jump_labels (doesn't exist yet)
> 
> And that's just x86...
> 
> And then of course there's the klp coming/going notifiers which have
> also been an additional source of complexity.
> 
> >       + Do we use them in livepatches? How often?
> 
> I don't have a number, but it's very common to patch a function which
> uses jump labels or alternatives.

Really? My impression is that both alternatives and jump_labels
are used in hot paths. I would expect them mostly in core code
that is always loaded.

Alternatives are often used in assembly that we are not able
to livepatch anyway.

Or are they spread widely via some macros or inlined functions?


> >       + How often new problematic features appear?
> 
> I'm not exactly sure what you mean, but it seems that anytime we add a
> new feature, we have to try to wrap our heads around how it interacts
> with the weirdness of late module patching.

I agree that we need to think about it and it makes complications.
Anyway, I think that these are never the biggest problems.

I would be more concerned about arch-specific features that might need
special handling in the livepatch code. Everyone talks only about
alternatives and jump_labels that were added long time ago.


> >       Anyway, it might rule out some variants so that we could better
> >       concentrate on the acceptable ones. Or come with yet another
> >       proposal that would avoid the real blockers.
> 
> I'd like to hear more specific negatives about Joe's recent patches,
> which IMO, are the best option we've discussed so far.

I discussed this approach with our project manager. He was not much
excited about this solution. His first idea was that it would block
attaching USB devices. They are used by admins when taking care of
the servers. And there might be other scenarios where a new module
might need loading to solve some situation.

Customers understand Livepatching as a way how to secure system
without immediate reboot and with minimal (invisible) effect
on the workload. They might get pretty surprised when the system
suddenly blocks their "normal" workflow.

As Miroslav said. No solution is perfect. We need to find the most
acceptable compromise. It seems that you are more concerned about
saving code, reducing complexity and risk. I am more concerned
about user satisfaction.

It is almost impossible to predict effects on user satisfaction
because they have different workflow, use case, expectation,
and tolerance.

We could better estimate the technical side of each solution:

   + implementation cost
   + maintenance cost
   + risks
   + possible improvements and hardening
   + user visible effects
   + complication and limits with creating livepatches


From my POV, the most problematic is the arch-specific code.
It is hard to maintain and we do not have it fully under
control.

And I do not believe that we could remove all arch specific code
when we do not allow delayed livepatching of modules.

Best Regards,
Petr
