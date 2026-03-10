Return-Path: <live-patching+bounces-2160-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yCbqA9WMr2n4aQIAu9opvQ
	(envelope-from <live-patching+bounces-2160-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 04:15:33 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 78D62244AE7
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 04:15:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6EC123020ECD
	for <lists+live-patching@lfdr.de>; Tue, 10 Mar 2026 03:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 787923B895A;
	Tue, 10 Mar 2026 03:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IftY/sgF"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5107838B7C0;
	Tue, 10 Mar 2026 03:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773112463; cv=none; b=E5QbBoIJVC6HEph64neFAR26pAsJm/QB9MljDXsxzHHhK4EdlGvH/FKz5A5Ud0xpcMu1IiOs7nynpUfUbXQwW9BvMy09wydK+Q36R1Jr/5QAtJq5NtJRfIzdhTUoOXVwnpWQazK5012P0wFEK+VcIar0qTdRJPoO3eUvdQyGfDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773112463; c=relaxed/simple;
	bh=X6rBUHlsAWpnqZFAipqPmjIKUoFR7rKomQfTbdomyyI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8IcVoDyZJWPG7WxEb6UwbVU3CZdSNGSXM9mghXuZkA6zhHl/+lb0tvV2RcmanGzU+3iiO2pvjUq6M95ygYlVUdQqhaXGwoUoi7M+bvuZccdLam9hXqWQP91ulcu1bTLXZan1qQy5R9WDIE5xHJfbQZKU2vV2N4rnZGnfoisXzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IftY/sgF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB8FC4CEF7;
	Tue, 10 Mar 2026 03:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773112463;
	bh=X6rBUHlsAWpnqZFAipqPmjIKUoFR7rKomQfTbdomyyI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IftY/sgFJ+VZByRTe38PHlrrmdaX68EUn5utrCxUmVsxwdSxwMlY3Z7TJ/L12v5Ov
	 TM6unhOeTJIpNA/Q2KDHLLtsooC2QfMxGh0DMItEfjq/cCzkrKFY6yplFpdqThIXhD
	 MSNPMeVY+ub06VwlEogFCYZiYUzstLi5avicb6AOh+ubKdllmZdNU1V6sz1CBsjDRP
	 ZcluBa96q/r0bYFAkghTi6EdiOnpny8qISKV0g49VUVhWIsO7BGQkuXldxpcXZCIhZ
	 qM/Mi8uiPnpU5Wl0HQ9ZfDzcBEOzUkDcclIVDl/3Mjp6WOyfscgkAmIl48aujmxMH0
	 8k6xTmeHiWHXA==
Date: Mon, 9 Mar 2026 20:14:18 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Yonghong Song <yonghong.song@linux.dev>
Cc: linux-kbuild@vger.kernel.org, live-patching@vger.kernel.org,
	Josh Poimboeuf <jpoimboe@kernel.org>, kernel-team@fb.com,
	Nicolas Schier <nsc@kernel.org>, Song Liu <song@kernel.org>
Subject: Re: [PATCH kbuild v2] kbuild: Reduce the number of
 compiler-generated suffixes for clang thin-lto build
Message-ID: <20260310031418.GA3988399@ax162>
References: <20260307050250.3767489-1-yonghong.song@linux.dev>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307050250.3767489-1-yonghong.song@linux.dev>
X-Rspamd-Queue-Id: 78D62244AE7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2160-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nathan@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
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

Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org> # build

Thanks!

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
> -- 
> 2.47.3
> 

