Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE6457E808
	for <lists+live-patching@lfdr.de>; Fri, 22 Jul 2022 22:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236690AbiGVUKR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 22 Jul 2022 16:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236638AbiGVUKQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 22 Jul 2022 16:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDF911448;
        Fri, 22 Jul 2022 13:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDFDE61F5E;
        Fri, 22 Jul 2022 20:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E828C341CA;
        Fri, 22 Jul 2022 20:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658520614;
        bh=H5j29TD1aac05Kotttybo0+H5KC0UQYvJJI3ZOxcHjU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h9SO7/gwY+zSz6CZh1/ATQ6T/fa5QnnYojhkDX7YzNiTvJzwOKLihL37gEdUCmgFW
         ARIeKhPosnLFWc6m8eB9M4UftoPas9bsVZpRQcttp5uMyXnSpECJg3nKBajpauFRHh
         F0OG18DJfuNt3C9BnqLUSqi6h+RjJy4jF5+sVBDwc1c9wGgJfo329KJjuKgPzAIQVD
         W0OlbR40aFGlYF2eQJqLEjqqgkocqd6UQWOfPCiNPfspIsOQZ5IOEhC9VUu4k9lTsf
         ++4dAOA3uGKC5SNdwbDlnagdW4nQUrYTtHvqMQysojuGR9voE1+gFvLXcx7o9/9tRf
         OsKtMLSTnXbSQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12A50E451BB;
        Fri, 22 Jul 2022 20:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 bpf-next 0/4] ftrace: host klp and bpf trampoline together
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165852061406.17882.15043433276735332820.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 20:10:14 +0000
References: <20220720002126.803253-1-song@kernel.org>
In-Reply-To: <20220720002126.803253-1-song@kernel.org>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, jolsa@kernel.org, rostedt@goodmis.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 19 Jul 2022 17:21:22 -0700 you wrote:
> Changes v4 => v5:
> 1. Cleanup direct_mutex handling in register_ftrace_function.
>    (Steven Rostedt, Petr Mladek).
> 2. Various smallish fixes. (Steven Rostedt, Petr Mladek).
> 
> Changes v3 => v4:
> 1. Fix build errors for different config. (kernel test robot)
> 
> [...]

Here is the summary with links:
  - [v5,bpf-next,1/4] ftrace: Add modify_ftrace_direct_multi_nolock
    https://git.kernel.org/bpf/bpf-next/c/f96f644ab97a
  - [v5,bpf-next,2/4] ftrace: Allow IPMODIFY and DIRECT ops on the same function
    https://git.kernel.org/bpf/bpf-next/c/53cd885bc5c3
  - [v5,bpf-next,3/4] bpf, x64: Allow to use caller address from stack
    https://git.kernel.org/bpf/bpf-next/c/316cba62dfb7
  - [v5,bpf-next,4/4] bpf: Support bpf_trampoline on functions with IPMODIFY (e.g. livepatch)
    https://git.kernel.org/bpf/bpf-next/c/00963a2e75a8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


