Return-Path: <live-patching+bounces-2136-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WIpZN48NqmlbKQEAu9opvQ
	(envelope-from <live-patching+bounces-2136-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 00:11:11 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E5347219316
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 00:11:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 00CAC30074F5
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 23:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47FE936402B;
	Thu,  5 Mar 2026 23:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DiPzJkRk"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258A929B799
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 23:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772752265; cv=none; b=kVYhMFYXBn0UCfT1rtMLpnKc7sC2nlv4/UM41veoQC2A4KFSPJP3YstL7XlViWRCdTplyAMaFqdAAq2jSQo9NV7leUyOn9HIlXwe9zcYhzgOK6XUAUQWZUt03pcUdP8X7ivZBxaBIQxDeF/2Ow9Vm2fu2kOA8wo243v9TerlABQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772752265; c=relaxed/simple;
	bh=j1TB8AjuFpYoGZlG8TOUXKgqAv2GwoA5+0lyZR+l8U0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wi7Wp5I44O17l06yQzS//hMGNztEB1OaJZPGgUuiSzxlnI0IZa1NqiursYLmZ2iCQmaJ5r9AzttgEfwwk6uxfGWWjwzSga1jxniT+sNNrm1X4yOc89vLMxJZ0j0aJ6lPpmdgKhHAH5YySLwM0HA/HNEPRYVYkJWLGcMpE1Hmby4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DiPzJkRk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC97AC2BC87
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 23:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772752264;
	bh=j1TB8AjuFpYoGZlG8TOUXKgqAv2GwoA5+0lyZR+l8U0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DiPzJkRk4EMGbhTDnyUpuyowCEe0BI+uuS60WNadwtMPgAdHvcIRRAe6jJM6ST8/N
	 ge3zhBgbPinWIJoN9MGMKtdtiON/3o3921+M2IlwqPaKxb5xkWRF0lDov9ufm98XlW
	 /2+47EfzkID1iwXhA7Uccw+W442B3/wzchGweOTyX4FUCFCrMTVg35nAnUyiWyd8Lo
	 YLjN8foryX11DDqko9VmXNjoH8/HaLIDHzywaByayYj5nv5Owiig8QxGEGjHg7tXR+
	 d/qRPzhSmQPCdLVAN165Sxd5y1XdbeA6AUzmDyzM85Zqp9JNi6Il23eWSMsmNM3SNz
	 96GzNHsH+wStg==
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-505e2e4c35fso82419031cf.3
        for <live-patching@vger.kernel.org>; Thu, 05 Mar 2026 15:11:04 -0800 (PST)
X-Gm-Message-State: AOJu0YxlbV0vlCfwuuhZbKamL4QUdtTuUVfEabjkEglGd5ARA8VaOMvx
	NRKBDBrTWDDutYnx9rxHP5jXSlZto9oAAHe7VBtnQgbgaC6SjzerdE8jaxD/bRH16bnoprWaFSw
	Ur0EWnjq6qizj+jhRdYfBguE0qHGkgkY=
X-Received: by 2002:ac8:7f0c:0:b0:4ed:b012:9706 with SMTP id
 d75a77b69052e-508f493e1c0mr2002211cf.43.1772752263942; Thu, 05 Mar 2026
 15:11:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226005436.379303-1-song@kernel.org> <20260226005436.379303-8-song@kernel.org>
 <4j5chvfnlugrpycrehextkinzfle7mokkos4ooa2ali2susov7@ncunycnjajtu>
In-Reply-To: <4j5chvfnlugrpycrehextkinzfle7mokkos4ooa2ali2susov7@ncunycnjajtu>
From: Song Liu <song@kernel.org>
Date: Thu, 5 Mar 2026 15:10:52 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6XWa9zNXCutFxC-=yu6-63fwYYvvUyMD17VHhX_LP5KQ@mail.gmail.com>
X-Gm-Features: AaiRm5010jpBMEu6wAaj7SLbsDW1HeHluCyt8Cl9lePt801F75DDId0FyuJqT5Q
Message-ID: <CAPhsuW6XWa9zNXCutFxC-=yu6-63fwYYvvUyMD17VHhX_LP5KQ@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] objtool/klp: Correlate locals to globals
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: live-patching@vger.kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	pmladek@suse.com, joe.lawrence@redhat.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E5347219316
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
	TAGGED_FROM(0.00)[bounces-2136-lists,live-patching=lfdr.de];
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
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Mar 5, 2026 at 11:51=E2=80=AFAM Josh Poimboeuf <jpoimboe@kernel.org=
> wrote:
>
> On Wed, Feb 25, 2026 at 04:54:35PM -0800, Song Liu wrote:
> > Allow correlating original locals to patched globals, and vice versa.
> > This is needed when:
> >
> > 1. User adds/removes "static" for a function.
> > 2. CONFIG_LTO_CLANG_THIN promotes local functions and objects to global
> >    and add .llvm.<hash> suffix.
> >
> > Given this is a less common scenario, show warnings when this is needed=
.
> >
> > Signed-off-by: Song Liu <song@kernel.org>
> > ---
> >  tools/objtool/klp-diff.c | 34 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> >
> > diff --git a/tools/objtool/klp-diff.c b/tools/objtool/klp-diff.c
> > index 92043da0ed0b..5cda965807a5 100644
> > --- a/tools/objtool/klp-diff.c
> > +++ b/tools/objtool/klp-diff.c
> > @@ -517,6 +517,40 @@ static int correlate_symbols(struct elfs *e)
> >               }
> >       }
> >
> > +     /* Correlate original locals with patched globals */
> > +     for_each_sym(e->orig, sym1) {
> > +             if (sym1->twin || dont_correlate(sym1) || !is_local_sym(s=
ym1))
> > +                     continue;
> > +
> > +             sym2 =3D find_global_symbol_by_name(e->patched, sym1->nam=
e);
> > +             if (!sym2 && find_global_symbol_by_demangled_name(e->patc=
hed, sym1, &sym2))
> > +                     return -1;
> > +
> > +             if (sym2 && !sym2->twin) {
> > +                     sym1->twin =3D sym2;
> > +                     sym2->twin =3D sym1;
> > +                     WARN("correlate LOCAL %s (original) to GLOBAL %s =
(patched)",
> > +                          sym1->name, sym2->name);
>
> I think this correlation is deterministic so there's no need for the
> warning?

Yes, we can remove this.

I also fixed 1/8 and 3/8. I will send v4 of patch 1/8 to 7/8, as we discuss
more with 8/8.

Thanks,
Song

