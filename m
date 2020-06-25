Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6725E209A2D
	for <lists+live-patching@lfdr.de>; Thu, 25 Jun 2020 08:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390013AbgFYG7s (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Jun 2020 02:59:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:51520 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389958AbgFYG7q (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Jun 2020 02:59:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 16463AAD0;
        Thu, 25 Jun 2020 06:59:44 +0000 (UTC)
Date:   Thu, 25 Jun 2020 08:59:43 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Nicolai Stange <nstange@suse.com>,
        Jason Baron <jbaron@akamai.com>,
        Gabriel Gomes <gagomes@suse.com>,
        Alice Ferrazzi <alice.ferrazzi@gmail.com>,
        Michael Matz <matz@suse.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        ulp-devel@opensuse.org, live-patching@vger.kernel.org
Subject: Re: Live patching MC at LPC2020?
Message-ID: <20200625065943.GB6156@alley>
References: <nycvar.YFH.7.76.2003271409380.19500@cbobk.fhfr.pm>
 <20200331205204.GA7388@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331205204.GA7388@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2020-03-31 16:52:04, Joe Lawrence wrote:
> On Fri, Mar 27, 2020 at 02:20:52PM +0100, Jiri Kosina wrote:
> > Hi everybody,
> > 
> > oh well, it sounds a bit awkward to be talking about any conference plans 
> > for this year given how the corona things are untangling in the world, but 
> > LPC planning committee has issued (a) statement about Covid-19 (b) call 
> > for papers (as originally planned) nevertheless. Please see:
> > 
> > 	https://linuxplumbersconf.org/
> > 	https://linuxplumbersconf.org/event/7/abstracts/
> > 
> > for details.
> > 
> > Under the asumption that this Covid nuisance is over by that time and 
> > travel is possible (and safe) again -- do we want to eventually submit a 
> > livepatching miniconf proposal again?

The conference is going to be an online event.


> As for LPC mini-conf topics, I'd be interested in (at least):
> 
> - Petr's per-object livepatch POC
> - klp-convert status
> - objtool hacking
> - Nicolai's klp-ccp status
> - arch update (arm64, etc)
 
> Hmm, all good points.  Some conferences have gone virtual to cope with
> necessary cancellations, but who knows what things will look like even
> at the end of August.  Perhaps we can still do something remotely if the
> conditions dictate it.  But my vote would be yes, and let's see what
> topics interest folks.

It seems that there is interest into sharing/discussing some topics.
The question is whether is has to be under the LPC even umbrella.

Advantages of LPC:

   + well defined date
   + more attendees (ARM people, Steven Rostedt ;-)
   + access to some powerful video conference tool
   + access to another LPC content
   + support for the conference in the long term


Advantages of self-organized event:

   + less paperwork?
   + cheaper?
   + only interested people invited
   + date after summer holidays
   + more time for the discussion

I am in the favor of self organized event. For me, LPC is much less
interesting without the personal contact and hallway conversations.
All the LPC date is not ideal for me.

Best Regards,
Petr
