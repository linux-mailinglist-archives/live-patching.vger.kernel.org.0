Return-Path: <live-patching+bounces-1797-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A9F2C06125
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 13:45:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0F63C188B06B
	for <lists+live-patching@lfdr.de>; Fri, 24 Oct 2025 11:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F39C830EF7A;
	Fri, 24 Oct 2025 11:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W2hd5zi8"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32F42580E2
	for <live-patching@vger.kernel.org>; Fri, 24 Oct 2025 11:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761306196; cv=none; b=BX3SS8tXKBL/FVhQspwjiRAnOiUVqtjsYicxl7kClgiZX0br8h0xXGBOYrn62eaoG1ov+evz7SK6wIFNmn5ynA0AZx4VRNQ6g3gE8dUXpsb8Lf35qGPwHfsWwLy+rWZauvrTOtHwtgRhYJe7ZxfsCkiaYMYjNRA0v88QcohGTvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761306196; c=relaxed/simple;
	bh=CZui3p+NqHREMsGpHs7m0KywPm9p3i9nKNibsoLTXQk=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pd/QrHJrlvpEx7PWLtch0r+258Pyj5xNPJqb5cD0Nf7vA/gSJKHd959i3L0AQ/5eJhn/vIHkVoB63NLFJy1gza+SNXvgBoTT5wrWFCKduyDUe19zI6ppain9dm5IrCSODH1U2i+PtRE17Uw9cjcdbPxZttGvVgyTj9P0Jxl8BxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W2hd5zi8; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47495477241so16402085e9.3
        for <live-patching@vger.kernel.org>; Fri, 24 Oct 2025 04:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761306193; x=1761910993; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=b18S4CmbOg3TG3MbWQlCwD9e5ZRL2nAAZ1ZNc6R+a5o=;
        b=W2hd5zi8mg9GtsRG5T91H58HFZto2aJJx+TPEEcWinUhJfscrbebdirdaztL8iBBS2
         mw/KUhLy4BG62nc8GorAjoQM1JoiZhCT2rpNnTc5ggz0eGyIPMgAD5evmWpC40TBV1SX
         uqHnb7nMAb1dV8z5OpMGAkzPZOBKTf7ujwKGxsGgKItVNTKbirf/vAd3Q+OZer7yo51L
         InjYzdk+yTBxIhOW/9utgvKaF7oubSHVA3Kseydg7Ad0iQVDAj+Dj4P99evsN6WFtxF+
         iVZMpjv7stUYIBOjX4dqEcgxZPVJSsVkKAigz2/3Qt+98thKCW9szTMeNcOEUUU8iBC1
         S9Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761306193; x=1761910993;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b18S4CmbOg3TG3MbWQlCwD9e5ZRL2nAAZ1ZNc6R+a5o=;
        b=r8yYe5Sn+XVqIfUAtkeMafieQ9HeAtiZNzv6NmlJGGgotyiaPgGR/xpeCvZwaqJGgl
         rejTpiVbT3a/nuSd9EFx8LrBc1MY/UX2LNLygAxHI238EgnxvwXj0ucs57Gft500UsVA
         by25WROIGKO+OOcla40D0U1hA/Somp290CkJYkfmFXTNBfmmGaxs6lclIpqA64ZL8dwB
         Uz4EufGOTT6fYyl62k27+UtBZ6xcj3V57taTuvCtTfbaj6h8Asru7HRixbmQMiK3Cu03
         HWpRTKOl74pD6sq2jD5XORPE76PNchHjxlWk3Qp7WyaaZ2W61X0Q4nLNzXZApXTtDXDM
         /ing==
X-Forwarded-Encrypted: i=1; AJvYcCX2ihGVyUJiiKPFsLhrzDo4K+Lrun0yQfPOL21yt6z89ZhrrKLs2jUK0Xggego4LgwkYKEG/3BDPFNLYn9H@vger.kernel.org
X-Gm-Message-State: AOJu0Yw97YDvf/eUW4qcmZNNCJStVve6E5MCwEiRoGR9dkGAMUC3LEBZ
	AlecuJ2lr5GwgQc3aQ5jKxKBx34CUs1ki4c9/NAP09clMy8LMqcjPCCP
X-Gm-Gg: ASbGncthbd+YUlct8DUDjFd43KWEQhoiVZnDe1J4ckZZcadrm7M1mbAPIXWBu1PDvN0
	Ju6H4pNBPfCoIaTYWxWUA/+TFPKe3mDS4Zdxpk3+4FGXUnB31tXS3B74YHoymg49CO1P3gaT0AU
	VFcrTK9izRY5fPNrDJ90g0eG9hEBDcet9ZB3ofJJJ6Rs7IjIYbvfY1H3BmdcVOG8LDHqO48Dzfj
	/KJ7sMd0pOEVJFPqBNIbd6aFu1+U6lyMwV9dChB5O+8fzy9o7moF2MZDnA0N7dGQCjXgaxMFG/5
	CtIX8zTpMRHjRnt0NsRphpsi0qvGlYm3xCFCMFz5Q41bUE9wDXpvV/yxAf37X8QkwK3etC6U1/3
	nh3usS5pXBbh4Qnylf6ATo/lzvvn2cUcyTQTRf9dC4uB3mXA25A==
X-Google-Smtp-Source: AGHT+IHpcyD6w06WvdrfkL+V8Avu/JoPzLSg/RttGHw9HhPaiYsYuNKZcx58iYrmG4o++/6PM8eOHg==
X-Received: by 2002:a05:600c:4f09:b0:471:a73:9c49 with SMTP id 5b1f17b1804b1-475caf930dfmr55560595e9.2.1761306192938;
        Fri, 24 Oct 2025 04:43:12 -0700 (PDT)
Received: from krava ([2a02:8308:a00c:e200::b44f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47494ac30b4sm82187635e9.2.2025.10.24.04.43.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 04:43:12 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Fri, 24 Oct 2025 13:43:10 +0200
To: Song Liu <song@kernel.org>
Cc: bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	live-patching@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, rostedt@goodmis.org,
	andrey.grodzovsky@crowdstrike.com, mhiramat@kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH bpf-next 2/3] ftrace: bpf: Fix IPMODIFY + DIRECT in
 modify_ftrace_direct()
Message-ID: <aPtmThVpiCrlKc0b@krava>
References: <20251024071257.3956031-1-song@kernel.org>
 <20251024071257.3956031-3-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024071257.3956031-3-song@kernel.org>

On Fri, Oct 24, 2025 at 12:12:56AM -0700, Song Liu wrote:
> ftrace_hash_ipmodify_enable() checks IPMODIFY and DIRECT ftrace_ops on
> the same kernel function. When needed, ftrace_hash_ipmodify_enable()
> calls ops->ops_func() to prepare the direct ftrace (BPF trampoline) to
> share the same function as the IPMODIFY ftrace (livepatch).
> 
> ftrace_hash_ipmodify_enable() is called in register_ftrace_direct() path,
> but not called in modify_ftrace_direct() path. As a result, the following
> operations will break livepatch:
> 
> 1. Load livepatch to a kernel function;
> 2. Attach fentry program to the kernel function;
> 3. Attach fexit program to the kernel function.
> 
> After 3, the kernel function being used will not be the livepatched
> version, but the original version.
> 
> Fix this by adding ftrace_hash_ipmodify_enable() to modify_ftrace_direct()
> and adjust some logic around the call.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  kernel/bpf/trampoline.c | 12 +++++++-----
>  kernel/trace/ftrace.c   | 12 ++++++++++--
>  2 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
> index 5949095e51c3..8015f5dc3169 100644
> --- a/kernel/bpf/trampoline.c
> +++ b/kernel/bpf/trampoline.c
> @@ -221,6 +221,13 @@ static int register_fentry(struct bpf_trampoline *tr, void *new_addr)
>  
>  	if (tr->func.ftrace_managed) {
>  		ftrace_set_filter_ip(tr->fops, (unsigned long)ip, 0, 1);
> +		/*
> +		 * Clearing fops->trampoline_mutex and fops->NULL is

s/trampoline_mutex/trampoline/

> +		 * needed by the "goto again" case in
> +		 * bpf_trampoline_update().
> +		 */
> +		tr->fops->trampoline = 0;
> +		tr->fops->func = NULL;

IIUC you move this because if modify_fentry returns -EAGAIN
we don't want to reset the trampoline, right?

>  		ret = register_ftrace_direct(tr->fops, (long)new_addr);
>  	} else {
>  		ret = bpf_arch_text_poke(ip, BPF_MOD_CALL, NULL, new_addr);
> @@ -479,11 +486,6 @@ static int bpf_trampoline_update(struct bpf_trampoline *tr, bool lock_direct_mut
>  		 * BPF_TRAMP_F_SHARE_IPMODIFY is set, we can generate the
>  		 * trampoline again, and retry register.
>  		 */
> -		/* reset fops->func and fops->trampoline for re-register */
> -		tr->fops->func = NULL;
> -		tr->fops->trampoline = 0;
> -
> -		/* free im memory and reallocate later */
>  		bpf_tramp_image_free(im);
>  		goto again;
>  	}
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 7f432775a6b5..370f620734cf 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2020,8 +2020,6 @@ static int __ftrace_hash_update_ipmodify(struct ftrace_ops *ops,
>  				if (is_ipmodify)
>  					goto rollback;
>  
> -				FTRACE_WARN_ON(rec->flags & FTRACE_FL_DIRECT);

why is this needed?

thanks,
jirka

> -
>  				/*
>  				 * Another ops with IPMODIFY is already
>  				 * attached. We are now attaching a direct
> @@ -6128,6 +6126,15 @@ __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
>  	if (err)
>  		return err;
>  
> +	/*
> +	 * Call ftrace_hash_ipmodify_enable() here, so that we can call
> +	 * ops->ops_func for the ops. This is needed because the above
> +	 * register_ftrace_function_nolock() worked on tmp_ops.
> +	 */
> +	err = ftrace_hash_ipmodify_enable(ops);
> +	if (err)
> +		goto out;
> +
>  	/*
>  	 * Now the ftrace_ops_list_func() is called to do the direct callers.
>  	 * We can safely change the direct functions attached to each entry.
> @@ -6149,6 +6156,7 @@ __modify_ftrace_direct(struct ftrace_ops *ops, unsigned long addr)
>  
>  	mutex_unlock(&ftrace_lock);
>  
> +out:
>  	/* Removing the tmp_ops will add the updated direct callers to the functions */
>  	unregister_ftrace_function(&tmp_ops);
>  
> -- 
> 2.47.3
> 
> 

