Return-Path: <live-patching+bounces-1474-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 15072AC752C
	for <lists+live-patching@lfdr.de>; Thu, 29 May 2025 02:47:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CAAA34E80F8
	for <lists+live-patching@lfdr.de>; Thu, 29 May 2025 00:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4F141482E8;
	Thu, 29 May 2025 00:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UwD3waOm"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083B752F99
	for <live-patching@vger.kernel.org>; Thu, 29 May 2025 00:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748479642; cv=none; b=F7g3RBB2wkfujZ5xF/rhBVnBpJ8Rngsl4zlvMFvkXVgnQXmlq7lsK5XJNM7yJv9Lsh0/QR90lZTWX1MNTDE/rKWQiKOYIlRWQwOjQJs7fKBUiB2dAyHJ3kZ7PEMd00WRWKB0YpX/PTqAam/O/EKFcJlBdPymVr3yKeLfsJM/n40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748479642; c=relaxed/simple;
	bh=nMxYb8M8OaAeVFAVvCa0NWPJ0hqSKxbRHfrVdZuONdA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r7Dt2m1G7mEnHF7o6D6LfX9xMW5Rvdbo/0M0EoMDsnDcvqmjmqLBcAJXWJPu3T6mnJDtBkDD23BtJymODbFcHKi+n3uPmdkkPe7ot18GjxvNgsjoFrEN4iWM3bwW+oPanIGWJ0HAekarS8kZy5N4LEBNi/KKE1A3SYFsI38yBn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UwD3waOm; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-4c34dcdaf88so110129137.2
        for <live-patching@vger.kernel.org>; Wed, 28 May 2025 17:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748479640; x=1749084440; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NcJSuZLlEiXXGQNoUX9py5aoN4tofONoEJKG7XFVq38=;
        b=UwD3waOmApEZO6iDEVTS07SrZJlEYSmPbic+sE0mI7fvinHYunNHcp+dB3uiOcZ+BE
         Cobsv+0nGZ4T8AfRabNeF2zjZYH4C3zlUYTxHs+aABdtfzxtCKw5OzRRYPJPifJgGiqP
         T8dURJL+To7g5kCe6b755s7MPI6tWy272W2KwAjN0IpnJ+RS5HZzCxSE9Wpv3xk5NSCT
         DbPUN/ZCOM+Tak/xyESh5CKVmE86f5alYksqo0FbvuhBFMAZRo+co0eyWcBzhnP99kn/
         ZVmdsn/dtROh2hjXchNr9NlTakRP2l1iKlAz3Wd6sWyCJP7qqTwb/8JU++ltqN/5RNcp
         Ztbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748479640; x=1749084440;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NcJSuZLlEiXXGQNoUX9py5aoN4tofONoEJKG7XFVq38=;
        b=WHKtwjCotLDrFSZoIQN/0nlbsuNC6nvD63o+UY7ncMKO5ek8oMHkw+MOvs8EayQ8Ny
         Muw7FQQP+GajiYayIz6XbYoXMNrKs9vd+vtR8NECJ+zEdIg1X7Zy1j50Stf3CBId+5Ht
         e9DUF5Oi6jcZHIykCAIVpYxL1WO0DYVcj8IhgooZbEpK3jvPAtN+W75SOQWFdauhyZY8
         D0HIokE4GRnHRdY6mRW1FxwsgcJxpPCnoN8gKxUQ6TkdZl+49p9bHhOY7nCncK1pbu4f
         FHoKVWJUfY6rjqdZI0HvynknG+YI4hVTfvZxh+eFG3C1+DdK35dP92fJI0RldFmLGmki
         MwSw==
X-Forwarded-Encrypted: i=1; AJvYcCWBYmoLat/5+dxitUOuBu95c6gRs7qwxKx7ihXsB2k9+xXB0vE3dcBmtKUovtJY0u5YY4PV4TSMAnY1bfOk@vger.kernel.org
X-Gm-Message-State: AOJu0YxudZBhIK1NwjsBYpza7Awu+9jcFQHgPB4Rf1A1/JcxdRL8JLGK
	GCzzk1JKswhLY5hxI0tTi7EPjX+vsxYl1h+Qkl+rG4usw1N8BqYc1mNKVco+Pyw43vibMEgTeh6
	XOAF1Iv8TtiYMkDm3ueO3pprZn/f39tkFLIW+wf/2
X-Gm-Gg: ASbGncsk0YX/sgUqc4UUClrVnhKvw3zHtyo2vE6mhN7fbMFsJVXPEjTUFEvooAQS4Nd
	33fMfq2l3iGmuHVOGjnmlhzuBd4qV+QZKeczKC9VesEx0R55InoO9DTaoYyPlVOU5/xgUwcgXhD
	+aXdWJ1X32+sNNdLz4tnOzeRRnDpmvchtP/iHMM05Kvqo=
X-Google-Smtp-Source: AGHT+IEj9ymqfBXg6cFdB/Bj79VZBgVJSds2yTL3tVJMdz6WyDjPNGjPqLqwJ5g5XLlSN1N8famZpJNRS8BECNpItp4=
X-Received: by 2002:a05:6102:2c0f:b0:4e5:9628:9e39 with SMTP id
 ada2fe7eead31-4e59628a358mr6877728137.6.1748479639651; Wed, 28 May 2025
 17:47:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522205205.3408764-1-dylanbhatch@google.com>
 <20250522205205.3408764-2-dylanbhatch@google.com> <aDXQYMcLle2E_b2d@pathway.suse.cz>
In-Reply-To: <aDXQYMcLle2E_b2d@pathway.suse.cz>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Wed, 28 May 2025 17:47:08 -0700
X-Gm-Features: AX0GCFst9YoNtP29t3lkS_hoyCgFJvPQXD1R7QrZslaZlG-dM0idmAI4vCWSU-M
Message-ID: <CADBMgpzO36dP=bXQAL46_WnWZJK0TmdO9ZR5z6OBdvtXsHn4_g@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] livepatch, x86/module: Generalize late module
 relocation locking.
To: Petr Mladek <pmladek@suse.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>, Song Liu <song@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Peter Zijlstra <peterz@infradead.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>, 
	Toshiyuki Sato <fj6611ie@aa.jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Petr,

On Tue, May 27, 2025 at 7:46=E2=80=AFAM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> As this patch suggests, the "text_mutex" has been used to
> sychronize apply_relocate_add() only on x86_64 so far.
>
> s390x seems to rely on "s390_kernel_write_lock" taken by:
>
>   + apply_relocate_add()
>     + s390_kernel_write()
>       + __s390_kernel_write()
>
> And powerpc seems to rely on "pte" locking taken by
>
>   + apply_relocate_add()
>     + patch_instruction()
>       + patch_mem()
>         + __do_patch_mem_mm()
>           + get_locked_pte()
>

Reading through these implementations, I see that the serialization
happens only at the level of each individual write action. This is
equivalent to the patch_lock already used by aarch64_insn_copy() and
aarch64_insn_set(). I see now that this same serialization is achieved
by x86 using text_mutex, and that text_poke uses
'lockdep_assert_held(&text_mutex);' instead of grabbing the lock
itself, which is why only the x86 apply_relocate_add() currently takes
this mutex.

> I see two possibilities:
>
>   1. Either this change makes a false feeling that "text_mutex"
>      sychronizes apply_relocate_add() on all architextures.
>
>      This does not seems to be the case on, for example, s390
>      and powerpc.
>
>      =3D> The code is misleading and could lead to troubles.
>

My original intent with this change was to give the late relocations
on arm64 the correct synchronization with respect to other
text-patching code. From what you've shown above, it looks like the
[PATCH 2/2] should work fine without this change since the arm64
patching code already takes patch_lock.

>
>    2. Or it actually provides some sychronization on all
>       architectures, for example, against kprobe code.
>
>       In this case, it might actually fix an existing race.
>       It should be described in the commit message
>       and nominated for backporting to stable.
>

I hadn't really considered this. From what I can tell, kprobe is the
only non-arch-specific code that takes this mutex when touching kernel
text. Though my understanding of kprobe is very limited, I think there
could be a risk due to the late relocations for livepatch:

Suppose I apply a livepatch 'L' that touches some module 'M', but M
isn't currently loaded. Between check_kprobe_address_safe() and
__register_kprobe(), I don't see any check that would fail for a probe
'P' registered on a function inside L. So it seems to me that it's
possible for prepare_kprobe() on L to race with apply_relocate_add()
for L if P is registered while M is being loaded.

Perhaps more importantly, is it ever safe to kprobe an instruction
that hasn't yet received relocation? This would probably only be
possible in the case of late relocations for a livepatch, so maybe
this scenario was overlooked. I wonder if check_kprobe_address_safe()
can check for this case and cause the kprobe to fail, preventing the
above race condition from ever being possible.

In any case, synchronizing against kprobe wasn't the original intent
of this patch series, so in my opinion it makes sense to resend it as
a standalone patch (if it is to be resent at all).

>
> I am sorry if this has already been discussed. But I have been
> in Cc only for v3 and v4. And there is no changelog in
> the cover letter.
>

This patch was added to the series in v3, which is how you got added
to CC. Sorry about not adding a changelog, I'm still learning the best
practices for sending patches.

> > +
> > +     if (apply)
> > +             ret =3D apply_relocate_add(sechdrs, strtab, symndx, secnd=
x, pmod);
> > +     else
> > +             clear_relocate_add(sechdrs, strtab, symndx, secndx, pmod)=
;
> > +
> > +     if (!early)
> > +             mutex_unlock(&text_mutex);
> > +     return ret;
> >  }
>
> Best Regards,
> Petr

Thanks,
Dylan

On Tue, May 27, 2025 at 7:46=E2=80=AFAM Petr Mladek <pmladek@suse.com> wrot=
e:
>
> On Thu 2025-05-22 20:52:04, Dylan Hatch wrote:
> > Late module relocations are an issue on any arch that supports
> > livepatch, so move the text_mutex locking to the livepatch core code.
> >
> > Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
> > Acked-by: Song Liu <song@kernel.org>
> > ---
> >  arch/x86/kernel/module.c |  8 ++------
> >  kernel/livepatch/core.c  | 18 +++++++++++++-----
> >  2 files changed, 15 insertions(+), 11 deletions(-)
> >
> > --- a/arch/x86/kernel/module.c
> > +++ b/arch/x86/kernel/module.c
> > @@ -197,18 +197,14 @@ static int write_relocate_add(Elf64_Shdr *sechdrs=
,
> >       bool early =3D me->state =3D=3D MODULE_STATE_UNFORMED;
> >       void *(*write)(void *, const void *, size_t) =3D memcpy;
> >
> > -     if (!early) {
> > +     if (!early)
> >               write =3D text_poke;
> > -             mutex_lock(&text_mutex);
> > -     }
> >
> >       ret =3D __write_relocate_add(sechdrs, strtab, symindex, relsec, m=
e,
> >                                  write, apply);
> >
> > -     if (!early) {
> > +     if (!early)
> >               text_poke_sync();
> > -             mutex_unlock(&text_mutex);
> > -     }
> >
> >       return ret;
> >  }
> > diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
> > index 0e73fac55f8eb..9968441f73510 100644
> > --- a/kernel/livepatch/core.c
> > +++ b/kernel/livepatch/core.c
> > @@ -319,12 +320,19 @@ static int klp_write_section_relocs(struct module=
 *pmod, Elf_Shdr *sechdrs,
> >                                         sec, sec_objname);
> >               if (ret)
> >                       return ret;
> > -
> > -             return apply_relocate_add(sechdrs, strtab, symndx, secndx=
, pmod);
> >       }
> >
> > -     clear_relocate_add(sechdrs, strtab, symndx, secndx, pmod);
> > -     return 0;
> > +     if (!early)
> > +             mutex_lock(&text_mutex);
>
> I understand why you do this but it opens some questions.
>
> As this patch suggests, the "text_mutex" has been used to
> sychronize apply_relocate_add() only on x86_64 so far.
>
> s390x seems to rely on "s390_kernel_write_lock" taken by:
>
>   + apply_relocate_add()
>     + s390_kernel_write()
>       + __s390_kernel_write()
>
> And powerpc seems to rely on "pte" locking taken by
>
>   + apply_relocate_add()
>     + patch_instruction()
>       + patch_mem()
>         + __do_patch_mem_mm()
>           + get_locked_pte()
>
> I see two possibilities:
>
>   1. Either this change makes a false feeling that "text_mutex"
>      sychronizes apply_relocate_add() on all architextures.
>
>      This does not seems to be the case on, for example, s390
>      and powerpc.
>
>      =3D> The code is misleading and could lead to troubles.
>
>
>    2. Or it actually provides some sychronization on all
>       architectures, for example, against kprobe code.
>
>       In this case, it might actually fix an existing race.
>       It should be described in the commit message
>       and nominated for backporting to stable.
>
>
> I am sorry if this has already been discussed. But I have been
> in Cc only for v3 and v4. And there is no changelog in
> the cover letter.
>
> > +
> > +     if (apply)
> > +             ret =3D apply_relocate_add(sechdrs, strtab, symndx, secnd=
x, pmod);
> > +     else
> > +             clear_relocate_add(sechdrs, strtab, symndx, secndx, pmod)=
;
> > +
> > +     if (!early)
> > +             mutex_unlock(&text_mutex);
> > +     return ret;
> >  }
>
> Best Regards,
> Petr

