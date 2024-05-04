Return-Path: <live-patching+bounces-232-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 515098BBD4A
	for <lists+live-patching@lfdr.de>; Sat,  4 May 2024 18:53:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 92A0B2819E5
	for <lists+live-patching@lfdr.de>; Sat,  4 May 2024 16:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A07A5A117;
	Sat,  4 May 2024 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCtS0yHu"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576F53D971;
	Sat,  4 May 2024 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714841589; cv=none; b=gmDeLu16bagjR/o010caU7wdyzu+Pgp9VMRfcGYlvi8sXl2D0W4vksWk80UhslhDXRKeru2XvB6yAeTrzTLT8U09HCMuGeoqvSpCNFp5WeUBtEsN2k1rlcNay/rjXmiPkrrk03V6/KVrviSPWoiqJOpit9mRCsRaUFVo4Y9obBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714841589; c=relaxed/simple;
	bh=cUaO7j+9/NGbB63eAPCXMsUVTPw/N5JpLV0d5Uf1amM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K4uUILdCRq9OLf1a664XCiEHmN+zt6mfHlcFb27oqa16h4zNVMoTEFU0MV3EmwFvTOK9eeazY+PUDT5C4epRvMwj/++gKHbhOabZAuHX3vlAuR607acgLWcXn8JyGsAHu9vdqqHOer6/f3DCTXdnGrT1GORaAvWVJc8H631RSeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCtS0yHu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67355C072AA;
	Sat,  4 May 2024 16:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714841588;
	bh=cUaO7j+9/NGbB63eAPCXMsUVTPw/N5JpLV0d5Uf1amM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fCtS0yHuOJpgS+CBu7z+RXXyAbbW+nod+qUCVRBxqKrjgVghf6qAWPYikXLdbeCWe
	 3y3h5+7qrgOxbzFqsO0wyzLktKcc+KF+D7dGDIad67LRkscouvB/HZHKF0+lC/tP0x
	 gobdDeAnQiJ4c47dT/TlzNc0p7UyHs5wnCj4sWUU=
Date: Sat, 4 May 2024 18:53:05 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, mcgrof@kernel.org,
	live-patching@vger.kernel.org, linux-modules@vger.kernel.org
Subject: Re: [PATCH v2 1/2] module: Add a new helper delete_module()
Message-ID: <2024050415-refocus-preoccupy-6d53@gregkh>
References: <20240407035730.20282-1-laoar.shao@gmail.com>
 <20240407035730.20282-2-laoar.shao@gmail.com>
 <CALOAHbDGcY5y6hWZgJp9ELrt_w4pfB-X3EqS3yu8k37pj3ZEcw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALOAHbDGcY5y6hWZgJp9ELrt_w4pfB-X3EqS3yu8k37pj3ZEcw@mail.gmail.com>

On Wed, Apr 24, 2024 at 08:09:05PM +0800, Yafang Shao wrote:
> On Sun, Apr 7, 2024 at 11:58 AM Yafang Shao <laoar.shao@gmail.com> wrote:
> >
> > Introduce a new helper function, delete_module(), designed to delete kernel
> > modules from locations outside of the `kernel/module` directory.
> >
> > No functional change.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  include/linux/module.h |  1 +
> >  kernel/module/main.c   | 82 ++++++++++++++++++++++++++++++++----------
> >  2 files changed, 65 insertions(+), 18 deletions(-)
> >
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index 1153b0d99a80..c24557f1b795 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -75,6 +75,7 @@ extern struct module_attribute module_uevent;
> >  /* These are either module local, or the kernel's dummy ones. */
> >  extern int init_module(void);
> >  extern void cleanup_module(void);
> > +extern int delete_module(struct module *mod);
> >
> >  #ifndef MODULE
> >  /**
> > diff --git a/kernel/module/main.c b/kernel/module/main.c
> > index e1e8a7a9d6c1..3b48ee66db41 100644
> > --- a/kernel/module/main.c
> > +++ b/kernel/module/main.c
> > @@ -695,12 +695,74 @@ EXPORT_SYMBOL(module_refcount);
> >  /* This exists whether we can unload or not */
> >  static void free_module(struct module *mod);
> >
> > +static void __delete_module(struct module *mod)
> > +{
> > +       char buf[MODULE_FLAGS_BUF_SIZE];
> > +
> > +       WARN_ON_ONCE(mod->state != MODULE_STATE_GOING);
> > +
> > +       /* Final destruction now no one is using it. */
> > +       if (mod->exit != NULL)
> > +               mod->exit();
> > +       blocking_notifier_call_chain(&module_notify_list,
> > +                                    MODULE_STATE_GOING, mod);
> > +       klp_module_going(mod);
> > +       ftrace_release_mod(mod);
> > +
> > +       async_synchronize_full();
> > +
> > +       /* Store the name and taints of the last unloaded module for diagnostic purposes */
> > +       strscpy(last_unloaded_module.name, mod->name, sizeof(last_unloaded_module.name));
> > +       strscpy(last_unloaded_module.taints, module_flags(mod, buf, false),
> > +               sizeof(last_unloaded_module.taints));
> > +
> > +       free_module(mod);
> > +       /* someone could wait for the module in add_unformed_module() */
> > +       wake_up_all(&module_wq);
> > +}
> > +
> > +int delete_module(struct module *mod)
> > +{
> > +       int ret;
> > +
> > +       mutex_lock(&module_mutex);
> > +       if (!list_empty(&mod->source_list)) {
> > +               /* Other modules depend on us: get rid of them first. */
> > +               ret = -EWOULDBLOCK;
> > +               goto out;
> > +       }
> > +
> > +       /* Doing init or already dying? */
> > +       if (mod->state != MODULE_STATE_LIVE) {
> > +               ret = -EBUSY;
> > +               goto out;
> > +       }
> > +
> > +       /* If it has an init func, it must have an exit func to unload */
> > +       if (mod->init && !mod->exit) {
> > +               ret = -EBUSY;
> > +               goto out;
> > +       }
> > +
> > +       if (try_release_module_ref(mod) != 0) {
> > +               ret = -EWOULDBLOCK;
> > +               goto out;
> > +       }
> > +       mod->state = MODULE_STATE_GOING;
> > +       mutex_unlock(&module_mutex);
> > +       __delete_module(mod);
> > +       return 0;
> > +
> > +out:
> > +       mutex_unlock(&module_mutex);
> > +       return ret;
> > +}
> > +
> >  SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
> >                 unsigned int, flags)
> >  {
> >         struct module *mod;
> >         char name[MODULE_NAME_LEN];
> > -       char buf[MODULE_FLAGS_BUF_SIZE];
> >         int ret, forced = 0;
> >
> >         if (!capable(CAP_SYS_MODULE) || modules_disabled)
> > @@ -750,23 +812,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
> >                 goto out;
> >
> >         mutex_unlock(&module_mutex);
> > -       /* Final destruction now no one is using it. */
> > -       if (mod->exit != NULL)
> > -               mod->exit();
> > -       blocking_notifier_call_chain(&module_notify_list,
> > -                                    MODULE_STATE_GOING, mod);
> > -       klp_module_going(mod);
> > -       ftrace_release_mod(mod);
> > -
> > -       async_synchronize_full();
> > -
> > -       /* Store the name and taints of the last unloaded module for diagnostic purposes */
> > -       strscpy(last_unloaded_module.name, mod->name, sizeof(last_unloaded_module.name));
> > -       strscpy(last_unloaded_module.taints, module_flags(mod, buf, false), sizeof(last_unloaded_module.taints));
> > -
> > -       free_module(mod);
> > -       /* someone could wait for the module in add_unformed_module() */
> > -       wake_up_all(&module_wq);
> > +       __delete_module(mod);
> >         return 0;
> >  out:
> >         mutex_unlock(&module_mutex);
> > --
> > 2.39.1
> >
> 
> Luis, Greg,
> 
> Since the last version, there hasn't been any response. Would you mind
> taking a moment to review it and provide your feedback on the
> kernel/module changes?

There was response on patch 2/2, which is why I deleted this from my
review queue a long time ago.

Please address that if you wish to, and then resend if you feel this is
still needed.

Personally, I really don't like this function you added...

thanks,

greg k-h

