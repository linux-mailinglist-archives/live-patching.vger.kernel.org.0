Return-Path: <live-patching+bounces-206-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E003C89491B
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 04:03:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3EFB8B22C5B
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 02:03:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEAE8D51D;
	Tue,  2 Apr 2024 02:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LAWFTAVT"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198D5BA2D;
	Tue,  2 Apr 2024 02:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712023384; cv=none; b=EddA4YdE2h7R/OLqPvxuXhflWP+jIpjNf0oEjobFq7sx+UFKbu7lUronoKt81QyXwhSNxaIgJarlN/pqPtJ0ecqCwbfj1VMd51dIevzojDSmFBwUQjuHO2Y+D7X3GixVuUrCfyRc0BXqyLKrmpUq4Nwcqo35sQfFGb54np24XLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712023384; c=relaxed/simple;
	bh=oJDokXbbRB/n2WAfiK2/EiQZiR/eNY0y1vdiczU2Q9s=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=ozsax4ZijwV87r4UJujn5A+VGtI1sYUfwkZQPCuXvwob9V32qmg4pv3OIdC26RLl0bNVDq5lJPf8wBh0dDzQuFlnT48laCT+L+bCE22h5x2LPbzvpo96GM0G3/ZdOETOYc+gAssUYkfC+19Ke9utQOleT0EAUBd7dUDTOcy3kig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LAWFTAVT; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-6ea7f2d093aso4303159b3a.3;
        Mon, 01 Apr 2024 19:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712023382; x=1712628182; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JG53/uIkSpBMtiKQrxrjUYTKftOawX6GTvLp9I5TnJI=;
        b=LAWFTAVTT5QWOo6R+FkMRyVsBjUObA2bO4WFhUvEf2b/RSvRNhZCX+tVimmWcUUR7J
         +OnqEz0s4vauGvpU3pXHMbSimLmz2ZPzORYqFaaLeH1oS19vujulX3OoBxmUJUHJStjH
         kmcKSLa6xksJHssuFaOe/2ZxI48Ow/eep/mOemI8j86fcQwSLLF9lCezcpDLkyL7fPSZ
         5jIcC+HliUDvX2ZrD51yrNVZFyjwseVr3BdfK9S2c5xyXbhD8+A+pBCZ9TqNnkD/30Cv
         d9dKMyh0k5EnjL/5SnQ5g0R4o6pe2ZN0bFk+naruhAHicd4brotuFHbXw4w7CQUXY+sW
         gdSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712023382; x=1712628182;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JG53/uIkSpBMtiKQrxrjUYTKftOawX6GTvLp9I5TnJI=;
        b=geeI09i6ZLEeF7JPXnJBiOjBMxejy/rqdNN0QOiqs7FARiT3IBLTRRLFM5J0AQzPiu
         /62xds6CwER9Cc8jjMY6T9a221GnsN5HIKLM/csWLROVjNj/iHFhbCoXgRpMubzgzMp5
         8QD08u6I6buN0UIrcr45Cue3btLxbsRvuh4viG5dUFu1NrgEO2r8mkMcIZDtOvoO1VX5
         l9XXefjJIq1dWZPG+THhWHGjz+Ksh1WIWsIEI8kPwZBXemIvmVnhi31xMtAp0kFgqtxp
         gRQlsFJqOnUCfxw53xyTJuWn902BXCcMMkCpwZ20ZvXB9RvZayR4FFeuz7JnI7noysDg
         +9KA==
X-Forwarded-Encrypted: i=1; AJvYcCXfH3KLAAYrt8pS8R6f0l2GryEDcOYp2pRnldkOvyoUc2yLaydzSu3/X3/QvMcGlqT6JjP3YYXxlNCbmOGRaHeFfy6zIFuyc2RvAlTbjN+Ps/HcZpojubY/QIdGPYuRGi9bZupTKuxuUmgyhYk=
X-Gm-Message-State: AOJu0YzZBcu6vAAuR7H333dKMVZlAlBSvCzUOVbbzdMy04m5ArtETWhj
	jtVGjo3HzFhpcVZBnW+6+EAf40x0bCZpQOK78hQW6wywcm3N5nFa
X-Google-Smtp-Source: AGHT+IE6s47rQU1Egvfe9ACDunPQr2C6yzgnKwXr4oIiRecPoLlLZKVN6ZnoKJy+n0InJGVwnZhxfg==
X-Received: by 2002:a05:6a00:3a14:b0:6ec:b624:ffa8 with SMTP id fj20-20020a056a003a1400b006ecb624ffa8mr4425415pfb.13.1712023382188;
        Mon, 01 Apr 2024 19:03:02 -0700 (PDT)
Received: from smtpclient.apple ([205.204.117.123])
        by smtp.gmail.com with ESMTPSA id ln13-20020a056a003ccd00b006eaf3fd91a1sm5336769pfb.62.2024.04.01.19.02.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Apr 2024 19:03:01 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH] livepatch: Delete the associated module when replacing an
 old livepatch
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20240331133839.18316-1-laoar.shao@gmail.com>
Date: Mon, 1 Apr 2024 22:51:44 +0800
Cc: jpoimboe@kernel.org,
 jikos@kernel.org,
 mbenes@suse.cz,
 pmladek@suse.com,
 joe.lawrence@redhat.com,
 mcgrof@kernel.org,
 live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E75FC9D0-22AD-4FB6-B9F1-CE4A7C9DBBA8@gmail.com>
References: <20240331133839.18316-1-laoar.shao@gmail.com>
To: Yafang Shao <laoar.shao@gmail.com>
X-Mailer: Apple Mail (2.3731.500.231)

It seems that you try to remove the disabled module by the kip replace. =
However, changing the code of sys call may introduce some unnecessary =
changes to non-livepatch module. Is that really a safe way to do so?

> On Mar 31, 2024, at 21:38, Yafang Shao <laoar.shao@gmail.com> wrote:
>=20
> Enhance the functionality of kpatch to automatically remove the =
associated
> module when replacing an old livepatch with a new one. This ensures =
that no
> leftover modules remain in the system. For instance:
>=20
> - Load the first livepatch
> $ kpatch load 6.9.0-rc1+/livepatch-test_0.ko
> loading patch module: 6.9.0-rc1+/livepatch-test_0.ko
> waiting (up to 15 seconds) for patch transition to complete...
> transition complete (2 seconds)
>=20
> $ kpatch list
> Loaded patch modules:
> livepatch_test_0 [enabled]
>=20
> $ lsmod |grep livepatch
> livepatch_test_0       16384  1
>=20
> - Load a new livepatch
> $ kpatch load 6.9.0-rc1+/livepatch-test_1.ko
> loading patch module: 6.9.0-rc1+/livepatch-test_1.ko
> waiting (up to 15 seconds) for patch transition to complete...
> transition complete (2 seconds)
>=20
> $ kpatch list
> Loaded patch modules:
> livepatch_test_1 [enabled]
>=20
> $ lsmod |grep livepatch
> livepatch_test_1       16384  1
> livepatch_test_0       16384  0   <<<< leftover
>=20
> With this improvement, executing
> `kpatch load 6.9.0-rc1+/livepatch-test_1.ko` will automatically remove =
the
> livepatch-test_0.ko module.
>=20
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
> include/linux/module.h  |  1 +
> kernel/livepatch/core.c | 11 +++++++++--
> kernel/module/main.c    | 43 ++++++++++++++++++++++++-----------------
> 3 files changed, 35 insertions(+), 20 deletions(-)
>=20
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 1153b0d99a80..9a95174a919b 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -75,6 +75,7 @@ extern struct module_attribute module_uevent;
> /* These are either module local, or the kernel's dummy ones. */
> extern int init_module(void);
> extern void cleanup_module(void);
> +extern void delete_module(struct module *mod);
>=20
> #ifndef MODULE
> /**
> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> index ecbc9b6aba3a..f1edc999f3ef 100644
> --- a/kernel/livepatch/core.c
> +++ b/kernel/livepatch/core.c
> @@ -711,6 +711,8 @@ static void klp_free_patch_start(struct klp_patch =
*patch)
> */
> static void klp_free_patch_finish(struct klp_patch *patch)
> {
> + struct module *mod =3D patch->mod;
> +
> /*
> * Avoid deadlock with enabled_store() sysfs callback by
> * calling this outside klp_mutex. It is safe because
> @@ -721,8 +723,13 @@ static void klp_free_patch_finish(struct =
klp_patch *patch)
> wait_for_completion(&patch->finish);
>=20
> /* Put the module after the last access to struct klp_patch. */
> - if (!patch->forced)
> - module_put(patch->mod);
> + if (!patch->forced)  {
> + module_put(mod);
> + if (module_refcount(mod))
> + return;
> + mod->state =3D MODULE_STATE_GOING;
> + delete_module(mod);
> + }
> }
>=20
> /*
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index e1e8a7a9d6c1..e863e1f87dfd 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -695,12 +695,35 @@ EXPORT_SYMBOL(module_refcount);
> /* This exists whether we can unload or not */
> static void free_module(struct module *mod);
>=20
> +void delete_module(struct module *mod)
> +{
> + char buf[MODULE_FLAGS_BUF_SIZE];
> +
> + /* Final destruction now no one is using it. */
> + if (mod->exit !=3D NULL)
> + mod->exit();
> + blocking_notifier_call_chain(&module_notify_list,
> +     MODULE_STATE_GOING, mod);
> + klp_module_going(mod);
> + ftrace_release_mod(mod);
> +
> + async_synchronize_full();
> +
> + /* Store the name and taints of the last unloaded module for =
diagnostic purposes */
> + strscpy(last_unloaded_module.name, mod->name, =
sizeof(last_unloaded_module.name));
> + strscpy(last_unloaded_module.taints, module_flags(mod, buf, false),
> + sizeof(last_unloaded_module.taints));
> +
> + free_module(mod);
> + /* someone could wait for the module in add_unformed_module() */
> + wake_up_all(&module_wq);
> +}
> +
> SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
> unsigned int, flags)
> {
> struct module *mod;
> char name[MODULE_NAME_LEN];
> - char buf[MODULE_FLAGS_BUF_SIZE];
> int ret, forced =3D 0;
>=20
> if (!capable(CAP_SYS_MODULE) || modules_disabled)
> @@ -750,23 +773,7 @@ SYSCALL_DEFINE2(delete_module, const char __user =
*, name_user,
> goto out;
>=20
> mutex_unlock(&module_mutex);
> - /* Final destruction now no one is using it. */
> - if (mod->exit !=3D NULL)
> - mod->exit();
> - blocking_notifier_call_chain(&module_notify_list,
> -     MODULE_STATE_GOING, mod);
> - klp_module_going(mod);
> - ftrace_release_mod(mod);
> -
> - async_synchronize_full();
> -
> - /* Store the name and taints of the last unloaded module for =
diagnostic purposes */
> - strscpy(last_unloaded_module.name, mod->name, =
sizeof(last_unloaded_module.name));
> - strscpy(last_unloaded_module.taints, module_flags(mod, buf, false), =
sizeof(last_unloaded_module.taints));
> -
> - free_module(mod);
> - /* someone could wait for the module in add_unformed_module() */
> - wake_up_all(&module_wq);
> + delete_module(mod);
> return 0;
> out:
> mutex_unlock(&module_mutex);
> --=20
> 2.39.1
>=20
>=20


