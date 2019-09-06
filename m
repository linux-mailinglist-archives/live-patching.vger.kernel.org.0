Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7968AB860
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2019 14:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404748AbfIFMvR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Sep 2019 08:51:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:35376 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404746AbfIFMvR (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Sep 2019 08:51:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 70B34AFB0;
        Fri,  6 Sep 2019 12:51:15 +0000 (UTC)
Date:   Fri, 6 Sep 2019 14:51:01 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Petr Mladek <pmladek@suse.com>, jikos@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <20190905125418.kleis5ackvhtn4hs@treble>
Message-ID: <alpine.LSU.2.21.1909061431590.3031@pobox.suse.cz>
References: <20190814151244.5xoaxib5iya2qjco@treble> <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz> <20190822223649.ptg6e7qyvosrljqx@treble> <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz> <20190826145449.wyo7avwpqyriem46@treble>
 <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz> <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com> <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz> <20190905023202.ed7fecc22xze4pwj@treble> <alpine.LSU.2.21.1909051403530.25712@pobox.suse.cz>
 <20190905125418.kleis5ackvhtn4hs@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


> > Now, I don't think that replacing .ko on disk is a good idea. We've 
> > already discussed it. It would lead to a maintenance/packaging problem, 
> > because you never know which version of the module is loaded in the 
> > system. The state space grows rather rapidly there.
> 
> What exactly are your concerns?
> 
> Either the old version of the module is loaded, and it's livepatched; or
> the new version of the module is loaded, and it's not livepatched.

Let's have module foo.ko with function a().

Live patch 1 (LP1) fixes it to a'(), which calls new function b() (present 
in LP1). LP1 is used only if foo.ko is loaded. foo.ko is replaced with 
foo'.ko on disk. It contains both a'() (fixed a() to be precise) and new 
b().

Now there is LP2 with new function c() (or c'(), it does not matter) 
calling b(). Either foo.ko or foo'.ko can be loaded and you don't know 
which one. The implementation LP2 would be different in both cases.

You could say that it does not matter. If LP2 is implemented for foo.ko, 
the same could work for foo'.ko (b() would be a part of LP2 and would not 
be called directly from foo'.ko). LP2 would only be necessarily larger. It 
is true in case of functions, but if symbol b is not a function but a 
global variable, it is different then.

Moreover, in this case foo'.ko is "LP superset". Meaning that it contains 
only fixes which are present in LP1. What if it is not. We usually 
preserve kABI, so there could be a module in two or more versions compiled 
from slightly different code (older/newer and so on) and you don't know 
which one is loaded. To be fair we don't allow it (I think) at SUSE except 
for KMPs (kernel module packages) (the issue of course exists even now 
and we haven't solved it yet, because it is rare) and out of tree modules 
which we don't support with LP. It could be solved with srcversion, but it 
complicates things a lot. "blue sky" idea could extend the issue to all 
modules given the above is real.

Does it make sense?

Miroslav
