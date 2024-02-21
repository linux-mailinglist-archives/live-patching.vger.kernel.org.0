Return-Path: <live-patching+bounces-171-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0880285CCA5
	for <lists+live-patching@lfdr.de>; Wed, 21 Feb 2024 01:20:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 11FB4B21555
	for <lists+live-patching@lfdr.de>; Wed, 21 Feb 2024 00:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66044382;
	Wed, 21 Feb 2024 00:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGmgz4In"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26CEA40
	for <live-patching@vger.kernel.org>; Wed, 21 Feb 2024 00:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708474798; cv=none; b=B2Hv4vBl/9aY1hDECPe5VrjFmIJlGGBYY9eNT19JqO17gA0QyGP60kTLcpsvBDZkqI+tdjDHbP/YIiPpcRVZfq+rZRyGluCyc9J8KhCEhRE7WYJ9dEVNWK2vH3gTa8SqotsKLZJ05qJnsk2ncAhM0CsGnOKgQUIUtCFgWl/IuHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708474798; c=relaxed/simple;
	bh=K7QkEMeFgCEOBDdteVUHDL15AVxzWVVyz5SmmokOZXs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eOO9yoD0hFu1xXBzUZCydUNAB5NxUHNJjXhKx2cGt+PSnJQPeZcAlp/mA67QFXksycDco0dA5f9qiOrRQv/PKwZ57xsUfFMtFbXMICIOzO5hhuQwoUPRT7SasbsrO3/QSC0lYNu0kYHjhanD2zjyWDSj8u1wexEIhOats6GLkR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGmgz4In; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so54263239f.0
        for <live-patching@vger.kernel.org>; Tue, 20 Feb 2024 16:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1708474796; x=1709079596; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1SSchokFBeolQFf43F1Ki91lkNWxa302wO4DNZKIww8=;
        b=ZGmgz4InfEOdPa4mtx0gqh8QkxsZbhOmJeVjxYaB+LKKYiQHYVu2v8wK0eki469hUp
         sdh8TGch/eG9NHkPfsm8VVXCBDe7F27k46EpRzNErcdiNmkR/HSXhVmZVZHeAzv+MmFv
         WjtKjbvDCcsUSg2hRfQTuRfDlrSbcexNclV88=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708474796; x=1709079596;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1SSchokFBeolQFf43F1Ki91lkNWxa302wO4DNZKIww8=;
        b=GgjZOXZUm7TsrJ98yd5Bte+7dSt0J9tQ+Wvn6G6N3EnroYU+82A16bFW9yPRftAYv/
         UBW0/Xn+JUrlXMxOY91TLWWsLDjrS09jmgijVl8YhVTQ91iYyI0/PRtEn9zLjDJh6ugm
         rtlZsnEhO7h6tC7ZEkrzhV3pNQJEtsPion/staLr6ybz8MaUwSO/b9BGXhXOoDYw1nVY
         Y2oLNE6NPAFp56/9jtUda7XlCqPJ9S77cuT6F4jC8RVKjPdmArgZz6jBMUR6X3uDr6uw
         qfj8wvS6S2w5LZPohQnS3etemBo3mJNZgClFvUL3BVlHZY88Ia4PIo9+uyFxiidRS6XS
         2q1A==
X-Forwarded-Encrypted: i=1; AJvYcCWsW8h0FoKfYtxw2GyompEWgoaaypnXF601ObE2omy9zVFnK4mY6cPt/RKd0fhX0oxRlcELifekEXyVS5Xg/O0w2Njo/DcFWneKkuHufA==
X-Gm-Message-State: AOJu0YwAGKp0EHBREMxLvCPB0giSUO79kJThNUbZSqwMjwxB1c29O4qB
	31kBAXJcq4ZUecJyR5GA+0ZL5JRiL0wI+nK/PXBaQj33ooDJlLia0aM/hPUzW5k=
X-Google-Smtp-Source: AGHT+IHjKllnuZm8GTJktzvD7k1+Fmvk1+TpjJvDUR7WXcS/dDJj3/rdo98ETt9VO7T5uUrGvECeJg==
X-Received: by 2002:a05:6602:f15:b0:7c7:28f7:cc81 with SMTP id hl21-20020a0566020f1500b007c728f7cc81mr11052980iob.1.1708474795830;
        Tue, 20 Feb 2024 16:19:55 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id d5-20020a056602280500b007c73e9033fcsm1884269ioe.2.2024.02.20.16.19.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Feb 2024 16:19:55 -0800 (PST)
Message-ID: <c3ee4083-fca7-43cc-b955-3b7e4faed2b0@linuxfoundation.org>
Date: Tue, 20 Feb 2024 17:19:54 -0700
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] selftests: lib.mk: Do not process TEST_GEN_MODS_DIR
Content-Language: en-US
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: kernel test robot <lkp@intel.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>,
 oe-kbuild-all@lists.linux.dev, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240219135325.2280-1-mpdesouza@suse.com>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240219135325.2280-1-mpdesouza@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/19/24 06:53, Marcos Paulo de Souza wrote:
> On Mon, 19 Feb 2024 09:15:15 -0300 Marcos Paulo de Souza <mpdesouza@suse.com> wrote:
> 
>> On Mon, 19 Feb 2024 14:35:16 +0800 kernel test robot <lkp@intel.com> wrote:
>>
>>> Hi Marcos,
>>>
>>> kernel test robot noticed the following build errors:
>>>
>>> [auto build test ERROR on 345e8abe4c355bc24bab3f4a5634122e55be8665]
>>>
>>> url:    https://github.com/intel-lab-lkp/linux/commits/Marcos-Paulo-de-Souza/selftests-lib-mk-Do-not-process-TEST_GEN_MODS_DIR/20240216-021601
>>> base:   345e8abe4c355bc24bab3f4a5634122e55be8665
>>> patch link:    https://lore.kernel.org/r/20240215-lp-selftests-fixes-v1-1-89f4a6f5cddc%40suse.com
>>> patch subject: [PATCH 1/3] selftests: lib.mk: Do not process TEST_GEN_MODS_DIR
>>> compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
>>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240219/202402191417.XULH88Ct-lkp@intel.com/reproduce)
>>>
>>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>>> the same patch/commit), kindly add following tags
>>> | Reported-by: kernel test robot <lkp@intel.com>
>>> | Closes: https://lore.kernel.org/oe-kbuild-all/202402191417.XULH88Ct-lkp@intel.com/
>>>
>>> All errors (new ones prefixed by >>):
>>>
>>>>> make[3]: *** /lib/modules/5.9.0-2-amd64/build: No such file or directory.  Stop.
>>
>> We should ask the kernel test robot machine owners to install kernel-devel
>> package in order to have this fixed.
> 
> Or maybe ask them to change the reproducer to specify KDIR to the git tree,
> instead of /lib/modules/?
> 

This would be a regression to automated test rings. Do you have any other
solutions?

We could remove livepatch from default test until these changes are made
to test ring environments?

thanks,
-- Shuah


