Return-Path: <live-patching+bounces-2152-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wJ0RLMsdq2mPaAEAu9opvQ
	(envelope-from <live-patching+bounces-2152-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 19:32:43 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B8D73226B28
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 19:32:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C4E5C300C359
	for <lists+live-patching@lfdr.de>; Fri,  6 Mar 2026 18:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5E4735B643;
	Fri,  6 Mar 2026 18:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s3r/Gpk4"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C6C33BBAD;
	Fri,  6 Mar 2026 18:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772821956; cv=none; b=U7G90Ky2O6JgO91qXwPMTj3WlQtkvpltrOO7n/szI80xq9+Qp66c3r17y2jhPtHhh4Kp1fA9LD5vVOylVS34T/12tDdCoWVpIIpnitOSb9iEX4sOPyxlYZJKD+985isahPFlFeK00Ww7AKwq0GKpxYYPYqtMYx1hLTRor2NHAIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772821956; c=relaxed/simple;
	bh=zIFjbZzFGH8xleoElScILSUjUJP7/AN816fjOoAle6k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tPelWz+HIgZ9gHVLzLOzUf7vK7qE9xp8AymJej6lPwkv3DyySme/8Iu9ONb6EB+dneuevbV6U3wr7d0MlRT+4kyHNn0KpuY7AKeK6QmX5LtEQkbQxQNcIUSPwEmuTUJ4hp6QW67gSKI+GgjUoMFFpnGRuBoWBW7o3TX4lSEblDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s3r/Gpk4; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2E5C4CEF7;
	Fri,  6 Mar 2026 18:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772821956;
	bh=zIFjbZzFGH8xleoElScILSUjUJP7/AN816fjOoAle6k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s3r/Gpk41MIV+EO8J7NYTIvDd469saPvgdSXxmt0P39U7uSrbiVRcGkqOmx8VEGUD
	 rVv3FXDeqmSx7kTRixzElRuA4aN7U55ssoyhgeyyM9SgguQD7RMrBU22IK/QM7v59e
	 kfR+bgv9MSHlpksBW+BvgZDYJ852rSHEoj7A7xbBrCYJPv6LBUt37rBp8wcSX0EUAA
	 GvZvHfliZl5Ekpk0E96g+uBkuZ9D+7HHui6UUYSZKxnzM6NyiRR3SwkIlUQ1FjRIev
	 AZOI6TRMGJ2rUN/DxADVK27AYUcQPSWGgKlf/iInMENFyf1gmO+tTpNTbr3ViXAViA
	 QSQzsOMdsw2Rg==
Date: Fri, 6 Mar 2026 10:32:33 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yonghong Song <yonghong.song@linux.dev>
Cc: linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org, 
	kernel-team@fb.com, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Song Liu <song@kernel.org>
Subject: Re: [PATCH kbuild] kbuild: Allow to reduce the number of suffixes
 for clang thin-lto build
Message-ID: <pat2b5nibiik6nua6ls7cu7eqy5qgrugo4gnel32bz6vpcrmz3@f7ynsbvnxcaj>
References: <20260306034325.3605301-1-yonghong.song@linux.dev>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260306034325.3605301-1-yonghong.song@linux.dev>
X-Rspamd-Queue-Id: B8D73226B28
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2152-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.938];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,linux.dev:email,llvm.org:url]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026 at 07:43:25PM -0800, Yonghong Song wrote:
> The current clang thin-lto build often produces lots of symbols with
> suffix. The following is a partial list of such function call symbols:
>     ...
>     ethnl_module_fw_flash_ntf.llvm.7631589765585346066
>     __nf_conntrack_alloc.llvm.6438426151906658917
>     tcp_can_early_drop.llvm.11937612064648250727
>     tcp_print_conntrack.llvm.11937612064648250727
>     ...
> 
> In my particular build with current bpf-next, the number of '*.llvm.<hash>'
> function calls is 1212. Such symbols make kernel live patching
> difficult since
>   - a minor code change will change the hash and then the '*.llvm.<hash>'
>     symbol becomes another one with a different hash or no hash, and
>   - a previous source-level symbol may become an one with suffix after live
>     patching code.
> 
> In [1], Song Liu suggested to reduce the number of '*.llvm.<hash>' functions
> to make live patch easier. In respond of this, I implemented this
> in llvm ([2]). The same thin-lto build with [2] only has two symbols with
> suffix:
>     m_stop.llvm.14460341347352036579
>     m_next.llvm.14460341347352036579
> This should make live patch much easier.
> 
> To support suffix symbol reduction, a new config
>     LTO_CLANG_THIN_SUFFIX_REDUCTION
> is introduced and the config depends on thin-lto and llvm23 or higher.
> 
> Two lld flags are necessary to enable this feature in kernel:
>     - Flag '--lto-whole-program-visibility' is needed as it ensures that all
>       modules are available in the same process, which is true for kernel at
>       thin-lto lld.
>     - Flag '-mllvm -always-rename-promoted-locals=false' is needed to enable
>       suffix reduction. Currently in llvm [1], only process mode is supported.
>       There is another distributed mode (across different processes or even
>       different machines) which is not supported yet ([2]).
> 
>   [1] https://lpc.events/event/19/contributions/2212
>   [2] https://github.com/llvm/llvm-project/pull/178587
> 
> Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
> ---
>  Makefile     |  3 +++
>  arch/Kconfig | 15 +++++++++++++++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index e944c6e71e81..9d6033595615 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1034,6 +1034,9 @@ endif
>  ifdef CONFIG_LTO_CLANG
>  ifdef CONFIG_LTO_CLANG_THIN
>  CC_FLAGS_LTO	:= -flto=thin -fsplit-lto-unit
> +ifdef CONFIG_LTO_CLANG_THIN_SUFFIX_REDUCTION
> +KBUILD_LDFLAGS += --lto-whole-program-visibility -mllvm -always-rename-promoted-locals=false
> +endif
>  else
>  CC_FLAGS_LTO	:= -flto
>  endif
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 102ddbd4298e..e1db64a3284e 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -861,8 +861,23 @@ config LTO_CLANG_THIN
>  	    https://clang.llvm.org/docs/ThinLTO.html
>  
>  	  If unsure, say Y.
> +
>  endchoice
>  
> +config LTO_CLANG_THIN_SUFFIX_REDUCTION
> +	bool "Clang ThinLTO Suffix Reduction (EXPERIMENTAL)"
> +	depends on LTO_CLANG_THIN
> +	depends on CLANG_VERSION >= 230000
> +	default y
> +	help
> +	  This option allows to reduce the number of symbols with
> +	  '.llvm.<hash' suffixes. This can help KLP (kernel living
> +	  patch) as symbol name can stay stable in most cases.
> +
> +	  See https://github.com/llvm/llvm-project/pull/178587
> +
> +	  If unsure, say N.
> +

Thanks!  Would there be any downsides to enabling this feature
unconditionally in the kernel when the compiler supports it?

-- 
Josh

