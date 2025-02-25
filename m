Return-Path: <live-patching+bounces-1224-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A69BA431C2
	for <lists+live-patching@lfdr.de>; Tue, 25 Feb 2025 01:14:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 798693AE480
	for <lists+live-patching@lfdr.de>; Tue, 25 Feb 2025 00:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB32436D;
	Tue, 25 Feb 2025 00:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSXg4Hv3"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5A8EC0;
	Tue, 25 Feb 2025 00:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740442450; cv=none; b=YnI9W4fDztOnRdusn5jhonympxbhI7KSuDvIqxsv76qFyzn3BTv4FyKT6YE50kv6Z+BxeZHjLC+o7XkLIrdpOMiwXfKIpwwIs6EYqR56mbJHRkka3f7W5Zt2TAwcnHX1Om0gDUV7p9gMT23HZpEOkGFs74pQk0u1Vfke+qgbujo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740442450; c=relaxed/simple;
	bh=RrjZywtok7pmqjRXq+52Mw3aIZaqlkmt827OKazuRN8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xy+mLPr2bnlK6bJRZayOYllshRH9DYTrRyOnXL+l1oF4MXSSNAFF8PW+T5ON7M2Ad6PCnPPm3ffyx1aofJlmE9b2q9gK02TbthuKLhMw5eHym2z1O+3qbBkApaDHOXZwyviIcA4dRNg9CCejDKj7bssiPbNzbsVhQc24Zix8gKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JSXg4Hv3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA89C4CEEA;
	Tue, 25 Feb 2025 00:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740442450;
	bh=RrjZywtok7pmqjRXq+52Mw3aIZaqlkmt827OKazuRN8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JSXg4Hv3hAgWNZiLAcLwodBsvL355TD9HhBuHHgJxH64OhFw6QwjwpJi5/sRd2hnE
	 bacx8UiqoRurkn5hnZjOe9ZkV3pcMJ1r5E1GbmEO0RuOgK9gKQFFWy8OEA2R/3C/Zz
	 OsxVw8lNacqv2tIViGLMII/Tr1Pgfmky/feOJfXW3L76HFNGzBUJl5VvF+7tABbW4l
	 SOkj6z6zrqAIe+S+ZkMZpcZcC1RQ59Ovi9r76EZme/hVAUn60+35VQzQEIKbJTIcVg
	 tEniDvRB761XJK2VrxWbzz9ZrIH1WnT36lmUUlgsGcjut7uRal2T2dKXPi/CvX5F87
	 82qwpNiXaZuUw==
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-855d73856f3so347941539f.1;
        Mon, 24 Feb 2025 16:14:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUb8rPJ1/N9aO7tjvv2En3cfQVoQfPPxClvprG/l5RbN0sSeQ2vyIGWvXgskDnoKkGnNsAFp1fBUQhRTFFNFA==@vger.kernel.org, AJvYcCV/F7ZjbazXAovT5iCkBbHC8KlrcSxurz1yCUmFgOWeZUEIU2in6TQ3N/+qXNk8EoBjrR6SEeBmh/O1KF+xSsSRtA==@vger.kernel.org, AJvYcCX6p9BR2R4RQ8KHJXppywrSBx+TbsocnOqv7ACk2TozqFZ1mwhnyBs/NRUUnhZix+LmK9x2B2ZV0e1yMsc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5dgqpOFKSceFZJJeM3Y+/QREDCcLPGMFagdf9GI882OPZ86YK
	YLCOR5LrW2KHBH989n17AMLj3azR3EZL62d5uFpy08WUnxuqqQlAeU4VGA8i+lYrHgt9ov16On6
	7Dmr6A8EeUJpKgftZpFHLsicoDNU=
X-Google-Smtp-Source: AGHT+IEGfSMvQhcmxe+D0QwBwqdzpgzsf7C3s6D4Gjai2KF9IRKGDa/39Olkwm6B0VNAodvYcGSMocV0IYhoCmStwQE=
X-Received: by 2002:a05:6e02:148e:b0:3d2:b7b6:e80d with SMTP id
 e9e14a558f8ab-3d2fc0c54a4mr18692795ab.3.1740442449607; Mon, 24 Feb 2025
 16:14:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPhsuW6dxPtgqZaHrZEVhQXwm2+sETreZnGybZXVKYKfG9H6tg@mail.gmail.com>
 <20250214193400.j4hp45jlufihv5eh@jpoimboe> <CAPhsuW6q+yhn0pGQb0K+RhXHYDkjEgomZ2pu3P_MEeX+xNRe0g@mail.gmail.com>
 <20250214232342.5m3hveygqb2qafpp@jpoimboe> <CAPhsuW48h11yLuU7uHuPgYNCzwaxVKG+TaGOZeT7fR60+brTwA@mail.gmail.com>
 <20250218063702.e2qrpjk4ylhnk5s7@jpoimboe> <CAPhsuW5ZauBrSz11cvVtG5qQBfNmbcwPgMf=BScHtyZfHvK4FQ@mail.gmail.com>
 <20250218184059.iysrvtaoah6e4bu4@jpoimboe> <CAPhsuW4pd8gEiRNj920kO8c4JuEWoXT=MhFK-nWvJZ9QseefaQ@mail.gmail.com>
 <CAPhsuW57xpR1YZqENvDr0vNZGVrq4+LUzPRA-wZipurTTy7MmA@mail.gmail.com>
 <20250220182221.vdmmnoyvc2do5mnn@jpoimboe> <CAPhsuW53DK2vFH-BZeUYN-eythX3NQEbcxrYf6jvBDtDmctRgw@mail.gmail.com>
In-Reply-To: <CAPhsuW53DK2vFH-BZeUYN-eythX3NQEbcxrYf6jvBDtDmctRgw@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Mon, 24 Feb 2025 16:13:58 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5Codoe2NViZJRE4JjM2Qc_v-qPzKZ1vOyr+9Oi0CxpAQ@mail.gmail.com>
X-Gm-Features: AWEUYZlhFxBXD7xdQSvghIzbkdQB4xbhvgY6aZ3jRtXIkzKgZAdiM9UvB5WldRw
Message-ID: <CAPhsuW5Codoe2NViZJRE4JjM2Qc_v-qPzKZ1vOyr+9Oi0CxpAQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] unwind, arm64: add sframe unwinder for kernel
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Puranjay Mohan <puranjay@kernel.org>, Weinan Liu <wnliu@google.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Indu Bhagat <indu.bhagat@oracle.com>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, roman.gushchin@linux.dev, 
	Will Deacon <will@kernel.org>, Ian Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	joe.lawrence@redhat.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2025 at 10:33=E2=80=AFAM Song Liu <song@kernel.org> wrote:
>
>
> On Thu, Feb 20, 2025 at 10:22=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.=
org> wrote:
>>
>> On Wed, Feb 19, 2025 at 08:50:09PM -0800, Song Liu wrote:
>> > Indu, is this behavior (symbols with same name are not in
>> > sorted order from readelf -s) expected? Or is this a bug?
>> > I am using this gcc:
>> >
>> > $ gcc --version
>> > gcc (GCC) 14.2.1 20240801 (Red Hat 14.2.1-1)
>> > Copyright (C) 2024 Free Software Foundation, Inc.
>> > This is free software; see the source for copying conditions.  There i=
s NO
>> > warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PUR=
POSE.
>>
>> Are you using different binutils versions as well?
>
>
> I am using binutil 2.41, for both gcc -11 and gcc-14.
>
>>
>> It sounds like a linker "issue" to me.  I'm not sure if it qualifies as
>> a bug, the linker might be free to layout symbols how it wishes.
>
>
> We can probably handle that in kpatch-build.

OK, something like the following gets the proper sympos for
gcc-14 built kernel.

Thanks,
Song


diff --git i/kpatch-build/lookup.c w/kpatch-build/lookup.c
index bd2b732de910..87ac127184c5 100644
--- i/kpatch-build/lookup.c
+++ w/kpatch-build/lookup.c
@@ -479,13 +479,10 @@ static bool lookup_local_symbol(struct
lookup_table *table,
        struct object_symbol *sym;
        unsigned long sympos =3D 0;
        int i, in_file =3D 0;
+       bool found =3D false;

        memset(result, 0, sizeof(*result));
        for_each_obj_symbol(i, sym, table) {
-               if (sym->bind =3D=3D STB_LOCAL && !strcmp(sym->name,
-                                       lookup_sym->name))
-                       sympos++;
-
                if (lookup_sym->lookup_table_file_sym =3D=3D sym) {
                        in_file =3D 1;
                        continue;
@@ -499,20 +496,29 @@ static bool lookup_local_symbol(struct
lookup_table *table,

                if (sym->bind =3D=3D STB_LOCAL && !strcmp(sym->name,
                                        lookup_sym->name)) {
-                       if (result->objname)
+                       if (found)
                                ERROR("duplicate local symbol found for %s"=
,
                                                lookup_sym->name);

                        result->objname         =3D table->objname;
                        result->addr            =3D sym->addr;
                        result->size            =3D sym->size;
-                       result->sympos          =3D sympos;
                        result->global          =3D false;
                        result->exported        =3D false;
+                       found =3D true;
                }
        }
+       if (!found)
+               return false;

-       return !!result->objname;
+       for_each_obj_symbol(i, sym, table) {
+               if (sym->bind =3D=3D STB_LOCAL &&
+                   !strcmp(sym->name, lookup_sym->name) &&
+                   sym->addr < result->addr)
+                       sympos++;
+       }
+       result->sympos =3D sympos;
+       return true;
 }

 static bool lookup_exported_symbol(struct lookup_table *table, char *name,

