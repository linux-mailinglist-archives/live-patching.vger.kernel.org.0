Return-Path: <live-patching+bounces-2929-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +ApRJOAcGWrwqQgAu9opvQ
	(envelope-from <live-patching+bounces-2929-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 06:58:08 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A4625FD327
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 06:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6691D3081124
	for <lists+live-patching@lfdr.de>; Fri, 29 May 2026 04:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 610D634A78F;
	Fri, 29 May 2026 04:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TxAXp0SU"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C791F38CFEF
	for <live-patching@vger.kernel.org>; Fri, 29 May 2026 04:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780030489; cv=none; b=uuHzVMjQk3avlAV3j5w8/cdnF9a+c7wlIv8vyFlFff9U8lqFNjmzgJauFd94VL9uGyacukKmOtFHvKr2eIPciVTcot6BNydDqN38N9tPRjesPlIzY7RIMSzR0KccaqIvmvSVHsbrkDhTvrLxKxC1UqTcIrvv3kzgeY0y4P7oPw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780030489; c=relaxed/simple;
	bh=iJmkvm378Wwp5C23b+GhypE1Ge1/iKwTwaga5yWq+1I=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=KvDxEyjGa94+9B8beL2nNv/Ufc7x49AiTMkdkm3l+Sm3+zoy+8BfUi9BkEmUps5qmHf3NtFPI9oyJns0nI0ncyxY03g8lRGDz+zRmHP7xx2zvr/aML9oQ7pGQSZ80ffo8jzszyoQUjCve4zag7BS5+iz/7hFLUAAjpcdrGrsp1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TxAXp0SU; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22791F00893;
	Fri, 29 May 2026 04:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780030487;
	bh=kKahT91E6JfACw+5Y2h7FjJK0MMqfYxpNtiL3vV9uNg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TxAXp0SUf2Wcx/O2XWlxS+t1kcw1C5Hy84u0dwgGh64Juc6OBv+EBZxAJzQlYNAp/
	 ap1WOwWNFhS1tNfT/sr1Ks6v1goGfvECgz0Oae0qW/fbH2YO1qzd7x+8+ccBJcmdB6
	 ZBl+YAPW1pwedN9Qz8J2q7nmnLzEcEWpYGtGzbwp5ZwRUHSJKJJ5dS647i806lbTBF
	 dkaUjzuibG/mWej5c0vuxe/Yz7KCqnpPX1ZvpKRWJTcZlafvcorpQcmltilGxCRsz8
	 WbVJ2QILzveNVEtdGko86Bsi4rJZn31J22W7IYhlItjWzcdgy3PSWmBowMyexGULos
	 8jRvcOFBsxr2g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/4] livepatch: deprecate stack_order
Reply-To: sashiko-reviews@lists.linux.dev
To: song@kernel.org, jpoimboe@kernel.org, joe.lawrence@redhat.com, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com
Cc: live-patching@vger.kernel.org, "Yafang Shao" <laoar.shao@gmail.com>
In-Reply-To: <20260529034542.68766-4-laoar.shao@gmail.com>
References: <20260529034542.68766-4-laoar.shao@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 29 May 2026 04:54:46 +0000
Message-Id: <20260529045446.B22791F00893@smtp.kernel.org>
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
	TAGGED_FROM(0.00)[bounces-2929-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	HAS_REPLYTO(0.00)[sashiko-reviews@lists.linux.dev];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,lists.linux.dev:replyto,smtp.kernel.org:mid,sashiko.dev:url]
X-Rspamd-Queue-Id: 0A4625FD327
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Critical] The commit entirely removes the `stack_order` sysfs attribute =
while only marking it as `<deprecated>` in the ABI documentation, causing i=
mmediate backwards compatibility breakage and contradicting documentation g=
uidelines.
--

commit 041b2dbba1a7397626104dd773fc1f37228d382c
Author: Yafang Shao <laoar.shao@gmail.com>

livepatch: deprecate stack_order

This commit deprecates the stack_order sysfs attribute for atomic-replace
livepatches, since a single function can only be modified by a unique
replace_set.

> diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documenta=
tion/ABI/testing/sysfs-kernel-livepatch
> index 6d75235a6a2e4..fddad93dba797 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-livepatch
> +++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
> @@ -62,6 +62,7 @@ Description:
>  		are applied to the system. If multiple live patches modify the same
>  		function, the implementation with the biggest 'stack_order' number
>  		is used, unless a transition is currently in progress.
> +		<deprecated>

[ ... ]

> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index 969fea2a92631..6d65f839f4420 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
[ ... ]
> @@ -457,38 +456,15 @@ static ssize_t replace_set_show(struct kobject *kob=
j,
>  	return sysfs_emit(buf, "%u\n", patch->replace_set);
>  }
> =20
> -static ssize_t stack_order_show(struct kobject *kobj,
> -				struct kobj_attribute *attr, char *buf)
> -{
> -	struct klp_patch *patch, *this_patch;
> -	int stack_order =3D 0;
> -
> -	this_patch =3D container_of(kobj, struct klp_patch, kobj);
> -
> -	mutex_lock(&klp_mutex);
> -
> -	klp_for_each_patch(patch) {
> -		stack_order++;
> -		if (patch =3D=3D this_patch)
> -			break;
> -	}
> -
> -	mutex_unlock(&klp_mutex);
> -
> -	return sysfs_emit(buf, "%d\n", stack_order);
> -}
> -
>  static struct kobj_attribute enabled_kobj_attr =3D __ATTR_RW(enabled);
>  static struct kobj_attribute transition_kobj_attr =3D __ATTR_RO(transiti=
on);
>  static struct kobj_attribute force_kobj_attr =3D __ATTR_WO(force);
>  static struct kobj_attribute replace_set_kobj_attr =3D __ATTR_RO(replace=
_set);
> -static struct kobj_attribute stack_order_kobj_attr =3D __ATTR_RO(stack_o=
rder);
>  static struct attribute *klp_patch_attrs[] =3D {
>  	&enabled_kobj_attr.attr,
>  	&transition_kobj_attr.attr,
>  	&force_kobj_attr.attr,
>  	&replace_set_kobj_attr.attr,
> -	&stack_order_kobj_attr.attr,
>  	NULL
>  };

[Severity: Critical]
The commit message and documentation state that the stack_order attribute
is being deprecated, but this code completely removes the attribute. Does
this abruptly break ABI compatibility for userspace tools that expect this
sysfs file to exist?

Normally, deprecating an interface requires keeping it around for a
transition period (perhaps returning a dummy value) rather than deleting
it immediately. Also, if it were actually removed, shouldn't the ABI
documentation be moved to the removed/ directory instead of just appending
<deprecated> to the existing entry?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260529034542.6876=
6-1-laoar.shao@gmail.com?part=3D3

