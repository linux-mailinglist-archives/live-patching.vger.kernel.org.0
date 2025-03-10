Return-Path: <live-patching+bounces-1267-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A629A58A65
	for <lists+live-patching@lfdr.de>; Mon, 10 Mar 2025 03:22:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14EF53A95F2
	for <lists+live-patching@lfdr.de>; Mon, 10 Mar 2025 02:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8468C1581F0;
	Mon, 10 Mar 2025 02:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H82QIkph"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A19145A18
	for <live-patching@vger.kernel.org>; Mon, 10 Mar 2025 02:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741573355; cv=none; b=h4DHNwzLXDDXLedcJrCxA5ah0VXh1gcF4lZXy0KDhok9yyudcnXqf4Yw23vlYcgjtXO3hv5Qtpey3dNTu7q0j1TO4AW0YIUZIpWbSSRhWKYw+T5yBSZcfodgyH9vtoFYsdjES4rOzvDJ094grQ3EK2RSqz6QxIGNfF0v6ufDJ60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741573355; c=relaxed/simple;
	bh=zCvqlbeE7nNq3wOaRu874oc915v4SBUfyD543CTrxpA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=Iyn1CwoO0fH/+ICe+lSIf41EZViGTnSpsxwlPy4haKV43K0UTwwVKH8T4RRMDcnRRqrKBA9XKV3IbVb2OkWWQD9GZRGLi4c4fOgS3bEOaEGqhdT9JWfvUHV5U99D08F8nSMwUUGUoEIEAE66RGOlomxYliN0sOgscri5ZHMMmws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H82QIkph; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22398e09e39so64034995ad.3
        for <live-patching@vger.kernel.org>; Sun, 09 Mar 2025 19:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741573353; x=1742178153; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YgVmFNdggz52GvGYTrOMQuvE+O9CkjIVbsWkED7Ngtw=;
        b=H82QIkphcyUzZgq3wBtrlDh8zIEx0za3B9xzjr8qlZmt2P3bxefgur/agBdu03NoDR
         6ni8vVuf2q2WASAQ1t9/IXcWFdqroK9Qjb5jTpaqUNa7JSh9ZefvFC7TM++wW+LEXvtG
         Su1+dBvYZpgVvmidNpXsgDmEjOjk4jjsEixfvJsbZYoPgL3DS+TIBSh0/ufWKu1FYDnV
         7+IrDoyGS8XJCJCZB2Mk8f4Nv6bk2q4iWWlAhh9so3jIPCW882Bf81VGvtaxKIhNy4Dq
         95ptJG86l9Lvh213PRk4oG9SPfVYR05oo8x9jyRVIJ1/xzib+dDPkBWHg6Q/AaQANAyD
         U7ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741573353; x=1742178153;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YgVmFNdggz52GvGYTrOMQuvE+O9CkjIVbsWkED7Ngtw=;
        b=tSC02dbOykWs3iXLsnZmX1Wm7oyEsUyA5LMSs9J4u0iTj2+TG0Z+t8H1/He4aa2vyj
         IR0GcJ2N2O80dYKYH5QGprRYm9D8udesbx/4PcinigT2HY23a3WujKSPIb36oIYBUrYu
         aHd/8jGKX6cDF92o0gCJmqn+Igwt+SHb+zoAtCYNh310uTQthGgorpiqxO26HvJhBQiH
         gALJS/Xz3D1/oWjBzqsKOYK25t1kwzkRpEeyk5PFfQAtkSaOWicMBtJOgucf61NtlY21
         bg+KJdoGaJtIlA3Uxy2pTk0YnEEqHnpki+jfarL2SWgGQFqzyR5Gh340fi09H4r8xLAJ
         vFTw==
X-Forwarded-Encrypted: i=1; AJvYcCVcWLVsi3rHg36iY4ezvfpa5xgHYeKTeMnzAlmCbDrdAXrYHej9tA5VhwM/B67Zm2vxPU/4obpx2Rhemh7L@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8r8yobj8dasMku2dNw6++LYnVjOWQpPxwWaq0eeEtJWAoRYwO
	8n2509KSrThPQQ819hFRJUGqwFi+fX3gMqDN6P0QvmI0DN6T7Q/u
X-Gm-Gg: ASbGncvSlUXji0bd2Ip7tp6hw/wqt5oBg6QpQ67E5u2dQ8njl4qPqxIytPQ18VLOdvK
	VJz2b5i/JfHPCqd8FEDlMDMstX0YTAeuscomIoKLI1OSbqeqPx/nTjN8fl4KjRTd4hpCQih3/P4
	J60wuW6TVPKJuIYPT+DgziDAR3Jz3gm1rcHRluLGEhIHoom3L4MjAG+NIyPuKh+CVenXEu95NrS
	f7PDpzWiFos0JltxthoJKU7TS94tAT9/MCJI3M5sO4PFx8uI0QV88O3Kslk8OuPDNTohSNlklLH
	qTiFUbMBvCbssS4avLg87M6C9EBTMM8X+DhLryWXbPJGFyECFQ76iL4kUUDK940F6A==
X-Google-Smtp-Source: AGHT+IF6KHMXTRiP8gsXXTaznICmXQpLIdvcfHnAbv3OhawLfSIuIdCDWWd+62TzdrYndDosLRWcCg==
X-Received: by 2002:a05:6a00:928b:b0:736:4d44:8b77 with SMTP id d2e1a72fcca58-736aaa1cf9fmr23157698b3a.8.1741573352961;
        Sun, 09 Mar 2025 19:22:32 -0700 (PDT)
Received: from smtpclient.apple ([205.204.117.126])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736c14cc7b9sm3322352b3a.140.2025.03.09.19.22.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Mar 2025 19:22:32 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [RFC] Add target module check before livepatch module loading
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <Z8r6AKBU4WPkPlaq@pathway.suse.cz>
Date: Mon, 10 Mar 2025 10:22:19 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3524E557-77AD-427C-82BA-6CA06968AC5B@gmail.com>
References: <C746373C-96ED-47EE-94F2-00E930BE2E8B@gmail.com>
 <Z8r6AKBU4WPkPlaq@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi, Petr!

> The work with the elf sections is tricky. I would prefer to add
> .srcversion into struct klp_object, something like:
>=20
> struct klp_object {
> /* external */
> const char *name;
> + const char *srcversion;
> struct klp_func *funcs;
> struct klp_callbacks callbacks;
> [...]
> }
>=20

In fact, I have a though in mind that we can easily use the=20
srcversion in `struct module` like:

struct module {
    enum module_state state;

    /* Member of list of modules */
    struct list_head list;

    /* Unique handle for this module */
    char name[MODULE_NAME_LEN];

#ifdef CONFIG_STACKTRACE_BUILD_ID
    /* Module build ID */
    unsigned char build_id[BUILD_ID_SIZE_MAX];
#endif

    /* Sysfs stuff. */
    struct module_kobject mkobj;
    struct module_attribute *modinfo_attrs;
    const char *version;
    const char *srcversion;
    struct kobject *holders_dir;

    /* Exported symbols */
    const struct kernel_symbol *syms;
    const u32 *crcs;
    unsigned int num_syms;

becase when we are loading a livepatch module, the syscall `init_module`
will be called and we can check the srcversion here.

What I want to do in the elf section is that I want to add a new section
to store the target module src version inside.=20

> It would be optional. I made just a quick look. It might be enough
> to check it in klp_find_object_module() and do not set obj->mod
> when obj->srcversion !=3D NULL and does not match mod->srcversion.
>=20
> Wait! We need to check it also in klp_write_section_relocs().
> Otherwise, klp_apply_section_relocs() might apply the relocations
> for non-compatible module.
>=20

As previously mentioned, if we can check the srcversion when calling
the syscall `init_module`, refuse to load the module if the livepatch
module have srcversion and the srcversion is not equal to the target
in the system. Can it avoid such relocations problem?

> Another question is whether the same livepatch could support more
> srcversions of the same module. It might be safe when the livepatched
> functions are compatible. But it would be error prone.
>=20
> If we wanted to allow support for incompatible modules with the same
> name, we would need to encode the srcversion also into the name
> of the special .klp_rela sections so that we could have separate
> relocations for each variant.
>=20

I am not sure if supporting more srcversions is necessary. Because=20
I can't find a senario that more than one version of a module are =
running
in the system at the same time.

>=20
> Alternative: I think about using "mod->build_id" instead of =
"srcversion".
> It would be even more strict because it would make dependency
> on a particular build.
>=20
> An advantage is that it is defined also for vmlinux,
> see vmlinux_build_id. So that we could easily use
> the same approach also for vmlinux.
>=20
> I do not have strong opinion on this though.
>=20

Petr, using "mod->build_id" instead of "srcversion" may not be good.
Because livepatch can not only handle the function in vmlinux but also
the function in modules.

=46rom my point of view, each build will have a different srcversion =
generated.
Is it necessary to introduce a "mod->build_id"?

>=20
>> This function can avoid livepatch from patching the wrong version of =
the function.
>>=20
>> The original discussion can be seem on [1]. (Discussion with Joe =
Lawrence)
>>=20
>> After the discussion, we think that the actual enforcement of this =
seems like a job for kernel/livepatch/core.c.
>> Or it should be the process of sys call `init_module` when loading a =
module.
>>=20
>> I am here waiting for Request For Comment. Before I do codes.
>=20
> I am open to accept such a feature. It might improve reliability of
> the livepatching.
>=20
> Let's see how the code looks like and how complicated would be to
> create such livepatches from sources or using kPatch.
>=20
> Best Regards,
> Petr

Thanks, Petr. And I will start to code the draft soon. If you have any =
suggestions, please be
open to tell me :)

Best Regards=20
Wardenjohn




