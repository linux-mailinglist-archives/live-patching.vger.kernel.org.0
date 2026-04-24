Return-Path: <live-patching+bounces-2521-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CG1eLQLZ62nRSAAAu9opvQ
	(envelope-from <live-patching+bounces-2521-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 22:56:34 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A03E4635A8
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 22:56:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8BE39300679E
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 20:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6813FB7DC;
	Fri, 24 Apr 2026 20:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pBDIjeh2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294A137C92A
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 20:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777064190; cv=none; b=jZLaZoeWRBk4sQHkAlVxlYh0Alwkh89E2uPrbxHIyeQENNRSPAR/+ANoHMkEfNMhvval8BznwsFhGxkW86KUIVjnI2Cre0uKpjcnVy9HiWuNQTTdn3MO+LLC1KrbHBq5ytMqFnoWgjqQ5+gS23ksC3sVOyb+fP7oMxYNjart9X4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777064190; c=relaxed/simple;
	bh=kPLhdTQay+0C9qTsOJxFhNbOrNUuEvhMdQc7QspcTJY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kn99geNMWePG9TQSEOyg9BfmHpfHFKdDeXmWei/sGfnnlujwzf27pa+EucqMUv/f60p8xLDOWKnc391aalo/U5hZO5yBAvhdTuQPVA1WB0fYI9j88qS7N8254i3WcgkFisYZ7QzAB3wqpnx/54FcyOAV/qVfTJTh3Pd9/t/Jd/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pBDIjeh2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A17C2BCB4
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 20:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777064190;
	bh=kPLhdTQay+0C9qTsOJxFhNbOrNUuEvhMdQc7QspcTJY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pBDIjeh25uxokebuhA6ok9vjvG8WYK4aZWs3Hb+93A1BGzr3u6t6ypYnPvuCdRKLo
	 HTlxvDsHBzY2HXRYEn0S+6Qwb4oZb+UZjFXqpNV6Mdn4SNwcPVL4DZ7zemp1O8FAGB
	 6o2rGL9LXVDKJm1EXWFHK+MRTGK2x9aY6dXbEJskE3qZ4Bsry7jRMBA6XwZkamK4R7
	 ynI4CfcdQsS28m200m4RbDXeWfH4vjJA0yJgpm9WC2WNeDfcc/R83JYUFmoY+tVIwu
	 UogCCegGZxMZjYXjDNu7IjwMihZ+9yXbXa7ogJVwS6FH1Zdls7pTJAMznAYpxZd2vV
	 HDZphjLHhJ9Aw==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8acb3daf2aaso128064166d6.0
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 13:56:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8oyt4f5VhnYpTar1M6s2VqnZjM3674TM1gJ1DpdZ/AEGWBuSHT79RU/g+Q/zMKBi8FwPQHqxAhgBYhjCjb@vger.kernel.org
X-Gm-Message-State: AOJu0YzYQhHboM4AMojp95rknO+PA1Ty1ql7KYKUZSJFgNiOV3oqo1We
	3EtL1ljya6rmGCEjwvc18foTuSD/NSXExdMS0o47gzRZKOnc/wANjdLjR9AcHVNixM+qZTvL85M
	gRVEXAcCYR2kGUhYXpAWThVnmE5k8LFk=
X-Received: by 2002:a05:6214:4783:b0:8ac:b2e1:37a4 with SMTP id
 6a1803df08f44-8b02812e432mr477688486d6.25.1777064189234; Fri, 24 Apr 2026
 13:56:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <1dc8b127ff0b1252e53bb7e6130ed46c60f57c25.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <1dc8b127ff0b1252e53bb7e6130ed46c60f57c25.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 13:56:17 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7fcJPF=sXX=5TcgcC-R4LUQimLedqbAMBUBT-9WrO3dQ@mail.gmail.com>
X-Gm-Features: AQROBzB9W-RAYPleesdZxj-OM29kFCUcS4E_CFTCyNECj15h8hSQPn1B4iNY1xs
Message-ID: <CAPhsuW7fcJPF=sXX=5TcgcC-R4LUQimLedqbAMBUBT-9WrO3dQ@mail.gmail.com>
Subject: Re: [PATCH 07/48] objtool/klp: Don't correlate absolute symbols
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4A03E4635A8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2521-lists,live-patching=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[]

On Wed, Apr 22, 2026 at 9:04=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> Some arch/x86/crypto/*.S files define local .set/.equ constants that get
> duplicated in vmlinux.o.  This causes klp-diff to fail with "Multiple
> correlation candidates" errors since it can't uniquely match these
> between orig and patched builds.
>
> Skip ABS symbols in dont_correlate().  They're purely compile-time
> assembly constants that are never referenced by relocations, so they
> don't need correlation.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

