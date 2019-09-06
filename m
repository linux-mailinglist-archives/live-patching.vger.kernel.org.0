Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19B69ABDF8
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2019 18:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbfIFQpy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Sep 2019 12:45:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44628 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbfIFQpy (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Sep 2019 12:45:54 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ED1433084288;
        Fri,  6 Sep 2019 16:45:53 +0000 (UTC)
Received: from treble (ovpn-112-76.rdu2.redhat.com [10.10.112.76])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB107194BB;
        Fri,  6 Sep 2019 16:45:48 +0000 (UTC)
Date:   Fri, 6 Sep 2019 11:45:44 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Petr Mladek <pmladek@suse.com>, jikos@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190906164544.4hmszo2wlqw3pvu5@treble>
References: <20190822223649.ptg6e7qyvosrljqx@treble>
 <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz>
 <20190826145449.wyo7avwpqyriem46@treble>
 <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz>
 <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com>
 <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz>
 <20190905023202.ed7fecc22xze4pwj@treble>
 <alpine.LSU.2.21.1909051403530.25712@pobox.suse.cz>
 <20190905125418.kleis5ackvhtn4hs@treble>
 <alpine.LSU.2.21.1909061431590.3031@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1909061431590.3031@pobox.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 06 Sep 2019 16:45:54 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Sep 06, 2019 at 02:51:01PM +0200, Miroslav Benes wrote:
> 
> > > Now, I don't think that replacing .ko on disk is a good idea. We've 
> > > already discussed it. It would lead to a maintenance/packaging problem, 
> > > because you never know which version of the module is loaded in the 
> > > system. The state space grows rather rapidly there.
> > 
> > What exactly are your concerns?
> > 
> > Either the old version of the module is loaded, and it's livepatched; or
> > the new version of the module is loaded, and it's not livepatched.
> 
> Let's have module foo.ko with function a().
> 
> Live patch 1 (LP1) fixes it to a'(), which calls new function b() (present 
> in LP1). LP1 is used only if foo.ko is loaded. foo.ko is replaced with 
> foo'.ko on disk. It contains both a'() (fixed a() to be precise) and new 
> b().
> 
> Now there is LP2 with new function c() (or c'(), it does not matter) 
> calling b(). Either foo.ko or foo'.ko can be loaded and you don't know 
> which one. The implementation LP2 would be different in both cases.
> 
> You could say that it does not matter. If LP2 is implemented for foo.ko, 
> the same could work for foo'.ko (b() would be a part of LP2 and would not 
> be called directly from foo'.ko). LP2 would only be necessarily larger. It 
> is true in case of functions, but if symbol b is not a function but a 
> global variable, it is different then.

Assuming atomic replace, I don't see how this could be a problem.  LP2
replaces LP1, so why would LP2 need to access LP1's (or foo'.ko's)
symbol b?  All live patches should be built against and targeted for the
original foo.ko.

However... it might break atomic replace functionality in another way.

If LP2 is an 'atomic replace' partial revert of LP1, and foo'.ko were
loaded, when loading LP2, the atomic replace code wouldn't be able to
detect which functions were "patched" in foo'.ko. So if the LP2
functions are not a superset of the LP1 functions, the "patched"
functions in foo'.ko wouldn't get reverted.

What if foo'.ko were really just the original foo.ko, plus livepatch
metadata grafted onto it somehow, such that it patches itself when it
loads?  Then patched state would always be the same regardless of
whether the patch came from the LP or foo'.ko.

> Moreover, in this case foo'.ko is "LP superset". Meaning that it contains 
> only fixes which are present in LP1. What if it is not. We usually 
> preserve kABI, so there could be a module in two or more versions compiled 
> from slightly different code (older/newer and so on) and you don't know 
> which one is loaded. To be fair we don't allow it (I think) at SUSE except 
> for KMPs (kernel module packages) (the issue of course exists even now 
> and we haven't solved it yet, because it is rare) and out of tree modules 
> which we don't support with LP. It could be solved with srcversion, but it 
> complicates things a lot. "blue sky" idea could extend the issue to all 
> modules given the above is real.

I'm having trouble understanding what this issue is and how "blue sky"
would extend it.

-- 
Josh
