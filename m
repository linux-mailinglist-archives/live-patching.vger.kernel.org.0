Return-Path: <live-patching+bounces-2157-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qHJRNA1Zq2mZcQEAu9opvQ
	(envelope-from <live-patching+bounces-2157-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 23:45:33 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C47E42285F2
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 23:45:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 652443009838
	for <lists+live-patching@lfdr.de>; Fri,  6 Mar 2026 22:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E5C53502BA;
	Fri,  6 Mar 2026 22:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G7rmqkmY"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECE82F12AE;
	Fri,  6 Mar 2026 22:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772837127; cv=none; b=MxLgBp0sqnSf6chdl0ssnobu2TjbHjnjFqTr9bYgfrENgXCJSuZFIQcEgNcE27CR5Ra3wxgrWl6pCnDSiNgiKu+KujYM6g2q0lF+ySOZV20EbE4z+1tp2J3jSACyR4UscK9Fu17smkTfLRCRLPVXMAsmoTfPQ2Wv2FXT9Iej8Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772837127; c=relaxed/simple;
	bh=dNOTZvU0FlC/ztZAG6jbBsB2dYRaK/F+Ss9rz9BLcJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kg1Rl6CONl0b0e/F9/1wqDSrsISJiRv62FyB8NXmwsdhPchN+n7pEnHworFT0hQgzVcruc8AKRXfEGSazNijlMUmGAFhiKnvjVgNCRq5OrWwN1teEOWzNCX7Q31pTDfPNwhnrGtAzmrcQ0DWgLiqXtci0ODUFFZtx14IsCussmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G7rmqkmY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D26CC4CEF7;
	Fri,  6 Mar 2026 22:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772837126;
	bh=dNOTZvU0FlC/ztZAG6jbBsB2dYRaK/F+Ss9rz9BLcJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G7rmqkmYzPAAuBwDV/3HhLULIgdLnT1wjhffepT0VLV2ePkjVdyD9iohYCrGa2HGl
	 Nw5MGI7d08ll44xQJa13q7tWA22KgnC0BrhXbFHu9+sMLmn+Mq++SsaaRybEQY4UpT
	 CNHQJ7YJu5uhdesrh0gdlwlI1g8N0tZhPtbYOBX1qxMPBjCmZl8vZM1OtqkXNLL6Io
	 9sz3NhuszGQgEvh/JRxh4UaYjfXXIMmd9AE/f9m6M7i4MR0mcbg6i+2EYgSz+q4y/T
	 T8VM7vp41OAGIQ7AbQyeHYyyQFHEPO6GQ6LcdYvUIeEtrXQ9GioUcM+KsPWIj6PBUr
	 7h+zz1Gj0FH5w==
Date: Fri, 6 Mar 2026 15:45:22 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Yonghong Song <yonghong.song@linux.dev>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, linux-kbuild@vger.kernel.org,
	live-patching@vger.kernel.org, kernel-team@fb.com,
	Nicolas Schier <nsc@kernel.org>, Song Liu <song@kernel.org>
Subject: Re: [PATCH kbuild] kbuild: Allow to reduce the number of suffixes
 for clang thin-lto build
Message-ID: <20260306224522.GA2746259@ax162>
References: <20260306034325.3605301-1-yonghong.song@linux.dev>
 <pat2b5nibiik6nua6ls7cu7eqy5qgrugo4gnel32bz6vpcrmz3@f7ynsbvnxcaj>
 <f1afe1e8-0dfd-47b0-8ca4-f09d4fda13eb@linux.dev>
 <bt7t2452h27o7bf27f7ljs2xhn7venhvslynq3a77jbtwi7hqk@cgobhbhi5y2r>
 <lmj53l5djuipucmuxwr563n6ty7hobduzg4vvy4pjnw4yz5t56@he3wiioegzhy>
 <f0c037e6-d498-41c3-8d71-0597a2e1d68d@linux.dev>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f0c037e6-d498-41c3-8d71-0597a2e1d68d@linux.dev>
X-Rspamd-Queue-Id: C47E42285F2
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2157-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.933];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nathan@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 02:12:44PM -0800, Yonghong Song wrote:
> So you mean we do not need a new config. Should just check clang and
> clang versionn like below?
> 
> diff --git a/Makefile b/Makefile
> index e944c6e71e81..9bd3990024c5 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1034,6 +1034,11 @@ endif
>  ifdef CONFIG_LTO_CLANG
>  ifdef CONFIG_LTO_CLANG_THIN
>  CC_FLAGS_LTO   := -flto=thin -fsplit-lto-unit
> +ifdef CONFIG_CC_IS_CLANG
> +ifeq ($(shell test $(CONFIG_CLANG_VERSION) -ge 230000; echo $$?),0)

This is the same as

  ifeq ($(call clang-min-version,230000),y)

That being said, could we not just do a dynamic check so that it always
works when these flags are supported?

> +KBUILD_LDFLAGS += --lto-whole-program-visibility -mllvm -always-rename-promoted-locals=false

  KBUILD_LDFLAGS += $(call ld-option,--lto-whole-program-visibility -mllvm -always-rename-promoted-locals=false)

> +endif
> +endif
>  else
>  CC_FLAGS_LTO   := -flto
>  endif
> 
> I think this should work. In rare case, renaming the function should
> solve the problem.

I agree with Josh that having this be the default behavior with the
workarounds that we have available to us to avoid problems from it is
worth it. Thanks for chasing this after the discussions at LPC.

Cheers,
Nathan

