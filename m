Return-Path: <live-patching+bounces-1831-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 22976C2ED24
	for <lists+live-patching@lfdr.de>; Tue, 04 Nov 2025 02:40:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C369F343D4F
	for <lists+live-patching@lfdr.de>; Tue,  4 Nov 2025 01:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3E01219E8D;
	Tue,  4 Nov 2025 01:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQMdp11x"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB257215F42;
	Tue,  4 Nov 2025 01:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762220435; cv=none; b=nHQZNnRj28Al5vZPyMjBRMpDcRAhAkvktlAD04HMfR9H8+K/M1oLL9O8X3PPusZmUq9kS4r0wN54ogkC1pW4bJDi7GFxX8hzApG/xaMaBnXIx10l7Y62va1OjcgEcK4D13F1hInC+KpnSweJ+VeJO4VQMOOGLvFmVsdfS/tvQIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762220435; c=relaxed/simple;
	bh=lzOD0CVb2YW225N81+aQO9LxHdybwn5EIDNjriISPz0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=PQracFoUsTUjl+hCJRuvcn3Y0bzr92vjSmhK52T03CHu6eGK9Wwtt9hY9F8Nslsh91yQx+lY8gD97xNJ+yGMJt4AAaey5RS8QgP/GMj++HHZZkQPfOA9ozFP1VJXb6GCGVROMj05zc6+itz2fH1Ea08g5EcVHTXCVSrXOm58Ts8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQMdp11x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F2B6C4CEE7;
	Tue,  4 Nov 2025 01:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762220435;
	bh=lzOD0CVb2YW225N81+aQO9LxHdybwn5EIDNjriISPz0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UQMdp11xSxb02bAhmfbmZypSvTMo1odhWNX3rfXzexvPk1C38VqukMF3CvVUqqX+N
	 hJH13fbUM6iF5GGukBizaevpm0ZhTysRKesf/TCGolVJ6hGgl/Jl9/8q6g+h6hh9s6
	 LWb08loFlHMZJj4PvMfKDxzNNw5FiMHupL9DLpILRNJnst3iRB4Ay7y/tqy6iuthSh
	 j9E7CkN4c7jE+9/CpWK/gCt1o7xJlHNdGzObD2FWEepy1qAT/vjNDV2X9YCjULHGni
	 oJKWKpboRCQA3bcGBQkndsTY5fsWJ7N80JFWpF0GNnsO995FzNOJt6fu1GSd3axLOI
	 uj3SErnAtuQWA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB0203809A8A;
	Tue,  4 Nov 2025 01:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 bpf 0/3] Fix ftrace for livepatch + BPF fexit programs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176222040973.2285814.7620331983451064735.git-patchwork-notify@kernel.org>
Date: Tue, 04 Nov 2025 01:40:09 +0000
References: <20251027175023.1521602-1-song@kernel.org>
In-Reply-To: <20251027175023.1521602-1-song@kernel.org>
To: Song Liu <song@kernel.org>
Cc: bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 live-patching@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
 andrii@kernel.org, rostedt@goodmis.org, andrey.grodzovsky@crowdstrike.com,
 mhiramat@kernel.org, kernel-team@meta.com, olsajiri@gmail.com

Hello:

This series was applied to bpf/bpf.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Mon, 27 Oct 2025 10:50:20 -0700 you wrote:
> livepatch and BPF trampoline are two special users of ftrace. livepatch
> uses ftrace with IPMODIFY flag and BPF trampoline uses ftrace direct
> functions. When livepatch and BPF trampoline with fexit programs attach to
> the same kernel function, BPF trampoline needs to call into the patched
> version of the kernel function.
> 
> 1/3 and 2/3 of this patchset fix two issues with livepatch + fexit cases,
> one in the register_ftrace_direct path, the other in the
> modify_ftrace_direct path.
> 
> [...]

Here is the summary with links:
  - [v4,bpf,1/3] ftrace: Fix BPF fexit with livepatch
    https://git.kernel.org/bpf/bpf/c/56b3c85e153b
  - [v4,bpf,2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in modify_ftrace_direct()
    https://git.kernel.org/bpf/bpf/c/3e9a18e1c3e9
  - [v4,bpf,3/3] selftests/bpf: Add tests for livepatch + bpf trampoline
    https://git.kernel.org/bpf/bpf/c/62d2d0a33839

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



