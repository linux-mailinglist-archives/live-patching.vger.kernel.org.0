Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3082813B2
	for <lists+live-patching@lfdr.de>; Fri,  2 Oct 2020 15:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbgJBNGO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 2 Oct 2020 09:06:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:59470 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726569AbgJBNGN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 2 Oct 2020 09:06:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2C67BAE7D;
        Fri,  2 Oct 2020 13:06:12 +0000 (UTC)
Date:   Fri, 2 Oct 2020 15:06:11 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Evgenii Shatokhin <eshatokhin@virtuozzo.com>
cc:     live-patching@vger.kernel.org, pmladek@suse.com, nstange@suse.de
Subject: Re: Patching kthread functions
In-Reply-To: <1cdecdce-fb34-29aa-1dda-1d02d8a635ef@virtuozzo.com>
Message-ID: <alpine.LSU.2.21.2010021501510.24950@pobox.suse.cz>
References: <9c9e5b82-660e-a666-b55c-a357dd7482cb@virtuozzo.com> <alpine.LSU.2.21.2010011300450.6689@pobox.suse.cz> <05a9533b-4b12-d600-5307-1f4fadb44f2b@virtuozzo.com> <alpine.LSU.2.21.2010021339390.24950@pobox.suse.cz>
 <1cdecdce-fb34-29aa-1dda-1d02d8a635ef@virtuozzo.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 2 Oct 2020, Evgenii Shatokhin wrote:

> On 02.10.2020 14:53, Miroslav Benes wrote:
> > 
> >>>> The old function will continue running, right?
> >>>
> >>> Correct. It will, however, call new functions.
> >>
> >> Ah, I see.
> >>
> >> So, I guess, our best bet would be to rewrite the thread function so that
> >> it
> >> contains just the event loop and calls other non-inline functions to
> >> actually
> >> process the requests. And, perhaps, - place klp_update_patch_state() before
> >> schedule().
> > 
> > Yes, that might be the way. klp_update_patch_state() might not be even
> > needed. If the callees are live patched, the kthread would be migrated
> > thanks to stack checking once a task leaves the callee.
> 
> You mean, the task runs the callee, then goes to schedule(), then, while it
> waits, livepatch core checks its stack, sees no target functions there and
> switches patch_state?

Yes. Once the task gets out of the target function (or the set of 
functions), its patch state can be changed. If it sleeps (interruptedly) 
in the target function, we wake it up so it can get out 
(klp_send_signals()).
 
> >   
> >> This will not help with this particular kernel version but could make it
> >> possible to live-patch the request-processing functions in the future
> >> kernel
> >> versions. The main thread function will remain unpatchable but it will call
> >> the patched functions once we switch the patch_state for the thread.
> > 
> > Yes. The only issue is if the intended fix changes the semantics which is
> > incompatible between old and new functions (livepatch consistency model is
> > LEAVE_PATCHED_SET, SWITCH_THREAD, see
> > https://lore.kernel.org/lkml/20141107140458.GA21774@suse.cz/ for the
> > explanation if interested).
> 
> Yes, I have read that.
> 
> In our case, the fix only adds a kind of lock/unlock around the part of the
> function processing actual requests. The implementation is more complex, but,
> essentially, it is lock + unlock. The code not touched by the patch already
> handles such locking OK, so it can work both with old and the new versions of
> patched functions. And - even if some threads use the old functions and some -
> the new ones. So, I guess, it should be fine.

Ok, that should be fine.

Miroslav
