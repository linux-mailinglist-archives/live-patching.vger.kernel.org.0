Return-Path: <live-patching+bounces-1889-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AD93C9CB39
	for <lists+live-patching@lfdr.de>; Tue, 02 Dec 2025 19:59:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id BAD26342E4F
	for <lists+live-patching@lfdr.de>; Tue,  2 Dec 2025 18:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ACCC2D592E;
	Tue,  2 Dec 2025 18:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UJQ8Z3Jk"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6B02D47E1
	for <live-patching@vger.kernel.org>; Tue,  2 Dec 2025 18:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764701972; cv=none; b=qkW4NbtIlt3o4bgQDQrrsDpmFv+VmXYfgUaVJIABsHN45clitrNRnah6N9U1r6d3jhT4u8Rr2qJ48fU/fTMvFahDMcqqEWzr43aNBWZfbtmQxZYpQhU78spEvIVs10IfZKhElFk4pIhofgM/VMcD0zw0iDit9+SStmgpwp8Dp7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764701972; c=relaxed/simple;
	bh=qxGRTymQBdqEZRyZTYFMdPSWMq8Iwa6jq+qdbBbcZXM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JAbOLHBoYTsDvcU7WbXj9lgHCQIWzChaZP/+qjr/DTYLcFthFpbfiD1JGkOrk5sjWn5Gs74EeWEqOVXiV4FcFUnxzKLQXi+1Cfg3iL87wGd6TaqJz3odD+1qzNnVeBYcA+5IP+/+kTLCqqkqCIJl1v+Y9bXIclITgj30+9N10lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UJQ8Z3Jk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EF2C2BC9E
	for <live-patching@vger.kernel.org>; Tue,  2 Dec 2025 18:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764701971;
	bh=qxGRTymQBdqEZRyZTYFMdPSWMq8Iwa6jq+qdbBbcZXM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UJQ8Z3Jk1FPSv6I21WnU/e2LHrq3tO0on9tVGOJFaoLmlVqJ5KWP7Ee8yeG3eMMLD
	 /b13oCo7AgVp/NfcUVS/dItaycrWziVCzka9R+2cXc57nglrTwpnYoXIJVIDUC9XVB
	 kmtWyryAfop96P+/6bKJC/ObGXL+Bl5qHPszxcGr/Uurl6DoQe4nOZtfWHptHqoowD
	 RmXJ+ztrkZIiYA2DWfYj8BVS37kKPGMu6HQRqwO5gxSJ7oUOZhAeyOFyfrCzehg6tz
	 oR7Oynrf7nkvr6ypB4K1tnTWV6X+mfWTdFB5hSug9unlFUhiQ6yxmshlTd1Z2kHZRh
	 MvJkknU95VtcA==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-88056cab4eeso39783206d6.2
        for <live-patching@vger.kernel.org>; Tue, 02 Dec 2025 10:59:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWtNEH6ajNKC7IrcsSIw7E6k5Mf8UiX2p4LcCdIU7CsH0VOlgMNRognqHdWcxCbDgNJTe9itp4b98JQXkRl@vger.kernel.org
X-Gm-Message-State: AOJu0YxPE2zIQPi4R8CTXkw4IZhWmGzXmehQ8HuD5VVcq7MOZn16jHAC
	dmofom/e8dVAa4BhjDZVZZ4YEY/954KGdS1hG8WznDJyRUtKhqA3IrjuQaAaDLKcCJ7TmFazda0
	mBYYBX8Ybz3oa927ka08c/2Ra+VRrH0E=
X-Google-Smtp-Source: AGHT+IERIQolTMr7/trLG3nUJaBpnN2g+JP43RsLxHzGOLxR0dS54ZVVaPc0PsQkgDHz4yCAhK4vZZt9cnVIYrO4qF4=
X-Received: by 2002:a05:6214:3286:b0:785:aa57:b5bb with SMTP id
 6a1803df08f44-8863af9e4e2mr453435506d6.43.1764701970731; Tue, 02 Dec 2025
 10:59:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1764699074.git.jpoimboe@kernel.org> <26bf6f9106478d5e5dd447b21ee15ebe84e0f7cd.1764699074.git.jpoimboe@kernel.org>
In-Reply-To: <26bf6f9106478d5e5dd447b21ee15ebe84e0f7cd.1764699074.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Tue, 2 Dec 2025 10:59:19 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5+0F1rVvYyWCq+cAOim2=FE3FmVMH23sLr1Vft55FGpg@mail.gmail.com>
X-Gm-Features: AWmQ_bmQO-oEm-xFG7pYXFS2duq6lVviNG72-HJEnh6TYDect5JbMECFd-M6R3w
Message-ID: <CAPhsuW5+0F1rVvYyWCq+cAOim2=FE3FmVMH23sLr1Vft55FGpg@mail.gmail.com>
Subject: Re: [PATCH 2/2] x86/unwind/orc: Support reliable unwinding through
 BPF stack frames
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, bpf@vger.kernel.org, 
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>, Petr Mladek <pmladek@suse.com>, 
	Raja Khan <raja.khan@crowdstrike.com>, Miroslav Benes <mbenes@suse.cz>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 10:20=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> BPF JIT programs and trampolines use a frame pointer, so the current ORC
> unwinder strategy of falling back to frame pointers (when an ORC entry
> is missing) usually works in practice when unwinding through BPF JIT
> stack frames.
>
> However, that frame pointer fallback is just a guess, so the unwind gets
> marked unreliable for live patching, which can cause livepatch
> transition stalls.
>
> Make the common case reliable by calling the bpf_has_frame_pointer()
> helper to detect the valid frame pointer region of BPF JIT programs and
> trampolines.
>
> Fixes: ee9f8fce9964 ("x86/unwind: Add the ORC unwinder")
> Reported-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
> Closes: https://lore.kernel.org/0e555733-c670-4e84-b2e6-abb8b84ade38@crow=
dstrike.com
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

