Return-Path: <live-patching+bounces-2189-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EO6GNCr3sWl7HQAAu9opvQ
	(envelope-from <live-patching+bounces-2189-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:13:46 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5497F26B441
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:13:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 50B463015891
	for <lists+live-patching@lfdr.de>; Wed, 11 Mar 2026 23:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2892D39936B;
	Wed, 11 Mar 2026 23:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aNd3/ivz"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060D8375AA9
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270824; cv=none; b=mgkET/QmG24yvsvxCDyzV2RgVCigvlywB/R7iVwD0Doi/5l3549LlGXKb4y/ovoKChbwsdoJkvZmXqtAYRm2PIDs9ST1OMSyIv+lGDn6KYSjdiFF/FUgl5KOaHAnU4G3QqC61TQQ9ZdZyqFV7i49+wb/u58xYkKikvz+9DsmRg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270824; c=relaxed/simple;
	bh=+fnd8GyqNif8heEveaiUaU5hVAJSMaWTWNUQxsBz62E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kxdI3Wc4ad+pOKouUaowsrFF2LwX75ORfvKFP1Esp0tgVuzzVVT9S5T8ejGbuufBTebxxyL4v1vSKIsfx/fbUtuJNAVuaC+k54/rX0BDl3hBikQ5o5BPHGZt5z6voC34ntX1ETOO4cyb96I4RmbeNRpc3wiIiHGS6gBOFvdHz58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aNd3/ivz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B99C4AF0E
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773270823;
	bh=+fnd8GyqNif8heEveaiUaU5hVAJSMaWTWNUQxsBz62E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=aNd3/ivzSpKsXILkEa6pWkM9T+0ceORI8IsbXSsjpjnU7YGIzeXaBUyw7vP1GVGBP
	 a9Yiynl9793uKXoFNGHbJWMDXpE8X0Fa7bUakWm0FpaanPmDjs3+Ole7tHrhBdxcuQ
	 NNtd0zRO/xhNsjcXYaO3Bp262jt+GBkQ2hGQ6a3CKDqwIq8onKaLfEWdSSQ1Nk/+Ix
	 Rvg+UgshtP/CDNnwbY7KW1Zei/DjmFo/pnc68MNBG4ME/HOkQL2sG2x+qu7mcmdDbd
	 4aFcUCH46+7k0ZeX8E/v6swA1332LaFxxePjkInLfV+/nQYs/EGNnY7oV8UlhGgD3I
	 uoCsq5b8CRCMA==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-89a1c6dd788so6868646d6.0
        for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 16:13:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU5PjDxPcwSSjO2d/fx5o8qZlKI3ra9GCLUYUAxgURAMHqYe5TcukD6ilJ0KZ2IKqgJHYhjB02+q8VQr9GM@vger.kernel.org
X-Gm-Message-State: AOJu0YyaBjwo8YrjoTkXe7ZshP/ZWszf+IE6QPyzmRgXQGdSg+HK7VVW
	lWgwEyDipM79RClyqh28GEFJd+edEE6jDCRslnwpNoTQq/HK5eiS6fxxr0XQrm+CFOhP76riNcs
	SQHKn82QCMpBy3yH/+ptdX54DLt196EE=
X-Received: by 2002:a05:6214:2483:b0:894:6b9e:253e with SMTP id
 6a1803df08f44-89a66b60bf3mr61486446d6.52.1773270822999; Wed, 11 Mar 2026
 16:13:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1772681234.git.jpoimboe@kernel.org> <696aeb326a797e97b87c7657b5b3d0ada958cc5f.1772681234.git.jpoimboe@kernel.org>
In-Reply-To: <696aeb326a797e97b87c7657b5b3d0ada958cc5f.1772681234.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Wed, 11 Mar 2026 16:13:31 -0700
X-Gmail-Original-Message-ID: <CAPhsuW52kX13KuQqHuq9CReksaV=GTMPoSB3PU8ZOfU-Quo88g@mail.gmail.com>
X-Gm-Features: AaiRm508Or0sfnUqrHy7DAM78r2-dTNuvOfnqws0FNtwIKi1zmJ50NKIsPn7YHc
Message-ID: <CAPhsuW52kX13KuQqHuq9CReksaV=GTMPoSB3PU8ZOfU-Quo88g@mail.gmail.com>
Subject: Re: [PATCH 08/14] objtool: Allow setting --mnop without --mcount
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2189-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5497F26B441
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 4, 2026 at 7:31=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> Instead of returning an error for --mnop without --mcount, just silently
> ignore it.  This will help simplify kbuild's handling of objtool args.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

