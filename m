Return-Path: <live-patching+bounces-2079-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WLR8MMgTnml+TQQAu9opvQ
	(envelope-from <live-patching+bounces-2079-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 24 Feb 2026 22:10:32 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id DDEC018C9C1
	for <lists+live-patching@lfdr.de>; Tue, 24 Feb 2026 22:10:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 05EEB30091C9
	for <lists+live-patching@lfdr.de>; Tue, 24 Feb 2026 21:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6ED7A33C199;
	Tue, 24 Feb 2026 21:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jVaL4ENc"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B6A91EB5E1
	for <live-patching@vger.kernel.org>; Tue, 24 Feb 2026 21:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771967426; cv=none; b=lQtu42pVvgc0sCtqeE3p0+n3eU84lqWKZrFEgA2iCVEaC1Li0Z2Q0R+H9ttS8LON0UYnC19/UQfDMeUJDcv6aXoLKNNT0EeFGoKMoa0AAKbRDO+z9/TzK+6BkYLOZ5DZsLpbC9aS2iA+dyzaWOzPH5xk0S/qLdK4muo4uXGf5Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771967426; c=relaxed/simple;
	bh=NV6TWXj2CJsbGb55sqTJ1c6bdoH7gzidJngWmVXLCfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Su9E2ruaFVOH3IsqkfNKEDoH/rObjVaw3xc+3hxapQw1m70A517nMniJW/6J8LRbrAYRXW4nKZdBP5uNsJ0oRxos7wRUVO2bqAVtVU9o9sF/b0bihwli+8403GZyS0JeRc1psBNZ0px6Jwm0FTIsu0a/nrQ1wvgENgqomE1mqV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jVaL4ENc; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B2CC116D0;
	Tue, 24 Feb 2026 21:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771967425;
	bh=NV6TWXj2CJsbGb55sqTJ1c6bdoH7gzidJngWmVXLCfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jVaL4ENcWnv6S7mx75z4fnqveXUb0sRQGVd1zqeCJgJZpfEhLOcf6Wg070adlb4gO
	 dtAlTjZ4KonAJaa0YN3MpKeP0HQW+IlyI5GKY/kXBgDar5lRIJDL/dnk0LbjVF0gsN
	 uxKSU2VMlB4QuLvISDtqcyG7jW00yX4IrFTI2ckaix2OnTHh/MgQEw0y/iXB0uoeIj
	 fu3PJRhbHzWGZWAUaGv0cAUX5hAsn+qgEmclGqqdbd8r8ohmm5Eb5MVliEemOSBMTe
	 aTNERceXfduj5fa3AiXquVbcPPA+jlum1zutjPKGmT41ftKix833aY4nSlWHeYOZUS
	 cfPcP1q19oapg==
Date: Tue, 24 Feb 2026 13:10:23 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Song Liu <song@kernel.org>
Cc: live-patching@vger.kernel.org, jikos@kernel.org, mbenes@suse.cz, 
	pmladek@suse.com, joe.lawrence@redhat.com, kernel-team@meta.com
Subject: Re: [PATCH v2 6/8] objtool/klp: Match symbols based on
 demangled_name for global variables
Message-ID: <bnjywtiec4uxzshqmlydkxjsskogmb2afwbgwjrtubbsb5eo6y@3vnmwh6htywh>
References: <20260219222239.3650400-1-song@kernel.org>
 <20260219222239.3650400-7-song@kernel.org>
 <neszhyiktzw4uo4lc556jdfie2xu3dop5j4u7zo4fziqwn75an@6ui4e5fuyv5j>
 <CAPhsuW7V6B5DRNK6_hhwRPXgeetd60yZyncmj1933mT++vVDmg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAPhsuW7V6B5DRNK6_hhwRPXgeetd60yZyncmj1933mT++vVDmg@mail.gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2079-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jpoimboe@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DDEC018C9C1
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 04:07:23PM -0800, Song Liu wrote:
> > > +void iterate_global_symbol_by_demangled_name(const struct elf *elf,
> > > +                                          const char *demangled_name,
> > > +                                          void (*process)(struct symbol *sym, void *data),
> > > +                                          void *data)
> > > +{
> > > +     struct symbol *sym;
> > > +
> > > +     elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash(demangled_name)) {
> > > +             if (!strcmp(sym->demangled_name, demangled_name) && !is_local_sym(sym))
> > > +                     process(sym, data);
> > > +     }
> > > +}
> > > +
> >
> > I think a saner interface would be something like:
> >
> > struct symbol *find_global_demangled_symbol(const struct elf *elf, const char *demangled_name)
> > {
> >         struct symbol *ret = NULL;
> >
> >         elf_hash_for_each_possible(symbol_name, sym, name_hash, str_hash(demangled_name)) {
> >                 if (!is_local_sym(sym) && !strcmp(sym->demangled_name, demangled_name)) {
> >                         if (ret)
> >                                 return ERR_PTR(-EEXIST);
> >                         ret = sym;
> >                 }
> >         }
> >
> >         return ret;
> > }
> 
> I had something similar to this initially. However, we need to check
> sym->twin, and skip symbols that already have correlations. For
> example, if we have foo.llvm.123 and foo.llvm.456 in the original
> kernel, and foo.llvm.123 and foo.llvm.789 in the patched kernel,
> we will match foo.llvm.456 to foo.llvm.789 without ambiguity.
> Since elf.c doesn't touch sym->twin at all, I think it is cleaner to
> keep this logic in klp-diff.c. If you think it is OK to have elf.c
> handle this, we can do something like:
> 
> struct symbol *find_global_demangled_symbol(const struct elf *elf,
> const char *demangled_name)
> {
>         struct symbol *ret = NULL;
> 
>         elf_hash_for_each_possible(symbol_name, sym, name_hash,
> str_hash(demangled_name)) {
>                 if (!is_local_sym(sym) &&
>                     !strcmp(sym->demangled_name, demangled_name) &&
>                     !sym->twin) {  /* We need to add this */
>                         if (ret)
>                                 return ERR_PTR(-EEXIST);
>                         ret = sym;
>                 }
>         }
> 
>         return ret;
> }
> 
> I personally like v2 patch better. But I wouldn't mind changing to the
> above version in v3.

Ah, I see.  Yeah, the v2 implementation seems ok.

-- 
Josh

