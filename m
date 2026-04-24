Return-Path: <live-patching+bounces-2525-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yO1aEore62mdSQAAu9opvQ
	(envelope-from <live-patching+bounces-2525-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:20:10 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B72C246374C
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 23:20:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B0423301DEC1
	for <lists+live-patching@lfdr.de>; Fri, 24 Apr 2026 21:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B47D9337688;
	Fri, 24 Apr 2026 21:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WdOapvhQ"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F87347C7
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777065605; cv=none; b=Vu7hkKpsEopZYEIn9dHamJ2TKQs5d2ALV9zYUpJsCKPWjS62HNzTJuUH+FNDkdrHHrV+LiQO0PXE/0jlK7Q56MeuRy4uRdeQbVU6b/3pAmoSi2gnpfj4zII0T2mn9tf1x/tPJRUDa/CbTxMgaY6q2C+09zWSDgY/0bn6V+TtS5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777065605; c=relaxed/simple;
	bh=j9VQKYaQYsfPhISQaoAwqGiPtu3CEsLVd8SjYKB9yG8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ltpbFxnoYHgHgJvRiPNRWKz6U2Yz2+w92D7mk0mioSp0jd+Q1JZbCXpMdCEV6azovNFXdshzX9yosrmUhYwgvfLMVWiX4UBC4z3VC1MbGpTi7uZk5Ji1BT6NwlqI0A4nqlmiCS1aLnFJGPkkPmCfeKKPS/OyQEm1xltktTn4fmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WdOapvhQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F0A7C2BCB8
	for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 21:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777065605;
	bh=j9VQKYaQYsfPhISQaoAwqGiPtu3CEsLVd8SjYKB9yG8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WdOapvhQcsMGHn+6UJGgjweqtgQaprvoTYIl8MeIq83uflw5comnwIMG7tJC7ZJh4
	 f/SIAiM3Qk9YI1cEs6d5PnZns0IPjZCFWP19NOExEmC144j8WGLkKWovOatJ7lyCJr
	 qbIQsNrx7nwFvaq0ygT3NeCCq6FcnRpTgP7XlaQNHA5IK+NGkiXEXkzwTOifLut5HJ
	 Rs4Xe5QO+tBDkG1YuLFKMc3brJQjhe6Mb+l49Uga6gbBhnBsuq8XPsimED3Buh0lIo
	 IVkjGp08PBCDov4VgML1TzUeLyemLcVb0+8uJl+Yh8ZBegN2neFEDWghVM2r32nFMp
	 nQzqCZpT3Y4IQ==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-89f1e767f92so74723656d6.2
        for <live-patching@vger.kernel.org>; Fri, 24 Apr 2026 14:20:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+r51dZNjW53hqW1F9hSUHDfGf1eiVkkZisyzStQBRjDTEfG0M07R1krQa7aHsjy6mCJLfqq8piGz7O2GHR@vger.kernel.org
X-Gm-Message-State: AOJu0Yyxk+ja8TgGWXg6fW7XB7zJNv6j/zZvxVahFZdy/XpkNbU7S8R2
	7NbReV7uhektNRluW91V2pF95w69yWol/O4njHLBuvnxbnCOJWqFkIKHycaEZ1ywaaF9Aanx9Bg
	QkCSLV4hJrgGEYqY9kadM5nhHQImgqqs=
X-Received: by 2002:a05:6214:3913:b0:8ad:bccd:94cf with SMTP id
 6a1803df08f44-8b0280733ebmr510156996d6.18.1777065604377; Fri, 24 Apr 2026
 14:20:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <99099e77dffb352f97c5276298ab344c186a3ee2.1776916871.git.jpoimboe@kernel.org>
In-Reply-To: <99099e77dffb352f97c5276298ab344c186a3ee2.1776916871.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 24 Apr 2026 14:19:52 -0700
X-Gmail-Original-Message-ID: <CAPhsuW53h4mCj8=0bfGy5N8O9JCUMGgCZTpMY8c140wno+UPXQ@mail.gmail.com>
X-Gm-Features: AQROBzBaQmujN9jknGipATW_P4f-W91jqCDZ1Kh1Ten93sTSwV7fy9hVLUC1Lx0
Message-ID: <CAPhsuW53h4mCj8=0bfGy5N8O9JCUMGgCZTpMY8c140wno+UPXQ@mail.gmail.com>
Subject: Re: [PATCH 11/48] objtool/klp: Fix handling of zero-length
 .altinstr_replacement sections
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B72C246374C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2525-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]

On Wed, Apr 22, 2026 at 9:05=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> When a section is empty (e.g. only zero-length alternative
> replacements), there are no symbols to convert a section symbol
> reference to.  Skip the reloc instead of erroring out.
>
> Fixes: dd590d4d57eb ("objtool/klp: Introduce klp diff subcommand for diff=
ing object files")
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>

With a nitpick below:

[...]

> @@ -1293,12 +1301,15 @@ static int clone_sym_relocs(struct elfs *e, struc=
t symbol *patched_sym)
>                     !strcmp(patched_reloc->sym->sec->name, ".altinstr_aux=
"))
>                         continue;
>
> -               if (convert_reloc_sym(e->patched, patched_reloc)) {
> +               ret =3D convert_reloc_sym(e->patched, patched_reloc);
> +               if (ret < 0) {
>                         ERROR_FUNC(patched_rsec->base, reloc_offset(patch=
ed_reloc),
>                                    "failed to convert reloc sym '%s' to i=
ts proper format",
>                                    patched_reloc->sym->name);
>                         return -1;
>                 }
> +               if (ret > 0)
> +                       continue;

Functions that return -1, 0, 1 are usually more confusing. Shall we add mor=
e
comments for convert_reloc_sym()?

Thanks,
Song

