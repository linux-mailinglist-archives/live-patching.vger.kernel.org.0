Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCA4DA692F
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2019 15:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729088AbfICNCs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 3 Sep 2019 09:02:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:46844 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728094AbfICNCs (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 3 Sep 2019 09:02:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3EE2BAF5A;
        Tue,  3 Sep 2019 13:02:47 +0000 (UTC)
Date:   Tue, 3 Sep 2019 15:02:34 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Petr Mladek <pmladek@suse.com>, jikos@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com>
Message-ID: <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz>
References: <20190719122840.15353-1-mbenes@suse.cz> <20190719122840.15353-3-mbenes@suse.cz> <20190728200427.dbrojgu7hafphia7@treble> <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz> <20190814151244.5xoaxib5iya2qjco@treble> <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
 <20190822223649.ptg6e7qyvosrljqx@treble> <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz> <20190826145449.wyo7avwpqyriem46@treble> <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz> <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 2 Sep 2019, Joe Lawrence wrote:

> On 9/2/19 12:13 PM, Miroslav Benes wrote:
> >> I can easily foresee more problems like those in the future.  Going
> >> forward we have to always keep track of which special sections are
> >> needed for which architectures.  Those special sections can change over
> >> time, or can simply be overlooked for a given architecture.  It's
> >> fragile.
> > 
> > Indeed. It bothers me a lot. Even x86 "port" is not feature complete in
> > this regard (jump labels, alternatives,...) and who knows what lurks in
> > the corners of the other architectures we support.
> > 
> > So it is in itself reason enough to do something about late module
> > patching.
> > 
> 
> Hi Miroslav,
> 
> I was tinkering with the "blue-sky" ideas that I mentioned to Josh the other
> day.

> I dunno if you had a chance to look at what removing that code looks
> like, but I can continue to flesh out that idea if it looks interesting:

Unfortunately no and I don't think I'll come up with something useful 
before LPC, so anything is really welcome.

> 
>   https://github.com/joe-lawrence/linux/tree/blue-sky
> 
> A full demo would require packaging up replacement .ko's with a livepatch, as
> well as "blacklisting" those deprecated .kos, etc.  But that's all I had time
> to cook up last week before our holiday weekend here.

Frankly, I'm not sure about this approach. I'm kind of torn. The current 
solution is far from ideal, but I'm not excited about the other options 
either. It seems like the choice is basically between "general but 
technically complicated fragile solution with nontrivial maintenance 
burden", or "something safer and maybe cleaner, but limiting for 
users/distros". Of course it depends on whether the limitation is even 
real and how big it is. Unfortunately we cannot quantify it much and that 
is probably why our opinions (in the email thread) differ.

Not much constructive email, but I have to think about it some more 
(before LPC).

Regards
Miroslav
