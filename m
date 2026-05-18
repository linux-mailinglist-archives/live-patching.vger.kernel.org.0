Return-Path: <live-patching+bounces-2845-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2FmIE8VSC2qYFgUAu9opvQ
	(envelope-from <live-patching+bounces-2845-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 19:56:21 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FC67571CBD
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 19:56:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5CFCF3009E12
	for <lists+live-patching@lfdr.de>; Mon, 18 May 2026 17:55:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38B44389DED;
	Mon, 18 May 2026 17:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UxFDiZkA"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2ACA33AD88
	for <live-patching@vger.kernel.org>; Mon, 18 May 2026 17:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779126952; cv=pass; b=WnqNMwxfuJA3mu3Q7r7c3W7u7DGNa9G6WZLvI6Tl8Gc9DftVwOkhUGOFUzObTHj0K4c1BcAGgySQMLXpswW3bbE5bYzN55yY82VZtSsKkCcFTCCw0aquZ/dWnAchqar81hzR3Kb+30v/uRQ6n098/Ckiqj5/+Za5N3dW7DTpRCU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779126952; c=relaxed/simple;
	bh=AMBMcN6Oz88RhegA9Ps7e2JqEUwXUNQUQ6Z+7YCgw4U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X4RMX9hyY7dvr5g9MIjfa3FB7vF4QDWDRviNnEo11HI9mwpeZyiFoU/yGyf25DnUGLZ+jR/RsTwbZQXKNpYJGCXa4DxrieSqiNEYgVeh4DYAWBqfAAgDzv5fhBv5WWqh07sIxPWUMLc3E9uWB9iisOTT8FifdTB+5DRjHCylRVc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UxFDiZkA; arc=pass smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-6329f0e0a16so1697699137.3
        for <live-patching@vger.kernel.org>; Mon, 18 May 2026 10:55:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779126950; cv=none;
        d=google.com; s=arc-20240605;
        b=HhXjfxSkxZLsrPGbNCbvnrdP2fHrB30JUYSgZbsGGxOwMuLQnlJSGTuNhEGgBTBy8l
         Hi5nqI2A2o5IMyAFWRTWy/bQM6eyXJPpoCwFztqcuNfvqavKPDnBn9r7Qjj8E3C6b61k
         k92D9JzwXn8aGQ8Kh7vbkAASo+Fq4zOte0EobkZGQFR4BWyqXnr62wQOAHrkUCBxvgfM
         sXw8tYnG637D/g6aTJcUTwZzPZrqzAppfCsYxsujFc7ufz3celI7RdjiJchj/O+9S5KG
         CVc2XIm86HRhIFjjAR/8OzCvbLnTFFLrqIM/cW2Z0cwVti0fbxKBhVWBq0F9fJMps2dT
         QCyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uRWobckzeW61/um9iWV6bMFpw8+SVVVfvtQLyFDktwE=;
        fh=jERklFvDrVPk5GRstkqSCPCDKecSBU/qHXWVUXzRNDY=;
        b=cUkFQTXrR3AfxwPyzm5Dtamu+cEfiWVuc/kbhlVosVuKsvcb0nWrO6UrRnjLCPAckt
         Rifc5p2VPEN8v5n8oDbDsoUnQwmOPqsHaZV6eC2WKpDbHqi4FNDT2/p5TPj+mKcEvqN8
         xBdD8IJK2UlGVDJuEha73iTQVDuipPorgys06gxJ8F+FUhnrQDHg46FkXwB6fgH4zyxq
         4p6lJRRslfW4KBe2rJft39CYHyQ675sH2yM978QYuPDCPJRHzlcpi13tV8YpkJ06YryW
         HJf+5/37i5Yx9KZCN8t+9gLg9p+ntvWlzhxWVOAsGgXZs+AhpnnooX20Rml5MUeN89z9
         vBuQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779126950; x=1779731750; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uRWobckzeW61/um9iWV6bMFpw8+SVVVfvtQLyFDktwE=;
        b=UxFDiZkAzWqXxRggYjEgrh6gSIoZ2jo4O/0axyiTxBFOsG3xrI8jQXBVwbMXZvYvB4
         5IIlkNSsWaCBuFFu+VQ38skwjeaBYrWWjzkuuVyI393Se5e+Rgnhq+xeX281NPj8iko8
         S/klYJa2xknXyBQGXnmI6sFNhNGUb1bTrfu6Py9hXmpDQKH2BpjNx14GNR+s1anAM5P2
         rU+6XXDv9sF5Hb9awaumRiyBDJQQMvuiK1lwC3JA9pHlaJRPseEHRspSbjqaDnrZEkrr
         qgYOEytlXOltl45Z7696oHXrpsTVDv1OvJ4BFw6yOyFxu59+NkLxtFrfjlzkhlZrAzDu
         Ghgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779126950; x=1779731750;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uRWobckzeW61/um9iWV6bMFpw8+SVVVfvtQLyFDktwE=;
        b=AldRDPL6BtOfm1z+UzQTQedtpc5u9h8OvZdeHTjfPNqQdExOWKv7H3x2RI69D3eP8L
         8gJoJVxmTgMbhcq2T0gBe/CEoLOLwe84teI7pgnjtQJikwyRmpymkZy8i14Y52krjc37
         VhyKA1AS1CBHmiEaDjmabHxMtvjAPZXZ4xz/M3BJaHNaMiBTPu0PZVgOfLXb02QNENV5
         tsK+AHppoh8SmM/u1r7LCTkGjSQWkcNd6vdCIQhkiTy7kEPEpuQwKtI2W4P8wPaBnPJY
         lN1yCQtlxhzaojXCankY8zADvAucY7c8tm4dSlnHA8xLke1WYX4EOVhkE01ePXBCm2on
         X+zg==
X-Forwarded-Encrypted: i=1; AFNElJ8lKfjfcrueJqN9E3P6kO2xN1GQ9PIVANamfu9JFvm/j1Hf7cVtxXmHi2qlrcZFhx8J2MKGwlVruMuhb3MT@vger.kernel.org
X-Gm-Message-State: AOJu0YyuhUEsqxTnHTz/V2SooCVc4xfZrGVL0f9V3zEZ30Z9eekr2AFv
	h10icDhotkXZt8lQDynLkS/2qWGvYVVulqoNKg2r9syb7CtoCTwWXGinfX2riZH8hEGLG3CfCde
	jmEDPR4toy+bysIipF9HfFkVD9HAO6RnPgSzqUUVB
X-Gm-Gg: Acq92OGUxbF8pesth7mQiFLnfX73nTOne6+p4514yoq+FOH5a3oc9p9g7HBhlqRWbVX
	Ik6XFJldkzWT+OH/sHI7usmLWP3t43i+J/oBpE9gLS+NJDUoeJma+4z5nAJ3o3KrEo2/ZykAwpl
	a5k9AL9U/ebuGpBT0sISzSVkwgpzXLTfIsP/ogean7+vszCvHxKuUDuHamqFpmCFuW68jI/LAXr
	4+6TYqbyemGww8SfGDUcEDW+xvh8SqHJrrWixHsgjomhLUG8TgFpqjFW+MZJ22vqPqRtkjg75vU
	sdmCAxYqRclEauyyeXav3wWXrW+VEbPuIaH7f9HIaCDoohd1
X-Received: by 2002:a05:6102:5493:b0:631:37cb:1e64 with SMTP id
 ada2fe7eead31-63a3cd147f1mr8765580137.4.1779126949351; Mon, 18 May 2026
 10:55:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428183643.3796063-1-dylanbhatch@google.com> <agcEMEl-QR0g6DgF@google.com>
In-Reply-To: <agcEMEl-QR0g6DgF@google.com>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Mon, 18 May 2026 10:55:37 -0700
X-Gm-Features: AVHnY4KAVyVG3MIthAgIvuYFRo0zgnpM4Osagc0xDbfXJPvO4gKarvsASmJ8hSE
Message-ID: <CADBMgpx38SUUuYYCm612STqh01jqv817WnJeeXYTD7Uc1r-fug@mail.gmail.com>
Subject: Re: [PATCH v5 0/8] unwind, arm64: add sframe unwinder for kernel
To: Mostafa Saleh <smostafa@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Jens Remus <jremus@linux.ibm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Prasanna Kumar T S M <ptsm@linux.microsoft.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Song Liu <song@kernel.org>, joe.lawrence@redhat.com, 
	linux-toolchains@vger.kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2845-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.ibm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TAGGED_RCPT(0.00)[live-patching];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 7FC67571CBD
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Mostafa,

On Fri, May 15, 2026 at 4:32=E2=80=AFAM Mostafa Saleh <smostafa@google.com>=
 wrote:
>
> On Tue, Apr 28, 2026 at 06:36:35PM +0000, Dylan Hatch wrote:
> > Implement a generic kernel sframe-based [1] unwinder. The main goal is
> > to improve reliable stacktrace on arm64 by unwinding across exception
> > boundaries.
> >
> > On x86, the ORC unwinder provides reliable stacktrace through similar
> > methodology, but arm64 lacks the necessary support from objtool to
> > create ORC unwind tables.
> >
> > Currently, there's already a sframe unwinder proposed for userspace: [2=
].
> > To maintain common definitions and algorithms for sframe lookup, a
> > substantial portion of this patch series aims to refactor the sframe
> > lookup code to support both kernel and userspace sframe sections.
> >
> > Currently, only GNU Binutils support sframe. This series relies on the
> > Sframe V3 format, which is supported in binutils 2.46.
> >
> > These patches are based on Steven Rostedt's sframe/core branch [3],
> > which is and aggregation of existing work done for x86 sframe userspace
> > unwind, and contains [2]. This branch is, in turn, based on Linux
> > v7.0-rc3. This full series (applied to the sframe/core branch) is
> > available on github: [4].
> >
>
> Not sure if related, but after updating my toolchain
> (aarch64-linux-gnu-gcc (Debian 15.2.0-4) 15.2.0), I hit link errors:
> ld.lld: error: arch/arm64/kernel/vdso/vgettimeofday.o:(.sframe) is being =
placed in '.sframe'
> ld.lld: error: arch/arm64/kernel/vdso/vgetrandom.o:(.sframe) is being pla=
ced in '.sframe`

Previously when developing against the SFrame V2 format, I had fixed
these warnings with the VDSO Makefile change currently in this series:

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makef=
ile
index 7dec05dd33b7..c60ef921956f 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -38,7 +38,7 @@ ccflags-y +=3D -DDISABLE_BRANCH_PROFILING -DBUILD_VDSO
 CC_FLAGS_REMOVE_VDSO :=3D $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS) \
                        $(RANDSTRUCT_CFLAGS) $(KSTACK_ERASE_CFLAGS) \
                        $(GCC_PLUGINS_CFLAGS) \
-                       $(CC_FLAGS_LTO) $(CC_FLAGS_CFI) \
+                       $(CC_FLAGS_LTO) $(CC_FLAGS_CFI) $(CC_FLAGS_SFRAME) =
\
                        -Wmissing-prototypes -Wmissing-declarations

 CC_FLAGS_ADD_VDSO :=3D -O2 -mcmodel=3Dtiny -fasynchronous-unwind-tables

But the warnings seem to have returned after upgrading my toolchain,
possibly due to SFrame V3 or some confounding change in GCC. The
--gsframe in the assembler should be set to 'no' by default, so
perhaps GCC is providing an override --gsframe internally?

>
> I applied this series hoping that fix it, but it doesn't, so far I
> have this hack :
> diff --git a/arch/arm64/kernel/vdso/vdso.lds.S b/arch/arm64/kernel/vdso/v=
dso.lds.S
> index 52314be29191..53bdf757ee44 100644
> --- a/arch/arm64/kernel/vdso/vdso.lds.S
> +++ b/arch/arm64/kernel/vdso/vdso.lds.S
> @@ -77,7 +77,7 @@ SECTIONS
>         /DISCARD/       : {
>                 *(.data .data.* .gnu.linkonce.d.* .sdata*)
>                 *(.bss .sbss .dynbss .dynsbss)
> -               *(.eh_frame .eh_frame_hdr)
> +               *(.eh_frame .eh_frame_hdr .sframe)
>         }
>  }
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmli=
nux.lds.h
> index 60c8c22fd3e4..759903acd6fc 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -1064,6 +1064,7 @@
>         /* ld.bfd warns about .gnu.version* even when not emitted */    \
>         *(.gnu.version*)                                                \
>         *(__tracepoint_check)                                           \
> +       *(.sframe)                                                      \
>
>  #define DISCARDS                                                       \
>         /DISCARD/ : {                                                   \

Since this series only handles kernel stacktrace, I believe it's
better to omit the .sframe section entirely in the case where only
ARCH_SUPPORTS_UNWIND_KERNEL_SFRAME is enabled. I think this hack may
work better for this purpose:

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makef=
ile
index c60ef921956f..29f802bfedb1 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -41,7 +41,7 @@ CC_FLAGS_REMOVE_VDSO :=3D $(CC_FLAGS_FTRACE) -Os
$(CC_FLAGS_SCS) \
                        $(CC_FLAGS_LTO) $(CC_FLAGS_CFI) $(CC_FLAGS_SFRAME) =
\
                        -Wmissing-prototypes -Wmissing-declarations

-CC_FLAGS_ADD_VDSO :=3D -O2 -mcmodel=3Dtiny -fasynchronous-unwind-tables
+CC_FLAGS_ADD_VDSO :=3D -O2 -mcmodel=3Dtiny -fasynchronous-unwind-tables
-Wa,--gsframe=3Dno

 CFLAGS_REMOVE_vgettimeofday.o =3D $(CC_FLAGS_REMOVE_VDSO)
 CFLAGS_REMOVE_vgetrandom.o =3D $(CC_FLAGS_REMOVE_VDSO)

Though, I don't understand why it is necessary to provide --gsframe=3Dno
explicitly. If this approach seems ok to other folks/maintainers, I
can fold this into my series.

On the topic of SFrame for VDSO, Jens has a patch adding support for
this as part of a series to support userspace SFrame unwinding for
arm64:

https://lore.kernel.org/lkml/20260417150827.1183376-4-jremus@linux.ibm.com/

>
>
> Thanks,
> Mostafa
>

Thanks,
Dylan

