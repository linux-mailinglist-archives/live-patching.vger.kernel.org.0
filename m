Return-Path: <live-patching+bounces-567-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 47B1196964F
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 09:58:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A31A1C233E4
	for <lists+live-patching@lfdr.de>; Tue,  3 Sep 2024 07:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA72200107;
	Tue,  3 Sep 2024 07:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lMDjCN0N"
X-Original-To: live-patching@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A631CE6E9;
	Tue,  3 Sep 2024 07:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725350299; cv=none; b=DuflIPd1loYvtoyB3IP3rIB0PI+505LzSfbhRT7U4p5N+OD8GU0lVvuY5/ew8ImczBN/KK9qgWoBbDEVfmhGTjMGUGUVPmVxlRn6hX5z2ch0cn9S+2gGHKe0o0WS/VWn9V1HiIApPer4LTMQW9XkeSMGx1M53xOlWF2qSb5EpRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725350299; c=relaxed/simple;
	bh=4D3S/BsYGaQ3l4dc2jnl4uMpwjFH30GUssAHsELqCXY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NPDRtsCetUAFvHGl/foM+5UYePPd0MEhghPfxzn5rEvZwodM2ZE6QbXa+NRMimMDn3vy8S25nuIbUv/XI1RIlCZMlArZGdG4Tz7xy+VF8xzTpFISh8IekSWfDMgh39bu+hhhydGVPRwmLoP2TlEYTRSDK5FMZj5KufI89bIH3f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lMDjCN0N; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oe/Wg4+NW65ewgXCzrrA8wLdgceb0z2I9Xk2kIKnGP0=; b=lMDjCN0NTIGBN96OCJPPGqbGnx
	5x7tMeBslfxs7lvVRM5tuYzcoE9sSzCGWpY57AJDEciiDjliAB+K8nzHPW6glXDe6dYGDtjkeQN2t
	JhYxqPWyxbcnj8roiHKeUQ58T0tgiSHeAhOAQiLnCrdvFrGk5tMfzoNr5QTehhdSEQpChAwGvl0hK
	JNfDfT0ZTM7BZ6N/7xneSkZq1V5ue9A6pz8u1hkCiAhMu3o9x4h2Bnt6EVLBU8X8VzQrdk35jFK1n
	sYOdnYzv0ywI2859TtKubPSj1NKNxR4wOjuwTz4RAyjWe5AN58jwtCFdgXU3NDe318ljfPrH5k+b6
	zAbnJkWQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1slOQY-0000000CHjc-20J3;
	Tue, 03 Sep 2024 07:58:14 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E2EC6300390; Tue,  3 Sep 2024 09:58:13 +0200 (CEST)
Date: Tue, 3 Sep 2024 09:58:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, Miroslav Benes <mbenes@suse.cz>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Jiri Kosina <jikos@kernel.org>,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Song Liu <song@kernel.org>
Subject: Re: [RFC 07/31] kbuild: Remove "kmod" prefix from __KBUILD_MODNAME
Message-ID: <20240903075813.GM4723@noisy.programming.kicks-ass.net>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <d781bcac7ddd4563ed7849b5d644849760ad8109.1725334260.git.jpoimboe@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d781bcac7ddd4563ed7849b5d644849760ad8109.1725334260.git.jpoimboe@kernel.org>

On Mon, Sep 02, 2024 at 08:59:50PM -0700, Josh Poimboeuf wrote:
> Remove the arbitrary "kmod" prefix from __KBUILD_MODNAME and add it back
> manually in the __initcall_id() macro.
> 
> This makes it more consistent, now __KBUILD_MODNAME is just the
> non-stringified version of KBUILD_MODNAME.  It will come in handy for
> the upcoming "objtool klp diff".
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  include/linux/init.h | 3 ++-
>  scripts/Makefile.lib | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/init.h b/include/linux/init.h
> index 58cef4c2e59a..b1921f4a7b7e 100644
> --- a/include/linux/init.h
> +++ b/include/linux/init.h
> @@ -206,12 +206,13 @@ extern struct module __this_module;
>  
>  /* Format: <modname>__<counter>_<line>_<fn> */
>  #define __initcall_id(fn)					\
> +	__PASTE(kmod_,						\
>  	__PASTE(__KBUILD_MODNAME,				\
>  	__PASTE(__,						\
>  	__PASTE(__COUNTER__,					\
>  	__PASTE(_,						\
>  	__PASTE(__LINE__,					\
> -	__PASTE(_, fn))))))
> +	__PASTE(_, fn)))))))

:-(

