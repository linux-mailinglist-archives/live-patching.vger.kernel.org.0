Return-Path: <live-patching+bounces-339-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FFEE9005DF
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 16:04:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24A45287E48
	for <lists+live-patching@lfdr.de>; Fri,  7 Jun 2024 14:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A42E193099;
	Fri,  7 Jun 2024 14:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XzoYAm8e"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8C1194AD1
	for <live-patching@vger.kernel.org>; Fri,  7 Jun 2024 14:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717769047; cv=none; b=CbnL2rxoi9ElSZk6TWfswZyyyd864G8+wfM8U6Xln9595Oy2qIlFxSddEF8TAHtARaERwlmr84nS+69dbt3ST7v9zrAoa85W04GnMLnHKbVpTngOWVHvEhTVMQUzHhTOwex4yjXgOE7UOHvYgi8Ph/DEPdNX1FKuyjh3GlpXGqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717769047; c=relaxed/simple;
	bh=3HmabiF3mx+uPBtbfEtrzoNyhmgTa8X8/icAaUkBSaw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uy7FCt7Ke61KMImyP6BmoxrLAZVvCw3fpq63Bk8+/yae/B/6joE0RY3znJNsXRHvQw5JEDonPeKkY2Uh2XnthmNz0GnRPuHlljHSONNcF231S4mWoHAdy8a4/zm953+2pYskRjw9vWsVBNPPeVm2KTwnWJHU4y8QlEoW/+VCj1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XzoYAm8e; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6afbadc33e8so11460486d6.0
        for <live-patching@vger.kernel.org>; Fri, 07 Jun 2024 07:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717769044; x=1718373844; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EvBnSp6mM1zKpQgn5neE/WHUQMWhgRLrcZxYPB1lsS8=;
        b=XzoYAm8eTTQUJNs+D8u8z3qvk0g9UZC/nXriG+f8OviTRL8EjB9ToZjWf/HKpfUQqH
         LKz6lgRm5q5upYfaRDjbQ9PQ1ZrBNhAHSqNhBJ+vrZxob6u3MEDPXfpzJREyK80rxIT0
         D59ZVBHEwSpwR/IqeIy4juGYi4+S39NfV76d3YL2bHZkuve85dy2FtpwwYWvzq/Z2aAE
         MW0t3DB0oiWnNjtAIA7gYev4SwXgxNqgWdJDg2msP6HAkmiW4Dn/ts6oZ0ilDTomKdL4
         sxsYXfPnNC/dqAtSd1YpTQUMhGx8jfJHmRQYwTmZSQJNGt7JlejgaeQE6Zx3mdNOK2d0
         ljFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717769044; x=1718373844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EvBnSp6mM1zKpQgn5neE/WHUQMWhgRLrcZxYPB1lsS8=;
        b=CmvQ12y+eHxziYLfdPwcBSJbBO3s8Zy1lmLsCX4T5oFHj35kVoSg3F5eKxSq2X5IAW
         b1TivhHANTxU+tThJrdbgz7oPtCmKd/Z6otxhvuRTYZS7gYMYBA/5YAl5kQsEyMJsyjC
         03Gem3xXpCXHeypGpySeM2aTqMda+756O8jYk6AeSiXWDqj3DEQSWBiPDvkRs1Dbeevh
         r1Hqdz6HyaJpwsvv8QgMATEpkXgrEdOd5jjuvNMjIu2/Rv+n/DMl73LqAcQTr7ApWw+f
         DXjtjYgvxMlADbegbUD26041pHWwcCn5hOaRJk9Hn4VoPq7jfkQtIBgIjCXQPSBZr11B
         Ms+g==
X-Forwarded-Encrypted: i=1; AJvYcCVwRvtDB5cHocZrPn8lBbgOKVuB+nYeMewU14IMaoNvMqQ8LOuQRW/avjjX7MvP9M5p2oQFqQyB6OeZDu1tDaOA0uYI+ZvTp8iIuy1Nug==
X-Gm-Message-State: AOJu0Yy72i/YU0op97fO7SaOCrPIfRtGkbqmuYPfcz9iX3S2F7n1DtWh
	xRHDVELUPXt9kK2gygr8sMcv/fQYliLqj2TgLAsxe3a9RBJBio+HDaO0RZUyvVi6ODHf0r06Dps
	aAhrWBen7S0KfGf6OM/6uL3tup28=
X-Google-Smtp-Source: AGHT+IEsawNyC8q2OPWmqowChM8mSjL+1CviiwDoUUp4nElUGNPzXvrfC/RIKwxZ74tv/mClWdygB4Ua97/rO3BKcLs=
X-Received: by 2002:a0c:f6c2:0:b0:6b0:62c2:52e6 with SMTP id
 6a1803df08f44-6b062c2548dmr11156386d6.13.1717769044260; Fri, 07 Jun 2024
 07:04:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240607070157.33828-1-laoar.shao@gmail.com> <alpine.LSU.2.21.2406071425530.29080@pobox.suse.cz>
 <1601fed223252c8d0e26389bfa738238d0fd5ac7.camel@suse.com>
In-Reply-To: <1601fed223252c8d0e26389bfa738238d0fd5ac7.camel@suse.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Fri, 7 Jun 2024 22:03:27 +0800
Message-ID: <CALOAHbCYDV5pMuY1QW6ByBTWg5F86q=JWAbh_fMHwHkhphAYtw@mail.gmail.com>
Subject: Re: [PATCH] livepatch: Add a new sysfs interface replace
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Miroslav Benes <mbenes@suse.cz>, jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
	joe.lawrence@redhat.com, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 7, 2024 at 8:59=E2=80=AFPM Marcos Paulo de Souza <mpdesouza@sus=
e.com> wrote:
>
> On Fri, 2024-06-07 at 14:33 +0200, Miroslav Benes wrote:
> > Hi,
> >
> > I think the subject should be something like
> >
> > "livepatch: Add "replace" sysfs attribute"
> >
> > or use a different way to stress "replace" is the name.
> >
> > On Fri, 7 Jun 2024, Yafang Shao wrote:
> >
> > > When building a livepatch, a user can set it to be either an
> > > atomic-replace
> > > livepatch or a non-atomic-replace livepatch.
> >
> > I am not a native speaker but I would drop '-' everywhere in this
> > context.
> >
> > > However, it is not easy to
> > > identify whether a livepatch is atomic-replace or not until it
> > > actually
> > > replaces some old livepatches.
> >
> > Ok.
> >
> > > This can lead to mistakes in a mixed
> > > atomic-replace and non-atomic-replace environment, especially when
> > > transitioning all livepatches from non-atomic-replace to atomic-
> > > replace in
> > > a large fleet of servers.
> >
> > Out of curiosity, could you describe your setup in more detail here?
> > It is
> > interesting to mix different type of livepatches so I would like to
> > learn
> > more.
> >
> > > To address this issue, a new sysfs interface called 'replace' is
> > > introduced
> > > in this patch. The result after this change is as follows:
> > >
> > >   $ cat /sys/kernel/livepatch/livepatch-non_replace/replace
> > >   0
> > >
> > >   $ cat /sys/kernel/livepatch/livepatch-replace/replace
> > >   1
> > >
> > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > ---
> > >  Documentation/ABI/testing/sysfs-kernel-livepatch |  8 ++++++++
> > >  kernel/livepatch/core.c                          | 12 ++++++++++++
> > >  2 files changed, 20 insertions(+)
> > >
> > > diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch
> > > b/Documentation/ABI/testing/sysfs-kernel-livepatch
> > > index a5df9b4910dc..3735d868013d 100644
> > > --- a/Documentation/ABI/testing/sysfs-kernel-livepatch
> > > +++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
> > > @@ -47,6 +47,14 @@ Description:
> > >             disabled when the feature is used. See
> > >             Documentation/livepatch/livepatch.rst for more
> > > information.
> > >
> > > +What:              /sys/kernel/livepatch/<patch>/replace
> > > +Date:              Jun 2024
> > > +KernelVersion:     6.11.0
> > > +Contact:   live-patching@vger.kernel.org
> > > +Description:
> > > +           An attribute which indicates whether the patch
> > > supports
> > > +           atomic-replace.
> > > +
> > >  What:              /sys/kernel/livepatch/<patch>/<object>
> > >  Date:              Nov 2014
> > >  KernelVersion:     3.19.0
> > > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > > index 52426665eecc..0e9832f146f1 100644
> > > --- a/kernel/livepatch/core.c
> > > +++ b/kernel/livepatch/core.c
> > > @@ -346,6 +346,7 @@ int klp_apply_section_relocs(struct module
> > > *pmod, Elf_Shdr *sechdrs,
> > >   * /sys/kernel/livepatch/<patch>/enabled
> > >   * /sys/kernel/livepatch/<patch>/transition
> > >   * /sys/kernel/livepatch/<patch>/force
> > > + * /sys/kernel/livepatch/<patch>/replace
> > >   * /sys/kernel/livepatch/<patch>/<object>
> > >   * /sys/kernel/livepatch/<patch>/<object>/patched
> > >   * /sys/kernel/livepatch/<patch>/<object>/<function,sympos>
> > > @@ -443,13 +444,24 @@ static ssize_t force_store(struct kobject
> > > *kobj, struct kobj_attribute *attr,
> > >     return count;
> > >  }
> > >
> > > +static ssize_t replace_show(struct kobject *kobj,
> > > +                       struct kobj_attribute *attr, char
> > > *buf)
> > > +{
> > > +   struct klp_patch *patch;
> > > +
> > > +   patch =3D container_of(kobj, struct klp_patch, kobj);
> > > +   return snprintf(buf, PAGE_SIZE-1, "%d\n", patch->replace);
> >
> > It might be better to use sysfs_emit() here. See patched_show() in
> > the
> > same file. There are still snprintf() occurrences and it might be a
> > separate cleanup patch if you are interested.
>
> Hi Yafang, thanks for the patch!
>
> Besides Miroslav's comments, I think that a new kselftest exercising
> this attribute would be good, since we have tests for other attributes
> as well.

I will add it. Thanks for your suggestion.

--=20
Regards
Yafang

