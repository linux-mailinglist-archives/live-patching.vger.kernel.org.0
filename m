Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CB86748D3
	for <lists+live-patching@lfdr.de>; Fri, 20 Jan 2023 02:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjATBaV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 19 Jan 2023 20:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjATBaT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 19 Jan 2023 20:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB904F355;
        Thu, 19 Jan 2023 17:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 982FA61DD3;
        Fri, 20 Jan 2023 01:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7C21C433F1;
        Fri, 20 Jan 2023 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674178217;
        bh=y0WMSXaWfNZ1D7CpsRFRbTx5lwlDTZw1fj+Z3txRgkw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EleMx3DOl0FetT8mhi7z3gEb0AhNJOh7HRMuz6rlrkO9/3rzHlsbIuoZUP4JBUl1z
         lX7nBh/R+fAFVWHZJIUKor97VmJVy5eLnYxFW9LwFkfdJbimKEtWd9y7JnQHVF+euO
         KEE+nWyQPGdUvonR7G/RqClJup0gUBdWJiOYO8lm8juzF7aX4kAZZesggP9+pH3y8p
         iOSlSZwAM9JEEQwOsJhJi3YH4MlvbQ/Mr4Z3dCO39ciS61iHjmuEfAbUnBCs1yI7HS
         mN+x/uhdcLSwPecci2e4WTFzIea+M7t2j+r//qzriZ1KQTlxDQfOJuT9Tx4bo5Fz2N
         n4e3okeV1wBmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9CC8C4314C;
        Fri, 20 Jan 2023 01:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 bpf-next 0/3] kallsyms: Optimize the search for module
 symbols by livepatch and bpf
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167417821682.1146.2462134173211926226.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 01:30:16 +0000
References: <20230116101009.23694-1-jolsa@kernel.org>
In-Reply-To: <20230116101009.23694-1-jolsa@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, thunder.leizhen@huawei.com, bpf@vger.kernel.org,
        live-patching@vger.kernel.org, linux-modules@vger.kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, sdf@google.com,
        haoluo@google.com, joe.lawrence@redhat.com, rostedt@goodmis.org,
        mhiramat@kernel.org, mark.rutland@arm.com, mcgrof@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Mon, 16 Jan 2023 11:10:06 +0100 you wrote:
> hi,
> sending new version of [1] patchset posted originally by Zhen Lei.
> It contains 2 changes that improove search performance for livepatch
> and bpf.
> 
> v3 changes:
>   - fixed off by 1 issue, simplified condition, added acks [Song]
>   - added module attach as subtest [Andrii]
> 
> [...]

Here is the summary with links:
  - [PATCHv3,bpf-next,1/3] livepatch: Improve the search performance of module_kallsyms_on_each_symbol()
    https://git.kernel.org/bpf/bpf-next/c/07cc2c931e8e
  - [PATCHv3,bpf-next,2/3] selftests/bpf: Add serial_test_kprobe_multi_bench_attach_kernel/module tests
    https://git.kernel.org/bpf/bpf-next/c/edac4b5b185e
  - [PATCHv3,bpf-next,3/3] bpf: Change modules resolving for kprobe multi link
    https://git.kernel.org/bpf/bpf-next/c/6a5f2d6ee8d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


