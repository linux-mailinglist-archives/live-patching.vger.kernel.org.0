Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B15281196
	for <lists+live-patching@lfdr.de>; Fri,  2 Oct 2020 13:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733260AbgJBLxX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 2 Oct 2020 07:53:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:36442 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgJBLxX (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 2 Oct 2020 07:53:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4BA39B13C;
        Fri,  2 Oct 2020 11:53:22 +0000 (UTC)
Date:   Fri, 2 Oct 2020 13:53:21 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Evgenii Shatokhin <eshatokhin@virtuozzo.com>
cc:     live-patching@vger.kernel.org, pmladek@suse.com, nstange@suse.de
Subject: Re: Patching kthread functions
In-Reply-To: <05a9533b-4b12-d600-5307-1f4fadb44f2b@virtuozzo.com>
Message-ID: <alpine.LSU.2.21.2010021339390.24950@pobox.suse.cz>
References: <9c9e5b82-660e-a666-b55c-a357dd7482cb@virtuozzo.com> <alpine.LSU.2.21.2010011300450.6689@pobox.suse.cz> <05a9533b-4b12-d600-5307-1f4fadb44f2b@virtuozzo.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


> >> The old function will continue running, right?
> > 
> > Correct. It will, however, call new functions.
> 
> Ah, I see.
> 
> So, I guess, our best bet would be to rewrite the thread function so that it
> contains just the event loop and calls other non-inline functions to actually
> process the requests. And, perhaps, - place klp_update_patch_state() before
> schedule().

Yes, that might be the way. klp_update_patch_state() might not be even 
needed. If the callees are live patched, the kthread would be migrated 
thanks to stack checking once a task leaves the callee.
 
> This will not help with this particular kernel version but could make it
> possible to live-patch the request-processing functions in the future kernel
> versions. The main thread function will remain unpatchable but it will call
> the patched functions once we switch the patch_state for the thread.

Yes. The only issue is if the intended fix changes the semantics which is 
incompatible between old and new functions (livepatch consistency model is 
LEAVE_PATCHED_SET, SWITCH_THREAD, see 
https://lore.kernel.org/lkml/20141107140458.GA21774@suse.cz/ for the 
explanation if interested).

Regards
Miroslav
