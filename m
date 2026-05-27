Return-Path: <live-patching+bounces-2893-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ACmDK0tUFmo+lQcAu9opvQ
	(envelope-from <live-patching+bounces-2893-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 04:17:47 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 16E075DE7F8
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 04:17:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1B018302FE8D
	for <lists+live-patching@lfdr.de>; Wed, 27 May 2026 02:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B08762F28EA;
	Wed, 27 May 2026 02:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sOYNLPZd"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A88C273D76
	for <live-patching@vger.kernel.org>; Wed, 27 May 2026 02:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779848263; cv=pass; b=XJ6oxp/gGuoEgeR5araF16kCR9/r+BV+RNHnc0MS/W9K1kd5Hyf2cnXH4lvdQSdLOpjb9EqM0DsLXIyycjB9o00UF3QI+eqjeR4EMyevYmPr15q6KV8CGUX/SDW8yH1HqNEaLo9yNA26tv6Li/o9L/sAtEaden93YOQyZ2zi4Gs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779848263; c=relaxed/simple;
	bh=pSVlJJ7AVSYcuvBy1sh1TWCTnc7UyyTSypiawoajxPg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=elXA4VjcFf19QZ3y129HAwL1il9Ro//yF1poi0bBiDdsFGxaSqclLYuDND1gY/OLDHAloEb1yGilSwOcF+9Blq6i0O//BDQYvvmFW53unmUVyP7WsGxDGAsi3yyi9+N3HbxNw35HfmYYdaN/xAmZdvjnjLo7o1sjqDdH2IT5U3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=sOYNLPZd; arc=pass smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7bdf83185bbso110613307b3.2
        for <live-patching@vger.kernel.org>; Tue, 26 May 2026 19:17:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779848261; cv=none;
        d=google.com; s=arc-20240605;
        b=LDB3CtOgAjNkD6dJGfi11m4McpflUqesEhkTxA5Yvfzaya/pFsyGmt7px25bH+/4sO
         AQtP8JwkealgOsO3je62ukhWTifypM4dPIIl/KIR7eI9Seh53pSTwGp6W0coqAlDWN0e
         BlfXohuYKGLBCdjmed5ud93EQbcMFcoo08zp3evMf11UUua7avQoZ5FqABo7Hh7T8+EP
         l5XlwKtI/z1v8IZnegwbQOmDk3d1i9Aw90tuGyZuo7bvbuEdJaHng/zesXY3ZIHjIZIt
         q0VnK/ZWtG4U2Fb6XZ5k3cc4C20+UzrziPkBI2aQAMlhN5zVLNiCG6qgp1ccbZ0jNV9t
         xeFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=srWHMYeogVo29BIpptmFARdBrJy5R8qplrjxsM6tEc8=;
        fh=BsC/dEmsdm5spzJjvenX4ymvfQcgP1f6Eu4MR4154RM=;
        b=Rgwwp+294nX34DE6nfIgQseEoeMsfCkhVNW6xfPKCSRf9ATTnKd1BLw+OfeRMSd686
         /NX7VlYtK/X+HOrP/D9ZMarbPrL7w0tBpcLich26sclDigX5v96Wx5jNLfAxvgMF9yoD
         z0cVgChaYICq42En/fIdrqsZMgZ2hPySwt6oDlVLk78uuJP4meEqNugP+zvcV77diaf3
         ICB/ERqNJ17NTET8sftsnIjFEtGAyYrfj1SSCEmncAzHVIUdq+vPadpdRzNGCq+gOHyu
         NNx7TJISrf2F3iYBTewOZ6tvO+LUzEvxDhO0pMTdrptE+wnDnIXKAEhZe09cn1ZtVIOs
         UQLg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779848261; x=1780453061; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=srWHMYeogVo29BIpptmFARdBrJy5R8qplrjxsM6tEc8=;
        b=sOYNLPZdTr5+tSi1dIQfSW97KLf4cVgISkOP7SKiqbbIArzVrkaSnD2AeaoXtoJX0D
         7Qe2woqoJ/q2uX7FXkAmCpOCXEMmYPSJd77RkCR8krQtKBZxBsW2uMekajBpMKwcxPXu
         4FD6gnQuzBtA+qIXLH5npm5Bx37xWEfbP68+kqpfJOt4AQ8lxGOx2BgtFHbq7u1p8cok
         Ym3m4ZmF+1Ra2MvGcn0Y8PbHHFoUWYpA+moq/RcUntuqRuLbN+W1SPzmY76963Mbaypw
         7qhRr78kpYppRUZ9Rdb0YmYaSO46xY10RA/9mqQE0j7M49qZZf/UIIAMts9OikPjMNP2
         +Vbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779848261; x=1780453061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=srWHMYeogVo29BIpptmFARdBrJy5R8qplrjxsM6tEc8=;
        b=Ru2EjJ33GuArbSVtvV27Zd0U5ZP7Y05OemEVmRqDsptLosaIKMo2prRIXwJltmuU3s
         KHUwWrahT60gXGmxxq3uZ7Nn02v+TL3EfAHX8PmPfzJSbQSqtZ9r5LuOK/ZQ9OrzVbd+
         ke0b4weuv/UBof7NCPU5wU09h2UaBzozBRa3tbapjsD0IERD5pGNd+3w4ttMeTzmrf3y
         eKOv2ihYc508z2DeH4yX+a3JN8T6CAT2s1GOlZSWbQDtxe/APoEZeVJOihp43egMx5f6
         RHpdhltbXXXO7DQ/3D/fQkK0D1UyZXoYOyjyf8nr9+rxv9HV8sNDyv8TT0wiiJq/khlJ
         cR4Q==
X-Forwarded-Encrypted: i=1; AFNElJ/piaCrxPCoVFC+LRwNp+wwbPm7trRIvw3VH/OnqWqwThofC0AoOYlpYebI4CYABFx7ZRwWN2EE259x0a22@vger.kernel.org
X-Gm-Message-State: AOJu0YwDB4I+Offv/N86Whk90aCrRh9IB2juAy4Phhm0mJNjWxTrKWzt
	DLQ7ewlS3iy+gpyX4ZvgO8RDFw4/m/p6jTfzT05zOhAboQ0zhVUI7UISa8EUG12g1FHoOT0GECS
	4mA8yK5uslJabqLOoq8rSpmCE0hwf6Co=
X-Gm-Gg: Acq92OE457PeWRMdCz188hnyg9jn7Jv5o3Nl/V2rBxQBULDA0miC8EwIZoxirFWqhGC
	48i+8ihjgBgpNjqrGU0JLCaEUNuZNMxGf3GNcRoDcBMmwJcXf9GgB5sLM/vsZgtdYnS3BXR/8dZ
	GITcOIQlsJX4jXiDZeuIe63j4CFkl0C3IJy4lLxZ8z5BSSmJonZkUYeBM9UidGLZqYHGARW7KHd
	+MDFwiOY09OczujHsroXbmrBd7v3fbiJqCQYFypdoLub6zjWePm60QqfV4vLEpGIuAblLqKDFpG
	BntsJ4W8X19lBOMhqTBnh7ni2PjdumSiWLXNySUTmOv/gsoRpd0=
X-Received: by 2002:a05:690c:c18:b0:7b2:7dc9:360e with SMTP id
 00721157ae682-7d334fd2d52mr237943457b3.0.1779848261322; Tue, 26 May 2026
 19:17:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513143321.26185-1-laoar.shao@gmail.com> <20260513143321.26185-2-laoar.shao@gmail.com>
 <CAPhsuW6Aa8Tu5aWGVYzRVVNEnJiHrNzsa4aKXoOEa_gwhp3XfQ@mail.gmail.com>
 <ahV3dBovdQZoF__j@pathway.suse.cz> <CAPhsuW4OsPexwZE9EeffuDwndV_Oj-fcR5T-ZFFsBOuY1EkKnw@mail.gmail.com>
In-Reply-To: <CAPhsuW4OsPexwZE9EeffuDwndV_Oj-fcR5T-ZFFsBOuY1EkKnw@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 27 May 2026 10:17:04 +0800
X-Gm-Features: AVHnY4KpanJyyPHK2l0XsYHFkCefi4IaQ4DnPjn9ygyvL_xriwKu7IH5ygS4Hkg
Message-ID: <CALOAHbA4xkY-gRXH0oc_nUEGY=LfX9G31Mitp+p7Og_Y=Oy17A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/6] livepatch: Support scoped atomic replace using
 replace set
To: Song Liu <song@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2893-lists,live-patching=lfdr.de];
	URIBL_MULTI_FAIL(0.00)[suse.com:server fail,mail.gmail.com:server fail,tor.lore.kernel.org:server fail];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[laoarshao@gmail.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 16E075DE7F8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 27, 2026 at 2:28=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> On Tue, May 26, 2026 at 3:35=E2=80=AFAM Petr Mladek <pmladek@suse.com> wr=
ote:
> [...]
> > > I wonder whether we should have "replace_set =3D 0" means no replace.
> > > This will simplify the transition for users of the existing replace=
=3Dfalse
> > > option. I would like to hear other folks' thoughts on this.
> >
> > I would find this confusing. Also it would complicate the code.
>
> Agreed with your assessment of the scenario.
>
> > I always considered the "replace" and "no replace" mode as two
> > separate worlds:
> >
> >     + people using many "no replace" livepatches
>
> My only concern is that we are adding more burden to these users.
> Before replace_set, they just use 0 for all the live patches.

The only valid use case for setting this to 0 is to keep certain
livepatches persistent on the system. Without replace_set, developers
are forced to disable replacement entirely. With replace_set, however,
they have a better, more selective option to keep specific livepatches
persistent. Therefore, I don't see this new semantic as an issue. On
the other hand, the new klp-build tool already requires developers to
significantly refactor their livepatch building and deployment
systems, so adapting to this new semantic shouldn't be an additional
burden.

> With
> replace_set, they will have to use some mechanism to assign a
> unique replace_set for each livepatch.
>
> I don't know how many users are in this world. If there aren't many
> users, we can ignore this case.
>
> >     + people always using atomic replace
>
> OTOH, these users don't need much change. They will just use
> replace_set =3D 1 for all live patches.
>
> Note that, I am not proposing to have replace_set =3D 1 to replace
> all live patches. It only needs to replace other live patches with
> replace_set =3D 1. The only change I am proposing (debating) here
> is to have replace_set =3D 0 as "no replace". However, if this still
> feels too confusing, or there are NOT many users in the "no
> replace" world, we can safely ignore this.


--=20
Regards
Yafang

