Return-Path: <live-patching+bounces-185-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9459485E9A7
	for <lists+live-patching@lfdr.de>; Wed, 21 Feb 2024 22:12:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4701C285E26
	for <lists+live-patching@lfdr.de>; Wed, 21 Feb 2024 21:12:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA7B1272A3;
	Wed, 21 Feb 2024 21:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItdJFygh"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8805686AF8
	for <live-patching@vger.kernel.org>; Wed, 21 Feb 2024 21:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708549924; cv=none; b=gaTaAOHvtLPDabQcOEsPO5jSgUy+RPlZu4/2yP3gBTXt0rhWdOAoiTWwxwU913nE33eeLkGxTh9wZTYJIK1OHTE+gx8mvIRmxu8OmRRSMMvxfMX9QRT9ZUkHXDSN0jdMQzkC6FwW/o19AEeniIodplQ34D2T5TzKG/9vwauE550=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708549924; c=relaxed/simple;
	bh=eCAZYluSAU2RBM3yi8viKMCds9GjEA+ZqgAym0tc/HU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a7cn5vj3vxVU8/c3u93E5FAP+HdR6faQ+G8iNNWe9cWAk1sVkg5NcXK5q0zRcwwMPkbfaSGofsx2pp5yBNf9XxcNdzZ7rdXnIzsB76pU133f0olvd0dImIhCPpdpk8W/qyRUMulmdjW601nWuAe36G9OTXtrsQR2YigYlzWYvfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItdJFygh; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7c495be1924so82106539f.1
        for <live-patching@vger.kernel.org>; Wed, 21 Feb 2024 13:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1708549921; x=1709154721; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jmnwSrST3rdrwZH7tVh8fU2y439F+I4SPNnc2rPJRm4=;
        b=ItdJFygh+FybiLD/BTfbC2qLS6bc8gnbUww0rf5LlXeVXHCIZYu4JznYcBpUr2BO9s
         BA435dNt2I6i2nkbg5BtB0NqSCMevpFA2C25Nu133+CzuvltRTmAGN2lvnp7BPR3viBm
         O3iquGYhKF3KUngR7XUbo/V7VzBTGaIJqKaHY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708549921; x=1709154721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jmnwSrST3rdrwZH7tVh8fU2y439F+I4SPNnc2rPJRm4=;
        b=sep7TkOZ3eImkqOGmWP8PmwPfN/mb9O0xNoxiQSNEaDazFY/OWMZRVn2MzOa/KG3UK
         ccZ4WxWkVW/6l4wM2zFUix9WE/hT5PzexHTS0lMqSCuTJqz/2Xlp5NxcnUNPw5ppSrIe
         kmDSC3+ZePUvQfmUEBBB8rw+nv6A4azASmKNCZKOFSOFNKNqkHd8eQNBulptJPpARlOO
         Z0H9JwPfpj0jetRuEkVYTPjQbFvVcIfF+JvGuq49l5pV9Z629JlWUquTje3fh6wJfN9n
         UkrRwUtT/eCfXohdkQfgDhNKujUPkpqQ3i6W2ftqUdw8wWeyLaaD9/Mv+jc9TW6CcNOd
         f3vw==
X-Forwarded-Encrypted: i=1; AJvYcCUw+qXxdq0jqqTbU9Oa9AgPqN03H6q2noih1tVmo/LfBGWYeccu0Jswb6bm6Ihat9WMINMkh8BNdYSVLbkjEre6VrSYPYilXsrmSpkEBQ==
X-Gm-Message-State: AOJu0YxzPpe3vvhVHZHPTGhZKq5Tp7Aplx5dkEdByUTCkEB1CTTPXAPH
	hHy6+z8/MlE1YbDMmBpmEnRQldXoMVxODIg4OG2qd02BywSQd5ao7rdPew4wIxU=
X-Google-Smtp-Source: AGHT+IEKAg+nZ32ayi2M4M5a60R13l5jKMcKbJmjVQV6UGaoe7QNiELpd3CjkGf9tzTBuiDTkMd6Kg==
X-Received: by 2002:a05:6602:2545:b0:7c4:c985:145a with SMTP id cg5-20020a056602254500b007c4c985145amr478044iob.2.1708549921301;
        Wed, 21 Feb 2024 13:12:01 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ay23-20020a056638411700b0047437765adcsm1200095jab.81.2024.02.21.13.12.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 13:12:00 -0800 (PST)
Message-ID: <d984977f-b7ad-44b9-82dd-27aeb2fad592@linuxfoundation.org>
Date: Wed, 21 Feb 2024 14:12:00 -0700
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
References: <20240221122624.30549-1-mpdesouza@suse.com>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240221122624.30549-1-mpdesouza@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/24 05:26, Marcos Paulo de Souza wrote:
> On Tue, 20 Feb 2024 17:19:54 -0700 Shuah Khan <skhan@linuxfoundation.org> wrote:
> 
>> On 2/19/24 06:53, Marcos Paulo de Souza wrote:
>>> On Mon, 19 Feb 2024 09:15:15 -0300 Marcos Paulo de Souza <mpdesouza@suse.com> wrote:
>>>
>>>> On Mon, 19 Feb 2024 14:35:16 +0800 kernel test robot <lkp@intel.com> wrote:
>>>>
>>>>> Hi Marcos,
>>>>>
>>>>> kernel test robot noticed the following build errors:
>>>>>
>>>>> [auto build test ERROR on 345e8abe4c355bc24bab3f4a5634122e55be8665]
>>>>>
>>>>> url:    https://github.com/intel-lab-lkp/linux/commits/Marcos-Paulo-de-Souza/selftests-lib-mk-Do-not-process-TEST_GEN_MODS_DIR/20240216-021601
>>>>> base:   345e8abe4c355bc24bab3f4a5634122e55be8665
>>>>> patch link:    https://lore.kernel.org/r/20240215-lp-selftests-fixes-v1-1-89f4a6f5cddc%40suse.com
>>>>> patch subject: [PATCH 1/3] selftests: lib.mk: Do not process TEST_GEN_MODS_DIR
>>>>> compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
>>>>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240219/202402191417.XULH88Ct-lkp@intel.com/reproduce)
>>>>>
>>>>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>>>>> the same patch/commit), kindly add following tags
>>>>> | Reported-by: kernel test robot <lkp@intel.com>
>>>>> | Closes: https://lore.kernel.org/oe-kbuild-all/202402191417.XULH88Ct-lkp@intel.com/
>>>>>
>>>>> All errors (new ones prefixed by >>):
>>>>>
>>>>>>> make[3]: *** /lib/modules/5.9.0-2-amd64/build: No such file or directory.  Stop.
>>>>
>>>> We should ask the kernel test robot machine owners to install kernel-devel
>>>> package in order to have this fixed.
>>>
>>> Or maybe ask them to change the reproducer to specify KDIR to the git tree,
>>> instead of /lib/modules/?
>>>
>>
>> This would be a regression to automated test rings. Do you have any other
>> solutions?
> 
> I would say that we could skip the these tests if kernel-devel package is not
> installed. Would it be acceptable? At least we would avoid such issues like this
> in the future as well.
> 

We have to check and skip build. Something we could do in the livepatch
Makefile. Can you send patch for this - I will oull this in for next
so we don't break test rings.

thanks,
-- Shuah

