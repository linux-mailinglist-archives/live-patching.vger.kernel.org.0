Return-Path: <live-patching+bounces-2808-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aFX5EQ/JBGqnOgIAu9opvQ
	(envelope-from <live-patching+bounces-2808-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 20:55:11 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 94436539612
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 20:55:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 335E130302B0
	for <lists+live-patching@lfdr.de>; Wed, 13 May 2026 18:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B81DF3A8759;
	Wed, 13 May 2026 18:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="AI9IuKvX"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361C53A875B
	for <live-patching@vger.kernel.org>; Wed, 13 May 2026 18:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778697846; cv=none; b=dUCRf6QayreuTe5uRZ+0J+L2fIT/9xcEEjgfl/FvgrAhHyAfBrmp5U5FGEgdP9BoTU6QF+9XpsddY1qo67+x1FgPgqOtd3MDp1ZCheavnGF4kioBeGEV+6IEABnc6nCSV01spUWmYTsMUxUouEayfIjmgjFUo2h+uBkjEOu3ST8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778697846; c=relaxed/simple;
	bh=gvYWgZrfWpSGyISTJ3VTjWX35j/ErlcVdotOLyISBAk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Zd67sUi4KOMudVn1H439RMoxNfYTKoS8g/QVGR7kYFoB3rbus1QbjE0s4SJuPdxm9A+5fFg65fvd5n96MYdWVn7rM2YTMEI6pvreB+dnd21YeSUbFxm3GPnuINUzGbeTE/CXqjneWKEZgATx+v64yeKm+/Lnar0V1dkaugiofGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=AI9IuKvX; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488d2079582so74119575e9.2
        for <live-patching@vger.kernel.org>; Wed, 13 May 2026 11:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778697843; x=1779302643; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gvYWgZrfWpSGyISTJ3VTjWX35j/ErlcVdotOLyISBAk=;
        b=AI9IuKvX3+/Ks7QFXV5X3yiq2hkntUZC4pPcbABAj/r3a6kFq5GPUqGPiYSWs+gdDw
         YOFQhg9d0X0D5yysmJhqjrUsPomeNi7XuZY2JTWbCNJYac3KOXdwgqrQpSXEZS00KNft
         XzhkpVkWC6NA3QQlaQOJ0UeNroCdwyt0C2Y/GQsy3PYeh0Hfk7/CApOVQUFBpNnBF9Uu
         H9MlXrB+tk1hcC4zf593TS/debnTMuscqP+dD2TGcVpVpdZWngSspXpOAaCQ9yphTc+2
         YtkRZdJHWlX5BaBjzb2lZcS9MeugaiavBWvptB+dm9KAqx6DBdBC+yj6NAmj0imhMLJo
         LIew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778697843; x=1779302643;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gvYWgZrfWpSGyISTJ3VTjWX35j/ErlcVdotOLyISBAk=;
        b=HNxOaKH3IvI/6cy0gb5hjQeU8vtFTzPKsX7qLe3VEw/59dRK5opBrktuy5htg7sKcD
         7rbVNWZ+iq1myzv/GjsQebkUdk6SIVxt7SpzzORtr78zfJmel36gC48XqEQaPAIwksK2
         L5yJq+GucnKl4B8lhe2gRIHNalRnaP3QfqfSiYPBylFANrjSvHK0JKDXTR7FEmrUWbMb
         aB9sFvSOoEOcDlc7eYRKxfKvys3u57haJ1VNbt3zysfCHRx4Ywh4fNHxCmgbACGpv1e/
         lqsy5/sh8DFaQWC2W1n5Z/t86mckJi6UsESKszsjbK/jqSc7XHXSBEiWy84AOWfEWEUF
         mCxg==
X-Forwarded-Encrypted: i=1; AFNElJ8+aVVsGAQBw8TXrrcHRQG6ASCVNLlUE5exRM1B2cPP6Gv/tpiSGOdyx8Fj0Qe6LN453he69btnrRybLfm2@vger.kernel.org
X-Gm-Message-State: AOJu0YzjVG25oIojWKEHx5ZaHZR/jyyzH8Jns80A6wNemLe6ymF8/e4J
	5TM9cCWJfDNO8fcUrNvSMs/qJG//eAV4BF5MgM88p9vk+rDsVI2QYYBQCbI3/+/96Ws=
X-Gm-Gg: Acq92OFedk/oxfwXolpf4IQTGrMnkD1F98G1fS1xWfWQUuZmkzX4lojbVqe/Y01lZ0O
	lxhsZ+zyqKihIulPT4IVDnxywf8L31BcCJ/89bRkVIxcdQuwtgQXK+LrGHB7AYnxNxat26pqC+k
	h/fouAfQ2dJgg/PEakKkf7wAegvhSx4VIKv/fnt+4h2gO4FECg2J3+TGRAe7Ayui5Agrttp4gBZ
	xnnZdtXV+Y3RAAMPbbekj2FhjUsOx3aLcxyBkbsDZaCQ7oz02BYdgJdUH3osqc4aNJDf3TEuP88
	ow3dlSulf4can9BzDMJ8r0H61hg2Ds5d2noaMRDPFAEIRlpYXj8n1LRhjcvljSxBSfQvuhh/m0+
	1GP2Q77D3UOlg6Wyv+T3KYjY0kHy75uxHLIZw9+euuiyWJW04CbwWomoTU5GdiAqgP8h4xbzXqW
	qCNVQgPZCOiwVXhjhh/ieVpe/ZrESOMQqS2vb0saBelPj8k5LtyuFhRtbYvGSX9EBnHOA=
X-Received: by 2002:a05:600c:19cd:b0:48f:be94:d82c with SMTP id 5b1f17b1804b1-48fce9e1a34mr64839125e9.19.1778697843483;
        Wed, 13 May 2026 11:44:03 -0700 (PDT)
Received: from ?IPv6:2804:1bc4:224:7800:585c:db3a:fcb:e21f? ([2804:1bc4:224:7800:585c:db3a:fcb:e21f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0a178adsm857760f8f.18.2026.05.13.11.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 11:44:03 -0700 (PDT)
Message-ID: <4f5c20003e064cea830ce1e1b135b66c33538714.camel@suse.com>
Subject: Re: Sashiko patch review for live-patching?
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org
Cc: Jiri Kosina <jikos@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
 Miroslav Benes	 <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, Song Liu
 <song@kernel.org>
Date: Wed, 13 May 2026 15:43:57 -0300
In-Reply-To: <agSjM8dxgnV9QQaf@redhat.com>
References: <agSjM8dxgnV9QQaf@redhat.com>
Autocrypt: addr=mpdesouza@suse.com; prefer-encrypt=mutual;
 keydata=mDMEZ/0YqhYJKwYBBAHaRw8BAQdA4JZz0FED+JD5eKlhkNyjDrp6lAGmgR3LPTduPYGPT
 Km0Kk1hcmNvcyBQYXVsbyBkZSBTb3V6YSA8bXBkZXNvdXphQHN1c2UuY29tPoiTBBMWCgA7FiEE2g
 gC66iLbhUsCBoBemssEuRpLLUFAmf9GKoCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 QemssEuRpLLWGxwD/S1I0bjp462FlKb81DikrOfWbeJ0FOJP44eRzmn20HmEBALBZIMrfIH2dJ5eM
 GO8seNG8sYiP6JfRjl7Hyqca6YsE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 94436539612
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	SUBJECT_ENDS_QUESTION(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_FROM(0.00)[bounces-2808-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mpdesouza@suse.com,live-patching@vger.kernel.org];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:mid,suse.com:dkim,sashiko.dev:url]
X-Rspamd-Action: no action

On Wed, 2026-05-13 at 12:13 -0400, Joe Lawrence wrote:
> Hello live-patching maintainers,
>=20
> I've noticed several references to the Sashiko (https://sashiko.dev/)
> kernel review bot on this list and was wondering if there is interest
> in
> adding live-patching to the mailing lists Sashiko tracks.
>=20
> Integration appears straightforward: we can submit an MR to add our
> entry to sashiko-k8s.yaml and customize the bot's email behavior in
> email_policy.toml.
>=20
> Full Sashiko Maintainer documentation is available here:
> https://github.com/sashiko-dev/sashiko/blob/main/MAINTAINERS_GUIDE.md
>=20
> Personally, I would vote to set reply_to_author.=C2=A0 I don't have a
> strong
> opinion on the other custom options, provided that the CC list is
> opt-in
> rather than simply mirrored from the MAINTAINERS::LIVE PATCHING file.
> Either way, I've found the Sashiko web interface very helpful in
> patch
> review.

We can start with reply_to_author for some time before opting for
reply_all. At least in my last patches, it was quite good and helpful.

>=20
> --
> Joe
>=20

