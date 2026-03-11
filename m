Return-Path: <live-patching+bounces-2190-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AGOSGVH3sWl7HQAAu9opvQ
	(envelope-from <live-patching+bounces-2190-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:14:25 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0790026B458
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:14:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 58B2B3022066
	for <lists+live-patching@lfdr.de>; Wed, 11 Mar 2026 23:14:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DEFE3A16A2;
	Wed, 11 Mar 2026 23:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XwKwXLr+"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6AD377542
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270862; cv=none; b=iex8OgtAd0SlKumn23t2ub1rP66LYlSvqQ6WPfZ9EqjN6uQ6ty5XIKWXQ1v1TU6L/2it9BcegThiANlrihz3jrC6fHr8TQiwUgOHGuSrloY2It2uMEQ3TMB4RmmpdkNMtu1KfxRMjsKwn3ZbzqkUjbdEEIe1I5o/lUMhwPSkMqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270862; c=relaxed/simple;
	bh=xjrAc3qmId1a2v9e00uKv43/2Twl2eGTpfjvSlvf8go=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hAHPNKpmLARV/QLocN5Ns1L+0P1LOcSHaYosWdMoZKcEBX+78eGHyTlgr5M5Uqic1Ym3kokwbUjuHW+sUcR+cVjRuzEPCh1BRc8BS8eSJx0bzHmQIEwRS5XNu2X/meE3FmRSk9xszjN3im0Z3IZHpPkb6ysX5GmmF0Cnc5SX4do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XwKwXLr+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26BBC4AF09
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773270861;
	bh=xjrAc3qmId1a2v9e00uKv43/2Twl2eGTpfjvSlvf8go=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=XwKwXLr+68Bkt2J0nDWHpAD2Gm506XyOlKJEfbrXqs6AlhVJ+M+6Cz2VT9fd/Wq/X
	 03t9uYksFdQZyAqVdyJRx2aDhpL2gzEckiPeQyHT6nbOb5UySp0Ee1c6zuOoe5HMYd
	 Ni1xjaQ1Xe2cOjhsOhHtsxr94dste5XooGrGykMKARPCvwaD/UVWzNuzZhwkyt2pbu
	 FdW0N0oPPpCntzY9cJuIcBXEOiza7f+OWV/kHxMy6d3118PQ6S5EVhyQV/SFBZXj2k
	 ABif4Xrc2ktcZ4lXDqjyQuxkuI0JS/u8ZIbkV39ojxyRo36br2FlBW7T9U+gJFj77V
	 dcFBWZ5bBGp+Q==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-899fc265126so4602816d6.1
        for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 16:14:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUyPnsbEy1p5MDr8/irOPfXijr9QmZ4CHv6So42spkWqqBOty7tGkEkdRl/KejStjWjxnC0rOkZ2fhoBaAN@vger.kernel.org
X-Gm-Message-State: AOJu0YyBIpEeMoHBVoH1E3oceENFXKjKFop1590rKtc92mlru08lwEFG
	CdWJcXdD23oN8JtVab1Sg/TsI/Hmuplm/zcUcbNykSIxkQLAdH086TMQlEaHrZMKugiYsSI9Sih
	oO3McwWPRKc/AXE2mzxUEaDDdipMkjsI=
X-Received: by 2002:a05:6214:d8c:b0:89a:4e3:aa3a with SMTP id
 6a1803df08f44-89a66a14d4cmr62957826d6.28.1773270861124; Wed, 11 Mar 2026
 16:14:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1772681234.git.jpoimboe@kernel.org> <1af3deb308fd59086b63690c1e7b53586ba3c5e7.1772681234.git.jpoimboe@kernel.org>
In-Reply-To: <1af3deb308fd59086b63690c1e7b53586ba3c5e7.1772681234.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Wed, 11 Mar 2026 16:14:09 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5Rkfj8XGZJnDb38sLaAMv=+dEjXaEm1oGG8OiZe8U96w@mail.gmail.com>
X-Gm-Features: AaiRm52SG38bxq2YdjNi5QYWzZEPiXxfjKoBoY-Ep8HQxEshw-prsY3revpgMhk
Message-ID: <CAPhsuW5Rkfj8XGZJnDb38sLaAMv=+dEjXaEm1oGG8OiZe8U96w@mail.gmail.com>
Subject: Re: [PATCH 11/14] objtool: Allow empty alternatives
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
	TAGGED_FROM(0.00)[bounces-2190-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 0790026B458
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 4, 2026 at 7:31=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> arm64 can have empty alternatives, which are effectively no-ops.  Ignore
> them.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

