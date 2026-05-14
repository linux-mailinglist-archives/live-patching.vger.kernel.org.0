Return-Path: <live-patching+bounces-2813-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SJ1EK1nuBWpWdgIAu9opvQ
	(envelope-from <live-patching+bounces-2813-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 17:46:33 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 105AC5443B1
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 17:46:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BA7163030125
	for <lists+live-patching@lfdr.de>; Thu, 14 May 2026 15:45:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52048223DEA;
	Thu, 14 May 2026 15:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LoYGPWf0"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECA21D45E8
	for <live-patching@vger.kernel.org>; Thu, 14 May 2026 15:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778773558; cv=none; b=utp7VFASZp1Q/p5XkJDdLTViC7ltbnI+pjwBDTEV+voX2xN67vZ9khq8/ZJCJdzkJyCLkCcRCtp+EeMyv5L0ailiWtbYe1LII7P+FSSRWbLlalsJAL8SMjq7eLlO71V4aItU69MUBqLcejGLZzd1uIileisR1D98wLyvE4u2Wtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778773558; c=relaxed/simple;
	bh=PK7zALDZPSI7rphSqQ4B81Q4rNgfj6uN21QhZTUGxJE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZDhzHYQrA7lm31HY1mAwA3ti0O/p9s6jGNr9Z6e4fOwWF4qzURKS2t/RG8tHC9n2BPN77nr6AxtVqepF4DPpEYpy1zhPsLKLMXz6dc5LGVPY4ZczgaRnHoeDcJZkeav36srMPkVE2EGYGzKJ/UY7rqldDQm2irRZmoHdRXK2tOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LoYGPWf0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDC6C2BCF5
	for <live-patching@vger.kernel.org>; Thu, 14 May 2026 15:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778773557;
	bh=PK7zALDZPSI7rphSqQ4B81Q4rNgfj6uN21QhZTUGxJE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LoYGPWf0RDPr2EdfQULHUb/E79osUcQd7+a2Ssz5KZmndEq3h27XUft2GaxjlYRwk
	 91dENnVYodMt2/S/iYVIh3qQBL5qKRQ9m1zhQCarOFRXrSYtute+Ly00xEHixyan5k
	 egrfj3OEm7miNLFxMzdQW0OFPsRvoGVj+VBKXdxtFhB8CvnwlqWzrQYTEaoqQEqwts
	 bWVSgvTvmQa0/qUn+iFyU0X7+DL8VR//GymAipC97ti8/AK3cLfkv2S++sLzo8jaOy
	 diDhsPq5I7oULs1251rJkXpS6koc8aEjy6tmWXCMOfyVpERdMiaT3hy9INRNyx3j6f
	 dpNlOBTQcYd3g==
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-56a8fdaddebso3055185e0c.0
        for <live-patching@vger.kernel.org>; Thu, 14 May 2026 08:45:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/Lx0k73rYYXHObpnHIdFWLVYiPvQ8Imt/MeivUe7VRkpOoYXDgxU7e4WsCq8dlZSF+AYeiwy8FdX4amqWS@vger.kernel.org
X-Gm-Message-State: AOJu0YxiNsBD3PelNYqrQyKn7NOzLldmMIMM3qD/7lSnMyihGB8cQI2+
	kh3Qso3A4NTkfTPfzjEXMoACEvMsAxojGdQ7P4PLIqSD3kqNC6UUVwMWszAlfeMm4luX0h/INW5
	W4bSAZi3Bk3puQiom5b6UE0XZ7GCLYnc=
X-Received: by 2002:a05:6122:6589:b0:56d:9e98:4676 with SMTP id
 71dfb90a1353d-575e708a7a8mr4797644e0c.13.1778773556490; Thu, 14 May 2026
 08:45:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <agSjM8dxgnV9QQaf@redhat.com> <CAPhsuW6CgBtEGAK+E0n7+tnLAWNPTEuvnAo0vtQsbMVBb6htFw@mail.gmail.com>
 <ju3k5mp22u37l4m27xygqce2sh2nczwckvmk3exkldk5365csx@q53zbumzj33t> <agV33GZsjwQjZNGb@pathway.suse.cz>
In-Reply-To: <agV33GZsjwQjZNGb@pathway.suse.cz>
From: Song Liu <song@kernel.org>
Date: Thu, 14 May 2026 08:45:44 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6Op81pTM7AMJKD6K-=ukkS9VGAmngNKpfQ1o0mBTi=nw@mail.gmail.com>
X-Gm-Features: AVHnY4IKwgtjLq8o81YhkAg2h3LMl9mN2vmv9pt33Zg85zz0mQVM6H0ji7MIg8U
Message-ID: <CAPhsuW6Op81pTM7AMJKD6K-=ukkS9VGAmngNKpfQ1o0mBTi=nw@mail.gmail.com>
Subject: Re: Sashiko patch review for live-patching?
To: Petr Mladek <pmladek@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>, 
	live-patching@vger.kernel.org, Jiri Kosina <jikos@kernel.org>, 
	Miroslav Benes <mbenes@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 105AC5443B1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	SUBJECT_ENDS_QUESTION(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2813-lists,live-patching=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sashiko.dev:url,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email]
X-Rspamd-Action: no action

On Thu, May 14, 2026 at 12:21=E2=80=AFAM Petr Mladek <pmladek@suse.com> wro=
te:
>
> On Wed 2026-05-13 12:47:13, Josh Poimboeuf wrote:
> > On Wed, May 13, 2026 at 10:17:51AM -0700, Song Liu wrote:
> > > Hi Joe,
> > >
> > > On Wed, May 13, 2026 at 9:13=E2=80=AFAM Joe Lawrence <joe.lawrence@re=
dhat.com> wrote:
> > > >
> > > > Hello live-patching maintainers,
> > > >
> > > > I've noticed several references to the Sashiko (https://sashiko.dev=
/)
> > > > kernel review bot on this list and was wondering if there is intere=
st in
> > > > adding live-patching to the mailing lists Sashiko tracks.
> > >
> > > I think it is a great idea. AFAICT, these bots add a lot of values in=
 the
> > > code reviews.
> >
> > +1
> >
> > > > Integration appears straightforward: we can submit an MR to add our
> > > > entry to sashiko-k8s.yaml and customize the bot's email behavior in
> > > > email_policy.toml.
> > > >
> > > > Full Sashiko Maintainer documentation is available here:
> > > > https://github.com/sashiko-dev/sashiko/blob/main/MAINTAINERS_GUIDE.=
md
> > > >
> > > > Personally, I would vote to set reply_to_author.  I don't have a st=
rong
> > > > opinion on the other custom options, provided that the CC list is o=
pt-in
> > > > rather than simply mirrored from the MAINTAINERS::LIVE PATCHING fil=
e.
> > > > Either way, I've found the Sashiko web interface very helpful in pa=
tch
> > > > review.
> > >
> > > Given the relatively low volume of patches to the livepatch mail list=
, I
> > > think we can use reply_all. But if folks prefer reply_to_author inste=
ad,
> > > we sure can use the cc list.
> >
> > I would vote reply_all.  The signal/noise ratio isn't perfect, but it's
> > high enough to be useful in many cases.  That way the
> > maintainers/reviewers are aware of any potential issues, and it avoids
> > duplicating review work and fragmenting conversations.
>
> I agree. And it might even motivate us to update the subsystem
> specific review prompts so that the review gets improved over time.

+1 for livepatch specific prompts. We sure have some unique constraints
due to the nature of livepatch.

Thanks,
Song

