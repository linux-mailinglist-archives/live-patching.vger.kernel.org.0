Return-Path: <live-patching+bounces-1516-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 65E45AD5EEF
	for <lists+live-patching@lfdr.de>; Wed, 11 Jun 2025 21:21:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FDAC16F631
	for <lists+live-patching@lfdr.de>; Wed, 11 Jun 2025 19:21:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0657027CCF3;
	Wed, 11 Jun 2025 19:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NsEdqaXV"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D826198A1A
	for <live-patching@vger.kernel.org>; Wed, 11 Jun 2025 19:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749669693; cv=none; b=uagrQY45Yi6LMZ5ywJJ+ntW2WhwJZM0Tth3FofmYAk6A/2QVyE25zKE2C6vBo/Id6MepvmdGLDq7a8c3b4N0QYqyd9zd31YWWaa0t5Kletz01BDxfTNUxW7c8/zfrlcEVwo8Sr7mjXuVm4VLq6ZmfmGTyWoR4x/582pIqXuD1M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749669693; c=relaxed/simple;
	bh=HMN2fi2TmhdHEV32HsDxSoAR5XfJc1qOe1LERRefehk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EXHbhxVyRqVH64fOYWru2cqrPJkxXfENHObjpR5Y5RV6uG1aPVGLZ9tCqX4NQMhXcc4XFottwbheriTXGP4ROIcHTofUXAQxLourkgOwKuJmWqfi+ftgLfxLR3J7701CgARfymWUXe29B/JeNMSRFcvFSdKYj79zPKwU7iI7dLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NsEdqaXV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749669691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YWk6r3wX+x8EGIq9XU5abkxHWPirOn7mXEdF47KgwPI=;
	b=NsEdqaXVnzZR6Fekhz5Nex3fVBl85PRYHU03Osm0B6IogDgfG9vwkpe7uq9bMfQHDu47XN
	PXDc6QkDcfL9PgM16Sq3ikxVUXwnrH/KG1feyOHSr4y/+Ns+VnQlVw2RBo3S60gjkCz0Sn
	DzO3NkvT+5lISOlngDeq8PoD6rPQnuM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-HglCm0-CPui39bFmbobMFw-1; Wed, 11 Jun 2025 15:21:30 -0400
X-MC-Unique: HglCm0-CPui39bFmbobMFw-1
X-Mimecast-MFC-AGG-ID: HglCm0-CPui39bFmbobMFw_1749669689
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c793d573b2so30655285a.1
        for <live-patching@vger.kernel.org>; Wed, 11 Jun 2025 12:21:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749669689; x=1750274489;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YWk6r3wX+x8EGIq9XU5abkxHWPirOn7mXEdF47KgwPI=;
        b=d/Rh8fTXNaXCVYJYf8mviSppN06QYPOtZtpztXKsEbLr36lNwvYa6F67PfrQcSc+TH
         0mOtSe5STQzyHmFqQGVoz618AFuaCYFi+PXXEz4/J1+5ffHPbzqOVjgpxClZ7jywR0uB
         WULryMqS2koiCEov3kzraoXecSateaVl8hDvlF/AoJwwwhBiiN7PEWj1eQgCrz6mz+TA
         HODsxolGwxNVknnLYx//tEPDA8i0AMDHzT0w0481QeKjee7P09M0HmO9/aOBb/fJKuNc
         qAIwnH5CKCPi/s3OPowz+k62+BATeI+wU52zF+4SYvRx7kyq9NiNV86P9befpVSL5olf
         /vsQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+Z4tWWx2R6VD7mkjqQO5mG8H9XMV+rQB2GLM36ZKFKyfk0Jc6c4HkVXN9RA2vp6Y1Pg3z9vZmxA5vAJMx@vger.kernel.org
X-Gm-Message-State: AOJu0YzOxgley8j3+jT0ZqC75qIwLiByf0rE6V6VtaVD4i/LFPk4RHV/
	OU8I0AiNJruV9o9aHxjIqQg5PGIed52H6oHf+v4de8P2JKwWxolBzpMBGYFFdNxzgyROWuZUaCx
	ShnkZuCrnbMdIUbeZeTZ27xp/94sHQdPal4o0+MXjgrQRibhtGqzIfh6mlsUNV5UZw1k=
X-Gm-Gg: ASbGncsSUNqb43YVI19plvv81xrLHA4uY723GhwEb1CDB4VXdDI+DH8qNMsxACKdkZN
	onTMn051hXgbi13ZKVtS5+108mr7+hT24Rhzq7M8QeECgWE7z5a+fjxwSJTd3yZpLX6LwWSTbpn
	a9FgVv0LGPI4wYVU5tKoJ7Tf+Sl5tTfXPWXHw/tL85asoFwjOe5ywZXK4z50G1JJmjQXr3tmWi2
	s1q2oi7Jdt1R5ApNQac4qC8F6I20bTlHyLsZ8bWmwXmiqBV2Rq+MCNcn7EPkmPyj82fnqpqZkJC
	8i/3icO/6/R0KsVy2jnzqBIQjGIY+g8iS8exiGZ0T+01Elvc405ePofkVGplfl5ET2QLjSQx8uG
	4ig==
X-Received: by 2002:a05:620a:4110:b0:7d3:8d1e:9703 with SMTP id af79cd13be357-7d3a88e40c8mr611380785a.33.1749669689170;
        Wed, 11 Jun 2025 12:21:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGPmKMJwPRr4iSghVXRwPOrOjJvpMtoECu4tD1pD2f54epIlHFwj+Ns6F3NMx7ew6HvX5jS+Q==
X-Received: by 2002:a05:620a:4110:b0:7d3:8d1e:9703 with SMTP id af79cd13be357-7d3a88e40c8mr611376885a.33.1749669688656;
        Wed, 11 Jun 2025 12:21:28 -0700 (PDT)
Received: from [192.168.1.17] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d2669b4900sm901765985a.109.2025.06.11.12.21.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Jun 2025 12:21:28 -0700 (PDT)
Message-ID: <ba9ec5eb-8078-4780-a2bd-db53c12f437d@redhat.com>
Date: Wed, 11 Jun 2025 15:21:26 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 59/62] livepatch/klp-build: Introduce klp-build script
 for generating livepatch modules
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
 live-patching@vger.kernel.org, Song Liu <song@kernel.org>,
 laokz <laokz@foxmail.com>, Jiri Kosina <jikos@kernel.org>,
 Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>,
 Fazla Mehrab <a.mehrab@bytedance.com>,
 Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <10ccbeb0f4bcd7d0a10cc9b9bd12fdc4894f83ee.1746821544.git.jpoimboe@kernel.org>
 <8c79b86e-fc30-4f48-bdd2-91ef6f612bb5@redhat.com>
 <c7bifa7n7ybhqxxwbcl7o5743gl6ezd2odx63qc3nmqwcqpxiy@64oztd4qm3um>
Content-Language: en-US
From: Joe Lawrence <joe.lawrence@redhat.com>
Autocrypt: addr=joe.lawrence@redhat.com; keydata=
 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
 pNzsRQ==
In-Reply-To: <c7bifa7n7ybhqxxwbcl7o5743gl6ezd2odx63qc3nmqwcqpxiy@64oztd4qm3um>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/25 3:08 PM, Josh Poimboeuf wrote:
> On Wed, Jun 11, 2025 at 02:44:35PM -0400, Joe Lawrence wrote:
>>> +get_patch_files() {
>>> +	local patch="$1"
>>> +
>>> +	grep0 -E '^(--- |\+\+\+ )' "$patch"			\
>>> +		| gawk '{print $2}'				\
>> If we split the rest of this line on the tab character and print the
>> first part of $2:
>>
>>   gawk '{ split($2, a, "\t"); print a[1] }'
>>
>> then it can additionally handle patches generated by `diff -Nupr` with a
>> timepstamp ("--- <filepath>\t<timestamp>").
> Hm?  The default gawk behavior is to treat both tabs and groups of
> spaces as field separators:
> 
>   https://www.gnu.org/software/gawk/manual/html_node/Default-Field-
> Splitting.html
> 
> And it works for me:
> 
>   $ diff -Nupr /tmp/meminfo.c fs/proc/meminfo.c > /tmp/a.patch
>   $ grep -E '^(--- |\+\+\+ )' /tmp/a.patch | gawk '{print $2}'
>   /tmp/meminfo.c
>   fs/proc/meminfo.c
> 
> Or did I miss something?

Ah hah, I fixed up the code in refresh_patch() with that double gawk,
and then noticed it could have just called get_patch_files() instead.

So yeah, you're right, the simple gawk '{print $2}' handles both cases
already :)

-- 
Joe


