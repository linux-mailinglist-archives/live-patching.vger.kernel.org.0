Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6945AA5D8
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 16:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbfIEO2Q (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Sep 2019 10:28:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727914AbfIEO2P (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Sep 2019 10:28:15 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A34FB8980EA;
        Thu,  5 Sep 2019 14:28:15 +0000 (UTC)
Received: from treble (ovpn-120-170.rdu2.redhat.com [10.10.120.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 23EEB100033E;
        Thu,  5 Sep 2019 14:28:12 +0000 (UTC)
Date:   Thu, 5 Sep 2019 09:28:09 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     jikos@kernel.org, Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
Message-ID: <20190905142809.bpalx7wmihkvavxy@treble>
References: <20190826145449.wyo7avwpqyriem46@treble>
 <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz>
 <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com>
 <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz>
 <20190904084932.gndrtewubqiaxmzy@pathway.suse.cz>
 <20190905025055.36loaatxtkhdo4q5@treble>
 <20190905110955.wl4lwjbnpqybhkcn@pathway.suse.cz>
 <20190905130832.dznviqrrg6lfrxvx@treble>
 <20190905131502.mgiaplb3grlxsahp@treble>
 <20190905135259.7obdymb7c2wdgafw@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190905135259.7obdymb7c2wdgafw@pathway.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Thu, 05 Sep 2019 14:28:15 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Sep 05, 2019 at 03:52:59PM +0200, Petr Mladek wrote:
> On Thu 2019-09-05 08:15:02, Josh Poimboeuf wrote:
> > On Thu, Sep 05, 2019 at 08:08:32AM -0500, Josh Poimboeuf wrote:
> > > On Thu, Sep 05, 2019 at 01:09:55PM +0200, Petr Mladek wrote:
> > > > > I don't have a number, but it's very common to patch a function which
> > > > > uses jump labels or alternatives.
> > > > 
> > > > Really? My impression is that both alternatives and jump_labels
> > > > are used in hot paths. I would expect them mostly in core code
> > > > that is always loaded.
> > > > 
> > > > Alternatives are often used in assembly that we are not able
> > > > to livepatch anyway.
> > > > 
> > > > Or are they spread widely via some macros or inlined functions?
> > > 
> > > Jump labels are used everywhere.  Looking at vmlinux.o in my kernel:
> > > 
> > >   Relocation section [19621] '.rela__jump_table' for section [19620] '__jump_table' at offset 0x197873c8 contains 11913 entries:
> > > 
> > > Each jump label entry has 3 entries, so 11913/3 = 3971 jump labels.
> > > 
> > > $ readelf -s vmlinux.o |grep FUNC |wc -l
> > > 46902
> > > 
> > > 3971/46902 = ~8.5%
> > > 
> > > ~8.5% of functions use jump labels.
> > 
> > Obviously some functions may use more than one jump label so this isn't
> > exactly bulletproof math.  But it gives a rough idea of how widespread
> > they are.
> 
> It looks scary. I just wonder why we have never met this problem during
> last few years.

Who knows what can happen when you disable jump label patching.
Sometimes it may be harmless.  A panic is probably the worst case.
There may be other fail modes which are harder to detect.

> My only guess is that most of these functions are either in core
> kernel or in code that we do not livepatch.

This is definitely not the case.  We recently introduced jump label
checking in kpatch-build, and it complains a lot.  The workaround is to
replace such uses with static_key_enabled().

-- 
Josh
