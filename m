Return-Path: <live-patching+bounces-675-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3648497EF05
	for <lists+live-patching@lfdr.de>; Mon, 23 Sep 2024 18:16:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBE6F282C09
	for <lists+live-patching@lfdr.de>; Mon, 23 Sep 2024 16:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43C6319EECD;
	Mon, 23 Sep 2024 16:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMHhifpi"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11797DA81
	for <live-patching@vger.kernel.org>; Mon, 23 Sep 2024 16:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727108194; cv=none; b=ZvLOl426CA4m8OkRpBswgFdyhE9vmu58p1673hb+vhZnxBQitXXp2e3g9Jo1leNpkWk1B5OcigJdgIqY/f3ftJ3iRQn2UoMuN0u7ZcK7X8+/BV3c9sT8fjjclVq9XzxyFXkxDm/H7ivNP2S7Z2QHlF6TtrYfMk909jy8rOtAkKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727108194; c=relaxed/simple;
	bh=PaVCnBOKk2NESWPONQlxx6ZgFkfE6jLEf8fYtjJKjb8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=o4J3cSGcdZNAVm0qdzJ9LoZP9mdb7Enf/R71yx/o8smwR41XRZhTb5diWeBeNhZftItGHbHgtxPn0+vSHqv+bGKYpMg2iWMDrKofuEIi7jnfCgUUyQIZ4neW+yRdbIUTLNnmYNTaoWg6IsdYTTq+zkdoM9FxeZlqI2cxO7+nyC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMHhifpi; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3a098a478c4so14395655ab.1
        for <live-patching@vger.kernel.org>; Mon, 23 Sep 2024 09:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1727108191; x=1727712991; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P5jMyl1o/1TmcmM08X17fpAg4ADxzwYCfdFzHbbaa3w=;
        b=YMHhifpipIKLWvy/w02AZkCFkO32+0xzVUmxERUJt0kTVnVSwPnAAgKLlSI4E45bdu
         8d/jbtNRvc9QX15qgv3be3JdiYVz+Zxdc8YFqwAA1cuzvdYmyjro6HYHr0AqUJajMkUz
         tMLeLH2SmGLTCLGLDSnS5+73I1HK1pHL47oJs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727108191; x=1727712991;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P5jMyl1o/1TmcmM08X17fpAg4ADxzwYCfdFzHbbaa3w=;
        b=i8D6a4Z9/Z2UEyJQ8xqim9uV8pbCoqC0ITEtvgkZItJZ0tY8hJ/bNr2UZRLk+OBilZ
         DdBwYfFOAfv24iqOjv0N1qAaChGABUXYBtFSmglYmolIJyg4sNhBIrpfya7Ks3IprSe2
         9nOYpREgUyRtpPyddFQPPBSFKnbM3lE/NLsF4nMRtEvBFWfJO4g0hEbuGJTugSvG11gv
         Sb+zpVeWCs9MvaBexvkY557VirB7sX83QNs6SEwvTCr80MISFYmeKiR0EOI3IPmfxWgf
         BDXVZmdmPrZ7pTzHmC7Mq1hAlwVuwwfvxvE3HXzbtpy6CTOZKcjRxx1EOTK+x20TjQom
         zIaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXB+OatdFmvMlveAVPn/gRyY0ot60Ecy/eSbM5BGFYXjQXqUMu+8ekEVc4jEGn+rd4l+hfx3FqQb6kYkRe@vger.kernel.org
X-Gm-Message-State: AOJu0YzV5pGV4Ale+q75pZiPNjSFVf5YUIDTaEYoxpv2vAaP6LvHdX6J
	v+UCslQlP31Fx/d+Jy3UDZnmcn99sq165aQM2U29n8wymBbrGgu7mdlCfQRjZjQ=
X-Google-Smtp-Source: AGHT+IEavZikzUvEoQrnouuHC7VsGydWDHWwaU5JCQGMN+RAYA4mkhllBoYUAIZRqWeOopdM8/dwBQ==
X-Received: by 2002:a05:6e02:1a63:b0:3a0:9f85:d74e with SMTP id e9e14a558f8ab-3a0c8d0ba04mr100943395ab.16.1727108190886;
        Mon, 23 Sep 2024 09:16:30 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d37ed1901dsm5162715173.115.2024.09.23.09.16.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2024 09:16:30 -0700 (PDT)
Message-ID: <9abe1f61-3379-44b5-8b8a-517c3df34daa@linuxfoundation.org>
Date: Mon, 23 Sep 2024 10:16:29 -0600
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/3] selftests: livepatch: test livepatching a kprobed
 function
To: Marcos Paulo de Souza <mpdesouza@suse.com>,
 Michael Vetter <mvetter@suse.com>, linux-kselftest@vger.kernel.org,
 live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240920115631.54142-1-mvetter@suse.com>
 <5e544e68ad83fcdeb3502f1273f18e3d33dc8804.camel@suse.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <5e544e68ad83fcdeb3502f1273f18e3d33dc8804.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/23/24 08:45, Marcos Paulo de Souza wrote:
> On Fri, 2024-09-20 at 13:56 +0200, Michael Vetter wrote:
>> This patchset adds a test for livepatching a kprobed function.
>>
>> Thanks to Petr and Marcos for the reviews!
>>
>> V3:
>> Save and restore kprobe state also when test fails, by integrating it
>> into setup_config() and cleanup().
>> Rename SYSFS variables in a more logical way.
>> Sort test modules in alphabetical order.
>> Rename module description.
>>
>> V2:
>> Save and restore kprobe state.
>>
>> Michael Vetter (3):
>>    selftests: livepatch: rename KLP_SYSFS_DIR to SYSFS_KLP_DIR
>>    selftests: livepatch: save and restore kprobe state
>>    selftests: livepatch: test livepatching a kprobed function
>>
> 
> Thanks for the new version! LGTM, so the series is
> 
> Reviewed-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> 
>>   tools/testing/selftests/livepatch/Makefile    |  3 +-
>>   .../testing/selftests/livepatch/functions.sh  | 13 +++-
>>   .../selftests/livepatch/test-kprobe.sh        | 62
>> +++++++++++++++++++
>>   .../selftests/livepatch/test_modules/Makefile |  3 +-
>>   .../livepatch/test_modules/test_klp_kprobe.c  | 38 ++++++++++++
>>   5 files changed, 114 insertions(+), 5 deletions(-)
>>   create mode 100755 tools/testing/selftests/livepatch/test-kprobe.sh
>>   create mode 100644
>> tools/testing/selftests/livepatch/test_modules/test_klp_kprobe.c
>>
> 

Assuming this is going through livepatch tree:

Acked-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah


