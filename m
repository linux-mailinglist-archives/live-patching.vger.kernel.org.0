Return-Path: <live-patching+bounces-2040-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aBCEHLrAlGkXHgIAu9opvQ
	(envelope-from <live-patching+bounces-2040-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 20:25:46 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E388614F9DF
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 20:25:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9F03530420B6
	for <lists+live-patching@lfdr.de>; Tue, 17 Feb 2026 19:25:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B53CD37755C;
	Tue, 17 Feb 2026 19:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S4AJV9O5"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C8937474B
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 19:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771356327; cv=none; b=MgAtDw8S4cBaWFmZaE1NVzhnQh8A/r8+apDoKLfqeZx2mMAUJQNS8w3sssh65PNB+RLXLe1Znenv6aW2bazNmBCUyzjr5j5rw2OPjd5n4A2WWCDk4UfrS8VssrN8UY0ehWQbBgiUhRe/BG+vcix3er4lng2coD7K0lnm6qzTXBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771356327; c=relaxed/simple;
	bh=JfmqxG8GUqZhxJJXh5PLNUA1AGbiIOXu2TGEZi/jedo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZwmWTZslJCFxyA1LXDNWTmSL52dScYdsdqax5us3xw2dPdXaZJGLhg5nvUS1kGEBwQj6bm9EX81NCKGLepV3h3PI2PFSCQPeToRZPGaEAUd89kIMliB5qAS+hcopoxwWCS3shgPA9a4Ke81qAywBpGA5gpdZADuzzGVj4/9UnkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S4AJV9O5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A7FC4AF09
	for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 19:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771356327;
	bh=JfmqxG8GUqZhxJJXh5PLNUA1AGbiIOXu2TGEZi/jedo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=S4AJV9O596f41Hl/UdSvUAOJMW1XrwnLshK4sJH47kWMpmhOnq09NawLmPaC1Zvx3
	 VMeDioRnkPNH7d1FQ2Cj881xj9nZf2cUYFgFmLmvYgFKSa0FdJ1DY7526U4KCjxucn
	 wNgN6pkmJRxkCwMTMYv1zHRtHQAvFben0FYeKr/DOoivy8fjpEya1Oz/Yg+6OUL2hw
	 NRRcbppHqlrCmFa/tWqfXn/pLy8zSNPM3493CxW/8JIHx+YWxuCCXtu5bYNrQbn+n8
	 t8AOkBvjCrNj1uDjLduIVdTGu5naHLvcNUS72zH52+ads388bTry9usI4bcQXUgd8i
	 pg7CJQXpEO47A==
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5069df1d711so38884261cf.2
        for <live-patching@vger.kernel.org>; Tue, 17 Feb 2026 11:25:27 -0800 (PST)
X-Gm-Message-State: AOJu0Yz/uTL087XGutnG20vrm23BsjdPmyqEawV43UWuBHnQS2+wFeYg
	/09DpyR3shfZCGRGdS8Y41xzdC7fkcHJb8CfODiNlNUV9XuYLncvR/rQilaPEDojhYITFKFlx5v
	Os94+LpPqcdOJswoPatTiYjGp/kzbW90=
X-Received: by 2002:a05:622a:1455:b0:4eb:a6c9:e839 with SMTP id
 d75a77b69052e-506a8318edfmr211465141cf.47.1771356326385; Tue, 17 Feb 2026
 11:25:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260217160645.3434685-1-joe.lawrence@redhat.com>
 <20260217160645.3434685-10-joe.lawrence@redhat.com> <aZSUfFUfpUYIbuiA@redhat.com>
In-Reply-To: <aZSUfFUfpUYIbuiA@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 17 Feb 2026 11:25:13 -0800
X-Gmail-Original-Message-ID: <CAPhsuW55E-T0gg4zFitjVB81+y5wHPEQ0665MDPnznV9=9Y1+g@mail.gmail.com>
X-Gm-Features: AaiRm504Xcw1YMkNdZXGb3jTqP7lHBj5KJTEXMLA9cyfRM7p03tHrYa9ZcBotbQ
Message-ID: <CAPhsuW55E-T0gg4zFitjVB81+y5wHPEQ0665MDPnznV9=9Y1+g@mail.gmail.com>
Subject: Re: [PATCH v3 09/13] livepatch/klp-build: fix version mismatch when short-circuiting
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
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
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2040-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E388614F9DF
X-Rspamd-Action: no action

On Tue, Feb 17, 2026 at 8:17=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.c=
om> wrote:
>
[...]
> > 2.53.0
> >
> >
>
> Maybe I'm starting to see things, but when running 'S 2' builds, I keep
> getting "vmlinux.o: changed function: override_release".  It could be
> considered benign for quick development work, or confusing.  Seems easy
> enough to stash and avoid.

"-S 2" with a different set of patches is only needed in patch development,
but not used for official releases. Therefore, I agree this is not a real i=
ssue.

Thanks,
Song

