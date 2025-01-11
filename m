Return-Path: <live-patching+bounces-968-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 284E0A0A528
	for <lists+live-patching@lfdr.de>; Sat, 11 Jan 2025 19:00:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 32FB93A68E4
	for <lists+live-patching@lfdr.de>; Sat, 11 Jan 2025 18:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91DF61B424D;
	Sat, 11 Jan 2025 18:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AzB8vYm8"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF8C1494CC
	for <live-patching@vger.kernel.org>; Sat, 11 Jan 2025 18:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736618440; cv=none; b=ml2b0ZEcFviN4YmIPNihWZS/dTVBTl0Tu2SMDYmm+V0RcMNYQc4Gn3C+CMzOECPKszx9eKbl+Mj/yol/fI4sE9+IdW+1OMGSANYNSvtj/aYV3R4icMoq907dF55/KYvlKQ0z1Jn8Fl3MWSJ2DMJoP/iqYr5iYS7sEeQEaCHBj0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736618440; c=relaxed/simple;
	bh=rl4tzMbjTVPrZL8vIZg0CsU+U4RCupZ142ByB8y5vNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uMdq8MU7s8q5u9YiyMfgwyr889HuI3gXM9sndmTk4bwV8Cap3QPelFzvrfF42jPrXREfsQW2uCepSZFQJvr6AzcJmrRh15Qz2Fm7vxiC06IUPIxqD6sLtD+lIXAfOpoe7YR6PG+chSsEg12Mkb+61pS50CdnrkhIvNGwfgDBPMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AzB8vYm8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736618437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=65m01HXSlqOBQF0X6QUSrEpGfIBoOq9A2r6WX82xrgk=;
	b=AzB8vYm8cdmWtbGHKFds9On9i3pwXYtAQGR46EywRC48ogFZICdX1FL6jn765G2AVtZ9lv
	21CpJovhi7gd6M8euEA6kW/69MNAhM8ezNW/mpPEBJP3w7NqZPRJVFk4wkvLm7gLHrKX9i
	9mVm6jBj1PohHX3FNa0MCZRSBNzsPDY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-YebiG8oHN6OhKj8GndsfFw-1; Sat, 11 Jan 2025 13:00:36 -0500
X-MC-Unique: YebiG8oHN6OhKj8GndsfFw-1
X-Mimecast-MFC-AGG-ID: YebiG8oHN6OhKj8GndsfFw
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7b6e5c9ef38so509510685a.1
        for <live-patching@vger.kernel.org>; Sat, 11 Jan 2025 10:00:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736618435; x=1737223235;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=65m01HXSlqOBQF0X6QUSrEpGfIBoOq9A2r6WX82xrgk=;
        b=J8sJ8F8HbeK/N81Xz3bUXIy8zshV6M1nOgHbOXrMNLbxssEJTpiv7GxN0vm56o/g1o
         D7RhzoyAz4v+Zbw1C1HmV7gaPvocXW/GIjH5NaGK4g06dJAKLR9iFAQ2KANG6R+NcCsQ
         46MLZSVgS2q6XyRFkXIAIN+dbyNOu+7qcGQs1JEcLjFP/wfdAoW0B7KfKupiI8Kb0BrS
         7JF1Z2jo8Q2fFTXj26azzN7+Z9cWo6aZL+9k8dsw2HJS70a3R+/3dGxtFVTJNca8xY0y
         JV4o2BtIh7nll+8P/qf8olEbDk49GcWmd+wzZH2L/JC7rU+ZvWoek7hF5p6i6ZpZQI2h
         hMqg==
X-Forwarded-Encrypted: i=1; AJvYcCVJ3kpLgC/XxDDXo1ydlACN0jjLJEVVJR4P+laGbSjeegbsVE4hSM1As6zOqQLSiIoT9J7fDBqNh9bpTiZp@vger.kernel.org
X-Gm-Message-State: AOJu0YxhfvxRrWgUdt/DFj3Mps4T+6IuRUJQ2JWu30FJ2gaWR5okDcAl
	tKdHNmGRnA/g/4ZQXBBJFL6GT0ejwqbj9fK2TSTTPeYfsl5QM5i3Yh8Ojj34fSgbLf0OnUHqscA
	X265a8/OAZzHlriVDFUgVPylkg1yRRGfASJeYdyTBq0wzBUHlpJGzOMnK+IsDO/o=
X-Gm-Gg: ASbGncvLsnD+eoqcVgD973CT7z+kgacla1bzu/C6VgR50Q6ZZoSwL5cZvW5vtP3t/Yq
	PmBNKUunyVaLENuRMo1ODjIME4K3LgJFgmD8EWCiUwgX89+QkrdfBUsVQBsLOxWjhtpxE92zkBs
	uxO7xoEEF0XnGXO5eMan/w20Ka/cDCzjy9oaPPBewi1nxs3RXa0UdAtfach758sIR2HgC0AFCuF
	AX/cIfjRwFMW91V5e3eX1JZYdH4mPn1sPUx1CK6nO4jZS0uuyzSuRRm9FYuq6dbc71KMgck4MMw
	raqQDC4n0CJGSxb0mYpYj1fjZ41Xz+gowjadiHA=
X-Received: by 2002:a05:620a:4e50:b0:7b6:d237:abfa with SMTP id af79cd13be357-7bcf3670440mr376712185a.21.1736618435655;
        Sat, 11 Jan 2025 10:00:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGUdu/RdQiy62AcFdeOz8EqMSt9UG6Qp5/L1AaHX+TMZ/CBG16QzRl866a0rluy1MJWs1zVjw==
X-Received: by 2002:a05:620a:4e50:b0:7b6:d237:abfa with SMTP id af79cd13be357-7bcf3670440mr376708085a.21.1736618435329;
        Sat, 11 Jan 2025 10:00:35 -0800 (PST)
Received: from [192.168.1.45] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7bce3238003sm303883985a.2.2025.01.11.10.00.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2025 10:00:33 -0800 (PST)
Message-ID: <20867ce3-901c-7821-fe02-ccd223fdcf17@redhat.com>
Date: Sat, 11 Jan 2025 13:00:31 -0500
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] selftests: livepatch: test if ftrace can trace a
 livepatched function
Content-Language: en-US
To: Filipe Xavier <felipeaggger@gmail.com>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
 Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Felipe Xavier <felipe_life@live.com>
References: <20250102-ftrace-selftest-livepatch-v1-1-84880baefc1b@gmail.com>
 <Z31VBN3zo47Ohr27@redhat.com>
 <9edd671a-be5e-41c9-a8dc-b1fd1d5e3375@gmail.com>
From: Joe Lawrence <joe.lawrence@redhat.com>
In-Reply-To: <9edd671a-be5e-41c9-a8dc-b1fd1d5e3375@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/10/25 12:13, Filipe Xavier wrote:
> Em 07/01/2025 13:23, Joe Lawrence escreveu:
> 
>> On Thu, Jan 02, 2025 at 03:42:10PM -0300, Filipe Xavier wrote:
>>> This new test makes sure that ftrace can trace a
>>> function that was introduced by a livepatch.
>>>
>> Hi Filipe,
>>
>> Thanks for adding a test!
>>
>> Aside: another similar test could verify that the original function, in
>> this case cmdline_proc_show(), can still be traced despite it being
>> livepatched.  That may be non-intuitive but it demonstrates how the
>> ftrace handler works.
> 
> Thanks for the review Joe!
> 
> I have fixed all points mentioned below,
> 
> and have a patch ready to submit.
> 
> Do you believe that this other similar test could be sent later,
> 
> or is it required in this patch?
> 

The second test could be added later if you like, either way is fine w/me.

Thanks,

-- 
Joe


