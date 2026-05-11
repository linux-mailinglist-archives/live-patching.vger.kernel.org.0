Return-Path: <live-patching+bounces-2739-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mJF7MsIcAmocoAEAu9opvQ
	(envelope-from <live-patching+bounces-2739-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Mon, 11 May 2026 20:15:30 +0200
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E9C985142F1
	for <lists+live-patching@lfdr.de>; Mon, 11 May 2026 20:15:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4EE7D3025A38
	for <lists+live-patching@lfdr.de>; Mon, 11 May 2026 18:09:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B13E247887B;
	Mon, 11 May 2026 18:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eNFK8H38"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D18247884E;
	Mon, 11 May 2026 18:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778522987; cv=none; b=jU7Lmx3zaXcToBLBnIYFnuabYgXX9ADzLg63z9op1IN+pOcMpPnovynihMeMYGR2oGxv5/SWITyOQjnxaN5wsRwuoiqxFESqOjsO+gahqo1/FPn4OfuvtvIARHgyzBR4Jmr70BXe5Uwsp1Xz4dWp6bGHBi8DCUQvAu9nrzE6hCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778522987; c=relaxed/simple;
	bh=n6e+PmZVSR5bhRNfnAYiSruj3Fg+dvFavJ2iy712Q+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f7tCNH+FlM5R48ua8wiH7nhKNq8DJIGuryHZCuXpqI++TroXlmJMDCQTr2Wgl1fT82zx0M9f+KRWQoqyj4PGwCgwT7DXlZ4bYi36mlnMCOK3auKFUCHjFB4c4AvN+I9mEBFAKTTMwEpChlJ5Xb1Loh23xYkID3iLe2PH0MbGxT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eNFK8H38; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0626FC2BCF5;
	Mon, 11 May 2026 18:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778522987;
	bh=n6e+PmZVSR5bhRNfnAYiSruj3Fg+dvFavJ2iy712Q+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eNFK8H38aFLYaReWqtEPcdko+4inpVwcknl+8Zovts1NkJPF1b0tNFF/TWgihTZnv
	 txWQynlmEJGV9JUuAgO4RlguJlgzvEZsVpy2nMC1zJAJU89jC0zKgGqAcdLYAEX8z1
	 TE289mAgg4jshxQUUEpJfCO2XoR0nj21GkdmVmD1sBac9eLE+3KA6EIWPRTbWl+s7+
	 mUnFmHmLgPnegH4uw+5sh8nMKperGP/aHZovEWUaW3ZRkGMSG+hKKGX/7C9hyYMTAx
	 WKaDwSu0vx2DlsHJYlV0Wd9q9DJEA0LhvyjnSfeDF2vbpxP45gvj9WYJNr2NbPt8pF
	 UAJWgeRuCUXAA==
Date: Mon, 11 May 2026 14:09:45 -0400
From: Sasha Levin <sashal@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: Breno Leitao <leitao@debian.org>,
	Andrew Morton <akpm@linux-foundation.org>, corbet@lwn.net,
	skhan@linuxfoundation.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	gregkh@linuxfoundation.org, akinobu.mita@gmail.com,
	live-patching@vger.kernel.org
Subject: Re: [PATCH] killswitch: add per-function short-circuit mitigation
 primitive
Message-ID: <agIbaeBQAr-RkqYc@laps>
References: <agG_PZ3qcl6TwLnL@gmail.com>
 <agHUp8ulaWJ75WU5@tiehlicka>
 <agHcFCRVSn5ra5Kc@laps>
 <agHeZPA3eHhJHIsQ@tiehlicka>
 <agHgDgwu8H9Opzpl@laps>
 <agHm9Vj7bPPCRS1g@tiehlicka>
 <agH7_QBPLWKTZucB@laps>
 <agH_bGUTvWm2h5g4@tiehlicka>
 <agIHsN9tiIHnVTeV@laps>
 <agINlnNN4ubZgyiN@tiehlicka>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <agINlnNN4ubZgyiN@tiehlicka>
X-Rspamd-Queue-Id: E9C985142F1
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-2739-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[debian.org,linux-foundation.org,lwn.net,linuxfoundation.org,vger.kernel.org,gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,live-patching@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,gitlab.com:url]
X-Rspamd-Action: no action

On Mon, May 11, 2026 at 07:10:46PM +0200, Michal Hocko wrote:
>On Mon 11-05-26 12:45:36, Sasha Levin wrote:
>> Could you describe an existing infrastructure I can use here?
>
>I think it would help to CC maintainers of subsystems that provide
>kernel modification functionality. They will surely have a better
>insight than me.
>
>> Let's look at
>> this recent "Copy Fail" thing as an example.
>>
>> I can obviously build my own kernel and enroll my own key, but 99.9% of our
>> users won't be doing that.
>> Livepatching, or manually building a module that just injects a kprobe is out
>> of the question as we previously agreed.
>
>Onless I am mistaken you can enroll your own key through MOK. But you
>are right that this is an additional step. But the real question is
>whether this is a major road block for users of this specific feature.

The roadblock here is that then I need to start owning the kernel package: I
need to pull updates, rebuild, reinstall, etc. I lose the support I might be
getting from the distro vendor.

I see "users of this particular feature" as the other 99.9% of folks who don't
build their own kernel, who follow security updates from their distro vendor
and could apply the simple workaround that those vendors could now provide.

>> systemtap falls into the same bucket as building my own module.
>>
>> BPF doesn't help because bpf_override_return() requires the target to be on the
>> same within_error_injection_list() whitelist as fault injection, and the CVE
>> targets never are. Some of our fleet doesn't even have BPF enabled either, but
>> that's the smaller objection.
>>
>> I can't use fault injection because:
>>
>>  a. It's almost never built in production/distro kernels, and I suspect this
>> won't change.
>>  b. The functions I need are not whitelisted.
>>  c. Even if (a) and (b) were addressed, fault injection would still need a
>> securityfs front-end, a cmdline parser, a module-unload notifier, a taint flag,
>> and audit on engage and disengage. By the time those land in fail_function and
>> tie into/refactor the fault injection code, the net diff is bigger than this
>> proposal.
>
>I cannot comment on fault injection imeplementation details of course
>but I have to say that the whitelist nature is something that makes its
>use very limited. Maybe this is a good opportunity to change the
>approach.

Possibly, but IMO the bigger hurdle is the refactoring we'll need to do so
seperate fail_function out of the fault injection umbrella.

One approach would be to abstract the kprobe logic out of fail_function into a
common lib that killswitch could also use, but from a brief look the benefit
will be minimal.

>> In my case I can remove the module, but not if I run a distro that shipped with
>> CONFIG_CRYPTO_USER_API_AEAD=y (like RHEL/SUSE).
>
>If you look at copy fail[2], IIRC algif_aead, esp[46] and rxrcp are all
>modules that could be blacklisted.

On some distros sure, on some others, not:
https://gitlab.com/redhat/centos-stream/src/kernel/centos-stream-10/-/raw/main/redhat/configs/common/generic/CONFIG_CRYPTO_USER_API_AEAD

Even if it is a module, what if I can't just unload it because I have something
that actually uses it?

Look at the ESP issue for example. I can mitigate it by simply doing:

   echo "engage xfrm4_udp_encap_rcv 0" > /sys/kernel/security/killswitch/control
   echo "engage xfrm6_udp_encap_rcv 0" > /sys/kernel/security/killswitch/control

which only kills ESP encapsulated in UDP. The remaining functionality will keep
working just fine.

>> I can use "initcall_blacklist=" hack and reboot, but as things stand today,
>> I'll need to be rebooting few times a day.
>
>with your just disable some functions in the kernel you might need to
>reboot even more. But more seriously...
>
>> Even if I'm okay with rebooting that often (and I really really would prefer
>> not to), this doesn't solve the issues of a larger fleet of servers that can't
>> just reboot that often.
>>
>> What am I missing?
>
>For one, you are missing more maintainers of code modification infrastructures.

Happy to add more, but I don't want to be too spammy. I'll add in the
livepatching ML and the fault injection maintainer (I couldn't find a list).
Please add any other folks/lists who you think might want to contribute to this
discussion. 

-- 
Thanks,
Sasha

