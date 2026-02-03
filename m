Return-Path: <live-patching+bounces-1969-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gMA7OAg4gmmVQgMAu9opvQ
	(envelope-from <live-patching+bounces-1969-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 03 Feb 2026 19:01:44 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 04318DD3D5
	for <lists+live-patching@lfdr.de>; Tue, 03 Feb 2026 19:01:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B283D3011115
	for <lists+live-patching@lfdr.de>; Tue,  3 Feb 2026 17:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA6C7335551;
	Tue,  3 Feb 2026 17:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qBHoQipX"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974AA30DD1C
	for <live-patching@vger.kernel.org>; Tue,  3 Feb 2026 17:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770141196; cv=none; b=Q3jmgMU5cV2EST1pOQefgpWAmmMgpqxQT+PMHQCWWvwy5SXjajRQcHp5tDqfUw/5jRqO2hRsnPY24ulCm13E4IEiex+vw6QILYTtX+wzKxVx7NNM7d8HttN+wy5pugqbsqMlMjZZPl0RAbADRKFTpy+VveQuZVValbqwziuFQck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770141196; c=relaxed/simple;
	bh=3j7ew4TPOUmuYfJNoqjfSR7uJHhNIOgIUdSenp8eVq4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PKKn7IJjN37ESmBPB+VveMxa1GeR6I9U9FSTpuGMPUG7yGdTBbV1XDr0JnRTK7n12aqRMKDHxfdS2SQ5Mk0viVdPR7hmDTrl1yLN0ebw6FkjEJQRxrMdlGLvUvaUxrTGnBqqVf6zJyouKQfaNuGupptYyH2tHlVWfcvOmZ9TIRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qBHoQipX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35ACFC4AF0B
	for <live-patching@vger.kernel.org>; Tue,  3 Feb 2026 17:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770141196;
	bh=3j7ew4TPOUmuYfJNoqjfSR7uJHhNIOgIUdSenp8eVq4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qBHoQipXRpsihWD7R86JZM0fZ/d60pHic43ZKUfoV06lRB7cIGx3Tc8hYaLZxHROM
	 7QtiVKEdkoHqbWaXnwvCN+NXkSZqF2RKP+qlTwBft2xweRV/KRUmWGGbf51PSt/4qY
	 WR0t0Zj0sHhxqL9K/OLtA5OUtRqRaIBJa+fmR+nrnH5RMIAnyqZyCd9W7LytXzzP4j
	 J9X0peb1eqRC1H9arcYlICs+dBEGdNnoAhSvOcWr36Mm8FcQFTdtKWYFyjCdmJ6hsp
	 kS4L8u76OihOpOY4OLe4bZLz+uJqqOfhDl0ktDpSd+HSzfsp/NpbcHpowfa9l5YXq3
	 D5ioEdwIuOiCQ==
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-88a26ce6619so77935866d6.3
        for <live-patching@vger.kernel.org>; Tue, 03 Feb 2026 09:53:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWJMJD892AwvaKHYwZNlwwJSy7M6U1keTw7viMGo/Tc29vJykaTQufdssfVe2GnjbACNuPuKLpSk3pHhPt/@vger.kernel.org
X-Gm-Message-State: AOJu0YwX9i+TplkzYUxrGI/igewaLT8jhUqiBg0nXmEoJp3pEC1gkPER
	s4ACGXuT85ev9pB+iQLFqDk+cCjgakBktYfti+RvRXMlxgOpKPEwy7stTiTK/5TK/B1vsSeV8Kc
	hXMxEsFUJbkVyFYdv2E2/2jqSGkW2G90=
X-Received: by 2002:ac8:7f45:0:b0:4e8:b9fd:59f0 with SMTP id
 d75a77b69052e-5061c1c5aaamr1323421cf.61.1770141195362; Tue, 03 Feb 2026
 09:53:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260130175950.1056961-1-joe.lawrence@redhat.com>
 <20260130175950.1056961-4-joe.lawrence@redhat.com> <lqchka76tcwjxitn5tm42keexglnac6iveb44ppgx4c425qsfg@sbcdkfgmebqu>
 <aX0W0JWRkLbuQpGY@redhat.com> <omt3bm5upud3sywupr3g3evxqs437x5f5wcxlnba2j5u4rtle2@b62zb4hfydby>
 <72pzjkj4vnp2vp4ekbj3wnjr62yuywk67tavzn27zetmkg2tjh@nkpihey5cc3g> <604a8b96-47f2-4986-b602-c7bdf3de7cca@redhat.com>
In-Reply-To: <604a8b96-47f2-4986-b602-c7bdf3de7cca@redhat.com>
From: Song Liu <song@kernel.org>
Date: Tue, 3 Feb 2026 09:53:04 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4oQfWTPd7jQKhd8Ff-9gWW9GMKyA9HpUCxF2F0KXecEA@mail.gmail.com>
X-Gm-Features: AZwV_QigX3w6dRDdnQiKqg4R9f3PxA0gUFP-C18fuB7y87dwis-QARNhk3CpGXI
Message-ID: <CAPhsuW4oQfWTPd7jQKhd8Ff-9gWW9GMKyA9HpUCxF2F0KXecEA@mail.gmail.com>
Subject: Re: [PATCH 3/5] objtool/klp: validate patches with git apply --recount
To: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, live-patching@vger.kernel.org, 
	Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1969-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[live-patching];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 04318DD3D5
X-Rspamd-Action: no action

On Tue, Feb 3, 2026 at 8:45=E2=80=AFAM Joe Lawrence <joe.lawrence@redhat.co=
m> wrote:
[...]
> > Or at least validate_patches() could be replaced with
> > check_unsupported_patches(), as the apply/revert test wouldn't be neede=
d
> > since the actual apply/revert would happen immediately after that in
> > fix_patches().
> >
>
> Currently fix_patches runs in short-circuit step (2) after building the
> original kernel.  But what if the user runs:
>
>  $ klp-build -T 0001.patch
>  $ klp-build -S 2 0002.patch

On one hand, I think this is a user mistake that we need the users
to avoid by themselves. If the user do

   $ klp-build -T 0001.patch
   $ klp-build -S 3 0002.patch

Even when 0001.patch and 0002.patch are totally valid, the end
result will be very confusing (it is the result of 0001.patch, not 0002).

> If we move fix_patches() to step (1) to fail fast and eliminate a
> redundant apply/revert, aren't we then going to miss it if the user
> jumps to step (2)?
>
> Is there a way to check without actually doing it if we're going to
> build the original kernel first?
>
> And while we're here, doesn't this mean that we're currently not running
> validate_patches() when skipping to step (2)?

On the other hand, I guess we can always run fix_patches. If any
-S is given, we compare the fixed new patches against fixed saved
patches. If they are not identical, we fail fast.

Thanks,
Song

