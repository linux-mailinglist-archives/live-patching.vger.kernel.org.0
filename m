Return-Path: <live-patching+bounces-2826-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OEcXFz1XBmqiiwIAu9opvQ
	(envelope-from <live-patching+bounces-2826-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 01:14:05 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 45C8D547B2B
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 01:14:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 070093005162
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 23:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1ADBC38D3FB;
	Thu, 14 May 2026 23:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mfuh03Ng"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E82671FC101;
	Thu, 14 May 2026 23:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778800437; cv=none; b=C52zXOeynToZkrZyv4kJbCCJfGnFQ1Lf56JfjBfUVrPr+DhoV66/jLeiFItrN1NXHc9ALxm0k31mRDc7WyMn8EY+Dac25HRTvUg2mdMBaXt9izg68hqGt7Y0xsBz5e7o0Q9cUuSgXLY3M4+riKn0Cx0IZTCG+MgHSKT7YdAPrFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778800437; c=relaxed/simple;
	bh=QyMVF0uvG9KUHwhsL0Eq8/ietjFflpcbXOwE8C7wqCU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jwl1o1KzmfPr7hRfAgZBTNSyxTDD5YAkGjETjJDriCl4ZCq8hh2voYDbs0VTShd8qyhvmDPFA+j0NWYIs+WMO7oNuTS4MCb7radzqxLi2hebHrdJaDsixzspgpeT8fq0pLpW2f3VjaIbf//C7xtGWZl13qarm8wvPWCRc1jpB8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mfuh03Ng; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8D7C2BCB3;
	Thu, 14 May 2026 23:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778800436;
	bh=QyMVF0uvG9KUHwhsL0Eq8/ietjFflpcbXOwE8C7wqCU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date:From;
	b=mfuh03NgX/Go16wsBTOGvc06SxamGu7YJj7eMNaLPoAlItjCAJErKtt9cEK1seu+J
	 YC2cofJLMSf9MvpZgJQfBE4tOaN2mdGW4z3X/krDR3H7+L7CO+OuZiWuJQFjtV4oAF
	 8EELHB5yDw1FmXuGJi8DaPIe/PeKmffNGSfEKvpTZAFO+bIvY+eAISneBrCQjigOsB
	 rkEyNgHGlNnEJUoSh8dxUlwKJRGkC91aHA7w+NgcV/QYm137VuntrZoC6bDol8FmIg
	 TzzF4RANjnVkfxp8iqjem/Tc8dWvdQ2EUfTEOoFxbWYJUbpNqEZnM9Wv+SZQMufngu
	 6PoUlFE+MeYHw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 12/21] objtool: Refactor elf_add_data() to use a
 growable data buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: x86@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, live-patching@vger.kernel.org, "Will
 Deacon" <will@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Joe Lawrence" <joe.lawrence@redhat.com>, "Song
 Liu" <song@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Petr Mladek" <pmladek@suse.com>, "Miroslav
 Benes" <mbenes@suse.cz>
In-Reply-To: <a0fe2363d017a2833e98ae50de797fe55c2796a4.1778642120.git.jpoimboe@kernel.org>
References: <a0fe2363d017a2833e98ae50de797fe55c2796a4.1778642120.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 14 May 2026 23:13:55 +0000
Message-Id: <20260514231355.DD8D7C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: 45C8D547B2B
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2826-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lists.linux.dev:replyto,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,smtp.kernel.org:mid]
X-Rspamd-Action: no action

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] An integer overflow in `elf_add_data()` due to an uncontrolled `=
sh_addralign` value allows an out-of-bounds heap write.
- [Low] In `elf_add_data`, a failed `calloc` for the new data buffer overwr=
ites `sec->data->d_buf` with NULL and leaks the original buffer.
--

commit 02f18d399bba6e3d751363b4e85f507e3f288e34
Author: Josh Poimboeuf <jpoimboe@kernel.org>

objtool: Refactor elf_add_data() to use a growable data buffer

Instead of calling elf_newdata() for each new piece of data with its own
separate buffer, keep it all in the same growable buffer so the
section's entire data can be accessed if needed.

> diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> --- a/tools/objtool/elf.c
> +++ b/tools/objtool/elf.c
[ ... ]
> @@ -1409,30 +1406,55 @@ void *elf_add_data(struct elf *elf, struct sectio=
n *sec, const void *data, size_
>  		return NULL;
>  	}
> =20
> -	sec->data =3D elf_newdata(s);
>  	if (!sec->data) {
[ ... ]
> +		sec->data->d_align =3D sec->sh.sh_addralign;
>  	}
> =20
> -	sec->data->d_buf =3D calloc(1, size);
> -	if (!sec->data->d_buf) {
> -		ERROR_GLIBC("calloc");
> -		return NULL;
> +	size_old =3D sec->data->d_size;
> +	offset =3D ALIGN(size_old, sec->sh.sh_addralign);
> +	size_new =3D offset + size;

Could this ALIGN calculation overflow if a malformed ELF file provides an
extremely large sh_addralign value?

If offset wraps around, it seems size_new might also wrap, potentially caus=
ing
roundup_pow_of_two to return a small allocation size. Could this lead to an
out-of-bounds write during the subsequent memcpy further down in this funct=
ion?

> -	if (data)
> -		memcpy(sec->data->d_buf, data, size);
> +	if (!sec->data_overallocated)
> +		alloc_size_old =3D size_old;
> +	else
> +		alloc_size_old =3D max(64UL, roundup_pow_of_two(size_old ? : 1));
> =20
> -	sec->data->d_size =3D size;
> -	sec->data->d_align =3D sec->sh.sh_addralign;
> +	alloc_size_new =3D max(64UL, roundup_pow_of_two(size_new ? : 1));
> =20
> -	offset =3D ALIGN(sec_size(sec), sec->sh.sh_addralign);
> -	sec->sh.sh_size =3D offset + size;
> +	if (alloc_size_new > alloc_size_old) {
> +		void *orig_buf =3D sec->data->d_buf;
> +
> +		sec->data->d_buf =3D calloc(1, alloc_size_new);
> +		if (!sec->data->d_buf) {
> +			ERROR_GLIBC("calloc");
> +			return NULL;
> +		}

If calloc fails here, does assigning its result directly to sec->data->d_buf
clobber the valid pointer to orig_buf?

It appears orig_buf is never freed on this error path, which might leak the
original buffer if it was previously owned by objtool. Would it be safer to
keep the original buffer pointer intact on allocation failure?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1778642120.gi=
t.jpoimboe@kernel.org?part=3D12

