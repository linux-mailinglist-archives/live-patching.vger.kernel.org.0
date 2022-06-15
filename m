Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E634A54C9F3
	for <lists+live-patching@lfdr.de>; Wed, 15 Jun 2022 15:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238058AbiFONhi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Jun 2022 09:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348465AbiFONhh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Jun 2022 09:37:37 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC6F9CE3;
        Wed, 15 Jun 2022 06:37:32 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BF271153B;
        Wed, 15 Jun 2022 06:37:32 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.38.208])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7E3BB3F7F5;
        Wed, 15 Jun 2022 06:37:30 -0700 (PDT)
Date:   Wed, 15 Jun 2022 14:37:26 +0100
From:   Mark Rutland <mark.rutland@arm.com>
To:     "Ivan T. Ivanov" <iivanov@suse.de>
Cc:     madvenka@linux.microsoft.com, jpoimboe@redhat.com,
        peterz@infradead.org, chenzhongjin@huawei.com, broonie@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/20] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Message-ID: <YqngltNLQJl67yu0@FVFF77S0Q05N>
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
 <20220615121844.34v7cos5kcz2hufk@suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615121844.34v7cos5kcz2hufk@suse>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jun 15, 2022 at 03:18:44PM +0300, Ivan T. Ivanov wrote:
> I have run following [1] livepatch tests on kernel build from your repository.
> Overall results looks good, but when I run klp_tc_13.shI there is something which
> I still can not understand completely. It is because of kaslr.
> 
> [   36.817617] livepatch: enabling patch 'klp_tc_13_livepatch'
> [   36.819602] branch_imm_common: offset out of range
> [   36.820113] branch_imm_common: offset out of range
> [   36.820643] ------------[ ftrace bug ]------------
> [   36.821172] ftrace failed to modify
> [   36.821173] [<ffffdde931176804>] orig_do_read_active_livepatch_id+0x4/0xa8 [klp_test_support_mod]
> [   36.822465]  actual:   e4:01:00:94
> [   36.822821] Updating ftrace call site to call a different ftrace function
> [   36.823537] ftrace record flags: e4000002
> [   36.823953]  (2) R
> [   36.823953]  expected tramp: ffffdde96882e224
> [   36.824619] ------------[ cut here ]------------
> [   36.825125] WARNING: CPU: 0 PID: 950 at kernel/trace/ftrace.c:2085 ftrace_bug+0x98/0x280
> [   36.826027] Modules linked in: klp_tc_13_livepatch(OK+) klp_test_support_mod(O) crct10dif_ce
> [   36.826943] CPU: 0 PID: 950 Comm: insmod Tainted: G           O  K   5.18.0-rc1-00020-g1ffee6fdcfda #39
> [   36.827987] Hardware name: linux,dummy-virt (DT)
> [   36.828546] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [   36.829348] pc : ftrace_bug+0x98/0x280
> [   36.829790] lr : ftrace_bug+0x228/0x280
> [   36.830224] sp : ffff8000084038e0
> [   36.830620] x29: ffff8000084038e0 x28: ffff00000485a920 x27: ffffdde931176804
> [   36.831419] x26: ffffdde93117d1a0 x25: ffff00000485a900 x24: ffffdde96aea1000
> [   36.832226] x23: 0000000000000000 x22: 0000000000000001 x21: ffffdde96a124da0
> [   36.833024] x20: ffff0000045620f0 x19: ffffdde96b54a358 x18: ffffffffffffffff
> [   36.833818] x17: 5b20386178302f34 x16: 78302b64695f6863 x15: ffffdde96a3078f8
> [   36.834621] x14: 0000000000000000 x13: 3432326532383836 x12: ffffdde96ae9b3d8
> [   36.835425] x11: 0000000000000001 x10: 0000000000000001 x9 : ffffdde96891305c
> [   36.836221] x8 : c0000000ffffefff x7 : 0000000000017fe8 x6 : ffffdde96ae83398
> [   36.837023] x5 : 0000000000057fa8 x4 : 0000000000000000 x3 : 00000000ffffefff
> [   36.837836] x2 : e32439832ffb9700 x1 : 0000000000000000 x0 : 0000000000000022
> [   36.838635] Call trace:
> [   36.838923]  ftrace_bug+0x98/0x280
> [   36.839319]  ftrace_replace_code+0xa0/0xb8
> [   36.839768]  ftrace_modify_all_code+0xc0/0x160
> [   36.840273]  arch_ftrace_update_code+0x14/0x20
> [   36.840780]  ftrace_run_update_code+0x24/0x78
> [   36.841283]  ftrace_startup_enable+0x50/0x60
> [   36.841781]  ftrace_startup+0xb4/0x178
> [   36.842214]  register_ftrace_function+0x68/0x88
> [   36.842738]  klp_patch_object+0x1c8/0x330
> [   36.843196]  klp_enable_patch+0x468/0x828

IIUC that splat specifically is due to ftrace_modify_call() missing module PLT lookups.

That should be fixed by:

  https://lore.kernel.org/all/20220614080944.1349146-3-mark.rutland@arm.com/

I have not looked at the rest of this series (yet).

Thanks,
Mark.
