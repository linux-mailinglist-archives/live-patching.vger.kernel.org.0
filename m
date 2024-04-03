Return-Path: <live-patching+bounces-215-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C6E98962E3
	for <lists+live-patching@lfdr.de>; Wed,  3 Apr 2024 05:20:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A752C1F2450A
	for <lists+live-patching@lfdr.de>; Wed,  3 Apr 2024 03:20:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B233D1F958;
	Wed,  3 Apr 2024 03:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UAERCeXO"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3CAC1BF5C;
	Wed,  3 Apr 2024 03:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712114429; cv=none; b=hnclN2V1FIfsonfvOBUXmnfiI4kz3hRmMvqG6IvsV+Y1FI4eVsHjDMO8tJmxF0fMyT9aG3ls6mhtOPfz6SXpQWzJJtDAHscdj2OxHcH1+lZTRzWWoiSIktDZcdhAwFPhy8x3qmAB5bQYfd4HoubT5+Rd1XaLpBaQAym0D7zZ2R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712114429; c=relaxed/simple;
	bh=AAM+vmdgD9AdgjJuJGwk8weBY34yyuWsEiSqmA6iMw0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bYoRqWK6V8O9jWYCoH3BmwnnNHNS/idy38sgQ7Ud+I5luiJ4j2P9ZPCk6At3QQSB6cWB6ylqvMqz8bIKBmsMVujoSvtMt3bmXyt446OPmLznrL46WwP1mj8gWi2AU3b4zPpR4WB+m+gpZ6clwXnpJh0d5YJq8DLQYE4Ori7WbMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UAERCeXO; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-69699fecccdso33173536d6.1;
        Tue, 02 Apr 2024 20:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712114427; x=1712719227; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H3njtlNQOXlw54XekmM99OKJq2sIiZT7JHjAPlsP5Po=;
        b=UAERCeXOTftN+CFXP0cnMbeUcO30rElkXaKvPzlHAlYqbRLYlSZD26VOFlCMjd2hg/
         ar5wz6Gz7/Zqyht7xLVQIuNy70dIFLIEJZAlQ0Yz3vl1RyG4fPC9HQpg6bFlKLTlAKrr
         AUbUHdF7cHzJw24bMGkbjlk+Vw3SxW4FeHl/9WiKzDx1smAFMGr6nM0f82pL7snIhdIw
         3motLUf80akygqL1PNhFuvKxBxE9tBLkV9bBE9Urub1FRrzRClb9modDRGZ9lz9vkmnU
         5uH3ps5RamvhaRWx2lZ17rDvOVYt2Nuv9UdKcI17Y3RT2tJargd1GF71dbAqZ0UMm3lv
         /gCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712114427; x=1712719227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H3njtlNQOXlw54XekmM99OKJq2sIiZT7JHjAPlsP5Po=;
        b=iL0i4eLP75f+ZFTfb5TybsWcpHK8bx4SQugXsZB/PxtwbgQulRk2CSqhQ79+2tUBHr
         009muEic8aua2RFjV1cFVqitB8d6GVTJI7Xi/8LxawK3pDqwul4qkBxVtjPEmv7XoczF
         FjYYQKskAOqRTVuR/4cUZzIoc2PkSuOuB5vab8j+ElXqRsqQ4FPcTQwh7WRUmK/vC0/P
         WrapKBFg8X28YP5J92DJ0PuUyS0LUAWGZHVphPWXcRL3boCEm32SouDvqM3SQ4TmdaG2
         CrzIOHgrDxO8Lcnmy2618ijNZzL4SXe4ZY/NRFImw+6XzCDBvgoOIq64IGVVb2ue1ci2
         mMYA==
X-Forwarded-Encrypted: i=1; AJvYcCUG6ZAnv42KPQdKLsxKI4k0FAmmMZJyZkKSvpsTQvDC4ftqLjKqoX0Kfdgy+z+LdyxDD66BGh/DgIePKmKt7+heZ+p8t9dWcIsmPJWGXV1W6dzE0MgvjrKTCLceeSVqt/OW83fOFPOOePWDOVU=
X-Gm-Message-State: AOJu0YwziMWPOXXPqBYT3rLAoI7sDnDS0AfvkNNKRQnjSoVcYQCCF3VI
	sB5+qH9y/Dqb0Js6r2z3DrCm9Xdu7CLALE08NLZX6pdkYPr1uNqwIVOjbzGra8f/TBSncAi/LOc
	5EWZ5M3a6wehwZXUZotA0sRLMkR3PZfWNNafndSg1
X-Google-Smtp-Source: AGHT+IHIZmhHhDQN4lZAtXhWxfZ1w0U3URlbhnLROhn8ZQAQCyAyA8QGvT0g1zhJD/j+aaaffWOYJwJgSARHL+g67kM=
X-Received: by 2002:a05:6214:1786:b0:699:16c8:8517 with SMTP id
 ct6-20020a056214178600b0069916c88517mr4050450qvb.6.1712114426711; Tue, 02 Apr
 2024 20:20:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240331133839.18316-1-laoar.shao@gmail.com> <ZgrMfYBo8TynjSKX@redhat.com>
 <CALOAHbDWiO+TbRnjxCN3j9YWD3Cz9NOg9g-xOhVqmaPmexqNoQ@mail.gmail.com> <f9780cb7-1071-7cb3-c18a-0681a741e0b4@redhat.com>
In-Reply-To: <f9780cb7-1071-7cb3-c18a-0681a741e0b4@redhat.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Wed, 3 Apr 2024 11:19:50 +0800
Message-ID: <CALOAHbAiKzFef577W=hao4+mSrGsn_SjAgub+FHTbJ7-8XO_9w@mail.gmail.com>
Subject: Re: [PATCH] livepatch: Delete the associated module when replacing an
 old livepatch
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: mbenes@suse.cz, pmladek@suse.com, jpoimboe@kernel.org, jikos@kernel.org, 
	mcgrof@kernel.org, live-patching@vger.kernel.org, 
	linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 2, 2024 at 9:39=E2=80=AFPM Joe Lawrence <joe.lawrence@redhat.co=
m> wrote:
>
> On 4/1/24 22:45, Yafang Shao wrote:
> > On Mon, Apr 1, 2024 at 11:02=E2=80=AFPM Joe Lawrence <joe.lawrence@redh=
at.com> wrote:
> >>
> >> On Sun, Mar 31, 2024 at 09:38:39PM +0800, Yafang Shao wrote:
> >>> Enhance the functionality of kpatch to automatically remove the assoc=
iated
> >>> module when replacing an old livepatch with a new one. This ensures t=
hat no
> >>> leftover modules remain in the system. For instance:
> >>>
> >>> - Load the first livepatch
> >>>   $ kpatch load 6.9.0-rc1+/livepatch-test_0.ko
> >>>   loading patch module: 6.9.0-rc1+/livepatch-test_0.ko
> >>>   waiting (up to 15 seconds) for patch transition to complete...
> >>>   transition complete (2 seconds)
> >>>
> >>>   $ kpatch list
> >>>   Loaded patch modules:
> >>>   livepatch_test_0 [enabled]
> >>>
> >>>   $ lsmod |grep livepatch
> >>>   livepatch_test_0       16384  1
> >>>
> >>> - Load a new livepatch
> >>>   $ kpatch load 6.9.0-rc1+/livepatch-test_1.ko
> >>>   loading patch module: 6.9.0-rc1+/livepatch-test_1.ko
> >>>   waiting (up to 15 seconds) for patch transition to complete...
> >>>   transition complete (2 seconds)
> >>>
> >>>   $ kpatch list
> >>>   Loaded patch modules:
> >>>   livepatch_test_1 [enabled]
> >>>
> >>>   $ lsmod |grep livepatch
> >>>   livepatch_test_1       16384  1
> >>>   livepatch_test_0       16384  0   <<<< leftover
> >>>
> >>> With this improvement, executing
> >>> `kpatch load 6.9.0-rc1+/livepatch-test_1.ko` will automatically remov=
e the
> >>> livepatch-test_0.ko module.
> >>>
> >>
> >> Hi Yafang,
> >>
> >> I think it would be better if the commit message reasoning used
> >> insmod/modprobe directly rather than the kpatch user utility wrapper.
> >> That would be more generic and remove any potential kpatch utility
> >> variants from the picture.  (For example, it is possible to add `rmmod=
`
> >> in the wrapper and then this patch would be redundant.)
> >
> > Hi Joe,
> >
> > I attempted to incorporate an `rmmod` operation within the kpatch
> > replacement process, but encountered challenges in devising a safe and
> > effective solution. The difficulty arises from the uncertainty
> > regarding which livepatch will be replaced in userspace, necessitating
> > the operation to be conducted within the kernel itself.
> >
>
> I wasn't suggesting that the kpatch user utility should or could solve
> this problem, just that this scenario is not specific to kpatch.  And
> since this is a kernel patch, it would be consistent to speak in terms
> of livepatches: the repro can be phrased in terms of modprobe/insmod,
> /sys/kernel/livepatch/ sysfs, rmmod, etc. for which those not using the
> kpatch utility are more familiar with.

Understood. Thanks for your explanation. I will try it.

>
> >>
> >>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> >>> ---
> >>>  include/linux/module.h  |  1 +
> >>>  kernel/livepatch/core.c | 11 +++++++++--
> >>>  kernel/module/main.c    | 43 ++++++++++++++++++++++++---------------=
--
> >>>  3 files changed, 35 insertions(+), 20 deletions(-)
> >>>
> >>> diff --git a/include/linux/module.h b/include/linux/module.h
> >>> index 1153b0d99a80..9a95174a919b 100644
> >>> --- a/include/linux/module.h
> >>> +++ b/include/linux/module.h
> >>> @@ -75,6 +75,7 @@ extern struct module_attribute module_uevent;
> >>>  /* These are either module local, or the kernel's dummy ones. */
> >>>  extern int init_module(void);
> >>>  extern void cleanup_module(void);
> >>> +extern void delete_module(struct module *mod);
> >>>
> >>>  #ifndef MODULE
> >>>  /**
> >>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> >>> index ecbc9b6aba3a..f1edc999f3ef 100644
> >>> --- a/kernel/livepatch/core.c
> >>> +++ b/kernel/livepatch/core.c
> >>> @@ -711,6 +711,8 @@ static void klp_free_patch_start(struct klp_patch=
 *patch)
> >>>   */
> >>>  static void klp_free_patch_finish(struct klp_patch *patch)
> >>>  {
> >>> +     struct module *mod =3D patch->mod;
> >>> +
> >>>       /*
> >>>        * Avoid deadlock with enabled_store() sysfs callback by
> >>>        * calling this outside klp_mutex. It is safe because
> >>> @@ -721,8 +723,13 @@ static void klp_free_patch_finish(struct klp_pat=
ch *patch)
> >>>       wait_for_completion(&patch->finish);
> >>>
> >>>       /* Put the module after the last access to struct klp_patch. */
> >>> -     if (!patch->forced)
> >>> -             module_put(patch->mod);
> >>> +     if (!patch->forced)  {
> >>> +             module_put(mod);
> >>> +             if (module_refcount(mod))
> >>> +                     return;
> >>> +             mod->state =3D MODULE_STATE_GOING;
> >>> +             delete_module(mod);
> >>> +     }
>
> I'm gonna have to read study code in kernel/module/ to be confident that
> this is completely safe.  What happens if this code races a concurrent
> `rmmod` from the user (perhaps that pesky kpatch utility)?  Can a stray
> module reference sneak between the code here.  Etc.  The existing
> delete_module syscall does some additional safety checks under the
> module_mutex, which may or may not make sense for this use case... Petr,
> Miroslav any thoughts?

A race condition may occur. It appears necessary to modify the
mod->state under the protection of module_mutex. If the state is not
MODULE_STATE_LIVE, it must be skipped.

>
> Also, code-wise, it would be nice if the mod->state were only assigned
> inside the kernel/module/main.c code... maybe this little sequence can
> be pushed into that file so it's all in one place?

good suggestion. will do it.

>
> >>>  }
> >>>
> >>>  /*
> >>> diff --git a/kernel/module/main.c b/kernel/module/main.c
> >>> index e1e8a7a9d6c1..e863e1f87dfd 100644
> >>> --- a/kernel/module/main.c
> >>> +++ b/kernel/module/main.c
> >>> @@ -695,12 +695,35 @@ EXPORT_SYMBOL(module_refcount);
> >>>  /* This exists whether we can unload or not */
> >>>  static void free_module(struct module *mod);
> >>>
> >>> +void delete_module(struct module *mod)
> >>> +{
> >>> +     char buf[MODULE_FLAGS_BUF_SIZE];
> >>> +
> >>> +     /* Final destruction now no one is using it. */
> >>> +     if (mod->exit !=3D NULL)
> >>> +             mod->exit();
> >>> +     blocking_notifier_call_chain(&module_notify_list,
> >>> +                                  MODULE_STATE_GOING, mod);
> >>> +     klp_module_going(mod);
> >>> +     ftrace_release_mod(mod);
> >>> +
> >>> +     async_synchronize_full();
> >>> +
> >>> +     /* Store the name and taints of the last unloaded module for di=
agnostic purposes */
> >>> +     strscpy(last_unloaded_module.name, mod->name, sizeof(last_unloa=
ded_module.name));
> >>> +     strscpy(last_unloaded_module.taints, module_flags(mod, buf, fal=
se),
> >>> +             sizeof(last_unloaded_module.taints));
> >>> +
> >>> +     free_module(mod);
> >>> +     /* someone could wait for the module in add_unformed_module() *=
/
> >>> +     wake_up_all(&module_wq);
> >>> +}
> >>> +
> >>>  SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
> >>>               unsigned int, flags)
> >>>  {
> >>>       struct module *mod;
> >>>       char name[MODULE_NAME_LEN];
> >>> -     char buf[MODULE_FLAGS_BUF_SIZE];
> >>>       int ret, forced =3D 0;
> >>>
> >>>       if (!capable(CAP_SYS_MODULE) || modules_disabled)
> >>> @@ -750,23 +773,7 @@ SYSCALL_DEFINE2(delete_module, const char __user=
 *, name_user,
> >>>               goto out;
> >>>
> >>>       mutex_unlock(&module_mutex);
> >>> -     /* Final destruction now no one is using it. */
> >>> -     if (mod->exit !=3D NULL)
> >>> -             mod->exit();
> >>> -     blocking_notifier_call_chain(&module_notify_list,
> >>> -                                  MODULE_STATE_GOING, mod);
> >>> -     klp_module_going(mod);
> >>> -     ftrace_release_mod(mod);
> >>> -
> >>> -     async_synchronize_full();
> >>> -
> >>> -     /* Store the name and taints of the last unloaded module for di=
agnostic purposes */
> >>> -     strscpy(last_unloaded_module.name, mod->name, sizeof(last_unloa=
ded_module.name));
> >>> -     strscpy(last_unloaded_module.taints, module_flags(mod, buf, fal=
se), sizeof(last_unloaded_module.taints));
> >>> -
> >>> -     free_module(mod);
> >>> -     /* someone could wait for the module in add_unformed_module() *=
/
> >>> -     wake_up_all(&module_wq);
> >>> +     delete_module(mod);
> >>>       return 0;
> >>>  out:
> >>>       mutex_unlock(&module_mutex);
> >>> --
> >>> 2.39.1
> >>>
> >>
> >> It's been a while since atomic replace was added and so I forget why t=
he
> >> implementation doesn't try this -- is it possible for the livepatch
> >> module to have additional references that this patch would force its w=
ay
> >> through?
> >
> > In the klp_free_patch_finish() function, a check is performed on the
> > reference count of the livepatch module. If the reference count is not
> > zero, the function will skip further processing.
> >
> >>
> >> Also, this patch will break the "atomic replace livepatch" kselftest i=
n
> >> test-livepatch.sh [1].  I think it would need to drop the `unload_lp
> >> $MOD_LIVEPATCH` command, the following 'live patched' greps and their
> >> corresponding dmesg output in the test's final check_result() call.
> >
> > Thanks for your information. I will check it.
> >
>
> Let me know if you have any questions, I'm more familiar with that code
> than the atomic replace / module interactions :)
>

You're correct in noting that we need to discard certain unload_lps
and rmmods. This is because, after implementing the change, executing
`echo 0 > /sys/kernel/livepatch/${livepatch}/enabled` will remove the
associated kernel module.

The question then arises: is this change in behavior acceptable, or
should we avoid it?

--=20
Regards
Yafang

