Return-Path: <live-patching+bounces-2825-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oFJVK0lUBmqnigIAu9opvQ
	(envelope-from <live-patching+bounces-2825-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 01:01:29 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 532DA547A1C
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 01:01:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 43210301254B
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 23:01:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B9B0319847;
	Thu, 14 May 2026 23:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecsi441U"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE0B303A0D
	for <live-patching@vger.kernel.org>; Thu, 14 May 2026 23:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778799686; cv=none; b=GdA86DM8UeJ5dEoHt5al26CKiuoFLBYKTXkwXZ8nVuGyEj7/Co3P++DSd3JsNlyvVVILk+fy/n6sC9MvnwIBStn9v5WV19pRdAF1sjkPyl5G5FEWrH6CCr/LkgjB03ED05t1r05P0JhgxFWfEUChIxynAwVDkYW/8GJer6qNAJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778799686; c=relaxed/simple;
	bh=la0Ors1jDTuogJnAQ3BBDAkeIVg19fZqxef8LOJWy/c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DEhm0VYDlXAeCya2AGxHeE6yCLQyIImlEPJnUsSE91QCBUBO1VM2iaC/2laEcxpGjqqlR8lG98NgCbIZtDs+GAGOjOr8UM1x5STy9ubm1WxRMggqglx4EN1bI+qLuFs/7uNakesYdcA4wlxFVnZr/GRIq/0YG1am1raKwS1wktQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecsi441U; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4236C2BCB3;
	Thu, 14 May 2026 23:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778799685;
	bh=la0Ors1jDTuogJnAQ3BBDAkeIVg19fZqxef8LOJWy/c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date:From;
	b=ecsi441Uk2Y1gvcsmSgCIJgYySzyGshKQrZbhh345He2sS/yJqeEtAxbZD5fRy5JE
	 y22Ebl5sQdr085Y8znjm3t87Ozl44frSpwkf9/2EkFMQDzmz8rR6eWppoLjPvkJjJy
	 KBHcoD3zD7xNoqb6rez7T8TF8AAafIMei/R0XRHsmEUHbvkBta9mdcK851usJ+WSrK
	 +UJqSdX320tMT43aR4x4UXxxK3255PT4XPO0bj5ThhK+6KdqcfIuVZmaEn0zR83wst
	 lLspuy7TeHIiDR9lvqPavTRrHiH65kFNA/lFcoxzMtMJwckifMM3y+2Kw6SAFvFseQ
	 s48+a2H0qEUTA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 6/6] livepatch: Support replace_set in shadow
 variable API
Reply-To: sashiko-reviews@lists.linux.dev
To: jpoimboe@kernel.org, joe.lawrence@redhat.com, song@kernel.org, mbenes@suse.cz, jikos@kernel.org, pmladek@suse.com
Cc: "Yafang Shao" <laoar.shao@gmail.com>, live-patching@vger.kernel.org
In-Reply-To: <20260513143321.26185-7-laoar.shao@gmail.com>
References: <20260513143321.26185-7-laoar.shao@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 14 May 2026 23:01:23 +0000
Message-Id: <20260514230124.A4236C2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: 532DA547A1C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2825-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,live-patching@vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	REPLYTO_DOM_NEQ_FROM_DOM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,lists.linux.dev:replyto,smtp.kernel.org:mid]
X-Rspamd-Action: no action

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Newly allocated shadow variables fail to store the `replace_set` i=
dentifier, breaking all subsequent lookups and leading to unbounded memory =
leaks.
- [High] The `klp_shadow_combined_id()` function invokes undefined behavior=
 and loses data on 32-bit architectures by shifting a 32-bit integer by 32 =
bits.
- [High] Changing the shadow API `id` parameter to `unsigned int` silently =
truncates 64-bit `klp_state` identifiers, leading to memory leaks.
- [Low] Modifying the `klp_shadow_*` function signatures breaks the build f=
or in-tree callers.
--

commit 91116e31e667d0beea437b5048ab5a62099a5eed
Author: Yafang Shao <laoar.shao@gmail.com>

livepatch: Support replace_set in shadow variable API
   =20
To support more complex livepatching scenarios where multiple
replacement sets might coexist, extend the klp_shadow API to
include a replace_set identifier.

> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index c9f2036dfefcf..cee35f5cae9ad 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -192,15 +192,17 @@ static inline bool klp_have_reliable_stack(void)
>  	       IS_ENABLED(CONFIG_HAVE_RELIABLE_STACKTRACE);
>  }
> =20
> -void *klp_shadow_get(void *obj, unsigned long id);
> -void *klp_shadow_alloc(void *obj, unsigned long id,
> +void *klp_shadow_get(void *obj, unsigned int replace_set, unsigned int i=
d);
> +void *klp_shadow_alloc(void *obj, unsigned int replace_set, unsigned int=
 id,
>  		       size_t size, gfp_t gfp_flags,
>  		       klp_shadow_ctor_t ctor, void *ctor_data);

Does this signature change break the build for existing in-tree callers?

It looks like samples/livepatch/livepatch-shadow-fix1.c and
tools/testing/selftests/livepatch/test_modules/test_klp_shadow_vars.c
might not have been updated to pass the new replace_set argument.

[ ... ]

> diff --git a/kernel/livepatch/shadow.c b/kernel/livepatch/shadow.c
> index c2e724d97ddf2..35e507fae4458 100644
> --- a/kernel/livepatch/shadow.c
> +++ b/kernel/livepatch/shadow.c
> @@ -59,6 +60,11 @@ struct klp_shadow {
>  	char data[];
>  };
> =20
> +static unsigned long klp_shadow_combined_id(unsigned int set, unsigned i=
nt id)
> +{
> +	return ((unsigned long)set << 32) | id;
> +}

On 32-bit architectures that support livepatching (such as 32-bit PowerPC),
unsigned long is 32 bits wide. Does shifting a 32-bit integer by 32 bits
invoke undefined behavior here?

Furthermore, since struct klp_shadow->id remains defined as an unsigned lon=
g,
it cannot physically store a 64-bit combined ID on these systems. The
replace_set value might be entirely truncated, resulting in hash collisions
and subsequent issues when multiple sets manage the same resource.

[ ... ]

> @@ -126,7 +134,7 @@ static void *__klp_shadow_get_or_alloc(void *obj, uns=
igned long id,
> =20
>  	/* Look for <obj, id> again under the lock */
>  	spin_lock_irqsave(&klp_shadow_lock, flags);
> -	shadow_data =3D klp_shadow_get(obj, id);
> +	shadow_data =3D klp_shadow_get(obj, set, id);
>  	if (unlikely(shadow_data)) {
>  		/*
>  		 * Shadow variable was found, throw away speculative
> @@ -147,8 +155,8 @@ static void *__klp_shadow_get_or_alloc(void *obj, uns=
igned long id,
[ ... ]
>  	}
> =20
>  	new_shadow->obj =3D obj;
>  	new_shadow->id =3D id;

Because the id argument is now a 32-bit integer, the upper 32 bits of
new_shadow->id will be zero. Should this be initialized using
klp_shadow_combined_id(set, id) instead?

Lookup functions like klp_shadow_get() and klp_shadow_free() search using
the 64-bit composite ID klp_shadow_combined_id(replace_set, id). When
replace_set is non-zero, this lookup will always fail.

This means klp_shadow_get() will erroneously return NULL, and
klp_shadow_get_or_alloc() could duplicate variables indefinitely, leading
to unbounded memory leaks.

[ ... ]

> diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
> index 43115e8e8453c..6e3d6fb92e64a 100644
> --- a/kernel/livepatch/state.c
> +++ b/kernel/livepatch/state.c
> @@ -203,7 +203,8 @@ void klp_states_post_unpatch(struct klp_patch *patch)
>  			state->callbacks.post_unpatch(patch, state);
> =20
>  		if (state->is_shadow)
> -			klp_shadow_free_all(state->id, state->callbacks.shadow_dtor);
> +			klp_shadow_free_all(patch->replace_set, state->id,
> +					    state->callbacks.shadow_dtor);

The shadow variable APIs previously accepted an unsigned long for the id,
allowing 64-bit identifiers. The new klp_shadow_free_all() now accepts an
unsigned int, but struct klp_state still defines id as an unsigned long.

Will the implicit cast from unsigned long to unsigned int silently truncate
the upper 32 bits of state->id on 64-bit platforms?

If the original ID exceeded 32 bits, the core might fail to locate and free
the correct shadow variables, causing a permanent memory leak during
garbage collection.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260513143321.2618=
5-1-laoar.shao@gmail.com?part=3D6

