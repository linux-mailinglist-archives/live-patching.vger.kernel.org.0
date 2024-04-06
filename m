Return-Path: <live-patching+bounces-221-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D73F689AB00
	for <lists+live-patching@lfdr.de>; Sat,  6 Apr 2024 15:03:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AB8F1F22171
	for <lists+live-patching@lfdr.de>; Sat,  6 Apr 2024 13:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98CA52E645;
	Sat,  6 Apr 2024 13:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PTjDup7d"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EA6374DD;
	Sat,  6 Apr 2024 13:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712408593; cv=none; b=npNAC5nrYZmaAXnBnpdULYL4tgYD44rLlNN2HbqpXe1PtFMBsNZ6No6QCr0d/RbRyOR/RYgTXHK46I5M98b5Wvjd8SQC6pUKoHanW/dkxZ0k0bEbUlx8LE+9PPA9zEC9u0N2hf8MLAq2mVHHrrnWpCzmbehxMlrdt4u3miXZBKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712408593; c=relaxed/simple;
	bh=Yi27qjSRe7yAR5cujUOXcvyqPxnVGwsQV25G6wUopMg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CrMy8GtO+jyaeZsxiEYqiWzpiWlDUXoyzARQb63Xjz+F44NQBTqnZHm5nC3Da3/GhtRR+Ch2gdOR3R8M5jhn1BrmNTqpHe973RgWK4qPaMGD3SxbbrVeekKn6r2THaz8LHBhRAejXgLsK6kmvfD7NugmDAPOrWQWZUumkDwTTv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PTjDup7d; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-699308ac84aso15851216d6.0;
        Sat, 06 Apr 2024 06:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712408591; x=1713013391; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F0GoR+fJPolzGDlfcKIMwad3Z/lnfaK9+3L9wKS/1RI=;
        b=PTjDup7dPZekiAkJZYhLAWyPNiQa52tdBMH42OSgHG505DvY6p+aK6YUPcaIzYUCuI
         nCBC6bEznv03AOeQiSIYMVvPFiXyS3MQeJvRF1hdnAtZt7cZvUVHovWes5zq+i0NVPk8
         Tfh4AJY0Qt1MpfEpJMxS4Ba4hzU1n5hzke7Ehlu3X2ZUeBbtOH6VWXD2IoJimKnDiVqC
         SUej0ucmjHn6nfNmiIeXp3PyIsZpF2stZcx3K7seyOlv+tV1wLN3q9hJDh0EGZXMV5TJ
         CU0Y8UvKPmUIrNMFOkxrnJ5bbZpG9Za5RTAEWEo1Q9Bo79zaY5YjNeyERnk0C6XBo++6
         5GJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712408591; x=1713013391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F0GoR+fJPolzGDlfcKIMwad3Z/lnfaK9+3L9wKS/1RI=;
        b=ehRdjYOV1pPJFEpxFTyu/wIj5RTbeOO79/TBl1pp8yw/vPaT0GRo5ukWzzL0VPXBnC
         nrjkoeGfCteHqHTV3cPskLQdVSNh4o46DQ6Io+ZsHFTdYsn1/biehM/5eHeItCbUKvH5
         Xs359ei2lnBcTLmz8nZiEefNmgJxFmai7oVZsJn3D3Q04henmUySX3HDYt7hz5HkEE++
         d7F8k3880Tw/sKbsv8qxcR3T2lkpSP3iDDu42PPwqhEHNwZrkspzpuS21uBDpoX8yCAm
         I6N79rcqIEv2l4MsPMxr4uS+aPDZO5usS3T7bZdXieGTmfBY4hd6D5mrJ2E8VEq7wI6y
         3kZQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyhnuH1ti3KXmNkfsiti8VBd1PJlWmUvbKCyNapQN+tnmdTLwTrwo/p96f8nrP1lGDg2+lM3IFgM3c1CFHB23rgbLeybcvPXiZiLR/qauLI3w3jmqxqYbT7yaT8plTvJ3x5todUUNUfW/uTiM=
X-Gm-Message-State: AOJu0YxyZu7z1Hi7lP7qtQO0CizD9N/NemReVAiVWe0IASMRoBhh4ZEm
	X1DoNKCUtXaJ25U855AVJBg2BVIbF5OTuf+gAYlNXNKo4sKze3R80r4JpiKcTulkiHNHzNvwcsY
	NjtbPad5piXCFsaPHsyPPbk0R6stUT9OeXs4=
X-Google-Smtp-Source: AGHT+IEIwQ0pIfl+WI3h6qfp5/VmRydQEOBLutsR+yPsSRzDYGHcHPyxZ/bXmGCs3xUViIjvz2eiuMv3U6HO4HJ9ScE=
X-Received: by 2002:a05:6214:c27:b0:696:752a:fa96 with SMTP id
 a7-20020a0562140c2700b00696752afa96mr4820273qvd.16.1712408590830; Sat, 06 Apr
 2024 06:03:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240331133839.18316-1-laoar.shao@gmail.com> <Zg6zWLuYHotLSSLT@alley>
In-Reply-To: <Zg6zWLuYHotLSSLT@alley>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sat, 6 Apr 2024 21:02:34 +0800
Message-ID: <CALOAHbBoHek6snRn9d-fw8HrP8W5LAZkYn3hK+yP5YTecY2zxQ@mail.gmail.com>
Subject: Re: [PATCH] livepatch: Delete the associated module when replacing an
 old livepatch
To: Petr Mladek <pmladek@suse.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	joe.lawrence@redhat.com, mcgrof@kernel.org, live-patching@vger.kernel.org, 
	linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 4, 2024 at 10:04=E2=80=AFPM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Sun 2024-03-31 21:38:39, Yafang Shao wrote:
> > Enhance the functionality of kpatch to automatically remove the associa=
ted
> > module when replacing an old livepatch with a new one. This ensures tha=
t no
> > leftover modules remain in the system. For instance:
>
> I like this feature. I would suggest to split it into two parts:
>
>   + 1st patch would implement the delete_module() API. It must be safe
>     even for other potential in-kernel callers. And it must be
>     acceptable for the module loader code maintainers.
>
>   + 2nd patch() using the API in the livepatch code.
>     We will need to make sure that the new delete_module()
>     API is used correctly from the livepatching code side.
>
> The 2nd patch should also fix the selftests.

Thanks for your suggestion. I will do it.

>
>
> > - Load the first livepatch
> >   $ kpatch load 6.9.0-rc1+/livepatch-test_0.ko
> >   loading patch module: 6.9.0-rc1+/livepatch-test_0.ko
> >   waiting (up to 15 seconds) for patch transition to complete...
> >   transition complete (2 seconds)
> >
> >   $ kpatch list
> >   Loaded patch modules:
> >   livepatch_test_0 [enabled]
> >
> >   $ lsmod |grep livepatch
> >   livepatch_test_0       16384  1
> >
> > - Load a new livepatch
> >   $ kpatch load 6.9.0-rc1+/livepatch-test_1.ko
> >   loading patch module: 6.9.0-rc1+/livepatch-test_1.ko
> >   waiting (up to 15 seconds) for patch transition to complete...
> >   transition complete (2 seconds)
> >
> >   $ kpatch list
> >   Loaded patch modules:
> >   livepatch_test_1 [enabled]
> >
> >   $ lsmod |grep livepatch
> >   livepatch_test_1       16384  1
> >   livepatch_test_0       16384  0   <<<< leftover
> >
> > With this improvement, executing
> > `kpatch load 6.9.0-rc1+/livepatch-test_1.ko` will automatically remove =
the
> > livepatch-test_0.ko module.
>
> As already mentioned by Joe, please replace "kpatch" with
> the related "modprobe" and "echo 0 >/sys/kernel/livepatch/<name>/enable"
> calls.
>
> "kpatch" is a 3rd party tool and only few people know what it does
> internally. The kernel commit message is there for current and future
> kernel developers. They should be able to understand the behavior
> even without digging details about "random" user-space tools.

will do it.

>
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -721,8 +723,13 @@ static void klp_free_patch_finish(struct klp_patch=
 *patch)
> >       wait_for_completion(&patch->finish);
> >
> >       /* Put the module after the last access to struct klp_patch. */
> > -     if (!patch->forced)
> > -             module_put(patch->mod);
> > +     if (!patch->forced)  {
> > +             module_put(mod);
> > +             if (module_refcount(mod))
> > +                     return;
> > +             mod->state =3D MODULE_STATE_GOING;
>
> mod->state should be modified only by the code in kernel/module/.
> It helps to keep the operation safe (under control of module
> loader code maintainers).
>
> The fact that this patch does the above without module_mutex is
> a nice example of possible mistakes.
>
> And there are more problems, see below.
>
> > +             delete_module(mod);
>
> klp_free_patch_finish() is called also from the error path
> in klp_enable_patch(). We must not remove the module
> in this case. do_init_module() will do the clean up
> the right way.

Thanks for pointing it out. will fix it.

>
> > +     }
> >  }
> >
> >  /*
> > diff --git a/kernel/module/main.c b/kernel/module/main.c
> > index e1e8a7a9d6c1..e863e1f87dfd 100644
> > --- a/kernel/module/main.c
> > +++ b/kernel/module/main.c
> > @@ -695,12 +695,35 @@ EXPORT_SYMBOL(module_refcount);
> >  /* This exists whether we can unload or not */
> >  static void free_module(struct module *mod);
> >
> > +void delete_module(struct module *mod)
> > +{
> > +     char buf[MODULE_FLAGS_BUF_SIZE];
> > +
>
> If we export this API via include/linux/module.h then
> it could be used anywhere in the kernel. Therefore we need
> to make it safe.
>
> This function should do the same actions as the syscall
> starting from:
>
>         mutex_lock(&module_mutex);
>
>         if (!list_empty(&mod->source_list)) {
>                 /* Other modules depend on us: get rid of them first. */
>                 ret =3D -EWOULDBLOCK;
>                 goto out;
>         }
> ...

good suggestion. will do it.


--=20
Regards
Yafang

