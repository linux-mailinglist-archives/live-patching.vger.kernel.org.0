Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E20523DF96
	for <lists+live-patching@lfdr.de>; Thu,  6 Aug 2020 19:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727081AbgHFRuR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 Aug 2020 13:50:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:49584 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727961AbgHFQdo (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 Aug 2020 12:33:44 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 427C4AB55;
        Thu,  6 Aug 2020 12:03:54 +0000 (UTC)
Date:   Thu, 6 Aug 2020 14:03:36 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] docs/livepatch: Add new compiler considerations doc
Message-ID: <20200806120336.GP24529@alley>
References: <20200721161407.26806-1-joe.lawrence@redhat.com>
 <20200721161407.26806-2-joe.lawrence@redhat.com>
 <20200721230442.5v6ah7bpjx4puqva@treble>
 <de3672ef-8779-245f-943d-3d5a4b875446@redhat.com>
 <20200722205139.hwbej2atk2ejq27n@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722205139.hwbej2atk2ejq27n@treble>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2020-07-22 15:51:39, Josh Poimboeuf wrote:
> On Wed, Jul 22, 2020 at 01:03:03PM -0400, Joe Lawrence wrote:
> > On 7/21/20 7:04 PM, Josh Poimboeuf wrote:
> > > On Tue, Jul 21, 2020 at 12:14:06PM -0400, Joe Lawrence wrote:
> > > > Compiler optimizations can have serious implications on livepatching.
> > > > Create a document that outlines common optimization patterns and safe
> > > > ways to livepatch them.
> > > > 
> > > > Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> > > 
> > > There's a lot of good info here, but I wonder if it should be
> > > reorganized a bit and instead called "how to create a livepatch module",
> > > because that's really the point of it all.
> > > 
> > 
> > That would be nice.  Would you consider a stand-alone compiler-optimizations
> > doc an incremental step towards that end?  Note that the other files
> > (callbacks, shadow-vars, system-state) in their current form might be as
> > confusing to the newbie.
> 
> It's an incremental step towards _something_.  Whether that's a cohesive
> patch creation guide, or just a growing hodgepodge of random documents,
> it may be too early to say :-)

Yes, it would be nice to have a cohesive documentation. But scattered
pieces are better than nothing.

> > > I'm thinking a newcomer reading this might be lost.  It's not
> > > necessarily clear that there are currently two completely different
> > > approaches to creating a livepatch module, each with their own quirks
> > > and benefits/drawbacks.  There is one mention of a "source-based
> > > livepatch author" but no explanation of what that means.
> > > 
> > 
> > Yes, the initial draft was light on source-based patching since I only
> > really tinker with it for samples/kselftests.  The doc was the result of an
> > experienced livepatch developer and Sunday afternoon w/the compiler. I'm
> > sure it reads as such. :)
> 
> Are experienced livepatch developers the intended audience?  If so I
> question what value this document has in its current form.  Presumably
> experienced livepatch developers would already know this stuff.

IMHO, this document is useful even for newbies. They might at
least get a clue about these catches. It is better than nothing.

I do not want to discourage Joe from creating even better
documentation. But if he does not have interest or time
to work on it, I am happy even for this piece.

Acked-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
