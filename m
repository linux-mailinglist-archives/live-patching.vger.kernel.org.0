Return-Path: <live-patching+bounces-2077-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OI1hKc7rnGnqMAQAu9opvQ
	(envelope-from <live-patching+bounces-2077-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 24 Feb 2026 01:07:42 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 050D718021C
	for <lists+live-patching@lfdr.de>; Tue, 24 Feb 2026 01:07:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8B09430479E0
	for <lists+live-patching@lfdr.de>; Tue, 24 Feb 2026 00:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C09A171CD;
	Tue, 24 Feb 2026 00:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GnqS2ADg"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09994288AD
	for <live-patching@vger.kernel.org>; Tue, 24 Feb 2026 00:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771891656; cv=none; b=raPt6zPRYFyDkD5sc12EmpnuGA8aN3CG8QVGVzXQgVcFpjWyAUrwhSas/p0v/bVq/3RxYYOSCkF0RcS3f2JDjMUUtyiW1ua4W45kpw6MI+1KyfrAluVt0RHonJV3M1RuXoBz6Jgwx+04nNerXmrtcdmahL2WAiIKD+qc8Z6xlEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771891656; c=relaxed/simple;
	bh=5eZbmRvwdOESyzhegRM2UnvoXfS4i+jDoJ3zmR4LOwI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I2I6G9YBOKAAIBkEJ1Px68lsBpMplv0mnIL7ZiGt68fmMBw+nE8aNfgGihTWrvgisulFTJ8GjLiFggdx9FExC6fXvKePyVKxKFsafrGSUlTZlGkKxwvRtYCdFB36NvJlI+fJVK8jHfF4HueUgStnJeO/OHp7afwKg4sDgvpSPgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GnqS2ADg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0004C4AF09
	for <live-patching@vger.kernel.org>; Tue, 24 Feb 2026 00:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771891655;
	bh=5eZbmRvwdOESyzhegRM2UnvoXfS4i+jDoJ3zmR4LOwI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=GnqS2ADgQSHUrGtEmQKsOjax+chBZxWGKQvr2RlCX9/ifQC7tx7MmuDuUKAdNzOSc
	 yQRc6uFhKDOStiEhinPESESIUvdzBNk9UWPKSmwdmAOl8wKwsqjtPFhOnPbUJ4vBD6
	 1ewUb9yLMA84yTQ+kwwchnBNLK3/IV/OTsd+Vx2IYIolOunSg3Zdo7Ku+RZAcPMnXz
	 3vIDuWZLY3GZjwX0WavzfK92pl/TAUIvXBC61eP5UGqKoGcESoKqPH3aPKpqeqiphX
	 fKX+LnYZxUmS1z08/idsbe++qlzXqvbrxxIgEAEZs7UZFmyR8pZtOE1laxsIaKmFPy
	 dPGQJxPmE2ZNQ==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-895071c5527so59141306d6.1
        for <live-patching@vger.kernel.org>; Mon, 23 Feb 2026 16:07:35 -0800 (PST)
X-Gm-Message-State: AOJu0YwyJgqVdldMgr2f9/rvkPO2oDuWi64gz+6glT7PLR2x8W6tfmXq
	0XZM6lFWBIqD5iTD3cnl9yECJSpQcO7s0HgeRkKhBbdKpNZXHF1yS4yi5Db0Pge8FZ4Xeb/vN8r
	aEW++Bl35iQB26S7uBkm04kmzE36X8CY=
X-Received: by 2002:a05:6214:2683:b0:897:30b:e1f4 with SMTP id
 6a1803df08f44-89979c5548emr164646726d6.13.1771891654785; Mon, 23 Feb 2026
 16:07:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260219222239.3650400-1-song@kernel.org> <20260219222239.3650400-7-song@kernel.org>
 <neszhyiktzw4uo4lc556jdfie2xu3dop5j4u7zo4fziqwn75an@6ui4e5fuyv5j>
In-Reply-To: <neszhyiktzw4uo4lc556jdfie2xu3dop5j4u7zo4fziqwn75an@6ui4e5fuyv5j>
From: Song Liu <song@kernel.org>
Date: Mon, 23 Feb 2026 16:07:23 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7V6B5DRNK6_hhwRPXgeetd60yZyncmj1933mT++vVDmg@mail.gmail.com>
X-Gm-Features: AaiRm52TJqM2L2unlyhzas3PY167qJZHOejfTXdcJtBTPuDQ2ZqTIjD7aotEdD8
Message-ID: <CAPhsuW7V6B5DRNK6_hhwRPXgeetd60yZyncmj1933mT++vVDmg@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] objtool/klp: Match symbols based on demangled_name
 for global variables
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	pmladek@suse.com, joe.lawrence@redhat.com, kernel-team@meta.com
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
	TAGGED_FROM(0.00)[bounces-2077-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 050D718021C
X-Rspamd-Action: no action

Hi Josh,

Thanks for the review!

On Mon, Feb 23, 2026 at 2:56=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Thu, Feb 19, 2026 at 02:22:37PM -0800, Song Liu wrote:
> > correlate_symbols will always try to match full name first. If there is=
 no
> > match, try match only demangled_name.
>
> In commit logs, please add "()" to function names, like
> correlate_symbols().

Noted.

>
> > +++ b/tools/objtool/elf.c
> > @@ -323,6 +323,19 @@ struct symbol *find_global_symbol_by_name(const st=
ruct elf *elf, const char *nam
> >       return NULL;
> >  }
> >
> > +void iterate_global_symbol_by_demangled_name(const struct elf *elf,
> > +                                          const char *demangled_name,
> > +                                          void (*process)(struct symbo=
l *sym, void *data),
> > +                                          void *data)
> > +{
> > +     struct symbol *sym;
> > +
> > +     elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash(=
demangled_name)) {
> > +             if (!strcmp(sym->demangled_name, demangled_name) && !is_l=
ocal_sym(sym))
> > +                     process(sym, data);
> > +     }
> > +}
> > +
>
> I think a saner interface would be something like:
>
> struct symbol *find_global_demangled_symbol(const struct elf *elf, const =
char *demangled_name)
> {
>         struct symbol *ret =3D NULL;
>
>         elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash(=
demangled_name)) {
>                 if (!is_local_sym(sym) && !strcmp(sym->demangled_name, de=
mangled_name)) {
>                         if (ret)
>                                 return ERR_PTR(-EEXIST);
>                         ret =3D sym;
>                 }
>         }
>
>         return ret;
> }

I had something similar to this initially. However, we need to check
sym->twin, and skip symbols that already have correlations. For
example, if we have foo.llvm.123 and foo.llvm.456 in the original
kernel, and foo.llvm.123 and foo.llvm.789 in the patched kernel,
we will match foo.llvm.456 to foo.llvm.789 without ambiguity.
Since elf.c doesn't touch sym->twin at all, I think it is cleaner to
keep this logic in klp-diff.c. If you think it is OK to have elf.c
handle this, we can do something like:

struct symbol *find_global_demangled_symbol(const struct elf *elf,
const char *demangled_name)
{
        struct symbol *ret =3D NULL;

        elf_hash_for_each_possible(symbol_name, sym, name_hash,
str_hash(demangled_name)) {
                if (!is_local_sym(sym) &&
                    !strcmp(sym->demangled_name, demangled_name) &&
                    !sym->twin) {  /* We need to add this */
                        if (ret)
                                return ERR_PTR(-EEXIST);
                        ret =3D sym;
                }
        }

        return ret;
}

I personally like v2 patch better. But I wouldn't mind changing to the
above version in v3.

> > @@ -453,8 +493,27 @@ static int correlate_symbols(struct elfs *e)
> >                       continue;
> >
> >               sym2 =3D find_global_symbol_by_name(e->patched, sym1->nam=
e);
> > +             if (sym2 && !sym2->twin) {
> > +                     sym1->twin =3D sym2;
> > +                     sym2->twin =3D sym1;
> > +             }
> > +     }
> > +
> > +     /*
> > +      * Correlate globals with demangled_name.
> > +      * A separate loop is needed because we want to finish all the
> > +      * full name correlations first.
> > +      */
> > +     for_each_sym(e->orig, sym1) {
> > +             if (sym1->bind =3D=3D STB_LOCAL || sym1->twin)
> > +                     continue;
> > +
> > +             if (find_global_symbol_by_demangled_name(e->patched, sym1=
, &sym2))
> > +                     return -1;
> >
> >               if (sym2 && !sym2->twin) {
> > +                     WARN("correlate %s (original) to %s (patched)",
> > +                          sym1->name, sym2->name);
>
> Since there's not actually any ambiguity at this point, do we actually
> need a warning?

I cannot think of a case where this match is ambiguous, so yes,
we can remove this warning.

Thanks,
Song

