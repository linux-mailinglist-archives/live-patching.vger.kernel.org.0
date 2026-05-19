Return-Path: <live-patching+bounces-2866-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WARxFBZWDGqUfgUAu9opvQ
	(envelope-from <live-patching+bounces-2866-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 14:22:46 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C99E457E96E
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 14:22:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6F86B30F4FEF
	for <lists+live-patching@lfdr.de>; Tue, 19 May 2026 12:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D2504C9574;
	Tue, 19 May 2026 12:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iogearbox.net header.i=@iogearbox.net header.b="hQ5wDWvP"
X-Original-To: live-patching@vger.kernel.org
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D411A492502;
	Tue, 19 May 2026 12:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.133.104.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779192835; cv=none; b=EyDjcW1Xq9b6ql+uqp4gAgP7D3t5KEtXvvdcPdlVJJHCBk5e0J+R3RG/MF5zHG7ckY2U3Fdz08BpW3qErMu1k7BtzFZYzm2fXfnjT8qtN21ECdNzV41+NAQUgIfcv6u+lxKTEreVQ2peJ9mMz49UboI7zgWXZ6EAhUAOCfon8Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779192835; c=relaxed/simple;
	bh=qGkWukyg7BRJ3BYm19QN2I31E/gz6jl12f4LD2DpBVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UOVCJv6QGfRPc/Kbroie6SkXcyr1cUv/Ssuq7pkSCVoMiUGCKRqjhaC3+xhhiZ5OPsemYAKc8Je4L1yRfBv91oi62AyqxnF3laa0J3sRxl/8udt2w5aU77qVQTUHLuQlYbb9JVh8Gv2+kZ1QuM4jjttvmBCW9fMVbjQMqCYmCzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iogearbox.net; spf=pass smtp.mailfrom=iogearbox.net; dkim=pass (2048-bit key) header.d=iogearbox.net header.i=@iogearbox.net header.b=hQ5wDWvP; arc=none smtp.client-ip=213.133.104.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iogearbox.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iogearbox.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=lQBojDY84EYZekKZoulFlCOXOf8H914FBQk+2ZSsF6M=; b=hQ5wDWvPkargrg/9FISN9vF9o0
	/ylJJiY7sUlG2YI4i2GCxTghR1XNzejpmh9PcOm98xRpzCGj//eI3HFVSWWbvYxfSWKEMW3g+dgRf
	whaeMaFjn4cLGcGgSwW2KSCeunu8/f3xDZaQRpxY0K1vkU+Hp5zJ5ye0/cuaySKntHGW6WGu0HisE
	+PLes7xgZlsGFJ8zhRNYHimhWOL+XY5paB/dZg7PA40Xhcv5Im98ikFt7dcl6jYnLIHzQMzLIr8Rz
	GCcs43CrZbNNrzNEHY+NX46jtI9EpG3yfdjUlySgCShr2CVxWQenhRy04k5k2K+3ydMwQ0lQiieto
	oBpIkAoQ==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1wPJKC-0008pA-0P;
	Tue, 19 May 2026 14:13:28 +0200
Received: from localhost ([127.0.0.1])
	by sslproxy06.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <daniel@iogearbox.net>)
	id 1wPJKB-0008ua-0C;
	Tue, 19 May 2026 14:13:27 +0200
Message-ID: <b342c38b-7323-4b72-a239-8a574d6bc36b@iogearbox.net>
Date: Tue, 19 May 2026 14:13:26 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] killswitch: add per-function short-circuit mitigation
 primitive
To: Song Liu <song@kernel.org>, Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
 live-patching@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Joshua Peisach <jpeisach@ubuntu.com>, Florian Weimer <fw@deneb.enyo.de>,
 Breno Leitao <leitao@debian.org>, Anthony Iliopoulos <ailiop@suse.com>,
 Michal Hocko <mhocko@suse.com>, Jiri Olsa <jolsa@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Christian Brauner <brauner@kernel.org>
References: <20260508195749.1885522-1-sashal@kernel.org>
 <20260517134858.146569-1-sashal@kernel.org>
 <CAPhsuW4x8shWon8Moi5VgCq2n4E2EzaaauZ2HHpy42Rp1Y-J-g@mail.gmail.com>
 <agsVDqdALBoHEHlv@laps>
 <CAPhsuW44UX663Au=WwHz8MVwnQgLkjxOqpJSCKxNiv3=RpZvqw@mail.gmail.com>
Content-Language: en-US
From: Daniel Borkmann <daniel@iogearbox.net>
Autocrypt: addr=daniel@iogearbox.net; keydata=
 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
In-Reply-To: <CAPhsuW44UX663Au=WwHz8MVwnQgLkjxOqpJSCKxNiv3=RpZvqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: Clear (ClamAV 1.4.3/28005/Tue May 19 08:25:42 2026)
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[iogearbox.net,reject];
	R_DKIM_ALLOW(-0.20)[iogearbox.net:s=default2302];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2866-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,linuxfoundation.org,linux-foundation.org,lwn.net,efficios.com,ubuntu.com,deneb.enyo.de,debian.org,suse.com,kernel.org,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[19];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[daniel@iogearbox.net,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[iogearbox.net:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[iogearbox.net:mid,iogearbox.net:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: C99E457E96E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/19/26 1:59 AM, Song Liu wrote:
> On Mon, May 18, 2026 at 6:33 AM Sasha Levin <sashal@kernel.org> wrote:
>> On Sun, May 17, 2026 at 11:37:36PM -0700, Song Liu wrote:
>>> On Sun, May 17, 2026 at 6:49 AM Sasha Levin <sashal@kernel.org> wrote:
>>>> * fail_function (CONFIG_FUNCTION_ERROR_INJECTION) is disabled in
>>>>    most production kernels. Even where enabled, it only works on
>>>>    functions pre-annotated with ALLOW_ERROR_INJECTION() in source -
>>>>    no help for a freshly-disclosed CVE. The debugfs UI is blocked by
>>>>    lockdown=integrity and the override is probabilistic.
>>>>
>>>> * BPF override (bpf_override_return) honors the same
>>>>    ALLOW_ERROR_INJECTION() whitelist, and BPF itself is off in many
>>>>    production kernels. Even where on, the operator interface is
>>>>    "load a verified BPF program," not a one-line write.
>>>
>>> If it is OK for killswitch to attach to any kernel functions, do we still
>>> need ALLOW_ERROR_INJECTION() for fail_function and BPF
>>> override? Shall we instead also allow fail_function and BPF override
>>> to attach to any kernel functions?
>>
>> I don't think so. ALLOW_ERROR_INJECTION is not a security mechanism, it's an
>> integrity/safety mechanism for both bpf and fault injection.
>>
>> It protects against a "developer or CI script doing legitimate fault injection
>> accidentally panics the box" scenario, not an "attacker gets in" one.
> 
> There really isn't a clear boundary between "security mechanism" and
> "non-security mechanism". As we are making killswitch available
> everywhere under root, users will soon learn to use it to do fault injection,
> and potentially much more scary things. (Think about agents with sudo
> access).

Fully agree with Song here that there is no clear boundary, and that the
killswitch could lead to arbitrary, hard to debug breakage if applied to
the wrong function.. introducing worse bugs than the one being mitigated
or even /short-circuit LSM enforcement/ (engage security_file_open 0,
engage cap_capable 0, engage apparmor_* etc).

The ALLOW_ERROR_INJECTION() provides a curated white-list where you may
return with an error without causing more severe damage (assuming the
error handling code is right). The right thing would be to more widely
apply ALLOW_ERROR_INJECTION() or to figure out a better way to safely
enable the latter without explicit function annotation.

Wrt BPF:

>>>> * BPF override (bpf_override_return) honors the same
>>>>    ALLOW_ERROR_INJECTION() whitelist, and BPF itself is off in many
>>>>    production kernels. Even where on, the operator interface is
>>>>    "load a verified BPF program," not a one-line write.

The claim that BPF itself is off in many production kernels is not really
true, where did you get that from? All the major distros and cloud providers
have BPF enabled these days, and even systemd ships BPF programs for
custom service firewalling etc.

The operator interface is to load a program vs. one-line write.. so we're
disregarding existing infra where you can already achieve the same for a
less safe one-liner convenience? (similarly for the livepatch infra..)

If you need a one-liner: bpftrace -e 'kprobe:FUNC { override(RETVAL); }'
Alternatively, add an extension to systemd where you can just deploy a
list of functions, and it does the necessary work in the background and
persistently.

Also, what about other classes of bugs, like OOB access, UAFs, locking
issues, etc which then could be used as a means for privilege escalations?
It feels like this proposal is a quick'n'dirty prototype via Claude as a
reaction to copy fail bug, but the right solution would be to improve
the user space tooling as mentioned and existing infra we have in kernel.

