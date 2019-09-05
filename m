Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B201AA207
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 13:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730809AbfIELw5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Sep 2019 07:52:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:58488 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725921AbfIELw5 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Sep 2019 07:52:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8A64BAEF8;
        Thu,  5 Sep 2019 11:52:56 +0000 (UTC)
Date:   Thu, 5 Sep 2019 13:52:42 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Joe Lawrence <joe.lawrence@redhat.com>, jikos@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <20190904084932.gndrtewubqiaxmzy@pathway.suse.cz>
Message-ID: <alpine.LSU.2.21.1909051345160.25712@pobox.suse.cz>
References: <20190728200427.dbrojgu7hafphia7@treble> <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz> <20190814151244.5xoaxib5iya2qjco@treble> <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz> <20190822223649.ptg6e7qyvosrljqx@treble>
 <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz> <20190826145449.wyo7avwpqyriem46@treble> <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz> <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com> <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz>
 <20190904084932.gndrtewubqiaxmzy@pathway.suse.cz>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

[...]

> I wonder what is necessary for a productive discussion on Plumbers:

[...]

>     + It might be useful to prepare overview of the existing proposals
>       and agree on the positives and negatives. I am afraid that some
>       of them might depend on the customer base and
>       use cases. Sometimes we might not have enough information.
>       But it might be good to get on the same page where possible.
> 
>       Anyway, it might rule out some variants so that we could better
>       concentrate on the acceptable ones. Or come with yet another
>       proposal that would avoid the real blockers.

My plan is to describe the problem first for the public in the room. Then 
describe the proposals and their advantages and disadvantages. This should 
start the discussion pretty well.

I would be happy if we managed to settle at least on the requirements for 
a solution. It seems that our experience with users and their use cases 
differ a lot and I doubt we could come up with a good solution without 
stating what we want (and don't want) first.

Silly hope is that there may be someone with a perfect solution in the 
room. After all, it is what conferences are for.

> Would it be better to discuss this in a separate room with
> a whiteboard or paperboard?

Maybe.

Miroslav
