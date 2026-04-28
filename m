Return-Path: <live-patching+bounces-2599-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2KdWLt4d8WlmdgEAu9opvQ
	(envelope-from <live-patching+bounces-2599-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 22:51:42 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1312348C058
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 22:51:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EF6E23064648
	for <lists+live-patching@lfdr.de>; Tue, 28 Apr 2026 20:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47D1933B6C9;
	Tue, 28 Apr 2026 20:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5OgnJcH"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2502929B20A
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 20:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777409459; cv=none; b=OaJ7XcYI1Krcg6yMmRUvKZIe3tMVUX961/HvxTeB1DRPD4CIDJAuOAmwuO2S8Q7kfHYDNB5JC0cq8qIVB4x22kbq4T2jTUd18XL2KhqmjrnojAfQvQqUItZ3pQ2wWNg/8iWwe+9w5hADUKxclGdWUkXy7e2cVi47OmYdVTwdOkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777409459; c=relaxed/simple;
	bh=UJkuIFzRTu6vbaYeFolU2FrWbfM2yMCw7GNViIy/XPk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nYwyda0Oyl9FGzLhQDx1SS6cyPs/wGf3kHXHidK6Y7JgTqIklmzKlnqTijIiy6cviaWVG5+Ec/K/YGS71qgK6LgMiAhOBDvpo67qKgR3csTEoI6VWRg6ISrvzhxVlT1QFq0K9IbR2qCZn5ULLO4VTI0HbAKEMNvg1vY/iLvcXVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5OgnJcH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03827C2BCB8
	for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 20:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409459;
	bh=UJkuIFzRTu6vbaYeFolU2FrWbfM2yMCw7GNViIy/XPk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=K5OgnJcHyFqLt3bvaYrIMvnHCXkuun9XExFbXK38div8MkNUmgxFpkbsKguFQaLhR
	 ZVXA9Fn10LXgCV3b8C5aMo9OPepgN9rwq4pHIuYrQr7cv10KsatjRydo4nzD6Mg2gL
	 Vvda7v0nyGyO1pPEcFeFslxB+/iABdKOenbXhoSj5cIIaBnyNyasfr0XBwsGvYlucQ
	 MnQdiUbfK5PGTTBgi0oVlHhBPVzocLj8XajZr2DaymDxcIEeWeEBUzVYEbqIPavdOq
	 DdktH5y6BMEwB+Cc/xUNcj/bAZ2MweZxcWj3LKmJHq789Y96/BFXoTTsUBA9m/VPrk
	 AlRSID/pGzL2w==
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50fb18c55beso85497261cf.2
        for <live-patching@vger.kernel.org>; Tue, 28 Apr 2026 13:50:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8nteiA369akAmxgDb4oBpTe6kEj2jFXKmPng+j/u7UNWeVQkqY+g2ID+khdiXcIKTkho5091zkSMQnjYLo@vger.kernel.org
X-Gm-Message-State: AOJu0YyziEnKo4qFlaDrXbJjwwWyJB3bjZ21WbkZujGhgEE6XYd4eYx7
	aRTZzy/3/baHW3QcKsViDiF9r8Dfd1Wlv6H3JqyZJjRx3IrS63n541Dhdo9eqUBdJcMLzju9ojh
	w4xziry1a8uZoLBW8mUTEbClVfAiA9wA=
X-Received: by 2002:a05:622a:1f0a:b0:50e:a1ab:67eb with SMTP id
 d75a77b69052e-5100e1b7356mr63359621cf.33.1777409458208; Tue, 28 Apr 2026
 13:50:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1776916871.git.jpoimboe@kernel.org> <284944d45120ff69959c4d9cde90db13e493d223.1776916871.git.jpoimboe@kernel.org>
 <CAPhsuW4zF9P1mpZ88P5k=TgbHSCQfrdqFok9YiANHo5CLttZNQ@mail.gmail.com> <abm7sbrlshe23ccholc5q67idnvuackxfy34thnpvyeiglafwe@cdtxtdi3zenv>
In-Reply-To: <abm7sbrlshe23ccholc5q67idnvuackxfy34thnpvyeiglafwe@cdtxtdi3zenv>
From: Song Liu <song@kernel.org>
Date: Tue, 28 Apr 2026 21:50:46 +0100
X-Gmail-Original-Message-ID: <CAPhsuW5H47o59-Np_Uj1xP5V5wFj7KeVEaiDUoTGki=uxrbGDQ@mail.gmail.com>
X-Gm-Features: AVHnY4LJO8YrjrJ8Y5B6GvSXbPq7tfbVZG_ukHlFwVlEKqMkT6l6cWv8ufsgWvs
Message-ID: <CAPhsuW5H47o59-Np_Uj1xP5V5wFj7KeVEaiDUoTGki=uxrbGDQ@mail.gmail.com>
Subject: Re: [PATCH 41/48] objtool/klp: Rewrite symbol correlation algorithm
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, 
	live-patching@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, 
	Joe Lawrence <joe.lawrence@redhat.com>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1312348C058
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2599-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]

On Tue, Apr 28, 2026 at 5:23=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
[...]
> > Also a few nitpicks below.
> >
> > > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > > ---
> > [...]
> > > +static struct symbol *find_twin(struct elfs *e, struct symbol *sym1)
> > > +{
> > > +       struct symbol *name_last =3D NULL, *scope_last =3D NULL,
> > > +                     *file_last =3D NULL, *csum_last =3D NULL;
> > > +       unsigned int name_orig =3D 0, name_patched =3D 0;
> > > +       unsigned int scope_orig =3D 0, scope_patched =3D 0;
> > > +       unsigned int file_orig =3D 0, file_patched =3D 0;
> > > +       unsigned int csum_orig =3D 0, csum_patched =3D 0;
> > > +       struct symbol *sym2, *match =3D NULL;
> > > +
> > > +       /* Count orig candidates */
> > > +       for_each_sym_by_demangled_name(e->orig, sym1->demangled_name,=
 sym2) {
> > > +               if (sym2->twin || sym1->type !=3D sym2->type || dont_=
correlate(sym2) ||
> > > +                   (!maybe_same_file(sym1, sym2)))
> > >                         continue;
> > >
> > > -               count++;
> > > -               result =3D sym2;
> > > +               /* Level 1: name match (widest filter)  */
> > > +               name_orig++;
> > > +
> > > +               /* Level 2: scope (scope changes allowed) */
> > > +               if (is_tu_local_sym(sym1) !=3D is_tu_local_sym(sym2))
> >
> > is_tu_local_sym(sym1) is called many times, shall we add a variable
> > for it?
>
> Unless it's actually a performance issue I'd prefer not to add yet
> another bit to struct symbol.

We don't need to add it to struct symbol, a local variable for sym1
will be good. No need for sym2.

IOW, we have something like

bool sym1_is_local =3D is_tu_local_sym(sym1);
...
if (sym1_is_local !=3D is_tu_local_sym(sym2))
...

Thanks,
Song

