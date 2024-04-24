Return-Path: <live-patching+bounces-228-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3C0B8B08F4
	for <lists+live-patching@lfdr.de>; Wed, 24 Apr 2024 14:09:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0364C1C221A0
	for <lists+live-patching@lfdr.de>; Wed, 24 Apr 2024 12:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FEE515ADA0;
	Wed, 24 Apr 2024 12:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S8D4A0Q2"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A1615A4B0;
	Wed, 24 Apr 2024 12:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713960584; cv=none; b=iKJATSnJ+ydUZxLA6VVi/dSS/FC27Wno186XB5xGVfCsOVqFIKNCc1MEvv2o0BF1OAUxASwuEerqcChtD6eUoqqn9/hVEHdah8YdOZhSSEFrnfYjpFpQeS+SNYHElFJNGxH+qD7sRScstXJZB41V64T5RPh9rBawaa/U51Z2CxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713960584; c=relaxed/simple;
	bh=IYr2ymtDnzRjoGBlAt7i6ZTSzxn7Op1cEuDB7evFyO4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E9BSN3xna3b15j+rGA178F6ePFKzO9AAvEEFVKUgZ8MAVsNbhvMc87b7c8Wq+6zZiZOdAAYFMG4L+QVYCBPdPFNTW65+QHf9J5EFqXT3FBgUdAuP4Thev/dyA4DGv1W68k2MafUlmQeIIJs7mJJD7gSIEcdG0qFjam6tOn1guwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S8D4A0Q2; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6a077a861e7so26610776d6.2;
        Wed, 24 Apr 2024 05:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713960582; x=1714565382; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RoTyunRbk6WKbcDZzKg0fChldKgzN8TCsYu19OLDZgw=;
        b=S8D4A0Q2j8m24hWY/16EZvlJft8Hvw//xlguWdP4QQ26AjGUeYnjs1bNCTQWodg917
         7B39TbcXRl50HarsqMUkX7epGZVciXnyPkAsyC3stwCDZ1FcCekJX0bdtDNchf9pvpWe
         qjF932Zw/vzEQTX5bScI6uZixKBeq64FZyjXguQaQ5IQrmKfT0fJ0Jr3/N/0aS9oZjE4
         gDAm1yAsakd2jtFVH4NmaXdh+Opi4WqHGAF3OudHG9PVU7PTVjY5CydRaLqhyNs9Zg3k
         VqR0qZZI9RX1gqRg5nmB79a9OaUzd7x+zAKI4xAOp0ExyCPQYVNnYmggNQi3Pqml0cgx
         ZPAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713960582; x=1714565382;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RoTyunRbk6WKbcDZzKg0fChldKgzN8TCsYu19OLDZgw=;
        b=qUvNGiYVmvNStrbhxFH0+0eIC18rHSbUn3dBGjW+AJGMSUNxij/vAgyzw/VxzX/tgE
         a84FE3Xrq3ZYyKt5jcabXHUIhEnO4n/dF2ef3KYPXVex12LPoBREtpYHx/a/nM9ml8/R
         EXXxHPmypxEq8fMMbVd7EBnPug5DtaaTSzPKNIEPkGVMNQRuiwuZ0Zn8rXsdH0GXX+XT
         2JzWei3LJ29u/1pyWVQzeCMChkub8pVKfLOVxHidM6vFDyGPznuJ99mXy0Kcx6WRrXq/
         33ovm+tfRx6Dv9jaSzfV9VN5omZPO7TA+vpC6VCTweO+B7BsM3QMZ0MoTgL7LTKqkEDE
         s5wQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLTKReK8213hKMtChN038csDD4YGG2B5NFkJV5lSlcc0azFiWd2Vlz8Rf9WBdfItlvblTYnNSgqrSxyeB/d7/F3PX2HSW3YAyGh6cJtA==
X-Gm-Message-State: AOJu0Yz7vNcpIRQ4uavGlo6p+0xHo7pqq4G5wq4QGBSwR9kZGR6LmaaM
	nYQUbfC1ZVSggK570/nVAZIW9SnJdPQH6b2kmDWTBp689mZeV3a+0Xud/LBFtFMnnVN8kUcyS+V
	VkxwXluezZ5aTQ0Wo+XT+j1AVlag=
X-Google-Smtp-Source: AGHT+IG6P5IOtP/IBR7tUT+Vmq3PxHxW08YKGSM7hoe5r+LPonprmr+xHcBxyNJLNSssJggvIKz0eFcT8E4l8guGNsA=
X-Received: by 2002:a0c:e149:0:b0:6a0:8c9a:c74b with SMTP id
 c9-20020a0ce149000000b006a08c9ac74bmr2282787qvl.28.1713960581636; Wed, 24 Apr
 2024 05:09:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240407035730.20282-1-laoar.shao@gmail.com> <20240407035730.20282-2-laoar.shao@gmail.com>
In-Reply-To: <20240407035730.20282-2-laoar.shao@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 24 Apr 2024 20:09:05 +0800
Message-ID: <CALOAHbDGcY5y6hWZgJp9ELrt_w4pfB-X3EqS3yu8k37pj3ZEcw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] module: Add a new helper delete_module()
To: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, 
	joe.lawrence@redhat.com, mcgrof@kernel.org, 
	Greg KH <gregkh@linuxfoundation.org>
Cc: live-patching@vger.kernel.org, linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 7, 2024 at 11:58=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com> =
wrote:
>
> Introduce a new helper function, delete_module(), designed to delete kern=
el
> modules from locations outside of the `kernel/module` directory.
>
> No functional change.
>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  include/linux/module.h |  1 +
>  kernel/module/main.c   | 82 ++++++++++++++++++++++++++++++++----------
>  2 files changed, 65 insertions(+), 18 deletions(-)
>
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 1153b0d99a80..c24557f1b795 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -75,6 +75,7 @@ extern struct module_attribute module_uevent;
>  /* These are either module local, or the kernel's dummy ones. */
>  extern int init_module(void);
>  extern void cleanup_module(void);
> +extern int delete_module(struct module *mod);
>
>  #ifndef MODULE
>  /**
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index e1e8a7a9d6c1..3b48ee66db41 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -695,12 +695,74 @@ EXPORT_SYMBOL(module_refcount);
>  /* This exists whether we can unload or not */
>  static void free_module(struct module *mod);
>
> +static void __delete_module(struct module *mod)
> +{
> +       char buf[MODULE_FLAGS_BUF_SIZE];
> +
> +       WARN_ON_ONCE(mod->state !=3D MODULE_STATE_GOING);
> +
> +       /* Final destruction now no one is using it. */
> +       if (mod->exit !=3D NULL)
> +               mod->exit();
> +       blocking_notifier_call_chain(&module_notify_list,
> +                                    MODULE_STATE_GOING, mod);
> +       klp_module_going(mod);
> +       ftrace_release_mod(mod);
> +
> +       async_synchronize_full();
> +
> +       /* Store the name and taints of the last unloaded module for diag=
nostic purposes */
> +       strscpy(last_unloaded_module.name, mod->name, sizeof(last_unloade=
d_module.name));
> +       strscpy(last_unloaded_module.taints, module_flags(mod, buf, false=
),
> +               sizeof(last_unloaded_module.taints));
> +
> +       free_module(mod);
> +       /* someone could wait for the module in add_unformed_module() */
> +       wake_up_all(&module_wq);
> +}
> +
> +int delete_module(struct module *mod)
> +{
> +       int ret;
> +
> +       mutex_lock(&module_mutex);
> +       if (!list_empty(&mod->source_list)) {
> +               /* Other modules depend on us: get rid of them first. */
> +               ret =3D -EWOULDBLOCK;
> +               goto out;
> +       }
> +
> +       /* Doing init or already dying? */
> +       if (mod->state !=3D MODULE_STATE_LIVE) {
> +               ret =3D -EBUSY;
> +               goto out;
> +       }
> +
> +       /* If it has an init func, it must have an exit func to unload */
> +       if (mod->init && !mod->exit) {
> +               ret =3D -EBUSY;
> +               goto out;
> +       }
> +
> +       if (try_release_module_ref(mod) !=3D 0) {
> +               ret =3D -EWOULDBLOCK;
> +               goto out;
> +       }
> +       mod->state =3D MODULE_STATE_GOING;
> +       mutex_unlock(&module_mutex);
> +       __delete_module(mod);
> +       return 0;
> +
> +out:
> +       mutex_unlock(&module_mutex);
> +       return ret;
> +}
> +
>  SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>                 unsigned int, flags)
>  {
>         struct module *mod;
>         char name[MODULE_NAME_LEN];
> -       char buf[MODULE_FLAGS_BUF_SIZE];
>         int ret, forced =3D 0;
>
>         if (!capable(CAP_SYS_MODULE) || modules_disabled)
> @@ -750,23 +812,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, =
name_user,
>                 goto out;
>
>         mutex_unlock(&module_mutex);
> -       /* Final destruction now no one is using it. */
> -       if (mod->exit !=3D NULL)
> -               mod->exit();
> -       blocking_notifier_call_chain(&module_notify_list,
> -                                    MODULE_STATE_GOING, mod);
> -       klp_module_going(mod);
> -       ftrace_release_mod(mod);
> -
> -       async_synchronize_full();
> -
> -       /* Store the name and taints of the last unloaded module for diag=
nostic purposes */
> -       strscpy(last_unloaded_module.name, mod->name, sizeof(last_unloade=
d_module.name));
> -       strscpy(last_unloaded_module.taints, module_flags(mod, buf, false=
), sizeof(last_unloaded_module.taints));
> -
> -       free_module(mod);
> -       /* someone could wait for the module in add_unformed_module() */
> -       wake_up_all(&module_wq);
> +       __delete_module(mod);
>         return 0;
>  out:
>         mutex_unlock(&module_mutex);
> --
> 2.39.1
>

Luis, Greg,

Since the last version, there hasn't been any response. Would you mind
taking a moment to review it and provide your feedback on the
kernel/module changes?

--=20
Regards
Yafang

