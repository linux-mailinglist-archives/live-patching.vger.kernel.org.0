Return-Path: <live-patching+bounces-1453-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CEECCAC152C
	for <lists+live-patching@lfdr.de>; Thu, 22 May 2025 22:02:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 683D34A71BF
	for <lists+live-patching@lfdr.de>; Thu, 22 May 2025 20:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1B0188713;
	Thu, 22 May 2025 20:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aC9Khox7"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87833234
	for <live-patching@vger.kernel.org>; Thu, 22 May 2025 20:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747944143; cv=none; b=kWt7mGk34fEWKJdWHorggB011bPziS3350ByEzrf1P0BThpkHmZzCulX1emG+QgjDipPQytJWwKxiXS1xBe39FJCz8B0sbruRAqUDOwgoU86/tt2+BqY2j6PCE+C87RadE9Ul6ULq0p1CAv/YdO+Iqa1gFDyXQZRFl+9j0jplHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747944143; c=relaxed/simple;
	bh=8IJvB9beb+r+MxI+EXR5zieblC1Zn7nGymkkexuE6yk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=idOuAGRRe2VIPcYHCBQWQKnreezMSJsehEZgbUJbEwftaWoruenm0ag0Dtboq5splmIqGVFF3oxWhjWVUFXF6cpVkks+aSElJT+TpRGLBE5491EjhvR3evzA4p0M2NWa9dmq9NMBN0sCve474gjr+88GuMx/fxisBy5PDu3rhHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aC9Khox7; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7c55500d08cso922107685a.0
        for <live-patching@vger.kernel.org>; Thu, 22 May 2025 13:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747944140; x=1748548940; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XYtEiOvOJY+FaEu+fbVRhtpVNQYUEghdyi9GI75aP8I=;
        b=aC9Khox7w0FFNQDArZa47rQPNxRhtcwI9v2zrb2lew4VPDzi/wMa0hfkzRN5fTT70g
         vC1Q1JcrsQc2+mTIRmGjPmoMMa7dyRwtOkcbafqeWpl+2uJS96vVlfj07BPZNYmFr2Ro
         /ol1QHXawO1kwctEMD8JFz7hAXlLuTV1tdjzBZHhB/lfBJEdXE7I+0gaUMXxYEvW4iI9
         zxZFgpmAsVtvKQKvRIEWqjGz+KHuXgEZWUeu1XanAdFcbzsaUHi6AI5r6AqyYz3DxAVT
         OgJ2oVucyh9YqRNWuXN1cdLEO0pE7K48HfonVNiIftoY6MLXzuSqWC01mJQK13tFXclN
         c1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747944140; x=1748548940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XYtEiOvOJY+FaEu+fbVRhtpVNQYUEghdyi9GI75aP8I=;
        b=MvE/0+4XVDINT92egHbauz/VeIVIMC6wg0anmfZcu417I7pM62KhORsC/o0FOHRmY/
         j7VpHtvFKtlsMaZO+my+22R8EnlwZaFdMi3TAkfveHXrxUOc7hCBdd9LtwXSSS229Fy5
         lgEpfRogEuZx4o/S+SjtsmzCFXvrBQxcZ7ykM/CyzgWELCjO1tlZShN3OpNYm3vZpdmp
         Sl9XJo+YTOgpd3WCVjXE5Q1EKNeNJYwWptCXSwL/bWdhhLFul9dIgijL1VzbVJA1GyKl
         RIxSbYvmETj/Byoeq7BDeRsF6JMhzgoC+4LMnbrlRtBOq2RhDrJ/e16fsJtnlinQG8Od
         Us3g==
X-Forwarded-Encrypted: i=1; AJvYcCWdysTwtPoYX7kbW5Y5qRDAVoNAcGEw2UjlNqflVxmLnrqjIRJIdASCcQR1cfzfRq41I8oX1EqPgQf+Vu1K@vger.kernel.org
X-Gm-Message-State: AOJu0Ywps9lipggEKfsVsY01hSrkNeu+fr3lWwe3WouLQx74DCo0ZSkt
	6pS5IZbZdbIWWMWpQwHJOHeRMvPJ1Xsjsh0TZmMaIVzNRHWRlme3hXX2+82SnoC2me0YIa+PJh0
	NbX4OqheDWMeDCTcSXV5jQNwqK4bTe0ImYQeq/Du5C8w0UKcBNa44KgFRcn1z3Q==
X-Gm-Gg: ASbGnctTohVe04ULEjj6g3KzrDdBm8dbTFLi3yW4Y/4S4NZMAr0RJOgI2EEkdnqd15H
	y6QuH7pi3T4bflip4xT7+xSCsNf/3jXaDWPAFLkf59iLv1FLTv4nwFgTTATkcHqobrdQceH/99d
	Cqaht50ZVfXEef1UqzRoio4k8xZIwrRjJNL4H2vttK2vs=
X-Google-Smtp-Source: AGHT+IEucfGw+409TlEusjP+6OlYVzLfhDBZdAG6SCdZYc8C7RdAhMQVE8YivqBkAZo+MIZeaLcFh1on0ea/ipIcJmE=
X-Received: by 2002:a05:6102:3ca8:b0:4bb:623:e1f7 with SMTP id
 ada2fe7eead31-4dfa6c61bdemr24828235137.16.1747944129793; Thu, 22 May 2025
 13:02:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522184249.3137187-1-dylanbhatch@google.com> <20250522184249.3137187-3-dylanbhatch@google.com>
In-Reply-To: <20250522184249.3137187-3-dylanbhatch@google.com>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Thu, 22 May 2025 13:01:58 -0700
X-Gm-Features: AX0GCFvfkzpEu5JGWQRB8yIzUnMv-s4h5bh4PH9PmaEgpJEyTdBLcPIDEBaSofI
Message-ID: <CADBMgpxiQMGZpdqxc5ejeuhowUVNWiDqx=BVmRQEWxkn1+WXHA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] arm64/module: Use text-poke API for late relocations.
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>, 
	Joe Lawrence <joe.lawrence@redhat.com>
Cc: Song Liu <song@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Peter Zijlstra <peterz@infradead.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2025 at 11:43=E2=80=AFAM Dylan Hatch <dylanbhatch@google.co=
m> wrote:
> -static int reloc_data(enum aarch64_reloc_op op, void *place, u64 val, in=
t len)
> +static int reloc_data(enum aarch64_reloc_op op, void *place, u64 val, in=
t len,
> +                     struct module *me)
>  {
>         s64 sval =3D do_reloc(op, place, val);
>
> @@ -66,7 +69,11 @@ static int reloc_data(enum aarch64_reloc_op op, void *=
place, u64 val, int len)
>
>         switch (len) {
>         case 16:
> -               *(s16 *)place =3D sval;
> +               if (me->state !=3D MODULE_STATE_UNFORMED)
> +                       aarch64_insn_set(place, sval, sizeof(s16));
> +               else
> +                       *(s16 *)place =3D sval;
> +
>                 switch (op) {
>                 case RELOC_OP_ABS:
>                         if (sval < 0 || sval > U16_MAX)
> @@ -82,7 +89,11 @@ static int reloc_data(enum aarch64_reloc_op op, void *=
place, u64 val, int len)
>                 }
>                 break;
>         case 32:
> -               *(s32 *)place =3D sval;
> +               if (me->state !=3D MODULE_STATE_UNFORMED)
> +                       aarch64_insn_set(place, sval, sizeof(s32));
> +               else
> +                       *(s32 *)place =3D sval;
> +
>                 switch (op) {
>                 case RELOC_OP_ABS:
>                         if (sval < 0 || sval > U32_MAX)
> @@ -98,8 +109,10 @@ static int reloc_data(enum aarch64_reloc_op op, void =
*place, u64 val, int len)
>                 }
>                 break;
>         case 64:
> -               *(s64 *)place =3D sval;
> -               break;
> +               if (me->state !=3D MODULE_STATE_UNFORMED)
> +                       aarch64_insn_set(place, sval, sizeof(s64));
> +               else
> +                       *(s64 *)place =3D sval;           break;
>         default:
>                 pr_err("Invalid length (%d) for data relocation\n", len);
>                 return 0;
> @@ -113,7 +126,8 @@ enum aarch64_insn_movw_imm_type {
>  };

Don't merge this. I spotted an issue -- for the data relocations this
looks like an incorrect usage of aarch64_insn_set(). An updated
version will follow soon.

Thanks,
Dylan

