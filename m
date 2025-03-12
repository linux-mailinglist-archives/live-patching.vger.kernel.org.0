Return-Path: <live-patching+bounces-1272-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13A19A5D4B0
	for <lists+live-patching@lfdr.de>; Wed, 12 Mar 2025 04:17:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8909189D9A8
	for <lists+live-patching@lfdr.de>; Wed, 12 Mar 2025 03:17:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E984D155C96;
	Wed, 12 Mar 2025 03:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1VSJvVc"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644F4208A7
	for <live-patching@vger.kernel.org>; Wed, 12 Mar 2025 03:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741749461; cv=none; b=W+9FwMYolLMQT0eIijDopfV7DYMUmm8q9dnIYwNRG5sc/gJxBfJO6aiSPEd+2xfyuyzfp0ZxqmogtAANQHUtVxaDB5ItXisQ5HIDQXdGPXvLZA+1sHOZaJE9S8bT5Ex6HWarGj/0p7YIfNcuVIBiSe/f5PUyTCjZGL8eIU7MPQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741749461; c=relaxed/simple;
	bh=HpWJ/59NCnYSId4RH1/ZtxJeb4s8bIUM78tABQGI0Fs=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=jUc+qVJUbbI16FnnGqcsgdYqd/MMZtXh9aJRGgaaozwWi6p5cCNo3sqjV+6ftGP4vExGn5UGwYjZyz6o4Aj9fAUuVlTlQg8z3uq96JMZGTnmZUTLAkD5lcEh5DdsQGIDHhbzQmGJnEKLLhqXp07IJwDcEgfO6VysilnrMInfy9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V1VSJvVc; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2fef5c978ccso9409084a91.1
        for <live-patching@vger.kernel.org>; Tue, 11 Mar 2025 20:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741749459; x=1742354259; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bguHidrSSuKxiVcQ5EMCLXuk1P3NqWkwDP0LparcwyE=;
        b=V1VSJvVctiRyPhLdsjT89PNnm4mFBfnyQpolsywKQD0mx4UshVhzC6HtyOiw0ZFMar
         RJBcLAnt3VRgBc2YDuKnwFWRmV0OQ+23Y+yUqFJN9jNTdZrt6bOruJX5kZGdkikV9Cr/
         +wH6QGHRW/QSFpXf+q7da5VJr9CET6Pi0zir3UhIw0UmC8M0G+CjdBT8/8je/rW7eic7
         cuM6OYNBgs0bIhWEB+6j6Os3BVhUrMqnCDY6Mt3fQ59fOq5xyZzWE5gPfYqe/UY9vJaG
         WjBvf3Dc+CfbH2AfjQrNsmJ9VT6rwb7D73yImQzGpBgZXJ+cteSOBYikY2aP8Ii8bTXM
         hlRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741749459; x=1742354259;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bguHidrSSuKxiVcQ5EMCLXuk1P3NqWkwDP0LparcwyE=;
        b=aCxSrcZwgi7igt+6WQ6GXq6l7Flb9XIpnQWrxAGAmU0Tvag+rFfuFzv37iCj/j+r9o
         9glrZEc5/5ilqHVxHnUAVhBaTOdxJxXBX/zLohl2LfxovI9+I28c5u9xdq9kmf3WdPTg
         iLfEGnATUpPP60rjTBLTM+1lq4sc+CJTJCJnMlFYwjhlGZBbD23/fQyMVSwIJh1tSk0e
         rllLfziFvzSMN/baLqARBYU2VW1tmVfDzexYsfgyFFSBNPCgnanBk5AmMlZztRF/KqBz
         LeOGsNLlUq/AH4pvv/J3gd0cSm4vodN7/huSe8YkXOMQQXYSnIBdiZE6BMUIcVh6vEyH
         OVxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGHws4g0W/UKUb5Sc7dku0ABXTH1eDC9PoKyjEtWKxLxZ9nc534Gg1wb5rF6JZD5ofXthRvB0tdh5aNpe/@vger.kernel.org
X-Gm-Message-State: AOJu0Yyam94Gy6aelpBuBzOP7rWCjE1/QwD6yxmGr3qYADK1OgtIIQWT
	R1+xog5F1FG+SMiaNgVvZF6I6qX8YU3Plfe81T2f+16lldlKzd7p
X-Gm-Gg: ASbGncv5Br/UUIfrnWiFgSgDgeI2+Fd6ILQyJBggfUZY57V3aimc/5PT3NuEL3dwz3R
	VRGvDF+SdNoEGS8Om0xWmPbwTUb6v40mpR7lcFSSiwkKaD8c+rUBn42yk1X79u+fPQ85kbSt0T5
	9vPm4PijXAvM7ZyXQ3SbHg/C2uwHJABvPhApgOG4q5S4lQC8eqHk5IlqLV+eBHxypFUPrfKpvN9
	3gzXgwtTWl8t8Uah/jiL/UrdENVFV7Y5i6WG8TUbcN3ze2/mw1gEBhpvnacjGtUsqa+S1UAv60r
	h67VwnV9BLCzDKMjKy8OEES98MyD3+5tEukK+daBlrIhzjizdbW8vRkkrIyFYKvykw==
X-Google-Smtp-Source: AGHT+IG9CDMu04NSXi6PA26pknEMpmCNnSbwq9XA31GT4JSDdc5XfffZdctthNlXJIcMgpRTgjKWOQ==
X-Received: by 2002:a17:90a:a009:b0:301:1d03:93cd with SMTP id 98e67ed59e1d1-3011d039a52mr564659a91.24.1741749459321;
        Tue, 11 Mar 2025 20:17:39 -0700 (PDT)
Received: from smtpclient.apple ([205.204.117.120])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3011824b998sm510080a91.25.2025.03.11.20.17.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Mar 2025 20:17:38 -0700 (PDT)
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
In-Reply-To: <Z9ArueBi3cd3OLEo@pathway.suse.cz>
Date: Wed, 12 Mar 2025 11:17:25 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0742313B-8C99-4B70-A940-C6A1018F95C5@gmail.com>
References: <C746373C-96ED-47EE-94F2-00E930BE2E8B@gmail.com>
 <Z8r6AKBU4WPkPlaq@pathway.suse.cz>
 <3524E557-77AD-427C-82BA-6CA06968AC5B@gmail.com>
 <Z88JxGTGMcBEeHVP@pathway.suse.cz>
 <911AD123-9CA6-405A-8D63-6F0806C12F84@gmail.com>
 <Z9ArueBi3cd3OLEo@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Mar 11, 2025, at 20:25, Petr Mladek <pmladek@suse.com> wrote:
>=20
> On Tue 2025-03-11 11:53:59, zhang warden wrote:
>>> A single livepatch could modify more objects: vmlinux and several
>>> modules. The metadata for each modified object are in "struct
>>> klp_object". The related obect is currently identified only by =
obj->name.
>>> And we could add more precision identification by setting
>>> also "obj->srcversion" and/or "obj->build_id".
>>>=20
>>=20
>> Yep, but how can we get the obj->srcversion? If we tring to store it=20=

>> in klp_object, the information should be carried when livepatch is =
being build.
>> Otherwise, we don't know which srcversion is good to patch, isn't it?
>=20
> I am not sure if I get the question correctly.
>=20
> Anyway, struct klp_object must be defined in any livepatch, for =
example, see
> /prace/kernel/linux/samples/livepatch/livepatch-sample.c
>=20
> I guess that you are using kPatch. I am not sure how it initializes
> these klp_patch, klp_object, and klp_func structures.
> But it has to create struct klp_object for the livepatched module
> and initialize at least .name, .func items.
>=20
> The srcversion of the livepatched module can be read by modinfo,
> for example:
>=20
> # modinfo test_printf
> filename:       /lib/modules/6.13.0-default+/kernel/lib/test_printf.ko
> license:        GPL
> description:    Test cases for printf facility
> author:         Rasmus Villemoes <linux@rasmusvillemoes.dk>
> test:           Y
> srcversion:     AF319FC942A3220645E7E99
> depends:       =20
> intree:         Y
> name:           test_printf
> retpoline:      Y
> vermagic:       6.13.0-default+ SMP preempt mod_unload modversions=20
>=20
> You need to teach kPatch to read the srcversion of the livepatched
> module and set it in the related struct klp_object.
>=20
> Best Regards,
> Petr

Oh,yeah.

You got the point. I am using kpatch[1] as userspace tool to build =
livepatch
module. Therefore, I am focusing on combining kPatch and kernel.

So, I need to teach kpatch module to learn the srvcversion, that's why=20=

I am trying to put srcversion into elf file. This elf file I mentioned =
is the=20
livepatch module built by kPatch.

So, maybe now you can understand why my livepatch module miss the =
information
of the target srcversion. Because this livepatch module is built by =
kPatch, not building
it manually.

But now I think I have a mistake here. I should focus on the kernel =
first. And then,
 make adjustment to kpatch[1] after this feature is ready in kernel.

Regards
Wardenjohn

[1] kpatch: https://github.com/dynup/kpatch=

