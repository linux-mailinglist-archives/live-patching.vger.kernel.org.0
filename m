Return-Path: <live-patching+bounces-2617-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0FPyG1x182mt4AEAu9opvQ
	(envelope-from <live-patching+bounces-2617-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 17:29:32 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CAE34A4C5D
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 17:29:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 979BF303E7B1
	for <lists+live-patching@lfdr.de>; Thu, 30 Apr 2026 15:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC3BF438FFE;
	Thu, 30 Apr 2026 15:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KOPOFqpr"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570ED438FEC
	for <live-patching@vger.kernel.org>; Thu, 30 Apr 2026 15:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777561923; cv=none; b=jICAR/8IgrDwwUEVGvhhozmGtncQ34XBdEZKsSOvWOhQKmBZjkjbioF/mkhW9o4nGSdRnBxyr5jWIHH85Jo9KGDC/XSWQ2NItnGdnGHAm0IET+r6V+tQBJ5FtdMCC9F+t0YF5jHJEhyHx1buyWndY0UD5u7rWp3KscXS6hDkABA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777561923; c=relaxed/simple;
	bh=mkTj0HUPdtaF4M9iRKk2jM6BLpIgDC0BRYzHz4cP5LQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k/3BjalE0Pog0rnzWCeJF7Eig99wjDtluJfT0TD6oUOI0CP12wpursYEbbA7wgp443KOmncGU1Amln3u0oPFTL35INH1gSuaaiOJtnq3qToq1iaqxr3Od9bIZYfN8DRflgF1ZyR+5zuxQ5jh0HG25XzMdVN3NXppjXeVOYJaqV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KOPOFqpr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D5CC2BCB3
	for <live-patching@vger.kernel.org>; Thu, 30 Apr 2026 15:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777561922;
	bh=mkTj0HUPdtaF4M9iRKk2jM6BLpIgDC0BRYzHz4cP5LQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KOPOFqpr9jRNpQbq7Rz3ARf6aPIMGBhWJ86U3Ju0zTrR+d4R4OwqDFHdyH9xwTUxJ
	 kxRqYGSwna9PgLB2A0o13ZR1hqsyWQtgssrs555cgttQPRNyMusvV223WwxQqXh7cz
	 9nnX2meLeOjt3AvMNd+32YIJcscczuTHbKii7lFWpt5qY/Bp+cvshepL6qDDkt+/33
	 ohbm8nSPUQA83fShf4aIFLSt73PMgxrtN1k1I0NyWllNJ6ZsMLdWBLaBm+puQg4Lct
	 JYYC4uJXk+BZxjgmoT7R2bcblVISB0Il5TmN2XLYyEudx0b0yydCJWZGL9dLDA++0w
	 pChbxf8j2b7WQ==
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8aca4e14411so10933596d6.3
        for <live-patching@vger.kernel.org>; Thu, 30 Apr 2026 08:12:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+m7mdEdyiiIaxZvRubPeXKyl4+zfERTyZo+AcDcT6JC4FSbMw6rv+Axhm/mHKTMGlJCQnIKhAri2OFRz28@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4y51o5hyqFSI+NC4Hrazm2kBkuWNi/KdjXpOuyeiOeb+qZK3e
	dsX8ZVXCjbaqfSqn7S3Ael/1gjulCrYhi6K38/aFVzQgo4Tvc1d/d+FOcsv0O7hF2fcCUoj/Dkg
	ctJX5M3z+5KNINB5AU68P5FrW3+hZVTc=
X-Received: by 2002:a05:6214:2a8a:b0:8ac:b4d5:50ec with SMTP id
 6a1803df08f44-8b3fe801483mr47056106d6.38.1777561921695; Thu, 30 Apr 2026
 08:12:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <284944d45120ff69959c4d9cde90db13e493d223.1776916871.git.jpoimboe@kernel.org>
 <CAPhsuW4zF9P1mpZ88P5k=TgbHSCQfrdqFok9YiANHo5CLttZNQ@mail.gmail.com>
 <abm7sbrlshe23ccholc5q67idnvuackxfy34thnpvyeiglafwe@cdtxtdi3zenv>
 <CAPhsuW5H47o59-Np_Uj1xP5V5wFj7KeVEaiDUoTGki=uxrbGDQ@mail.gmail.com> <z5njxpewtwl4m3drovmqykouqmwon3klnsvs6ypa63jym7t2ic@nonc2g73yvs3>
In-Reply-To: <z5njxpewtwl4m3drovmqykouqmwon3klnsvs6ypa63jym7t2ic@nonc2g73yvs3>
From: Song Liu <song@kernel.org>
Date: Thu, 30 Apr 2026 16:11:47 +0100
X-Gmail-Original-Message-ID: <CAPhsuW4g=ZTnFsrTeV_sQYZyK==twONBTHjDbcdbx1MHs9Yfuw@mail.gmail.com>
X-Gm-Features: AVHnY4I4GWFBmLfN2XnmI-0OBoVGbzncQRH4Ezw0kKeGMPukdoe_JcpdmX8hNgE
Message-ID: <CAPhsuW4g=ZTnFsrTeV_sQYZyK==twONBTHjDbcdbx1MHs9Yfuw@mail.gmail.com>
Subject: Re: [PATCH 41/48] objtool/klp: Rewrite symbol correlation algorithm
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8CAE34A4C5D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2617-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]

On Thu, Apr 30, 2026 at 3:53=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Tue, Apr 28, 2026 at 09:50:46PM +0100, Song Liu wrote:
> > On Tue, Apr 28, 2026 at 5:23=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel=
.org> wrote:
> > [...]
> > > > Also a few nitpicks below.
> > > >
> > > > > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > > > > ---
> > > > [...]
> > > > > +static struct symbol *find_twin(struct elfs *e, struct symbol *s=
ym1)
> > > > > +{
> > > > > +       struct symbol *name_last =3D NULL, *scope_last =3D NULL,
> > > > > +                     *file_last =3D NULL, *csum_last =3D NULL;
> > > > > +       unsigned int name_orig =3D 0, name_patched =3D 0;
> > > > > +       unsigned int scope_orig =3D 0, scope_patched =3D 0;
> > > > > +       unsigned int file_orig =3D 0, file_patched =3D 0;
> > > > > +       unsigned int csum_orig =3D 0, csum_patched =3D 0;
> > > > > +       struct symbol *sym2, *match =3D NULL;
> > > > > +
> > > > > +       /* Count orig candidates */
> > > > > +       for_each_sym_by_demangled_name(e->orig, sym1->demangled_n=
ame, sym2) {
> > > > > +               if (sym2->twin || sym1->type !=3D sym2->type || d=
ont_correlate(sym2) ||
> > > > > +                   (!maybe_same_file(sym1, sym2)))
> > > > >                         continue;
> > > > >
> > > > > -               count++;
> > > > > -               result =3D sym2;
> > > > > +               /* Level 1: name match (widest filter)  */
> > > > > +               name_orig++;
> > > > > +
> > > > > +               /* Level 2: scope (scope changes allowed) */
> > > > > +               if (is_tu_local_sym(sym1) !=3D is_tu_local_sym(sy=
m2))
> > > >
> > > > is_tu_local_sym(sym1) is called many times, shall we add a variable
> > > > for it?
> > >
> > > Unless it's actually a performance issue I'd prefer not to add yet
> > > another bit to struct symbol.
> >
> > We don't need to add it to struct symbol, a local variable for sym1
> > will be good. No need for sym2.
> >
> > IOW, we have something like
> >
> > bool sym1_is_local =3D is_tu_local_sym(sym1);
> > ...
> > if (sym1_is_local !=3D is_tu_local_sym(sym2))
>
> I'd rather keep it the way it is for readability, the compiler should be
> able to recognize the sym1 value doesn't change and calculate its value
> once.

Agreed for readability.

We can always optimize it in case this becomes a real slowdown.

Thanks,
Song

