Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2C7AA388
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 14:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730959AbfIEMyY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Sep 2019 08:54:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730864AbfIEMyY (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Sep 2019 08:54:24 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 64EA3306E115;
        Thu,  5 Sep 2019 12:54:23 +0000 (UTC)
Received: from treble (ovpn-120-170.rdu2.redhat.com [10.10.120.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 48B16600F8;
        Thu,  5 Sep 2019 12:54:20 +0000 (UTC)
Date:   Thu, 5 Sep 2019 07:54:18 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Petr Mladek <pmladek@suse.com>, jikos@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190905125418.kleis5ackvhtn4hs@treble>
References: <20190814151244.5xoaxib5iya2qjco@treble>
 <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
 <20190822223649.ptg6e7qyvosrljqx@treble>
 <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz>
 <20190826145449.wyo7avwpqyriem46@treble>
 <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz>
 <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com>
 <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz>
 <20190905023202.ed7fecc22xze4pwj@treble>
 <alpine.LSU.2.21.1909051403530.25712@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1909051403530.25712@pobox.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Thu, 05 Sep 2019 12:54:23 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Sep 05, 2019 at 02:16:51PM +0200, Miroslav Benes wrote:
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
> > How would this option be "limiting for users/distros"?  If the packaging
> > part of the solution is done correctly then I don't see how it would be
> > limiting.
> 
> I'll try to explain my worries.
> 
> Blacklisting first. Yes, I agree that it would make things a lot simpler, 
> but I am afraid it would not fly at SUSE. Petr meanwhile explained 
> elsewhere, but I don't think we can limit our customers that much. We 
> perceive live patching as a product as much transparent as possible and as 
> less intrusive as possible. One thing is to forbid to remove a module, the 
> other is to forbid its loading.
> 
> We could warn the admin. Something like "there is a fix for a module foo, 
> which is not loaded currently. It will not be patched and the system will 
> be still vulnerable if you load the module unless a new fixed version is 
> provided."

No.  We just distribute the new .ko with the livepatch.  It should be
transparent to the user.

> Yes, we can distribute the new version of .ko with a livepatch. What is 
> the reason for blacklisting then? I don't probably understand, but either 
> a module is loaded and we can patch it (without late module patching), or 
> it is not and we could replace .ko on disk.

I think the blacklisting is a failsafe to prevent the old module from
accidentally getting loaded after patching.

> Now, I don't think that replacing .ko on disk is a good idea. We've 
> already discussed it. It would lead to a maintenance/packaging problem, 
> because you never know which version of the module is loaded in the 
> system. The state space grows rather rapidly there.

What exactly are your concerns?

Either the old version of the module is loaded, and it's livepatched; or
the new version of the module is loaded, and it's not livepatched.

Anyway that could be reported to the user somehow, e.g. report
srcversion in sysfs.

-- 
Josh
