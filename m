Return-Path: <live-patching+bounces-1892-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id EFE63C9D4BA
	for <lists+live-patching@lfdr.de>; Wed, 03 Dec 2025 00:11:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D669134B195
	for <lists+live-patching@lfdr.de>; Tue,  2 Dec 2025 23:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2DD2FC029;
	Tue,  2 Dec 2025 23:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gL3NvrUt"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF52B2F746C;
	Tue,  2 Dec 2025 23:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764717018; cv=none; b=HN8UJzA4AxscB+M/KimCTkPDqLyWgBpvJf3Xfs8ccAIayOmKL4gAWn5AYxiYj9UYjSeFVSC43y0fgCpND67CapPyv5DcFxwWP9jRchAfetBirwuLgO95FZmbYDEzS6rtwr8uE6dPiQrAMq/V1YuaUjYYPFIqKttvOQwc5B4qMDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764717018; c=relaxed/simple;
	bh=tRCsOuX/ksBhSmQ5Q3cp/aypjTFPIG6+CglTNauCLiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LRMwEPboUcqzDRTv3dv9iE7p+JDFp8/Fgh13Z53hU27OYS/xxqs5pMePOPtoe+bJKY2F4VtlxxJEytv1hst6YA/7miIRfw6udCldNCXl8O9Uchgkn5JesSuLDE+HznIw1H6s0W5M0T6S1Mhe5NJ81tBYOb8dpJEfnziDNKN9fRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gL3NvrUt; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928B6C4CEF1;
	Tue,  2 Dec 2025 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764717017;
	bh=tRCsOuX/ksBhSmQ5Q3cp/aypjTFPIG6+CglTNauCLiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gL3NvrUtH2Kr7e4B3vLMtnNl/QfFY/0Ny1shXVC8E/oduudy03aibuRp0OrzQJJZG
	 w6myq0g0Pg9wlrpTFM+PUEzStv4gLzr6J6kkhgrNns97GedkuqR9ef6h9i2D4ZwWCb
	 f+uAlxiUmqlXV9cl2459RqHzClj/t60wR7Ivnw2ZY4EZHKIThEMrxO3FMIjrzmpLe/
	 BQR6bqIGH1QHbCDPMI87cPa8h4DHoTRcYimWy2EETwoJVHtOfyz0cq9sl1HvbdTlTE
	 Tg9SFzjfem2Rx1HkWy1cyL79ciVfSL5mwfuk5votpf3jouUgmrc65aq8ZRAKOHjR0e
	 YIOQZvHrC2k8Q==
Date: Tue, 2 Dec 2025 15:10:15 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	bpf@vger.kernel.org, Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>, 
	Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>, 
	Raja Khan <raja.khan@crowdstrike.com>, Miroslav Benes <mbenes@suse.cz>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/2] bpf: Add bpf_has_frame_pointer()
Message-ID: <6l5jgeoajy7jtkpfpk7iaglmauyempa4uctbvn32syrmgvqqej@ls7qvu2nqpir>
References: <cover.1764699074.git.jpoimboe@kernel.org>
 <c2764d2ad229d0bcea21dbb774e2494ca34fc130.1764699074.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c2764d2ad229d0bcea21dbb774e2494ca34fc130.1764699074.git.jpoimboe@kernel.org>

On Tue, Dec 02, 2025 at 10:19:18AM -0800, Josh Poimboeuf wrote:
> @@ -3299,6 +3304,8 @@ static int __arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *rw_im
>  	}
>  	EMIT1(0x55);		 /* push rbp */
>  	EMIT3(0x48, 0x89, 0xE5); /* mov rbp, rsp */
> +	im->ksym.fp_start = prog - (u8 *)rw_image;

CI is reporting NULL pointer deref here, @im can be NULL.  Will fix.

-- 
Josh

