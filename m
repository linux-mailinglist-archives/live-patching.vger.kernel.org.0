Return-Path: <live-patching+bounces-2131-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QBozCdbeqWm4GgEAu9opvQ
	(envelope-from <live-patching+bounces-2131-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 20:51:50 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 96AB2217CCC
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 20:51:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4842A300B9B3
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 19:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C5BB3093C3;
	Thu,  5 Mar 2026 19:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DacJzrII"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2BF1F4634
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 19:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772740305; cv=none; b=qEH+uPi1tncAu65bi6vGaSdUcxkRrImI8EFqrn7HdYKeN+vddJiiJgyGYSsqR9WU6pFYOGjKOyOCrGa2X+8UlHS5BwRmo7/MKlVKDPV/PIR1sNsj7ULFzbavsjgu3lGBcW0aUYb0u8/jl4sRMEultBytKQyobuDBK41/PTWZ1QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772740305; c=relaxed/simple;
	bh=c1dhAO44OLtQzN2L+VS/ogf1DUFX0FN7tBgaAG7DLk4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RFDnciZiIXssNx6+qeBoh3atxYh3QPTOgtXYRj0DRE4GEM+zV4b3vVkbn0n8ZIvK/TWYGTd/NtsU7bh4yQnceRm4AxmZDp+sXt7gYg97ZshPDbTM9916dT7tVmcv2t024ihINeDehn+L1iNpyGBtbHEDg65rsyMTYJWiNH703tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DacJzrII; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CED7C116C6;
	Thu,  5 Mar 2026 19:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772740305;
	bh=c1dhAO44OLtQzN2L+VS/ogf1DUFX0FN7tBgaAG7DLk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DacJzrII1A2BMhVg/Mw6hlmvOnWEyJKsdhP7TEMXn+h2SLLoUqtr9AxCM1z+8wdPL
	 YSjer/mRh9onX67fDVUlOXjV5msEUgW3og5pWmyi8t4dYg+QH3+E4XWdZWSCf+zGrK
	 9i3bWQKUSWfYGnq8QgyiC6UlPS8MzoI6nlT8Gf/KrBYuU77LGRhHug1Z7ECl0HAo37
	 gSvWzBikaAeAdE2DASr0JCFp9U+lGt/4115ok57kCb5FRvvoX8iXIFRDWXieOelMTH
	 1tQFcQgqo31KRHWw8oYkpf2cVIHkAWjifK9PZbWpL38TltJgvp+q+N90TIsuo6rZVQ
	 mHkHKpqq/OKTQ==
Date: Thu, 5 Mar 2026 11:51:42 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	pmladek@suse.com, joe.lawrence@redhat.com, kernel-team@meta.com
Subject: Re: [PATCH v3 7/8] objtool/klp: Correlate locals to globals
Message-ID: <4j5chvfnlugrpycrehextkinzfle7mokkos4ooa2ali2susov7@ncunycnjajtu>
References: <20260226005436.379303-1-song@kernel.org>
 <20260226005436.379303-8-song@kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260226005436.379303-8-song@kernel.org>
X-Rspamd-Queue-Id: 96AB2217CCC
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
	TAGGED_FROM(0.00)[bounces-2131-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Feb 25, 2026 at 04:54:35PM -0800, Song Liu wrote:
> Allow correlating original locals to patched globals, and vice versa.
> This is needed when:
> 
> 1. User adds/removes "static" for a function.
> 2. CONFIG_LTO_CLANG_THIN promotes local functions and objects to global
>    and add .llvm.<hash> suffix.
> 
> Given this is a less common scenario, show warnings when this is needed.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  tools/objtool/klp-diff.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> index 92043da0ed0b..5cda965807a5 100644
> --- a/tools/objtool/klp-diff.c
> +++ b/tools/objtool/klp-diff.c
> @@ -517,6 +517,40 @@ static int correlate_symbols(struct elfs *e)
>  		}
>  	}
>  
> +	/* Correlate original locals with patched globals */
> +	for_each_sym(e->orig, sym1) {
> +		if (sym1->twin || dont_correlate(sym1) || !is_local_sym(sym1))
> +			continue;
> +
> +		sym2 = find_global_symbol_by_name(e->patched, sym1->name);
> +		if (!sym2 && find_global_symbol_by_demangled_name(e->patched, sym1, &sym2))
> +			return -1;
> +
> +		if (sym2 && !sym2->twin) {
> +			sym1->twin = sym2;
> +			sym2->twin = sym1;
> +			WARN("correlate LOCAL %s (original) to GLOBAL %s (patched)",
> +			     sym1->name, sym2->name);

I think this correlation is deterministic so there's no need for the
warning?

> +		}
> +	}
> +
> +	/* Correlate original globals with patched locals */
> +	for_each_sym(e->patched, sym2) {
> +		if (sym2->twin || dont_correlate(sym2) || !is_local_sym(sym2))
> +			continue;
> +
> +		sym1 = find_global_symbol_by_name(e->orig, sym2->name);
> +		if (!sym1 && find_global_symbol_by_demangled_name(e->orig, sym2, &sym1))
> +			return -1;
> +
> +		if (sym1 && !sym1->twin) {
> +			sym2->twin = sym1;
> +			sym1->twin = sym2;
> +			WARN("correlate GLOBAL %s (origial) to LOCAL %s (patched)",
> +			     sym1->name, sym2->name);
> +		}

Ditto.

-- 
Josh

