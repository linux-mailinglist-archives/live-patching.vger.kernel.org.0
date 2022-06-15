Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DA354CB0B
	for <lists+live-patching@lfdr.de>; Wed, 15 Jun 2022 16:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242460AbiFOOTB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Jun 2022 10:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238011AbiFOOTA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Jun 2022 10:19:00 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BE3334B96;
        Wed, 15 Jun 2022 07:18:58 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5763F21C19;
        Wed, 15 Jun 2022 14:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655302737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YgLkMI9DqFt3ydqQoLdZQvEZhwQFjz0PcIyBz6Ee8W4=;
        b=nDOj/JDX8TbIMSSCX9jxqeAFJq6ogVecA5wHTgsxD7utIae/P3JoJhTtcM9PbWUqSkvu7X
        VhktLnitWXSk/sYRqqLhBykJRXeKcOMU0+xTmzGcz8+w3f5gEbqNE8OQ0jNzz5+i466NKH
        /BPSV6WBrE35QKroSbZCSQMmVEBkhzI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655302737;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YgLkMI9DqFt3ydqQoLdZQvEZhwQFjz0PcIyBz6Ee8W4=;
        b=jy0EeX2/SF5zOktPUxdwIMjY1FnFiF1wsT7P7NYhzEtUwuhzdtZNMHAxFUW8GR6yTKXE+f
        0bF6ZMfHne3UfWCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 397D0139F3;
        Wed, 15 Jun 2022 14:18:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kwO7DVHqqWKEOgAAMHmgww
        (envelope-from <iivanov@suse.de>); Wed, 15 Jun 2022 14:18:57 +0000
Date:   Wed, 15 Jun 2022 17:18:56 +0300
From:   "Ivan T. Ivanov" <iivanov@suse.de>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     madvenka@linux.microsoft.com, jpoimboe@redhat.com,
        peterz@infradead.org, chenzhongjin@huawei.com, broonie@kernel.org,
        nobuta.keiya@fujitsu.com, sjitindarsingh@gmail.com,
        catalin.marinas@arm.com, will@kernel.org,
        jamorris@linux.microsoft.com, linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 00/20] arm64: livepatch: Use ORC for dynamic frame
 pointer validation
Message-ID: <20220615141856.t6jfuuk4loevahi5@suse>
References: <e81e773678f88f7c2ff7480e2eb096973ec198db>
 <20220524001637.1707472-1-madvenka@linux.microsoft.com>
 <20220615121844.34v7cos5kcz2hufk@suse>
 <YqngltNLQJl67yu0@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqngltNLQJl67yu0@FVFF77S0Q05N>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

On 06-15 14:37, Mark Rutland wrote:
> 
> On Wed, Jun 15, 2022 at 03:18:44PM +0300, Ivan T. Ivanov wrote:
> > I have run following [1] livepatch tests on kernel build from your repository.
> > Overall results looks good, but when I run klp_tc_13.shI there is something which
> > I still can not understand completely. It is because of kaslr.
> > 
> > [   36.817617] livepatch: enabling patch 'klp_tc_13_livepatch'
> > [   36.819602] branch_imm_common: offset out of range
> > [   36.820113] branch_imm_common: offset out of range
> > [   36.820643] ------------[ ftrace bug ]------------
> > [   36.821172] ftrace failed to modify
> > [   36.821173] [<ffffdde931176804>] orig_do_read_active_livepatch_id+0x4/0xa8 [klp_test_support_mod]
> > [   36.822465]  actual:   e4:01:00:94
> > [   36.822821] Updating ftrace call site to call a different ftrace function
> > [   36.823537] ftrace record flags: e4000002
> > [   36.823953]  (2) R
> > [   36.823953]  expected tramp: ffffdde96882e224
> > [   36.824619] ------------[ cut here ]------------
> > [   36.825125] WARNING: CPU: 0 PID: 950 at kernel/trace/ftrace.c:2085 ftrace_bug+0x98/0x280
> > [   36.826027] Modules linked in: klp_tc_13_livepatch(OK+) klp_test_support_mod(O) crct10dif_ce
> > [   36.826943] CPU: 0 PID: 950 Comm: insmod Tainted: G           O  K   5.18.0-rc1-00020-g1ffee6fdcfda #39
> > [   36.827987] Hardware name: linux,dummy-virt (DT)
> > [   36.828546] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > [   36.829348] pc : ftrace_bug+0x98/0x280
> > [   36.829790] lr : ftrace_bug+0x228/0x280
> > [   36.830224] sp : ffff8000084038e0
> > [   36.830620] x29: ffff8000084038e0 x28: ffff00000485a920 x27: ffffdde931176804
> > [   36.831419] x26: ffffdde93117d1a0 x25: ffff00000485a900 x24: ffffdde96aea1000
> > [   36.832226] x23: 0000000000000000 x22: 0000000000000001 x21: ffffdde96a124da0
> > [   36.833024] x20: ffff0000045620f0 x19: ffffdde96b54a358 x18: ffffffffffffffff
> > [   36.833818] x17: 5b20386178302f34 x16: 78302b64695f6863 x15: ffffdde96a3078f8
> > [   36.834621] x14: 0000000000000000 x13: 3432326532383836 x12: ffffdde96ae9b3d8
> > [   36.835425] x11: 0000000000000001 x10: 0000000000000001 x9 : ffffdde96891305c
> > [   36.836221] x8 : c0000000ffffefff x7 : 0000000000017fe8 x6 : ffffdde96ae83398
> > [   36.837023] x5 : 0000000000057fa8 x4 : 0000000000000000 x3 : 00000000ffffefff
> > [   36.837836] x2 : e32439832ffb9700 x1 : 0000000000000000 x0 : 0000000000000022
> > [   36.838635] Call trace:
> > [   36.838923]  ftrace_bug+0x98/0x280
> > [   36.839319]  ftrace_replace_code+0xa0/0xb8
> > [   36.839768]  ftrace_modify_all_code+0xc0/0x160
> > [   36.840273]  arch_ftrace_update_code+0x14/0x20
> > [   36.840780]  ftrace_run_update_code+0x24/0x78
> > [   36.841283]  ftrace_startup_enable+0x50/0x60
> > [   36.841781]  ftrace_startup+0xb4/0x178
> > [   36.842214]  register_ftrace_function+0x68/0x88
> > [   36.842738]  klp_patch_object+0x1c8/0x330
> > [   36.843196]  klp_enable_patch+0x468/0x828
> 
> IIUC that splat specifically is due to ftrace_modify_call() missing module PLT lookups.
> 
> That should be fixed by:
> 
>   https://lore.kernel.org/all/20220614080944.1349146-3-mark.rutland@arm.com/
> 

Yes, this is it. Thanks!

Regards,
Ivan

