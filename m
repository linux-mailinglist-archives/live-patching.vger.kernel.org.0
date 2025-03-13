Return-Path: <live-patching+bounces-1275-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88D1BA5FF01
	for <lists+live-patching@lfdr.de>; Thu, 13 Mar 2025 19:15:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0EE77AF490
	for <lists+live-patching@lfdr.de>; Thu, 13 Mar 2025 18:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 826CA1EE7BB;
	Thu, 13 Mar 2025 18:12:55 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1DF1E51EE;
	Thu, 13 Mar 2025 18:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741889575; cv=none; b=RVEHs+J7+TZxEMWXUc62S7YP8INzdTc1jflS+uqz0XUpfjvuUapCDoHbUVk8eZZebAw9GLYqMZSOI9sfcRmIJ5DDsCgBhv/Fm0dtpliOsh6Gx64TONaTVuDqX+E08+3hCvTtQf4UcNDI1KSc9q6ESxLTftWSefmJzsk9TOC6734=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741889575; c=relaxed/simple;
	bh=w7h+C1e3nKxZHfNJfAwxyAknU7YcoWF3GaRMfx+P8u4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BrOfZ5F0W9BsMknK2xUg11eKrR5K+2YIDQlqXzalC4aj6rk1DWivDp8xznQiHL4jGJVnSi2w4oMyVxPQnPvB9fNB80/crXchmXhi1C/dtHOQvmDgZcDyBZA/+GiICkmTmd5iHifEfZnpAd8f41WcuKz02gz9/2GSNaYmW+gAwSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aaeec07b705so206486666b.2;
        Thu, 13 Mar 2025 11:12:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741889572; x=1742494372;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vYxlmv810ezcplIPoQtIO8dfhKLPRYFog6EoMaT+7UQ=;
        b=drOUxEMDEg/TrCLOgb90n83e0hbqOc+Q06aJBiEG2qIUUYa5MyA6BgbTQwZR5JweUv
         /t+81ldW4gqnp0gjYWd2EWelSVxs7OTx06kSfbNY34BlztXl9l7lWsJwZvXCP6C8G8KS
         lzse6qtpeH3jnC9MYIKvnVFVdKUmTyvi8zbIv0ZfmsnvL3EP2kmEgGgCuuPdnQv8yFmS
         WEKkksn4S05CsDphsMHtY3evk5Q38vC6uSjQchvyOJ4SPeg6MOtTdw8QJrUoh97JXO6l
         lrHRa6iP22+ET7rz6dTCh7YShxmSttZq7iQEJl39Ri96GatLGmkPBDTepnBNxxVPULE7
         9ZqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQXLa/Bh95aoh8lR+LUkg5/8ovh8ASM93nP2LrDIyIJPiNwEzHyMUYsCHhZJfJDxylhTQWAwJSuGDDTn+O9A==@vger.kernel.org, AJvYcCVihu3ypBa/L8Vyd08MeS1yjCj4spNdsC1GAU4MpV5bh/oAVRGMUNe5tNo7FJq37Ad87q36gNXGLdQQx3U=@vger.kernel.org, AJvYcCXKU9q7FJ2yPGKBTbHnKNrmAqL1i6xByJxh261PkUaFecGcoxZ+eNoyzqVX2Z2YoNNTDuMppe2iPEgoSu1E0s9e/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwVGnizalTHoFyXMWdPyXDgAiIxL09qsvQ9oiXUi5Uvl+21fwkB
	z/V6iOUGOXMbiAcf3pf5mzJ2Ife1YBjMKoSV1tF2e9DL0Z7aHjJN
X-Gm-Gg: ASbGncspz4cQvoroBLtMUX4QV97kj2hHOK8Grf2/CwgqvLpau+qbejx/tx6DrAaQYE1
	XUwxcTMVg3Fzsj/QvWRxMM2DySXKJolZMAULX5qmCgLh0z8kRJ2b4ElgNxSg00yZ4VON7Wa+XR3
	0WwJWQJPPA3+cS7lk7mzclawKNumaDXuHGavHVEiu/hUCAebBoJj7aJ026Q06GI5rSRzDwGoU/1
	lCFwO0NqWF4qM52aQ3lS0v+hD/fNeFd3N1LWHQPLXEGgL3KZM9eVQ4Ab+peEw3oToT1bKQ/N/9D
	AlUG9RTs0u9R8hue62Ps8Hr26SnVxegdHXSIko2+0hNsuQ==
X-Google-Smtp-Source: AGHT+IEIROBjcQc5+N5Ug6gFEtowlLLgmIvSl5IlxYNgNSYZ+MT7JS4kaQNvmVgwY2CUORVYXQi9zQ==
X-Received: by 2002:a17:906:59a1:b0:ac3:aa7:fa07 with SMTP id a640c23a62f3a-ac30aa7fbd8mr405245766b.44.1741889571403;
        Thu, 13 Mar 2025 11:12:51 -0700 (PDT)
Received: from gmail.com ([2a03:2880:30ff:3::])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac314a4856csm107427266b.156.2025.03.13.11.12.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 11:12:50 -0700 (PDT)
Date: Thu, 13 Mar 2025 11:12:48 -0700
From: Breno Leitao <leitao@debian.org>
To: Song Liu <song@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-toolchains@vger.kernel.org, live-patching@vger.kernel.org,
	indu.bhagat@oracle.com, puranjay@kernel.org, wnliu@google.com,
	irogers@google.com, joe.lawrence@redhat.com, jpoimboe@kernel.org,
	mark.rutland@arm.com, peterz@infradead.org,
	roman.gushchin@linux.dev, rostedt@goodmis.org, will@kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/2] arm64: Implement arch_stack_walk_reliable
Message-ID: <20250313-angelic-coral-giraffe-dfa4f3@leitao>
References: <20250308012742.3208215-1-song@kernel.org>
 <20250308012742.3208215-2-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250308012742.3208215-2-song@kernel.org>

On Fri, Mar 07, 2025 at 05:27:41PM -0800, Song Liu wrote:
> With proper exception boundary detection, it is possible to implment
> arch_stack_walk_reliable without sframe.
> 
> Note that, arch_stack_walk_reliable does not guarantee getting reliable
> stack in all scenarios. Instead, it can reliably detect when the stack
> trace is not reliable, which is enough to provide reliable livepatching.
> 
> This version has been inspired by Weinan Liu's patch [1].
> 
> [1] https://lore.kernel.org/live-patching/20250127213310.2496133-7-wnliu@google.com/
> Signed-off-by: Song Liu <song@kernel.org>

Tested-by: Breno Leitao <leitao@debian.org>

>  arch/arm64/Kconfig                         |  2 +-
>  arch/arm64/include/asm/stacktrace/common.h |  1 +
>  arch/arm64/kernel/stacktrace.c             | 44 +++++++++++++++++++++-
>  3 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 940343beb3d4..ed4f7bf4a879 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -275,6 +275,7 @@ config ARM64
>  	select HAVE_SOFTIRQ_ON_OWN_STACK
>  	select USER_STACKTRACE_SUPPORT
>  	select VDSO_GETRANDOM
> +	select HAVE_RELIABLE_STACKTRACE

Can we really mark this is reliable stacktrace?  I am wondering
if we need an intermediate state (potentially reliable stacktrace?)
until we have a fully reliable stack unwinder.

Thanks for working on it.
--breno

