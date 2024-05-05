Return-Path: <live-patching+bounces-235-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0059F8BC3D7
	for <lists+live-patching@lfdr.de>; Sun,  5 May 2024 23:00:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4634EB2147A
	for <lists+live-patching@lfdr.de>; Sun,  5 May 2024 21:00:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AEFA7580E;
	Sun,  5 May 2024 21:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Km+UI4VF"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082FA6CDBD;
	Sun,  5 May 2024 21:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942827; cv=none; b=i1ULQ00nUbaBYC1J0cTVBaRcfhpWrwuzDL/X315DHkD1L0OYuDfQz+xWVUJsiCDlQwctYMEKemauWvOymhNIeKJna0Vx2hCdPtnt+v9gbIh2keDm+s/UaN1F9zV2yL2Rdhz/NapHn8bYLU9PZhamFAqCZfkiqL0n+ipzvXdPEks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942827; c=relaxed/simple;
	bh=9xjsM37E5E5cOsGCqAL/S0VNAfQ7SyGuZPJpH+QQFJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZKc57wbQy31kVxoUvNRdqLhjP4BOQkxGFrw+f1A3s2/oKKugsS/4ohDrQr8MO9YvUBHZyj9NFpNsgpslTROKdX/bCHQb3nVm8CnPz4bBVHKzJfw7+410a8jNebB5i7JX1IlZRP9yynW4IP/QMmeznXrzTnup5+bqYUoshKWQ6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Km+UI4VF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D70CC116B1;
	Sun,  5 May 2024 21:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714942826;
	bh=9xjsM37E5E5cOsGCqAL/S0VNAfQ7SyGuZPJpH+QQFJ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Km+UI4VFWIEaDG7cb5rw9YDN4URq3V9hzWc6thk4F5A6IZRsDAEVPRt9880/SloLM
	 FhjRsVOZE402opeGfce1jcVUMTHUJdghTCNK+BzCFgjA2F29oSURdp/0u3LYAHpnS4
	 iDQ73j9RD9yVMPAnaA7KX2vNK9/fu3xTRzoqYQcJ8xAIhjJaEUPNf93h6yxXXxrJBI
	 J748+8ZvSYVwl0M4WB6bRwoM5oqZF8ewwzNvpd+JzwRK65HeJlxFdwym3a7R7YY7ig
	 RBoscvl2MFvW7tWIaaF+CQiIEyHEbGmg5r6jKThU6iTFz42kmKtRK3pZSvuN3DV2++
	 vV4nYOPaUjNnQ==
Date: Sun, 5 May 2024 14:00:24 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: zhangwarden@gmail.com
Cc: mbenes@suse.cz, jikos@kernel.org, pmladek@suse.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch.h: Add comment to klp transition state
Message-ID: <20240505210024.2veie34wkbwkqggl@treble>
References: <20240429072628.23841-1-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240429072628.23841-1-zhangwarden@gmail.com>

On Mon, Apr 29, 2024 at 03:26:28PM +0800, zhangwarden@gmail.com wrote:
> From: Wardenjohn <zhangwarden@gmail.com>
> 
> livepatch.h use KLP_UNDEFINED\KLP_UNPATCHED\KLP_PATCHED for klp transition state.
> When livepatch is ready but idle, using KLP_UNDEFINED seems very confusing.
> In order not to introduce potential risks to kernel, just update comment
> to these state.
> ---
>  include/linux/livepatch.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index 9b9b38e89563..b6a214f2f8e3 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -18,9 +18,9 @@
>  #if IS_ENABLED(CONFIG_LIVEPATCH)
>  
>  /* task patch states */
> -#define KLP_UNDEFINED	-1
> -#define KLP_UNPATCHED	 0
> -#define KLP_PATCHED	 1
> +#define KLP_UNDEFINED	-1 /* idle, no transition in progress */
> +#define KLP_UNPATCHED	 0 /* transitioning to unpatched state */
> +#define KLP_PATCHED	 1 /* transitioning to patched state */

Instead of the comments, how about we just rename them to

  KLP_TRANSITION_IDLE
  KLP_TRANSITION_UNPATCHED
  KLP_TRANSITION_PATCHED

which shouldn't break userspace AFAIK.

-- 
Josh

