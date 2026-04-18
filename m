Return-Path: <live-patching+bounces-2393-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Ls0DnjO4mmX+gAAu9opvQ
	(envelope-from <live-patching+bounces-2393-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 18 Apr 2026 02:21:12 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B609C41F553
	for <lists+live-patching@lfdr.de>; Sat, 18 Apr 2026 02:21:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AADD6307E677
	for <lists+live-patching@lfdr.de>; Sat, 18 Apr 2026 00:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6557C1DF27F;
	Sat, 18 Apr 2026 00:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hOOfbp/4"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D8119CCF7
	for <live-patching@vger.kernel.org>; Sat, 18 Apr 2026 00:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776471662; cv=pass; b=IVFrFGhyw7amHPCbOciP8keDGyXke2QzksO0W0wrRd4HbwNKkUfjNM3s5/2CizC8hRkINI9mYFIYUmk5xJQ34OZ1CDLR+QBNNxFKVXIPgnly/c+ATBbZCWr8MMC58TlJVT5ocR1fWcd1ITjBoRvyjlTRaZ9SQfnSWSvHH6O4lUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776471662; c=relaxed/simple;
	bh=Fy1AeIoM5y5RmDzNAND3jZ59xRLbxO1xCYC20A/FF2k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VkJRQqBLJlPmkLfjG6G6Oxgpg78aSzn5WA3QKRuLY3Zdh1t8/u5ypSsB8MhmDekFISGeg9s/HquKlqtvb6sKIdkVCSQ7UO1kl3PlUbtv5fKQ9VoPj5CTmwT2BrHKY+qQlohI9/vX8axN9o06huLxxfT72K/PjZpgqXQgVl4sQAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hOOfbp/4; arc=pass smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-94aaa5d3bfcso739237241.3
        for <live-patching@vger.kernel.org>; Fri, 17 Apr 2026 17:21:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776471659; cv=none;
        d=google.com; s=arc-20240605;
        b=NLm1ZleEUOZhreAGwecjbmG8zXnuQktYIfN1uCObCmm1YpX7j12ghYFGhuEjlrLzTS
         8r8Z2JY6RzjjyMUhcE2GyF+fqMacb2vr8FWXBjW+1uJttIyTWZU3NCuxWHMzj1T0VeV7
         DJruDffeBkZW/K56sSQpheH85xVDEaDZPbsrBuV8vssN9XNSZMvZsxhD4Cv6Relz+FY5
         fvxnquu0xRGpRsYY7v3AMLmqTEsigTOgenItCobHki62jE+dUShoLKNIg79ufTqYwJoy
         ss0qggeRpZeqrwRZA22POadv+jGhwH1JlGqMuL9gfKjgwpE0rMI1wHn/+Lh7MWrbKZp+
         695w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jG0p0yq8quIKGtqOiuFn9k0lGMjmC+bQB/Uy9ctLaug=;
        fh=KpO8VsLPMh6HgF0qlE624aQtQmTit31k9U3t/QgnXso=;
        b=QzKpSZ+uvOIXGxlFSrCZ9Fhv/3m1bsXUd5voWGtKECY4J8oLjuyUmr9mtup9AORhgA
         wqmIZYCpIPocKLD9q29bsi2+RUSCFttN2BKH7eK4FBChfM+Tq6vA1iuj4qHbHfJm+RJL
         Pma5GjViR2jDcwoKZo1W1sHCRXHYNA545U/P6AGWF2DarMzv8MxDr8tx0UDv2Kw62zCA
         ycdq8IglOO0rMjD+628SS4WbKGCIap8DXhZA+Yjx/l3F9OX+joPPzvvWW9WX5OUm3Htt
         HLlQr+w7p8VMQPLfePiaCclV2pguQUckwUaz3bapzylBrK5UTeonIzeGlsrwyvePkODr
         HjEg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776471659; x=1777076459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jG0p0yq8quIKGtqOiuFn9k0lGMjmC+bQB/Uy9ctLaug=;
        b=hOOfbp/4Fjr+e+3ZcWL5OJ8OFKQPnAoz9nNN5I/uQNknmPaBpOM4w3xiWXaDQAY6iV
         y3PzmfwRNUHcdeJhEtNffWvDB5aPImih2oR7LbGnTUytGLbzhoT3bdIiBi6/SPw8anmP
         mC+ZpS4e04rWuh5wHjmNmJrIufjSndbQgCpkrT2OHjH26jXyX7BICF2qpA39bjWqPqNn
         aQfP+wHfBauThfU8cOeFqR6MgQPpv/0yI/o2c8iCvj279UNlQxUqbD8U8xca3RCdTYsp
         PI6ib4BZ5BEVjNv+bZ/UB/Xkwma8uwypfurY8sVOHVBTM3Vv04ToCv/9N/qxTYI/Lm5J
         hfxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776471659; x=1777076459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jG0p0yq8quIKGtqOiuFn9k0lGMjmC+bQB/Uy9ctLaug=;
        b=IbXmpA1hUg2euwcaXPEhwARGkwrvMzLhLBb6+FTrIwuNhPj/xJnOosB0g3RnOO2S8N
         cdEpKkKbwD3Wdwo1DP8cPsR8iO5/ndIA0N8qhsIqrQ6qUMsGrsdnrq7bxwjFLb7qGeqL
         3CxboxTucZbHuLjC4YxmJd3bWqWmhUAS/8xu7z/MoeihJz7PzE+n/vb1xoHi9dSzrFX0
         pPnsRfQKKQACQcOFHCam2KeB+8QSoqHmOoui6Z7DF6475I15s9GSXvrwuQwi0wO1YQ54
         kYmL8lllum+nxyhX7CiGm7qpmWqs0jxA+y/hWHYR/3uw10squrFbEtoAoA2uEOPZTol9
         Kx7w==
X-Forwarded-Encrypted: i=1; AFNElJ84/cMbvaWRpMuJlkwRCpKc0BHnRWtRSjH0Fg59m8YqBvw0K4MnMQRBVPBkL0X2CHeBBb+VgGfstFcCVutp@vger.kernel.org
X-Gm-Message-State: AOJu0Ywx5s8Ydgrc7JrvQIlVEmi96mCNH4lvGGhZhqvJ3bEGLL1huZNh
	bOQ0DYT4kptJrpXtGQh6nUUOklfp6zhMzjWnBWlkOT9xqJnjjwBLloq200VgmU+FuY4ItTzfvPU
	+k4MxRqMBKTS6wqhZNuvYb7HTvUFukaZnHtAIkiC7
X-Gm-Gg: AeBDietqOTOl6uaauKMqcVS3cQfu1+Mls/4w1uYZHifnFrk7LELl7w30TAizp4+HdqX
	lfu8/+ewjj0iQX9Y5QVkD7+ru7GHW0FI1TemUi4AgS2Myp/1gANf5tdIcSgFFw4C6oL+RFQxJnj
	2W3ZbLkNJJm/uT+olUu1jDtT67hHXK2mH8a/YhnuU43nfmXdToLrOd+vyQQSFQU54gfI7oAWl9a
	w5qzGIp+3Qqk7f9Anadl77aKw9eRWObYAkNv0DMJri1+iEeno95HREwWq2Y/ohWmUL8JLudihHY
	NFROM07wuDFIXU2PN2n83j6rDBKbxTfucqDT1Kk=
X-Received: by 2002:a05:6102:604b:b0:605:1070:231d with SMTP id
 ada2fe7eead31-616f69cf882mr2387773137.17.1776471659198; Fri, 17 Apr 2026
 17:20:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260406185000.1378082-1-dylanbhatch@google.com>
 <20260406185000.1378082-3-dylanbhatch@google.com> <cc7f741c-41a0-4620-b5d5-3428aaa7648f@linux.ibm.com>
In-Reply-To: <cc7f741c-41a0-4620-b5d5-3428aaa7648f@linux.ibm.com>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Fri, 17 Apr 2026 17:20:48 -0700
X-Gm-Features: AQROBzDJREPHzvzsRYQqEASREPSDUbQGxoXWvTmDMaigTLPH3oGDcoCo6QgsWe0
Message-ID: <CADBMgpyFd=id0M0Q+nZouBt9Ph6T=0PfP9xWuKOFWoLQd7zvng@mail.gmail.com>
Subject: Re: [PATCH v3 2/8] arm64, unwind: build kernel with sframe V3 info
To: Jens Remus <jremus@linux.ibm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2393-lists,live-patching=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[22];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B609C41F553
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, Apr 14, 2026 at 5:43=E2=80=AFAM Jens Remus <jremus@linux.ibm.com> w=
rote:
>
>
> Good catch!  Should we rather add the following in the series you are
> basing on, as there are already arch-specific unwind_user.h and
> unwind_user_sframe.h?
>
> F:      arch/*/include/asm/unwind*.h

Thanks for the suggestion, this works for me.

>
> On the other hand I wonder whether the arch-specific headers should
> remain maintained by the respective arch maintainers?  How is that
> handled in general?

I had the same question. My scan of MAINTAINERS shows both patterns
are present, so I defer to those who know more about this kind of
maintainership configuration.

>
> > diff --git a/arch/Kconfig b/arch/Kconfig
>
> > @@ -520,6 +520,13 @@ config SFRAME_VALIDATION
> >
> >         If unsure, say N.
> >
> > +config ARCH_SUPPORTS_SFRAME_UNWINDER
> > +     bool
> > +     help
> > +       An architecture can select this if it  enables the sframe (Simp=
le
> > +       Frame) unwinder for unwinding kernel stack traces. It uses unwi=
nd
> > +       table that is directly generatedby toolchain based on DWARF CFI=
 information.
>
> Nit: s/sframe/SFrame/
>
> > +
> >  config HAVE_PERF_REGS
> >       bool
> >       help
>
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>
> > @@ -112,6 +112,7 @@ config ARM64
> >       select ARCH_SUPPORTS_SCHED_SMT
> >       select ARCH_SUPPORTS_SCHED_CLUSTER
> >       select ARCH_SUPPORTS_SCHED_MC
> > +     select ARCH_SUPPORTS_SFRAME_UNWINDER
> >       select ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
> >       select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
> >       select ARCH_WANT_DEFAULT_BPF_JIT
>
> > diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
>
> > @@ -20,4 +20,17 @@ config ARM64_RELOC_TEST
> >       depends on m
> >       tristate "Relocation testing module"
> >
> > +config SFRAME_UNWINDER
>
> Why do you introduce this for arm64 (and debug) only?  If s390 were to
> add support (as replacement for s390 backchain), this would have to be
> moved or duplicated.  It would not suffice to enable
> ARCH_SUPPORTS_SFRAME_UNWINDER to also enable SFRAME_UNWINDER.

Makes sense, I'll look into introducing this as arch-generic.

>
> As mentioned in my feedback on the previous patch in this series:
> Would it make sense to align the naming to the existing
> HAVE_UNWIND_USER_SFRAME, for instance:
>
>   HAVE_UNWIND_KERNEL_SFRAME
>
> > +     bool "Sframe unwinder"
> > +     depends on AS_SFRAME3
> > +     depends on 64BIT
> > +     depends on ARCH_SUPPORTS_SFRAME_UNWINDER
> > +     select SFRAME_LOOKUP
> > +     help
> > +       This option enables the sframe (Simple Frame) unwinder for unwi=
nding
> > +       kernel stack traces. It uses unwind table that is directly gene=
rated
> > +       by toolchain based on DWARF CFI information. In, practice this =
can
> > +       provide more reliable stacktrace results than unwinding with fr=
ame
> > +       pointers alone.
>
> Nit: s/sframe/SFrame/
>
> > +
> >  source "drivers/hwtracing/coresight/Kconfig"
>
> You are introducing two new Kconfig options (SFRAME_UNWINDER and
> ARCH_SUPPORTS_SFRAME_UNWINDER).  I wonder whether they could somehow be
> combined into a single new option.  Although I am not sure how an option
> can be both selectable and depending at the same time, so that the ARM64
> config could select it, but it would also depend on the above.

I don't think this is recommended, since the behavior of 'select'
appears to override a 'depends' requirement.

From Documentation/kbuild/kconfig-language.rst: "select should be used
with care. select will force a symbol to a value without visiting the
dependencies. By abusing select you are able to select a symbol FOO
even if FOO depends on BAR that is not set. In general use select only
for non-visible symbols (no prompts anywhere) and for symbols with no
dependencies. That will limit the usefulness but on the other hand
avoid the illegal configurations all over."

>
> > diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vm=
linux.lds.h
>
> > @@ -491,6 +491,8 @@
> >               *(.rodata1)                                             \
> >       }                                                               \
> >                                                                       \
> > +     SFRAME                                                          \
> > +                                                                     \
> >       /* PCI quirks */                                                \
> >       .pci_fixup        : AT(ADDR(.pci_fixup) - LOAD_OFFSET) {        \
> >               BOUNDED_SECTION_PRE_LABEL(.pci_fixup_early,  _pci_fixups_=
early,  __start, __end) \
> > @@ -911,6 +913,19 @@
> >  #define TRACEDATA
> >  #endif
> >
> > +#ifdef CONFIG_SFRAME_UNWINDER
> > +#define SFRAME                                                       \
> > +     /* sframe */                                            \
> > +     .sframe : AT(ADDR(.sframe) - LOAD_OFFSET) {             \
> > +             __start_sframe_header =3D .;                      \
>
>                 __start_sframe[_section] =3D .;
>
> > +             KEEP(*(.sframe))                                \
> > +             KEEP(*(.init.sframe))                           \
> > +             __stop_sframe_header =3D .;                       \
>
>                 __stop_sframe[_section] =3D .;
>
> Unless I am missing something both are not the start/stop of the .sframe
> header (in the .sframe section) but the .sframe section itself (see also
> your subsequent "[PATCH v3 4/8] sframe: Provide PC lookup for vmlinux
> .sframe section." where you assign both to kernel_sfsec.sframe_start
> and kernel_sfsec.sframe_end.
>
> > +     }
> > +#else
> > +#define SFRAME
> > +#endif
> > +
> >  #ifdef CONFIG_PRINTK_INDEX
> >  #define PRINTK_INDEX                                                 \
> >       .printk_index : AT(ADDR(.printk_index) - LOAD_OFFSET) {         \
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

I'm working on a new version that I'm hoping to be able to send
sometime next week, which should address your other comments.

Thanks,
Dylan

