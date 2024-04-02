Return-Path: <live-patching+bounces-209-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AC3AD8949B1
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 04:57:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3BF5BB25461
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 02:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE63614005;
	Tue,  2 Apr 2024 02:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IPNNZbDI"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B39517BA8;
	Tue,  2 Apr 2024 02:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712026605; cv=none; b=crGnnAeeNS80X5q7Gn7EnfH0HB8ixrvC4M1+UoDAvAPithSbFTPEv8AzWLzbcm/I1v9DSBWvQDbEgXUVoO4Ce9wMpwxew30FgT8J8KeDYQgKpDN6Rudb4QhPYhbiEJcX+kSP/FAvCljeS9OuetnV4W/pTh5SC5Dql3ejZM14Yk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712026605; c=relaxed/simple;
	bh=YPa7+cMB/Q8XxTTEJbZPj++YCyfRAed5cks7zu44ugs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=jm+SN0T8SPoAMYnlhLxKj/fAeR9hCLCHPVhHCXCTOCQsTIz1OowMvQIIzWmZtiy6QN7mGb41vKXAa/M8n1H4iX05SwOilXfuogG2m0PzoW1A/mkXzMnudl6FK3zk9O5LZRw9JGhWkwUMCp8j22s7rtKoTrs1W11hELI2o0xFp6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IPNNZbDI; arc=none smtp.client-ip=209.85.215.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f194.google.com with SMTP id 41be03b00d2f7-5d8b519e438so3282978a12.1;
        Mon, 01 Apr 2024 19:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712026603; x=1712631403; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQvktJ5NOLPFOAxB9ZrxU2xKDPwGV3LW1PpZ4E+LqDw=;
        b=IPNNZbDIys9qQ2sAVtSj+GuCXb2i9Cz2QlOSWdiBhOsmMb0CdUTJAa981CiDJP0men
         2SS66gEUwLsAQPfiNW7bMbjEsJsGoA/qonRroc9Y+Sx04TzdymIUR0QThEdPC41CMRUk
         TbcDYiGMWeHrNZZjgtf14nLAACuttLEBqpZ1DL0b/eB0ee8QBITSlZXri27gOfk5AQ0Z
         1SX049+skq4SLg8H5IDKb1ktiu/3ZBedloYtzVVK4CMCSeyXVmbO713h1peWywU9EHhi
         HeMUTHWM6b3eLPSzCUxva7ulO1NGyQje9we6C0oux53PfTOYBM7nfWnfK51Tt7/hKkup
         FFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712026603; x=1712631403;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQvktJ5NOLPFOAxB9ZrxU2xKDPwGV3LW1PpZ4E+LqDw=;
        b=lR4xw8ovUj/gMMzlc0nDaENcql9gbCnS2tu9lxHFiONVRuFsJPIE9oQbHiMIF2v7tM
         gODq5Ojm5gnrsSp79IWbLrqAkSJrLj1v9LAYzyPo/2v3Zh9ODImNizr83gKml8mNhOLi
         vLXCGQV2a1y6VoQxPgBAznMhyQyBlLkHIb1raFxnfFHID6/0Pvbg81aLg/9up0V3djyd
         Zypo/nxnOW6VC4qw/3bZ8zdlECLaBY4fMUixUKZ3b+kPFVYpBbJv0uIfT+tkBVGuNGYQ
         ScNoQRr68ctK2nXV6PrgyzDfMKobxp3PeIdjLLYq6PLAlS0Nn1L0LK9boeO/ZuGUeo3+
         SfDw==
X-Forwarded-Encrypted: i=1; AJvYcCWHnZMFDfxqoJOrL00frlviFoHfoBn1efn/dWXaknTkMFfDyY9lMvFtiEmmU2M+qGicP2BiiHpHvdikRs62zquUkP9P3uRMkpemFFck8jaZvH+4RyHEPNzyy10OETdHQNyLYzSb79qkQpVyZhQ=
X-Gm-Message-State: AOJu0YyqouxKLZFRhYiYhDEuYku322I7fGChsizGL0cNSWXp3PrBz6Bd
	UxpyEvGY3R3D7O972vSv+Z13s+Ix12X4miR4h5VSRq4Swimn9lu9
X-Google-Smtp-Source: AGHT+IGGSrSASvQshMgXCQQ1vPH9kd5arBZcHKAvsmJldpozhuFL0FTNtwO2Ezu2VBtbx4KJ2YcRIw==
X-Received: by 2002:a17:902:64c8:b0:1e2:7879:8be8 with SMTP id y8-20020a17090264c800b001e278798be8mr132910pli.58.1712026603515;
        Mon, 01 Apr 2024 19:56:43 -0700 (PDT)
Received: from smtpclient.apple ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id l5-20020a170902f68500b001e06cc3be27sm9798050plg.253.2024.04.01.19.56.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Apr 2024 19:56:43 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH] livepatch: Delete the associated module when replacing an
 old livepatch
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <CALOAHbCzfoz0r=PPUdSVsBeHEjdbB8jtZM3-foTMYk183EjjVA@mail.gmail.com>
Date: Tue, 2 Apr 2024 10:56:30 +0800
Cc: jpoimboe@kernel.org,
 jikos@kernel.org,
 mbenes@suse.cz,
 pmladek@suse.com,
 joe.lawrence@redhat.com,
 mcgrof@kernel.org,
 live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E388354A-4FA5-4C64-A65E-2CBF129CA6A9@gmail.com>
References: <20240331133839.18316-1-laoar.shao@gmail.com>
 <E75FC9D0-22AD-4FB6-B9F1-CE4A7C9DBBA8@gmail.com>
 <CALOAHbCzfoz0r=PPUdSVsBeHEjdbB8jtZM3-foTMYk183EjjVA@mail.gmail.com>
To: Yafang Shao <laoar.shao@gmail.com>
X-Mailer: Apple Mail (2.3731.500.231)



> On Apr 2, 2024, at 10:27, Yafang Shao <laoar.shao@gmail.com> wrote:
>=20
> df1e98f2c74

Hi Yafang!

To my first question, from your patch, klp_free_patch_finish may not =
affect non-livpatch module. However, if my reading is right, your patch =
make changes to SYSCALL of delete_module. Making changes to sys call may =
effect non-livepatch module, I think.

Tell you the truth, in my production env, I don=E2=80=99t use klp =
replace mode because my livepatch fixing process dose=E2=80=99t adjust =
the logic of replacing the previous patches. Therefore, klp-replace mode =
is not suitable in my situation. The reason why I ask for safety is that =
this patch seems to change the syscall, which may cause some other =
effects.

For the commit ("kpatch: rmmod module of the same name before loading a =
module=E2=80=9D) in patch userspace, it seems to fix this issue, while =
this commit is working in userspace, under kpatch=E2=80=99s control. =20

What=E2=80=99s more, your patch seems to be malformed	when I try to =
patch it. Is there any thing wrong when I copying your patch?

This is only my own option in reading your patch. Thanks!

--
Regards
Warden


