Return-Path: <live-patching+bounces-643-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A6739734C4
	for <lists+live-patching@lfdr.de>; Tue, 10 Sep 2024 12:42:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D16C7B2D176
	for <lists+live-patching@lfdr.de>; Tue, 10 Sep 2024 10:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CE1F19005B;
	Tue, 10 Sep 2024 10:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BUTUbbqu"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A09B172BA8;
	Tue, 10 Sep 2024 10:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964072; cv=none; b=a0MwEwvfxwSwRLMd5Q3DwvURgtI+VRAAb4khgWlyM6nx1as7nhpIprmWhWdSTqVebroD3t0qwApucD1VUo4VhcVSvEVbm2wLE7FvXzguI1xlOBYZoRkbCPE7VTq6+7ACRTXItsZ5u7Co2lDxQyJ5/rXd+ntVM8NJTBi/j2GimfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964072; c=relaxed/simple;
	bh=PbymxaNYKWisICEPVN+Os7ZJit3MRfZQfFqNVukMdxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sp/6VEQtGaEpDUvDIBnkmFo9u5Fg2Vcfkytf5n0BnxpGWbjYQJoezey9LwHFQr6iC5j7p5zNG/5jpb+6KjXpbHNnbPPrK9zxR5xfH2la+bvg2W+aSLqOv8+hA1Ae4jxbrNLis3rg0/KPpvI/43Jce/WmCC4mGZDje4zFy9jlV4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BUTUbbqu; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2059204f448so44200735ad.0;
        Tue, 10 Sep 2024 03:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725964071; x=1726568871; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zIyR38y07x529tvCfbRZKMKVYOciOW8f0OoLScjnlLA=;
        b=BUTUbbqugpVz4SLf+jWKXxzHikZ+gK/nugYbUEF529QVUYvriGn2Wq4LoROv1+NVIO
         bUIWzLhiLV10NssyycnTbjplroXqn6AIk5sLJEQkq6hp1GsMDOWnrO8HN4KnyZ0VnImp
         YgOeLC2MHCwdnjYxoQi+A6WSDh3qEBfY2v925ZYfrAV/wsvU0oUDbPTC63YrsIhbXQGD
         o2lUZRVCID9HBOTnRclgPegT4CsQO1PwXPIgpYy2rWs9oQwUWLYqsfwsW1QiB2jnurUj
         sAnMG5R/2WM8VI/PxZzC/z793LGHwP3fNCh6pVGHuyGmXYeZD/CwNFL+vn/kpqpmp5JI
         EPAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725964071; x=1726568871;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zIyR38y07x529tvCfbRZKMKVYOciOW8f0OoLScjnlLA=;
        b=FeS9MFrUezQOZCnicB7pIegKL7WeU4rsSUpx5FQzU7O0sJd7Gh+bytK99CwY162cQ6
         +1yrbPMhTGQErdcsRhsOGZT5AErsUXrEKSaUdnngJ5OPxU0o5CesTnT3ic1rFmIx+hO7
         IuVLtM+XjnQ56fHtcqmwwTe0p8RRbsd+6POktDtndf6KKebabziJpuNTVEyzUKOYDG0l
         no5vdcImDTcWNSFPfBFguncJ6W3H0d+VAz/DmwfV87SNdaLrwqst9eFXWlp/9kmkPUeM
         8Vc124iOuflBr8exo12ePUWUIjNKXzW5LHk/FQr4CLpkCE6NRv/MZCwccSooBWuXZkaF
         aIEQ==
X-Forwarded-Encrypted: i=1; AJvYcCWS0DpyOGua9h7dShsbDmOVzD/aARYbZniF7JCmF5T9dy6J2h7mvgxZvHH02rUry2GsFuA/vlIXKFs=@vger.kernel.org, AJvYcCWVRfpGeqjKsa1hOW2Gw6sleW3qxth7gqWsKthFPaq2OM8re+lteEC5tFe/yEid0T3mTtqUf7QiAceG608MJw==@vger.kernel.org
X-Gm-Message-State: AOJu0YylVxgmFbZw+K9uChQ0wIs45PSe3aZoUs0F5S9ZeQ//WdEI7zfC
	eZ+rJp78EVl5fy5vXc2CfZOhACILr/OwJGfugRAzCl3FfOef57IW79FAQg==
X-Google-Smtp-Source: AGHT+IE0cOCoZz2a6Eq/RhwCR1w/LeizFbIS4+1ET66eUPsxYlSvO3gMXgqxdNfia9R4+ZvvCAQjfw==
X-Received: by 2002:a17:902:d586:b0:206:c5cf:9727 with SMTP id d9443c01a7336-2074c60a65cmr2875625ad.31.1725964070554;
        Tue, 10 Sep 2024 03:27:50 -0700 (PDT)
Received: from [192.168.0.106] ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2071ac25428sm40793195ad.306.2024.09.10.03.27.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 03:27:50 -0700 (PDT)
Message-ID: <cd1340e4-f726-4ac4-9caa-8e8a3c369203@gmail.com>
Date: Tue, 10 Sep 2024 17:27:42 +0700
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation: livepatch: Correct release locks antonym
To: Petr Mladek <pmladek@suse.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux Kernel Livepatching <live-patching@vger.kernel.org>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>,
 Jonathan Corbet <corbet@lwn.net>, Marcos Paulo de Souza <mpdesouza@suse.com>
References: <20240903024753.104609-1-bagasdotme@gmail.com>
 <ZthJEsogeqfVj8jg@pathway.suse.cz>
Content-Language: en-US
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <ZthJEsogeqfVj8jg@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/24 18:48, Petr Mladek wrote:
> On Tue 2024-09-03 09:47:53, Bagas Sanjaya wrote:
>> "get" doesn't properly fit as an antonym for "release" in the context
>> of locking. Correct it with "acquire".
>>
>> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
> 
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> 
> The patch is trivial. I have have committed it into livepatching.git,
> branch for-6.12/trivial.
> 

Shouldn't this for 6.11 instead? I'm expecting that though...

-- 
An old man doll... just what I always wanted! - Clara

