Return-Path: <live-patching+bounces-2161-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YGVIEL+Ur2kragIAu9opvQ
	(envelope-from <live-patching+bounces-2161-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 04:49:19 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 999A1245037
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 04:49:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 550AB3043034
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 03:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA68636C9ED;
	Tue, 10 Mar 2026 03:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lMg+xNvf"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 857921547C0;
	Tue, 10 Mar 2026 03:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773114556; cv=none; b=uLGF+ZLbtREKZWxHeTxStGMy7M8HetlmIw6c5fe+gRNmDQLnrUrg4ve1sTXs1CQiMwYCNy81txo6Mpo1YpLQRsZS76iJExdy5i1sVeLzKGDLvsHgo17j4sV3cRwwkiGa/jlCKSfbuMod0SEfS/LaqAxmIP/JbSxy5G+ZAzRSAaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773114556; c=relaxed/simple;
	bh=NFxovYa1E5E9XiC3eox80OUbokzGqYY+zZvvEMOuk/I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AMcqA2s9mN9Xjc/MQE7RxSbRspxvZy8PM1RYO2Yc/Zbgz0EpO/UrY/vQb/Uh1YxzHU2FQvCz+TJYkp7kM1merjTPp1P911P2rVeLTcWEz22UAuc2HMIb+v1F74xtMKH0A6XSeJgNisjS5MS+5WB5ReHT//R31qF54Prg9JkU/Mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lMg+xNvf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4527C19423;
	Tue, 10 Mar 2026 03:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773114556;
	bh=NFxovYa1E5E9XiC3eox80OUbokzGqYY+zZvvEMOuk/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lMg+xNvf5l8hqv/jLsqbzkITt0w00uRfq38nHdAsP5Z3mkJgtKQoDArju5yS8Xo0D
	 ZOBZpOJtnYrn8Iw4+uDeTZ1zw8GWLqyhEzFYhIDMHrJCYx6UdBXMSTczTZ/nw8juzO
	 vy3KeR+KnYfqgqnuyV0d6m4KjnPEAT/WDa37+LdYJhKL6qORfg2WDFilgLeUYUE2gJ
	 tqAdurqcEBXT1dxi1y9v4/6HQhZNS7XeQ+VrolVMBJe9clKRejCIZEYcY4HQKWFgrL
	 lOSDt3/kr0acsy9uOzrhXPuvBl7jIjMExmotoZwwqneOnNjfhBVvAKtDvkOawz+KKg
	 ntZFAAUIZKBxA==
Date: Mon, 9 Mar 2026 20:49:14 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Yonghong Song <yonghong.song@linux.dev>
Cc: linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org, 
	kernel-team@fb.com, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Song Liu <song@kernel.org>
Subject: Re: [PATCH kbuild v2] kbuild: Reduce the number of
 compiler-generated suffixes for clang thin-lto build
Message-ID: <r3cg6mdciwbjybnjjly7znam4xhslb2pnb5fhoafzz4tcui4cy@eyqzma6osi5z>
References: <20260307050250.3767489-1-yonghong.song@linux.dev>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260307050250.3767489-1-yonghong.song@linux.dev>
X-Rspamd-Queue-Id: 999A1245037
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2161-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,lpc.events:url]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 09:02:50PM -0800, Yonghong Song wrote:
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
> function calls is 1212. As the side effect of cross-file inlining,
> some static variables may be promoted with '*.llvm.<hash>' as well.
> In my same setup, the number of variables with such suffixes is 9.
> 
> Such symbols make kernel live patching difficult since
>   - a minor code change will change the hash and then the '*.llvm.<hash>'
>     symbol becomes another one with a different hash. Sometimes, maybe
>     the suffix is gone.
>   - a previous source-level symbol may become a one with suffix after live
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
> To support suffix symbol reduction, two lld flags are necessary to enable
> this feature in kernel:
>     - Flag '--lto-whole-program-visibility' is needed as it ensures that all
>       non-assembly files are available in the same thin-lto lld, which is true
>       for kernel.
>     - Flag '-mllvm -always-rename-promoted-locals=false' is needed to enable
>       suffix reduction. Currently in llvm [1], only process mode is supported.
>       There is another distributed mode (across different processes or even
>       different machines) which is not supported yet ([2]). The kernel uses
>       process mode so it should work.
> 
> The assembly files may have some global functions/data which may potentially
> conflict with thin-lto global symbols after the above two flags. But such assembly
> global symbols are limited and tend to be uniquely named for its context.
> Hence the conflict with globals in non-assembly codes is rare. If indeed the
> conflict happens, we can rename either of them to avoid conflicts.
> 
> Nathan Chancellor suggested the following under thin-lto:
>   KBUILD_LDFLAGS += $(call ld-option,--lto-whole-program-visibility -mllvm -always-rename-promoted-locals=false)
> The '-mllvm -always-rename-promoted-locals=false' flag is only available for llvm23.
> So for llvm22 or earlier, the above KBUILD_LDFLAGS will ignore those two flags.
> For llvm23 and later, two flags will be added to KBUILD_LDFLAGS.
> 
>   [1] https://lpc.events/event/19/contributions/2212
>   [2] https://github.com/llvm/llvm-project/pull/178587
> 
> Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
> ---
>  Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> Changelog:
>   v1 -> v2:
>     - v1: https://lore.kernel.org/linux-kbuild/20260306034325.3605301-1-yonghong.song@linux.dev/
>     - Removed the new config option and use ld-option to check whether new flags
>       will be used or not.
> 
> diff --git a/Makefile b/Makefile
> index e944c6e71e81..e4385af16985 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1034,6 +1034,7 @@ endif
>  ifdef CONFIG_LTO_CLANG
>  ifdef CONFIG_LTO_CLANG_THIN
>  CC_FLAGS_LTO	:= -flto=thin -fsplit-lto-unit
> +KBUILD_LDFLAGS += $(call ld-option,--lto-whole-program-visibility -mllvm -always-rename-promoted-locals=false)
>  else
>  CC_FLAGS_LTO	:= -flto
>  endif

Thanks, this will help a lot with livepatch module generation.

Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>

-- 
Josh

