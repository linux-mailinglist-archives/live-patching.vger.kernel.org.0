Return-Path: <live-patching+bounces-2159-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EFevIG20q2klfwEAu9opvQ
	(envelope-from <live-patching+bounces-2159-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Sat, 07 Mar 2026 06:15:25 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4511222A309
	for <lists+live-patching@lfdr.de>; Sat, 07 Mar 2026 06:15:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C7AAF3020EA5
	for <lists+live-patching@lfdr.de>; Sat,  7 Mar 2026 05:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 312CC36C0BD;
	Sat,  7 Mar 2026 05:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lIifXCwu"
X-Original-To: live-patching@vger.kernel.org
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA90A3644D3
	for <live-patching@vger.kernel.org>; Sat,  7 Mar 2026 05:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772860520; cv=none; b=WpUTogGdPq0/YW1wNCxEkF9L2N8Wt+4bju+tgF1LSY2KLtBcmeGFA+nQ16Cxg3m0dqDlP4VERDNUenQ+I+CtVHMiQSoKm7FPbHbV5+2/wNg4fs6n3V3QRAaVCFeElW5TU15MQEjbEew6zPfwu0KlcjCr94WubvpsXFcJ3faBaA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772860520; c=relaxed/simple;
	bh=h+CX0JJ0tUyfPPria3ogYiqLcW/imvT4cgeJbLA69lk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KURuYiX0/9CYgJVm65fJGqlCoL4qaYPVKrPDJLh9E5zcSb/slaSmExkxrRqK++oSKiTyGTldJCKyrQK3AeDMgxivsyNLhSl+nMahlZ9pn9StIP2Tbacmg/w3qGWGh/rhmSUfyCDSCp25aBy8JKVDEFWcsuHI1BmkkF1xWA5lthw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lIifXCwu; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <22f5c641-f472-4fe9-aec5-a660efbfdd5e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772860506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oVeP2T6JpMBn5IOWgrXjDxvTzJ0Ym2WSlHNkgDf+DoQ=;
	b=lIifXCwuAJ2DciDp8vw6wNT10UlQ/oC/piwkNzlvQYR/nlHCqfCgAVaf9CcKcZI9C5mtBi
	mdECe/aPrXuqAHnf0siVsiy8bi/h3moP0rYal02yUMPZFD/qjGDNFju9OhOK38gKokkiQl
	tb1CbDDm/dDLrkCLattKYQyz0lnjxR4=
Date: Fri, 6 Mar 2026 21:14:56 -0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH kbuild] kbuild: Allow to reduce the number of suffixes for
 clang thin-lto build
Content-Language: en-GB
To: Nathan Chancellor <nathan@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, linux-kbuild@vger.kernel.org,
 live-patching@vger.kernel.org, kernel-team@fb.com,
 Nicolas Schier <nsc@kernel.org>, Song Liu <song@kernel.org>
References: <20260306034325.3605301-1-yonghong.song@linux.dev>
 <pat2b5nibiik6nua6ls7cu7eqy5qgrugo4gnel32bz6vpcrmz3@f7ynsbvnxcaj>
 <f1afe1e8-0dfd-47b0-8ca4-f09d4fda13eb@linux.dev>
 <bt7t2452h27o7bf27f7ljs2xhn7venhvslynq3a77jbtwi7hqk@cgobhbhi5y2r>
 <lmj53l5djuipucmuxwr563n6ty7hobduzg4vvy4pjnw4yz5t56@he3wiioegzhy>
 <f0c037e6-d498-41c3-8d71-0597a2e1d68d@linux.dev>
 <20260306224522.GA2746259@ax162>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yonghong Song <yonghong.song@linux.dev>
In-Reply-To: <20260306224522.GA2746259@ax162>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 4511222A309
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-2159-lists,live-patching=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[linux.dev:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yonghong.song@linux.dev,live-patching@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.941];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,linux.dev:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action



On 3/6/26 2:45 PM, Nathan Chancellor wrote:
> On Fri, Mar 06, 2026 at 02:12:44PM -0800, Yonghong Song wrote:
>> So you mean we do not need a new config. Should just check clang and
>> clang versionn like below?
>>
>> diff --git a/Makefile b/Makefile
>> index e944c6e71e81..9bd3990024c5 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -1034,6 +1034,11 @@ endif
>>   ifdef CONFIG_LTO_CLANG
>>   ifdef CONFIG_LTO_CLANG_THIN
>>   CC_FLAGS_LTO   := -flto=thin -fsplit-lto-unit
>> +ifdef CONFIG_CC_IS_CLANG
>> +ifeq ($(shell test $(CONFIG_CLANG_VERSION) -ge 230000; echo $$?),0)
> This is the same as
>
>    ifeq ($(call clang-min-version,230000),y)
>
> That being said, could we not just do a dynamic check so that it always
> works when these flags are supported?

Thanks for the suggestion! What you had below with 'call ld-option' is perfect
to satisfy this requirement: <= llvm22, two flags will be ignored, and
>= llvm23, two flags will be used.

v2: https://lore.kernel.org/linux-kbuild/20260307050250.3767489-1-yonghong.song@linux.dev/

>
>> +KBUILD_LDFLAGS += --lto-whole-program-visibility -mllvm -always-rename-promoted-locals=false
>    KBUILD_LDFLAGS += $(call ld-option,--lto-whole-program-visibility -mllvm -always-rename-promoted-locals=false)
>
>> +endif
>> +endif
>>   else
>>   CC_FLAGS_LTO   := -flto
>>   endif
>>
>> I think this should work. In rare case, renaming the function should
>> solve the problem.
> I agree with Josh that having this be the default behavior with the
> workarounds that we have available to us to avoid problems from it is
> worth it. Thanks for chasing this after the discussions at LPC.
>
> Cheers,
> Nathan


