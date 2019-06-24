Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB648506AA
	for <lists+live-patching@lfdr.de>; Mon, 24 Jun 2019 12:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbfFXKAi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 24 Jun 2019 06:00:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:33766 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728620AbfFXKAh (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 24 Jun 2019 06:00:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7A0EAAFED;
        Mon, 24 Jun 2019 10:00:35 +0000 (UTC)
Date:   Mon, 24 Jun 2019 12:00:33 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Thomas Gleixner <tglx@linutronix.de>
cc:     Cheng Jian <cj.chengjian@huawei.com>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, jpoimboe@redhat.com,
        mingo@redhat.com, huawei.libin@huawei.com, xiexiuqi@huawei.com,
        yangyingliang@huawei.com, bobo.shaobowang@huawei.com
Subject: Re: [PATCH] Revert "x86/module: Detect and skip invalid
 relocations"
In-Reply-To: <alpine.DEB.2.21.1906220927460.5503@nanos.tec.linutronix.de>
Message-ID: <alpine.LSU.2.21.1906241150000.31030@pobox.suse.cz>
References: <1561019068-132672-1-git-send-email-cj.chengjian@huawei.com> <alpine.LSU.2.21.1906201028490.25778@pobox.suse.cz> <alpine.DEB.2.21.1906220927460.5503@nanos.tec.linutronix.de>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat, 22 Jun 2019, Thomas Gleixner wrote:

> Miroslav,
> 
> On Thu, 20 Jun 2019, Miroslav Benes wrote:
> > On Thu, 20 Jun 2019, Cheng Jian wrote:
> > 
> > > This reverts commit eda9cec4c9a12208a6f69fbe68f72a6311d50032.
> > > 
> > > Since commit (eda9cec4c9a1 'x86/module: Detect and skip invalid
> > > relocations') add some sanity check in apply_relocate_add, borke
> > > re-insmod a kernel module which has been patched before,
> > > 
> > > The relocation informations of the livepatch module have been
> > > overwritten since first patched, so if we rmmod and insmod the
> > > kernel module, these values are not zero anymore, when
> > > klp_module_coming doing, and that commit marks them as invalid
> > > invalid_relocation.
> > > 
> > > Then the following error occurs:
> > > 
> > > 	module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc (____ptrval____), val ffffffffc000236c
> > > 	livepatch: failed to initialize patch 'livepatch_0001_test' for module 'test' (-8)
> > > 	livepatch: patch 'livepatch_0001_test' failed for module 'test', refusing to load module 'test'
> > 
> > Oh yeah. First reported here 20180602161151.apuhs2dygsexmcg2@treble (LP ML 
> > only and there is no archive on lore.kernel.org yet. Sorry about that.). I 
> > posted v1 here 
> > https://lore.kernel.org/lkml/20180607092949.1706-1-mbenes@suse.cz/ and 
> > even started to work on v2 in March with arch-specific nullifying, but 
> > then I got sidetracked again. I'll move it up my todo list a bit.
> 
> so we need to revert it for now, right?

Not necessarily.

Quoting Josh from the original bug report:
"Possible ways to fix it:

1) Remove the error check in apply_relocate_add().  I don't think we
   should do this, because the error is actually useful for detecting
   corrupt modules.  And also, powerpc has the similar error so this
   wouldn't be a universal solution.

2) In klp_unpatch_object(), call an arch-specific arch_unpatch_object()
   which reverses any arch-specific patching: on x86, clearing all
   relocation targets to zero; on powerpc, converting the instructions
   after relative link branches to nops.  I don't think we should do
   this because it's not a global solution and requires fidgety
   arch-specific patching code.

3) Don't allow patched modules to be removed.  I think this makes the
   most sense.  Nobody needs this functionality anyway (right?).
"

1 would be the revert. We decided against it. The scenario (rmmod a 
module) is (supposedly) not that common in practice. Even the current bug 
report was triggered just in testing if I am not mistaken. Moreover, you 
need kpatch-build to properly set up relocation records. Upstream 
livepatch does not offer it as of now. That's why (I think) Josh thought 
the benefits of the check outweighed the disadvantage.

Then I tried to implement 3, but there were problems with it too. 2 
remains to be finished and then we can decide what the best approach is.

That being said... I am not against the reverting the commit per se, but 
we lived with it or quite a long time and no one has met it so far in 
"real life". I don't think it is the classic "we broke something, we have 
to revert" scenario.

Josh, any comment? I think your opinion matters here much more than mine.

Miroslav
