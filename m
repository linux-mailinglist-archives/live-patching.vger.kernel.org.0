Return-Path: <live-patching+bounces-2828-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QNSdB2t1BmoUkAIAu9opvQ
	(envelope-from <live-patching+bounces-2828-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 03:22:51 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B5205485EE
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 03:22:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 93A7730121C9
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 01:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3AEB36CDF3;
	Fri, 15 May 2026 01:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GcV7Zhql"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05D135BDCA;
	Fri, 15 May 2026 01:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778807988; cv=none; b=sqSAgqFnE5W5kdxwaNslklRtA2+Po6D+9f5rnhLoaVYov8Ul0BrlsFWY2lKJf+/O5eEa0nhTg7JF5RK7v7zmkouFCOBjAiRMOfA3BKfF7yDudGIXMGc8tb14zFGeQuT2tcnhs2aZHm8IT5u440kZnqFKy5IuEPFrhB/iG1d5tHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778807988; c=relaxed/simple;
	bh=3j+5BX7wS+F4Sxy4cieVbQ+E3J8B4XkGmkCnhpoT/H8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LsVhsVSHB1PgUK3hkY74eWni4k0aOuRia/PKCM3s+W5UMNDLOFGLZb+spn26TI/ADklntv0aNBULUUdIb9Eu984nvk1LKhp7PQv4Y/bBuUtgkjEV4H/pz9Nto/zRH3tytOZrQzo7jXxgiClvfGDDimkT3NE5S8Jw6RqufQqoBuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GcV7Zhql; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F225CC2BCC7;
	Fri, 15 May 2026 01:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778807988;
	bh=3j+5BX7wS+F4Sxy4cieVbQ+E3J8B4XkGmkCnhpoT/H8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date:From;
	b=GcV7ZhqlUSboF6CD1sjOsAE4IYTwRxyYAGQU19lsJe9QOk6Im3vb2h2Qmm0LMiPbA
	 GR4SAQQIt80eZV4WxxKf5gr+lXzvAgaRL1Dpje2ptn5l97L1Z/rBsEV6ox/Kbm9240
	 3P6uf7zdIFWHbGUodD6B1QrZwluS+Zo6ja3t7yDHFiNSnxC8NVjRFN2fld0mGRGtw1
	 CAQMyCUIi/oM68b6dSUTdyNj1wfUp+H3Rl1QyCnAjiHYoiLlaUbywWmFweJibfJJos
	 ds2rzDjvppaUNZb+Q+9f1HsH3PUBt40eLj4zXOKghe+V8BuD296aaEsxzIg7Q6Is3O
	 4g7mst3vcA2FA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 17/21] objtool/klp: Don't correlate arm64 mapping
 symbols
Reply-To: sashiko-reviews@lists.linux.dev
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, "Petr Mladek" <pmladek@suse.com>, "Song
 Liu" <song@kernel.org>, live-patching@vger.kernel.org, "Mark Rutland" <mark.rutland@arm.com>, "Peter
 Zijlstra" <peterz@infradead.org>, linux-arm-kernel@lists.infradead.org, "Will
 Deacon" <will@kernel.org>, "Miroslav Benes" <mbenes@suse.cz>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Joe Lawrence" <joe.lawrence@redhat.com>
In-Reply-To: <48efc64058f667159d3dedf367c1d4cdedf84f1c.1778642120.git.jpoimboe@kernel.org>
References: <48efc64058f667159d3dedf367c1d4cdedf84f1c.1778642120.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 15 May 2026 01:19:47 +0000
Message-Id: <20260515011947.F225CC2BCC7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: 1B5205485EE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2828-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[smtp.kernel.org:mid,sashiko.dev:url,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The `is_mapping_sym()` function relies on an overly broad substr=
ing match (`strchr(sym->name, '$')`), which risks falsely classifying any u=
nannotated (`STT_NOTYPE`) symbol containing a `$` as an ARM64 mapping symbo=
l.
--

commit fb925cb10f7a9c6ab8ecefca87d3cd3b4e4da879
Author: Josh Poimboeuf <jpoimboe@kernel.org>

objtool/klp: Don't correlate arm64 mapping symbols

This commit updates the livepatch diff tool to skip the correlation of arm64
mapping symbols. These symbols mark transitions between code and data but a=
re
not standard symbols that require correlation.

> diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> index eb21f3bf3120b..e1d4d94c9d77c 100644
> --- a/tools/objtool/klp-diff.c
> +++ b/tools/objtool/klp-diff.c
> @@ -501,6 +501,7 @@ static bool dont_correlate(struct symbol *sym)
>  	       is_prefix_func(sym) ||
>  	       is_uncorrelated_static_local(sym) ||
>  	       is_local_label(sym) ||
> +	       is_mapping_sym(sym) ||

Does this code risk falsely classifying user-defined or macro-generated
assembly labels as mapping symbols?

Looking at the definition:

tools/objtool/include/objtool/elf.h:is_mapping_sym() {
        return is_notype_sym(sym) && strchr(sym->name, '$');
}

Because it relies on a broad substring match, could this exclude valid
unannotated STT_NOTYPE symbols containing a $ from correlation across all
architectures?

Triggering a livepatching failure would require an unusual edge case, but
would it be safer to use a stricter match for standard arm64 mapping symbol
formats like $x or $d?

>  	       is_string_sec(sym->sec) ||
>  	       is_anonymous_rodata(sym) ||
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1778642120.gi=
t.jpoimboe@kernel.org?part=3D17

