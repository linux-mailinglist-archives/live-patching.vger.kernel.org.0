Return-Path: <live-patching+bounces-203-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7487488AB7A
	for <lists+live-patching@lfdr.de>; Mon, 25 Mar 2024 18:24:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD2D71F615ED
	for <lists+live-patching@lfdr.de>; Mon, 25 Mar 2024 17:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC5F853381;
	Mon, 25 Mar 2024 16:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QYb/ne13"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7397D762CD
	for <live-patching@vger.kernel.org>; Mon, 25 Mar 2024 16:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711383335; cv=none; b=uzNjmVpZm+KofeSI5l9B4W9OVM9JWWRDJQ7m/Jk5dxvuBISAEqY8Hu/86lG45OlPPMGZ3aklubgO52mHu4vVILEnAaPr2g5QTx0dAameIqW1fbHbYRniEOpGrMsHE1P/LsirAo7vUz3CH0YNJvFLeMzENHQ1VWcwzavwNRIvAxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711383335; c=relaxed/simple;
	bh=eDgom7jRq4Xcu2vT4SgmGX5Rou29zfDZbAIVqaruxos=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
	 In-Reply-To:Content-Type; b=NWpIqrzry/zV5Pgnv83p/ffCMVHrABLhyyz+/murHbSH7tXNc1+mjEyczar4aDQQw8SrtvS49jeyQFey6rNm0Ns1W9zpferX3A69l7saZ69O37NkqZRh4zZsplV/iDtK47k1cp9afB2PUREKfeR3tLcyjTGZvE7eKvFAHw0xwtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QYb/ne13; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711383332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y18CNMCvDOhmdaHugtFzaqnuQV+HwgBjYyd9+FwW44Q=;
	b=QYb/ne138AjCouStY3BGR8vYVGIHqLhSgE6PXJ31DQ5k1J6uhetulep0/n6xkLvTvC9Ppd
	2ERTm1ibje2S7cVw6rfA6b3fxlInpt8TJj4lnoON3Z18zhElEr2HHHgSzPVS4xadn3RZzG
	1xUhXatpKxG0O9Sd9VRbIeIOO8IIVD4=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-KayxnRH1N7-Ox72IsPDNsQ-1; Mon, 25 Mar 2024 12:15:30 -0400
X-MC-Unique: KayxnRH1N7-Ox72IsPDNsQ-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-789ec0e839eso575137085a.1
        for <live-patching@vger.kernel.org>; Mon, 25 Mar 2024 09:15:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711383329; x=1711988129;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y18CNMCvDOhmdaHugtFzaqnuQV+HwgBjYyd9+FwW44Q=;
        b=fhwF0tCG6iXzhPwmFLrtCVUwFr4I7MYjymI6GkztWLrGKfq8JuVirHDXAEfplBr0ZD
         kvpelDwH/2ChQuVKlMxbbdOtpXi+3dctxFMxGrmSf3thFbUqLFQbVmO+XkF/AuBZ8jlN
         tUPrhUMP/LbXIbJqM/Jamn3eKdPBCno8yXiAzZDtzX7oalWzY+02HoOnrT2sv6HnImt+
         RL4JhMO7tEPvg7Iz2VKG0/TixyJjF9oeoR468jx72CgtkICq3IODRpI++Xo+zXszZK5X
         MHB1V44TC1qwVzl3Uo7HOSEPS/rK8JXfPcCd4aoxuOcJbYy9z3Tj72FKwzMK8r7pIhVr
         za/A==
X-Forwarded-Encrypted: i=1; AJvYcCX9fXLLCg0dYLKBecCPLXX1e4T6URipNCrzt8lxJ3kjJqukXxfPLZ263FmESJP498hgjJLZQWMPCEq32S5i6mxBiO3wMKQT5hzkn3W04A==
X-Gm-Message-State: AOJu0Yw10A/q0BftSa5aAK3nlxacJDdyzFObghGUrJCAvrQIi9cwd8ir
	aI5niAfUoZFkkW7B7//D+KKT2rGJJi6uaLdDgMLeqh4aegc3GmCA1Zcp0QjshBsTdVZ+fd4ju2i
	hKfwuOLy1E7yjgwZjdJ4afNPnquN8N7i3w2jh+ohKeXlCwui7Lv4EPy1qqBL5elQ=
X-Received: by 2002:ac8:594d:0:b0:430:d6f0:206e with SMTP id 13-20020ac8594d000000b00430d6f0206emr8829741qtz.30.1711383328929;
        Mon, 25 Mar 2024 09:15:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUsb5Xdk9G1pl6Lam/czi3bThyEoglHXEf2y3LdV6Q5bGAeN6oRDpwi7biX/J1549NCVGziA==
X-Received: by 2002:ac8:594d:0:b0:430:d6f0:206e with SMTP id 13-20020ac8594d000000b00430d6f0206emr8829712qtz.30.1711383328625;
        Mon, 25 Mar 2024 09:15:28 -0700 (PDT)
Received: from [192.168.1.27] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id v22-20020ac87296000000b004309f67c186sm2708577qto.82.2024.03.25.09.15.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Mar 2024 09:15:28 -0700 (PDT)
Message-ID: <3b33196a-e0b8-d7a9-0fda-b028753a3d15@redhat.com>
Date: Mon, 25 Mar 2024 12:15:26 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Marcos Paulo de Souza <mpdesouza@suse.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20240312-lp-selftest-new-test-v1-1-9c843e25e38e@suse.com>
 <56bf6323-9e9b-a0e3-f505-d628aac793d4@redhat.com>
 <9d4c5c6bd5b7fd0305f9ec26038f4afbea5fc166.camel@suse.com>
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH] selftests: livepatch: Test atomic replace against
 multiple modules
In-Reply-To: <9d4c5c6bd5b7fd0305f9ec26038f4afbea5fc166.camel@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/22/24 16:31, Marcos Paulo de Souza wrote:
> On Thu, 2024-03-21 at 10:08 -0400, Joe Lawrence wrote:
>> On 3/12/24 08:12, Marcos Paulo de Souza wrote:
>>> This new test checks if a livepatch with replace attribute set
>>> replaces
>>> all previously applied livepatches.
>>>
>>> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
>>> ---
>>>  tools/testing/selftests/livepatch/Makefile         |  3 +-
>>>  .../selftests/livepatch/test-atomic-replace.sh     | 71
>>> ++++++++++++++++++++++
>>>  2 files changed, 73 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/testing/selftests/livepatch/Makefile
>>> b/tools/testing/selftests/livepatch/Makefile
>>> index 35418a4790be..e92f61208d35 100644
>>> --- a/tools/testing/selftests/livepatch/Makefile
>>> +++ b/tools/testing/selftests/livepatch/Makefile
>>> @@ -10,7 +10,8 @@ TEST_PROGS := \
>>>  	test-state.sh \
>>>  	test-ftrace.sh \
>>>  	test-sysfs.sh \
>>> -	test-syscall.sh
>>> +	test-syscall.sh \
>>> +	test-atomic-replace.sh
>>>  
>>>  TEST_FILES := settings
>>>  
>>> diff --git a/tools/testing/selftests/livepatch/test-atomic-
>>> replace.sh b/tools/testing/selftests/livepatch/test-atomic-
>>> replace.sh
>>> new file mode 100755
>>> index 000000000000..09a3dcdcb8de
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/livepatch/test-atomic-replace.sh
>>> @@ -0,0 +1,71 @@
>>> +#!/bin/bash
>>> +# SPDX-License-Identifier: GPL-2.0
>>> +#
>>> +# Copyright (C) 2024 SUSE
>>> +# Author: Marcos Paulo de Souza <mpdesouza@suse.com>
>>> +
>>> +. $(dirname $0)/functions.sh
>>> +
>>> +MOD_REPLACE=test_klp_atomic_replace
>>> +
>>> +setup_config
>>> +
>>> +# - Load three livepatch modules.
>>> +# - Load one more livepatch with replace being set, and check that
>>> only one
>>> +#   livepatch module is being listed.
>>> +
>>> +start_test "apply one liveptach to replace multiple livepatches"
>>> +
>>> +for mod in test_klp_livepatch test_klp_syscall
>>> test_klp_callbacks_demo; do
>>> +	load_lp $mod
>>> +done
>>> +
>>> +nmods=$(ls /sys/kernel/livepatch | wc -l)
>>> +if [ $nmods -ne 3 ]; then
>>> +	die "Expecting three modules listed, found $nmods"
>>> +fi
>>> +
>>> +load_lp $MOD_REPLACE replace=1
>>> +
>>> +nmods=$(ls /sys/kernel/livepatch | wc -l)
>>> +if [ $nmods -ne 1 ]; then
>>> +	die "Expecting only one moduled listed, found $nmods"
>>> +fi
>>> +
>>> +disable_lp $MOD_REPLACE
>>> +unload_lp $MOD_REPLACE
>>> +
>>> +check_result "% insmod test_modules/test_klp_livepatch.ko
>>> +livepatch: enabling patch 'test_klp_livepatch'
>>> +livepatch: 'test_klp_livepatch': initializing patching transition
>>> +livepatch: 'test_klp_livepatch': starting patching transition
>>> +livepatch: 'test_klp_livepatch': completing patching transition
>>> +livepatch: 'test_klp_livepatch': patching complete
>>> +% insmod test_modules/test_klp_syscall.ko
>>> +livepatch: enabling patch 'test_klp_syscall'
>>> +livepatch: 'test_klp_syscall': initializing patching transition
>>> +livepatch: 'test_klp_syscall': starting patching transition
>>> +livepatch: 'test_klp_syscall': completing patching transition
>>> +livepatch: 'test_klp_syscall': patching complete
>>> +% insmod test_modules/test_klp_callbacks_demo.ko
>>> +livepatch: enabling patch 'test_klp_callbacks_demo'
>>> +livepatch: 'test_klp_callbacks_demo': initializing patching
>>> transition
>>> +test_klp_callbacks_demo: pre_patch_callback: vmlinux
>>> +livepatch: 'test_klp_callbacks_demo': starting patching transition
>>> +livepatch: 'test_klp_callbacks_demo': completing patching
>>> transition
>>> +test_klp_callbacks_demo: post_patch_callback: vmlinux
>>> +livepatch: 'test_klp_callbacks_demo': patching complete
>>> +% insmod test_modules/test_klp_atomic_replace.ko replace=1
>>> +livepatch: enabling patch 'test_klp_atomic_replace'
>>> +livepatch: 'test_klp_atomic_replace': initializing patching
>>> transition
>>> +livepatch: 'test_klp_atomic_replace': starting patching transition
>>> +livepatch: 'test_klp_atomic_replace': completing patching
>>> transition
>>> +livepatch: 'test_klp_atomic_replace': patching complete
>>> +% echo 0 > /sys/kernel/livepatch/test_klp_atomic_replace/enabled
>>> +livepatch: 'test_klp_atomic_replace': initializing unpatching
>>> transition
>>> +livepatch: 'test_klp_atomic_replace': starting unpatching
>>> transition
>>> +livepatch: 'test_klp_atomic_replace': completing unpatching
>>> transition
>>> +livepatch: 'test_klp_atomic_replace': unpatching complete
>>> +% rmmod test_klp_atomic_replace"
>>> +
>>> +exit 0
>>>
>>
>> Hi Marcos,
>>
>> I'm not against adding a specific atomic replace test, but for a
>> quick
>> tl/dr what is the difference between this new test and
>> test-livepatch.sh's "atomic replace livepatch" test?
>>
>> If this one provides better coverage, should we follow up with
>> removing
>> the existing one?
> 
> Hi Joe,
> 
> thanks for looking at it. To be honest I haven't checked the current
> use of atomic replace on test-livepatch.sh =/
> 
> yes, that's mostly the same case, but in mine I load three modules and
> then load the third one replacing the others, while in the test-
> livepatch.sh we have only one module that is loaded, replaced, and then
> we unload the replaced one.
> 
> Do you see value in extending the test at test-livepatch.sh to load
> more than one LP moduled and the replace all of them with another one?
> I believe that it adds more coverage, while keeping the number of tests
> the same.
> 

Yeah, it shouldn't be too hard to combine this test with the existing
one by adding the 3 module load to the beginning of the test.

Verifying the livepatch count is an interesting new wrinkle.  (Do check
out the shellcheck warning about leveraging the output of ls, though.)
If atomic-replace was used throughout the test suite, I might say that
load_mod should be aware and check accordingly, but it's not the default
build mode, so counting the final livepatches in the test itself seems
reasonable enough.

-- 
Joe


