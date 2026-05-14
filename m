Return-Path: <live-patching+bounces-2824-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EN+YJ0NPBmoFigIAu9opvQ
	(envelope-from <live-patching+bounces-2824-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 00:40:03 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 046D954789F
	for <lists+live-patching@lfdr.de>; Fri, 15 May 2026 00:40:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C4B8F301A73D
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 22:40:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CFAE3BFE41;
	Thu, 14 May 2026 22:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K1RV5MlM"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A51935F16F
	for <live-patching@vger.kernel.org>; Thu, 14 May 2026 22:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778798401; cv=none; b=pff3NMW0D3FAHe80xNUYCRQ4ADuvBJdDMYiDIVyWjqDLap54BvQxPO1zE1i81lciqW/coSYn00LaA4AObKaddW7VPLUyD222SWyaUrBplQDnvDnTvs0c0hp8bUO5NfwVVjqUyrtVT68rvCKuFUCoy2vHnPnM/4D8ArGcFj8L8Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778798401; c=relaxed/simple;
	bh=EvTZFkKS7++gEod+kuOFlCx2vsi+EHPc++5+vz5dutk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jpePDGlJb2t2IZizvZZVRwoluaj5VwlTPqYWV7UScEbtIbNtaI2sICraly2FVEjz9LxJDuMUZhMEeDnSvHX7ZzFbt3DavsROeEnlVkvRGZAcgQhGuF9PtfMm4kECc+rulf4A2RhreyE8fKvPowEggwondUyzMGradwa0+CzJhGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K1RV5MlM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8316FC2BCB3;
	Thu, 14 May 2026 22:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778798400;
	bh=EvTZFkKS7++gEod+kuOFlCx2vsi+EHPc++5+vz5dutk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date:From;
	b=K1RV5MlMuYcC2JOino8x/2mg60f+KELLm67MuVF3NimdmA0W6xYmg6kOMdn1N+gxv
	 kx03blsqO8kjpX1uQv+4yF+kJFDdvBUiN2mXzJu6i9HTLxo0+gcD5+Yo9K26yxqbAZ
	 BJ7k+kQra4OJFpIvLN7Ft+BAQVi8IxaZoMoX0qa4T9X0jbcPR4Mj56v2UfMZb+unVx
	 uLmJ0k9CKjBgV5p/xKbKS6WqThWL36Fm8N6vGqSaryUTQMVEOwbPUbdJsDxsbiEDoI
	 G/3m98U2wEPaQEHVGhf5m5qkaVG4yU8EI/Cd3R3NMy/K3VfWTv5oc/hxNnxL146ygQ
	 67apVOfktaVzg==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 5/6] livepatch: Remove obsolete per-object callbacks
Reply-To: sashiko-reviews@lists.linux.dev
To: jikos@kernel.org, joe.lawrence@redhat.com, mbenes@suse.cz, song@kernel.org, pmladek@suse.com, jpoimboe@kernel.org
Cc: "Yafang Shao" <laoar.shao@gmail.com>, live-patching@vger.kernel.org
In-Reply-To: <20260513143321.26185-6-laoar.shao@gmail.com>
References: <20260513143321.26185-6-laoar.shao@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 14 May 2026 22:40:00 +0000
Message-Id: <20260514224000.8316FC2BCB3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: 046D954789F
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2824-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lists.linux.dev:replyto,sashiko.dev:url,smtp.kernel.org:mid]
X-Rspamd-Action: no action

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] Out-of-bounds ELF relocations causing memory corruption
- [High] Silent failure of livepatch state callbacks due to missing initial=
ization
- [Low] Build failures due to unmigrated selftests and samples
--

commit deb761bd65e9a96a95798282bde72ddb362e1c0d
Author: Yafang Shao <laoar.shao@gmail.com>

livepatch: Remove obsolete per-object callbacks

This commit removes obsolete per-object callbacks from the livepatch framew=
ork
in favor of per-state callbacks. It drops the callback fields from the klp
object structures and updates objtool and the livepatch core scripts.

> All selftests have been migrated to the new per-state callbacks, making t=
he
> per-object callbacks redundant.

Is this description accurate?

The callbacks field was removed from struct klp_object, but if modules like
samples/livepatch/livepatch-callbacks-demo.c or the selftests still use it
in their klp_object declarations, won't this cause build failures?

> diff --git a/scripts/livepatch/init.c b/scripts/livepatch/init.c
> index 9265e0e504e0c..570366b9268c4 100644
> --- a/scripts/livepatch/init.c
> +++ b/scripts/livepatch/init.c
> @@ -63,8 +63,6 @@ static int __init livepatch_mod_init(void)
> =20
>  		obj->name =3D obj_ext->name;
>  		obj->funcs =3D funcs;
> -
> -		memcpy(&obj->callbacks, &obj_ext->callbacks, sizeof(struct klp_callbac=
ks));
>  	}
> =20
>  	patch->mod =3D THIS_MODULE;

Will the state callbacks be executed when the patch is enabled?

Looking at livepatch_mod_init() after these changes, patch->states is never
initialized:

scripts/livepatch/init.c:livepatch_mod_init() {
        ...
        patch->mod =3D THIS_MODULE;
        patch->objs =3D objs;

        /* TODO patch->states */

        patch->replace_set =3D KLP_REPLACE_TAG;
        return klp_enable_patch(patch);
}

When klp_states_pre_patch() iterates over patch->states, won't it silently
skip the uninitialized callbacks?

> diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> index 4d1f9e9977eb9..6e2762de3d512 100644
> --- a/tools/objtool/klp-diff.c
> +++ b/tools/objtool/klp-diff.c
[ ... ]
> @@ -1566,8 +1566,8 @@ static int create_klp_sections(struct elfs *e)
>  		reloc =3D find_reloc_by_dest(e->out, sym->sec, sym->offset);
> =20
>  		if (!elf_create_reloc(e->out, obj_sec,
> -				      offsetof(struct klp_object_ext, callbacks) +
> -				      offsetof(struct klp_callbacks, pre_patch),
> +				      offsetof(struct klp_state_ext, callbacks) +
> +				      offsetof(struct klp_state_callbacks, pre_patch),
>  				      reloc->sym, reloc_addend(reloc), R_ABS64))
>  			return -1;
>  	}

Does this result in out-of-bounds memory writes during ELF relocation?

Earlier in create_klp_sections(), obj_sec is allocated using the size of
struct klp_object_ext, which is 24 bytes:

tools/objtool/klp-diff.c:create_klp_sections() {
	size_t obj_size  =3D sizeof(struct klp_object_ext);
	...
	obj_sec  =3D elf_create_section_pair(e->out, KLP_OBJECTS_SEC, obj_size, 0,=
 0);

However, the new relocations are created using offsets from a completely
different structure, struct klp_state_ext.=20

Because offsetof(struct klp_state_ext, callbacks) is 16, and the callback
offsets go up to 24, this applies relocations at offsets 16, 24, 32, and 40
within obj_sec.

Won't the relocation at offset 16 corrupt klp_object_ext.nr_funcs, and the
subsequent relocations write entirely out of bounds of the 24-byte obj_sec
buffer?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260513143321.2618=
5-1-laoar.shao@gmail.com?part=3D5

