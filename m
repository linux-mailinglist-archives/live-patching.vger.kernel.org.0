Return-Path: <live-patching+bounces-2868-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UMrWLPHeDGqXpQUAu9opvQ
	(envelope-from <live-patching+bounces-2868-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Wed, 20 May 2026 00:06:41 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E7B58571B
	for <lists+live-patching@lfdr.de>; Wed, 20 May 2026 00:06:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 47AB1306D850
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 22:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 994A23EBF16;
	Tue, 19 May 2026 22:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CWBZl/4G"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615ED3DB65A
	for <live-patching@vger.kernel.org>; Tue, 19 May 2026 22:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779228028; cv=none; b=DbNyxd7//uHsQnv2SUrL1QvIr03OeqNnCuTVP9ZsCwe4uzkONy2PKH5ZunGhuRtMEeRIG69E2YJF/SbsPb/z+OG1ytC5byRrXKWpFlRDERJJ1cw4oOVyjCWpa29S10N6zn1zqMLVReI/HGh8nAQPciYsLKSz3ximdDZWFR6BnGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779228028; c=relaxed/simple;
	bh=nqq25hT59kTZbGDbhXmx5RWuokj4m9KZmFmkHTSOiP8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jxIJcl8xXwrocUuCPwJ25vJJD8dyd+gr5tjwr/XKjeKP20I/bhtCpkwg7/v0zQciQs/GfPEwo0XVIbtTZqJGjwzFhS9D2vFwJEp1OOW4CmVI34LpzVWA6ZqHf7jxei2FGHuPVdH74WLYuDKxTEQLqt3/zdndHpHM3QTCrUvDQbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CWBZl/4G; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4221F1F008A0
	for <live-patching@vger.kernel.org>; Tue, 19 May 2026 22:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779228027;
	bh=nqq25hT59kTZbGDbhXmx5RWuokj4m9KZmFmkHTSOiP8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CWBZl/4GeRTqxV8lz1GPFUx8bgiRwtjS3lmXPBrHWkvZh4BHEG05uRQqNzTuU1RcX
	 HnwGdyQj/igIxdmZoTzYQoL3WGCYxO3AM4Y+PUVCBWDILytA8f2PSjLNWe7z6k+ZxQ
	 AJficOSZm/HbaNqkUzf5yS37Q1u8yJynhm1Ht9CuSydQl8WpBGm+ZQ0thgsShuZ3Gn
	 H+orpgtSvJW1ZnK3KdPqdGCIlm6Qk/h14NviCAwAVFjNaLfmKsnCW2P7L9ZeOJ1zJE
	 G7ky1HEljO6Z/KalzRhHAUMaFRNZeL98tdxpU/BtbD1HkYB/OszPku3TI7/fx559er
	 nRWZBrWeZTUOw==
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8c9166b26b4so51590166d6.0
        for <live-patching@vger.kernel.org>; Tue, 19 May 2026 15:00:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/mYLjvTbhnojNRsUqOQHRfTZv0fVnxb9fYoZ4SYEDcIuJuwwCX14H9E0M8MjRe4WxdBDJhxeH7wJT06aEd@vger.kernel.org
X-Gm-Message-State: AOJu0YznIVZvdUKKEOKU7P4dvo4suPC5H+v/vQbx1xfhzS2Hav4ynmdT
	fPJckvqHoZwN9jVAh4sQkT/0O5y1mO8VyDiqrNKlkP16+Y2BrwritTFj52HTLM1YlcdCMV6lGnP
	zG2nn9dXA3uv+DPsKfbm6V7GWqYMOh00=
X-Received: by 2002:a0c:e087:0:b0:8bc:81:c1db with SMTP id 6a1803df08f44-8ca0fc199e5mr348944026d6.43.1779228026482;
 Tue, 19 May 2026 15:00:26 -0700 (PDT)
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
In-Reply-To: <agzAwjKhOhuANz_P@laps>
From: Song Liu <song@kernel.org>
Date: Tue, 19 May 2026 15:00:15 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6C3hyciA4=z+V0BkQ9EEubuNCKLwoxtXorSbnhkUxdJQ@mail.gmail.com>
X-Gm-Features: AVHnY4KuHU9JfA0SbOuETBkWPKarT8gfjVbJ5MqqV3LlRdCPHn1pxUt-jUhFqng
Message-ID: <CAPhsuW6C3hyciA4=z+V0BkQ9EEubuNCKLwoxtXorSbnhkUxdJQ@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2868-lists,live-patching=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 31E7B58571B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, May 19, 2026 at 12:57=E2=80=AFPM Sasha Levin <sashal@kernel.org> wr=
ote:
[...]
> >Fully agree with Song here that there is no clear boundary, and that the
> >killswitch could lead to arbitrary, hard to debug breakage if applied to
> >the wrong function.. introducing worse bugs than the one being mitigated
> >or even /short-circuit LSM enforcement/ (engage security_file_open 0,
> >engage cap_capable 0, engage apparmor_* etc).
>
> This is similar to livepatch, right? Do we need guardrails there too?

livepatch has the same guardrails as other kernel modules:
CONFIG_MODULE_SIG, CONFIG_MODULE_SIG_FORCE, etc.

Thanks,
Song

