Return-Path: <live-patching+bounces-338-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C5B99005D6
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 16:02:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A174CB2262C
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 14:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E41C190686;
	Fri,  7 Jun 2024 14:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HEhiCivn"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E795EFC0A
	for <live-patching@vger.kernel.org>; Fri,  7 Jun 2024 14:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717768952; cv=none; b=u9QFV9cJRt9fR7OdAhw3EzEpQ7+x6xRgm3yI6op9fd03RljkRRdmMl9cP7Eh9MU2p+5OvRS/qzaO0EOj55/I47pwWTahMpB9KY3+BkzY8Byssmkytny5cuWd852U937841II7iTDoN5c43NV5jc6ULRvMX/mCXjSeDEkA2/5h/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717768952; c=relaxed/simple;
	bh=St8WvUyMaQwDJgu23wFNxgfZgAvmMfDMKoOgDOUFsRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cQJNk2h/akQWm8VHmpiHtEmRTFapLKmx9O6QBC2ejhcFz+oS1/b54KM2GVYqL/KM3PUYdmN85JHhP55ob5BmJRPhyx8BOSJ8MvgmTOBJoxO/W0DPTbuORFJ5Ls+yu11k+c2zqzGJZKjlt5PiUq+fPlk7eftG8JcCk8hZRZiyVBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HEhiCivn; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6ae0dca5929so11187836d6.0
        for <live-patching@vger.kernel.org>; Fri, 07 Jun 2024 07:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717768950; x=1718373750; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zpthU+vKe4HfO60MPqMUE8RYt30vsKfafBjJ2I0KAR0=;
        b=HEhiCivn1Ll5/Lm/0W9VyLTHOPNdAVScDe7zDeDCEDN3JysS3VvtoAIro6tHAqZE9u
         6ZEmDE2jSsiOhFFh/DAn8eMZlkTLkBp4XbRivrnfkcYcXFVZQnLULYwOpNyDXVvm//qE
         1BXbbNZFUsLSV9H87Cl8snVUtCulL3MDM4tTgxj366YjsgpzFshwzwygE6vrg7xMQ6zV
         CyqgA4dyJyLXEIUG3Rdai0hyjuiqqEYI96F0/6w99y9bhfRaFP5nNW4fErSvwIK9/GuF
         Co4448F2oxRATZZKfvxrDN+L+R9RfTPTIDO7iorEOihXLsVaCjuoIi3dwEEkZzE+ts2k
         AmFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717768950; x=1718373750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zpthU+vKe4HfO60MPqMUE8RYt30vsKfafBjJ2I0KAR0=;
        b=jFnPoolxeJsLsi/hUDrhLrOFOpBAWWnQivzDvZqdSsFN1hkCDWhd192GtJgA7jx2L/
         LQQtUR04AL3uOaMwihlbpKbUryYhusvjOIPqU09zz48LVYx4JE2QZBaThFJrnG7PeU5b
         w+v7Dk8IYgKnKKjTOmANTUIPHu1NgftjuhDMYHnymEgQUlpF9MTA4D3icwXedluZTidv
         /dXbkWE86oOUWakvb3IFAomkVHoKzYiLaNd54PonodBs3ZyE+/O7FWqmvKiYCq9aLmfr
         jRzbxcTY1lwc1FgJbbgLo9/y8Dv0YHXUI5Zw/wiL1IasWcg4BKo5IVoL1evp5CaIovJn
         85Pw==
X-Forwarded-Encrypted: i=1; AJvYcCWxFhPFXSJBl0F4J9rZW6cOOzAvNj3ELIAN8PjatCXulSqAgnRchBoTE80vSl6GQix5SiWUU6wsVCgiJWIlgvg679TffnZZhwgdBf9anw==
X-Gm-Message-State: AOJu0YyktaEGZu8jw+GgrZwrMunKzRN0FpEbjR2TGUkuXSY5GVaUN2rE
	ERON9d3o4fHoLadXRJSBIbm+d0ZABAEgfr0IT6RwCzPA0hYZNbLNcG63p/L33XYsxdhuk7yxFor
	iG2Hi6U77b2VmmqBZxr7IA8UWgeA=
X-Google-Smtp-Source: AGHT+IFrYJgaUEoDF37kzThEOCDSDz7DI++4iPs7jdXns92jmc/m9As+MoMM86eQvhv6hQxla08K+1jhJkFpmf/mwdw=
X-Received: by 2002:a05:6214:419c:b0:6ad:7e45:c3b6 with SMTP id
 6a1803df08f44-6b059bb8abfmr28009386d6.18.1717768949683; Fri, 07 Jun 2024
 07:02:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240607070157.33828-1-laoar.shao@gmail.com> <alpine.LSU.2.21.2406071425530.29080@pobox.suse.cz>
In-Reply-To: <alpine.LSU.2.21.2406071425530.29080@pobox.suse.cz>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 7 Jun 2024 22:01:53 +0800
Message-ID: <CALOAHbBYYKmxUEDbMDhrEn8Ts4_b0gTQh5az5CwLRhQ7V3zKRA@mail.gmail.com>
Subject: Re: [PATCH] livepatch: Add a new sysfs interface replace
To: Miroslav Benes <mbenes@suse.cz>
Cc: jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 8:33=E2=80=AFPM Miroslav Benes <mbenes@suse.cz> wrot=
e:
>
> Hi,
>
> I think the subject should be something like
>
> "livepatch: Add "replace" sysfs attribute"

agreed.

>
> or use a different way to stress "replace" is the name.
>
> On Fri, 7 Jun 2024, Yafang Shao wrote:
>
> > When building a livepatch, a user can set it to be either an atomic-rep=
lace
> > livepatch or a non-atomic-replace livepatch.
>
> I am not a native speaker but I would drop '-' everywhere in this context=
.

agreed. I'm not a native speaker either :)

>
> > However, it is not easy to
> > identify whether a livepatch is atomic-replace or not until it actually
> > replaces some old livepatches.
>
> Ok.
>
> > This can lead to mistakes in a mixed
> > atomic-replace and non-atomic-replace environment, especially when
> > transitioning all livepatches from non-atomic-replace to atomic-replace=
 in
> > a large fleet of servers.
>
> Out of curiosity, could you describe your setup in more detail here? It i=
s
> interesting to mix different type of livepatches so I would like to learn
> more.

It seems I didn't describe it clearly. We are transitioning non atomic
replace livepatches to atomic replace livepatches, which will take
some time to complete in a large fleet of servers. In other words,
some servers are still running non atomic replace livepatches while
others are running atomic replace livepatches. As a result, the
sysadmins have complained that they can't find a way to identify
whether a livepatch is an atomic replace or not. It will be beneficial
to show it directly.

>
> > To address this issue, a new sysfs interface called 'replace' is introd=
uced
> > in this patch. The result after this change is as follows:
> >
> >   $ cat /sys/kernel/livepatch/livepatch-non_replace/replace
> >   0
> >
> >   $ cat /sys/kernel/livepatch/livepatch-replace/replace
> >   1
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  Documentation/ABI/testing/sysfs-kernel-livepatch |  8 ++++++++
> >  kernel/livepatch/core.c                          | 12 ++++++++++++
> >  2 files changed, 20 insertions(+)
> >
> > diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documen=
tation/ABI/testing/sysfs-kernel-livepatch
> > index a5df9b4910dc..3735d868013d 100644
> > --- a/Documentation/ABI/testing/sysfs-kernel-livepatch
> > +++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
> > @@ -47,6 +47,14 @@ Description:
> >               disabled when the feature is used. See
> >               Documentation/livepatch/livepatch.rst for more informatio=
n.
> >
> > +What:                /sys/kernel/livepatch/<patch>/replace
> > +Date:                Jun 2024
> > +KernelVersion:       6.11.0
> > +Contact:     live-patching@vger.kernel.org
> > +Description:
> > +             An attribute which indicates whether the patch supports
> > +             atomic-replace.
> > +
> >  What:                /sys/kernel/livepatch/<patch>/<object>
> >  Date:                Nov 2014
> >  KernelVersion:       3.19.0
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index 52426665eecc..0e9832f146f1 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -346,6 +346,7 @@ int klp_apply_section_relocs(struct module *pmod, E=
lf_Shdr *sechdrs,
> >   * /sys/kernel/livepatch/<patch>/enabled
> >   * /sys/kernel/livepatch/<patch>/transition
> >   * /sys/kernel/livepatch/<patch>/force
> > + * /sys/kernel/livepatch/<patch>/replace
> >   * /sys/kernel/livepatch/<patch>/<object>
> >   * /sys/kernel/livepatch/<patch>/<object>/patched
> >   * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
> > @@ -443,13 +444,24 @@ static ssize_t force_store(struct kobject *kobj, =
struct kobj_attribute *attr,
> >       return count;
> >  }
> >
> > +static ssize_t replace_show(struct kobject *kobj,
> > +                         struct kobj_attribute *attr, char *buf)
> > +{
> > +     struct klp_patch *patch;
> > +
> > +     patch =3D container_of(kobj, struct klp_patch, kobj);
> > +     return snprintf(buf, PAGE_SIZE-1, "%d\n", patch->replace);
>
> It might be better to use sysfs_emit() here. See patched_show() in the
> same file. There are still snprintf() occurrences and it might be a
> separate cleanup patch if you are interested.

I will do it. Thanks for your suggestion.

--=20
Regards
Yafang

