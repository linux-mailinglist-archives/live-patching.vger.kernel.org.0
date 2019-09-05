Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B210EAA2D8
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 14:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732862AbfIEMRI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Sep 2019 08:17:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:51862 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731196AbfIEMRH (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Sep 2019 08:17:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C137DAB9D;
        Thu,  5 Sep 2019 12:17:05 +0000 (UTC)
Date:   Thu, 5 Sep 2019 14:16:51 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Petr Mladek <pmladek@suse.com>, jikos@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <20190905023202.ed7fecc22xze4pwj@treble>
Message-ID: <alpine.LSU.2.21.1909051403530.25712@pobox.suse.cz>
References: <20190728200427.dbrojgu7hafphia7@treble> <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz> <20190814151244.5xoaxib5iya2qjco@treble> <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz> <20190822223649.ptg6e7qyvosrljqx@treble>
 <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz> <20190826145449.wyo7avwpqyriem46@treble> <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz> <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com> <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz>
 <20190905023202.ed7fecc22xze4pwj@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 4 Sep 2019, Josh Poimboeuf wrote:

> On Tue, Sep 03, 2019 at 03:02:34PM +0200, Miroslav Benes wrote:
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
> 
> I like this a lot.
> 
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
> How would this option be "limiting for users/distros"?  If the packaging
> part of the solution is done correctly then I don't see how it would be
> limiting.

I'll try to explain my worries.

Blacklisting first. Yes, I agree that it would make things a lot simpler, 
but I am afraid it would not fly at SUSE. Petr meanwhile explained 
elsewhere, but I don't think we can limit our customers that much. We 
perceive live patching as a product as much transparent as possible and as 
less intrusive as possible. One thing is to forbid to remove a module, the 
other is to forbid its loading.

We could warn the admin. Something like "there is a fix for a module foo, 
which is not loaded currently. It will not be patched and the system will 
be still vulnerable if you load the module unless a new fixed version is 
provided."

Yes, we can distribute the new version of .ko with a livepatch. What is 
the reason for blacklisting then? I don't probably understand, but either 
a module is loaded and we can patch it (without late module patching), or 
it is not and we could replace .ko on disk.

Now, I don't think that replacing .ko on disk is a good idea. We've 
already discussed it. It would lead to a maintenance/packaging problem, 
because you never know which version of the module is loaded in the 
system. The state space grows rather rapidly there.

But I may be wrong in my understanding, so bear with me.

Miroslav
