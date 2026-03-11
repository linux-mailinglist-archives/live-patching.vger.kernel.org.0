Return-Path: <live-patching+bounces-2187-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0LpzFR33sWl7HQAAu9opvQ
	(envelope-from <live-patching+bounces-2187-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:13:33 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ABA6D26B433
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:13:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1A94E306DF29
	for <lists+live-patching@lfdr.de>; Wed, 11 Mar 2026 23:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FF143A1689;
	Wed, 11 Mar 2026 23:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjLRizsO"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D93E39936B
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270768; cv=none; b=UO1n2avCm2ySZqTe1GdM0I37eDLT4oto6uvQQMvMZnN5ijmS2b5PxQRzs13ZRtBd4pwkwJdG9w62LqCWZnJQBrYBhyTY69Ynp7JmX/+SrnAcGVPRfL+4DP1eZgNWEmAuEyoH5KPmNX3i7dGosesehvVMcqrZH0B4DA49JDhvqO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270768; c=relaxed/simple;
	bh=JRIPifTOp48WDrufwYh8jWnkuAzeptDMhAVCjNqxPTE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q90EWP/0Od1urHl18eixHoxrdq0bnuePA2oV0Fb+nswwfO4K+nfmdIGUf5rGuiEyESrdugzk2pGLOSS/cmI8BEDrr0kqAg0xg5CecdA8Z0WCPFEVQAN9lh2LZOdI4YJEL/DjSrCrH1sI9Wmo/ZEgRaW/Co4M1dNABmYLNiylAu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjLRizsO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280BAC4CEF7
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773270768;
	bh=JRIPifTOp48WDrufwYh8jWnkuAzeptDMhAVCjNqxPTE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=HjLRizsOtiFYfLX5lXV2JeMX5W0/3Ujk/sirhOhshMJPDnnimqINqfsMDj3Yxoi9M
	 W7gZnYmKxkILgLbn2kFgg5TJmCGqR9LOsc3y23GRlvh0iBtRegS4YGKXN0t9r+oBgj
	 +DqJSJjRV3OcgBvlAjXPQatKzpk2sqdQWA3Aeswf3JGXS6bgckSXdBPqS8ZFiJF4qg
	 f/QXlTXpGBSM23BTwR9EAXNQNOKqqtEGO5IRufkP2wOnMN1FWdPrAbVuvsiOFGG3rN
	 QaxybdqIqYzh2hFqs3+/NZ3MjSidpZWVHDhORUTSgjHIAKnlN1YFcloHGC1+JsLkHS
	 tllH2eiQmYO1A==
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-89a09ef1e3aso5491356d6.0
        for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 16:12:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU05+ArY5p4Zx8TrwmA+iPdP8LFsVvJ8KxoIKCz9w62QVYB1DJltPFz8b6YNUB2alAqwQznE6CpHe2Cl6IN@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy4Amc6XPsFO1SFHsHRWLbwBA7VN6mTju7/fwqGHGXtPkm1O5S
	WFIZ6rm9svFe6g3vzQdeyYyudKNUH54eiIiv8PRo5C21+R6w5lEdvjj/ZCTkmrY6E3HptxsJ0C/
	jbFWJo8Euh3ip0w4jmKUUKkb7vEW1sdg=
X-Received: by 2002:a05:6214:19cb:b0:89a:6353:ac1e with SMTP id
 6a1803df08f44-89a66a24d02mr63591736d6.11.1773270767400; Wed, 11 Mar 2026
 16:12:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1772681234.git.jpoimboe@kernel.org> <ec379ccc31c1bf49d918228eaa1ca016e99f267c.1772681234.git.jpoimboe@kernel.org>
In-Reply-To: <ec379ccc31c1bf49d918228eaa1ca016e99f267c.1772681234.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Wed, 11 Mar 2026 16:12:36 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4RrMdW=wfaEboDLrqRrObCmtd9RVTPN2-t01eOonEzpw@mail.gmail.com>
X-Gm-Features: AaiRm50xGeBZSWsH7yQEsvoXAOzI86kL7g2mU0OdtRzDad4qKy-8PbTjs8zPtKU
Message-ID: <CAPhsuW4RrMdW=wfaEboDLrqRrObCmtd9RVTPN2-t01eOonEzpw@mail.gmail.com>
Subject: Re: [PATCH 04/14] arm64: head: Move boot header to .head.data
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2187-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: ABA6D26B433
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 4, 2026 at 7:31=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> The arm64 boot header is mostly data.  Move it to a data section to
> prevent objtool and other tools from trying to disassemble it.  The
> final linked result is the same.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

