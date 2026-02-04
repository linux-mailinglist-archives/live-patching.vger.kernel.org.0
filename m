Return-Path: <live-patching+bounces-1984-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cIjiLnrpgmmPewMAu9opvQ
	(envelope-from <live-patching+bounces-1984-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 07:38:50 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F77E25D8
	for <lists+live-patching@lfdr.de>; Wed, 04 Feb 2026 07:38:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 20763302B39D
	for <lists+live-patching@lfdr.de>; Wed,  4 Feb 2026 06:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D0B737FF7C;
	Wed,  4 Feb 2026 06:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Egmwokuj"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3B537FF76
	for <live-patching@vger.kernel.org>; Wed,  4 Feb 2026 06:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770187107; cv=none; b=dbv0k0lc9JXEk+tBdOvpH3M3/4N4sN/fAdm9KHBnCrXBRQPK4yzM1HHgAAT2GW3fqXjtUph8P8UlFVIE01lQrQRb6OP6ONjDmoRgPF993obpq5F8GSqnttOmZ8oY0CTXMXyte8CJsYoDCsCOOFgpdlKinnGQYxrni0Zi0Xf32Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770187107; c=relaxed/simple;
	bh=yIwKvXqR/gSAfil/AXu+JrGVScFZsK6ESEsSoIlnn8k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tG7SxNwuT4vCiaFzKE9gEZlj0GovW0FmMPOnFORuKZvZQss3oHl5XUwKb+ZWN/0eRomsrEp6oEaTmaKfWTIb/E69wpVhpzglGg0obMPecFkZWFnlY+4vaL8jurYO7bR42rblHs67DpAsgR36JGJFymJhETjdDR7RMzxxMIPF3Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Egmwokuj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC60C2BC9E
	for <live-patching@vger.kernel.org>; Wed,  4 Feb 2026 06:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770187107;
	bh=yIwKvXqR/gSAfil/AXu+JrGVScFZsK6ESEsSoIlnn8k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=EgmwokujqlXn5vNaV0prSR6hKPr8sU7uFRTnqIF8rUejFmrkRZnVKaZ7XE9IUjlDD
	 SYGwrGTRjglUaXO442RY5uWHqLoIRYtkdSkCUDA6JlBgBr1oAFLyVqqdub6wpkR4dM
	 L2NeMAVFDG4bgVPVIqKXRCqAz0pWBqSi6b8SYh/pKaXo86SYTu3kS0gAkCEJ17AOxE
	 Fmz5kWWHPYJX0iosKa8bHpZqekBHyEMtjDuIfVYk3EjOH1NouwDiXbegDetXtr9kai
	 TnSvcT+YJiQ3xNP9h9tP7sfxVFUnfcd74h38AFd1Ai5R6TYipFIz+rqyKZgA2PSwA4
	 qjvbkGMhNOCUQ==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-894638da330so66150056d6.1
        for <live-patching@vger.kernel.org>; Tue, 03 Feb 2026 22:38:27 -0800 (PST)
X-Gm-Message-State: AOJu0YxF8niXuZkS7l4YzhSvV5FSPmWIjJ543EjZ9ivyoCr19BHpv2bJ
	OIDDFNsWwUb/+pawd4cbewzJiGxRxMyhzugxvoUrAJWoybiKSZhvzgS+If8ARH69iIg4altIufh
	QgV+mwy2W7fQpXiiXBNor7gHThxmX5zQ=
X-Received: by 2002:ad4:5c8c:0:b0:890:6603:f258 with SMTP id
 6a1803df08f44-895220fd0e6mr28679186d6.12.1770187106181; Tue, 03 Feb 2026
 22:38:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260203214006.741364-1-song@kernel.org> <3rufoy2rjvt4apzwplyn6g6cafrz5hxh2b2ug3cmljndctauo5@bskwjecforne>
 <CAPhsuW7tSyGVBBMOV2bc7gvRXCUbeEETUM7qcZ4HU+Z3D=8SEQ@mail.gmail.com> <ojtyhae2qexuvdogiwvja24g7dh7jhe6epl44wupicgigq7qkf@e4t7mvkycex3>
In-Reply-To: <ojtyhae2qexuvdogiwvja24g7dh7jhe6epl44wupicgigq7qkf@e4t7mvkycex3>
From: Song Liu <song@kernel.org>
Date: Tue, 3 Feb 2026 22:38:14 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6DZomMXFEhS5VOdTCaf7T=-HzMiysZuT_XB9WN-GEhWg@mail.gmail.com>
X-Gm-Features: AZwV_Qh_uuWCFKRKxtSObgHfh8mv9z4oDqrumr8JVXg2MDeTkHpuqhSlKrhWcEE
Message-ID: <CAPhsuW6DZomMXFEhS5VOdTCaf7T=-HzMiysZuT_XB9WN-GEhWg@mail.gmail.com>
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
	TAGGED_FROM(0.00)[bounces-1984-lists,live-patching=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 24F77E25D8
X-Rspamd-Action: no action

On Tue, Feb 3, 2026 at 5:24=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.org>=
 wrote:
>
> On Tue, Feb 03, 2026 at 04:24:06PM -0800, Song Liu wrote:
> > On Tue, Feb 3, 2026 at 3:53=E2=80=AFPM Josh Poimboeuf <jpoimboe@kernel.=
org> wrote:
> > >
> > > On Tue, Feb 03, 2026 at 01:40:06PM -0800, Song Liu wrote:
> > > > With CONFIG_LTO_CLANG_THIN, __UNIQUE_ID_* can be global. Therefore,=
 it
> > > > is necessary to demangle global symbols.
> > >
> > > Ouch, so LTO is changing symbol bindings :-/
> > >
> > > If a patch causes a symbol to change from LOCAL to GLOBAL between the
> > > original and patched builds, that will break some fundamental
> > > assumptions in the correlation logic.
> >
> > This can indeed happen. A function can be "LOCAL DEFAULT" XXXX
> > in original, and "GLOBAL HIDDEN" XXXX.llvm.<hash> in patched.
> >
> > I am trying to fix this with incremental steps.
> >
> > > Also, notice sym->demangled_name isn't used for correlating global
> > > symbols in correlate_symbols().  That code currently assumes all glob=
al
> > > symbols are uniquely named (and don't change between orig and patched=
).
> > > So this first fix seems incomplete.
> >
> > We still need to fix correlate_symbols(). I am not 100% sure how to do
> > that part yet.
> >
> > OTOH, this part still helps. This is because checksum_update_insn()
> > uses demangled_name. After the fix, if a function is renamed from
> > XXXX to XXXX.llvm.<hash> after the patch, functions that call the
> > function are not considered changed.
>
> Hm, wouldn't that still leave the .llvm at the end?

E.. Right. I described a different case.

The actual case being fixed here is when foo.llvm.<hash_1> got
changed to foo.llvm.<hash_2>.

Let me think more about all the cases and have a better solution.

Thanks,
Song

