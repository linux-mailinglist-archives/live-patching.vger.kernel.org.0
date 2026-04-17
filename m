Return-Path: <live-patching+bounces-2384-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sJaWDuhV4mlg5AAAu9opvQ
	(envelope-from <live-patching+bounces-2384-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 17:46:48 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 648D941CC97
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 17:46:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DF559302A32A
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2026 15:45:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19C98341ACA;
	Fri, 17 Apr 2026 15:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gnXTbqOn"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB34F33BBAF
	for <live-patching@vger.kernel.org>; Fri, 17 Apr 2026 15:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776440716; cv=none; b=X7ZeCrxEqJGQkHGb5XyG0BHhvKelqYHqae1zB6oU7+TxoOP9TSkVX48UxYkkd4uqK2LTOsbaDLBCHGJYRCRafO7KKo0j3dCxsfIsoFAc7WrpDVA/+pkHkLpDL+4jxce6x/JXty9yNk6N4IoI83HjoldLl8VJ8PPmSeQBd9vBKdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776440716; c=relaxed/simple;
	bh=AzsAvRzrIdwpnEWSpYGfKROJzmD6vFLOyzD6C7fpnVM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ley5dlvikTgK2GZ9d9QAdvBzIxFB2VpMAGg6yKTiYZqXW+1AZcJqOq6eXyYR/uvGI5W4xbfRppeX17d8sXyKiRFriHkcPXpeKvZDxOYpfKiR3mNIpf0vqJE9JYFlh15POXeCOL4eW62dwboS3aw3mOhycGt2F9b9XKZzkjsKOKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gnXTbqOn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852F8C2BCB5
	for <live-patching@vger.kernel.org>; Fri, 17 Apr 2026 15:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776440715;
	bh=AzsAvRzrIdwpnEWSpYGfKROJzmD6vFLOyzD6C7fpnVM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gnXTbqOn2AnOFyE5o7h7WhuaP07z7p1GZ5ema3J4Tmqk4CpITWl+1Q2wuNdwnPjLK
	 VV/dHx3rgdZYIkQWHfGeoLOtMmA73xt3HjbRYC4J/F5+s9Ypqfrgq7Eap02Zbs4AHT
	 bvoP+HkO6uIT99rzZwoKK95+KTMZ5mxb1Ag66fTi4DoqPDW7nTKFhN1jEB9FpwIzVU
	 D6NauTVCkhcRzcCBRxyWYyxtxJZZDxN5E8Q0XpIStpsxDr3qNBkMAspcj7O32oSW7s
	 B2PPyC521thY7htJ8YX7r9CyJfA8kBUYGNxvQmPGokXm+JDgyo4VTDDN4jyjtn6Ehc
	 BTnHKT+CAWgqg==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8a110e06b4cso9361266d6.1
        for <live-patching@vger.kernel.org>; Fri, 17 Apr 2026 08:45:15 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy33Mh8uI6ehldOln304M1LTmp34PIyIWq0Fp1GwAV3iHnmHMAr
	wfT0Wu6S5eXw+GNViY5FAfejFRiE2Fru2GcHW0/bxlp6d7NbC3kGIoYqg1oEFvEKSE7b9BwKy+A
	SOIFWfsjSKCpg38VSzrQ33nJnSPurnwM=
X-Received: by 2002:a05:6214:598c:b0:8ac:b6d7:e60e with SMTP id
 6a1803df08f44-8b027fd9d4amr53183776d6.7.1776440714079; Fri, 17 Apr 2026
 08:45:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416001628.2062468-1-song@kernel.org> <CALOAHbDSpofLCQ-LCU2uVtkc9w+zib0PPgBr+6sEv5FD5+Hd=g@mail.gmail.com>
 <CAPhsuW5=oXwQQyOU7Hf6Qf5=tK=-J75Xr+p+dcGiPs2vVEeMFw@mail.gmail.com> <CALOAHbAwmPnEFgzzrjQWdp=tfR4rZPoyn-at4EYFO0TX6rCLHA@mail.gmail.com>
In-Reply-To: <CALOAHbAwmPnEFgzzrjQWdp=tfR4rZPoyn-at4EYFO0TX6rCLHA@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Fri, 17 Apr 2026 08:45:02 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5PqNyjoDP+JFdteB_t6pT9g0f4yLk3JGQOPPWtejBP+Q@mail.gmail.com>
X-Gm-Features: AQROBzDaFmoGpqeVhPvD-YBBxtf7qnrqCoADnWomd7Ok3u5m9PXgA5XmjejU8fM
Message-ID: <CAPhsuW5PqNyjoDP+JFdteB_t6pT9g0f4yLk3JGQOPPWtejBP+Q@mail.gmail.com>
Subject: Re: [PATCH] samples/livepatch: Add BPF struct_ops integration sample
To: Yafang Shao <laoar.shao@gmail.com>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2384-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 648D941CC97
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Apr 17, 2026 at 12:45=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
>
> On Fri, Apr 17, 2026 at 12:33=E2=80=AFAM Song Liu <song@kernel.org> wrote=
:
> >
> > On Thu, Apr 16, 2026 at 12:46=E2=80=AFAM Yafang Shao <laoar.shao@gmail.=
com> wrote:
> > [...]
> > > > +
> > > > +static struct klp_patch patch =3D {
> > > > +       .mod =3D THIS_MODULE,
> > > > +       .objs =3D objs,
> > >
> > >   Nit: I suggest enabling the replace flag for this patch to align
> > > with the recommended implementation.
> > >
> > >     .replace =3D true,
> >
> > This is an interesting topic. To fully take advantage of the replace
> > feature, we need more work on the BPF side.
>
> Right.
> Replacement seems to break struct_ops registration and BPF
> re-attachment. On the livepatch side, we should add support for the
> 'livepatch tag' to prevent these types of livepatches from being
> replaced ;)

I somehow knew you were gonna say this. :) But I don't think this
is a strong enough argument (and will probably scare folks more).

Thanks,
Song

