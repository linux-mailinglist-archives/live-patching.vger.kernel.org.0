Return-Path: <live-patching+bounces-1902-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 45824CB250E
	for <lists+live-patching@lfdr.de>; Wed, 10 Dec 2025 08:44:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3F1C930D05D6
	for <lists+live-patching@lfdr.de>; Wed, 10 Dec 2025 07:43:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C65824EF76;
	Wed, 10 Dec 2025 07:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/BNXHwO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D70779DA;
	Wed, 10 Dec 2025 07:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352594; cv=none; b=X4gWbonmzXe0vOVjw0I+cS+rmpkc3D9hbZnsENEkcxwWc70D1jdyMSEApq8PjZIKz2jMeE63nq8kdtuGom8YXEz+TgzYX8vNt1PcLb17yS4tm1aKAoQAtCY/LD5730UKuhHSik3lWajgyPraDse4Xb/nZHkRK8JypGh8PttujX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352594; c=relaxed/simple;
	bh=Qa0U3wUR5XTUVJO+JqYELhVIxRSs8ALZiy9GSpDUcTQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=lDjHG3ncmWeU4DLTwdXPD7npbDoZOOv+71oP2jX3VWeIxwcyz0nAfxMNu6wagbcjsq4VXj7qERX+mfUDrLJRo+SbRMo7dLVcA+H9aXih+CpN7tqFa3F48U+f/PPOk0t92lKoMKMF/HlQ1EHL+oZDkWGSQKxFxnJw1DdYAyR6ems=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/BNXHwO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5217C116B1;
	Wed, 10 Dec 2025 07:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765352593;
	bh=Qa0U3wUR5XTUVJO+JqYELhVIxRSs8ALZiy9GSpDUcTQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=T/BNXHwOW0a/FhtuHJnd96HnA3i0GHmWTVoQfYKSCxArF6HtdvXdM2zGwOvOcjjGh
	 G+8MG2xCweUpeyXVcD6OTR9s9CzHjf/cbC9UM8kZgg+bIPI0hfPqcDpClg38symLgp
	 1brZhHvmDFp3FjmOLsoglFkttHZl7Z1pBoPdPJsfU1r/U1omFeO78aRLZlDv5nKq4U
	 SGjZcZ8dGlED8T3iDKkIqapirgwv2uktmoYnOgFpKgt/BWqmJWDi1NGrufiURbb7Pj
	 p5vOorhLF8JqsuZ1lXxrSyj82S3+POnVU+39VQV+ZdraCItUL/HFFYsaR5QKNbW0mr
	 Nwt3wYgxYBn8Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B5A9A3809A18;
	Wed, 10 Dec 2025 07:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] bpf,
 x86/unwind/orc: Support reliable unwinding through BPF stack frames
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176535240855.490601.4190926018220042956.git-patchwork-notify@kernel.org>
Date: Wed, 10 Dec 2025 07:40:08 +0000
References: <cover.1764818927.git.jpoimboe@kernel.org>
In-Reply-To: <cover.1764818927.git.jpoimboe@kernel.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, bpf@vger.kernel.org,
 andrey.grodzovsky@crowdstrike.com, pmladek@suse.com, song@kernel.org,
 raja.khan@crowdstrike.com, mbenes@suse.cz, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, peterz@infradead.org

Hello:

This series was applied to bpf/bpf.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Wed,  3 Dec 2025 19:32:14 -0800 you wrote:
> Fix livepatch stalls which may be seen when a task is blocked with BPF
> JIT on its kernel stack.
> 
> Changes since v1 (https://lore.kernel.org/cover.1764699074.git.jpoimboe@kernel.org):
> - fix NULL ptr deref in __arch_prepare_bpf_trampoline()
> 
> Josh Poimboeuf (2):
>   bpf: Add bpf_has_frame_pointer()
>   x86/unwind/orc: Support reliable unwinding through BPF stack frames
> 
> [...]

Here is the summary with links:
  - [v2,1/2] bpf: Add bpf_has_frame_pointer()
    https://git.kernel.org/bpf/bpf/c/ca45c84afb8c
  - [v2,2/2] x86/unwind/orc: Support reliable unwinding through BPF stack frames
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



