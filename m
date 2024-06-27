Return-Path: <live-patching+bounces-373-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3F6491ABFE
	for <lists+live-patching@lfdr.de>; Thu, 27 Jun 2024 17:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F4A31F21D31
	for <lists+live-patching@lfdr.de>; Thu, 27 Jun 2024 15:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FF4A1991DB;
	Thu, 27 Jun 2024 15:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J6g0aDhC"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED07319922C
	for <live-patching@vger.kernel.org>; Thu, 27 Jun 2024 15:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719503761; cv=none; b=UTds4MY2mhUX36hfEuy6CyR+Znlr5SKrAbC1RPht882vDrDAie+CJNZzromEkPwS4qJSRovRT33uU56OoKSil/TS5bUUiTSijHOvTR21v+GaJDAqqjU0KT/yxvoN1p0zr9JlGNEZ/iLLJtTQXjSGJyOSpnSn0yTz5HTlT9lzRSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719503761; c=relaxed/simple;
	bh=Z6Kf5jGzO/QR5u/QL626kFHukHC2vwQS+NTTVMq7mik=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MqraC5eA2yClppuWhCjXXT2F7UqsMOTMvPYlhgzZ2JrebL404AMR+KXLXO7H0KaMJLS9oBMr2ehMegnj300emun+AZx5mHuB/f5IvFz0lG09r8/5cImGG/gzg8eTAJ+Vv5ZqSKgev/xGthdjHVaWOhxgDQx0sn3HOZ7MaHXTPr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J6g0aDhC; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-48f760f89c3so1070977137.2
        for <live-patching@vger.kernel.org>; Thu, 27 Jun 2024 08:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719503759; x=1720108559; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LB/PyaK/w0/5DpEtcozxfIzRFeVbHomf0LWHAivFszo=;
        b=J6g0aDhCxW1mfhmUXpRKYIC5rcSjleX3LvfE/vJPGmi5t1Smm7zzCF5lIu2YhgQ382
         hcWtiVKhyHhTgl3kzdWsyWh7YOzrEoQK5RZGjSxMZGpD0zIA8bh/6NWUSpaxXe2tUuUK
         8GTp0N8ISOce5qx5gL2zR5vC2rx+ZvgmixMrKSwyAEOd44ewTZtFUyzOPo7me4JcBikt
         7NG3yT8s5MFRUJD0mFglbLjPojkb94TWuCSnFkTjutPCN8rFgDpcm9qO1hb04OCpOlQa
         jEFqNO3Gadi/6HV4e6wN3/wCGrM9HqTVvwHu19QlxdQNBhCWW1hRD5mTVokjzvVHtICB
         73Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719503759; x=1720108559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LB/PyaK/w0/5DpEtcozxfIzRFeVbHomf0LWHAivFszo=;
        b=AjCJTvrk4jSDzeArf+ZUxvIbkiXz731Ke2AFaeueA6dwIcoFTAEnTSjYciKNNiX136
         r5/C7WG+Ipne7fzGM1JDYm6sKoVFwUFXYkFgklqcX1kvrpT4lfnxezRSYDSKBp2RD+dw
         CrAy3bLHbkA94H9PcEMbWEmtXGQ9cUA30fk7sZGoQF/PkG0EUBgcjooNWnBSqibvInb0
         2/8L2KjEsnaJJOHf16zCOW7EzK127JLOnfcboaGdYzRvkZC8a/ET9apRk+c5oAiizVvW
         z2jlD0YP8pl+Zdbcl4C6LdGBnNY0r4ociczL/c8yjbh6Xm0fmEscHYAVuvDsknyniB9B
         cXTw==
X-Forwarded-Encrypted: i=1; AJvYcCVeePKXXif1zwj9qE0anLDXGIvWH2R2zK2vIFFAMQf91tsp12XnkTWAe58sCNS6AsrRggvEr6ll6q3PMJPFBQ5xPIxfg1thW5kikz6xNw==
X-Gm-Message-State: AOJu0Yy3TOy8u2wedlOcEVADQ4B9kg3qLIsfoIImgYt4cTygyJZJ1my4
	nsKb1/DFmCaygQI0jYJSd7RE6rqHKBu6UmGyWaAjQhH2e+4bZrli/0OAMxTeYbiJETUI2ZAYkSx
	uIvgo+X8wXN3ncYU6ELuc4YDmGzs=
X-Google-Smtp-Source: AGHT+IG6JSFCl4Fi6Id9K1f7krbugYdC1+AiH6bRPzc24WrHqSxI0wQbmLya+X3qwl1CjYYpA+n5acM+sjgWsWjzfHo=
X-Received: by 2002:a05:6102:828:b0:48d:993b:c03e with SMTP id
 ada2fe7eead31-48f4c063e4fmr14047328137.6.1719503758806; Thu, 27 Jun 2024
 08:55:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240610013237.92646-1-laoar.shao@gmail.com> <CAPhsuW6MB8MgCtttk2QZDCF0Wu-r0c47kVk=a9o1_VUDPHOjVw@mail.gmail.com>
 <CALOAHbDPXDZQJENvN-yZM-OyrTy94kE6wMLGHt83m_y3O23bRQ@mail.gmail.com>
 <ZnUsYf1-Ue59Fjru@pathway.suse.cz> <CALOAHbByr3UMy=xzP82LA=D3rW-uw+s3XfzHQMVYxu4RomAANg@mail.gmail.com>
 <ZnVQJEoXpaONuTNE@pathway.suse.cz> <CALOAHbALyUdQqvjEiZ+2=3HaAyY94UL5ZTLT0ZzNPJH-vv=3GQ@mail.gmail.com>
 <alpine.LSU.2.21.2406271459050.4654@pobox.suse.cz>
In-Reply-To: <alpine.LSU.2.21.2406271459050.4654@pobox.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 27 Jun 2024 23:55:22 +0800
Message-ID: <CALOAHbDJRGD9XBORx2OSN=KRc=aACPLXn1TG3KsYE+M3U261sw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] livepatch: Add "replace" sysfs attribute
To: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>, jpoimboe@kernel.org, 
	jikos@kernel.org, joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 27, 2024 at 9:02=E2=80=AFPM Miroslav Benes <mbenes@suse.cz> wro=
te:
>
> Hi,
>
> > > > Additionally, in our production environment, we need to ensure that
> > > > there are no non atomic replace livepatches in use. For instance, s=
ome
> > > > system administrators might still build livepatches outside of our =
CI
> > > > system. Detecting whether a single livepatch is atomic replace or n=
ot
> > > > is not easy. To simplify this, we propose adding a new sysfs attrib=
ute
> > > > to facilitate this check.
> > > >
> > > > BTW, perhaps we could introduce a new sysctl setting to forcefully
> > > > forbid all non atomic replace livepatches?
> > >
> > > I like it. This looks like the most reliable solution. Would it
> > > solve your problem.
> > >
> > > Alternative solution would be to forbid installing non-replace
> > > livepatches when there is already installed a livepatch with
> > > the atomic replace. I could imagine that we enforce this for
> > > everyone (without sysctl knob). Would this work for you?
> >
> > Perhaps we can add this sysctl knob as follows?
> >
> > kernel.livepatch.forbid_non_atomic_replace:
> >     0 - Allow non atomic replace livepatch. (Default behavior)
> >     1 - Completely forbid non atomic replace livepatch.
> >     2 - Forbid non atomic replace livepatch only if there is already
> > an atomic replace livepatch running.
>
> I would be more comfortable if such policies were implemented in the
> userspace. It would allow for more flexibility when it comes to different
> use cases. The kernel may provide necessary information (sysfs attributes=
,
> modinfo flag) for that of course.

The sysfs attributes serve as a valuable tool for monitoring and
identifying system occurrences, but they are unable to preempt
unexpected behaviors such as the occurrence of mixed atomic replace
livepatch and non atomic replace livepatch.

If the flexibility of the sysctl knob is limited, then perhaps we
could explore utilizing BPF LSM or fmod_ret as an alternative
implementation? We would simply define the necessary interfaces within
the kernel, and users would have the capability to define their own
policies through bpf programs.

--=20
Regards
Yafang

