Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94221A985C
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 04:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729848AbfIECcK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 4 Sep 2019 22:32:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbfIECcK (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 4 Sep 2019 22:32:10 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F0A062D1CE;
        Thu,  5 Sep 2019 02:32:09 +0000 (UTC)
Received: from treble (ovpn-121-98.rdu2.redhat.com [10.10.121.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EE5260852;
        Thu,  5 Sep 2019 02:32:03 +0000 (UTC)
Date:   Wed, 4 Sep 2019 21:32:02 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Petr Mladek <pmladek@suse.com>, jikos@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190905023202.ed7fecc22xze4pwj@treble>
References: <20190728200427.dbrojgu7hafphia7@treble>
 <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz>
 <20190814151244.5xoaxib5iya2qjco@treble>
 <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
 <20190822223649.ptg6e7qyvosrljqx@treble>
 <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz>
 <20190826145449.wyo7avwpqyriem46@treble>
 <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz>
 <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com>
 <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 05 Sep 2019 02:32:10 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Sep 03, 2019 at 03:02:34PM +0200, Miroslav Benes wrote:
> On Mon, 2 Sep 2019, Joe Lawrence wrote:
> 
> > On 9/2/19 12:13 PM, Miroslav Benes wrote:
> > >> I can easily foresee more problems like those in the future.  Going
> > >> forward we have to always keep track of which special sections are
> > >> needed for which architectures.  Those special sections can change over
> > >> time, or can simply be overlooked for a given architecture.  It's
> > >> fragile.
> > > 
> > > Indeed. It bothers me a lot. Even x86 "port" is not feature complete in
> > > this regard (jump labels, alternatives,...) and who knows what lurks in
> > > the corners of the other architectures we support.
> > > 
> > > So it is in itself reason enough to do something about late module
> > > patching.
> > > 
> > 
> > Hi Miroslav,
> > 
> > I was tinkering with the "blue-sky" ideas that I mentioned to Josh the other
> > day.
> 
> > I dunno if you had a chance to look at what removing that code looks
> > like, but I can continue to flesh out that idea if it looks interesting:
> 
> Unfortunately no and I don't think I'll come up with something useful 
> before LPC, so anything is really welcome.
> 
> > 
> >   https://github.com/joe-lawrence/linux/tree/blue-sky

I like this a lot.

> > A full demo would require packaging up replacement .ko's with a livepatch, as
> > well as "blacklisting" those deprecated .kos, etc.  But that's all I had time
> > to cook up last week before our holiday weekend here.
> 
> Frankly, I'm not sure about this approach. I'm kind of torn. The current 
> solution is far from ideal, but I'm not excited about the other options 
> either. It seems like the choice is basically between "general but 
> technically complicated fragile solution with nontrivial maintenance 
> burden", or "something safer and maybe cleaner, but limiting for 
> users/distros". Of course it depends on whether the limitation is even 
> real and how big it is. Unfortunately we cannot quantify it much and that 
> is probably why our opinions (in the email thread) differ.

How would this option be "limiting for users/distros"?  If the packaging
part of the solution is done correctly then I don't see how it would be
limiting.

-- 
Josh
