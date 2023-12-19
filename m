Return-Path: <live-patching+bounces-90-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EBDD818A73
	for <lists+live-patching@lfdr.de>; Tue, 19 Dec 2023 15:50:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 021821F2DF78
	for <lists+live-patching@lfdr.de>; Tue, 19 Dec 2023 14:50:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 979E51BDEA;
	Tue, 19 Dec 2023 14:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h41aocnY"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1591C68A
	for <live-patching@vger.kernel.org>; Tue, 19 Dec 2023 14:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702997422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qeJD0ZhEV9sTAtcyMvPkAuUPH96iGtm2NtO/84uhMP0=;
	b=h41aocnYnjd12zU4x1xxMIVjvUD1e3ZBGkXdLur9Pr/hwIqu7B6CJI1+mF7wZpXGVNlh7I
	uSvEOEe0fiY7pPtRyxCPmrqiKmyg5BlS5WqY3LvLw+cBm6dspPMkr7rl4GaEYLc3P0xsav
	faRubvXOgJNyvLHwghDqCOfViPMKqTs=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-547-cM-6nbYwM0C1F49GAZbVzg-1; Tue, 19 Dec 2023 09:50:20 -0500
X-MC-Unique: cM-6nbYwM0C1F49GAZbVzg-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-67f2caa9001so47473836d6.1
        for <live-patching@vger.kernel.org>; Tue, 19 Dec 2023 06:50:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702997420; x=1703602220;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qeJD0ZhEV9sTAtcyMvPkAuUPH96iGtm2NtO/84uhMP0=;
        b=bpe4A8IvjXrfzlzrAHPyxiriWU6GzxaSfkZ6/SAamVOlxpu/Ki2y6lf6OAOYSH8EIq
         Hq1o86NtgR7Lhnpjjbxv7XmCEjluD46t1OSVmFFwwbk8fN40L7nasVWhjDXAutrJEjo2
         FxQv9Tu+KxNputfxITyVdxXIy9RI3C42mRVcKUVtgrPcNvQREqdY+8n4Y61axsxn2JXt
         0yZG49Kxawqyb0gWn2KyzEknTXGfxV0U6kiAa6BZ+lH39dglgUqPWA7Oo8YL1gx6D6LL
         zD+NCFPjLs/AOisRKrvYpQXQ9ByCBH2KB1pxy22R19uVL1jKVUvsBR3OIZRSODRGqqkr
         /GgQ==
X-Gm-Message-State: AOJu0YwT6qnqx0QGcJ47n8WUWoYD8hvdnZYYE4Jy23dS8rZdRceJn7WT
	AkDQHJwCRAGTSF3z4ipAdB/a5Wevr/aL/juoWUTFXMDCwwo0jchrHd46yg79gslq8iPwe+WWjMV
	haul5mkH8JR8m9vvyKkTQghIOj89REFjxEg==
X-Received: by 2002:a05:6214:f21:b0:67f:2eda:8eb6 with SMTP id iw1-20020a0562140f2100b0067f2eda8eb6mr8541143qvb.37.1702997420062;
        Tue, 19 Dec 2023 06:50:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFgDZhpjRKWluB0vbYyC+B4wyhpe2gZ7mfx71cOXHBg5T+iQxNLo+ui2mber2Acze7TT+FGnA==
X-Received: by 2002:a05:6214:f21:b0:67f:2eda:8eb6 with SMTP id iw1-20020a0562140f2100b0067f2eda8eb6mr8541137qvb.37.1702997419851;
        Tue, 19 Dec 2023 06:50:19 -0800 (PST)
Received: from [192.168.1.14] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id uw2-20020a05620a4d8200b0077f103c8ad6sm9164643qkn.82.2023.12.19.06.50.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Dec 2023 06:50:19 -0800 (PST)
Message-ID: <8adb8209-d49b-4feb-5ab3-47ca4f3cefbc@redhat.com>
Date: Tue, 19 Dec 2023 09:50:18 -0500
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
 linux-kselftest@vger.kernel.org, live-patching@vger.kernel.org,
 linux-s390@vger.kernel.org
References: <ZYAimyPYhxVA9wKg@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <cf087c7e-d24d-5cee-eadd-dd1fe26efe39@redhat.com>
 <ZYDLZkXdJ22AXtLW@redhat.com>
 <ZYFmOfFgsOdeikec@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: selftests/livepatch fails on s390
In-Reply-To: <ZYFmOfFgsOdeikec@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/19/23 04:45, Alexander Gordeev wrote:
> On Mon, Dec 18, 2023 at 05:44:54PM -0500, Joe Lawrence wrote:
> 
>> @@ -280,7 +268,13 @@ function set_pre_patch_ret {
>>  function start_test {
>>  	local test="$1"
>>  
>> -	save_dmesg
>> +	# Dump something unique into the dmesg log, then stash the entry
>> +	# in LAST_DMESG.  The check_result() function will use it to
>> +	# find new kernel messages since the test started.
>> +	local timestamp="$(date --rfc-3339=ns)"
>> +	log "livepatch kselftest timestamp: $timestamp"
>> +	LAST_DMESG=$(dmesg | grep "livepatch kselftest timestamp: $timestamp")
> 
> Not sure if it not paranoid mode, but still..
> If the 'log' call is guaranteed synced? AKA would 'grep' always catch the line?
> 
> And yeah.. if the log output is pushed away (e.g by a crazy-dumping concurrent
> logger), then nothing here would work. But this is not a new problem, so just
> my two cents.
> 

Good question.  I added the timestamp message to ensure there would  be
something in the log to grab onto... but I'm not sure what guarantees
there are about syncing back out through dmesg.

There is a loop_util() utility function in the script that could be used
to wait, like:

	log "$last_dmesg_msg"
	loop_until "dmesg | grep -q '$last_dmesg_msg'" ||
		die "Can't find canary dmesg entry, buffer overrun?"
	LAST_DMESG=$(dmesg | grep "$last_dmesg_msg")

That should catch 1) short latencies and 2) buffer rollover.  Maybe that
is good enough?

-- 
Joe


