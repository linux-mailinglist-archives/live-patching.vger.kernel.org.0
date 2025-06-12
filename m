Return-Path: <live-patching+bounces-1519-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 11D40AD79BF
	for <lists+live-patching@lfdr.de>; Thu, 12 Jun 2025 20:26:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9141B3B46AD
	for <lists+live-patching@lfdr.de>; Thu, 12 Jun 2025 18:25:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F2E826D4E2;
	Thu, 12 Jun 2025 18:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YAswRbuH"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6073A2AE6D
	for <live-patching@vger.kernel.org>; Thu, 12 Jun 2025 18:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749752757; cv=none; b=d78FMW0UsIIxnJmB/ra4vlXfgPdkMf5Yo6cHKyKaqx7AiIkqbrYY/Kx4ZDCmj8xOR/F2LqbnPwgojnq29iHdxKLpzYoaHpaCdOxLmgEO6Maad7+NE0M4RadIQVCJN5zCnGRWKfFKpGoYsLFy/HGBT71NT86ESC9ob20a0PwA/W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749752757; c=relaxed/simple;
	bh=dR48tUjYWtP0jyzZ6txv4BiaSaZ+Izb0eg1xjl67Xqk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Tzn5GK6A7p0Cj8PBE1JiPnI97mukxmxKKQyteuVN3hLi/+m/L56Z8NGABOnA8PJFCe2Mku/3dPltwwtE8DHWZLE19fZ1gqdwVa4QKJTk2S5K1IEikNqO2+N4LgPcNoZHOyiBrR/Liwb1Pwr2vHPond1Gy7PKXE9sksVSuiNfR8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YAswRbuH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749752754;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mT5s3NcwQlvCbAF1ke/m714sd1KBFrvwnMoHz5CwDTw=;
	b=YAswRbuH1R4evVE14L5/EPDAB3mFHpBVZHIr1rQwW5jSLgx4M6PYU/0AxCC9M3Uo7KRF5z
	g1Y82N9yG35GCsHFoPa4G5mz5Q7Y3Q7bGppkCkfeRIJH+EE1RxsgUX3rNAcmAOPbHosDT1
	MpaujAt6lQst92omUIro+SRiiCcPatM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-BZpdhcFTNQKJeXHb5nPMiw-1; Thu, 12 Jun 2025 14:25:52 -0400
X-MC-Unique: BZpdhcFTNQKJeXHb5nPMiw-1
X-Mimecast-MFC-AGG-ID: BZpdhcFTNQKJeXHb5nPMiw_1749752751
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c791987cf6so258644385a.0
        for <live-patching@vger.kernel.org>; Thu, 12 Jun 2025 11:25:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749752751; x=1750357551;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mT5s3NcwQlvCbAF1ke/m714sd1KBFrvwnMoHz5CwDTw=;
        b=CmmP3+7QYpwMwtdZDS2RvyXIjV+sHt/kv2yMnqbCuubf2cPQeZX1GtuWdlZhoyoDt6
         fplavaqW576I0KmriDG/Ik1sGIgzRbPw3M4QMY+cklBDKtgVWtqcEju1LWKInUseirlr
         itvhfz+82MAQuwoliFWtiaSCfEx5lajl3wDph3arTlzrfbLCFxRXQy3F6B0gyZJur4VC
         kZDFPlY+Ppfal78BxuKE2JJDV5q4u9zufJhoTEzhw/89U1WFjdUC7pI4F/IlMY3dIUX0
         vuCwIreO2WOVVYRpKxKUSDCBuPu7ZBJ17ndKjabOqYiqmwQacMuV6jl1DrVQHCaH00KM
         meQg==
X-Forwarded-Encrypted: i=1; AJvYcCV3pIfI312fD5s5ZhSc5z0d09G1a4VHsLzru0Zjg9sxmNGLyofYQ7GpKAlCmtqbD2SXGKSLTGB/BYIFqzJL@vger.kernel.org
X-Gm-Message-State: AOJu0Yyrr2okYJeuHE9DNbFYv2dXIrLCoxaQ7ZeNOcVdyvV8MGaZVDmz
	EhBEZy6Q+jnR2qXAk4XP0namE23M3u0uwSTOImv6mr/2dtQ/5Zn6fcPiBHhS1UBCpk2GCmr3I+F
	bE6BQRiyZXHqzcvgntCXX2xaVBc/NpROF5BfYevaNI8KJNtaFIY4UWSRNaQ9GED+uovEpJ94OIs
	3XjQ==
X-Gm-Gg: ASbGnctWBxweguDbqYqol4HWaeXf+5cnctSeee3LF6NPWPRt44bOJJXTuSoD3AhKJ73
	COaBFKjyfC98F3BXSnzo2RYAtLC8nul2OGyk7q+YQu33brbb/HUYho0d3ND7/q6jdmgthyNM8uM
	0A+UmE/dDAyWpvgSa6JkE40VigswwshEfwgn4VbGPBXw08FEp6M9+Ppa+QQmxiZJezXokIYR0QM
	N9KrkvmDSH18ZSLpa/ZmZLDMW022LtG/8kO0jItqliGUVu7bMI1Pkzm72Hn8AbkPdMfPtHcbHEf
	EttMA+ZbmVAGDQXPsttDe/dZxRq1bD+PyurQ5K9NYtYFqEBIPeVMO/fwh/9rwY46l4HGX+xkCoy
	w6w==
X-Received: by 2002:a05:6214:cce:b0:6fa:fc96:d10a with SMTP id 6a1803df08f44-6fb3d2b2084mr12647796d6.27.1749752750974;
        Thu, 12 Jun 2025 11:25:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTwAq6WfDHaPemY/h8PwIsN4hrMc1IS/X6DYSMh/H/dDFvWv+mhNzkTWjGUfMDUerlSS/2iA==
X-Received: by 2002:a05:6214:cce:b0:6fa:fc96:d10a with SMTP id 6a1803df08f44-6fb3d2b2084mr12647466d6.27.1749752750553;
        Thu, 12 Jun 2025 11:25:50 -0700 (PDT)
Received: from [192.168.1.17] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fb35b3db9esm12870886d6.45.2025.06.12.11.25.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jun 2025 11:25:50 -0700 (PDT)
Message-ID: <1055be7c-1fba-4a75-8fd8-c79fc34f88f5@redhat.com>
Date: Thu, 12 Jun 2025 14:25:48 -0400
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
 <305c6d06-ae85-4595-ba05-9aa7b93739bd@redhat.com>
 <3nloqn2gjfn7rkaqsebb5wp4zikgwa7tfslvmv53bt4unuvu7d@p3q6qfskvhmo>
Content-Language: en-US
From: Joe Lawrence <joe.lawrence@redhat.com>
Autocrypt: addr=joe.lawrence@redhat.com; keydata=
 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
 pNzsRQ==
In-Reply-To: <3nloqn2gjfn7rkaqsebb5wp4zikgwa7tfslvmv53bt4unuvu7d@p3q6qfskvhmo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/11/25 7:12 PM, Josh Poimboeuf wrote:
> 
> Hm, revert_patch() already has a call to git_refresh(), so there doesn't
> appear to be any point to that extra refresh in revert_patches().
> 
> Does this fix?
> 
> diff --git a/scripts/livepatch/klp-build b/scripts/livepatch/klp-build
> index 7ec07c4079f7..e6dbac89ab03 100755
> --- a/scripts/livepatch/klp-build
> +++ b/scripts/livepatch/klp-build
> @@ -388,9 +388,6 @@ revert_patches() {
>  	done
>  
>  	APPLIED_PATCHES=()
> -
> -	# Make sure git actually sees the patches have been reverted.
> -	[[ -d "$SRC/.git" ]] && (cd "$SRC" && git update-index -q --refresh)
>  }
>  
>  validate_patches() {
> 

Ah yes, even better.

-- 
Joe


