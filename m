Return-Path: <live-patching+bounces-2311-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AKOxGQJy1GlquAcAu9opvQ
	(envelope-from <live-patching+bounces-2311-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 04:54:58 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D044F3A9410
	for <lists+live-patching@lfdr.de>; Tue, 07 Apr 2026 04:54:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7F21630182BC
	for <lists+live-patching@lfdr.de>; Tue,  7 Apr 2026 02:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C141372B26;
	Tue,  7 Apr 2026 02:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDxghOLA"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB5A28AB0B
	for <live-patching@vger.kernel.org>; Tue,  7 Apr 2026 02:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775530495; cv=none; b=UWWUug6o1zKgdFCmXkEDci3/4q5kO4AW3A1zgKqWTu0CfWiD4heGAmFbx+lNwUnCRlGGp6eaW55lrgB4sruXNto1DhT3oN5fRFhZh2lQTUE/arIRka+BYCeqEhjqHxGn9hBYShc59HtPclqbEgGCSY9xswwdinBwwiXWnI42yfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775530495; c=relaxed/simple;
	bh=i+ZDL4etGqbDD1SSvvEUCRe1RYGtEJ5vfifTRH6bLD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ehev+Jg9pydOZohDQfuh99R8i0FdZUcUtsHmCUx3p+7g4w9Wf5gZK5ZBoM2LKfsLnBwsoTy7bMIqhpCZkwvaoGMdRJS35kR/HSBfsTOaN5DVHlsbRXvum5C41AJ2WlPlTVjPUeXs+8vjh/X0Z24F1VNBx+jOkKE5kR4dTn/aQlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDxghOLA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87148C2BCAF
	for <live-patching@vger.kernel.org>; Tue,  7 Apr 2026 02:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775530494;
	bh=i+ZDL4etGqbDD1SSvvEUCRe1RYGtEJ5vfifTRH6bLD0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fDxghOLAxGTBRNETJTsItcNe23P2YftmNnIesNF+5Idflc9YaKGBatMJK6dfu7slw
	 tDjgMrSM5gp9Rkw0IGSARfwwH/XMoVxM0AknCLIIhwC0MT20FHsOUVQkddX76A+Q4x
	 V4C5jXrR2YVcwomTqUclO99AmdOieB0ahMnWw78RcALNH4/eFrN+AN26LdUTgLur1n
	 S481puPkxYg9tNyZqNUgM0NGibn/0wQ3BK9+SME13F1Ck56hRxmFoh/OsOmvKC4MYw
	 Ra3NSLq1FUU8IChwDbn352IBs6y/6zWQ+L5naJ1eCDNUZOHjyTlvrGJzF9cUI5cNNi
	 IydPgnwRv2F8g==
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8a1e1817db6so46305606d6.2
        for <live-patching@vger.kernel.org>; Mon, 06 Apr 2026 19:54:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWScfglIIAHcEoL+dsa8sH1C1UWjVFiCHsiHVxwJvBsxbLCFZ86igBzDMjPPkPH1Naht2a9vmZP2mr4xA5T@vger.kernel.org
X-Gm-Message-State: AOJu0YxumeVMLqC5fe+khftlrKtTM5sKzgr4u+i7IRNtTme6HwytDvOB
	nJAVq+3+tTr6ghzjEO5TtLKMH4L14EwL0CBOnm9ZmPr5LNFSwOW3xChWQeqVnupuPra5noig5HG
	DHkR+3hWBFhSetJ2lk2q3j/dOUUkL2Bc=
X-Received: by 2002:a05:6214:400a:b0:89a:f92:b09f with SMTP id
 6a1803df08f44-8a7022bb7a7mr254701016d6.4.1775530493763; Mon, 06 Apr 2026
 19:54:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260402092607.96430-1-laoar.shao@gmail.com> <20260402092607.96430-4-laoar.shao@gmail.com>
 <CAPhsuW51Hh7XfN6xXm_uMAoDXBBQoNQ5ynqom+wVNdqCt81f2A@mail.gmail.com>
 <CADBMgpy3e25EH5xbKMN5GeOK47jE6uzviknbt35V49_Y7zFj8A@mail.gmail.com>
 <CAPhsuW6p3YOv3_M_c0ThMcrNqNjT=7i46ekJBrWO_oGzQkxrxA@mail.gmail.com>
 <CALOAHbCbcw2jpjk9JD9yyf+SMpQ-s9FAonSaz7Gs4XUeP+w+2g@mail.gmail.com>
 <CAPhsuW4B00-grg9XJa+AO3xgGwM_u8FC+GH3JrkYZOJx4PuV8Q@mail.gmail.com> <adQhpBC2W9I6QW-g@redhat.com>
In-Reply-To: <adQhpBC2W9I6QW-g@redhat.com>
From: Song Liu <song@kernel.org>
Date: Mon, 6 Apr 2026 19:54:42 -0700
X-Gmail-Original-Message-ID: <CAPhsuW66tuF+QZ0pVheWb5sC4NQ-9CXikq=zMrPBXTHcsVPjdg@mail.gmail.com>
X-Gm-Features: AQROBzDqKNxQZBPxlDnbd5hKmrEsse7pr_E-tifmGgg4QCs2CTfpUdHYMDgmc5A
Message-ID: <CAPhsuW66tuF+QZ0pVheWb5sC4NQ-9CXikq=zMrPBXTHcsVPjdg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] livepatch: Add "replaceable" attribute to klp_patch
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, Dylan Hatch <dylanbhatch@google.com>, jpoimboe@kernel.org, 
	jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, kpsingh@kernel.org, 
	mattbobrowski@google.com, jolsa@kernel.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	eddyz87@gmail.com, memxor@gmail.com, yonghong.song@linux.dev, 
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2311-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,google.com,kernel.org,suse.cz,suse.com,goodmis.org,efficios.com,iogearbox.net,linux.dev,vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: D044F3A9410
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Apr 6, 2026 at 2:12=E2=80=AFPM Joe Lawrence <joe.lawrence@redhat.co=
m> wrote:
[...]
> > > > - The regular livepatches are cumulative, have the replace flag; an=
d
> > > >   are replaceable.
> > > > - The occasional "off-band" livepatches do not have the replace fla=
g,
> > > >   and are not replaceable.
> > > >
> > > > With this setup, for systems with off-band livepatches loaded, we c=
an
> > > > still release a cumulative livepatch to replace the previous cumula=
tive
> > > > livepatch. Is this the expected use case?
> > >
> > > That matches our expected use case.
> >
> > If we really want to serve use cases like this, I think we can introduc=
e
> > some replace tag concept: Each livepatch will have a tag, u32 number.
> > Newly loaded livepatch will only replace existing livepatch with the
> > same tag. We can even reuse the existing "bool replace" in klp_patch,
> > and make it u32: replace=3D0 means no replace; replace > 0 are the
> > replace tag.
> >
> > For current users of cumulative patches, all the livepatch will have th=
e
> > same tag, say 1. For your use case, you can assign each user a
> > unique tag. Then all these users can do atomic upgrades of their
> > own livepatches.
> >
> > We may also need to check whether two livepatches of different tags
> > touch the same kernel function. When that happens, the later
> > livepatch should fail to load.
> >
> > Does this make sense?
> >
>
> I haven't been following the thread carefully, but could the Livepatch
> system state API (see Documentation/livepatch/system-state.rst) be
> leveraged somehow instead of adding further replace semantics?

AFAICT, system state will not help Yafang's use case.

Thanks,
Song

