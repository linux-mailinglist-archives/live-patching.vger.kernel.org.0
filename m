Return-Path: <live-patching+bounces-1283-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0284DA66010
	for <lists+live-patching@lfdr.de>; Mon, 17 Mar 2025 22:05:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77C2F19A1DB6
	for <lists+live-patching@lfdr.de>; Mon, 17 Mar 2025 21:03:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A3E1F6664;
	Mon, 17 Mar 2025 21:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LcnBaM/I"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF73816F8F5
	for <live-patching@vger.kernel.org>; Mon, 17 Mar 2025 21:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742245260; cv=none; b=KfoXpdXfiYzinMAWBV64Q6KS44DuPCKLK2+OlZdu9xeor8DcIc8iRV9qEJmisDXxU8rRSzTndWgtyOxgKuFXKJWpOZT3XVtbQk+jZ7T4gKNl/Js3na7Ro0MX8eMdiJmV+B1zFCyJS5ud8Yifzpn5DuqlbtbDlA1JHGBbq2U5FCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742245260; c=relaxed/simple;
	bh=ISG/VRvYaHrtSGL94DrkcgVKLeoYJbGfnOJYb1Z4LOo=;
	h=Message-ID:Date:MIME-Version:From:To:Cc:References:Subject:
	 In-Reply-To:Content-Type; b=bdDxgtTiElcqlr6UREOTRtIG0IfVQEZY07LNCieWalMJxHeiJuG1UHu55FG3J0PMWLP/rKlE3D3dGQTWJqZsLENlDBlEq2tKsyfaspt6KQvzOuPMFVFe1Fz1/HbifTfcP3TW6PzzbjkU65aO8tZGQ+Dqdous4UJLtY2uqTQ2jn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LcnBaM/I; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742245257;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5L2jBArOye8pA1mIQk2n7F0Xc8SDHCwe3ymXGpyJ8GM=;
	b=LcnBaM/IWvv3SixUwSatm3ATXuGivvDiuUYkU+LG+go/sBIkxgLH3N8vZFNfNW4NTaXOx5
	CwOfbBBSjUKkrIppifOHkNW79n71Ay2hXuyqN93OMwRvLOyL7D38dVUkEg2IXKlk/aSEkV
	4XKmoq1aM59/CANOYLhyrwq+NjdIdv8=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-mz3qrF1ZNT-682kqVBXTwQ-1; Mon, 17 Mar 2025 17:00:56 -0400
X-MC-Unique: mz3qrF1ZNT-682kqVBXTwQ-1
X-Mimecast-MFC-AGG-ID: mz3qrF1ZNT-682kqVBXTwQ_1742245256
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d438be189bso55302155ab.3
        for <live-patching@vger.kernel.org>; Mon, 17 Mar 2025 14:00:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742245255; x=1742850055;
        h=content-transfer-encoding:in-reply-to:subject:references:cc:to:from
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5L2jBArOye8pA1mIQk2n7F0Xc8SDHCwe3ymXGpyJ8GM=;
        b=MIozz7CP8h336fAXfBfYETiii2jS6Wnu+yCIoo9fF/AHUP2y3aQ2nC7uyqEavIrmLo
         hJkREKOLgbcLc4UnSLYXYmCsKVhRqa7SAcmHSlQmYSbUsAScT6gHzeOdWfuIzAGO1KS3
         V1shd+zOMq/ZbkCqvvgAZr/iJ/EaRWBx1hw0wHXzGb0+m1BG9JHxdQyLiUdnZ4bl4xG4
         2mg44WFZKzF/20A5uK+iuv74RIzlGxnPi4aaO+lUmf1+RpLL/j8LRC+unCrBHwPl65FS
         OZhEwgg3iMciILE7qEyfscLNNw/W7ppmSgl0RkqVntVMRbueCh1AnPUnqJzQOsR4MBHp
         UprA==
X-Forwarded-Encrypted: i=1; AJvYcCVG4GgOWlcO5koVhz1JxY730JWL918UPsKmEoT86dEZFUUGe5WbnsDcQWc3/IcGsVrTQZLayRkfMWSulzku@vger.kernel.org
X-Gm-Message-State: AOJu0YzHJxd4bHz3IVbK2QYGT0/j4s7cOJ0k2ZBYb8qKjg2fEOejC6CO
	T6tI+Zcxpbt7sSa91R5GIrKvtOtXaJLt1qENSECv4D6Gn6YWrEd0Kl8Q32z+LYmMFQnhc/FDI27
	T9Pb7N/ELK3xm0zZ4yrK3xIwn4KalEbF06gjrLJvaE3oUrj0QH1+T/SyatN1wIyw=
X-Gm-Gg: ASbGncvGM5zzsjjm/GOutCka39ecgVTpMjo6+lO6ZZDkKTgwewxy2rvXoLy3SCumEgj
	1WsPb86ml4RSw37rQRzM2IPVB4ngBqBVXTqlU2lhEC9joaA8pnt3hR80/w6DelA805XlOuhccoX
	fucAhHDelx/pTZBMVOcfm9XYX8OtGhYtOvnRqXMVgesPa7M2pBooDDz+RsAr8/P6fFZAjxDh5T8
	AOnNt9aDDV4cdelDNw671JC1QTWnYK7vuIg/SQZ9wMPgpLWPj/ddilreYLgMPBEajBjJD03ZQr7
	ZLTNJ7n1uVnUmuJAh1kJcuLteppm4Ceb8SZcd96A7HRb+SOlee5Xl/aewiAqQGxBURRzNes=
X-Received: by 2002:a05:6e02:1d9b:b0:3d4:3cd7:d29c with SMTP id e9e14a558f8ab-3d57b9d5c50mr15389465ab.11.1742245254982;
        Mon, 17 Mar 2025 14:00:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE/bYoFZ7xaFiya0nsM9F04yaS7FBAwl7+t5zD0FipoGL1EWaB+AW6t98axQuOeT7/LxArivQ==
X-Received: by 2002:a05:6e02:1d9b:b0:3d4:3cd7:d29c with SMTP id e9e14a558f8ab-3d57b9d5c50mr15389105ab.11.1742245254690;
        Mon, 17 Mar 2025 14:00:54 -0700 (PDT)
Received: from [192.168.1.11] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2637196d7sm2403973173.37.2025.03.17.14.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Mar 2025 14:00:54 -0700 (PDT)
Message-ID: <86e20ddb-5d1c-8b52-c5dd-3cc33b54828c@redhat.com>
Date: Mon, 17 Mar 2025 17:00:51 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
From: Joe Lawrence <joe.lawrence@redhat.com>
To: Song Liu <song@kernel.org>, live-patching@vger.kernel.org
Cc: jpoimboe@kernel.org, kernel-team@meta.com, jikos@kernel.org,
 mbenes@suse.cz, pmladek@suse.com
References: <20250317165128.2356385-1-song@kernel.org>
 <2862567f-e380-a580-c3be-08bd768384f9@redhat.com>
Subject: Re: [PATCH] selftest/livepatch: Only run test-kprobe with
 CONFIG_KPROBES_ON_FTRACE
In-Reply-To: <2862567f-e380-a580-c3be-08bd768384f9@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/17/25 14:59, Joe Lawrence wrote:
> On 3/17/25 12:51, Song Liu wrote:
>> CONFIG_KPROBES_ON_FTRACE is required for test-kprobe. Skip test-kprobe
>> when CONFIG_KPROBES_ON_FTRACE is not set.
>>
>> Signed-off-by: Song Liu <song@kernel.org>
>> ---
>>  tools/testing/selftests/livepatch/test-kprobe.sh | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/tools/testing/selftests/livepatch/test-kprobe.sh b/tools/testing/selftests/livepatch/test-kprobe.sh
>> index 115065156016..fd823dd5dd7f 100755
>> --- a/tools/testing/selftests/livepatch/test-kprobe.sh
>> +++ b/tools/testing/selftests/livepatch/test-kprobe.sh
>> @@ -5,6 +5,8 @@
>>  
>>  . $(dirname $0)/functions.sh
>>  
>> +zgrep KPROBES_ON_FTRACE /proc/config.gz || skip "test-kprobe requires CONFIG_KPROBES_ON_FTRACE"
>> +
> 
> Hi Song,
> 
> This in turn depends on CONFIG_IKCONFIG_PROC for /proc/config.gz (not
> set for RHEL distro kernels).
> 
> Is there a dynamic way to figure out CONFIG_KPROBES_ON_FTRACE support?
> Without looking into it very long, maybe test_klp_kprobe.c's call to
> register_kprobe() could fail with -ENOTSUPP and the test script could
> gracefully skip the test?
> 

Ugh, n/m, looking at the code now I see it already does return
-EOPNOTSUPP, but insmod throws out the code (if it even gets that far)
and so it only reports success or failure.  Graceful handling will have
to be more clever than that.

-- 
Joe


