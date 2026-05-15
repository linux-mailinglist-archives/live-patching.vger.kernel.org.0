Return-Path: <live-patching+bounces-2827-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yIi0LApmBmrOjQIAu9opvQ
	(envelope-from <live-patching+bounces-2827-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 02:17:14 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 12212547EF1
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 02:17:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 11D5A3025920
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 00:16:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D81113E41A;
	Fri, 15 May 2026 00:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LLk3cfkM"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE3D3770B;
	Fri, 15 May 2026 00:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778804213; cv=none; b=bN+ZyiBChmH4CisQg8m2+wUlReWLeYyk0I3RXNIrZszIdEsDBumg4z/oz224VmPx/oG6SkaKtv+kTaH5NDys0QYU2T/6Y66uAyRtVsShXhsKmDn42NJ/WMxjYmq/iWzT1pRYoZssqWXo7uchfqDV7XWXe6T2wqkcfkU0lSuLLW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778804213; c=relaxed/simple;
	bh=UX7VNZBm0xMgUBdi6LTy4GtyerPnkbZCiJOpWfi6yUQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jLJHbBUvlnncJwgxuj6J8BcTlgv58Ndfkvi9LrihpubeHkUZuOyK8OCX6HJYOf6PHgMehcjJe01HTwcYtrmX5165WVwGbDJuxPhmr57NRZrm1VIbun5DxPjgUSyshAfnju9uLNWRlsgoQKw0Djm8pkt/GMUCL+qyw1Z9tDw/Bdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LLk3cfkM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09947C2BCB3;
	Fri, 15 May 2026 00:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778804212;
	bh=UX7VNZBm0xMgUBdi6LTy4GtyerPnkbZCiJOpWfi6yUQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date:From;
	b=LLk3cfkME3xw5l2/O0sRlOypKrlG5pYEdRt1TDWtq4XUO6hFhnw0GuZIYaMxPQtPA
	 +hf1zYeO9ae5v0xDggm3bNLy0s2ztbvlPbTNTFNr6Kgv1vXEIX8pcsvZ6rQs9JFlML
	 mJYKPrb+VK82lTnCNCadF5Rd8JwHSgBKDAvIO8C2ErVXN/DKRMz1sOHdJldNlMTZtV
	 jsaKSngT08JeGD66uN/Tqk0XxDg6Ru32FZwuimRodJISE7uyMYGBbBLTCZxyD2K+Ba
	 DGovAgdBJugxJJn1FJSqlej5J3XwFSZKXJQvoCP4utASwmRI2J/O2bDNh0zTpGPduK
	 I+3rYfJEvboDw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 14/21] objtool: Prevent kCFI hashes from being
 decoded as instructions
Reply-To: sashiko-reviews@lists.linux.dev
To: x86@kernel.org
Cc: "Will Deacon" <will@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, live-patching@vger.kernel.org, "Petr
 Mladek" <pmladek@suse.com>, linux-kernel@vger.kernel.org, "Peter Zijlstra" <peterz@infradead.org>, "Miroslav
 Benes" <mbenes@suse.cz>, "Song Liu" <song@kernel.org>, "Joe Lawrence" <joe.lawrence@redhat.com>
In-Reply-To: <b1d50c9fc9e6b9bca43833cc4ccbd88a31fed84b.1778642120.git.jpoimboe@kernel.org>
References: <b1d50c9fc9e6b9bca43833cc4ccbd88a31fed84b.1778642120.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 15 May 2026 00:16:51 +0000
Message-Id: <20260515001652.09947C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: 12212547EF1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2827-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,live-patching@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_NO_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lists.linux.dev:replyto,sashiko.dev:url,smtp.kernel.org:mid]
X-Rspamd-Action: no action

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Build failure due to undeclared mapping symbol functions.
- [Low] Unused header inclusion.
--

commit 4ad78a24a64cd6a2d10b9a2f9c0d306fba3e6d19
Author: Josh Poimboeuf <jpoimboe@kernel.org>

objtool: Prevent kCFI hashes from being decoded as instructions

On arm64 with CONFIG_CFI=3Dy, Clang places a 4-byte kCFI type hash immediat=
ely
before each address-taken function entry. This commit uses mapping symbols
to mark such data as NOP in text sections to prevent objtool from decoding
them.

> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index e05dc7a93dc1e..2b03a2d6fc952 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c
> @@ -25,6 +25,7 @@
>  #include <linux/kernel.h>
>  #include <linux/static_call_types.h>
>  #include <linux/string.h>
> +#include <linux/kconfig.h>

This isn't a bug, but is this include needed? It doesn't appear that any
Kconfig configuration macros are being used in the modified code.

[ ... ]

> @@ -478,6 +483,16 @@ static int decode_instructions(struct objtool_file *=
file)
> =20
>  			prev_len =3D insn->len;
> =20
> +			/* Use mapping symbols to skip data in text sections */
> +			sec_for_each_sym_from(sec, map_sym) {
> +				if (map_sym->offset > offset)
> +					break;
> +				if (is_mapping_sym(map_sym))
> +					is_data =3D is_data_mapping_sym(map_sym);

Could this cause a build failure across architectures here? It appears
is_mapping_sym() and is_data_mapping_sym() are neither declared nor defined
anywhere in the codebase at this point in the patch series.

If these functions are only introduced in a subsequent commit, applying
this patch independently might result in an implicit declaration of function
error, breaking git bisectability.

> +			}
> +			if (is_data)
> +				insn->type =3D INSN_NOP;
> +
>  			/*

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1778642120.gi=
t.jpoimboe@kernel.org?part=3D14

