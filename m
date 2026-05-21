Return-Path: <live-patching+bounces-2873-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iBy4KpBKD2qRIwYAu9opvQ
	(envelope-from <live-patching+bounces-2873-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 20:10:24 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D7A5AAD8F
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 20:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5362B30FF14A
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 18:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6293437C90D;
	Thu, 21 May 2026 18:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PE6S/s9s"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A743630AD
	for <live-patching@vger.kernel.org>; Thu, 21 May 2026 18:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779386534; cv=none; b=XBARXK1ZmJaWINw4MZrB+RpHXTclHCRb0pHRVIQVKq26gfgr5yaU9DWZnn79K0HXMdu8sQp0RXjkY6xOvyw998xLxShZNrC6ernXOT4Ed3vK6kJEa0wkiqvYuhL2SrI1DmlGEJ2mUOMZKFYHAEMkP7xYBFUWIuB/aRmS4eiuptE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779386534; c=relaxed/simple;
	bh=uLPZQ9vUr/4uTv8PfAlMmoLOrphUtX99fCwYRINzO4I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kgNU3I7sR2USow7U7IescUVmjTpvdt5h/qVpE+hUhdEBKcCwMzqQoELuSGGBG/SUR6Lto2EKR9uBp9xRYV4onXfAV9rGg2HlNQJGIvh2q5zJnDZ+KbOvQpOoIo8lMxa1uGpuGHhV+DEYXh8XIeltQNk3NrTG1RU3BGKItsD3R78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PE6S/s9s; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81B11F000E9
	for <live-patching@vger.kernel.org>; Thu, 21 May 2026 18:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779386532;
	bh=uLPZQ9vUr/4uTv8PfAlMmoLOrphUtX99fCwYRINzO4I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PE6S/s9sd0mSPmBeb70+EozqZRA4T1mvNxnlUCE5EebvYUJojOEw7Fpw9ddGli/kl
	 awZHd2fHG/VeDlDf/6c7YW5LTGZfSjRtUa/96H4h1QorCjWWCRDmuwhsO1mUrQpkqE
	 YhqF8erFyZAU5gPRY6tn/qIILJHW4cC3sUUkX/Evagk+7vt7C8asqSU17rxiCNRFRI
	 9eegBoWp5PsqHl/aHBNKNS3duNbZzmpBCTjDPYvo83QCFZtWTKTMGepo5XutvGtGl0
	 LZJhqtuh180NVXBtsVKMyceRCdTbwerJaigc8CMHx15XS39ufuiolqMoUO3jqUVAcT
	 ei/qrJbdoqNvw==
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-36a3aff302aso1205927a91.1
        for <live-patching@vger.kernel.org>; Thu, 21 May 2026 11:02:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9sK7kOwz9pSagijJpmJMTRYPIp18gTj0pROepZMsabv0GkLWnHYCthvIhu7BCDBwWA0lJYaR7QIk0z+hHf@vger.kernel.org
X-Gm-Message-State: AOJu0YxrWcLWn7rNmpju1n03QTFCJV9AmIMU2UtB2YGVGuQZdbqe8kCm
	R4x5K2+KWFZD8g62R6Kzmrhd6ZTuNSgx7JGYK8JEJWt6OVKbY1PFf/5xZz+kvfwykvQvg3v1giR
	PjUcTVCUiEMbNL/7kCzvCmjEi+1iXjG0=
X-Received: by 2002:a17:90b:5845:b0:368:d8a1:3bd4 with SMTP id
 98e67ed59e1d1-36a6741da05mr328033a91.3.1779386532181; Thu, 21 May 2026
 11:02:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260508195749.1885522-1-sashal@kernel.org> <20260517134858.146569-1-sashal@kernel.org>
 <CAPhsuW4x8shWon8Moi5VgCq2n4E2EzaaauZ2HHpy42Rp1Y-J-g@mail.gmail.com>
 <agsVDqdALBoHEHlv@laps> <CAPhsuW44UX663Au=WwHz8MVwnQgLkjxOqpJSCKxNiv3=RpZvqw@mail.gmail.com>
 <b342c38b-7323-4b72-a239-8a574d6bc36b@iogearbox.net> <agzAwjKhOhuANz_P@laps>
 <CAPhsuW6C3hyciA4=z+V0BkQ9EEubuNCKLwoxtXorSbnhkUxdJQ@mail.gmail.com> <ag8Y8L2WCcSEDPkG@laps>
In-Reply-To: <ag8Y8L2WCcSEDPkG@laps>
From: Song Liu <song@kernel.org>
Date: Thu, 21 May 2026 11:02:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5tUQ3J6hgdqXWiLEGV5zpJm+nuqy_dXovRvFkUHEyg=g@mail.gmail.com>
X-Gm-Features: AVHnY4JBfdUFRyhiKfJw5pxU2Y29FHkTxkEQ7Mu2Iqr9cDc-c-vLuUobNPxFRro
Message-ID: <CAPhsuW5tUQ3J6hgdqXWiLEGV5zpJm+nuqy_dXovRvFkUHEyg=g@mail.gmail.com>
Subject: Re: [PATCH v3] killswitch: add per-function short-circuit mitigation primitive
To: Sasha Levin <sashal@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	bpf@vger.kernel.org, live-patching@vger.kernel.org, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Joshua Peisach <jpeisach@ubuntu.com>, Florian Weimer <fw@deneb.enyo.de>, Breno Leitao <leitao@debian.org>, 
	Anthony Iliopoulos <ailiop@suse.com>, Michal Hocko <mhocko@suse.com>, Jiri Olsa <jolsa@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2873-lists,live-patching=lfdr.de];
	FREEMAIL_CC(0.00)[iogearbox.net,vger.kernel.org,linuxfoundation.org,linux-foundation.org,lwn.net,efficios.com,ubuntu.com,deneb.enyo.de,debian.org,suse.com,kernel.org,gmail.com];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[song@kernel.org,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 27D7A5AAD8F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, May 21, 2026 at 7:38=E2=80=AFAM Sasha Levin <sashal@kernel.org> wro=
te:
>
> On Tue, May 19, 2026 at 03:00:15PM -0700, Song Liu wrote:
> >On Tue, May 19, 2026 at 12:57=E2=80=AFPM Sasha Levin <sashal@kernel.org>=
 wrote:
> >[...]
> >> >Fully agree with Song here that there is no clear boundary, and that =
the
> >> >killswitch could lead to arbitrary, hard to debug breakage if applied=
 to
> >> >the wrong function.. introducing worse bugs than the one being mitiga=
ted
> >> >or even /short-circuit LSM enforcement/ (engage security_file_open 0,
> >> >engage cap_capable 0, engage apparmor_* etc).
> >>
> >> This is similar to livepatch, right? Do we need guardrails there too?
> >
> >livepatch has the same guardrails as other kernel modules:
> >CONFIG_MODULE_SIG, CONFIG_MODULE_SIG_FORCE, etc.
>
> Which the user can choose to enable or disable. Livepatches will work jus=
t fine
> with CONFIG_MODULE_SIG=3Dn, right?
>
> With the whitelist approach, the user has no choice but to accept it.
>
> Would it make sense to allow disabling the whitelist via a kernel config =
or
> some runtime flag?

I personally think it makes sense to have options to allow bypassing/blocki=
ng
more kernel functions than the current allow list. But I don't know whether
we would like to go all the way to allow it for all the ftrace-able functio=
ns.
I think we will need some careful analysis on this.

Thanks,
Song

