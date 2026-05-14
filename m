Return-Path: <live-patching+bounces-2823-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8PimBgJNBmqUiQIAu9opvQ
	(envelope-from <live-patching+bounces-2823-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 00:30:26 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id B1C815477A4
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 00:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1F8BD300788E
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 22:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44A263B6BEB;
	Thu, 14 May 2026 22:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bvAGzvan"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2160438C42D;
	Thu, 14 May 2026 22:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778797822; cv=none; b=hDzvDdr3/1Wl5wQOJ5qIw1WapM4wrMZRhi1BKkeHG5bNjR6bH/5H7pcHlUJVhc9TEAxKv1zmtoimStStZrPi828o7+aKtAjkxxFBLERVS8FZqgHZI1N1xLhJheQ4xm0Y257U5JOr0NyFXUafFQ9uBil1ytCtiw3Gg9cwSec3yYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778797822; c=relaxed/simple;
	bh=5yns+K4CDbbF35ROcL1UsFk0JF6RfU8OVfC6oCazIG8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=EXMCoYCuGV7e9ltv23MeqXEMUKQBoiSgQaSVwxJaKNft8S/2DrQZWqniqRFjzDnPHsrCdU1gIl7x0Zgw86eAxmJdWbk1IF6yclA3ADnATgidNIt6T/zYRyNlUw/BjbHofiS/elFsZYGifLV3Sv7K/xVgtvfRtuyD+xno10UHQAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bvAGzvan; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1326AC2BCB3;
	Thu, 14 May 2026 22:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778797821;
	bh=5yns+K4CDbbF35ROcL1UsFk0JF6RfU8OVfC6oCazIG8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date:From;
	b=bvAGzvanzcVJ4tqsWCZGn3wQSpUAEil8eXUpDwbqMdKk/9uFQMCtC4l8MwdH+oYhn
	 ySrnk0z50ZUIacONiFV6UZf+Q1J5I95aWBe4nc1aPnLN4yT5pZM0c7yOHR17RsK7BN
	 XEld92GAoxisDXweArpdyNQ7sxVUv5UhZagpJzsGDwWZjpTXLxPhaqkXgkL7sMYlWV
	 DnoSW3YUBS8uKCr2oEIMrtCfqwVAQTiIuXwqJ5XgTRLMF9wqFtdW0EJSWl29T9onZJ
	 0bOUFkRAEgRMsXN+5xg1sdUv9sHT6CJLFojYIyVqqTbMjfHHDJAFf5dFbhmilRckiN
	 gkosRnmHX/V+A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/21] objtool: Ignore jumps to the end of the
 function for checksum runs
Reply-To: sashiko-reviews@lists.linux.dev
To: x86@kernel.org
Cc: "Mark Rutland" <mark.rutland@arm.com>, live-patching@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, "Miroslav
 Benes" <mbenes@suse.cz>, "Petr Mladek" <pmladek@suse.com>, "Will Deacon" <will@kernel.org>, "Song
 Liu" <song@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Joe
 Lawrence" <joe.lawrence@redhat.com>, "Catalin Marinas" <catalin.marinas@arm.com>
In-Reply-To: <b3b58101e15e1bb5266e57134f0b65f7d8efdd4b.1778642120.git.jpoimboe@kernel.org>
References: <b3b58101e15e1bb5266e57134f0b65f7d8efdd4b.1778642120.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 14 May 2026 22:30:20 +0000
Message-Id: <20260514223021.1326AC2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: B1C815477A4
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2823-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,sashiko.dev:url,smtp.kernel.org:mid,lists.linux.dev:replyto]
X-Rspamd-Action: no action

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Missing parentheses in the jump destination check causes objtool=
 to silently ignore all missing jump targets when branch validation is disa=
bled, instead of only jumps to the end of the function.
--

commit aa068d4053e8b92ff17082c7a023821e72f5d625
Author: Josh Poimboeuf <jpoimboe@kernel.org>

objtool: Ignore jumps to the end of the function for checksum runs

Sometimes Clang arm64 code jumps to the end of the function for UB.
This commit ignores these jumps to the end of the function for
checksum runs to avoid errors.

> diff --git a/tools/objtool/check.c b/tools/objtool/check.c
> index 10b18cf9c3608..73451aef68029 100644
> --- a/tools/objtool/check.c
> +++ b/tools/objtool/check.c

[ ... ]

> @@ -1593,10 +1609,14 @@ static int add_jump_destinations(struct objtool_f=
ile *file)
>  			/*
>  			 * GCOV/KCOV dead code can jump to the end of
>  			 * the function/section.
> +			 *
> +			 * Clang on arm64 also does this sometimes for
> +			 * undefined behavior.
>  			 */
> -			if (file->ignore_unreachables && func &&
> -			    dest_sec =3D=3D insn->sec &&
> -			    dest_off =3D=3D func->offset + func->len)
> +			if (!validate_branch_enabled() ||
> +			    (file->ignore_unreachables && func &&
> +			     dest_sec =3D=3D insn->sec &&
> +			     dest_off =3D=3D func->offset + func->len))
>  				continue;

Does this condition silently ignore all missing jump targets when branch
validation is disabled?

Because of the || without proper parenthetical grouping around the first
two terms, if !validate_branch_enabled() is true (which it is for
--checksum or --noinstr runs), the rest of the condition short-circuits.

This appears to cause objtool to skip the error reporting and silently
leave the jump destination as NULL for any unresolvable jump in the binary,
instead of only those jumping to the end of the function.

Should the logic be grouped to restrict the exception to the end of the
function?

			if ((!validate_branch_enabled() || file->ignore_unreachables) &&
			    func &&
			    dest_sec =3D=3D insn->sec &&
			    dest_off =3D=3D func->offset + func->len)

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1778642120.gi=
t.jpoimboe@kernel.org?part=3D10

