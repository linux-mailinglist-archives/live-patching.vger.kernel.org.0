Return-Path: <live-patching+bounces-2125-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kMYaNPGfqWnGAwEAu9opvQ
	(envelope-from <live-patching+bounces-2125-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 16:23:29 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D6552146F7
	for <lists+live-patching@lfdr.de>; Thu, 05 Mar 2026 16:23:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 026B431CD788
	for <lists+live-patching@lfdr.de>; Thu,  5 Mar 2026 15:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91DD33ACA57;
	Thu,  5 Mar 2026 15:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EANCRiph";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IAis4jKt"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C123BED4F
	for <live-patching@vger.kernel.org>; Thu,  5 Mar 2026 15:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772723914; cv=none; b=O0n7EvHXq9TQ1biH6kErp5yj9CKz3z1KpQTawu+Gl/O/ndErwDHppIIT+WpVN+U+gIRtr6eFNfx9vkdZ3rl+x14fy2BP1L0h50Nq1T0GiVNHgOHhJW/9oozjX/QTqpjJPiVF9fzKNz72ogvEBgxODFcQ52DoXRuFqrWNunfhmvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772723914; c=relaxed/simple;
	bh=zrN2quUagauiqqljomBmYYcUrzKA7wXr4isw19alcxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e+78q9UMg6nmL+n9QLYgvhtMNOooFSwcuDKzFU0ctkLfQHhO1+E9gcSdskBiSlJhwMxhr3viRkbiSm1Lz4vnmmT1WN8Y4cl12+GuE/7HopoVR3u9mQMQUNl6ygMQmnyaYXqYMcbBfymIHHuoaQt/eQsDMpYRny87FRhcg3ww2ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EANCRiph; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IAis4jKt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772723912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4c37moaop9vKqY8CFeSuLOf6KcTweufStofUdaCXKV0=;
	b=EANCRiphtSxUYWdVljrF6iabtWSQ7fyW/h2mObbRuAWmKFiKQog6O4CdkLqKaeX58XW2n3
	QwtAyV5zCXNaRPRcUKdTGm1jebHdqnA7zakJu9OWCd/+Deo4khZ0O1M79IffOXHXYvCTsO
	aqPqrw/+fwe/bUscZpf2pBqb2n+xLh8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-qJEA2StcMQGkznNkbGVTvw-1; Thu, 05 Mar 2026 10:18:31 -0500
X-MC-Unique: qJEA2StcMQGkznNkbGVTvw-1
X-Mimecast-MFC-AGG-ID: qJEA2StcMQGkznNkbGVTvw_1772723910
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5032e68560dso624443641cf.3
        for <live-patching@vger.kernel.org>; Thu, 05 Mar 2026 07:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1772723910; x=1773328710; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4c37moaop9vKqY8CFeSuLOf6KcTweufStofUdaCXKV0=;
        b=IAis4jKtTUamVhtZmFNgBo0uJciQuaxSoviFKqMkDseTa3JDKFHh2CVBCDnyChANsn
         yVz6KKEkjgATTfp9dkTvN5brgNAbJSbtequoMjLllfCvRynqeLg4ANnBfRO2xUZSFKCv
         BckQZGaSza1TITHCp0gmmiCWEfuwLttqQ4HqbyDL7qO+/7/OFV6oXHAczSyl+SY85wT3
         2PNerlI8JhFD6aLpmk9Bc9N0wA7DT0+Evak/TZLuePsFbewu1Xq2r0BI2DLTlpiHjhv2
         H8aTQ/ObcRR1K/JKOZVTMvHd3xHJ9KxWXgwqrcaXot8MWowusjXrPFsWGzTHguXC0bi2
         GqQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772723910; x=1773328710;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4c37moaop9vKqY8CFeSuLOf6KcTweufStofUdaCXKV0=;
        b=RwZA5oZWGR7YzXgYf3Qa7QijfnZ+WN4fRRcMvYEAU6Xm8LOuk0AinlTtgPu13aB4Jn
         9icLjCTJ65MxIqa0P0X281k+o8nlIe7dXXmbxffawJ4OK8AY6kmioWqoaYREhY1yilUA
         cx/+Chcw0+0h+EemBzJZYi7yMh8dGEu/LfPcAUu9n9+rlTqWVfJABPb6CYVON/koqF9w
         ND6U6NZqxDc8omPhzB8+ii9T3CySWC/Z2zMYIDWV5dVy8ib9x7uZ8JU4d/yWwJB8o9r+
         qN6rL4Xfhm9Qtxot1Xtw1TlESB2ME0znUQFAN/A8Gy+sbA5lJRVazkUTSV+2GcyEFBCd
         mSeA==
X-Forwarded-Encrypted: i=1; AJvYcCU3FqRr74vc8HqvXXQS71iBtpPHNAWf+LgtR8B+LsaCWcULlQRvtqwZ4I2YLWg+dH3KFwVMOMR5GZ29I8Yc@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8TzWDhpIUFH5ZW8pr3DxncewtCzJMkssz3YTAqu/XHREqKxfy
	ygfu/Mnw+zaJTJUrynwQ01g4GQ4xWgyTFoSNdnr5rOMtm244DdfgMDqTDFQ14Gq+y12NaXt8dra
	SNntGnawitq7NkgC7oUbCvmFYrFOQDnuV4gd5tZOHePp6dZBGn/fcgu97Ee5dt29GJf1Pc3401F
	Y=
X-Gm-Gg: ATEYQzynoT5XsJMsrqL++aLHG9hDVmN17nzoJb6N+bIHxjZF8PE8o9oal1Kr5Ika5ba
	1NhfgDxux5FSJFfCwhF4zBZ7PPvgxyf1MOvx+FmyL2qhkIugHNJYd1RLJkfTnuZdJ29j/MS7B9C
	eHdcF8+rAsL/Lf+ziwcqDdUeD2xu7fl9ZVhiWMbSS2yglyQqBQOyA1lFEJwrb1A+d2aznTSg7qd
	tDzE87MdPCzif6tOTzs+1pMT7PzezKY/4lgr4D/0fNbKq/ht3DgQNpl1clb71BUBaiHTh9pMJC2
	X86rs6z4OfmisbK/nKEXqRBDV6RZh385ZZhgGAmNT8f3JB2gWSXa4ThTpz35SQI5Z5oVA7GTAzV
	FOiisIKqTJSXe6OyWVAroS9kjaNfh1D02c4WdpyXIMmUxO7VRKZdnFzXBL1sQzuVxQsPiQhCWov
	fgfA==
X-Received: by 2002:ac8:5f06:0:b0:506:be2c:a96e with SMTP id d75a77b69052e-508db437aeamr72874281cf.67.1772723910062;
        Thu, 05 Mar 2026 07:18:30 -0800 (PST)
X-Received: by 2002:ac8:5f06:0:b0:506:be2c:a96e with SMTP id d75a77b69052e-508db437aeamr72873801cf.67.1772723909591;
        Thu, 05 Mar 2026 07:18:29 -0800 (PST)
Received: from [192.168.1.17] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50744acf0desm177281641cf.23.2026.03.05.07.18.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2026 07:18:29 -0800 (PST)
Message-ID: <d55d5a29-e83a-432a-a723-9cf96668a3ac@redhat.com>
Date: Thu, 5 Mar 2026 10:18:28 -0500
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/8] livepatch: Add tests for klp-build toolchain
To: Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
 jpoimboe@kernel.org, jikos@kernel.org, kernel-team@meta.com
References: <20260226005436.379303-1-song@kernel.org>
 <20260226005436.379303-9-song@kernel.org>
 <alpine.LSU.2.21.2602271052240.374@pobox.suse.cz>
 <CAPhsuW69EZTcMGyXSKv2fEjh7mhtYaSxriZrSgX0nTPCEYKS7A@mail.gmail.com>
 <alpine.LSU.2.21.2603020930540.21479@pobox.suse.cz>
 <aaiI7zv2JVgXZkPm@redhat.com>
 <CAPhsuW6Nx6meWVCkTJXmp5BzTX_2s2dt1j+C-=AtMzQ8ZV396A@mail.gmail.com>
 <aajexDFNdFz_Lsrp@redhat.com>
 <CAPhsuW51ihr9mDv6Ov+vJAn_7feqTra2XFXUFm-cb4teE_4s8w@mail.gmail.com>
 <aamOXVxBXF8ivyVf@pathway.suse.cz>
Content-Language: en-US
From: Joe Lawrence <joe.lawrence@redhat.com>
Autocrypt: addr=joe.lawrence@redhat.com; keydata=
 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
 pNzsRQ==
In-Reply-To: <aamOXVxBXF8ivyVf@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6D6552146F7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2125-lists,live-patching=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[live-patching];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joe.lawrence@redhat.com,live-patching@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[7];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On 3/5/26 9:08 AM, Petr Mladek wrote:
> On Wed 2026-03-04 21:03:41, Song Liu wrote:
>> On Wed, Mar 4, 2026 at 5:39 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>>>>> (Tangent: kpatch-build implemented a unit test scheme that cached object
>>>>> files for even greater speed and fixed testing.  I haven't thought about
>>>>> how a similar idea might work for klp-build.)
>>>>
>>>> I think it is a good idea to have similar .o file tests for klp-diff
>>>> in klp-build.
>>>>
>>>
>>> kpatch-build uses a git submodule (a joy to work with /s), but maybe
>>> upstream tree can fetch the binary objects from some external
>>> (github/etc.) source?  I wonder if there is any kselftest precident for
>>> this, we'll need to investigate that.
>>
>> Ah, right. I forgot that carrying .o files in the upstream kernel is a bit
>> weird. That may indeed be a blocker.
> 
> I am afraind that caching .o files in the upstream git tree can't work
> in priniple. The upstream tree is generic. But .o files are comparable
> only when using the same toolchain, ...
> 
> Or do I miss anything, please?
> 

Hi Petr,

For kpatch-build, the cached object files were placed in a separate repo
away from the source code:

  https://github.com/dynup/kpatch-unit-test-objs/commits/master/

and its purpose is mostly to avoid regressions against known code
sequences (i.e. gcc omitting symbol section symbols, clang unnamed
sections, static call tests, etc.)  It only exercises the binary
comparison code and not full livepatch generation, so it never creates
or loads any .ko.

But you are right that the toolchain, optimization levels, etc. can all
contribute to generating unique code sequences.  The unit-test-objs were
 a (huge time) optimization to avoid building kernels just to check
things that should be generated 99% of the time -- or perhaps never,
given the toolchains we had on hand.  For example, we've converted a few
user bug reports into unit tests as we didn't have a particular compiler
version or kernel config at the ready.

It's a nice tool to be able to run a `make unit` test against your
development branch and have an answer in a few minutes.  The full `make
integration` test takes at least a few coffee cups and dog walks to
complete :D

Hope that clarifies things?

Regards,

-- 
Joe


