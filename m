Return-Path: <live-patching+bounces-2829-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OPyBK2iABmrnkAIAu9opvQ
	(envelope-from <live-patching+bounces-2829-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 04:09:44 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E886548A51
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 04:09:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DA68F3059E0A
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 02:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C2134E75A;
	Fri, 15 May 2026 02:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YzzXhh4g"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADC5328631;
	Fri, 15 May 2026 02:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778810926; cv=none; b=j0vFzmo+iK42WEXJQSa08SCXUw8/X/SCGm8cylkU9KvTDVeoS7UcW04P51NanL+0I45vHT+wMOBs3wXTBkHtQAnuhVHi6zCeVMP4Mcj8vXRbRNZQc9nqfD7kMRr70io6FHLTd61UI6BAwjYPf9UJQxlsast6yseuJbyyKwRWL18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778810926; c=relaxed/simple;
	bh=xCHGOvSiHLqCOrP+JKzt9pzABYAnM6/1kNNixxX6KE8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=hQ7OeVbCQwSE6DAH0PBCor+XcFNVDZtxuye3YH5lHFf7ZWnqhS1sy4cxJAfKlIr+U/YVq9oL+2ZGrg0CKreWEoi6pjyRHTgLtID2PvVn8KqniZ4jjVwCv9OYRGqGpH0KqRsJWUNEozzVNdWy83IAMu1KsTOa7/ya9SrZCbmaI+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YzzXhh4g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5B2C2BCB3;
	Fri, 15 May 2026 02:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778810926;
	bh=xCHGOvSiHLqCOrP+JKzt9pzABYAnM6/1kNNixxX6KE8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date:From;
	b=YzzXhh4gwgzBXVS/MYDUB0SY7m548HQFIawW8TFOIdnsUoRcWHkVikXINgzP7785U
	 5USN6u6xcmJ8WjZvkkonQRy7YKoP2kStpWIu5fK6+IuZvOn49UZc24btcdX5q5jpVa
	 5H6BZ9hwmqIAc72r9zyZ+zqtA8+D+N8OYytAEHu48+cLxTsB54UYb+2EClnBWSHPWd
	 p5ct9ch9fYebZC3F7dE/yK/dLoK2KrgDv+l+OZ4nOPYAWVWN+kJkOw6oH1RszTzyXy
	 HwcBB1pFi9EmqJmwi0cQgL/bcXG26lqJUgfG514dX//yNu/QeXbgsr1NhpzyxZvHvl
	 MxiJ2gU1WwMEA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 19/21] objtool/klp: Introduce objtool for arm64
Reply-To: sashiko-reviews@lists.linux.dev
To: x86@kernel.org
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, "Peter
 Zijlstra" <peterz@infradead.org>, "Song Liu" <song@kernel.org>, linux-arm-kernel@lists.infradead.org, "Petr
 Mladek" <pmladek@suse.com>, "Joe Lawrence" <joe.lawrence@redhat.com>, "Mark
 Rutland" <mark.rutland@arm.com>, "Will Deacon" <will@kernel.org>, "Miroslav
 Benes" <mbenes@suse.cz>, "Catalin Marinas" <catalin.marinas@arm.com>
In-Reply-To: <5b66146373b1ff1aba1318fd51867dea2eb882f6.1778642121.git.jpoimboe@kernel.org>
References: <5b66146373b1ff1aba1318fd51867dea2eb882f6.1778642121.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 15 May 2026 02:08:45 +0000
Message-Id: <20260515020845.CE5B2C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: 0E886548A51
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2829-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lists.linux.dev:replyto,sashiko.dev:url,smtp.kernel.org:mid]
X-Rspamd-Action: no action

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The arm64 instruction decoder misclassifies trap instructions (e=
.g., `brk #0x800` used for `BUG()`) as `INSN_OTHER` instead of `INSN_BUG`.
--

commit dd63f0c03bab6a47f34cfcb310454460653638ed
Author: Josh Poimboeuf <jpoimboe@kernel.org>

objtool/klp: Introduce objtool for arm64

This commit adds basic support for arm64 in objtool, initially enabling=20
only the "objtool klp" subcommands.

> diff --git a/tools/objtool/arch/arm64/decode.c b/tools/objtool/arch/arm64=
/decode.c
> new file mode 100644
> index 0000000000000..47658c76e1af0
> --- /dev/null
> +++ b/tools/objtool/arch/arm64/decode.c

[ ... ]

> +int arch_decode_instruction(struct objtool_file *file, const struct sect=
ion *sec,
> +			    unsigned long offset, unsigned int maxlen,
> +			    struct instruction *insn)
> +{

[ ... ]

> +	if (ins =3D=3D 0xd503201f) {
> +		/* NOP: static branch */
> +		insn->type =3D INSN_NOP;
> +	} else if ((ins & 0xfc000000) =3D=3D 0x14000000) {

[ ... ]

> +	} else if ((ins & 0x7e000000) =3D=3D 0x36000000) {
> +		/* TBZ/TBNZ: intra-TU sibling call */
> +		insn->type =3D INSN_JUMP_CONDITIONAL;
> +		insn->immediate =3D sign_extend64((ins >> 5) & 0x3fff, 13);
> +	} else {
> +		insn->type =3D INSN_OTHER;
> +	}

Does this code misclassify trap instructions?

On arm64, BUG() is implemented using the brk instruction (such as brk #0x80=
0).
Since the decoder doesn't appear to check for brk, it will fall through to =
the
else block and classify it as INSN_OTHER.

If INSN_BUG is misclassified as a normal instruction, won't this lose dead-=
end
propagation and corrupt objtool's control-flow analysis?

> +
> +	insn->len =3D 4;
> +	return 0;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1778642120.gi=
t.jpoimboe@kernel.org?part=3D19

