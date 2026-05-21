Return-Path: <live-patching+bounces-2869-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UMhnB4zPDmrOCQYAu9opvQ
	(envelope-from <live-patching+bounces-2869-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 11:25:32 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7715E5A249E
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 11:25:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7EA9231026F6
	for <lists+live-patching@lfdr.de>; Thu, 21 May 2026 09:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B3636A372;
	Thu, 21 May 2026 09:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iogearbox.net header.i=@iogearbox.net header.b="I4pMikeW"
X-Original-To: live-patching@vger.kernel.org
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A343612E2;
	Thu, 21 May 2026 09:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.133.104.62
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779354694; cv=none; b=DSXRkhqq+YYbW46Po0moc1fr3QCL+eDMeRmgTls1XG1DkdZWf6Z0+JtYAIikWZvSs8W02rkPjyQUTJnBg6YbkJzl71u1Atc7/JIbU3Pyvf0vpO9TlipyMdmhnIc436p6HNkWSdVEJcOqKOMcXSMclm6MNBN648ianW4qjGEUDbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779354694; c=relaxed/simple;
	bh=DBwND3nC8pz0T3fsybwJrQC384OVYfQ6K/eRwSh5mBU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nwcqOhZu5hXRGp7pbONywjk/NXvzksBVHGunvLjtsns8nle5ea6JYxNSol4Qk0HiC42gjc/CUTGbGH8Mz7/RH7mR8nOsbp+0yxSnmpDw+5qpnvn9KDqRif+qL2GiqYpa+uPHAR3VfRfQWHRdBh4LrVgz9qVCJ5LaxwI7o12IM4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iogearbox.net; spf=pass smtp.mailfrom=iogearbox.net; dkim=pass (2048-bit key) header.d=iogearbox.net header.i=@iogearbox.net header.b=I4pMikeW; arc=none smtp.client-ip=213.133.104.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=iogearbox.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iogearbox.net
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
	bh=dthM8mr9RgQqfO6aWBILeV9J7yPzF1+F0J3noxcs9Bk=; b=I4pMikeWDF7idIwdHni/jm4iK9
	c0Ai7OI1n5qCZhjXwGl0D5nC0G1O29ENcLZ+l++o33Z91/up1ZuCaXhoCbCaxAlULDrHZhCLAN9iY
	kcWr6JWdsLaAbqSGLXsfA9HxoQHKUAKl4w/nfE9VZ/gwvthYlekRIu9lFXZa2o41T8scZ5TvWYPPk
	8wzX6wj/nsxAKfg9MfxQqxHf8wl+TzvNKOowRKEso0s/gCrFYRX715o9T7RHKVLacwQI8qBsVidjk
	ZivfRTJg5ySCrAe75GVvIh/nmvtZlnZGKwOhaUj1VQ/xQLg7cw8ucg8oQyXNNTp09CaVi7vjgWxjR
	TeuxVEWw==;
Received: from sslproxy08.your-server.de ([78.47.166.52])
	by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <daniel@iogearbox.net>)
	id 1wPzQz-000EyG-2D;
	Thu, 21 May 2026 11:11:18 +0200
Received: from localhost ([127.0.0.1])
	by sslproxy08.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <daniel@iogearbox.net>)
	id 1wPzQy-000Pmk-0t;
	Thu, 21 May 2026 11:11:17 +0200
Message-ID: <3dd6d852-18fb-4c64-a1ae-0d79ef7c061f@iogearbox.net>
Date: Thu, 21 May 2026 11:11:16 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] killswitch: add per-function short-circuit mitigation
 primitive
To: Sasha Levin <sashal@kernel.org>
Cc: Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 bpf@vger.kernel.org, live-patching@vger.kernel.org,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Joshua Peisach <jpeisach@ubuntu.com>, Florian Weimer <fw@deneb.enyo.de>,
 Breno Leitao <leitao@debian.org>, Anthony Iliopoulos <ailiop@suse.com>,
 Michal Hocko <mhocko@suse.com>, Jiri Olsa <jolsa@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Christian Brauner <brauner@kernel.org>, KP Singh <kpsingh@kernel.org>
References: <20260508195749.1885522-1-sashal@kernel.org>
 <20260517134858.146569-1-sashal@kernel.org>
 <CAPhsuW4x8shWon8Moi5VgCq2n4E2EzaaauZ2HHpy42Rp1Y-J-g@mail.gmail.com>
 <agsVDqdALBoHEHlv@laps>
 <CAPhsuW44UX663Au=WwHz8MVwnQgLkjxOqpJSCKxNiv3=RpZvqw@mail.gmail.com>
 <b342c38b-7323-4b72-a239-8a574d6bc36b@iogearbox.net> <agzAwjKhOhuANz_P@laps>
Content-Language: en-US
From: Daniel Borkmann <daniel@iogearbox.net>
Autocrypt: addr=daniel@iogearbox.net; keydata=
 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
In-Reply-To: <agzAwjKhOhuANz_P@laps>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: Clear (ClamAV 1.4.3/28007/Thu May 21 08:26:28 2026)
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[iogearbox.net,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[iogearbox.net:s=default2302];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.org,vger.kernel.org,linuxfoundation.org,linux-foundation.org,lwn.net,efficios.com,ubuntu.com,deneb.enyo.de,debian.org,suse.com,gmail.com];
	TAGGED_FROM(0.00)[bounces-2869-lists,live-patching=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[iogearbox.net:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[20];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[daniel@iogearbox.net,live-patching@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 7715E5A249E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 5/19/26 9:57 PM, Sasha Levin wrote:
> On Tue, May 19, 2026 at 02:13:26PM +0200, Daniel Borkmann wrote:
>> On 5/19/26 1:59 AM, Song Liu wrote:
>>> On Mon, May 18, 2026 at 6:33 AM Sasha Levin <sashal@kernel.org> wrote:
>>>> On Sun, May 17, 2026 at 11:37:36PM -0700, Song Liu wrote:
>>>>> On Sun, May 17, 2026 at 6:49 AM Sasha Levin <sashal@kernel.org> wrote:
>>>>>> * fail_function (CONFIG_FUNCTION_ERROR_INJECTION) is disabled in
>>>>>>   most production kernels. Even where enabled, it only works on
>>>>>>   functions pre-annotated with ALLOW_ERROR_INJECTION() in source -
>>>>>>   no help for a freshly-disclosed CVE. The debugfs UI is blocked by
>>>>>>   lockdown=integrity and the override is probabilistic.
>>>>>>
>>>>>> * BPF override (bpf_override_return) honors the same
>>>>>>   ALLOW_ERROR_INJECTION() whitelist, and BPF itself is off in many
>>>>>>   production kernels. Even where on, the operator interface is
>>>>>>   "load a verified BPF program," not a one-line write.
>>>>>
>>>>> If it is OK for killswitch to attach to any kernel functions, do we still
>>>>> need ALLOW_ERROR_INJECTION() for fail_function and BPF
>>>>> override? Shall we instead also allow fail_function and BPF override
>>>>> to attach to any kernel functions?
>>>>
>>>> I don't think so. ALLOW_ERROR_INJECTION is not a security mechanism, it's an
>>>> integrity/safety mechanism for both bpf and fault injection.
>>>>
>>>> It protects against a "developer or CI script doing legitimate fault injection
>>>> accidentally panics the box" scenario, not an "attacker gets in" one.
>>>
>>> There really isn't a clear boundary between "security mechanism" and
>>> "non-security mechanism". As we are making killswitch available
>>> everywhere under root, users will soon learn to use it to do fault injection,
>>> and potentially much more scary things. (Think about agents with sudo
>>> access).
>>
>> Fully agree with Song here that there is no clear boundary, and that the
>> killswitch could lead to arbitrary, hard to debug breakage if applied to
>> the wrong function.. introducing worse bugs than the one being mitigated
>> or even /short-circuit LSM enforcement/ (engage security_file_open 0,
>> engage cap_capable 0, engage apparmor_* etc).
> 
> This is similar to livepatch, right? Do we need guardrails there too?
> 
> Or do we just trust root to do the right thing for it's systems without needing
> to be it's babysitter?

[See Song's reply.]

>> The ALLOW_ERROR_INJECTION() provides a curated white-list where you may
>> return with an error without causing more severe damage (assuming the
>> error handling code is right). The right thing would be to more widely
>> apply ALLOW_ERROR_INJECTION() or to figure out a better way to safely
>> enable the latter without explicit function annotation.
> 
> Sure, this would also work. How do you see this happening? Can we let a certain
> user/pid/etc disable the allowlist if they choose to?

I don't think we should, given then we're back to square one where root
or some other user would be able to just override/bypass an LSM.

[...]
> How do you see this working with the allowlist?

We should look at the underlying areas where most of the CVE-like fixes
took place (these days should be more easily doable given Claude and friends)
and based on that either extend ALLOW_ERROR_INJECTION() or (better) create
new hooks which BPF LSM can consume where you can then have a policy to reject
requests and tighten the attack surface. For example, the AF_ALG stuff you
can already easily cover today ...

#include "vmlinux.h"
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_tracing.h>

#define AF_ALG	38
#define EPERM	1

char _license[] SEC("license") = "Dual BSD/GPL";

SEC("lsm/socket_create")
int BPF_PROG(block_af_alg, int family, int type, int protocol, int kern)
{
	if (family == AF_ALG)
		return -EPERM;
	return 0;
}

... the problem is that distros enable and pull in all sort of crap which
then non-root could pull in via request_module() as an example; similarly
for netlink we want to have a BPF LSM policy to parse into netlink requests
and then reject based on certain attribute matching (both on our todo list)
which would have helped in case of exotic tc cls/act/qdisc modules to prevent
them to be pulled from userns. I bet there are a ton more examples once we
look further into the data.

Thanks,
Daniel

