Return-Path: <live-patching+bounces-1289-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1DC3A67AA9
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 18:20:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B607B1892986
	for <lists+live-patching@lfdr.de>; Tue, 18 Mar 2025 17:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13B23213E69;
	Tue, 18 Mar 2025 17:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XfB2Vv9d"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC521AB50D
	for <live-patching@vger.kernel.org>; Tue, 18 Mar 2025 17:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742318312; cv=none; b=ke437Y076FC8Vno0TjJOJP3raUM8X1OeRahh/dS12DcRz7M559d6+GP2q+gqkgYhZUe3MsVSS0dswcBcHFfdfa9cZ0azakvX2I5V5O2fDC06pXFaFzIRJFCnw/RWMCoiB0vdsrBdyS16Qghil/rb8Ik2N06791EXsfVq7t3F5YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742318312; c=relaxed/simple;
	bh=EgrGZ6KyLdXZrNkue3NnJ0WeR8E0Qlgg6fAygeoIzjo=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
	 In-Reply-To:Content-Type; b=melNKtpxCl/p3estvILlzGkhbKj096QO7TRQU5e9mjJud14RG6iEI2YgPh4ekfoi1hSKqvbLE5jC6io46fw1xtzV6j1vx0hchxcrEe5NU5OgK+7Kx+sF429g/E1uS8obEAOsbnhJ6BZjCHqWmR//Rm+lZNcoG4WN/1WSm4vhL/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XfB2Vv9d; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742318309;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZQoYApCycSct8afRXIMH/sMLNykvtAGuWni/gar9CfU=;
	b=XfB2Vv9dCvi5mpXF6PR7fX7SD3n4t6XsFZLJZkUB/CFsK5VwMpr1qwP20Pqv1CfL+KIJd2
	DGqBH0lza2vJgHKmx8Sd0ipBlmEWTca79Mb5yygcfOZ5NP5GtOVuhYdcejcCzy4p5CEShL
	StqkNM+OP3lr2IsA+6oLHg2aGX5Zf30=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-5npbc511PqKRSSQexcDyXw-1; Tue, 18 Mar 2025 13:18:28 -0400
X-MC-Unique: 5npbc511PqKRSSQexcDyXw-1
X-Mimecast-MFC-AGG-ID: 5npbc511PqKRSSQexcDyXw_1742318307
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d434c328dbso106515245ab.3
        for <live-patching@vger.kernel.org>; Tue, 18 Mar 2025 10:18:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742318305; x=1742923105;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZQoYApCycSct8afRXIMH/sMLNykvtAGuWni/gar9CfU=;
        b=VMAY8zJ6MYa1FEO1shKi5dKeM2DGx3VCYBBrT+0pmPBv/NmY9HMK7SJrlOdP4+xuS+
         DPECjDMjGllki3K8efpU5qANsMqQwrl4k7x7lKyp/A+9I+FXFFhxaAjS60/ma1zx93iI
         t0uN/a+jL1tleq6TfuQHayIaBPPWNWdguBGIOkFQv6D5k6IUkiyw/HaAXdRrEUcdvRJt
         9eH8sagjB/ofmRJpIrqXVKIh/Tk9JCR0NAHCHhffKxHC0cFbXG0ab3HEGbOoQwUv5IEX
         9Eo5zvaU5vx8FoNqzTy3RbDsDFuWiXypIQG3puDmEoZOfq9+F7wZB0H+e4m/YRNqkwpr
         uXOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGqsUuwTcEw2xvpY3MuHHuYKOI4A3G5eDAl2oSq8Cacmpq6nrjEiBWq9wRtv/8fErfUGK12y04gmx8YxbY@vger.kernel.org
X-Gm-Message-State: AOJu0YzPo75/+2h7dAVugHp9wMfbHek+iLS+MW0nAwaVDLD2EZPsZzJs
	ClcnVdRK7zTp6oHN2IZB3qvQUlSYfYoZYwJUTcdnw6h60FwwboEamxvxnffYf4bX7X1Jet1qjfe
	HyFU1HeJERDADXmq8MQ7Gmq8hx4Gg2Bl7R8ogcUpyppw6QEiUU/hUgeumv0f+XRE=
X-Gm-Gg: ASbGnctZXOCK8VUMOduhN5t9GiMNd7+Ar52RMaWDBDby8prEL0+j9M2bCq7PER0Xoq3
	HCFvJv1bMEQAdQRI9SZMMeOPLGMukt02/6pmhuznR3q/w1GY0ID+GSNFlavSg6oiePHkvaD3XJC
	jIrK5cCQyHnjv+zsGmOuj5EDR9l8FkujSgi7z7g6/h/kyLUmCE9jbMGb9aSer7FtOsbmrqOUaiG
	e2iuFcNNZrLGWKyViz1hzrkzNBL14T5bph03yT432fNAhz6N4jJ2Be8B5j9drLidjAtXSLGYAM7
	vxKztBKcqSacPJ27KA6iLMnA7wlGvzU0VuR0+o+7zzmE1dB1o1rzZCbXCxZKRrgEjx0ekxM=
X-Received: by 2002:a05:6e02:1d06:b0:3d3:e3fc:d5e1 with SMTP id e9e14a558f8ab-3d4839f5dd3mr159264565ab.1.1742318305264;
        Tue, 18 Mar 2025 10:18:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE2vhrpLwlQWCTa/HpYMrvPQH72ZujaPdTg300XPG5jPY0U2mxkvGlBMtuU/vaQOAOCapb8mA==
X-Received: by 2002:a05:6e02:1d06:b0:3d3:e3fc:d5e1 with SMTP id e9e14a558f8ab-3d4839f5dd3mr159264215ab.1.1742318304800;
        Tue, 18 Mar 2025 10:18:24 -0700 (PDT)
Received: from [192.168.1.11] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f263727597sm2751455173.60.2025.03.18.10.18.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Mar 2025 10:18:24 -0700 (PDT)
Message-ID: <671de80a-f3a4-9cd7-0de0-9a8930113232@redhat.com>
Date: Tue, 18 Mar 2025 13:18:22 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Song Liu <song@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
 jpoimboe@kernel.org, kernel-team@meta.com, jikos@kernel.org, pmladek@suse.com
References: <20250317165128.2356385-1-song@kernel.org>
 <2862567f-e380-a580-c3be-08bd768384f9@redhat.com>
 <CAPhsuW6UdBHHZA+h=hCctkL05YU7xpQ3uZ3=36ub5vrFYRNd5A@mail.gmail.com>
 <alpine.LSU.2.21.2503181112380.16243@pobox.suse.cz>
 <Z9l4zJKzXHc51OMO@redhat.com>
 <CAPhsuW63DceUb6Gfv8QaxwZFO+eKCNotdcppLhe=FJ0Ujoh=CA@mail.gmail.com>
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH] selftest/livepatch: Only run test-kprobe with
 CONFIG_KPROBES_ON_FTRACE
In-Reply-To: <CAPhsuW63DceUb6Gfv8QaxwZFO+eKCNotdcppLhe=FJ0Ujoh=CA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/18/25 12:25, Song Liu wrote:
> On Tue, Mar 18, 2025 at 6:45 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>>
>> On Tue, Mar 18, 2025 at 11:14:55AM +0100, Miroslav Benes wrote:
>>> Hi,
>>>
>>> On Mon, 17 Mar 2025, Song Liu wrote:
>>>
>>>> On Mon, Mar 17, 2025 at 11:59 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>>>>>
>>>>> On 3/17/25 12:51, Song Liu wrote:
>>>>>> CONFIG_KPROBES_ON_FTRACE is required for test-kprobe. Skip test-kprobe
>>>>>> when CONFIG_KPROBES_ON_FTRACE is not set.
>>>>>>
>>>>>> Signed-off-by: Song Liu <song@kernel.org>
>>>>>> ---
>>>>>>  tools/testing/selftests/livepatch/test-kprobe.sh | 2 ++
>>>>>>  1 file changed, 2 insertions(+)
>>>>>>
>>>>>> diff --git a/tools/testing/selftests/livepatch/test-kprobe.sh b/tools/testing/selftests/livepatch/test-kprobe.sh
>>>>>> index 115065156016..fd823dd5dd7f 100755
>>>>>> --- a/tools/testing/selftests/livepatch/test-kprobe.sh
>>>>>> +++ b/tools/testing/selftests/livepatch/test-kprobe.sh
>>>>>> @@ -5,6 +5,8 @@
>>>>>>
>>>>>>  . $(dirname $0)/functions.sh
>>>>>>
>>>>>> +zgrep KPROBES_ON_FTRACE /proc/config.gz || skip "test-kprobe requires CONFIG_KPROBES_ON_FTRACE"
>>>>>> +
>>>>>
>>>>> Hi Song,
>>>>>
>>>>> This in turn depends on CONFIG_IKCONFIG_PROC for /proc/config.gz (not
>>>>> set for RHEL distro kernels).
>>>>
>>>> I was actually worrying about this when testing it.
>>>>
>>>>> Is there a dynamic way to figure out CONFIG_KPROBES_ON_FTRACE support?
>>>>
>>>> How about we grep kprobe_ftrace_ops from /proc/kallsyms?
>>>
>>> which relies on having KALLSYMS_ALL enabled but since CONFIG_LIVEPATCH
>>> depends on it, we are good. So I would say yes, it is a better option.
>>> Please, add a comment around.
>>>
>>
>> Kallsyms is a good workaround as kprobe_ftrace_ops should be stable (I
>> hope :)
>>
>> Since Song probably noticed this when upgrading and the new kprobes test
>> unexpectedly failed, I'd add a Fixes tag to help out backporters:
>>
>>   Fixes: 62597edf6340 ("selftests: livepatch: test livepatching a kprobed function")
>>
>> but IMHO not worth rushing as important through the merge window.
>>
>>
>> Also, while poking at this today with virtme-ng, my initial attempt had
>> build a fairly minimal kernel without CONFIG_DYNAMIC_DEBUG.  We can also
>> check for that via the sysfs interface to avoid confusing path-not-found
>> msgs, like the following ...
> 
> We already have CONFIG_DYNAMIC_DEBUG=y in
> tools/testing/selftests/livepatch, so I think we don't need to check that again.
> 

Ah right.  Do you know what script/file reads or sources that file?
(It's such a generic term that I get a bazillion grep hits.)  When I run
`make -C tools/testing/selftests/livepatch run_tests` it just builds and
runs the tests regardless of the actual config.

-- 
Joe


