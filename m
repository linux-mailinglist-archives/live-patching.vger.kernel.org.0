Return-Path: <live-patching+bounces-2217-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0H9PLvieuWk1LQIAu9opvQ
	(envelope-from <live-patching+bounces-2217-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 19:35:36 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DB6F82B0FC8
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 19:35:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 386E430225A4
	for <lists+live-patching@lfdr.de>; Tue, 17 Mar 2026 18:21:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0934B37FF49;
	Tue, 17 Mar 2026 18:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HKcRrpnF"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA11F37F73E
	for <live-patching@vger.kernel.org>; Tue, 17 Mar 2026 18:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773771715; cv=none; b=X+7i88j+RPUM14U1KlS2UFD0/uTZsCiCcwJPFDGlOT4/gGVZP277+N5gvHk3NR+X0zRtMItHZjm9G9xLOeM0lUKMjdhFmEqz3gb5e6mmWmzvCLSJFM1QnNj5nDhslioEmMRxkGp+KMzqkpOGsIwcoBqVVc83sPnnxMrZe8tmUvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773771715; c=relaxed/simple;
	bh=sf75n7CEjU21BmUF3XvVzdQKRuDjc/QZKUiZWLivWoM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sPMRuyidacB/cK7rzqHDitYkfISCiZKWrlhHcsVmBefSVAgrlhZ8HGQMV/BoiM1A66dbenHDhNJ9U2eCFcvPTSQPvECRQNwwBssxxl9pLHA0DzHOUNmOoNqBd+7o8Q0iF+wBHw0dTT90ReMCBGZFHYpe472SWrFqxQX6gxKfKbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HKcRrpnF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B65C2BCB8
	for <live-patching@vger.kernel.org>; Tue, 17 Mar 2026 18:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773771715;
	bh=sf75n7CEjU21BmUF3XvVzdQKRuDjc/QZKUiZWLivWoM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HKcRrpnFq0OQgkQVHe4gTHn6G+/D4MqldIR9VV6tweATZ+Q92eMc+dGP326WyDhyo
	 32Ubmp06hNjY8SPmHuFWQ2Tu5OKUmVIo7uKy8x961DnXMC54L0swOlUJ/azo0fe8pO
	 TTr+m0FUDtqG1toS3rPVkZ7FwEpj5DCFQmiZ46aZWI+ipAHZgDtPA5Cvp1o0WVANoi
	 /V+Ex4qvmRtcyjRX9GS8HPHWBRuwo1dMuAXkShquJSHX+hNbBLRahqMkZnWdZkttIG
	 KjT0C863L6HeG5Wwz1zzoU7gLAKIs/GLShYu/ekCG8zMdQxUFzvDcoiB7BpowuAToV
	 Am9hm6dBaN5ag==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-899eabc5292so69391656d6.0
        for <live-patching@vger.kernel.org>; Tue, 17 Mar 2026 11:21:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVIEO78+3ggNNiBu8g/HWUiud12bFwCA4UVY1oZEcx40CFKOKYQW1rLxMVywEBj9uPsrAo8rtskawGuO1eQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ3BGXTl4btHFcV5acxKJ0o1VGH1eFbsbDWkgTScdeD44CEuSy
	nHrqzJIQcumLr8aTgtNO7mFMWkEz9Quv9JdnaT2lHBKfsou9Ae+eo5F2nNlRiO39SfLeega820c
	b1vd80gc8e3aBENJiRc5+Wy9XCDQsafE=
X-Received: by 2002:a05:6214:2a47:b0:89a:502:6055 with SMTP id
 6a1803df08f44-89c6b4f35b5mr8847036d6.24.1773771714566; Tue, 17 Mar 2026
 11:21:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1772681234.git.jpoimboe@kernel.org> <697c09ca0a8ffd545aa875e507502f62ad983419.1772681234.git.jpoimboe@kernel.org>
 <CAPhsuW6Cyw_z+9sWt5G1XOp94z8BbwNmsoVE9=iM8WQfkuNDBA@mail.gmail.com>
 <xzezfjfb5uttvmg2divzk3toym3qqvkh5c4w2enamsrku342m3@bogfmdj65wql> <e2yxamlxwif5kxur7thr4x7yp7ppbde6awzm6vomdfkg6auxeq@aaahh3aclf2e>
In-Reply-To: <e2yxamlxwif5kxur7thr4x7yp7ppbde6awzm6vomdfkg6auxeq@aaahh3aclf2e>
From: Song Liu <song@kernel.org>
Date: Tue, 17 Mar 2026 11:21:43 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6SsDTDCJ8-w9OP3FeS2d0Rj6jgP7gYbzD3pZhAmK5nAg@mail.gmail.com>
X-Gm-Features: AaiRm51nRAAg6m2ft7E7fQyeG7Vv3eFOij_rwGjVq5EaQ-JWDRFRn45eJM6ROcw
Message-ID: <CAPhsuW6SsDTDCJ8-w9OP3FeS2d0Rj6jgP7gYbzD3pZhAmK5nAg@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2217-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: DB6F82B0FC8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Mar 17, 2026 at 10:52=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.or=
g> wrote:
[...]
> >
> > Yeah, I think that would be a good idea.  Will do that for v2.
>
> So, in general ARCH is complicated.  For example:
>
>  - ARCH=3Darm64 would never match "uname -m" (aarch64)
>  - ARCH=3Di386 would use the same gcc binary (no cross-compiler needed)
>  - I'm sure there are many other edge cases...

Agreed. I haven't worked with i386 for a long time, but I did notice
the arm64 vs. aarch64 difference.

> Instead of a manual error, it may be simpler to just let the build fail
> naturally if the user doesn't set the right ARCH.
>
> Though, I think the check can be improved slightly, as ARCH is a
> reasonably good indicator that cross-compiling is happening.  So I can
> at least add an ARCH check at the beginning like so?
>
> cross_compile_init() {
>         if [[ ! -v ARCH ]]; then
>                 OBJCOPY=3Dobjcopy
>                 return 0
>         fi
>
>         if [[ -v LLVM ]]; then
>                 OBJCOPY=3Dllvm-objcopy
>         else
>                 OBJCOPY=3D"${CROSS_COMPILE:-}objcopy"
>         fi
> }

Do we need ARCH when CROSS_COMPILE is set? I was
under the impression that CROSS_COMPILE doesn't require
ARCH.

Thanks,
Song

