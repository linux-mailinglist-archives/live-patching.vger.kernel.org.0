Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8A104F429
	for <lists+live-patching@lfdr.de>; Sat, 22 Jun 2019 09:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfFVH2W (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 22 Jun 2019 03:28:22 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:57515 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfFVH2W (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 22 Jun 2019 03:28:22 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1heaRd-0003tp-O9; Sat, 22 Jun 2019 09:28:17 +0200
Date:   Sat, 22 Jun 2019 09:28:16 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Miroslav Benes <mbenes@suse.cz>
cc:     Cheng Jian <cj.chengjian@huawei.com>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, jpoimboe@redhat.com,
        mingo@redhat.com, huawei.libin@huawei.com, xiexiuqi@huawei.com,
        yangyingliang@huawei.com, bobo.shaobowang@huawei.com
Subject: Re: [PATCH] Revert "x86/module: Detect and skip invalid
 relocations"
In-Reply-To: <alpine.LSU.2.21.1906201028490.25778@pobox.suse.cz>
Message-ID: <alpine.DEB.2.21.1906220927460.5503@nanos.tec.linutronix.de>
References: <1561019068-132672-1-git-send-email-cj.chengjian@huawei.com> <alpine.LSU.2.21.1906201028490.25778@pobox.suse.cz>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Miroslav,

On Thu, 20 Jun 2019, Miroslav Benes wrote:
> On Thu, 20 Jun 2019, Cheng Jian wrote:
> 
> > This reverts commit eda9cec4c9a12208a6f69fbe68f72a6311d50032.
> > 
> > Since commit (eda9cec4c9a1 'x86/module: Detect and skip invalid
> > relocations') add some sanity check in apply_relocate_add, borke
> > re-insmod a kernel module which has been patched before,
> > 
> > The relocation informations of the livepatch module have been
> > overwritten since first patched, so if we rmmod and insmod the
> > kernel module, these values are not zero anymore, when
> > klp_module_coming doing, and that commit marks them as invalid
> > invalid_relocation.
> > 
> > Then the following error occurs:
> > 
> > 	module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc (____ptrval____), val ffffffffc000236c
> > 	livepatch: failed to initialize patch 'livepatch_0001_test' for module 'test' (-8)
> > 	livepatch: patch 'livepatch_0001_test' failed for module 'test', refusing to load module 'test'
> 
> Oh yeah. First reported here 20180602161151.apuhs2dygsexmcg2@treble (LP ML 
> only and there is no archive on lore.kernel.org yet. Sorry about that.). I 
> posted v1 here 
> https://lore.kernel.org/lkml/20180607092949.1706-1-mbenes@suse.cz/ and 
> even started to work on v2 in March with arch-specific nullifying, but 
> then I got sidetracked again. I'll move it up my todo list a bit.

so we need to revert it for now, right?

Thanks,

	tglx
