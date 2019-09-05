Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D907DAA3E2
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 15:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbfIENIi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Sep 2019 09:08:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfIENIh (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Sep 2019 09:08:37 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9904C315C010;
        Thu,  5 Sep 2019 13:08:37 +0000 (UTC)
Received: from treble (ovpn-120-170.rdu2.redhat.com [10.10.120.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 00B161001944;
        Thu,  5 Sep 2019 13:08:33 +0000 (UTC)
Date:   Thu, 5 Sep 2019 08:08:32 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     jikos@kernel.org, Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190905130832.dznviqrrg6lfrxvx@treble>
References: <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
 <20190822223649.ptg6e7qyvosrljqx@treble>
 <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz>
 <20190826145449.wyo7avwpqyriem46@treble>
 <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz>
 <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com>
 <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz>
 <20190904084932.gndrtewubqiaxmzy@pathway.suse.cz>
 <20190905025055.36loaatxtkhdo4q5@treble>
 <20190905110955.wl4lwjbnpqybhkcn@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190905110955.wl4lwjbnpqybhkcn@pathway.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 05 Sep 2019 13:08:37 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Sep 05, 2019 at 01:09:55PM +0200, Petr Mladek wrote:
> > I don't have a number, but it's very common to patch a function which
> > uses jump labels or alternatives.
> 
> Really? My impression is that both alternatives and jump_labels
> are used in hot paths. I would expect them mostly in core code
> that is always loaded.
> 
> Alternatives are often used in assembly that we are not able
> to livepatch anyway.
> 
> Or are they spread widely via some macros or inlined functions?

Jump labels are used everywhere.  Looking at vmlinux.o in my kernel:

  Relocation section [19621] '.rela__jump_table' for section [19620] '__jump_table' at offset 0x197873c8 contains 11913 entries:

Each jump label entry has 3 entries, so 11913/3 = 3971 jump labels.

$ readelf -s vmlinux.o |grep FUNC |wc -l
46902

3971/46902 = ~8.5%

~8.5% of functions use jump labels.

> > >       + How often new problematic features appear?
> > 
> > I'm not exactly sure what you mean, but it seems that anytime we add a
> > new feature, we have to try to wrap our heads around how it interacts
> > with the weirdness of late module patching.
> 
> I agree that we need to think about it and it makes complications.
> Anyway, I think that these are never the biggest problems.
> 
> I would be more concerned about arch-specific features that might need
> special handling in the livepatch code. Everyone talks only about
> alternatives and jump_labels that were added long time ago.

Jump labels have been around for many years, but we somehow missed
implementing klp.arch for them.  As I said this resulted in panics.

There may be other similar cases lurking, both in x86 and other arches.
It's not a comforting thought!

And each case requires special klp code in addition to the real code.

-- 
Josh
