Return-Path: <live-patching+bounces-2078-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UBRbDhTsnGnqMAQAu9opvQ
	(envelope-from <live-patching+bounces-2078-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 24 Feb 2026 01:08:52 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A547E180232
	for <lists+live-patching@lfdr.de>; Tue, 24 Feb 2026 01:08:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F3CC9304B5A5
	for <lists+live-patching@lfdr.de>; Tue, 24 Feb 2026 00:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7BC6288D2;
	Tue, 24 Feb 2026 00:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0EjDsR2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949E2171CD
	for <live-patching@vger.kernel.org>; Tue, 24 Feb 2026 00:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771891702; cv=none; b=FQYCRbe5UldWoqU23xyivpUMUjM3kKfM0pGJoIJC0gBSH8fpDC4zSY+mXsrMQP3o7lHMli6wlQKYO/ujanukvLEFDAJOvrfVy+ztyVb5Rcqfx18sXn7kOXLRDkTAITpsPBE/THlocoAA/DfInsO7cOwrSdeiYu5h75zWpgonj/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771891702; c=relaxed/simple;
	bh=52Ma0wZAzlQrX0NnPLIDDYv/AilQLQfkMTf+BqM8kOs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nxghjxjl1XzeG0Ni+XJpwlSdwZXlD3+ETsefBr5Ib/weT5wvaTnZtyqonXKy8CU8c1snMJ+0y+8LLaX0TCCvXExpZ8YlJfIyWQWwBKgsjYV2SEF2FdaGYzybtqGc79Ph5yHdpOJzOBTTIhfmkdeC2hDxRctzXkJljnFDmOLHIAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0EjDsR2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422A6C19424
	for <live-patching@vger.kernel.org>; Tue, 24 Feb 2026 00:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771891702;
	bh=52Ma0wZAzlQrX0NnPLIDDYv/AilQLQfkMTf+BqM8kOs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=c0EjDsR2Umb+yC4O11ariZr2UwxJLP6ppY35Ih9YB7nn4ummfhuLQLxzrX1+O6chi
	 4to2vFmQ1lyIurQxDQaTkJy9YFBuBKv6shvJdEwz3uEPWtZ11uD/wtSg3+7rRFiam/
	 ik5rUsMUxDmwumWSSYI/m3syaBo45rh+KKqkkLj6f1EujO0TZc2ZKtp2lavZoxjfyX
	 MfuNDWMxgegjeoTdyBIZ6QtjnaqzPU+CvrxYrpPccDfPow6undawEmyBhno/OPIztk
	 ykwP1wdDJoE8Pkg0I4Xt5euX/pjZCXXc28weWwj0W1rY7+QZgiyAPBArzfwMZzUhVJ
	 zDDf+O5ouBLaQ==
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-506a1b23c05so62477241cf.0
        for <live-patching@vger.kernel.org>; Mon, 23 Feb 2026 16:08:22 -0800 (PST)
X-Gm-Message-State: AOJu0Yx0+snZ+3W92xEn4pr12kd+ZArrJRoCDq9wvklCyN9J3Hif6r3O
	PModqB+f16LT82OAKnl5Zt2EQpLsYRgtOEjAA+dT9DJSAQHIfeI7JPa79onl8paBGA3NH6EtwNV
	5OlXmcToaVsd0yoZ8KjUm5FZ6JR6Jxkc=
X-Received: by 2002:a05:622a:2c8:b0:506:a142:6124 with SMTP id
 d75a77b69052e-5070bbda3b5mr145253591cf.24.1771891701478; Mon, 23 Feb 2026
 16:08:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260219222239.3650400-1-song@kernel.org> <20260219222239.3650400-8-song@kernel.org>
 <mkrgmnqv6djhzxvjqzjicenpscwwwz6kojhqeo45qbh7gyr4ar@2fy6hit2kuli>
In-Reply-To: <mkrgmnqv6djhzxvjqzjicenpscwwwz6kojhqeo45qbh7gyr4ar@2fy6hit2kuli>
From: Song Liu <song@kernel.org>
Date: Mon, 23 Feb 2026 16:08:10 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6wD2hX57xOEDOG3UNivfOyMYNYMCjCFa=0z9nP_OddqA@mail.gmail.com>
X-Gm-Features: AaiRm52VPjSqKMz5O1lA9142ewDFZSmbasgJhC2KY0eLWZ4jxe9i62-RGcygf7s
Message-ID: <CAPhsuW6wD2hX57xOEDOG3UNivfOyMYNYMCjCFa=0z9nP_OddqA@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] objtool/klp: Correlate locals to globals
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	pmladek@suse.com, joe.lawrence@redhat.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2078-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: A547E180232
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 2:58=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Thu, Feb 19, 2026 at 02:22:38PM -0800, Song Liu wrote:
> > +++ b/tools/objtool/klp-diff.c
> > @@ -519,6 +519,37 @@ static int correlate_symbols(struct elfs *e)
> >               }
> >       }
> >
> > +     /* Correlate original locals with patched globals */
> > +     for_each_sym(e->orig, sym1) {
> > +             if (sym1->twin || dont_correlate(sym1) || !is_local_sym(s=
ym1))
> > +                     continue;
> > +             sym2 =3D find_global_symbol_by_name(e->patched, sym1->nam=
e);
> > +             if (!sym2 && find_global_symbol_by_demangled_name(e->patc=
hed, sym1, &sym2))
> > +                     return -1;
> > +             if (sym2 && !sym2->twin) {
> > +                     sym1->twin =3D sym2;
> > +                     sym2->twin =3D sym1;
> > +                     WARN("correlate LOCAL %s (original) to GLOBAL %s =
(patched)",
> > +                          sym1->name, sym2->name);
> > +             }
> > +     }
>
> Try to follow the existing newline conventions which break the code into
> "paragraphs", like:
>
>         for_each_sym(e->orig, sym1) {
>                 if (sym1->twin || dont_correlate(sym1) || !is_local_sym(s=
ym1))
>                         continue;
>
>                 sym2 =3D find_global_symbol_by_name(e->patched, sym1->nam=
e);
>                 if (!sym2 && find_global_symbol_by_demangled_name(e->patc=
hed, sym1, &sym2))
>                         return -1;
>
>                 if (sym2 && !sym2->twin) {
>                         sym1->twin =3D sym2;
>                         sym2->twin =3D sym1;
>                         WARN("correlate LOCAL %s (original) to GLOBAL %s =
(patched)",
>                              sym1->name, sym2->name);
>                 }
>         }
>
> > +
> > +     /* Correlate original globals with patched locals */
> > +     for_each_sym(e->patched, sym2) {
> > +             if (sym2->twin || dont_correlate(sym2) || !is_local_sym(s=
ym2))
> > +                     continue;
> > +             sym1 =3D find_global_symbol_by_name(e->orig, sym2->name);
> > +             if (!sym1 && find_global_symbol_by_demangled_name(e->patc=
hed, sym2, &sym1))
>                                                                   ^^^^^^^=
^^^
>
> should be e->orig?

Yes, exactly...

Thanks for catching this bug!
Song

