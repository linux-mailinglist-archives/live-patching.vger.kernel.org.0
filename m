Return-Path: <live-patching+bounces-348-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24FFD902E91
	for <lists+live-patching@lfdr.de>; Tue, 11 Jun 2024 04:47:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 49A271C22900
	for <lists+live-patching@lfdr.de>; Tue, 11 Jun 2024 02:47:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0636D152161;
	Tue, 11 Jun 2024 02:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="idzPJIZN"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 800E98286B
	for <live-patching@vger.kernel.org>; Tue, 11 Jun 2024 02:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718074050; cv=none; b=aWUvqPY7d+vtOzkypPtBaMyIkX92hHU2fxkakkj8sMcyCV7vho//EEMFxYQmP32MdSzCdMhH8KsTZpUhTx+Zu4HgQAn8l9mvJ7PqZ0E8gKdR48sjvpAsWvvlHy389bJYWmx3oS8mCQ5fliS21JKkWsMcbVnQJ5lm80C9jXXCMF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718074050; c=relaxed/simple;
	bh=S/NRb/xFsTL1wRSg1+gfCoPhj5m8vDro81jifDJyMBo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UZdUpj/NCsFYn1AfxRQgJ8rvQGaEWXkkS8WIaEb6svnpknW8qqNLCEylGQA/rSjiUGUNcLTIWSlKrymH4AnkTpigQSyluN9KmQPvCjK3xr5HdnYydK4SPvAJnYn08WlVLcgKZR4XPCIe6TbxpP0Smdc6VAjzgL20XbWW05WsF3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=idzPJIZN; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7960454db4fso84969885a.2
        for <live-patching@vger.kernel.org>; Mon, 10 Jun 2024 19:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718074048; x=1718678848; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S/NRb/xFsTL1wRSg1+gfCoPhj5m8vDro81jifDJyMBo=;
        b=idzPJIZNbP92VSO9QTJf1Bm7YmK8e4sKr8Il2Ih60BFzXP4KGR+5maO28TnHPU4IZd
         IKc7VMKyWn8oSvGNqClCB/wKq7B02sSit2OPlmUoOU8lzDiGLNfrZk1tegGbbNq5H34U
         SvPCue0YkP1FL+ycXaDISk0l86nO5vl7XH2oe3nXI57PDfKIooI3dRmdagU1+nqw4VTx
         a3LHtv2htjaWe2YWRqZHAp5HkgNU9crnc+6oEsA1tPkERPhjHUK0/Tw+Fy8pWKRonUpK
         jtjh7kptRjwqqDyDo02vmGbxvsldYctgMi30IfdoawFhBNraI/GkUaL9uKdLvtx0L8/q
         Z1ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718074048; x=1718678848;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S/NRb/xFsTL1wRSg1+gfCoPhj5m8vDro81jifDJyMBo=;
        b=WdK64yBNgMdpWZjzh/ijk1/qA+vAkWrkSOSpzwsV+OoLWZNwU23A1nL+oqg8oNC2Zx
         KTdBBoHde/B7nqpnF6TS0FGqoWA/B/3G9cDfBpSugCWkXUgqjU0hi4Y6OBsGZpfPj7sQ
         dq7MYTYFKKpX5OG1v8e/vj1G/nmPRaRZr1XrQDyeXt1cEUcpjJRwhtg4SCm1UPiu6GZ1
         6YG4RpHnEHWVG/VTxD0LYFCnPcEgOMUcORRRZ2I0JBZ53AOct1LeumWbGz+WLIYD9Yif
         Tziy9vJfP7zUbCOP4axWqKHtJxOKoxRkaYZFYimD610HJiyUNk6KCDmYK9R0kag3GhDy
         Akqg==
X-Forwarded-Encrypted: i=1; AJvYcCVIYBFR2oZwDgs3S4nH5DYJ3JqYBpl1TAfE00RJ1YTHsBbeVUD/uIO+22yHSd2zwAukQIi1bJ72G2cawx/PrAX4tgxQ7O8xrG5fVQl8Lg==
X-Gm-Message-State: AOJu0YzyQwbRORKZWbPwzflyT/zn8zGtfb9QnA+pojKd1jbXSIIyg4F8
	ho3+lILGS4igd+Y65TV3wcYueyOGcqs9JorhhwDHylZhRPX5D7UTA8MtrpFhBe7yg0Qwnu+aNDa
	kJAUQxqB1tZRMFu5Mqqk+v9eJMbFtQzq4jOA=
X-Google-Smtp-Source: AGHT+IGBM/a1Z6bWoQD/j9MAGZ9urfQHdtSkZDsK3g83azKan46aVvIKedQmnO1iNzxIaolz9X63EwTRM8xNyMgrKaw=
X-Received: by 2002:ad4:5a50:0:b0:6b0:89a8:5704 with SMTP id
 6a1803df08f44-6b089a858e9mr14829216d6.65.1718074048200; Mon, 10 Jun 2024
 19:47:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240610013237.92646-1-laoar.shao@gmail.com> <CAPhsuW6MB8MgCtttk2QZDCF0Wu-r0c47kVk=a9o1_VUDPHOjVw@mail.gmail.com>
In-Reply-To: <CAPhsuW6MB8MgCtttk2QZDCF0Wu-r0c47kVk=a9o1_VUDPHOjVw@mail.gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 11 Jun 2024 10:46:47 +0800
Message-ID: <CALOAHbDPXDZQJENvN-yZM-OyrTy94kE6wMLGHt83m_y3O23bRQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] livepatch: Add "replace" sysfs attribute
To: Song Liu <song@kernel.org>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2024 at 1:19=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
> Hi Yafang,
>
> On Sun, Jun 9, 2024 at 6:33=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > Add "replace" sysfs attribute to show whether a livepatch supports
> > atomic replace or not.
>
> I am curious about the use case here.

We will use this flag to check if there're both atomic replace
livepatch and non atomic replace livepatch running on a single server
at the same time. That can happen if we install a new non atomic
replace livepatch to a server which has already applied an atomic
replace livepatch.

> AFAICT, the "replace" flag
> matters _before_ the livepatch is loaded. Once the livepatch is
> loaded, the "replace" part is already finished. Therefore, I think
> we really need a way to check the replace flag before loading the
> .ko file? Maybe in modinfo?

It will be better if we can check it before loading it. However it
depends on how we build the livepatch ko, right? Take the
kpatch-build[0] for example, we have to modify the kpatch-build to add
support for it but we can't ensure all users will use it to build the
livepatch.

[0]. https://github.com/dynup/kpatch

--=20
Regards
Yafang

