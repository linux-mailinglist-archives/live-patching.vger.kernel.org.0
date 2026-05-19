Return-Path: <live-patching+bounces-2867-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uIEJF8jADGqJlgUAu9opvQ
	(envelope-from <live-patching+bounces-2867-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 21:58:00 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F1751584608
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 21:57:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6AE3B3050035
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 19:57:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 585803B6367;
	Tue, 19 May 2026 19:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MIDo0oZ3"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D25F3B3899;
	Tue, 19 May 2026 19:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779220677; cv=none; b=oAcCSquhmUbCPaLZLwy4Z+LqH6r1cQ6m4sscjBfhUgSHXk302ouNTdTb/vWpb+a5JA4bAbYCj2ThAyBTKUHlgPE/sNPk9UNoEUDUMtT+xByXDAvgq/HRvkQQ1QXW55znCKDbDWpLX76SHkWAR1ebqXFpg3w/A0AexT7V/2io+SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779220677; c=relaxed/simple;
	bh=HJa7LTlB7rUz0py6A8HhHWbQBqnXH+vvLhZdOPi4+UQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i4z4Ia8bDL+PoD1v+qrba1qK0J9d0nyMY5/RI6lR6Hw3Iut8Em5ZKRoKv3ie5TIhDFwOgFESNCw8WVgtOTMzyzdRdzrXEOX66vEG5JzHZYFmikpj75KDkXMOnPVyCiaTo8y5Z7ySUATm05Zs2cFa6QsTIZLJEXRikDUdpjiJi9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MIDo0oZ3; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876D81F000E9;
	Tue, 19 May 2026 19:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779220675;
	bh=1Tamg3Hf9ko+bZLZl3xbxvWbVEJhbX7dm5Vi5ngVEyA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MIDo0oZ3rO3gBAI4EqRlMprpx3hMXyMnW5nC6bKsdblVLHZLT0gDBnRbUR29fDMms
	 Xy0TroVpr9Flole9DLbqOqt/DaAr+T5+OPs34A5cJoRdDF7clifWYpig0oyIuUWV3J
	 FM9P3Yb3Dogn8KGhOgTMme6FNcK94KrGPV5uUMK0Dd7OxnJn/aAQ0QfneK89iXeV2L
	 8UYlcPERZbtTrGXhki01jG+pbEo0VXAWIcLIzoeMiPJhXhUEpgeW3Q6jT6hLV+ZLNG
	 p5hiShgr65NLt6tw2u5kG4gMIxML2YLhh8/TBSMpi6pXD7SSyTRLqk7k1FJfVgpiuS
	 D5YClChAyz4hw==
Date: Tue, 19 May 2026 15:57:54 -0400
From: Sasha Levin <sashal@kernel.org>
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org,
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
Message-ID: <agzAwjKhOhuANz_P@laps>
References: <20260508195749.1885522-1-sashal@kernel.org>
 <20260517134858.146569-1-sashal@kernel.org>
 <CAPhsuW4x8shWon8Moi5VgCq2n4E2EzaaauZ2HHpy42Rp1Y-J-g@mail.gmail.com>
 <agsVDqdALBoHEHlv@laps>
 <CAPhsuW44UX663Au=WwHz8MVwnQgLkjxOqpJSCKxNiv3=RpZvqw@mail.gmail.com>
 <b342c38b-7323-4b72-a239-8a574d6bc36b@iogearbox.net>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b342c38b-7323-4b72-a239-8a574d6bc36b@iogearbox.net>
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2867-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,linuxfoundation.org,linux-foundation.org,lwn.net,efficios.com,ubuntu.com,deneb.enyo.de,debian.org,suse.com,gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: F1751584608
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Tue, May 19, 2026 at 02:13:26PM +0200, Daniel Borkmann wrote:
>On 5/19/26 1:59 AM, Song Liu wrote:
>>On Mon, May 18, 2026 at 6:33 AM Sasha Levin <sashal@kernel.org> wrote:
>>>On Sun, May 17, 2026 at 11:37:36PM -0700, Song Liu wrote:
>>>>On Sun, May 17, 2026 at 6:49 AM Sasha Levin <sashal@kernel.org> wrote:
>>>>>* fail_function (CONFIG_FUNCTION_ERROR_INJECTION) is disabled in
>>>>>   most production kernels. Even where enabled, it only works on
>>>>>   functions pre-annotated with ALLOW_ERROR_INJECTION() in source -
>>>>>   no help for a freshly-disclosed CVE. The debugfs UI is blocked by
>>>>>   lockdown=integrity and the override is probabilistic.
>>>>>
>>>>>* BPF override (bpf_override_return) honors the same
>>>>>   ALLOW_ERROR_INJECTION() whitelist, and BPF itself is off in many
>>>>>   production kernels. Even where on, the operator interface is
>>>>>   "load a verified BPF program," not a one-line write.
>>>>
>>>>If it is OK for killswitch to attach to any kernel functions, do we still
>>>>need ALLOW_ERROR_INJECTION() for fail_function and BPF
>>>>override? Shall we instead also allow fail_function and BPF override
>>>>to attach to any kernel functions?
>>>
>>>I don't think so. ALLOW_ERROR_INJECTION is not a security mechanism, it's an
>>>integrity/safety mechanism for both bpf and fault injection.
>>>
>>>It protects against a "developer or CI script doing legitimate fault injection
>>>accidentally panics the box" scenario, not an "attacker gets in" one.
>>
>>There really isn't a clear boundary between "security mechanism" and
>>"non-security mechanism". As we are making killswitch available
>>everywhere under root, users will soon learn to use it to do fault injection,
>>and potentially much more scary things. (Think about agents with sudo
>>access).
>
>Fully agree with Song here that there is no clear boundary, and that the
>killswitch could lead to arbitrary, hard to debug breakage if applied to
>the wrong function.. introducing worse bugs than the one being mitigated
>or even /short-circuit LSM enforcement/ (engage security_file_open 0,
>engage cap_capable 0, engage apparmor_* etc).

This is similar to livepatch, right? Do we need guardrails there too?

Or do we just trust root to do the right thing for it's systems without needing
to be it's babysitter?

>The ALLOW_ERROR_INJECTION() provides a curated white-list where you may
>return with an error without causing more severe damage (assuming the
>error handling code is right). The right thing would be to more widely
>apply ALLOW_ERROR_INJECTION() or to figure out a better way to safely
>enable the latter without explicit function annotation.

Sure, this would also work. How do you see this happening? Can we let a certain
user/pid/etc disable the allowlist if they choose to?

>Wrt BPF:
>
>>>>>* BPF override (bpf_override_return) honors the same
>>>>>   ALLOW_ERROR_INJECTION() whitelist, and BPF itself is off in many
>>>>>   production kernels. Even where on, the operator interface is
>>>>>   "load a verified BPF program," not a one-line write.
>
>The claim that BPF itself is off in many production kernels is not really
>true, where did you get that from? All the major distros and cloud providers
>have BPF enabled these days, and even systemd ships BPF programs for
>custom service firewalling etc.

The world is a bit bigger than home distros and cloud providers, but sure - bpf
is enabled widely enough at this point.

How do you see this working with the allowlist?

-- 
Thanks,
Sasha

