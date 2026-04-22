Return-Path: <live-patching+bounces-2426-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ENO4Ikvn6GkHRQIAu9opvQ
	(envelope-from <live-patching+bounces-2426-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 17:20:43 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E3A87447D42
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 17:20:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7D028301ECF4
	for <lists+live-patching@lfdr.de>; Wed, 22 Apr 2026 15:15:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F4208319858;
	Wed, 22 Apr 2026 15:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U8vvMgiN"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860053148B4
	for <live-patching@vger.kernel.org>; Wed, 22 Apr 2026 15:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776870924; cv=pass; b=XIPuFsLdfqi756jsLLsEwMrYsCBQ3W3ybGL10Mr4NSQtS7sTlWiWSyly8CE0AAOkHK8l9waDH6VosH11EWbJj0RQpqzbspSYsoyxVXLLmCl+kdi5nUbmgJrglALtV45xV1ZrrKKZUDwe7USzDLflD7gaBNHqRXdxUNU4Mzw0yYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776870924; c=relaxed/simple;
	bh=diFcozsLU1g5N/LDqHeKoTeQNkDx5DATuRE3CG7HilA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u8JLFfrZ8Xmu/tJNr+6X757QKW3jLrHZ0Z4uV0dEN8A2+jFTr2JkbuFy8qfO7C3b1mOQbT5O9BwMV30gFWpVTwMvU3055yQtGAPmNGcuuQ89fsCPU/miG2L/SuaL8QVtjcqw00bA9WT5YMxeC7IRnfc9NhaafRzAh3gcVzgKcWY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U8vvMgiN; arc=pass smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-605def5b807so1699558137.3
        for <live-patching@vger.kernel.org>; Wed, 22 Apr 2026 08:15:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776870919; cv=none;
        d=google.com; s=arc-20240605;
        b=lLVtGIYz0ucYj+H+mPlaNAfLiGxe1+bGvmaPVjylve2OgP4XK6amgB/cC2M0qnLsa5
         VwCk2YDmguuLOXh50OAS7k6OXxBwqHyGi5O14Fd/K3BN5fdPGIhWBu0WodjEB4U58PRt
         yK2zOuxfJZ1eCOTK0H1J6PjKt1Az4lGFqbE3zsrq4kUYMepP9ouHwihqZ8w+9U+KV1oz
         nBU11UOkpRhkNuXiuaGLu5Q2upFK3b2mG9qRENQ1b7i/eFcP11bPnq5Hh3EOvOTBf0uI
         gdeXLjpT8g4cm9lrcOdshhOhj79YR+HIoGBGjldJDlMcJw9qhqRsmUBMZ/oML7DfyfvC
         KDcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MnN3kffexEQ3erD83gZV8XS71NssMlwPJVCJhAvXMVg=;
        fh=zn8oVAOrZ2+gyKpO8tRQlJSD/kCxO2GiBiLF+/IlHiU=;
        b=Ba+bxu+wz22a3GtJBCY2ynORqq4j6/JHqPM73lsGxCI/B4LGRGT03eB4Fm/tX418gm
         0tR8WxXebYXtVi57YdQ6Es+CHtAOREheBKJ5WKQrfwH6iJDRHqJKhpDW2dYovp75nSUg
         hwGxxz0V/BKKexh9dQewaBdgpfsiZJRxXjuKtD9XKg5ExfHKzMFfsdVLOO9O3CXKtUGd
         n5GW8A/tbEqeH5F7ZqysThehAhrbz/qQr96nc1RqyGhb9KBhjx14o57knqVRYhbRWjDF
         tXzqkmvaCPUZRYU9GlN/1OKISfKuouDHc9FLqL1qC1y1nH/Cv5KqU1qWY5KzA2xG+5BH
         L/Wg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776870919; x=1777475719; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MnN3kffexEQ3erD83gZV8XS71NssMlwPJVCJhAvXMVg=;
        b=U8vvMgiNXlK9b2tPpSjZlngIKzlMrUi6bCS0aYtayeQuUXfMPQf/qVtDQgdeazju0o
         /qXdd6JI6sNwIqeo6vm/Yz0bZSE+NUpeFg27T5WVtI25BZg129IbN51nFm4gKIgqGsge
         h9b2vSem3O/xAczhRwKQza29nFoj+kQTGWGhNUYblRXMdEF20o0s85sCfEHzAggvRarV
         eQN8FkWBzPYCZX1+yG9CJY172Y7McEVFCRtdxRyQQn2S00Z+zL20PRiI5VOWRLz7TDuh
         uwUA9tSsCisBeCfZfSk2RI6GN9POffrHOHNKCYjc3r+vR52KgWh9s7zr9psB1fasjcLs
         gTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776870919; x=1777475719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MnN3kffexEQ3erD83gZV8XS71NssMlwPJVCJhAvXMVg=;
        b=qWy+7VSmbpk2YAJb/ioV1ah4PtZ9dEOBCeEh++Dzh1QzpAAO19DBYyNupEUWZ7JKKw
         4G92cIFAKlaqCWt82mP3Ghv7ZwySw+gxFM1GrkOAUnc0Bnd+5TAGsAbDMybMTR8Pc6ri
         AfURWi9dMwmzI27P6Gj5shq4U9vxTgToBjZI+TEW47+JwCo3HbzifOyODnrTslEGLsA8
         Z5rdYd7nfw5h8nxGDyHiMG5cJmUjcBeEzvYrjqlSYRzUZsK3jktuxgkV+tBcx0BIUALb
         JX/PwtS31F0E1PcfrZ0rME8iT10lOhDgqeMW5A/QxvlEzAfbAL26XG6z+BtOUxts+894
         ZYRA==
X-Forwarded-Encrypted: i=1; AFNElJ+M8YZFV3NBKpwGaLuukxKpqgYoLzWwnjidoaXZYml+4XPyZvMhhJAMXtGcfhH/oogshVhnQSWf1Pia0tjH@vger.kernel.org
X-Gm-Message-State: AOJu0YyKqEJ0wxKj4C/lGOI0p7yretvLa+/l1PuYThpKgwshHfWtsOVW
	UN/FaLEMfzkaImtj3Dpuctny7f3e/j2ifcaXpYdy3It7djl93sgimZZrT8gWi3/rNblQPm2Jj84
	XV630VSocXjSraUjuHbR9wWFdTtggLoXlyptLwnVK
X-Gm-Gg: AeBDiestNrZRhQTDiH2C9ongAeEuwEniU3chfuJxprOBE8/9XqoJnpH/zmUzRXX2sVg
	zEZo9sDXecfD3k1WuAXLffnm4avQDk9FcYfa+Lf7ugGnlfDwcCsujRNFPwouOWcGSTe4rLdTwIB
	1cBApe64w9rmwKy3TkWBim/e4BVkJOhwyVh7lGFnsP/tK0DnsOz+w2hCSjHu7+CaHj7DCGif/OW
	4SOrjgWpi8dY3VNe2WRlCJe6nWs692nEuaI0be7SJF8zI5xv9eBR9Dx6XqPjBDXbgRIFrnA3h5Q
	488Zgi9cIo5JAUBV/xBZ0ePiGp+x
X-Received: by 2002:a67:e111:0:b0:60c:fe65:7dbd with SMTP id
 ada2fe7eead31-616f4741f51mr10349005137.5.1776870918247; Wed, 22 Apr 2026
 08:15:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260421225200.1198447-1-dylanbhatch@google.com>
 <20260421225200.1198447-2-dylanbhatch@google.com> <38c9d976-6205-409c-8874-4c9757b25fd6@linux.ibm.com>
In-Reply-To: <38c9d976-6205-409c-8874-4c9757b25fd6@linux.ibm.com>
From: Dylan Hatch <dylanbhatch@google.com>
Date: Wed, 22 Apr 2026 08:15:07 -0700
X-Gm-Features: AQROBzCbPdFeYboP_oqMqLK5MAIPqTpd2YwkEakew5i23pus5XMPNY5ADgj5vpw
Message-ID: <CADBMgpy+HG1ksdZM=5pR1myyRzds6OZys_gpH6vJ=ZHOWb3mKQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/8] sframe: Allow kernelspace sframe sections
To: Jens Remus <jremus@linux.ibm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Weinan Liu <wnliu@google.com>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Indu Bhagat <ibhagatgnu@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jiri Kosina <jikos@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>, Puranjay Mohan <puranjay@kernel.org>, 
	Song Liu <song@kernel.org>, joe.lawrence@redhat.com, linux-toolchains@vger.kernel.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Randy Dunlap <rdunlap@infradead.org>, 
	Heiko Carstens <hca@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2426-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[linux.dev,google.com,kernel.org,gmail.com,infradead.org,goodmis.org,arm.com,linux.microsoft.com,redhat.com,vger.kernel.org,lists.infradead.org,linux.ibm.com];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dylanbhatch@google.com,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MAILSPIKE_FAIL(0.00)[172.234.253.10:query timed out];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: E3A87447D42
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 22, 2026 at 7:08=E2=80=AFAM Jens Remus <jremus@linux.ibm.com> w=
rote:
>
> On 4/22/2026 12:51 AM, Dylan Hatch wrote:
> > Generalize the sframe lookup code to support kernelspace sections. This
> > is done by defining a SFRAME_LOOKUP option that can be activated
> > separate from HAVE_UNWIND_USER_SFRAME, as there will be other client to
> > this library than just userspace unwind.
> >
> > Sframe section location is now tracked in a separate sec_type field to
> > determine whether user-access functions are necessary to read the sfram=
e
> > data. Relevant type delarations are moved and renamed to reflect the
> > non-user sframe support.
> >
> > Signed-off-by: Dylan Hatch <dylanbhatch@google.com>
>
> With return -EFAULT changed to goto label in DATA_COPY() and DATA_GET():
>
> Reviewed-by: Jens Remus <jremus@linux.ibm.com>
>
> > ---
> >  MAINTAINERS                                   |   2 +-
> >  arch/Kconfig                                  |   4 +
> >  .../{unwind_user_sframe.h =3D> unwind_sframe.h} |   6 +-
> >  arch/x86/include/asm/unwind_user.h            |  12 +-
> >  include/linux/sframe.h                        |  48 ++--
> >  include/linux/unwind_types.h                  |  46 +++
> >  include/linux/unwind_user_types.h             |  41 ---
> >  kernel/unwind/Makefile                        |   2 +-
> >  kernel/unwind/sframe.c                        | 270 ++++++++++++------
> >  kernel/unwind/user.c                          |  41 +--
> >  10 files changed, 293 insertions(+), 179 deletions(-)
> >  rename arch/x86/include/asm/{unwind_user_sframe.h =3D> unwind_sframe.h=
} (50%)
> >  create mode 100644 include/linux/unwind_types.h
>
> > diff --git a/include/linux/sframe.h b/include/linux/sframe.h
>
> > +enum sframe_sec_type {
> > +     SFRAME_KERNEL,
> > +     SFRAME_USER,
> > +};
>
> >  struct sframe_section {
> > -     struct rcu_head rcu;
> > +     struct rcu_head  rcu;
> >  #ifdef CONFIG_DYNAMIC_DEBUG
> > -     const char      *filename;
> > +     const char              *filename;
> >  #endif
> > -     unsigned long   sframe_start;
> > -     unsigned long   sframe_end;
> > -     unsigned long   text_start;
> > -     unsigned long   text_end;
> > -
> > -     unsigned long   fdes_start;
> > -     unsigned long   fres_start;
> > -     unsigned long   fres_end;
> > -     unsigned int    num_fdes;
> > -
> > -     signed char     ra_off;
> > -     signed char     fp_off;
> > +     enum sframe_sec_type    sec_type;
> > +     unsigned long           sframe_start;
> > +     unsigned long           sframe_end;
> > +     unsigned long           text_start;
> > +     unsigned long           text_end;
> > +
> > +     unsigned long           fdes_start;
> > +     unsigned long           fres_start;
> > +     unsigned long           fres_end;
> > +     unsigned int            num_fdes;
> > +
> > +     signed char             ra_off;
> > +     signed char             fp_off;
> >  };
>
> > diff --git a/kernel/unwind/sframe.c b/kernel/unwind/sframe.c
>
> > +#define DATA_COPY(sec, to, from, size, label)                        \
> > +({                                                           \
> > +     switch (sec->sec_type) {                                \
> > +     case SFRAME_KERNEL:                                     \
> > +             KERNEL_COPY(to, from, size, label);             \
> > +             break;                                          \
> > +     case SFRAME_USER:                                       \
> > +             UNSAFE_USER_COPY(to, from, size, label);        \
> > +             break;                                          \
>
> I wonder whether it would be worthwhile to come up with an approach
> where this would get evaluated at compile time instead at run time?
> Or is this overengineering?  Of course such improvement could be
> made later on, so no need to solve that now.

I had a similar thought when I was writing this patch, but I ended up
deciding to avoid premature optimization before getting feedback. I'd
definitely be interested in improving upon this later on.

>
> Options that came into my mind:
> A) Introduce and pass through a "bool user" parameter, whose value is
>    specified in sframe_find_user() and sframe_find_kernel().  Due to
>    inlining I would expect that to get any conditions based on that
>    to get evaluated at compile time.  See below.  Downside is the
>    ugly additional parameter.
>
> B) Introduce lightweight .c wrappers, e.g. sframe_kernel.c and
>    sframe_user.c, that define DATA_GET() and DATA_COPY() and include
>    sframe.c.  All HAVE_UNWIND_KERNEL_SFRAME code would be moved into
>    sframe_kernel.c and likewise all HAVE_UNWIND_USER_SFRAME code into
>    sframe_user.c.

(A) definitely sounds simpler to implement. For (B) it seems uncommon
for .c files to include one another. Style-wise, is this something
that is typically allowed (e.g. by checkpatch.pl)?

>
> > +     default:                                                \
> > +             return -EFAULT;                                 \
>
>                 goto label;                                     \
>
> Users of DATA_COPY() do expect the macro to branch to the label in case
> of an error and therefore do not evaluate any return value.  The
> wrapping then needs also be changed from "({ .. })" to
> "do { ... } while (0)".
>
> > +     }                                                       \
> > +})
> > +
> > +#define DATA_GET(sec, to, from, type, label)                 \
> > +({                                                           \
> > +     switch (sec->sec_type) {                                \
> > +     case SFRAME_KERNEL:                                     \
> > +             KERNEL_GET(to, from, type, label);              \
> > +             break;                                          \
> > +     case SFRAME_USER:                                       \
> > +             UNSAFE_USER_GET(to, from, type, label);         \
> > +             break;                                          \
> > +     default:                                                \
> > +             return -EFAULT;                                 \
>
> Likewise.
>
> > +     }                                                       \
> > +})
>
> > +#ifdef CONFIG_HAVE_UNWIND_USER_SFRAME
> > +
> > +int sframe_find_user(unsigned long ip, struct unwind_frame *frame)
> > +{
> > +     struct mm_struct *mm =3D current->mm;
> > +     struct sframe_section *sec;
> > +     int ret;
> > +
> > +     if (!mm)
> > +             return -EINVAL;
> > +
> > +     guard(srcu)(&sframe_srcu);
> > +
> > +     sec =3D mtree_load(&mm->sframe_mt, ip);
> > +     if (!sec)
> > +             return -EINVAL;
> > +
> > +     if (!user_read_access_begin((void __user *)sec->sframe_start,
> > +                                 sec->sframe_end - sec->sframe_start))
> > +             return -EFAULT;
> > +
> > +     ret =3D __sframe_find(sec, ip, frame);
>
> In sframe_find_user() sec->sec_type must be SFRAME_USER.  Likewise in
> sframe_find_kernel() it must be SFRAME_KERNEL.  So instead of
> introducing sec_type, we could add a parameter
> __sframe_find(..., bool user) and do:
>
>         ret =3D __sframe_find(sec, ip, frame, true);
>
> The downside is that this then requires to pass that flag through
> everywhere... (see below).
>
> > +
> > +     user_read_access_end();
> > +
> > +     if (ret =3D=3D -EFAULT) {
> > +             dbg_sec("removing bad .sframe section\n");
> > +             WARN_ON_ONCE(sframe_remove_section(sec->sframe_start));
> > +     }
> > +
> > +     return ret;
> > +}
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

