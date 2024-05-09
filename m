Return-Path: <live-patching+bounces-256-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38B188C09B1
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2024 04:18:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8941281D60
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2024 02:18:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B161213C9D9;
	Thu,  9 May 2024 02:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PNZWSUQ6"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A14513C9C8;
	Thu,  9 May 2024 02:18:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715221101; cv=none; b=O+oTobxL+W6lh/m7k7DHzNMOvOpUnJ4a9RQkE40JXH00mzh0E9pfEfB0M0usm5fr5d3dXZj+P+6jPH77zEtIz0GvzFca5gFiy9ne6THBqWt/kisyeNRz7Chg/a1s8Pa5YqWTVAHYed6OJWINqOdc7ptI2caU090u04eTMsfPYTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715221101; c=relaxed/simple;
	bh=L3r2/T18yqXh4dj6ELmFMPSP7SgVKhFxKsKSN6i4DYY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cstc72uTpKzr1jLXjXmzEgy21qmEJ9b4nTNYFBLPHZn1fVLgdiSWPvxgsygrYqTKsRdZ8kjhS/6y8n4bixllvkF0E4DOEYWfx0q2XMvp8vrdytJt/KeVKrItvO5HvXbpDKaweIp6cgoYK0O+T2AZv3tRz3D4idCgF55Wr5OQJKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PNZWSUQ6; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-69b7d2de292so1729896d6.2;
        Wed, 08 May 2024 19:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715221099; x=1715825899; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ttdTwj2Q5hVAH0qhkaE9Mh1Z8eimVRztRoz9uZHQNJc=;
        b=PNZWSUQ6aMoarfV37roa/RSSReiHj3atTqh4olNEpRPC9kAZRe2bxLVwBjexj8gkO5
         wjon3Y1W1lPlWohmjwhK7mHob0BEUNDoQGtq2Es/iTyk25z4yxrBKpV0rm+dC3CsLA74
         RPTLoVR0IoOrZJ11VjkkXzrir53j2ZNKujkB4shoypcesMki0mItTorzL9qGanzZAL/g
         1CttXfZnwlJn1FjrR9GnDPttnZpnxbLfPPRX6TPxSUPJAXFeAs211v7lScTn6av4ZAq/
         PK1Tl/ff7ktJ2UcEgWeQOAcCQvc0Vzhxi6IVOLkReOE3m2qe2oI86W6Qc8zxa59few+1
         1/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715221099; x=1715825899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ttdTwj2Q5hVAH0qhkaE9Mh1Z8eimVRztRoz9uZHQNJc=;
        b=OfL1UYzCHL+nldbM02L2AuoMnuLSXijfH+GdsrP7uF9mhR8EAxfw3rt5U0MCIq+ZO7
         Mob5HJGtfirkcqfH6i9il6jiKgIv0aJTk+diFv/uumBhFs1NaEaf8adknAwKVlH2sNLE
         NJmG9Wo4VFhy2EbHOgwILoEYGbw/H8zWG40NJJ7XBWo3Vx2M1Z11fNOvgVeGc+80oB2o
         v5HrGBlm+0BU09bP1d4KwTE0795bOsqy4cD1sg7HqFs2gzARe21JuSf3sCd9nWexpiKy
         eEugxOnpdBUh//qivyTqULSN+wd2xsDREGrrp0RwW85f9PUJ5PyVB8jtLe5CM4ybcl3J
         HWOg==
X-Forwarded-Encrypted: i=1; AJvYcCXjeE/P6FAT/A2IwjjaX7Ptyf8BZD2bSSGTMYcZXCmopwDOfJyClBh8xHqOTl+KZqEtAtO2tGrc/Xdk7NpWYSlVtaNUqaNFQ7420SeN8BSY1f7+uhHlvtg7UtCvM+gM4MIKPqA9sOtTlgk7178=
X-Gm-Message-State: AOJu0YzxqDOFgXXmodxCGiNss6jH4ehPGhFV4O9gTqsBBT2JAiCxAuqR
	fSsLTQHFv0ktS9w9wuTqdcksAP8GqdxQymSGqoLUufTdykZg8kgwHsgY5R5sAD1kNZSHsRhXHFP
	AhKnepAP5JwlPs0DLmxi1lvTWzMo=
X-Google-Smtp-Source: AGHT+IHuMBB4fhBzqBQVIcYG6xaC0pHhPyuQBpdqPCDKf1WxAyJ1Nm9h5FpZj1XR6MEngsncou83sVZ08abBreWbp+s=
X-Received: by 2002:a05:6214:212f:b0:6a0:cd13:fb7a with SMTP id
 6a1803df08f44-6a1514e2980mr48727916d6.24.1715221099098; Wed, 08 May 2024
 19:18:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240407035730.20282-1-laoar.shao@gmail.com> <20240407035730.20282-3-laoar.shao@gmail.com>
 <20240503211434.wce2g4gtpwr73tya@treble> <Zji_w3dLEKMghMxr@pathway.suse.cz>
 <20240507023522.zk5xygvpac6gnxkh@treble> <CALOAHbArS+WVnfU-RUzbgFJTH5_H=m_x44+GvXPS_C3AKj1j8w@mail.gmail.com>
 <20240508051629.ihxqffq2xe22hwbh@treble> <CALOAHbDn=t7=Q9upg1MGwNcbo5Su9W5JTAc901jq2BAyNGSDrg@mail.gmail.com>
 <20240508070308.mk7vnny5d27fo5l6@treble>
In-Reply-To: <20240508070308.mk7vnny5d27fo5l6@treble>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 9 May 2024 10:17:43 +0800
Message-ID: <CALOAHbCdO+myNZ899CQ6yD24k0xK6ZQtLYxqg4vU53c32Nha4w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] livepatch: Delete the associated module of
 disabled livepatch
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, mcgrof@kernel.org, live-patching@vger.kernel.org, 
	linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 8, 2024 at 3:03=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> On Wed, May 08, 2024 at 02:01:29PM +0800, Yafang Shao wrote:
> > On Wed, May 8, 2024 at 1:16=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.=
org> wrote:
> > > If klp_patch.replace is set on the new patch then it will replace all
> > > previous patches.
> >
> > A scenario exists wherein a user could simultaneously disable a loaded
> > livepatch, potentially resulting in it not being replaced by the new
> > patch. While theoretical, this possibility is not entirely
> > implausible.
>
> Why does it matter whether it was replaced, or was disabled beforehand?
> Either way the end result is the same.

When users disable the livepatch, the corresponding kernel module may
sometimes be removed, while other times it remains intact. This
inconsistency has the potential to confuse users.

>
> > > > As Petr pointed out, we can enhance the functionality by checking t=
he
> > > > return value and providing informative error messages. This aligns
> > > > with the user experience when deleting a module; if deletion fails,
> > > > users have the option to try again. Similarly, if error messages ar=
e
> > > > displayed, users can manually remove the module if needed.
> > >
> > > Calling delete_module() from the kernel means there's no syscall with
> > > which to return an error back to the user.
> >
> > pr_error() can calso tell the user the error, right ?
>
> The dmesg buffer isn't a reliable way to communicate errors to a user
> space process.
>
> > If we must return an error to the user, probably we can use
> > klp_free_replaced_patches_sync() instead of
> > klp_free_replaced_patches_async().
>
> It's async for a reason :-)
>
> > Under what conditions might a kernel module of a disabled livepatch be
> > unable to be removed?
>
> For example:
>
>   - Some code grabbed a reference to it, or some module has a dependency
>     on it
>
>   - It has an init function but not an exit function
>
>   - The module has already been removed due to some race
>
>   - Some other unforeseen bug or race in the module exit path

This scenario is typical for a regular kernel module, but I'm
uncertain if the same applies to a disabled livepatch. Is there a
mechanism in place to ensure that the corresponding kernel module is
always removed?

--=20
Regards
Yafang

