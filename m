Return-Path: <live-patching+bounces-212-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F20D894A7F
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 06:30:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A0AE285281
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 04:30:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B3B4F9DE;
	Tue,  2 Apr 2024 04:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nI9Py2wi"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA9B2581;
	Tue,  2 Apr 2024 04:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712032227; cv=none; b=ivyawxcpwikiTicREGaXGewZz9wkAakW1YUNXk42mfxEsH9AgxKxvE1sWkTFiwhuYuCnoYsLARoG7heJC6iJiON8vttRiyazMb10s1CYApyq9pzwmmgQd4hPK+PVEdxR2DOIr7pmJ6tYiO3EJjD8ZexalssGWFseUZiUVdTMJ+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712032227; c=relaxed/simple;
	bh=NnGVhEl97Am7raKLBTlPJ1DBtqngW+xOzN0JBv7l7dQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aenn3W7nrp9Jc9SZIyDPvoaa+wIftnRYPd2zmcAUTkoo76toernSgZ1DBNqZpEad8siiCHSEbByUHbe8Bp9t5XbFJY/yUKnesN0XVRUEatWMXfq6+DwtQ4J28KTSNVmPqrpFVRB+8RI1fb02vWA13NETY+N+WrPzVn2nbscVAtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nI9Py2wi; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6962e6fbf60so42077806d6.1;
        Mon, 01 Apr 2024 21:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712032224; x=1712637024; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cCnZVaNFJDMBM5Krz9488jM0lPe36JgfRYsTC7bRVZQ=;
        b=nI9Py2wizvJDFF95tL2+ZBtT4FKF7uAjJ2O3EVG8mlee4NN7JNi4hCvlatuC1okg4l
         AuI0jGgZNS5GQXPn8gBduEjT8i7Z8HW9WLvP2m2cJg1gXtcR2pPiRYcLkrmv7WSdRBgp
         ync0piUjJfz1/UGK2fKT7zh2tuJ1I5MkdNfJmMpzlgldBdXRcELdZPEeBHiywJ/C3o0N
         apfQ7hA4bzjTJgrBRdrc2NKmurtXYbNCTKs9NgUes/lEMTOp5wEpgxfkAUYCdMH1Lt+1
         EvHK2vtJllcdrmDWtFEfYo+fsTKpf7HTzH8bF2rVOhS1BsFyd/JmLLzfoZOH9+YNu7LA
         rmfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712032224; x=1712637024;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cCnZVaNFJDMBM5Krz9488jM0lPe36JgfRYsTC7bRVZQ=;
        b=rA8eOPxznLIMtAlI7d1AZKS1LCHXMaiuqth9IUpoZY/KbIm6QAs8gxb62LNq/P5lLd
         95XbzZ6I9OxPtqdp00pNHHvv32lE7iJh+FlIXmfyH94B2qivUmSidMWa2ucJSrsVVZ51
         oeYBPb2tJYxCh5rOGi8gQNNyFSih9yROi5du5oI/VWvA+5x/whee20v9wgrSpry+zt/j
         oIK7CHpMfxdfXzHH+RPpoWpTu37VJrhTcoHkn1H9+P5S2gYf3Bz1GYUNFaJlHKeNAPGS
         57DCxQikGhE3uKi5m6rQ18EkHb5CZp64Waulefr6F3BfQlgjOogpS3zMA91I1P2Hotcw
         yZCQ==
X-Forwarded-Encrypted: i=1; AJvYcCV0+GviAAP0CmCoBKAAt+t7SnG2pcSbFPiUrjqsG3/z+O1MH08WS77/3XO4Ndg+IkvQZqM1R/kEFwUfiWEjtSZEJVoWQIvhSV3TprrjN1LltIdrByd3ScTffnoOlMqQv4VMRw8qyq8wxt/fgBU=
X-Gm-Message-State: AOJu0YyKwn3SUbN4PnMWvr2eSpEVqc2aaj6v+dTIsDwXOuxZ0/CM3M+1
	nSaj/4Ub9EOXdzzl0qwEZzYNil/ky/PEwlF2JTyjwQ9ZxX8qe4oOqiE+X/93F/5lP4EAi1iTc9B
	+AecDMVyB9DMuroyqvmVK8pDAOSE=
X-Google-Smtp-Source: AGHT+IG+O7biTi4bhAl3eP7S+JMTS0VVIGemnTY9jd70iKFpY4PnlasTOgWO0VnKXqoKxReqQ30eFzhzUOqAASdtpZg=
X-Received: by 2002:a05:6214:f27:b0:698:f030:c9a6 with SMTP id
 iw7-20020a0562140f2700b00698f030c9a6mr14290290qvb.65.1712032224524; Mon, 01
 Apr 2024 21:30:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240331133839.18316-1-laoar.shao@gmail.com> <E75FC9D0-22AD-4FB6-B9F1-CE4A7C9DBBA8@gmail.com>
 <CALOAHbCzfoz0r=PPUdSVsBeHEjdbB8jtZM3-foTMYk183EjjVA@mail.gmail.com> <E388354A-4FA5-4C64-A65E-2CBF129CA6A9@gmail.com>
In-Reply-To: <E388354A-4FA5-4C64-A65E-2CBF129CA6A9@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 2 Apr 2024 12:29:48 +0800
Message-ID: <CALOAHbBo2XUArDhnV2m6G59+S0cSDO6u30yohBvhiKAqKvtwxw@mail.gmail.com>
Subject: Re: [PATCH] livepatch: Delete the associated module when replacing an
 old livepatch
To: zhang warden <zhangwarden@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, mcgrof@kernel.org, live-patching@vger.kernel.org, 
	linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 2, 2024 at 10:56=E2=80=AFAM zhang warden <zhangwarden@gmail.com=
> wrote:
>
>
>
> > On Apr 2, 2024, at 10:27, Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > df1e98f2c74
>
> Hi Yafang!
>
> To my first question, from your patch, klp_free_patch_finish may not affe=
ct non-livpatch module. However, if my reading is right, your patch make ch=
anges to SYSCALL of delete_module. Making changes to sys call may effect no=
n-livepatch module, I think.

I can't get your point here. Impact on what? The performance?

>
> Tell you the truth, in my production env, I don=E2=80=99t use klp replace=
 mode because my livepatch fixing process dose=E2=80=99t adjust the logic o=
f replacing the previous patches. Therefore, klp-replace mode is not suitab=
le in my situation. The reason why I ask for safety is that this patch seem=
s to change the syscall, which may cause some other effects.

Most code modifications within the kernel have the potential to
directly or indirectly alter one or more syscalls.

>
> For the commit ("kpatch: rmmod module of the same name before loading a m=
odule=E2=80=9D) in patch userspace, it seems to fix this issue, while this =
commit is working in userspace, under kpatch=E2=80=99s control.

It appears there may have been a misunderstanding regarding the commit
("kpatch: rmmod module of the same name before loading a module"). I
recommend trying it out first before drawing any conclusions.

>
> What=E2=80=99s more, your patch seems to be malformed   when I try to pat=
ch it. Is there any thing wrong when I copying your patch?

I don't know what happened. Probably I should rebase it on the lastest
live-patching tree.

>
> This is only my own option in reading your patch. Thanks!
>
> --
> Regards
> Warden
>


--=20
Regards
Yafang

