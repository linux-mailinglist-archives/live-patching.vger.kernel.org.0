Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE131AD97A
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2020 11:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgDQJIq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Apr 2020 05:08:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:46664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729920AbgDQJIp (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Apr 2020 05:08:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 69E84ABE2;
        Fri, 17 Apr 2020 09:08:43 +0000 (UTC)
Date:   Fri, 17 Apr 2020 11:08:42 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Peter Zijlstra <peterz@infradead.org>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jessica Yu <jeyu@kernel.org>
Subject: Re: [PATCH 0/7] livepatch,module: Remove .klp.arch and
 module_disable_ro()
In-Reply-To: <20200416122051.p3dk5i7h6ty4cwuc@treble>
Message-ID: <alpine.LSU.2.21.2004171104050.31054@pobox.suse.cz>
References: <cover.1586881704.git.jpoimboe@redhat.com> <20200414182726.GF2483@worktop.programming.kicks-ass.net> <20200414190814.glra2gceqgy34iyx@treble> <alpine.LSU.2.21.2004161136340.10475@pobox.suse.cz> <20200416122051.p3dk5i7h6ty4cwuc@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 16 Apr 2020, Josh Poimboeuf wrote:

> On Thu, Apr 16, 2020 at 11:45:05AM +0200, Miroslav Benes wrote:
> > On Tue, 14 Apr 2020, Josh Poimboeuf wrote:
> > 
> > > On Tue, Apr 14, 2020 at 08:27:26PM +0200, Peter Zijlstra wrote:
> > > > On Tue, Apr 14, 2020 at 11:28:36AM -0500, Josh Poimboeuf wrote:
> > > > > Better late than never, these patches add simplifications and
> > > > > improvements for some issues Peter found six months ago, as part of his
> > > > > non-writable text code (W^X) cleanups.
> > > > 
> > > > Excellent stuff, thanks!!
> > > >
> > > > I'll go brush up these two patches then:
> > > > 
> > > >   https://lkml.kernel.org/r/20191018074634.801435443@infradead.org
> > > >   https://lkml.kernel.org/r/20191018074634.858645375@infradead.org
> > > 
> > > Ah right, I meant to bring that up.  I actually played around with those
> > > patches.  While it would be nice to figure out a way to converge the
> > > ftrace module init, I didn't really like the first patch.
> > > 
> > > It bothers me that both the notifiers and the module init() both see the
> > > same MODULE_STATE_COMING state, but only in the former case is the text
> > > writable.
> > > 
> > > I think it's cognitively simpler if MODULE_STATE_COMING always means the
> > > same thing, like the comments imply, "fully formed" and thus
> > > not-writable:
> > > 
> > > enum module_state {
> > > 	MODULE_STATE_LIVE,	/* Normal state. */
> > > 	MODULE_STATE_COMING,	/* Full formed, running module_init. */
> > > 	MODULE_STATE_GOING,	/* Going away. */
> > > 	MODULE_STATE_UNFORMED,	/* Still setting it up. */
> > > };
> > > 
> > > And, it keeps tighter constraints on what a notifier can do, which is a
> > > good thing if we can get away with it.
> > 
> > Agreed.
> > 
> > On the other hand, the first patch would remove the tiny race window when 
> > a module state is still UNFORMED, but the protections are (being) set up. 
> > Patches 4/7 and 5/7 allow to use memcpy in that case, because it is early. 
> > But it is in fact not already. I haven't checked yet if it really matters 
> > somewhere (a race with livepatch running klp_module_coming while another 
> > module is being loaded or anything like that).
> 
> Maybe I'm missing your point, but I don't see any races here.
> 
> apply_relocate_add() only writes to the patch module's text, so there
> can't be races with other modules.

I meant... a patch module is being loaded and at the same time a 
to-be-patched module too. So apply_relocate_add() called from 
klp_module_coming() would see UNFORMED in the patch module state and the 
permissions would be set up already. So memcpy would not work. But we 
protect against that (and many other things) by taking klp_mutex, of 
course. I managed to confuse myself again, sorry about that.

Miroslav
