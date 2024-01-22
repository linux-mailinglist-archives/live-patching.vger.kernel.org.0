Return-Path: <live-patching+bounces-153-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97888836EB0
	for <lists+live-patching@lfdr.de>; Mon, 22 Jan 2024 19:00:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 92D8F1C28CF9
	for <lists+live-patching@lfdr.de>; Mon, 22 Jan 2024 18:00:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1320352F82;
	Mon, 22 Jan 2024 17:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCIqAD7c"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FDF612C5
	for <live-patching@vger.kernel.org>; Mon, 22 Jan 2024 17:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705944179; cv=none; b=iEp+P1uI57yWXj+Z6K6PAPRYFNWFvR43ivppE3o7rMZtIJTfcsuS0MAUEiwVZyf24OkKcQXfg8do+3OVldrbq9M8XlXTVH+fLJVDtlzGBFjtd69AJuYZYvQP6QUJ9CTCbNTqsCSL8g/BaLe12W4FHGFwElFCrMQtxTa+7jJBOXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705944179; c=relaxed/simple;
	bh=bEHwRRHZEZ5muODAZZTChjTXAGcN8GLNJSdSobXIA0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bb2LZIzEGJI6pFlqCL9ShIumPS6I0vLwkLOUedUy3A+wVB4ZptkkxDLRErXvclsimGGsECtG90NxMQKjIqG1KrmQu9UH0R6fD1NO7cAaHgLxM0yRYdgrsvqxGUYxESsFrjVvrujQCljB35EuUgBKBlEGtkI2hzmKemjzfjb9++c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCIqAD7c; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6d9ac0521c6so830653b3a.0
        for <live-patching@vger.kernel.org>; Mon, 22 Jan 2024 09:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1705944177; x=1706548977; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3cKBLusi5odBbefyu3q7+UJ6/M6hhfLrmEnRO/AYdSg=;
        b=NCIqAD7cPTDcHzPOjo+YrAdQhZRnfiXAizEgkmFr/YbQQIzPn5dYBRVoS31a+ULPw8
         /R5CcIGj6Mm8eLJg3DZK7ZCJPQpjgbfXu8Q11j91CGCoGCU8BY1JBVY6JepkTDzF5D1c
         axZaTBWHcjXBZ4ya9oqXJyJ/HDv68Y293Vi/M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705944177; x=1706548977;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3cKBLusi5odBbefyu3q7+UJ6/M6hhfLrmEnRO/AYdSg=;
        b=vtXx4srKpzRC3Prtmn3uk/7FtmH1H3rDXgedK0LPW85PEyTSepQy78b9N1U0eggIsd
         LF/sN1Edi8xBxRZVPcCcL4JGJ3RJHR6Q3qSjmx3PUtfMfWyh72mhFHxQ1g2daep1Js0v
         S5LFX+wirq4ugX8UWT0R77qPCuyAnRz3Cvdr5dEB02rsrbWx7nMjYvjVX0AY0R1YCWOx
         PcBsVHCMGYqjBZ487MDHvu+B1/ZXNlDrWAvbOB5wywnbjy2xKIIDHy07CEgeukFZ/m9m
         +DXyyly1FIYDZTI61BmdbmjQT8oFrokkD9q0X86y3GB45/qIK5O9wNxV9j/2SRb16hmV
         muGA==
X-Gm-Message-State: AOJu0Yws1+Ai31Tf7g1rLH7mZvItUmvUH7um592QAUZsoFIlFQHBuYKW
	doWJmdNAgGLaGxyhJqMMa+KhAbZqGK9shSAweM7v5Y2CSZN6rQptNuKxR6H0rLo=
X-Google-Smtp-Source: AGHT+IGjgFJLDdAfyqDNErB5PR6R2A+VDqHcrvgpf1rrqIFIthJVkNUJsACPjPjML0hqNb41Xog8zQ==
X-Received: by 2002:a62:6204:0:b0:6d9:383b:d91a with SMTP id w4-20020a626204000000b006d9383bd91amr8897256pfb.1.1705944176719;
        Mon, 22 Jan 2024 09:22:56 -0800 (PST)
Received: from [128.240.1.152] ([206.170.126.10])
        by smtp.gmail.com with ESMTPSA id y74-20020a62ce4d000000b006d9a48882f7sm10245573pfg.118.2024.01.22.09.22.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jan 2024 09:22:56 -0800 (PST)
Message-ID: <f3ba4181-ab38-4779-987f-9bda47f003be@linuxfoundation.org>
Date: Mon, 22 Jan 2024 10:22:54 -0700
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/3] livepatch: Move tests from lib/livepatch to
 selftests/livepatch
Content-Language: en-US
To: Marcos Paulo de Souza <mpdesouza@suse.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
 Petr Mladek <pmladek@suse.com>, Joe Lawrence <joe.lawrence@redhat.com>,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 live-patching@vger.kernel.org, skhan@linuxfoundation.org
References: <20240112-send-lp-kselftests-v6-0-79f3e9a46717@suse.com>
 <20240112-send-lp-kselftests-v6-2-79f3e9a46717@suse.com>
 <Zap04ddls7ZvbL/U@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <Zap26MINbbxREt4c@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <53cf93b2efadc0f42712eb92436bd575b5622664.camel@suse.com>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <53cf93b2efadc0f42712eb92436bd575b5622664.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/22/24 05:55, Marcos Paulo de Souza wrote:
> On Fri, 2024-01-19 at 14:19 +0100, Alexander Gordeev wrote:
>> On Fri, Jan 19, 2024 at 02:11:01PM +0100, Alexander Gordeev wrote:
>>> FWIW, for s390 part:
>>>
>>> Alexander Gordeev <agordeev@linux.ibm.com>
>>
>> Acked-by: Alexander Gordeev <agordeev@linux.ibm.com>
> 
> Thanks Alexandre and Joe for testing and supporting the change.
> 
> Shuah, now that the issue found by that Joe was fixed, do you think the
> change is ready to be merged? The patches were reviewed by three
> different people already, and I don't know what else can be missing at
> this point.
> 

I would have liked doc patch and lib.mk separate. However, I am pulling this
now to get testing done. In the future please keep them separate.

thanks,
-- Shuah


