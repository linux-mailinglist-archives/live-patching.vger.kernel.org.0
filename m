Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDF6585692
	for <lists+live-patching@lfdr.de>; Fri, 29 Jul 2022 23:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239357AbiG2VkT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 29 Jul 2022 17:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239328AbiG2VkR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 29 Jul 2022 17:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B38D6252;
        Fri, 29 Jul 2022 14:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BACE7B829CD;
        Fri, 29 Jul 2022 21:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 53AFDC433D7;
        Fri, 29 Jul 2022 21:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659130813;
        bh=ysiwbxtc6/5eLqh2EUgtobEZ7Cdyg4zNRPiSJBZDWYo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c3/khEa68dGRYkUMEAf0eSXDmMD/ZaVxM/Py/oncriCC9LLF+gePYBCcn68ZS1zAg
         wwjdSQh3fgpUiB9VhXM3FiE5SBrO/hIX2yGtTk4yEtuTzCff4JedLlCSOnHIBpt/sB
         fxy2nhI5/akbHcic2DMeUhXd4+kbXnTNiVGhtBjnFYDVa6s0I4JCj2g4pJww3omDVa
         ianKh/TMPNLWZoBAcMvNDdkXbVJxs2+PYx9uTecwhElmh2x0Cr6TvzgaQ5xM9sH0Nz
         doo9nCssm5pXGXOt2rN9DnO4cI1b6uBBpPQOJc3TEK+b7Vv47ZqhgppcTXMV/fFL0n
         80Xuv8nJVVQlA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 387B1C43140;
        Fri, 29 Jul 2022 21:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: fix test_progs -j error with fentry/fexit tests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165913081322.32307.9736154924263103124.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 21:40:13 +0000
References: <20220729194106.1207472-1-song@kernel.org>
In-Reply-To: <20220729194106.1207472-1-song@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, jolsa@kernel.org, rostedt@goodmis.org,
        andrii@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Fri, 29 Jul 2022 12:41:06 -0700 you wrote:
> Then multiple threads are attaching/detaching fentry/fexit programs to
> the same trampoline, we may call register_fentry on the same trampoline
> twice: register_fentry(), unregister_fentry(), then register_fentry again.
> This causes ftrace_set_filter_ip() for the same ip on tr->fops twice,
> which leaves duplicated ip in tr->fops. The extra ip is not cleaned up
> properly on unregister and thus causes failures with further register in
> register_ftrace_direct_multi():
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf: fix test_progs -j error with fentry/fexit tests
    https://git.kernel.org/bpf/bpf-next/c/dc81f8d1e8ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


