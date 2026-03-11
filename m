Return-Path: <live-patching+bounces-2188-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6BtUGwv3sWl7HQAAu9opvQ
	(envelope-from <live-patching+bounces-2188-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:13:15 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E0A926B42A
	for <lists+live-patching@lfdr.de>; Thu, 12 Mar 2026 00:13:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9E5F830142AE
	for <lists+live-patching@lfdr.de>; Wed, 11 Mar 2026 23:13:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D8583A1699;
	Wed, 11 Mar 2026 23:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDZDdcVv"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A19739EF23
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773270789; cv=none; b=L/6VNtIQXsDD6Ddgmuyo7Ap8yN1xwucnhP7HuJ8wnorPDyvCGxlk5F+xabL6nDMtKAALXD8V/wW8ynbGcEip2bBGTsK/F9UsOU0BoX5zc+eC9icGYtibrhaG91cRb7qaZkYNCfnFNtMBQVyWvXuaA34S7zHuJYeVi2LjVGzdmKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773270789; c=relaxed/simple;
	bh=z9S5WF2FfgFwvi+OcGmF3o/5fI+CN4zoPI4lv1plycQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dgS9fURYfo8H9a/Wi/KuzDoDIso7elOj9rqrZi+RXmZWGOv3oQUHuXGR+3G4FcXM3GwQ4T0fPbxyJo60RxwMeApbpIVFBWcP1xMk6oAypNkRLhBrg3JQ0RYUlbhHKQu8PLu/m/SF58+bbiTG3wVxFrtGFwpafZe/+flrWzR1MTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDZDdcVv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB32C4AF0B
	for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 23:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773270789;
	bh=z9S5WF2FfgFwvi+OcGmF3o/5fI+CN4zoPI4lv1plycQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hDZDdcVv3vxy/CLRphubWQhqxuIHeZvpfdOKo4zNiz7qraMuiF7U89GtZyjsyfIEK
	 /onh46pvNlFAiGNiDe1nxiqscZWZCWYboXw6C3aF5kDQGadZeXPgOt+RG+Lv8UAOFu
	 rZihD1mJZnHtL4yNuoHz4pBoQ4hBVb9YSB6Vb2X+W6mQTKszQlZYl6U/0ryololMEz
	 AQCu6OUq6lwhf3d8vlkzmqasPpz0ZWod0oBP191Chq7DNr/lZ0sICjEvytTMYKbdnB
	 k28FeefNhe2HVITr8hwfgdZKkQElkUwBD+L1li4xoVoZUutCjYJSzt+Yw3WAiL61dK
	 0If7o3EiTMUVg==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8cd7ecedf2cso37319685a.3
        for <live-patching@vger.kernel.org>; Wed, 11 Mar 2026 16:13:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUKDEirURD8VfB+QlnDItGpmrNTSyYYirC+q//f+njU1zHftBtPfkvhguxeY+QionmytSQiBnV5d9j3oFKj@vger.kernel.org
X-Gm-Message-State: AOJu0Yza8SdbMtojIUJkOwuLLwStrZNF5faZjoiAdKjxt/pQE4aj7zb2
	3qalFQ7xKhb7eYItEljSJMFu9aRNfCZCsN8Hx4Hj+vo9cNYzxKlvBnFmq55vpsx6FeghEWDGJXS
	n84ZdnI7GKVRYXp1cj3r8IJ0sXcdNbRs=
X-Received: by 2002:a05:620a:4009:b0:8cd:79f2:dc3c with SMTP id
 af79cd13be357-8cda1956faamr568490185a.19.1773270788238; Wed, 11 Mar 2026
 16:13:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1772681234.git.jpoimboe@kernel.org> <f85416e754996eeaaf158143e43eea8a81003849.1772681234.git.jpoimboe@kernel.org>
In-Reply-To: <f85416e754996eeaaf158143e43eea8a81003849.1772681234.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Wed, 11 Mar 2026 16:12:57 -0700
X-Gmail-Original-Message-ID: <CAPhsuW67c7BZ9nxnXRVpO0_a9s4SXqZ84mq7aEA30i9-cAyAdQ@mail.gmail.com>
X-Gm-Features: AaiRm51bRfi-7rBVPnt15nYkLz8tBtB897wNTcIGViY4symm4KVh_nRMoC3NvQA
Message-ID: <CAPhsuW67c7BZ9nxnXRVpO0_a9s4SXqZ84mq7aEA30i9-cAyAdQ@mail.gmail.com>
Subject: Re: [PATCH 05/14] arm64: Fix EFI linking with -fdata-sections
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2188-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 7E0A926B42A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Mar 4, 2026 at 7:31=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> When building with func-fdata-sections, the .init.bss section gets split
> up into a bunch of .init.bss.<var> sections.  Make sure they get linked
> into .init.data.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

