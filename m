Return-Path: <live-patching+bounces-208-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DC100894982
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 04:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42BEAB24307
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 02:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5419B1118D;
	Tue,  2 Apr 2024 02:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UOeE0U78"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFFE10A12;
	Tue,  2 Apr 2024 02:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712025945; cv=none; b=KVUeHICaEzKEuJM7Mnwe/QHpauNGUDS42dvkcEsfztMbhoLAfTrsrMIRF4l5dA1XRJnurdnp/qm/Y4arZBcvkwHtjJPMNJwe+hHJOCGihhwvLxG6nQtaizVe4w8Jga2PnWqRdY7zjkGEZvGY4FyXFW96R08crhRmEzhE30D19c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712025945; c=relaxed/simple;
	bh=utef0wIwxKKmQV0/ECzjceZ1kYPuMh4RK+qsubsjaoQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eUA+r2/TTrpdFJDZrLqIRw5pBV8n2u8wu9Iyl8srYvknEGbbU7IWcV7GHq+S5F5PcQrve3f7JSlx25aFXyA1Zup0ZQa7X9yTJ3a6hL6NOyqoRMUGX5101wv+qJ8dmR8x9NNCuv8zJwGmRzImy9bRgg4Nwnx293zUXhdrPBNLp6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UOeE0U78; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6964b1c529cso38532336d6.0;
        Mon, 01 Apr 2024 19:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712025942; x=1712630742; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RLFlcAC24Bkon2RX9e1oH2m2rJ8Jqv2dbz6+6+rguRo=;
        b=UOeE0U78XHjqkqf90WHGALzaJFTQAkwBgKtE/MsZ+hPpO+T0SaFTn4cGLDPmDhmhL6
         z4lxaS7DX2kvZz95fdu7QynZmi7W4yoAlk6DYieHaDdYbuqcYUcR6RRN1XlzOun+CHZA
         RGuJgBl4LBWrztGXrjz+sFv3YY0Ay7IaXTG5yxe0BADPXGqzUb4/t5jm9zhZ5Uv+ZNk6
         9pjDWdDyDNMNR0h4uDCE9YUQR/nFe2bN6uCBgGqJpfJoJ6hjX9x0AFEoRP/7ITCZo4Fr
         viWCgtEwDJyiFU39GG/55WWzOXBkcORJkVM8d6JhoPwr7rimttW4qBrkOjmD9e6xQyKA
         Qqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712025942; x=1712630742;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RLFlcAC24Bkon2RX9e1oH2m2rJ8Jqv2dbz6+6+rguRo=;
        b=Mn6KR/LrukaOg7WpHhiJKgI6KyniCyl2VReN5HPTfo26N/yxgtJXJtPxune52RX3b+
         q/enIe1dGkKjqEEUGX4HJTCCfCKH3AIffVw79iYacvYIGUkctLE0oq7Q9iPl3Y383HDZ
         AXnwVtmANuBwPYhc7XK32740Ac+cKGiECTy+88etepvd9l8H3J4+Gbq9po0tuGGlZH3N
         64w20KUeOlcyUG54OEQxJtpcIjD81SlaAm+lU5ePr9RKJVwVrr7nLs8XW9B7YFOUP1rD
         /WV9ZL4DrVyx12aKjsffX8bKqDELOaL8UjLZVTC5dC54rzombE5HNI/BaJOb3HhCNK9t
         Lm7g==
X-Forwarded-Encrypted: i=1; AJvYcCWAynZOZ/IZm0UGXHVPn4q6n4VJlDLC+jboN2LOH6P0xD9oLwda7+7ffIK7k1t9N0sX0SwikqMYkDopnpQhEoSbnveuy0AQXc2d4kDsFldqMpJvTxUsawtsAhGXMLz59rryGsNTcUFGUtm5VJc=
X-Gm-Message-State: AOJu0YyjTrXUjDMM9FtxwvaqriASu+7lXpG6uPlNi9kDFkgxbPEiRk6P
	SkfV9G/YT1xxj2ByID+WdXs5WvpADR/I0q56xOcQNrBkqP+QxtdJmsUxJuMc3tmuJ08XI8E+XH+
	2d7ETCzEf3CFHlC0Dc7nvTBu9DgAslgI+/Pnw3Q==
X-Google-Smtp-Source: AGHT+IGsChu1TGN5iY942ljNeEvp44uyA1LvqnXeZEpzwKd8gbO+y98Eyn4J3QdvsPMWPI0MlVWIayViJTHLsto2CBA=
X-Received: by 2002:a0c:c591:0:b0:698:f5b6:6595 with SMTP id
 a17-20020a0cc591000000b00698f5b66595mr9671928qvj.55.1712025942338; Mon, 01
 Apr 2024 19:45:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240331133839.18316-1-laoar.shao@gmail.com> <ZgrMfYBo8TynjSKX@redhat.com>
In-Reply-To: <ZgrMfYBo8TynjSKX@redhat.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 2 Apr 2024 10:45:04 +0800
Message-ID: <CALOAHbDWiO+TbRnjxCN3j9YWD3Cz9NOg9g-xOhVqmaPmexqNoQ@mail.gmail.com>
Subject: Re: [PATCH] livepatch: Delete the associated module when replacing an
 old livepatch
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	mcgrof@kernel.org, live-patching@vger.kernel.org, 
	linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 1, 2024 at 11:02=E2=80=AFPM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
> On Sun, Mar 31, 2024 at 09:38:39PM +0800, Yafang Shao wrote:
> > Enhance the functionality of kpatch to automatically remove the associa=
ted
> > module when replacing an old livepatch with a new one. This ensures tha=
t no
> > leftover modules remain in the system. For instance:
> >
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
> >
>
> Hi Yafang,
>
> I think it would be better if the commit message reasoning used
> insmod/modprobe directly rather than the kpatch user utility wrapper.
> That would be more generic and remove any potential kpatch utility
> variants from the picture.  (For example, it is possible to add `rmmod`
> in the wrapper and then this patch would be redundant.)

Hi Joe,

I attempted to incorporate an `rmmod` operation within the kpatch
replacement process, but encountered challenges in devising a safe and
effective solution. The difficulty arises from the uncertainty
regarding which livepatch will be replaced in userspace, necessitating
the operation to be conducted within the kernel itself.


>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  include/linux/module.h  |  1 +
> >  kernel/livepatch/core.c | 11 +++++++++--
> >  kernel/module/main.c    | 43 ++++++++++++++++++++++++-----------------
> >  3 files changed, 35 insertions(+), 20 deletions(-)
> >
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index 1153b0d99a80..9a95174a919b 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -75,6 +75,7 @@ extern struct module_attribute module_uevent;
> >  /* These are either module local, or the kernel's dummy ones. */
> >  extern int init_module(void);
> >  extern void cleanup_module(void);
> > +extern void delete_module(struct module *mod);
> >
> >  #ifndef MODULE
> >  /**
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index ecbc9b6aba3a..f1edc999f3ef 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -711,6 +711,8 @@ static void klp_free_patch_start(struct klp_patch *=
patch)
> >   */
> >  static void klp_free_patch_finish(struct klp_patch *patch)
> >  {
> > +     struct module *mod =3D patch->mod;
> > +
> >       /*
> >        * Avoid deadlock with enabled_store() sysfs callback by
> >        * calling this outside klp_mutex. It is safe because
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
> > +             delete_module(mod);
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
> > +     /* Final destruction now no one is using it. */
> > +     if (mod->exit !=3D NULL)
> > +             mod->exit();
> > +     blocking_notifier_call_chain(&module_notify_list,
> > +                                  MODULE_STATE_GOING, mod);
> > +     klp_module_going(mod);
> > +     ftrace_release_mod(mod);
> > +
> > +     async_synchronize_full();
> > +
> > +     /* Store the name and taints of the last unloaded module for diag=
nostic purposes */
> > +     strscpy(last_unloaded_module.name, mod->name, sizeof(last_unloade=
d_module.name));
> > +     strscpy(last_unloaded_module.taints, module_flags(mod, buf, false=
),
> > +             sizeof(last_unloaded_module.taints));
> > +
> > +     free_module(mod);
> > +     /* someone could wait for the module in add_unformed_module() */
> > +     wake_up_all(&module_wq);
> > +}
> > +
> >  SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
> >               unsigned int, flags)
> >  {
> >       struct module *mod;
> >       char name[MODULE_NAME_LEN];
> > -     char buf[MODULE_FLAGS_BUF_SIZE];
> >       int ret, forced =3D 0;
> >
> >       if (!capable(CAP_SYS_MODULE) || modules_disabled)
> > @@ -750,23 +773,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *=
, name_user,
> >               goto out;
> >
> >       mutex_unlock(&module_mutex);
> > -     /* Final destruction now no one is using it. */
> > -     if (mod->exit !=3D NULL)
> > -             mod->exit();
> > -     blocking_notifier_call_chain(&module_notify_list,
> > -                                  MODULE_STATE_GOING, mod);
> > -     klp_module_going(mod);
> > -     ftrace_release_mod(mod);
> > -
> > -     async_synchronize_full();
> > -
> > -     /* Store the name and taints of the last unloaded module for diag=
nostic purposes */
> > -     strscpy(last_unloaded_module.name, mod->name, sizeof(last_unloade=
d_module.name));
> > -     strscpy(last_unloaded_module.taints, module_flags(mod, buf, false=
), sizeof(last_unloaded_module.taints));
> > -
> > -     free_module(mod);
> > -     /* someone could wait for the module in add_unformed_module() */
> > -     wake_up_all(&module_wq);
> > +     delete_module(mod);
> >       return 0;
> >  out:
> >       mutex_unlock(&module_mutex);
> > --
> > 2.39.1
> >
>
> It's been a while since atomic replace was added and so I forget why the
> implementation doesn't try this -- is it possible for the livepatch
> module to have additional references that this patch would force its way
> through?

In the klp_free_patch_finish() function, a check is performed on the
reference count of the livepatch module. If the reference count is not
zero, the function will skip further processing.

>
> Also, this patch will break the "atomic replace livepatch" kselftest in
> test-livepatch.sh [1].  I think it would need to drop the `unload_lp
> $MOD_LIVEPATCH` command, the following 'live patched' greps and their
> corresponding dmesg output in the test's final check_result() call.

Thanks for your information. I will check it.

--=20
Regards
Yafang

