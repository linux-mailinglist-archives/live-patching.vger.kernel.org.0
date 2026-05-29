Return-Path: <live-patching+bounces-2928-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sP8PLNEWGWoMqQgAu9opvQ
	(envelope-from <live-patching+bounces-2928-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 06:32:17 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DC915FD026
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 06:32:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 15D033020ECC
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 04:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9DAE35201B;
	Fri, 29 May 2026 04:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+zLLG1l"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C632F1427A
	for <live-patching@vger.kernel.org>; Fri, 29 May 2026 04:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780029133; cv=none; b=SwTimFqCzmEOvXo3865ljL0xDvojsOMjR+mPsx6eSRfKppjrrXAKDArCY7eUk3QXugxmjEKmg65bCzZMuNDuQeZ1amTlZWHq1ps532YrLJ/9hfrWeG1+qOKCSaiLEEfuGw6vAXMcYuvD21u+bt79qAkHBP09UKMxN+9btHs2EeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780029133; c=relaxed/simple;
	bh=D+E3LJScjsgcloE0oXRrxiohyK+BKfFcd4HEqg0k2FY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o7RqhDyDSTitOyjS1Ruf2/lAvK6+OzkHY2nwfcHNEA8oNdoQhuaUOg9zxQAscA26wiB/uegY06OS+FEMyNOeP3fq/GN4FrqplheqlhOctHSbX7LKlmmh73yc4mG5YKMbzrXi7KCxAB9Z86zelGAI3TTZtTy6P+RM/8Jv1JU7eyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+zLLG1l; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2ED1F00893;
	Fri, 29 May 2026 04:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780029132;
	bh=wdnYbKigOSPqBa5FZja/U/js0Gx+24otvYhOsZC0AX0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=b+zLLG1ly2IJm+ZFiz0+aU/gEPtRGAVPrQ05b4tIi5VBtOnHR2wGaOTOdK2CE0M5l
	 ggn56mNUzl6IWTlATrJnc9LgtS6l5TYT+PMuoJF7yXXeu0ezV2RV+Y/fuv0A9vk0QX
	 QnAUdjmAYbA+hVrZXI8gfnwHWgmuZaS2R4BLKkjKX/wMAnlP8Eyakqr1O5lVYmnvMl
	 Vt3PGkb/JJ4The4uce9a/tHyAhNdaFIYt5M4lOuUXfK4bHi8L/x9cU5mDkN3Se9rll
	 7wp8Y3Pe0vU7eXZxffzfuuYCJqNPaawm9q7m/fkN+rvZl0fBSQXoJGkbwzTj2j3AUI
	 /GwPTuA2ZwZ2g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/4] livepatch: Support scoped atomic replace using
 replace_set
Reply-To: sashiko-reviews@lists.linux.dev
To: jikos@kernel.org, pmladek@suse.com, song@kernel.org, mbenes@suse.cz, jpoimboe@kernel.org, joe.lawrence@redhat.com
Cc: "Yafang Shao" <laoar.shao@gmail.com>, live-patching@vger.kernel.org
In-Reply-To: <20260529034542.68766-3-laoar.shao@gmail.com>
References: <20260529034542.68766-3-laoar.shao@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 29 May 2026 04:32:11 +0000
Message-Id: <20260529043212.1F2ED1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Spamd-Result: default: False [1.34 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2928-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[smtp.kernel.org:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 2DC915FD026
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] A malformed livepatch module with a missing function `old_name` wi=
ll cause a kernel panic during patch compatibility checking.
--

commit 48dd0b716d1f70f13c1e96b75bf54e1aba77be18
Author: Yafang Shao <laoar.shao@gmail.com>

livepatch: Support scoped atomic replace using replace_set

Convert the replace attribute from a boolean to a u32 to function as a
"replace set." A newly loaded livepatch will now atomically replace any
existing patch belonging to the same set. There can only ever be one active
livepatch for a given replace_set number.

Link: https://github.com/pmladek/linux/tree/klp-state-transfer-v1-iter12 [0]

> diff --git a/kernel/livepatch/state.c b/kernel/livepatch/state.c
> index 2565d039ade0a..a1ac466373360 100644
> --- a/kernel/livepatch/state.c
> +++ b/kernel/livepatch/state.c

[ ... ]

> @@ -85,34 +85,65 @@ EXPORT_SYMBOL_GPL(klp_get_prev_state);

[ ... ]

> +		klp_for_each_object_static(patch, obj) {
> +			klp_for_each_object(old_patch, old_obj) {
> +				if (!!obj->name !=3D !!old_obj->name)
> +					continue;
> +				if (obj->name && strcmp(obj->name, old_obj->name))
> +					continue;
> +				klp_for_each_func_static(obj, func) {
> +					if (klp_find_func(old_obj, func))
> +						return false;
> +				}
> +			}
> +		}

[Severity: High]
Could a malformed livepatch module cause a kernel panic here during patch
compatibility checking?

Since klp_is_patch_compatible() is called in klp_enable_patch() before
klp_init_patch() validates the incoming patch structures, a malformed patch
might have func->old_name set to NULL but func->new_func populated.

In that scenario, klp_for_each_func_static() would still process the functi=
on
and pass it to klp_find_func(), where it is used as old_func:

kernel/livepatch/core.c:klp_find_func() {
    ...
    klp_for_each_func(obj, func) {
        if ((strcmp(old_func->old_name, func->old_name) =3D=3D 0) &&
    ...
}

Would this result in a NULL pointer dereference when klp_find_func() attemp=
ts
to call strcmp() on the unvalidated function's old_name? While livepatch
modules are loaded by root, should they fail validation gracefully instead =
of
crashing the kernel?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260529034542.6876=
6-1-laoar.shao@gmail.com?part=3D2

