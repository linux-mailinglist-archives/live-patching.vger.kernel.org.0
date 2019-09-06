Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38FB1ABCB5
	for <lists+live-patching@lfdr.de>; Fri,  6 Sep 2019 17:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405008AbfIFPjA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Sep 2019 11:39:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38448 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733236AbfIFPi7 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Sep 2019 11:38:59 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3CE4E3082B43;
        Fri,  6 Sep 2019 15:38:59 +0000 (UTC)
Received: from [10.33.36.146] (unknown [10.33.36.146])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CC676012E;
        Fri,  6 Sep 2019 15:38:56 +0000 (UTC)
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
To:     Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>, jikos@kernel.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
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
 <20190905125418.kleis5ackvhtn4hs@treble>
 <alpine.LSU.2.21.1909061431590.3031@pobox.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <9a917499-4dbc-e78c-05d0-226e49fc9fa3@redhat.com>
Date:   Fri, 6 Sep 2019 16:38:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.1909061431590.3031@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 06 Sep 2019 15:38:59 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 9/6/19 1:51 PM, Miroslav Benes wrote:
> 
>>> Now, I don't think that replacing .ko on disk is a good idea. We've
>>> already discussed it. It would lead to a maintenance/packaging problem,
>>> because you never know which version of the module is loaded in the
>>> system. The state space grows rather rapidly there.
>>
>> What exactly are your concerns?
>>
>> Either the old version of the module is loaded, and it's livepatched; or
>> the new version of the module is loaded, and it's not livepatched.
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
> 
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
> 
> Does it make sense?
> 

If I understand correctly, you're saying that this would add another 
dimension to the potential system state that livepatches need to 
consider?  e.g. when updating a livepatch to v3, a v2 patched module may 
or may not be loaded.  So are we updating livepatch v2 code or module v2 
code...

I agree that for functions, we could probably get away with repeating 
code, but not necessarily for new global variables.

Then there's the question of:

   module v3 == module v{1,2} + livepatch v3?


Is this scenario similar to one where a customer somehow finds and loads 
module v3 before loading livepatch v3?  Livepatch doesn't have a 
srcversion whitelist so this should be entirely possible.  I suppose it 
is a bit different in that module v3 would be starting from a fresh load 
and not something that livepatch v3 has hotpatched from an unknown 
source/base.

-- Joe
