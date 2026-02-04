Return-Path: <live-patching+bounces-1973-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QKDzCMiRgmmhWQMAu9opvQ
	(envelope-from <live-patching+bounces-1973-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 01:24:40 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B53CDFFE1
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 01:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C460730CCA3D
	for <lists+live-patching@lfdr.de>; Wed,  4 Feb 2026 00:24:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6718C1AAE17;
	Wed,  4 Feb 2026 00:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oxgd+vYw"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440341A9F9F
	for <live-patching@vger.kernel.org>; Wed,  4 Feb 2026 00:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770164659; cv=none; b=svyAC/eefFo9bCxKXAuZ28M8QkJbKrEJYVURKtYgv5J47dfX2DdaRTLrn9LrplvZW85BCW53Jj5FMDKwEtXUrRUPlbV3S4bnx5MvvYkHSwM7ZBG73CDrmZH6H9TN2wMvBbnxeswk35aqzVzyEd2ePP9cLbkwaiOS9f6P2nTBuz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770164659; c=relaxed/simple;
	bh=n1aCSIJrA3TCkSpUjBf8aecjU6vRZ2GIjbPWh9mbQqo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EIRK4f6HF2/OtmM0moFsvksChnhpqNhgXxVRgv3FN+xffW3kb98QZEI9N0W9jIWMiPrDHQWNn/e+5znjWXBmzj2iEbk+UDQv+6f7e9RfaBlhk2QQpHUEdGLiASsrd1EmQl60B8DD0TJa4rha/lcqWDaWN7PKxqvkpHTxiWh8wJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oxgd+vYw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4621C2BC87
	for <live-patching@vger.kernel.org>; Wed,  4 Feb 2026 00:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770164658;
	bh=n1aCSIJrA3TCkSpUjBf8aecjU6vRZ2GIjbPWh9mbQqo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oxgd+vYwaHVl6iu/T0H9iLYyTmRWvK1yHjkpoHT2I7tSr397V3y7GsdeQM9cm1vTQ
	 DSHpKGC0nysQLi8ONI+FJuheLG4Os1mJF5PCrXI2UODJUgVa3VUxhEaW0Hnf5VzNl3
	 0rQe/N+9e9yoo5v/6IA8Zef3UHQmcMRqPtiVxes7muljNiGsto4W6qCAH9a0ltDoHe
	 EHSkdGwrSftzB/IYQuNZhbifDr8QYfXoCwVArJbp9lu65njCRZg3tHySd3H0yOmc4C
	 RUPr7ykc+l9g9Oppao8hGqdZf8TXaz7oUmyjJC/64Np5yUFMjBrqezuuOymnYTi7tw
	 ogpO9hh6w8qfg==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-894638da330so63891876d6.1
        for <live-patching@vger.kernel.org>; Tue, 03 Feb 2026 16:24:18 -0800 (PST)
X-Gm-Message-State: AOJu0YywvH2aXYQwpYXED23tAACgRPw1FffryBalgiuz6NUpS4qCXnp5
	V08NnBnkFF+XGs1U/Ll1L6ipp6c76FJ5VWBhx2iwMhadR1bHUFS4KYl1TVCwQBFUZ5mjN2syw6Y
	wEWcGSh1+3iZUMWmoWiDLx0sLC3Apl6Q=
X-Received: by 2002:a05:6214:489:b0:880:48c6:ad02 with SMTP id
 6a1803df08f44-895221b9840mr20098126d6.52.1770164657920; Tue, 03 Feb 2026
 16:24:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260203214006.741364-1-song@kernel.org> <3rufoy2rjvt4apzwplyn6g6cafrz5hxh2b2ug3cmljndctauo5@bskwjecforne>
In-Reply-To: <3rufoy2rjvt4apzwplyn6g6cafrz5hxh2b2ug3cmljndctauo5@bskwjecforne>
From: Song Liu <song@kernel.org>
Date: Tue, 3 Feb 2026 16:24:06 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7tSyGVBBMOV2bc7gvRXCUbeEETUM7qcZ4HU+Z3D=8SEQ@mail.gmail.com>
X-Gm-Features: AZwV_QgYNjtL7WV0OV-7zXYCkcKyJX7OKINCVhn4JiyZ1NtPa5riNHbdSF27vHc
Message-ID: <CAPhsuW7tSyGVBBMOV2bc7gvRXCUbeEETUM7qcZ4HU+Z3D=8SEQ@mail.gmail.com>
Subject: Re: [PATCH] klp-build: Update demangle_name for LTO
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, kernel-team@meta.com, jikos@kernel.org, 
	mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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
	TAGGED_FROM(0.00)[bounces-1973-lists,live-patching=lfdr.de];
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
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 7B53CDFFE1
X-Rspamd-Action: no action

On Tue, Feb 3, 2026 at 3:53=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> On Tue, Feb 03, 2026 at 01:40:06PM -0800, Song Liu wrote:
> > With CONFIG_LTO_CLANG_THIN, __UNIQUE_ID_* can be global. Therefore, it
> > is necessary to demangle global symbols.
>
> Ouch, so LTO is changing symbol bindings :-/
>
> If a patch causes a symbol to change from LOCAL to GLOBAL between the
> original and patched builds, that will break some fundamental
> assumptions in the correlation logic.

This can indeed happen. A function can be "LOCAL DEFAULT" XXXX
in original, and "GLOBAL HIDDEN" XXXX.llvm.<hash> in patched.

I am trying to fix this with incremental steps.

> Also, notice sym->demangled_name isn't used for correlating global
> symbols in correlate_symbols().  That code currently assumes all global
> symbols are uniquely named (and don't change between orig and patched).
> So this first fix seems incomplete.

We still need to fix correlate_symbols(). I am not 100% sure how to do
that part yet.

OTOH, this part still helps. This is because checksum_update_insn()
uses demangled_name. After the fix, if a function is renamed from
XXXX to XXXX.llvm.<hash> after the patch, functions that call the
function are not considered changed.

> > Also, LTO may generate symbols like:
>
> The "also" is a clue that this should probably be two separate patches.
>
> Also, for objtool patches, please prefix the subject with "objtool:", or
> in this case, for klp-specific code, "objtool/klp:".
>
> > __UNIQUE_ID_addressable___UNIQUE_ID_pci_invalid_bar_694_695
> >
> > Remove trailing '_' together with numbers and '.' so that both numbers
> > added to the end of the symbol are removed. For example, the above s
> > ymbol will be demangled as
> >
> > __UNIQUE_ID_addressable___UNIQUE_ID_pci_invalid_bar
>
> This is indeed a bug in demangle_name(), but not specific to LTO.  The
> unique number is added by the __UNIQUE_ID() macro.
>
> I guess in this case LTO is doing some kind of nested __UNIQUE_ID() to
> get two "__UNIQUE_ID" strings and two numbers?  But the bug still exists
> for the non-nested case.

I don't see nested __UNIQUE_ID() without LTO. Both gcc and clang without
LTO only sees one level of __UNIQUE_ID.

With one level of __UNIQUE_ID(), existing code works fine. We just get one
extra "_" at the end of the demanged_name.

>
> > Signed-off-by: Song Liu <song@kernel.org>
> > ---
> >  tools/objtool/elf.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/tools/objtool/elf.c b/tools/objtool/elf.c
> > index 2c02c7b49265..b4a7ea4720e1 100644
> > --- a/tools/objtool/elf.c
> > +++ b/tools/objtool/elf.c
> > @@ -445,9 +445,6 @@ static const char *demangle_name(struct symbol *sym=
)
> >  {
> >       char *str;
> >
> > -     if (!is_local_sym(sym))
> > -             return sym->name;
> > -
> >       if (!is_func_sym(sym) && !is_object_sym(sym))
> >               return sym->name;
> >
> > @@ -463,7 +460,13 @@ static const char *demangle_name(struct symbol *sy=
m)
> >       for (int i =3D strlen(str) - 1; i >=3D 0; i--) {
> >               char c =3D str[i];
> >
> > -             if (!isdigit(c) && c !=3D '.') {
> > +             /*
> > +              * With CONFIG_LTO_CLANG_THIN, the UNIQUE_ID field could
> > +              * be like:
> > +              *   __UNIQUE_ID_addressable___UNIQUE_ID_<name>_628_629
> > +              * Remove all the trailing number, '.', and '_'.
> > +              */
>
> A comment is indeed probably warranted, though I'm thinking it should
> instead go above the function, with examples of both __UNIQUE_ID and "."
> symbols.

I will split the patch into two, and fix the comment and commit log.

Thanks,
Song

