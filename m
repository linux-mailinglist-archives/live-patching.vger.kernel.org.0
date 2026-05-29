Return-Path: <live-patching+bounces-2927-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gJitNJ8PGWrDpwgAu9opvQ
	(envelope-from <live-patching+bounces-2927-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 06:01:35 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 310975FCDDF
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 06:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 364D93026311
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 04:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CD73261B8D;
	Fri, 29 May 2026 04:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y7zOYFmf"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4513218DB1A
	for <live-patching@vger.kernel.org>; Fri, 29 May 2026 04:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780027292; cv=none; b=l53BUq/O3QQsvoELzRI68467Hd/6aV1VyYgq4wseSdFLi69jjs7ePEgOiH14QfXsypvs8UjHGfYLSin7cM7Ke6g+Mm4psP48JwJYe+wjHZyYg7BupUtxQpceKUxuGbfQwj2cbP8oqm/P++e18aFLkLRKr1hOe3aCMHA4T5Y+l/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780027292; c=relaxed/simple;
	bh=Nnl6O3VzE5p2C/Wo8p3ETGfaxMA1ZyHYwi6q34RGQII=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=aqi2IaIgU4Xag3IWsLisTbGKQLHFVXKaywIqxwQHEHWgAPYztUhLDnA50mVpvl0Gs74Pnn2krz9FxJoKoACNoaKSDIVGzppg7fkZHdIrBGoluX3IK8UYcreDHaVHyXQZpOBJBrpVMGOuantvrn2VIg7Plg/13rksw7WgTEQh+FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y7zOYFmf; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A9C1F00893;
	Fri, 29 May 2026 04:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780027290;
	bh=whqUfG4A6KNUXa3WV+KqWJGuNupRFPBhA2eayArvD3w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y7zOYFmfVyHmx3Mf8mwCxpT4NuJvkT9c5fQnJPJghFCur5uqsl27s8Xi7h4JsabRM
	 QTlA2aKmBoltehLcmre8DIgWubATTco8Z6CFE0v5f+4HGrM4kq9Bk0oSXJjjjMLTGS
	 zKsh7AEr30GVSL+yYMl8q9BORZk95FTc62sw/oA3k3U6M1lx7Mbct1hFNDyBPlCJFG
	 oI+qvfO/9ZXtRDasj9JZ5oQ3coMlXjXK0icoqT/KBMtZw+KFIQ4j/jzPHF3AAKUsiV
	 OZvk8KWOFI4SPZvgENyK2BFpDRTGxuiEVX3tFrQVi1rYBLnNjJjsKaTdBuyAOJ2t7J
	 byiuaouGn/Fcg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/4] livepatch: Make klp_find_func() non-static
Reply-To: sashiko-reviews@lists.linux.dev
To: jikos@kernel.org, joe.lawrence@redhat.com, song@kernel.org, mbenes@suse.cz, jpoimboe@kernel.org, pmladek@suse.com
Cc: live-patching@vger.kernel.org, "Yafang Shao" <laoar.shao@gmail.com>
In-Reply-To: <20260529034542.68766-2-laoar.shao@gmail.com>
References: <20260529034542.68766-2-laoar.shao@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 29 May 2026 04:01:30 +0000
Message-Id: <20260529040130.95A9C1F00893@smtp.kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2927-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashiko-bot@kernel.org,live-patching@vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[smtp.kernel.org:mid,lists.linux.dev:replyto,sashiko.dev:url,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 310975FCDDF
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Low] klp_find_func() is improperly exposed in the global public header, =
breaking encapsulation and introducing potential build/linkage errors.

Pre-existing issues:
- [High] klp_find_func() lacks input validation, exacerbating a pre-existin=
g NULL pointer dereference vulnerability during livepatch loading.
--

commit 0b93025e6e1dd48057bb98e4d5e13741daab118e
Author: Yafang Shao <laoar.shao@gmail.com>

livepatch: Make klp_find_func() non-static
   =20
This commit exposes klp_find_func() by moving it out of the static scope
to make it available outside of core.c for reuse in upcoming patches.

> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> index ba9e3988c07c3..70854f542c33e 100644
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
> @@ -215,6 +215,10 @@ int klp_apply_section_relocs(struct module *pmod, El=
f_Shdr *sechdrs,
>  			     unsigned int symindex, unsigned int secindex,
>  			     const char *objname);
> =20
> +struct klp_func *klp_find_func(struct klp_object *obj,
> +			       struct klp_func *old_func);
> +

[Severity: Low]
Does this declaration belong in kernel/livepatch/core.h instead? It lacks
an EXPORT_SYMBOL_GPL() and a stub for when !CONFIG_LIVEPATCH is set.

[ ... ]

> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 28d15ba58a26d..e97df3e59057b 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -82,8 +82,8 @@ static bool klp_initialized(void)
>  	return !!klp_root_kobj;
>  }
> =20
> -static struct klp_func *klp_find_func(struct klp_object *obj,
> -				      struct klp_func *old_func)
> +struct klp_func *klp_find_func(struct klp_object *obj,
> +			       struct klp_func *old_func)
>  {
>  	struct klp_func *func;

[Severity: High]
This is a pre-existing issue, but does this function dereference a NULL
pointer if old_name is NULL?

If a newly loaded livepatch provides a function entry with a NULL old_name,
func->old_name will be NULL when evaluated in strcmp():

klp_init_patch()
    klp_add_nops()
        klp_find_func()
            strcmp(old_func->old_name, func->old_name)

Could a check be added for NULL before calling strcmp()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260529034542.6876=
6-1-laoar.shao@gmail.com?part=3D1

