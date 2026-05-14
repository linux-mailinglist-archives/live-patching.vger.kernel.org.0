Return-Path: <live-patching+bounces-2816-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2GM/EaI2BmqWgQIAu9opvQ
	(envelope-from <live-patching+bounces-2816-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 22:54:58 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B014B546D65
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 22:54:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 840463024459
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 20:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53F3B3B992E;
	Thu, 14 May 2026 20:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WD4R9YFA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31596346ACE
	for <live-patching@vger.kernel.org>; Thu, 14 May 2026 20:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778792080; cv=none; b=Qs8cnPEp/Z1miirt2z7ActC4EHJW5u6Rz3NEJFQY/8gMxKWkS6mJ00NQQ4ZrLNo+EJahF8SRpvlkhtAmtAfIEUQGqARP6qcKLU1Bt1ryRw23skohmK9/F5BqI2bd5Dzi4bQUqIbmFgVxB6f13H8F1CDXiBaUa67Nr5mMYczH3Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778792080; c=relaxed/simple;
	bh=EmnH44RhmTDM/tecfkSlKb9n0OmqkD20yy2elx6Ux5I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bQ4/NNczWMXv18q7Kkn+JkASP1xa9me9MA/2X5yaGZqKo+ALoM0cBESQig0I8yi3iDBoKf925kvGAV4ITFn22bU6BYumB2F3y/um8zo0l9PEkYe+xXL9QMPyZ28awFa1RahFky254GDFYrBgOna+lV0KG7dIFbE4vIOsruf1IBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WD4R9YFA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925F1C2BCB7;
	Thu, 14 May 2026 20:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778792079;
	bh=EmnH44RhmTDM/tecfkSlKb9n0OmqkD20yy2elx6Ux5I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date:From;
	b=WD4R9YFAa1aMlI50ntIBajGhpF3CXcr88pZB0l0mAFplA9jTHUn9FDYhB179ivktE
	 WQ8fsqPzHJU1i2y89Zkd7Xw3v/wA4nhNaKY2q1EHQUHW9uBaR+e4ZeOMRZfnVsRKxW
	 79HalnZp/BffIjfmlmPTYSlLkFRKoocPtldQ7Mbx/gZi5A3Yos2zvfPeKs7pU+k/TF
	 d0cdk5p4qiCjpwxTF8nasSUKWqNKCKc8xQWjEwh/5z1w7NHpcdtdAS/hu2ECUvjVA3
	 TBZJKo8gaNerF3JON9/fEi24VP2pSJM0LyG4GCbYpQW2yvlvLA6eoiNvoiRLECi27w
	 iYqoV/Qxow7dA==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 1/6] livepatch: Support scoped atomic replace using
 replace set
Reply-To: sashiko-reviews@lists.linux.dev
To: mbenes@suse.cz, song@kernel.org, jikos@kernel.org, jpoimboe@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com
Cc: "Yafang Shao" <laoar.shao@gmail.com>, live-patching@vger.kernel.org
In-Reply-To: <20260513143321.26185-2-laoar.shao@gmail.com>
References: <20260513143321.26185-2-laoar.shao@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 14 May 2026 20:54:38 +0000
Message-Id: <20260514205439.925F1C2BCB7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
X-Rspamd-Queue-Id: B014B546D65
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MISSING_MIME_VERSION(2.00)[];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	REPLYTO_DN_EQ_FROM_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-2816-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,smtp.kernel.org:mid,sashiko.dev:url,lists.linux.dev:replyto]
X-Rspamd-Action: no action

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [High] Module reference leak during forced transition.
- [High] Silent semantic reversion for zero-initialized out-of-tree livepat=
ches.
- [High] Sysfs ABI breakage and incorrect type formatting for the `replace`=
 attribute.
- [Medium] Build failure in livepatch selftests.
--

commit 8a05e8a3ebd9241541926ac6aba19452a820c899
Author: Yafang Shao <laoar.shao@gmail.com>

livepatch: Support scoped atomic replace using replace set

This commit converts the boolean replace attribute to a u32 replace_set
to allow livepatches to atomically replace only existing patches within
the same set. Patches with different replace sets can now remain active
simultaneously.

> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
> --- a/include/linux/livepatch.h
> +++ b/include/linux/livepatch.h
[ ... ]
> @@ -137,7 +138,7 @@ struct klp_patch {
>  	struct module *mod;
>  	struct klp_object *objs;
>  	struct klp_state *states;
> -	bool replace;
> +	unsigned int replace_set;

By removing the boolean replace flag, out-of-tree livepatches that
zero-initialize their patch structures will now default to a replace_set of=
 0.
Will this cause them to unintentionally replace all other zero-initialized
patches instead of stacking safely?

Additionally, does this rename break the livepatch selftests in
tools/testing/selftests/livepatch/test_modules/ (such as test_klp_state2.c),
which still explicitly set patch.replace =3D true?

[ ... ]
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -454,7 +454,7 @@ static ssize_t replace_show(struct kobject *kobj,
>  	struct klp_patch *patch;
> =20
>  	patch =3D container_of(kobj, struct klp_patch, kobj);
> -	return sysfs_emit(buf, "%d\n", patch->replace);
> +	return sysfs_emit(buf, "%d\n", patch->replace_set);

Does changing the sysfs output from a boolean to a replace set ID break
compatibility for userspace tools expecting strict 0 or 1 values from the
replace attribute?

Also, since replace_set is declared as an unsigned int, will using the
signed %d format specifier cause large replace set IDs to overflow and
display as negative numbers?

[ ... ]
> diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
> --- a/kernel/livepatch/transition.c
> +++ b/kernel/livepatch/transition.c
[ ... ]
> @@ -720,11 +720,11 @@ void klp_force_transition(void)
>  		klp_update_patch_state(idle_task(cpu));
> =20
>  	/* Set forced flag for patches being removed. */
> -	if (klp_target_state =3D=3D KLP_TRANSITION_UNPATCHED)
> +	if (klp_target_state =3D=3D KLP_TRANSITION_UNPATCHED) {
>  		klp_transition_patch->forced =3D true;
> -	else if (klp_transition_patch->replace) {
> +	} else {
>  		klp_for_each_patch(patch) {
> -			if (patch !=3D klp_transition_patch)
> +			if (patch->replace_set =3D=3D klp_transition_patch->replace_set)
>  				patch->forced =3D true;
>  		}
>  	}

Could this inadvertently set forced =3D true on the klp_transition_patch
itself?

Since klp_transition_patch was already added to the global list during
klp_init_patch(), it will match its own replace_set here. If it is marked
as forced during a patching transition, wouldn't we leak its module referen=
ce
in klp_free_patch_finish() when it is cleanly disabled later?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260513143321.2618=
5-1-laoar.shao@gmail.com?part=3D1

