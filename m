Return-Path: <live-patching+bounces-2123-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iFjqIL4OqWl80wAAu9opvQ
	(envelope-from <live-patching+bounces-2123-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 06:03:58 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CB13520AF0E
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 06:03:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 24BC43021B0C
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 05:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECBA31F4634;
	Thu,  5 Mar 2026 05:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ON8p08c2"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F3B13D891
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 05:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772687033; cv=none; b=N0iPye/58z9EbU0EgnLdEDS5AAqZz8nY77pUu5BmY2kTsy4am5ifVYhzJwpIAJc30XJP2TLxkABJIFXmrTxVQgDPYxtnFwF85YS7PRdWu6fuS8QDT/01GcXElwObUnEqQxtaZDVjFrQze9WojPcBRj8J4BaegBy8yGWoL5C6gr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772687033; c=relaxed/simple;
	bh=df5LXaZLAcTf2c/6VkxVDiy+MmWx4fEGrnVCBKS3m7w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SNjMpPfRq8n2ezzWESKUY0mXcKAkGFG08rqcJyccq34tflCUREVYwZp1XrEGkTGXUPKc4bJHmmg96GpOiLn9E+OBS4EvYXbybsaBXbHea7rRWpjLO0yNLckpGMmsf/8KfS7WxAFIMplR9m/LkJWnv0Gdg6WdAttOJT1bwDYK5uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ON8p08c2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A85C2BC9E
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 05:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772687033;
	bh=df5LXaZLAcTf2c/6VkxVDiy+MmWx4fEGrnVCBKS3m7w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ON8p08c2UJXBNa7C9xgy8vkg2CUPzdULbYhO1m3pKfKlj/gsOjFF/BLxcC+ZBWm8m
	 x1lwLn3LPy86Jl3tza9OAcR+kv42HhFKP1877i5ltzrbBlJQFZi2rAD+OBy5PaZUmU
	 0sWAJtZsmTUnP2NHHriNTQ7FbJXLfJmqnGnm/645BLS8+XBjk0ADQ/dZTP19Dhxz6l
	 TDJ+N6QqCdH8tv+ygItBsIAZnAXWPB5kezNtlhclYMCyjdqJSH5ShwjWKqcge5FkVy
	 3E1nMH34SEIyKELafwZSro82xpW/GR0D7fBv6VgyURTzctpJaOEBeCtDVD4nYlcwfn
	 TdptMaYAS+OLw==
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5069b3e0c66so117094541cf.1
        for <live-patching@vger.kernel.org>; Wed, 04 Mar 2026 21:03:53 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWIn5QxaZeztRXbCJGDwinOjanp8DrZ1T2ClaeIZLfe9i2c73Elo2WhjxLfJ4amNxTSwiRYGr2TSfrhAlPp@vger.kernel.org
X-Gm-Message-State: AOJu0YyP+zNT4LZ0IXymi1gmR/DZnowxJOPcz9WklEhMoNOM6Nq2rKUl
	B91CJXBygy3+bTZSQMpF0vYFRDvxrnoMniQBeQ5q+qx8UqYd1csTPOTgVGc6QBsTLKwoPlLgCil
	inSHicMTuGPZpQUKdfMrLc+GD068LzDo=
X-Received: by 2002:ac8:5a81:0:b0:501:4ff7:2641 with SMTP id
 d75a77b69052e-508e69d7266mr11903821cf.37.1772687032627; Wed, 04 Mar 2026
 21:03:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226005436.379303-1-song@kernel.org> <20260226005436.379303-9-song@kernel.org>
 <alpine.LSU.2.21.2602271052240.374@pobox.suse.cz> <CAPhsuW69EZTcMGyXSKv2fEjh7mhtYaSxriZrSgX0nTPCEYKS7A@mail.gmail.com>
 <alpine.LSU.2.21.2603020930540.21479@pobox.suse.cz> <aaiI7zv2JVgXZkPm@redhat.com>
 <CAPhsuW6Nx6meWVCkTJXmp5BzTX_2s2dt1j+C-=AtMzQ8ZV396A@mail.gmail.com> <aajexDFNdFz_Lsrp@redhat.com>
In-Reply-To: <aajexDFNdFz_Lsrp@redhat.com>
From: Song Liu <song@kernel.org>
Date: Wed, 4 Mar 2026 21:03:41 -0800
X-Gmail-Original-Message-ID: <CAPhsuW51ihr9mDv6Ov+vJAn_7feqTra2XFXUFm-cb4teE_4s8w@mail.gmail.com>
X-Gm-Features: AaiRm52bIFGCAQ2ahvlqKmyfoihoK-Fl6z4hWlmfINVHY7UjyfKk4I8SMc1GNRQ
Message-ID: <CAPhsuW51ihr9mDv6Ov+vJAn_7feqTra2XFXUFm-cb4teE_4s8w@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] livepatch: Add tests for klp-build toolchain
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, jpoimboe@kernel.org, 
	jikos@kernel.org, pmladek@suse.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CB13520AF0E
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
	TAGGED_FROM(0.00)[bounces-2123-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Wed, Mar 4, 2026 at 5:39=E2=80=AFPM Joe Lawrence <joe.lawrence@redhat.co=
m> wrote:
[...]
> >
>
> Gah, sorry about those internal links.
>
> Try:
>
> https://joe-lawrence.github.io/klp-build-selftest-artifacts/report.html
> https://joe-lawrence.github.io/klp-build-selftest-artifacts/report.txt

Thanks! These look pretty good!

[...]

> It is strange, but for my experiment, I wanted minimal disruption to the
> tree.  For the "real" changeset, upstream + some testing CONFIG_ sounds
> good to me.
>
> > > That said, patching a dummy patched-tree isn't be perfect either,
> > > particularly in the runtime sense.  You're not testing a release kern=
el,
> > > but something slightly different.
> >
> > This should not be a problem. The goal is to test the klp-build toolcha=
in.
> >
>
> Right, perhaps klp-build testing always targets a slightly modified
> kernel (or at least CONFIG_) while livepatching testing operates against
> the stock tree?

Agreed.

> > > (Tangent: kpatch-build implemented a unit test scheme that cached obj=
ect
> > > files for even greater speed and fixed testing.  I haven't thought ab=
out
> > > how a similar idea might work for klp-build.)
> >
> > I think it is a good idea to have similar .o file tests for klp-diff
> > in klp-build.
> >
>
> kpatch-build uses a git submodule (a joy to work with /s), but maybe
> upstream tree can fetch the binary objects from some external
> (github/etc.) source?  I wonder if there is any kselftest precident for
> this, we'll need to investigate that.

Ah, right. I forgot that carrying .o files in the upstream kernel is a bit
weird. That may indeed be a blocker.

[...]
> > >
> > > 8- Probably more I've already forgotten about :) Cross-compilation ma=
y
> > > be interesting for build testing in the future.  For the full AI crea=
ted
> > > commentary, there's https://github.com/joe-lawrence/linux/blob/klp-bu=
ild-selftests/README.md
> >
> > Yes, cross-compilation can be really useful.
> >
>
> Agreed (I think Josh may be working on arm64 klp-build?) how many
> dimensions of testing are we up to now :)

We currently cross compile arm64 livepatch on x86_64 hosts with
kpatch-build. We don't have to do the same with klp-build. But it is
good to have the option. :)

Thanks,
Song

