Return-Path: <live-patching+bounces-2186-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eAZPAOL2sWl7HQAAu9opvQ
	(envelope-from <live-patching+bounces-2186-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:12:34 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FF2426B403
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:12:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 50E163035A7F
	for <lists+live-patching@lfdr.de>; Wed, 11 Mar 2026 23:12:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 262023A1687;
	Wed, 11 Mar 2026 23:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SDlYxToe"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AC239EF23
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270749; cv=none; b=t2M83hYgG1FfDaB3mmv9JC/RYvpGTpD7W/OepC7YOvEZ2cKxM1IQkx1BMg6Ys7wo7PyAwaaLv3AVtH0HIsKmqUtIV2m9oCw2G6Fb4thaRjK3aP+Px0h7GECkjkC1wD2Ih2NOZxYUyoksb6ddVdhVOVpbweE17mS31X4iXcvu65U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270749; c=relaxed/simple;
	bh=xBhhGMjdEf/AAt0r3NS/ftcYplPTotkFnhvNtKj38Dc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tt7lN6hAg43bUetViIrCXxMY+GHSkXjGDtwUZry7VJX+xEgTWjVZzb0SNDq3K0CUKVRXFHXRBZGWY/pyRnSQn3gqZiKdNZzWVMiwlsPF02PGZON9Waip+Yv2qkJfeXMCGjxLU7q3GjN9sv/vyfbGJfemCcZDF31iXhvG4IVEUFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SDlYxToe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8104C4CEF7
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773270748;
	bh=xBhhGMjdEf/AAt0r3NS/ftcYplPTotkFnhvNtKj38Dc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SDlYxToegILB0SYrOCc9jqf/1RSBM4kCZYiywc+yvo0PxI9+RoNVAj4DlNa1M9zdB
	 JbiAisvkKUu68Ptozo7g6RizpbFSvjrmMFpld5ALPXF7+yyyIDX2bUTprJt4loOx7+
	 u3G0/XvR9BIBs9Fk2Ushkpq6aiaE2LdV5eKw/8SWlwEFZngnNOBFpob3QlRRb/Ugnn
	 Djq8L3fVTWRa/Nk63f0GEHpyX0H322Wc4iQn3RS7lOcxLv6Cf4IkppS38WcrUmiyaS
	 LktWjYOxwGRLPUXVkm2vT7D9l1/GGrQtV8gLLsgmjOgJyvbR5tFCMTHxvPFBvqG4QU
	 be8ruiHRA6iVw==
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-506aa68065eso3239541cf.1
        for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 16:12:28 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUBm+ysGpsiTSM6J0wizm48MzSfCKbLbNC2cMFGoVDD4ojP86QPMIq98z+7mAYzMB6FP6D/PJXtaAklimz4@vger.kernel.org
X-Gm-Message-State: AOJu0YyY7UsHAWYM4uMPA1eZu6KOV5NzqV9pWOtqzsayxzU3wLburTZC
	h4XWsBI/RtYeBoYeXiQTHcoYNRxFIzwuDT9C4Ot+HHCUbBOm2+JJDt7uS1Tz/DLZ+H+TFyYaNve
	loP17RY6+u+xmKkNu2TOmzKaJi7GioJg=
X-Received: by 2002:ac8:508:0:b0:509:456b:52e7 with SMTP id
 d75a77b69052e-509456b85c9mr21498081cf.16.1773270747795; Wed, 11 Mar 2026
 16:12:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1772681234.git.jpoimboe@kernel.org> <2fa6fbde8c6bbd91df0e2bf48b9c9370047dc61e.1772681234.git.jpoimboe@kernel.org>
In-Reply-To: <2fa6fbde8c6bbd91df0e2bf48b9c9370047dc61e.1772681234.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Wed, 11 Mar 2026 16:12:16 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6-Jeppuw-3dCnS=a31p6uwdQfvW-CDURXh9eyEwHPBUg@mail.gmail.com>
X-Gm-Features: AaiRm52rdNhb-OMPbVu7A6BSy4A_BsoV676rdnM-RkVREh6ybLEJlmVinm4_0hk
Message-ID: <CAPhsuW6-Jeppuw-3dCnS=a31p6uwdQfvW-CDURXh9eyEwHPBUg@mail.gmail.com>
Subject: Re: [PATCH 03/14] arm64: Annotate intra-function calls
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
	TAGGED_FROM(0.00)[bounces-2186-lists,live-patching=lfdr.de];
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
X-Rspamd-Queue-Id: 5FF2426B403
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 4, 2026 at 7:31=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> In preparation for enabling objtool on arm64, annotate intra-function
> calls.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

