Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB9A52142
	for <lists+live-patching@lfdr.de>; Tue, 25 Jun 2019 05:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfFYDbe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 24 Jun 2019 23:31:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32834 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbfFYDbe (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 24 Jun 2019 23:31:34 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C986FC1EB1E8;
        Tue, 25 Jun 2019 03:31:33 +0000 (UTC)
Received: from treble (ovpn-126-66.rdu2.redhat.com [10.10.126.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1F5C19936;
        Tue, 25 Jun 2019 03:31:29 +0000 (UTC)
Date:   Mon, 24 Jun 2019 22:31:25 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Cheng Jian <cj.chengjian@huawei.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        mingo@redhat.com, huawei.libin@huawei.com, xiexiuqi@huawei.com,
        yangyingliang@huawei.com, bobo.shaobowang@huawei.com
Subject: Re: [PATCH] Revert "x86/module: Detect and skip invalid relocations"
Message-ID: <20190625033125.7wcxeymke6zsdvdg@treble>
References: <1561019068-132672-1-git-send-email-cj.chengjian@huawei.com>
 <alpine.LSU.2.21.1906201028490.25778@pobox.suse.cz>
 <alpine.DEB.2.21.1906220927460.5503@nanos.tec.linutronix.de>
 <alpine.LSU.2.21.1906241150000.31030@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.1906241150000.31030@pobox.suse.cz>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Tue, 25 Jun 2019 03:31:33 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Jun 24, 2019 at 12:00:33PM +0200, Miroslav Benes wrote:
> On Sat, 22 Jun 2019, Thomas Gleixner wrote:
> 
> > Miroslav,
> > 
> > On Thu, 20 Jun 2019, Miroslav Benes wrote:
> > > On Thu, 20 Jun 2019, Cheng Jian wrote:
> > > 
> > > > This reverts commit eda9cec4c9a12208a6f69fbe68f72a6311d50032.
> > > > 
> > > > Since commit (eda9cec4c9a1 'x86/module: Detect and skip invalid
> > > > relocations') add some sanity check in apply_relocate_add, borke
> > > > re-insmod a kernel module which has been patched before,
> > > > 
> > > > The relocation informations of the livepatch module have been
> > > > overwritten since first patched, so if we rmmod and insmod the
> > > > kernel module, these values are not zero anymore, when
> > > > klp_module_coming doing, and that commit marks them as invalid
> > > > invalid_relocation.
> > > > 
> > > > Then the following error occurs:
> > > > 
> > > > 	module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc (____ptrval____), val ffffffffc000236c
> > > > 	livepatch: failed to initialize patch 'livepatch_0001_test' for module 'test' (-8)
> > > > 	livepatch: patch 'livepatch_0001_test' failed for module 'test', refusing to load module 'test'
> > > 
> > > Oh yeah. First reported here 20180602161151.apuhs2dygsexmcg2@treble (LP ML 
> > > only and there is no archive on lore.kernel.org yet. Sorry about that.). I 
> > > posted v1 here 
> > > https://lore.kernel.org/lkml/20180607092949.1706-1-mbenes@suse.cz/ and 
> > > even started to work on v2 in March with arch-specific nullifying, but 
> > > then I got sidetracked again. I'll move it up my todo list a bit.
> > 
> > so we need to revert it for now, right?
> 
> Not necessarily.
> 
> Quoting Josh from the original bug report:
> "Possible ways to fix it:
> 
> 1) Remove the error check in apply_relocate_add().  I don't think we
>    should do this, because the error is actually useful for detecting
>    corrupt modules.  And also, powerpc has the similar error so this
>    wouldn't be a universal solution.
> 
> 2) In klp_unpatch_object(), call an arch-specific arch_unpatch_object()
>    which reverses any arch-specific patching: on x86, clearing all
>    relocation targets to zero; on powerpc, converting the instructions
>    after relative link branches to nops.  I don't think we should do
>    this because it's not a global solution and requires fidgety
>    arch-specific patching code.
> 
> 3) Don't allow patched modules to be removed.  I think this makes the
>    most sense.  Nobody needs this functionality anyway (right?).
> "
> 
> 1 would be the revert. We decided against it. The scenario (rmmod a 
> module) is (supposedly) not that common in practice. Even the current bug 
> report was triggered just in testing if I am not mistaken. Moreover, you 
> need kpatch-build to properly set up relocation records. Upstream 
> livepatch does not offer it as of now. That's why (I think) Josh thought 
> the benefits of the check outweighed the disadvantage.
> 
> Then I tried to implement 3, but there were problems with it too. 2 
> remains to be finished and then we can decide what the best approach is.
> 
> That being said... I am not against the reverting the commit per se, but 
> we lived with it or quite a long time and no one has met it so far in 
> "real life". I don't think it is the classic "we broke something, we have 
> to revert" scenario.
> 
> Josh, any comment? I think your opinion matters here much more than mine.

Agreed, as far as I know the problem is purely theoretical and we
haven't seen any real-world bug reports, because people aren't reloading
patched modules in the real world.

If we were to revert the error checks in apply_relocate_add() then it
could expose us to real-world regressions (which we have actually seen
in the past).

So I would vote to leave the error checks in place, at least until it
becomes a real-world issue.  And in the meantime hopefully you can
finish implementing #2 or #3 soon :-)

-- 
Josh
