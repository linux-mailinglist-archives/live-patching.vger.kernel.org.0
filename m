Return-Path: <live-patching+bounces-2407-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id HpHjBQzT5mnt1AEAu9opvQ
	(envelope-from <live-patching+bounces-2407-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 03:29:48 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 67A9A435444
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 03:29:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 18A1A300C248
	for <lists+live-patching@lfdr.de>; Tue, 21 Apr 2026 01:29:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96ED5241686;
	Tue, 21 Apr 2026 01:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DA1Rf/ZG"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E877823F40D
	for <live-patching@vger.kernel.org>; Tue, 21 Apr 2026 01:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776734983; cv=pass; b=c9yEWmUg5LPxECGc/WwslwBr0VfmfXR7gZf2jMC6l9wudK0TlK7WIyPQT5rxtTr61Rpr7kPZnVL3C6hrskEv6ftBcG0QzUJmw/OZR0wBGFW04uET1CioGeIh4I+B0GmqHQsNc2ZtAX+2C5K/chO0jp6l/udzoEryOVmHbqR5dSw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776734983; c=relaxed/simple;
	bh=+LGW/ErEF4me0qtq4Pw0wU1fs3Oaa6yGJ38As49E5+U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=boDQngkJD10yC31XV0U+HW1qWJvRArLVlN/zTQSkFphx4bd4wtFJHKFY2DH15oHyTXkQwp1/NKFUV7w4l7HeZqomNe9Z20RY9jU0A4cU1hQC0g1ZV3YozxUwV8G/h5wX32v8/VKzjUrIpVJ2Tq4Wcf1tNz5a1XAoGSTvyW+4WZA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DA1Rf/ZG; arc=pass smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-6057723d553so2072549137.2
        for <live-patching@vger.kernel.org>; Mon, 20 Apr 2026 18:29:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776734981; cv=none;
        d=google.com; s=arc-20240605;
        b=geD3n1ew7S3j+Ld5J60huc2TL8rsCTHDCTfhVqbB1KpkYf6+U+0F1PfEXr2i3t9DOR
         +lYSBkQ6odIp2wgJs+r/OuXjpsvyXKiZL3oPsSguuOsPAUPKV2+FP5WpbDRL4ukyZN5M
         V4m0fVua2qf5K4OJ4y1guz7ShnsBXPwXvUhX3QZEJtRg+8AAAq+GUxv8RwFOTg46v1aX
         74lWz9Q5lKKFAf9R3P8vjQPvieHqf7ICfbiMo4qeXhUq7ejKsPmP+vYef58nbno8YHsd
         GkRfZoJ1yU5E1VaQ1AFevp75fm2lJFc/jJW2CNiUqDNZ3IHVf5AyXvwHQs9dvnGRJ/EO
         u6Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b9VCnm4L5RrHFLm9mWiN30aH7pXEysokH9gscuZA1LE=;
        fh=WvNk0901IP5xOApUq9tYZoF1PGMBVBcnXhkiPRvYFi4=;
        b=BSzQoUsuPELbysYsRTwVN4/xnBzHwzIKLMdWPFwResvK+78n6Zsrt5V4fBepiL7Th4
         EexWzGCmVnhla0kAxl1go7eJN4ZE53pD7/cRFTOKQOKwUWNI8fH+j0c8ov40S0m5ssmT
         a80CVn7T5V5fCF5axGS6cBdEdi7ik4rWXTAZwikDQYKvZ6G43SvU8cJcHetmI4fxw5Xh
         iOeMzFFCP2nbr5lkVLvGtnipLx46/+x6Qs7I/LYH412c3AQov4LhA/P0nBSrm4RAqGq/
         RZbVkYJPpRMG+3ibX+X82k0NPlePeSEeOzFQxVGC3irlzaDmmYGUHmsRMTI8T2KNRbUs
         YR7w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776734981; x=1777339781; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b9VCnm4L5RrHFLm9mWiN30aH7pXEysokH9gscuZA1LE=;
        b=DA1Rf/ZGDUmIH7OY6LAGwIHppiHAulRwVMoFwWaCt+q4IO4r2c/sg7F+qBn6N0pZfz
         jxeIJFQQCnSQSTUcSRBQRESqP+8lBDnVM/M7i2n2Kvv/SV6Rkp8yGWH4a0UUwn23CXm+
         AT83ft2SHYpaEtifakmTeKR90jKNLRJAY+bWuvCSeOYVCJjIxshh2N1mWoQbT2DO6p2C
         A8TH+Xk3zqXAoFolSnXCXY+J330qDQumW8eqjLRP4+ktR6PKXnsgHZ+r9B2c5mG+Z2H5
         6VymQX5j3lGoxo6RgyEHUQXsf7tueYNhbuqyLNppU4U20BXnxrbuWflv3LS2gqZHVhm8
         T+Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776734981; x=1777339781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b9VCnm4L5RrHFLm9mWiN30aH7pXEysokH9gscuZA1LE=;
        b=D974HYHd6wu95sLVHAQFAb4ppnrFUpM8bROch5w/M3w+QTLowfRw4YyPJpBmup4ANd
         YCiKl1uZaxAvoVw/iAwX8rgDB6kvBQzjdoXN9DeKYItwEIVxT4coBibL70AhG8V/CcdB
         hdCzwXHFfEyQQOuJ7BsqbU4mwi8uFocOvEfdbZLc/+2JXK7WAfW4jjUhTqBgHOXHK1zc
         0mi8ehlrBrZGxXUdqWpziRXDo/gmtyUkOjMTyVwP1dxIrRRV5gTgG7mYCCIkC28ysb1X
         N38GgXSUNyVmJ50C8bh9Nra5vDqKbEXa5g4lUPn5YS7G/S7LS5VdDFeR/PjjMYsXXUmL
         FIfw==
X-Forwarded-Encrypted: i=1; AFNElJ/xJasIhAyheYHMgVQQVLPE7y9vbqoXKfkfxbDoUNGt9IRo6T2u4+C4bDKg9lhrhFLJXy/8wKRWBxgM+G+m@vger.kernel.org
X-Gm-Message-State: AOJu0YwTP8ZEJru407uhZ36uKRuolt0vqiftAN48XtTUIXEXWss0OCho
	2l62Nf0WuqnE7Ne2jE3ArTC67oT3HTbPZBDDavE+thTxCa+nZoZ1w0ebtgH982bV/pVf7f43PMx
	8OyHa3mKYgX1TMoK2ah4bDNseykPo1kYtYoo90SdB
X-Gm-Gg: AeBDievAuhF03Z36RCbP2HSYD822mXFPX15G3zj4LvqgKODqRqEyikCeFvPtJGZV0Wh
	KDMlK0nJhlF3CvM1lGGVW5n2gtdcRuUsn/aboUx6jmz3ttKatH46hRtr0CpeNyEimFDtI/1GCMu
	cazMNfFJWb+21wnluSddvqURGqLe+kKPxhzCq5t2loVnWjaDbcqElYJsr7hwx744y0zPl0QDXRB
	FKNCbSZdhISoJTAjHtyGF0y7lhQnWpaFzTjqrRssFmNrQoKpg9ilXlkOJ1PQCTvwVRcdhhWmAFC
	nSTnXapoe88PJy39FS1IXefwZZtW
X-Received: by 2002:a05:6102:5094:b0:608:94e3:bd8a with SMTP id
 ada2fe7eead31-616f4f77861mr7269981137.8.1776734980393; Mon, 20 Apr 2026
 18:29:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260406185000.1378082-1-dylanbhatch@google.com>
 <20260406185000.1378082-8-dylanbhatch@google.com> <de7bd273-3650-4378-8fd8-a51217e7284b@linux.ibm.com>
 <CADBMgpzbEGTm-sZ71a5hvFOHbu5VgSR406F3NsMLF1+oDWbO6A@mail.gmail.com> <dde1daa9-724c-4186-aaf6-caff6b47c5a9@linux.ibm.com>
In-Reply-To: <dde1daa9-724c-4186-aaf6-caff6b47c5a9@linux.ibm.com>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Mon, 20 Apr 2026 18:29:29 -0700
X-Gm-Features: AQROBzD4sxXSCszJZ2N3Wrx6Xjh99aneu1LnlBIufFgIxKIHOKABwtCT5Jq0AHs
Message-ID: <CADBMgpzBvKTvRKHmLbEF301S_DnCg6SRETkMh6jPo-1hOEEZVw@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] sframe: Introduce in-kernel SFRAME_VALIDATION.
To: Jens Remus <jremus@linux.ibm.com>
Cc: Indu Bhagat <ibhagatgnu@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Weinan Liu <wnliu@google.com>, Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2407-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,linux.dev,google.com,kernel.org,oracle.com,infradead.org,goodmis.org,arm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org,linux.ibm.com];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 67A9A435444
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Apr 20, 2026 at 5:31=E2=80=AFAM Jens Remus <jremus@linux.ibm.com> w=
rote:
>
> On 4/20/2026 7:02 AM, Dylan Hatch wrote:
> > On Thu, Apr 16, 2026 at 8:04=E2=80=AFAM Jens Remus <jremus@linux.ibm.co=
m> wrote:
> >> On 4/6/2026 8:49 PM, Dylan Hatch wrote:
>
> >>> Generalize the __safe* helpers to support a non-user-access code path=
.
> >>> Allow for kernel FDE read failures due to the presence of .rodata.tex=
t.
> >>> This section contains code that can't be executed by the kernel
> >>> direclty, and thus lies ouside the normal kernel-text bounds.
> >>
> >> Nits: s/direclty/directly/ s/ouside/outside/
> >>
> >> Could you please explain the issue?  How/why does .sframe for
> >> .rodata.text pose an issue for .sframe verification?
> >
> > __read_fde checks that the fde_addr it extracts is within the bounds
> > of sec->text_start and sec->text_end. In the case of the vmlinux
>
> Looking at the existing check in __read_fde(), do you agree that it is
> wrong, as sec->text_end IIUC points behind .text and thus the check
> should be:
>
>         if (func_addr < sec->text_start || func_addr >=3D sec->text_end)
>                 return -EINVAL;

I agree this is correct. Is this a fix that would be folded into your
previous patch series?

>
> > .sframe section, this is _stext and _etext. However on arm64, there is
> > an .rodata.text section that lies outside this range. From
> > arch/arm64/kernel/vmlinux.lds.S:
> >
> >         /* code sections that are never executed via the kernel mapping=
 */
> >         .rodata.text : {
> >                 TRAMP_TEXT
> >                 HIBERNATE_TEXT
> >                 KEXEC_TEXT
> >                 IDMAP_TEXT
> >                 . =3D ALIGN(PAGE_SIZE);
> >         }
> >
> > So __read_fde fails for functions in this section. Under normal SFrame
> > usage for unwinding, we should never need to look up a PC value in
> > these functions because they will never be executed by the kernel.
> > However, we still hit this error when validating all FDEs.
>
> Thanks for the explanation!  Could you please improve the commit
> message, for instance as follows:
>
> __read_fde() checks that the extracted FDE function start address is
> within the bounds of the .text section start and end.  In case of
> vmlinux this is _stext and _etext.  However on arm64, .rodata.text
> resides outside this range, causing __read_fde() to fail.
>
> > I think ideally we might prevent sframe data from being generated for
> > this code (maybe from the linker script somehow?), but I don't know of
> > a simple way to do this.
>
> I dont't know of any way to exclude a single function or a whole section
> from .sframe generation.  The GNU linker would discard SFrame FDEs and
> its FREs for discarded functions.  But in this case the function itself
> is not discarded.  As .sframe is not generated separately per section it
> is also not possible to discard e.g. .sframe.rodata.
>
> > Alternatively, we can check for FDEs located
> > in .rodata.text during validation, but this seems to only be present
> > in arm64, so maybe we would need an arch-specific hook to do this? I'm
> > open to suggestions.
>
> Maybe that is better than ignoring __read_fde() failures?  I first
> thought this would get nasty, but maybe it would not be too bad.
> Following is what I came up with (note tabs replaced by spaces due to
> copy&paste from terminal):

Thanks for the suggestion! I'll look into incorporating this.

>
> diff --git a/arch/arm64/include/asm/sections.h b/arch/arm64/include/asm/s=
ections.h
> @@ -23,6 +23,7 @@ extern char __irqentry_text_start[], __irqentry_text_en=
d[];
>  extern char __mmuoff_data_start[], __mmuoff_data_end[];
>  extern char __entry_tramp_text_start[], __entry_tramp_text_end[];
>  extern char __relocate_new_kernel_start[], __relocate_new_kernel_end[];
> +extern char _srodatatext[], _erodatatext[];
>
>  static inline size_t entry_tramp_text_size(void)
>  {
> diff --git a/arch/arm64/include/asm/unwind_sframe.h b/arch/arm64/include/=
asm/unwind_sframe.h
> @@ -2,11 +2,28 @@
>  #ifndef _ASM_ARM64_UNWIND_SFRAME_H
>  #define _ASM_ARM64_UNWIND_SFRAME_H
>
> +#include <linux/sframe.h>
> +
>  #ifdef CONFIG_ARM64
>
>  #define SFRAME_REG_SP  31
>  #define SFRAME_REG_FP  29
>
> +static inline bool sframe_func_start_addr_valid(struct sframe_section *s=
ec,
> +                                               unsigned long func_addr)
> +{
> +       return (sec->text_start >=3D func_addr && func_addr < sec->text_e=
nd) ||
> +              (sec->rodatatext_start >=3D func_addr && func_addr < sec->=
rodatatext_end);
> +}
> +#define sframe_func_start_addr_valid sframe_func_start_addr_valid
> +
> +static void arch_init_sframe_table(struct sframe_section *kernel_sfsec)
> +{
> +       kernel_sfsec->rodatatext_start  =3D (unsigned long)_srodatatext;
> +       kernel_sfsec->rodatatext_end    =3D (unsigned long)_erodatatext;
> +}
> +#define arch_init_sframe_table arch_init_sframe_table
> +
>  #endif
>
>  #endif /* _ASM_ARM64_UNWIND_SFRAME_H */
> diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.=
lds.S
> @@ -213,12 +213,14 @@ SECTIONS
>
>         /* code sections that are never executed via the kernel mapping *=
/
>         .rodata.text : {
> +               _srodatatext =3D .;
>                 TRAMP_TEXT
>                 HIBERNATE_TEXT
>                 KEXEC_TEXT
>                 IDMAP_TEXT
>                 . =3D ALIGN(PAGE_SIZE);
>         }
> +       _erodatatext =3D .;
>
>         idmap_pg_dir =3D .;
>         . +=3D PAGE_SIZE;
> diff --git a/include/linux/sframe.h b/include/linux/sframe.h
> @@ -63,6 +63,10 @@ struct sframe_section {
>         unsigned long           sframe_end;
>         unsigned long           text_start;
>         unsigned long           text_end;
> +#if defined(CONFIG_SFRAME_UNWINDER) && defined(CONFIG_ARM64)
> +       unsigned long           rodatatext_start;
> +       unsigned long           rodatatext_end;
> +#endif

It looks to me like .rodata.text only exists for vmlinux. I wonder if
in sframe_func_start_addr_valid we can just use the global
_srodatatext and _erodatatext after identifying if an sframe_section
corresponds to vmlinux (kernel_sfsec)? That way we don't need to add
these extra fields.

>
>         bool                    fdes_sorted;
>         unsigned long           fdes_start;
> diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
> @@ -20,11 +20,23 @@
>  #include "sframe.h"
>  #include "sframe_debug.h"
>
> +#ifndef sframe_func_start_addr_valid
> +static inline bool sframe_func_start_addr_valid(struct sframe_section *s=
ec,
> +                                                unsigned long func_addr)
> +{
> +       return (sec->text_start <=3D func_addr && func_addr < sec->text_e=
nd);
> +}
> +#endif
> +
>  #ifdef CONFIG_SFRAME_UNWINDER
>
>  static bool sframe_init __ro_after_init;
>  static struct sframe_section kernel_sfsec __ro_after_init;
>
> +#ifndef arch_init_sframe_table
> +static void arch_init_sframe_table(struct sframe_section *kernel_sfsec) =
{}
> +#endif
> +
>  #endif /* CONFIG_SFRAME_UNWINDER */
>
>  struct sframe_fde_internal {
> @@ -152,7 +164,7 @@ static __always_inline int __read_fde(struct sframe_s=
ection *sec,
>                   sizeof(struct sframe_fde_v3), Efault);
>
>         func_addr =3D fde_addr + _fde.func_start_off;
> -       if (func_addr < sec->text_start || func_addr > sec->text_end)
> +       if (!sframe_func_start_addr_valid(sec, func_addr))
>                 return -EINVAL;
>
>         fda_addr =3D sec->fres_start + _fde.fres_off;
> @@ -696,13 +708,6 @@ static int sframe_validate_section(struct sframe_sec=
tion *sec)
>                 int ret;
>
>                 ret =3D safe_read_fde(sec, i, &fde);
> -               /*
> -                * Code in .rodata.text is not considered part of normal =
kernel
> -                * text, but there is no easy way to prevent sframe data =
from
> -                * being generated for it.
> -                */
> -               if (ret && sec->sec_type =3D=3D SFRAME_KERNEL)
> -                       continue;
>                 if (ret)
>                         return ret;
>
> @@ -1031,6 +1036,8 @@ void __init init_sframe_table(void)
>         if (WARN_ON(sframe_validate_section(&kernel_sfsec)))
>                 return;
>
> +       arch_init_sframe_table(&kernel_sfsec);
> +
>         sframe_init =3D true;
>  }
>
> Regards,
> Jens
> --
> Jens Remus
> Linux on Z Development (D3303)
> jremus@de.ibm.com / jremus@linux.ibm.com
>
> IBM Deutschland Research & Development GmbH; Vorsitzender des Aufsichtsra=
ts: Wolfgang Wendt; Gesch=C3=A4ftsf=C3=BChrung: David Faller; Sitz der Gese=
llschaft: Ehningen; Registergericht: Amtsgericht Stuttgart, HRB 243294
> IBM Data Privacy Statement: https://www.ibm.com/privacy/
>

Thanks,
Dylan

