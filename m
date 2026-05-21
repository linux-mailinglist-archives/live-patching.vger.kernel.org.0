Return-Path: <live-patching+bounces-2871-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6HVXGG8vD2r+HQYAu9opvQ
	(envelope-from <live-patching+bounces-2871-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 18:14:39 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C99485A9069
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 18:14:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7BCFC34621A8
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 14:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EA4F3EC2EB;
	Thu, 21 May 2026 14:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XsBlQTOC"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D52C3E9C16;
	Thu, 21 May 2026 14:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779374323; cv=none; b=ZYGJl7wkYRyU/fEvkOBEF6oAi21Qe4zdvq+FP7d+P1P1ndyM+ofGsDT+kS7U6kudEyo7P/5uT09EtaXFdehjy6rJPVJU1gBA9WoEi2ydfB06q7+025YgFQ986IZDEUclI1t8v6g23nWu7G8+94KZGcT0OMXSwT4MI0l7jedYV8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779374323; c=relaxed/simple;
	bh=XK48jeRB+QfYua9qvT6nkgqWoyk74EnZmHziGEhJckQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CZfb8BFFnQWOx+LsXHPZCYEUgQv1GPCMFU29vnJIV6n2ZViu3SEwJIoWiD2BkYG/pPcHKoi50zEvGLa2f5aw8XElXgLijJoAyYlPRIED/TAIx+0mP+diX9PD7Labmi+rLRXvytYw6xiY1jXVyHnUZXLNi+BmarduS2Tq6Yexh6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XsBlQTOC; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3991F00A3B;
	Thu, 21 May 2026 14:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374322;
	bh=nTzgC5HjU2axc7qp/6EBnj55/XJGfG1tYASFCI0U7g0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XsBlQTOCK2YksJm2MNjyE7j0ny1HPTgDymFmsxNKKxr1BVdAvgPOBuNn6tFA7vGjg
	 CSQXiV3VGsBWuWOwPes8pP8JUZc2AK1A75GOlY3qX2oC5FjQ7qoHn31pb8iXNfDSFm
	 iXK2YnCBCaUWupOdSh0ZVPN+0hcaS9CE+UFVcZubluvtHYPOHE110zqo5nJZBbiaNl
	 07zGPmwKluAZrGdXdG5ILZLoarbkdL9yDRoeg2O+Yo3PYLyE8/2+NE9g1lJxASkcRS
	 B6VRE8y+mpZLmBsjrXBLlPLTbSWjyT2Yslzd/guaonNwFYtLf41VMjJQhPrDfeUtxL
	 sB6G0e3DI2Biw==
Date: Thu, 21 May 2026 10:38:40 -0400
From: Sasha Levin <sashal@kernel.org>
To: Song Liu <song@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	bpf@vger.kernel.org, live-patching@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joshua Peisach <jpeisach@ubuntu.com>,
	Florian Weimer <fw@deneb.enyo.de>, Breno Leitao <leitao@debian.org>,
	Anthony Iliopoulos <ailiop@suse.com>,
	Michal Hocko <mhocko@suse.com>, Jiri Olsa <jolsa@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v3] killswitch: add per-function short-circuit mitigation
 primitive
Message-ID: <ag8Y8L2WCcSEDPkG@laps>
References: <20260508195749.1885522-1-sashal@kernel.org>
 <20260517134858.146569-1-sashal@kernel.org>
 <CAPhsuW4x8shWon8Moi5VgCq2n4E2EzaaauZ2HHpy42Rp1Y-J-g@mail.gmail.com>
 <agsVDqdALBoHEHlv@laps>
 <CAPhsuW44UX663Au=WwHz8MVwnQgLkjxOqpJSCKxNiv3=RpZvqw@mail.gmail.com>
 <b342c38b-7323-4b72-a239-8a574d6bc36b@iogearbox.net>
 <agzAwjKhOhuANz_P@laps>
 <CAPhsuW6C3hyciA4=z+V0BkQ9EEubuNCKLwoxtXorSbnhkUxdJQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW6C3hyciA4=z+V0BkQ9EEubuNCKLwoxtXorSbnhkUxdJQ@mail.gmail.com>
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2871-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[iogearbox.net,vger.kernel.org,linuxfoundation.org,linux-foundation.org,lwn.net,efficios.com,ubuntu.com,deneb.enyo.de,debian.org,suse.com,kernel.org,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: C99485A9069
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, May 19, 2026 at 03:00:15PM -0700, Song Liu wrote:
>On Tue, May 19, 2026 at 12:57 PM Sasha Levin <sashal@kernel.org> wrote:
>[...]
>> >Fully agree with Song here that there is no clear boundary, and that the
>> >killswitch could lead to arbitrary, hard to debug breakage if applied to
>> >the wrong function.. introducing worse bugs than the one being mitigated
>> >or even /short-circuit LSM enforcement/ (engage security_file_open 0,
>> >engage cap_capable 0, engage apparmor_* etc).
>>
>> This is similar to livepatch, right? Do we need guardrails there too?
>
>livepatch has the same guardrails as other kernel modules:
>CONFIG_MODULE_SIG, CONFIG_MODULE_SIG_FORCE, etc.

Which the user can choose to enable or disable. Livepatches will work just fine
with CONFIG_MODULE_SIG=n, right?

With the whitelist approach, the user has no choice but to accept it.

Would it make sense to allow disabling the whitelist via a kernel config or
some runtime flag?

-- 
Thanks,
Sasha

