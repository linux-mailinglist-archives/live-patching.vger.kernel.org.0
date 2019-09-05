Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9A08AA51A
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 15:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbfIENxA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Sep 2019 09:53:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:54198 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727735AbfIENxA (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Sep 2019 09:53:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 739D1AF84;
        Thu,  5 Sep 2019 13:52:59 +0000 (UTC)
Date:   Thu, 5 Sep 2019 15:52:59 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     jikos@kernel.org, Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190905135259.7obdymb7c2wdgafw@pathway.suse.cz>
References: <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz>
 <20190826145449.wyo7avwpqyriem46@treble>
 <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz>
 <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com>
 <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz>
 <20190904084932.gndrtewubqiaxmzy@pathway.suse.cz>
 <20190905025055.36loaatxtkhdo4q5@treble>
 <20190905110955.wl4lwjbnpqybhkcn@pathway.suse.cz>
 <20190905130832.dznviqrrg6lfrxvx@treble>
 <20190905131502.mgiaplb3grlxsahp@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905131502.mgiaplb3grlxsahp@treble>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2019-09-05 08:15:02, Josh Poimboeuf wrote:
> On Thu, Sep 05, 2019 at 08:08:32AM -0500, Josh Poimboeuf wrote:
> > On Thu, Sep 05, 2019 at 01:09:55PM +0200, Petr Mladek wrote:
> > > > I don't have a number, but it's very common to patch a function which
> > > > uses jump labels or alternatives.
> > > 
> > > Really? My impression is that both alternatives and jump_labels
> > > are used in hot paths. I would expect them mostly in core code
> > > that is always loaded.
> > > 
> > > Alternatives are often used in assembly that we are not able
> > > to livepatch anyway.
> > > 
> > > Or are they spread widely via some macros or inlined functions?
> > 
> > Jump labels are used everywhere.  Looking at vmlinux.o in my kernel:
> > 
> >   Relocation section [19621] '.rela__jump_table' for section [19620] '__jump_table' at offset 0x197873c8 contains 11913 entries:
> > 
> > Each jump label entry has 3 entries, so 11913/3 = 3971 jump labels.
> > 
> > $ readelf -s vmlinux.o |grep FUNC |wc -l
> > 46902
> > 
> > 3971/46902 = ~8.5%
> > 
> > ~8.5% of functions use jump labels.
> 
> Obviously some functions may use more than one jump label so this isn't
> exactly bulletproof math.  But it gives a rough idea of how widespread
> they are.

It looks scary. I just wonder why we have never met this problem during
last few years.

My only guess is that most of these functions are either in core
kernel or in code that we do not livepatch.

I do not want to say that we should ignore it. I want to
understand the cost and impact of the various approaches.

Regards,
Petr
