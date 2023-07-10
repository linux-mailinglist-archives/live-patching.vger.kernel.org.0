Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F383E74DC0B
	for <lists+live-patching@lfdr.de>; Mon, 10 Jul 2023 19:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjGJRNq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 10 Jul 2023 13:13:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjGJRNp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 10 Jul 2023 13:13:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B54EE67;
        Mon, 10 Jul 2023 10:13:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E91F61063;
        Mon, 10 Jul 2023 17:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3076EC433C7;
        Mon, 10 Jul 2023 17:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689009213;
        bh=0XJBPsK7aGaQFLIrClYgapZHapAhmIKbwi9fn87DyXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bQjAWcJExXBSd7NeEFmJw8QJraWUHIt/euSBYsecVMPN9Uab549z46CJTFAGje+bP
         DuBXnTWoUp+xTPc7jy2vaPYDVzW60aM5MZp5qZGdNOzu7xfk0UqvzaR9zMUiHKiQfP
         gw3/8Cx5RS/bkUylhjAzVVnjfFXYFTZO+KnXRBB75/HOD8lV2IY+AH9xY6HYszViss
         NBuhV2R4KsrPDQbCWDDXsS5KKcFJsaOLoWXUaydVEHP2LqaTQVV2R28PD5kjoTYKvI
         u9bdXjlqEkf7jEplokJaj6ym+XwZrOwD48N9CtePUda+7PG5jH6RxEzwwYocWPJqs5
         cCcyp4D7sXDIg==
Date:   Mon, 10 Jul 2023 10:13:31 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     wardenjohn <ydzhang@linux.alibaba.com>
Cc:     Bagas Sanjaya <bagasdotme@gmail.com>, jikos <jikos@kernel.org>,
        mbenes <mbenes@suse.cz>, pmladek <pmladek@suse.com>,
        "joe.lawrence" <joe.lawrence@redhat.com>,
        Kernel Live Patching <live-patching@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix MAX_STACK_ENTRIES from 100 to 32
Message-ID: <20230710171331.ycxrkttgmtzrwzk4@treble>
References: <931aaecf-66b1-469a-8bc3-7126871a8464.ydzhang@linux.alibaba.com>
 <ZKpqpamE89nvgslC@debian.me>
 <b0ed2a6d-c91b-4c72-9cfc-4900f3a37d82.ydzhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b0ed2a6d-c91b-4c72-9cfc-4900f3a37d82.ydzhang@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun, Jul 09, 2023 at 09:09:14PM +0800, wardenjohn wrote:
> OK, I will resubmit the patch by git-send-email(1) instead. :)
> 
> But I want ask how can I provide the Link to discussion?
> And what is v2 patch?
> I am sorry that it is my first time to join the kernel discussion. 
> 
> I am looking forward to get the guidance from you. Thanks!
> 
> The reason of reducing MAX_STACK_ENTRIES from 100 to 32 is as follows:
> In my daily work, I found that all the function stack will not achieve the number of 32.
> Therefore, setting the array of 100 may be a waste of kernel memory. Therefore, I suggest
> to reduce the number of entries of the stack entries from 100 to 32.
> 
> Here is an example of the call trace:
> [20409.505602]  [<ffffffff81168861>] group_sched_out+0x61/0xb0
> [20409.514791]  [<ffffffff81168bfd>] ctx_sched_out+0xad/0xf0
> [20409.520307]  [<ffffffff8116a03d>] __perf_install_in_context+0xbd/0x1b0
> [20409.526952]  [<ffffffff811649b0>] remote_function+0x40/0x50
> [20409.532644]  [<ffffffff810f1666>] generic_exec_single+0x156/0x1a0
> [20409.538864]  [<ffffffff81164970>] ? perf_event_set_output+0x190/0x190
> [20409.545425]  [<ffffffff810f170f>] smp_call_function_single+0x5f/0xa0
> [20409.551895]  [<ffffffff811f5e70>] ? alloc_file+0xa0/0xf0
> [20409.557326]  [<ffffffff81163523>] task_function_call+0x53/0x80
> [20409.563274]  [<ffffffff81169f80>] ? perf_cpu_hrtimer_handler+0x1b0/0x1b0
> [20409.570089]  [<ffffffff81166688>] perf_install_in_context+0x78/0x120
> [20409.576558]  [<ffffffff8116da54>] SYSC_perf_event_open+0x794/0xa40
> [20409.582852]  [<ffffffff8116e169>] SyS_perf_event_open+0x9/0x10
> [20409.588803]  [<ffffffff8166bf3d>] system_call_fastpath+0x16/0x1b
> [20409.594926]  [<ffffffff8166bddd>] ? system_call_after_swapgs+0xca/0x214

Actually, when I booted with CONFIG_PREEMPT+CONFIG_LOCKDEP, I saw the
number of stack entries go higher than 60.  I didn't do extensive
testing, so it might go even higher than that.

I'd rather leave it at 100 for now, as we currently have no way of
reporting if the limit is getting hit across a variety of configs and
usage scenarios.  And any memory savings would be negligible anyway.

-- 
Josh
