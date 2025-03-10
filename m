Return-Path: <live-patching+bounces-1268-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD2B6A59A56
	for <lists+live-patching@lfdr.de>; Mon, 10 Mar 2025 16:49:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00E763AA2D4
	for <lists+live-patching@lfdr.de>; Mon, 10 Mar 2025 15:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54B1E22F3BA;
	Mon, 10 Mar 2025 15:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Nzp8CQTi"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D7122D7A3
	for <live-patching@vger.kernel.org>; Mon, 10 Mar 2025 15:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741621706; cv=none; b=bldVP3WykXc2qw6fU76MYcbFCE5n1wvhBR0UGxC1/+H0y01r2sBvdcQqRVuL2F7xiOquNahTn+1HhxikqcKVM7LPHH0mCyN/T6hj9gNv+XRDK4m5q63fnH+mmzI01xI3Rk+2SZ0okRgBMW6K+6WS5CvVzIICOWHRoBp244PFe6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741621706; c=relaxed/simple;
	bh=4agdNq+pyTc0onKAMlNx5nc5CnK9lEDlRxlJ39RKo94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jHxrdI3WjlF+mDrkY56RBi2hzL9TNZm4pH3RyilZfUdk6lwP+VVmP19g7p1VIzAnJj9bDHd1EwLx4KG/PbYSimGZ7QygH/WLAbHFnMtim8qGqJxo0rZvZEf7IsPEYEqxvq7I4X+viN1kyxzGlL64rsbPNwJ8gcNiDhM50r4GoYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Nzp8CQTi; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4394a823036so37470105e9.0
        for <live-patching@vger.kernel.org>; Mon, 10 Mar 2025 08:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1741621702; x=1742226502; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3lcAZ8GMfmqoVMJO6v69JEyuLwlk96+gQnB1hMneebU=;
        b=Nzp8CQTizO/BP5MeARH6FFnCyywywP242X8unt6Uqgy0klYQg5q0ClVPEnfKF/1Gj+
         +/ByKaxQD8Zt7zvf1mDsuXkUP6JcYaJEGIjaPtpuml8gobG2Op96U0rb7FEuqg/dPMBC
         UrEER/213xEXAlqEESfnfkAb9WqcRzIj504aksuFiOTdsJtrqPUhRs+nFMCkrF8W4Ff6
         EcHAEeX5un7oiiw7eH8+pwArMMMhUY0ehq9Eo4H+7nG6n1dNb39kfKH/9kgynGQxh3vT
         gJFFisn80j42raLdx3U5VKaievZh7xOXxz0yn6u2IsxHEiE0/kx3CCxm8iCBn4DXXlBh
         g5LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741621702; x=1742226502;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3lcAZ8GMfmqoVMJO6v69JEyuLwlk96+gQnB1hMneebU=;
        b=Tb63tr++79fwWo1RaC3JftVU4e/zjZzzeMoJqL9ZrWHysmPXTt6Ic68c/Ifuuq4yBU
         xsmZvXnTUsADh2l9gcPtBGS9nOqPwoy0ldrAl9oiYfeugAS32q1VU6leqgA9cCi5wfGK
         j1TPv5XnQNVj8rD3VrYFd0MH2YvaAuKbLHQVrEdz+2+MGjbP+ZDu43woIeJSxvv0+f9F
         UFI1L3I5Sw5ozZP47HNVyNTP4/ZiUGnmyt8b4EOFWXWgQZXsrkdRR/wIDN/Zl8OaZkpW
         PEKYZ0H3/Fc+gsGC1V93qPegqWVSTh0LcKNGuY20JvWaTpNGcj+F+FyliMyeQm8Puvkf
         j3gg==
X-Forwarded-Encrypted: i=1; AJvYcCXd7wn0OhnxDhiE8ZEUuUhg5ZBzpDaR6lhLEUjvZmhY6BoWOYDjynisTSJbOeVYKr+xG3XUWnLW6gkcu4Ib@vger.kernel.org
X-Gm-Message-State: AOJu0YzTNkzXb/fccd+/B03z0vo1kusy1Of0XO8lwGUT2gKly3tiEg6j
	qN7j3p3R8TdHMfajV7fPoVujf6pkRHOzekGJKXDcJ4g4ldBPM7tWJvRd+H7rUW/BFUMaCyXbOFa
	7
X-Gm-Gg: ASbGncvloh58NeXTrhIkrTf0kvKbVVH9MCi8hVeIdiGO0dOXNO1Pg0k5ctqLgfNPEa8
	eOstUnA8iVkOuiVtumvPU/9RYTP9XTFyNFrySPNNe7B7eGmRs67FxJFvmci/h/HvNdzVT3V7QEC
	FDHi+PGHCkpORFnEXQXhWf111beTezm2J35iwNyb56x2OCFLl7eVmk6/YfPIrRSS+wMXQ0XN9BB
	y3arI2roe+rQxCN3MONkRfNILk6p+CvFIgmLFGpUxLBhpnSRxm1b5KhG+UaCOCThTymMvy0EV+A
	AC6fuRxhzJCsa3oIVFd3SZZH8KcJAIxo6xUqhH6P1+qFI1w=
X-Google-Smtp-Source: AGHT+IEuz/QnfRo3l7wuUHBPyXbI1lI3KcCunNZ1HHCASxptwPpGt7p7+mjJUcQ3NqlW48b9Yh002w==
X-Received: by 2002:a05:600c:3111:b0:43c:f7b8:83c7 with SMTP id 5b1f17b1804b1-43d01c22322mr779675e9.25.1741621702258;
        Mon, 10 Mar 2025 08:48:22 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43bd42c588dsm174643905e9.21.2025.03.10.08.48.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 08:48:21 -0700 (PDT)
Date: Mon, 10 Mar 2025 16:48:20 +0100
From: Petr Mladek <pmladek@suse.com>
To: zhang warden <zhangwarden@gmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org
Subject: Re: [RFC] Add target module check before livepatch module loading
Message-ID: <Z88JxGTGMcBEeHVP@pathway.suse.cz>
References: <C746373C-96ED-47EE-94F2-00E930BE2E8B@gmail.com>
 <Z8r6AKBU4WPkPlaq@pathway.suse.cz>
 <3524E557-77AD-427C-82BA-6CA06968AC5B@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3524E557-77AD-427C-82BA-6CA06968AC5B@gmail.com>

On Mon 2025-03-10 10:22:19, zhang warden wrote:
> 
> Hi, Petr!
> 
> > The work with the elf sections is tricky. I would prefer to add
> > .srcversion into struct klp_object, something like:
> > 
> > struct klp_object {
> > /* external */
> > const char *name;
> > + const char *srcversion;
> > struct klp_func *funcs;
> > struct klp_callbacks callbacks;
> > [...]
> > }
> > 
> 
> In fact, I have a though in mind that we can easily use the 
> srcversion in `struct module` like:
> 
> struct module {
>     enum module_state state;
> 
>     /* Member of list of modules */
>     struct list_head list;
> 
>     /* Unique handle for this module */
>     char name[MODULE_NAME_LEN];
> 
> #ifdef CONFIG_STACKTRACE_BUILD_ID
>     /* Module build ID */
>     unsigned char build_id[BUILD_ID_SIZE_MAX];
> #endif
> 
>     /* Sysfs stuff. */
>     struct module_kobject mkobj;
>     struct module_attribute *modinfo_attrs;
>     const char *version;
>     const char *srcversion;
>     struct kobject *holders_dir;
> 
>     /* Exported symbols */
>     const struct kernel_symbol *syms;
>     const u32 *crcs;
>     unsigned int num_syms;
> 
> becase when we are loading a livepatch module, the syscall `init_module`
> will be called and we can check the srcversion here.
> 
> What I want to do in the elf section is that I want to add a new section
> to store the target module src version inside. 

Why do you want to store the target module src version in an elf
section, please?

IMHO, it would be much easier to store it in struct klp_object
as I proposed above. Then the check might be as simple as:

diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
index 51a258c24ff5..dfd7132eec4e 100644
--- a/include/linux/livepatch.h
+++ b/include/linux/livepatch.h
@@ -104,6 +104,7 @@ struct klp_callbacks {
 /**
  * struct klp_object - kernel object structure for live patching
  * @name:	module name (or NULL for vmlinux)
+ * @srcversion  compactible srcversion (optional)
  * @funcs:	function entries for functions to be patched in the object
  * @callbacks:	functions to be executed pre/post (un)patching
  * @kobj:	kobject for sysfs resources
@@ -117,6 +118,7 @@ struct klp_callbacks {
 struct klp_object {
 	/* external */
 	const char *name;
+	const char *srcversion;
 	struct klp_func *funcs;
 	struct klp_callbacks callbacks;
 
diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 0cd39954d5a1..61004502e72d 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -66,6 +66,13 @@ static void klp_find_object_module(struct klp_object *obj)
 	 * klp_module_going() instead.
 	 */
 	mod = find_module(obj->name);
+
+	/* Do not livepatch an incompatible object. */
+	if (mod && obj->srcversion && mod->srcversion) {
+		if (strcmp(obj->srcversion, mod->srcversion) != 0)
+			goto out;
+	}
+
 	/*
 	 * Do not mess work of klp_module_coming() and klp_module_going().
 	 * Note that the patch might still be needed before klp_module_going()
@@ -75,7 +82,7 @@ static void klp_find_object_module(struct klp_object *obj)
 	 */
 	if (mod && mod->klp_alive)
 		obj->mod = mod;
-
+out:
 	rcu_read_unlock_sched();
 }

The above code causes that the livepatch would ignore an incompatible
object.

Maybe, you want to return an error instead and block the incompatible
module load.

> > It would be optional. I made just a quick look. It might be enough
> > to check it in klp_find_object_module() and do not set obj->mod
> > when obj->srcversion != NULL and does not match mod->srcversion.
> > 
> > Wait! We need to check it also in klp_write_section_relocs().
> > Otherwise, klp_apply_section_relocs() might apply the relocations
> > for non-compatible module.
> > 
> 
> As previously mentioned, if we can check the srcversion when calling
> the syscall `init_module`, refuse to load the module if the livepatch
> module have srcversion and the srcversion is not equal to the target
> in the system. Can it avoid such relocations problem?

Honestly, I am not sure what you mean by target module src version.

Anyway, you could prevent the module load also when
klp_find_object_module() returns an error.


> > Alternative: I think about using "mod->build_id" instead of "srcversion".
> > It would be even more strict because it would make dependency
> > on a particular build.
> > 
> > An advantage is that it is defined also for vmlinux,
> > see vmlinux_build_id. So that we could easily use
> > the same approach also for vmlinux.
> > 
> > I do not have strong opinion on this though.
> > 
> 
> Petr, using "mod->build_id" instead of "srcversion" may not be good.
> Because livepatch can not only handle the function in vmlinux but also
> the function in modules.

I do not understand this urgument.

vmlinux can be identified by build_id stored in "vmlinux_build_id".

And modules can be identified by both build_id and srcversion. Both
information are stored in struct module.

A single livepatch could modify more objects: vmlinux and several
modules. The metadata for each modified object are in "struct
klp_object". The related obect is currently identified only by obj->name.
And we could add more precision identification by setting
also "obj->srcversion" and/or "obj->build_id".


> From my point of view, each build will have a different srcversion generated.
> Is it necessary to introduce a "mod->build_id"?

My understanding is that "srcversion" a kind of checksum of the
sources. I guess that it will be always the same for the sources.
I guess that it is not affected by the compiler or compiler options.

But build_id should be unique with each rebuild. It should be
afftected by the compiler or compiler options.

Note that the compiler options might affect how the functions are
opimized (inlining). And it might affect compactibility of the livepatch.

Best Regards,
Petr

