Return-Path: <live-patching+bounces-336-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E80BA900446
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 14:59:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B7D4B25EFF
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 12:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15430190069;
	Fri,  7 Jun 2024 12:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bLme9/sf"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96C615D5BD
	for <live-patching@vger.kernel.org>; Fri,  7 Jun 2024 12:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717765174; cv=none; b=UWQo7LU/gUpNBUvXPRbTLwv+nsThJDCApapYRumVmX8VFBGwmUuhH5CmuJPD8cvzqoaFMI6+h9lkGPvdls9WXm3q8jGWVWMur7nOA0QLh54kowwPF4dM3wwsBsJ5+0aZTeKhT3mlER9oCyFUZAQFfKWbSKHIrq5UNJ7Bt6hutRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717765174; c=relaxed/simple;
	bh=fT/RD2yOOGrEmukuAM8yiyeFrn2CLIEgTVstKOXRj6k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kj/DF1/oOqrJmRI0JDOsAE4jZMcot8t9sk133YPgb3pQQx3eIFmw3PiMAGKOO9X+yZD8nq7uhtOw3gYu9ySuWTonUlnfFN9Yi0w3cNa1vlq8wDL81qCkQQGL7CE+r0+sxb2G0IXIJF569HCDnY+qrSH0jvmImHh7+CRGz7W0018=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bLme9/sf; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2eacd7e7b38so22688681fa.2
        for <live-patching@vger.kernel.org>; Fri, 07 Jun 2024 05:59:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1717765169; x=1718369969; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CirM7C8byD9u+ucaaiurOgr6o3fsvgMJivfLL2vja7U=;
        b=bLme9/sfH3rMO9mlgOsGIUuu/KvrQB0iSN7eOZD/0s4H+WJYDp5WlV/tT2AuScxQE9
         0E0CtWvP1CYM315zMAO2h1zS/+n5SyN+tHtJhkzCvdE1OcBrVhdduAChWwabRTCJWf2P
         7wXf5JQ1WNZu/fn9PLTaDwJg6YvAiu26dJVASWrzya77i2N+kMpsDUuosjbmxjSi19aw
         aZjdIN/LjuUVIx+wADnUvtJFGMZllQEXtTBHPzvALUauMAVl3/kB/IHa8KlzDQ22Wr/v
         c8RadqAGCQop8YUtDf/1f1kA6XkO1yrEayIhmtGtqlSzAve1+8HQUavOxiaSP+FyU1L1
         +c7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717765169; x=1718369969;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CirM7C8byD9u+ucaaiurOgr6o3fsvgMJivfLL2vja7U=;
        b=X3Ijt3F+2plsv6kSKwD0A8KS4BZwHHqml1ruEXXIWwGua4TeWTbCZttCRP6AE3Ge5w
         MCxXdWwI1GDKHbrd5m/ZBTVzbhyQD6XJb2OJCpO2xVSyK3bn8V3CXohi196yWoGBXMWG
         7DKhJSuHhX7LNv70ANXCV9KI4Eqt7DC05gBLhQaIY3he8Q+SuUSeadrw9BPwcOVmQ7tc
         JVxHubTx0OtCwGtFEbMtH9Y1v+KZI+JMCholeUrwO51MKooGdNH0bmlg9G/7RNY1+s5N
         LCFDdNQCXFwfiTJfqixZdeOlclGy8e6yLSqQpW+5dFqix6QPqMBkSWbDMmqh/Zx30U4M
         lSMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMNRpTeaM8Ovy6sfGEmzPm/Z49zuCeAtmeDTj0hNkLCTwu93GCYjoXep4DE5awZo9gLDcVzCcE/jN0pdJ2J06oK5TcQfQUppHJCm9DrA==
X-Gm-Message-State: AOJu0YyfnEhNnyXcVm82w/6CvDonsS/wH9x2WJYumlAwjjPnbsX2C8A8
	DC3Rml9wf4CCYelghfZDmaPTGpA6HgFNAsttnXPvvQ5zw7kQ36ClCUEQ8E52NnY=
X-Google-Smtp-Source: AGHT+IG3RiPJA1w57fiFmRBf2J2smlfsqkh6H92YPBio9Dl2gp48lfuiMQVD2UW7/de+x0NfKGG4Tw==
X-Received: by 2002:a05:651c:a0f:b0:2ea:8e94:a2ea with SMTP id 38308e7fff4ca-2eadce23e9dmr26585661fa.6.1717765168689;
        Fri, 07 Jun 2024 05:59:28 -0700 (PDT)
Received: from ?IPv6:2804:5078:851:4000:58f2:fc97:371f:2? ([2804:5078:851:4000:58f2:fc97:371f:2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-703fd49aba7sm2528107b3a.101.2024.06.07.05.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jun 2024 05:59:28 -0700 (PDT)
Message-ID: <1601fed223252c8d0e26389bfa738238d0fd5ac7.camel@suse.com>
Subject: Re: [PATCH] livepatch: Add a new sysfs interface replace
From: Marcos Paulo de Souza <mpdesouza@suse.com>
To: Miroslav Benes <mbenes@suse.cz>, Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Date: Fri, 07 Jun 2024 09:59:17 -0300
In-Reply-To: <alpine.LSU.2.21.2406071425530.29080@pobox.suse.cz>
References: <20240607070157.33828-1-laoar.shao@gmail.com>
	 <alpine.LSU.2.21.2406071425530.29080@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.1 (by Flathub.org) 
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2024-06-07 at 14:33 +0200, Miroslav Benes wrote:
> Hi,
>=20
> I think the subject should be something like
>=20
> "livepatch: Add "replace" sysfs attribute"
>=20
> or use a different way to stress "replace" is the name.
>=20
> On Fri, 7 Jun 2024, Yafang Shao wrote:
>=20
> > When building a livepatch, a user can set it to be either an
> > atomic-replace
> > livepatch or a non-atomic-replace livepatch.
>=20
> I am not a native speaker but I would drop '-' everywhere in this
> context.
>=20
> > However, it is not easy to
> > identify whether a livepatch is atomic-replace or not until it
> > actually
> > replaces some old livepatches.
>=20
> Ok.
>=20
> > This can lead to mistakes in a mixed
> > atomic-replace and non-atomic-replace environment, especially when
> > transitioning all livepatches from non-atomic-replace to atomic-
> > replace in
> > a large fleet of servers.
>=20
> Out of curiosity, could you describe your setup in more detail here?
> It is=20
> interesting to mix different type of livepatches so I would like to
> learn=20
> more.
>=20
> > To address this issue, a new sysfs interface called 'replace' is
> > introduced
> > in this patch. The result after this change is as follows:
> >=20
> > =C2=A0 $ cat /sys/kernel/livepatch/livepatch-non_replace/replace
> > =C2=A0 0
> >=20
> > =C2=A0 $ cat /sys/kernel/livepatch/livepatch-replace/replace
> > =C2=A0 1
> >=20
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> > =C2=A0Documentation/ABI/testing/sysfs-kernel-livepatch |=C2=A0 8 ++++++=
++
> > =C2=A0kernel/livepatch/core.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 12 ++++++++++++
> > =C2=A02 files changed, 20 insertions(+)
> >=20
> > diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch
> > b/Documentation/ABI/testing/sysfs-kernel-livepatch
> > index a5df9b4910dc..3735d868013d 100644
> > --- a/Documentation/ABI/testing/sysfs-kernel-livepatch
> > +++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
> > @@ -47,6 +47,14 @@ Description:
> > =C2=A0		disabled when the feature is used. See
> > =C2=A0		Documentation/livepatch/livepatch.rst for more
> > information.
> > =C2=A0
> > +What:		/sys/kernel/livepatch/<patch>/replace
> > +Date:		Jun 2024
> > +KernelVersion:	6.11.0
> > +Contact:	live-patching@vger.kernel.org
> > +Description:
> > +		An attribute which indicates whether the patch
> > supports
> > +		atomic-replace.
> > +
> > =C2=A0What:		/sys/kernel/livepatch/<patch>/<object>
> > =C2=A0Date:		Nov 2014
> > =C2=A0KernelVersion:	3.19.0
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index 52426665eecc..0e9832f146f1 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -346,6 +346,7 @@ int klp_apply_section_relocs(struct module
> > *pmod, Elf_Shdr *sechdrs,
> > =C2=A0 * /sys/kernel/livepatch/<patch>/enabled
> > =C2=A0 * /sys/kernel/livepatch/<patch>/transition
> > =C2=A0 * /sys/kernel/livepatch/<patch>/force
> > + * /sys/kernel/livepatch/<patch>/replace
> > =C2=A0 * /sys/kernel/livepatch/<patch>/<object>
> > =C2=A0 * /sys/kernel/livepatch/<patch>/<object>/patched
> > =C2=A0 * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
> > @@ -443,13 +444,24 @@ static ssize_t force_store(struct kobject
> > *kobj, struct kobj_attribute *attr,
> > =C2=A0	return count;
> > =C2=A0}
> > =C2=A0
> > +static ssize_t replace_show(struct kobject *kobj,
> > +			=C2=A0=C2=A0=C2=A0 struct kobj_attribute *attr, char
> > *buf)
> > +{
> > +	struct klp_patch *patch;
> > +
> > +	patch =3D container_of(kobj, struct klp_patch, kobj);
> > +	return snprintf(buf, PAGE_SIZE-1, "%d\n", patch->replace);
>=20
> It might be better to use sysfs_emit() here. See patched_show() in
> the=20
> same file. There are still snprintf() occurrences and it might be a=20
> separate cleanup patch if you are interested.

Hi Yafang, thanks for the patch!

Besides Miroslav's comments, I think that a new kselftest exercising
this attribute would be good, since we have tests for other attributes
as well.

Thanks,
  Marcos

>=20
> Regards,
> Miroslav
>=20


