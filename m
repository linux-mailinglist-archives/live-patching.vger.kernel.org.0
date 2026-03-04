Return-Path: <live-patching+bounces-2105-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IFm5DoC8qGlbwwAAu9opvQ
	(envelope-from <live-patching+bounces-2105-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 00:13:04 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D7FD208E62
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 00:13:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 278113013EC0
	for <lists+live-patching@lfdr.de>; Wed,  4 Mar 2026 23:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3368E376489;
	Wed,  4 Mar 2026 23:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMp9JXIU"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1055C371046
	for <live-patching@vger.kernel.org>; Wed,  4 Mar 2026 23:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772665981; cv=none; b=BHpzDBZDF+crNg6BXh0rxcyhlZrvrcFsC0XVGYChsxlPgSO17kr2a3bg98k3SkKI6cKY7Vwed3fwExA+S9QxJB7t+H+snEzfVfikbu7ADVxs9B6R+IEBYuupKBaVbbtlDztDMMi51iJL0qgd8jVqgsq7Z+o/ixEJ6f1AdJ7e424=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772665981; c=relaxed/simple;
	bh=EzTxkgNLTwiEKzUr6JpIRalVb5Rzm6/I05a0C2cAJo0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qya7o8wdjtU/+GWGfbekAy03lfP7lEmAcD4IQtYw5e0M1lo0/04JjNCHwbsTd7220LP9cOQyf3HEpbvzqvAwAxaIvLoEcYp3n+biYsLgqc9WqKx+3fm3TH9Bskc8WZ371CMkXJAIsG9kRaUHahWI4yNp8lf3OxchifuovdnCQsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMp9JXIU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6CEC4CEF7
	for <live-patching@vger.kernel.org>; Wed,  4 Mar 2026 23:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772665980;
	bh=EzTxkgNLTwiEKzUr6JpIRalVb5Rzm6/I05a0C2cAJo0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WMp9JXIUxrLzpBsOBkQKqTPTlfkCcJMokJdgQHz/N6v7SVEPcNq7t7LRLbsse2zyG
	 JPMDi42JIuh3foF+oZcHmDy/nTExiovBw/eje+OhM8ZFeABQHzL4d6yRjegSdpVq9y
	 Mg9PA0dG7P809FpU2M+uj/QtENSYNFTdGspoJcddZUM9dzSeokyJtD/Nppv4Pg0cqF
	 xFRzQOLSHhWZ9Lpe4O4+L+uFrToDr77AR0UiiR6l8qkQDNnVTij9vzkaV317I3qUg/
	 LGUyYEm78si5rgvdB4U2q4cBPWoWTqF3drw7Hg6HzJtnmHNezoSiOjbH+7qecnKy8I
	 qd/k0/V8ZQ9gw==
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-899f27df3d1so41092386d6.3
        for <live-patching@vger.kernel.org>; Wed, 04 Mar 2026 15:13:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUeHSanQI+JRIDyNO83WO9FgmdIzPQkw7Jyqb5rORgUxUOhmrqywndoqg2IpxoscSqUhhqc9pA1mxepPEkO@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9jpQ9fl5yX/HmCkZ5M+1sMgYDhjVIOOtQSRkrBtrsidYzfhSm
	j5OwUcY/exzXvU7YYHt0DCISPLS53GaAdLR1Yq26vCilWIAhgZGedggSB1MkVPRLdLM1ENwZQ4+
	fDWx76ra7KPtzxIPTmihuhaAHJPhSeyE=
X-Received: by 2002:a05:6214:1d06:b0:89a:110f:8946 with SMTP id
 6a1803df08f44-89a1997a12bmr55017816d6.13.1772665979660; Wed, 04 Mar 2026
 15:12:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260226005436.379303-1-song@kernel.org> <20260226005436.379303-9-song@kernel.org>
 <alpine.LSU.2.21.2602271052240.374@pobox.suse.cz> <CAPhsuW69EZTcMGyXSKv2fEjh7mhtYaSxriZrSgX0nTPCEYKS7A@mail.gmail.com>
 <alpine.LSU.2.21.2603020930540.21479@pobox.suse.cz> <aaiI7zv2JVgXZkPm@redhat.com>
In-Reply-To: <aaiI7zv2JVgXZkPm@redhat.com>
From: Song Liu <song@kernel.org>
Date: Wed, 4 Mar 2026 15:12:48 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6Nx6meWVCkTJXmp5BzTX_2s2dt1j+C-=AtMzQ8ZV396A@mail.gmail.com>
X-Gm-Features: AaiRm51hrkQbyWzLyZievy-A76YpPtqGvbL3sHFoEikUqIY3xSXWpcFK_0CTmW8
Message-ID: <CAPhsuW6Nx6meWVCkTJXmp5BzTX_2s2dt1j+C-=AtMzQ8ZV396A@mail.gmail.com>
Subject: Re: [PATCH v3 8/8] livepatch: Add tests for klp-build toolchain
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org, jpoimboe@kernel.org, 
	jikos@kernel.org, pmladek@suse.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8D7FD208E62
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2105-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,functions.sh:url,mail.gmail.com:mid]
X-Rspamd-Action: no action

On Wed, Mar 4, 2026 at 11:33=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
[...]

> I've been tinkering with ideas in this space, though I took it in a very
> different direction.
>
> (First a disclaimer, this effort is largely the result of vibe coding
> with Claude to prototype testing concepts, so I don't believe any of it
> is reliable or upstream-worthy at this point.)
>
> From a top-down perspective, I might start with the generated test
> reports:
>
> - https://file.rdu.redhat.com/~jolawren/artifacts/report.html
> - https://file.rdu.redhat.com/~jolawren/artifacts/report.txt

I cannot access these two links.

> and then in my own words:
>
[...]
>
> 5- Two patch targets:
>
> a) current-tree - target the user's current source tree
> b) patched-tree - (temporarily) patch the user's tree to *exactly* what
>                   we need to target
>
> Why?  In the kpatch-build project, patching the current-tree meant we
> had to rebase patches for every release.  We also had to hunt and find
> precise scenarios across the kernel tree to test, hoping they wouldn't
> go away in future versions.  In other cases, the kernel or compiler
> changed and we weren't testing the original problem any longer.

I would prefer making patched-tree as upstream + some different
CONFIG_s. Otherwise, we will need to carry .patch files for the
patched-tree in selftests, which seems weird.

> That said, patching a dummy patched-tree isn't be perfect either,
> particularly in the runtime sense.  You're not testing a release kernel,
> but something slightly different.

This should not be a problem. The goal is to test the klp-build toolchain.

> (Tangent: kpatch-build implemented a unit test scheme that cached object
> files for even greater speed and fixed testing.  I haven't thought about
> how a similar idea might work for klp-build.)

I think it is a good idea to have similar .o file tests for klp-diff
in klp-build.

>
> 6- Two patch models:
>
> a) static .patch files
> b) scripted .patch generation
>
> Why?  Sometimes a test like cmdline-string.patch is sufficient and
> stable.  Other times it's not.  For example, the recount-many-file test
> in this branch is implemented via a script.  This allows the test to be
> dynamic and potentially avoid the rebasing problem mentioned above.

I think we can have both a) and b).

> 7- Build verification including ELF analysis.  Not very mature in this
> branch, but it would be nice to be able to build on it:

If we test the behavior after loading the patches, ELF analysis might
be optional. But we can also do both.

[...]

>
> 8- Probably more I've already forgotten about :) Cross-compilation may
> be interesting for build testing in the future.  For the full AI created
> commentary, there's https://github.com/joe-lawrence/linux/blob/klp-build-=
selftests/README.md

Yes, cross-compilation can be really useful.

> > > I was using kpatch for testing. I can replace it with insmod.
> >
>
> Do the helpers in functions.sh for safely loading and unloading
> livepatches (that wait for the transition, etc.) aid here?

Yes, we can reuse those.
[...]

> To continue the bike shedding, in my branch, I had dumped this all under
> a new tools/testing/klp-build subdirectory as my focus was to put
> klp-build through the paces.  It does load the generated livepatches in
> the runtime testing, but as only as a sanity check.  With that, it
> didn't touch CONFIG or intermix testing with the livepatch/ set.
>
> If we do end up supplementing the livepatch/ with klp-build tests, then
> I agree that naming them (either filename prefix or subdirectory) would
> be nice.
>
> But first, is it goal for klp-build to be the build tool (rather than
> simple module kbuild) for the livepatching .ko selftests?

I think we don't have to use klp-build for livepatch selftests. Existing
tests work well as-is.

Thanks,
Song

