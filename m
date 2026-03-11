Return-Path: <live-patching+bounces-2193-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8GhRLWL4sWl7HQAAu9opvQ
	(envelope-from <live-patching+bounces-2193-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:18:58 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E5E926B4E8
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:18:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id BF560302651E
	for <lists+live-patching@lfdr.de>; Wed, 11 Mar 2026 23:18:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA1D3A3804;
	Wed, 11 Mar 2026 23:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aHMu2k+9"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15553A257C
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773271134; cv=none; b=V13icSuCYRE4gdPspG4Yq6dPgPn8qsz4oExpo5I4iw6sRQj2a6guVTKwsbgcyV4LPdTAe8VOgfeP1lTpsDvRKZBEdVg7Jrfp8L4c5rEPCl9gaiVaWSbDY6oQW0981w6GQ3fbpxRSIQAjpB4PyYW4vvxt96sAJn/XQQZGzEV+BgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773271134; c=relaxed/simple;
	bh=Mr9POiEHF84Nd6nPxAee/tWtwPmFbTtS72+IImYqkEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lLuNvLLg/s4Cjq0BA3WktW//oLWzaUUbqxoxKS5GELyDT+bpYARu8ghEoduBF6Or8/9icyD4YQnMjprtckpLUVAlpPqgHiGz/ZNZvKguapLwXLFhY57GE9Ud9jYPgkxc1UsPWDs4HN7hW4cC25yJHsiaDRcQrpl0OTfO2Q7BBPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aHMu2k+9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E751C2BC86
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773271133;
	bh=Mr9POiEHF84Nd6nPxAee/tWtwPmFbTtS72+IImYqkEU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aHMu2k+9sRBhcfZ8R1Y9pajwrQr6gjytT0lbe91FVWCEAx/6vRuCdX2PAQkpJQI9r
	 uFfAICXk7vPhcq2kwfIGPqlRDSnmmY1sgx8yxn+wx+r6J2w45yvevOG/eGLem7Zkye
	 9tYcmNrefJsba9GPWSqxiC6n1T1nC/GebuCwz6DDzaPGk7KHyqxMa23OLRN1EDZm5I
	 qqRj3aIfnU4IW5mSNN74xDsqwLFxeWmAHmHg2vUIcYvZjnPWHMAmiwKseC1y3ofR+R
	 u92YB2CiwHfmEJpQcUhL9ZOpUzcrHFbVvGy5uFFL07l3qlVw58q9m1mtK1a6jbM3pt
	 XJqdeYna0ku9w==
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-89a06bc2f1bso6934446d6.1
        for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 16:18:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWAWzke/itLkWWDyqJBYojQBhrPIt8PiffHW+dU/zid8cg90FsM7FWkP6Q+UGfIEzcgczMtNqO36Br5NbrO@vger.kernel.org
X-Gm-Message-State: AOJu0YxTJ84XaK9Jdj7XvSpoXTOehGzLbft7CK4tNqHMTz2oIjsBIRsj
	M/KF5dJ1no3B50ecC3/76FN+JkaE9M2OLEfu7J5dhzJmXd2UuIquzBMixztXYzXeQO8kE3yuDLU
	hcCdCtCD85OXzvdurjWekyuTa7Kb1cyc=
X-Received: by 2002:a05:6214:508c:b0:899:f5a9:be38 with SMTP id
 6a1803df08f44-89a66a85e8dmr55318246d6.47.1773271132658; Wed, 11 Mar 2026
 16:18:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1772681234.git.jpoimboe@kernel.org> <697c09ca0a8ffd545aa875e507502f62ad983419.1772681234.git.jpoimboe@kernel.org>
In-Reply-To: <697c09ca0a8ffd545aa875e507502f62ad983419.1772681234.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Wed, 11 Mar 2026 16:18:40 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6Cyw_z+9sWt5G1XOp94z8BbwNmsoVE9=iM8WQfkuNDBA@mail.gmail.com>
X-Gm-Features: AaiRm53FL9d_HvNQD56UsGUH6aLAV9slp2Y2AiaB_VHX1tlUesyfGAJaIb95vrA
Message-ID: <CAPhsuW6Cyw_z+9sWt5G1XOp94z8BbwNmsoVE9=iM8WQfkuNDBA@mail.gmail.com>
Subject: Re: [PATCH 14/14] klp-build: Support cross-compilation
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org, 
	Mark Rutland <mark.rutland@arm.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nsc@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2193-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5E5E926B4E8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 4, 2026 at 7:32=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> Add support for cross-compilation.  The user must export ARCH, and
> either CROSS_COMPILE or LLVM.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  scripts/livepatch/klp-build | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index 809e198a561d..b6c057e2120f 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build
> @@ -404,6 +404,14 @@ validate_patches() {
>         revert_patches
>  }
>
> +cross_compile_init() {
> +       if [[ -v LLVM ]]; then
> +               OBJCOPY=3Dllvm-objcopy
> +       else
> +               OBJCOPY=3D"${CROSS_COMPILE:-}objcopy"
> +       fi
> +}

Shall we show a specific warning if
  - ARCH is set; and
  - ARCH is not the same as (uname -m); and
  - neither LLVM nor CROSS_COMPILE is set.

Thanks,
Song

