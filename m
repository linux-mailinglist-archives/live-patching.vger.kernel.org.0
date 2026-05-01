Return-Path: <live-patching+bounces-2677-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aK8eM5CC9Gn8BwIAu9opvQ
	(envelope-from <live-patching+bounces-2677-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:38:08 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 69E444ABAF1
	for <lists+live-patching@lfdr.de>; Fri, 01 May 2026 12:38:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 876E230055B0
	for <lists+live-patching@lfdr.de>; Fri,  1 May 2026 10:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C28C387581;
	Fri,  1 May 2026 10:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fiLHgW5U"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A130387367
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777631884; cv=none; b=HEVKSRTUQXhjIRAwL8rfXXz2FyTy++H4lhW0p+7G5CNDrHhJMqEKVdaS6JIsiuoCiV6ZckbUjQ6OoMXBl3dA/daUZlR4Wh6lCBJW/w9MlzIe11L1FfxanJj4qhNoB84GkBdAAmXhUnMPc8GdhEhkFMDGPR0veI4j1ocrbh5sLFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777631884; c=relaxed/simple;
	bh=ADJ+XXk4ifpXkvpxOT38zLKvX5yGFhWH56lSwP5Dml0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rDO/LTr3CDeVmrf9Q05L3Wpp6I7N32FLGyQJSVAgc6B+LiO4fKLpg86R8xWodS9AwGZHf90HxsfEcFMWJOyVE+SEnF8IHWR7y/gYfJftXi8OJ/LDJe2m+KZdMAsU0a2CXwHMVHzh9vVeq0f/1xT1YGdXbydQT55PWBHF+XJ1JyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fiLHgW5U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA119C2BCC6
	for <live-patching@vger.kernel.org>; Fri,  1 May 2026 10:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777631883;
	bh=ADJ+XXk4ifpXkvpxOT38zLKvX5yGFhWH56lSwP5Dml0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fiLHgW5U0g6BWheBXV5wpu15asdhLMNlrBSRoh0kl3pOctQ4f2qU6qzjj1pq8BQGh
	 g/pM/0Vb7tSWqYy9mGErSZj3x/7UVfTHwiKLhnJcgJmpzPJh2YF3VsoBSE48aNUBr4
	 3f9XIHTzb8mVvtc1wL4/Zow8OQHbugowCX1CTH8uKTtJHd27Zgz33PLX14p0cKncnr
	 2SR2GiKFp3wCy4pZX277WXnVBI+YRpac77fGCR1BWi3jHJGCfrmDrKofyNPtyUeTPY
	 milof0hQAo92uCpjgIV8Jldi5RfNzwsO5GMD5akH3synNJft38vh2K9hJDQ6l2wh/M
	 oZyUt4fLPORCg==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8b038a00370so16975676d6.1
        for <live-patching@vger.kernel.org>; Fri, 01 May 2026 03:38:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/sJ/WXDMTFq/zoAXLrDEHuINMSrRx1Mqdq8TDGYCPzrWeHbNvv3r/OMVIcm+fZRdOh63t9hdoCDb2DBzbP@vger.kernel.org
X-Gm-Message-State: AOJu0Yyry7TX2mE+cZQ+l+9LTYMlwDtVt/5DCQZjKnbVoJsNM5m4xKYA
	UvVuEl93678I/P8jZYx0dA24INobhqESTge4l/tfUy3st8U3YHhPsF4mACKUjaEqoHAsDt8QrOa
	ULw0hvPnKJEps6rblVtHMYgb5ATvETp4=
X-Received: by 2002:a05:6214:4404:b0:8ac:a6bd:503b with SMTP id
 6a1803df08f44-8b5454cfe3bmr34858936d6.15.1777631882969; Fri, 01 May 2026
 03:38:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1777575752.git.jpoimboe@kernel.org> <80d6f8df4db610a6c9f68031dc0153f04814f2fa.1777575752.git.jpoimboe@kernel.org>
In-Reply-To: <80d6f8df4db610a6c9f68031dc0153f04814f2fa.1777575752.git.jpoimboe@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 1 May 2026 11:37:49 +0100
X-Gmail-Original-Message-ID: <CAPhsuW7wAG1MEb2xVxFLN2V_BG4KddhKRXaL9LPxWEP2DUFAJQ@mail.gmail.com>
X-Gm-Features: AVHnY4INr33XOUqS5HbfYrUJk_Tiysx4mvwbLRUCAISAV9L_V1o92e2RseUXFRs
Message-ID: <CAPhsuW7wAG1MEb2xVxFLN2V_BG4KddhKRXaL9LPxWEP2DUFAJQ@mail.gmail.com>
Subject: Re: [PATCH v2 20/53] objtool/klp: Don't correlate .rodata.cst*
 constant pool objects
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 69E444ABAF1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2677-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]

On Fri, May 1, 2026 at 5:08=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> Clang aggregates UBSAN type descriptors into shared anonymous
> .data..L__unnamed_* sections.  This data is used by UBSAN trap handlers.
>
> When a changed function has an UBSAN bounds check, klp-diff clones the
> entire UBSAN data section associated with the TU.  Relocations within
> the cloned section that reference named rodata objects in .rodata.cst*
> (like 'exponent', 'pirq_ali_set.irqmap') become KLP relocations because
> those objects now get correlated.
>
> That results in a .klp.rela.vmlinux..data section which can easily have
> thousands of KLP relocs, most of which are completely superfluous, used
> by functions which aren't cloned to the patch module.
>
> The .rodata.cst* sections are SHF_MERGE constant pool sections
> containing small fixed-size data (lookup tables, bitmasks) that is only
> read by value.  Pointer identity is never relevant for these objects, so
> correlating them is unnecessary.
>
> Exclude .rodata.cst* objects from correlation so they get cloned as
> local data instead of generating KLP relocations.
>
> It might be possible to someday treat UBSAN data sections as special
> sections, and only extract the few needed entries.  But this works for
> now.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  tools/objtool/klp-diff.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> index bf37c652188b..ca87bcb9afa3 100644
> --- a/tools/objtool/klp-diff.c
> +++ b/tools/objtool/klp-diff.c
> @@ -372,6 +372,21 @@ static bool is_initcall_sym(struct symbol *sym)
>                strstarts(sym->name, "__initstub__");
>  }
>
> +/*
> + * Some .rodata is anonymous and can't be correlated due to there being =
no
> + * symbol names.
> + *
> + * The .rodata.cst* sections aren't technically anonymous, they're SHF_M=
ERGE
> + * constant pool sections containing small fixed-size data (lookup table=
s,
> + * bitmasks) which are only read by value, so pointer equivalence isn't =
needed.
> + * They are typically referenced by UBSAN data sections.
> + */
> +static bool is_anonymous_rodata(struct symbol *sym)
> +{
> +       return is_rodata_sec(sym->sec) &&
> +              (!is_object_sym(sym) || strstarts(sym->sec->name, ".rodata=
.cst"));
> +}
> +
>  /*
>   * These symbols should never be correlated, so their local patched vers=
ions
>   * are used instead of linking to the originals.
> @@ -386,7 +401,7 @@ static bool dont_correlate(struct symbol *sym)
>                is_uncorrelated_static_local(sym) ||
>                is_local_label(sym) ||
>                is_string_sec(sym->sec) ||
> -              (is_rodata_sec(sym->sec) && !is_object_sym(sym)) ||
^^^^
This line was added in 19/53. Maybe we can merge 19 and 20?

Thanks,
Song

> +              is_anonymous_rodata(sym) ||
>                is_initcall_sym(sym) ||
>                is_addressable_sym(sym) ||
>                is_special_section(sym->sec) ||
> --
> 2.53.0
>

