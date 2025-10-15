Return-Path: <live-patching+bounces-1753-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 00779BDEADC
	for <lists+live-patching@lfdr.de>; Wed, 15 Oct 2025 15:12:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 68A954F1500
	for <lists+live-patching@lfdr.de>; Wed, 15 Oct 2025 13:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2746E3233EE;
	Wed, 15 Oct 2025 13:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="SOn5znxd"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55BB31D38C
	for <live-patching@vger.kernel.org>; Wed, 15 Oct 2025 13:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760533827; cv=none; b=ssw6OzdD5nnKyEHavvFW66KNI8hs3sA9Y2fppakW90lA/Teo4LcESF3DGmmS6xa+kCYRYxIm/+X1D3wjHzWE7JepOADSweQmljGLUdGnSZ0sNJ7koY5PfNUBO2yEusdSHKPhEpmEK7W65Q3Ff50JfwgCROS+OHFbEhezA+BiMbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760533827; c=relaxed/simple;
	bh=yZvPSemDJmujYQJqSbEpjlYvobwClsNXhSzXnC/AwmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ILuTudP819ROrQbcM/Yxgoo65glhlByWW+Y3pME6sxksAtOKi8NcdH9AiPj3KwHMk9PZjtWT3dPtNF/BCTRGKpM5AGSBPEcsUrr5H+qeUeakxwcOc+2pryFcBBaPjQ0JVl3YGZ5PcWHHfeWg9JVzkWDvpe+5iM4ZBdpt+f4beQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=SOn5znxd; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46b303f755aso58358785e9.1
        for <live-patching@vger.kernel.org>; Wed, 15 Oct 2025 06:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760533823; x=1761138623; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ykx2GQz+96wpwXjuDb3ApIQKn+vmnlBhCM/1P2RoS9o=;
        b=SOn5znxdVTV0ck31dct7jiHwbLxzaGQ8kqsnK7kpsp6yKoUq5O3yl1sVng/ZUeM8ms
         LIBMPpsbvrIcnafSm7FlRpVPYcZdRNLvCbIXaKYDPBCalvQiNJJ120j40gAoPuOlLogo
         qGYJsVFfotePcdMHwaW+eHICM1/ddTiHW4KUgWwQOyuCOyMgsYEQ7CF8EgNgh/xtzVUz
         fDT+qq+zGLP69lKx8aczrP3xKoYEJNxQU4Pd+4SCwSfReBGpjTT5K680Z0xVptug2ub1
         im2yt9RK+KFLXysD6vze2XHYojKTc1Xg5DIL6+hynyB2k6Ka8lVjR+LutWidUMJ7IpSi
         hesQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760533823; x=1761138623;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ykx2GQz+96wpwXjuDb3ApIQKn+vmnlBhCM/1P2RoS9o=;
        b=XbtHLbOflYJn3Vby0yG598ZZrASxcdSMbjarsPW/EI14HonrbPpmMZJo1Szvu2aZR/
         mHkAHkt4np60eQf4Rkq9a4X9i1tCmvvU0cQMkX3fso8QIvYDKeohGmB04B4776n8PWnN
         luYKxhDkpPJWkZdXsiWOTCoUsY2OgJYN2XhN1DPiIMzOYaagynFZoKgD+XVlSiB+9afm
         CLlQvz6pd7V5gCc3Cryu9amHpzyKzuDIWjic+QU1lDjj09YI/e5dXZvud/gx4On0QvLy
         OfNCfZfXrR5iGqXKglMGBPmnLGlLd9Lpatl2js3IBE7gLrqCr5lAUhLNGz9IASAWXH5o
         b8rw==
X-Gm-Message-State: AOJu0YxeFvKUhIRZf7/7MN/cmPzQPrBrBB4LcJYOUpgfiaMH2p63xdmd
	/RMeL3TezGb7DU+hPyn4xIIuxGqikrJLc0ZCBT+4HY1ZAoDBOv3JXGoAwbgEoBljgNQ=
X-Gm-Gg: ASbGncvo4RzrTLYQKZLWXBirTzq/O/y5y0MahFOd/RJ22cfgUZaepF59QVTnERpO88g
	vLPO5g+5XxGIYI5lDbi+T1kxuGpbxEIjDyUY0RzI6O6buKMuEyKokRVF1XBYJxHbpv/X4ZIhW7x
	0aJ4RQcaJqCi2GVaQsMABt/yklgUC0VGtRdNiOpxNkELBC/ZYacsywP5J0gWg+Z4e/SxmVq5GRK
	PZjR0ccC1C0vrYPHz7UFjct32tNKALAQsS+3SP8TvgOzkv+xwuFq/oBOuHpvZEjMWA7yynW//Pt
	IcaUuw66zHxH8dkjbw0K/8cTPuGKErDeWmbLKu92vIYtgHCAiTn+Lr4mciFEoZxUQioIBvbU0Wi
	IqvUDgszg5npYE3bD7s4tIqGiWHd47t+WeKRmLk+oCC+f
X-Google-Smtp-Source: AGHT+IFYkt/oUuVCbvGRrxSPJnxkuXAmJLOmMYujaBInN6Rtjjn17LQRuoRXWm+lqupLeJIlFDSu5g==
X-Received: by 2002:a05:600c:a02:b0:46e:4499:ba30 with SMTP id 5b1f17b1804b1-46fa9b052f2mr214906725e9.30.1760533822958;
        Wed, 15 Oct 2025 06:10:22 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab36a773sm185598825e9.0.2025.10.15.06.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 06:10:22 -0700 (PDT)
Date: Wed, 15 Oct 2025 15:10:20 +0200
From: Petr Mladek <pmladek@suse.com>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, joe.lawrence@redhat.com, kernel-team@meta.com
Subject: Re: [PATCH v2] livepatch: Match old_sympos 0 and 1 in klp_find_func()
Message-ID: <aO-dPImgapKJRQrw@pathway.suse.cz>
References: <20251013173019.990707-1-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013173019.990707-1-song@kernel.org>

On Mon 2025-10-13 10:30:19, Song Liu wrote:
> When there is only one function of the same name, old_sympos of 0 and 1
> are logically identical. Match them in klp_find_func().
> 
> This is to avoid a corner case with different toolchain behavior.
> 
> In this specific issue, issue two versions of kpatch-build were used to

  s/issue, issue/issue/

> build livepatch for the same kernel. One assigns old_sympos == 0 for
> unique local functions, the other assigns old_sympos == 1 for unique
> local functions. Both versions work fine by themselves. (PS: This
> behavior change was introduced in a downstream version of kpatch-build.
> This change does not exist in upstream kpatch-build.)
> 
> However, during livepatch upgrade (with the replace flag set) from a
> patch built with one version of kpatch-build to the same fix built with
> the other version of kpatch-build, livepatching fails with errors like:
> 
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -88,8 +88,14 @@ static struct klp_func *klp_find_func(struct klp_object *obj,
>  	struct klp_func *func;
>  
>  	klp_for_each_func(obj, func) {
> +		/*
> +		 * Besides identical old_sympos, also condiser old_sympos

As Josh already pointed out:

   s/condiser/consider/

> +		 * of 0 and 1 are identical.
> +		 */
>  		if ((strcmp(old_func->old_name, func->old_name) == 0) &&
> -		    (old_func->old_sympos == func->old_sympos)) {
> +		    ((old_func->old_sympos == func->old_sympos) ||
> +		     (old_func->old_sympos == 0 && func->old_sympos == 1) ||
> +		     (old_func->old_sympos == 1 && func->old_sympos == 0))) {
>  			return func;
>  		}
>  	}

With the two above fixes:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

I have fixed both problems when committing.

And the patch has been committed into livepatching.git,
branch for-6.19/trivial.

Best Regards,
Petr

