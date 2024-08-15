Return-Path: <live-patching+bounces-501-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BDF1E95382B
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 18:25:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3B903B20E48
	for <lists+live-patching@lfdr.de>; Thu, 15 Aug 2024 16:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FC641AD401;
	Thu, 15 Aug 2024 16:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P7DM8izQ"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9835837703
	for <live-patching@vger.kernel.org>; Thu, 15 Aug 2024 16:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723739098; cv=none; b=DgGnOURcT8cYGFeYbVnz8bZQg0/5NCU4NX5ztd+d3TXe3wTuCqNT6irUk4hI97d8RweFlQxjgTHv+LEu4QqLcU+E9OnDmojsV0jJ4QdHPqL80/gEN5YiD/+D3snU3LNyXUgVM3XdcdrMxVROQJF00FYGN7uXlJAgnC63IAlbSp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723739098; c=relaxed/simple;
	bh=8hBL/iVNXq51gb2t0KtmOvDljI8agPAvuiF6YXDoqQ8=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
	 In-Reply-To:Content-Type; b=ShZjbgErUp/STkrOmyFtuK/oGKdp6vhME5gn1tWIk2OY8eKs2YJ3a3Fkh4QJVHLbiJDDi5POeer+D/WcoJbktHBIPOFt8vtJAmov7B+zAIpXFwne9LpvOtuKGYljbMgtR2Q+JXTBh3LWpDaQNiklVazAxvJ2HW26KgjZO7yxz3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P7DM8izQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723739095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G5gZYokzgkCL4xQW4GJraQSqmDBgypT9DDRopqeH444=;
	b=P7DM8izQeaIkf7TB2XHfRBSqDI0Ki4C9vh4OebcOZc5m/uGcfvyABR/rXToPHbjw+iv+wd
	ZD4SxrO4LupaWQC0Lz+i3BDq53AWJc7+/+gCW6sSiCSHavEeSMxgWb4F7E2Dlxykee+rc8
	l8CZ/sAbgqDK2H4jDVcMc7HRbvjUlG8=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-298--u8u_gAeNV-pIuF_y9Ntig-1; Thu, 15 Aug 2024 12:24:50 -0400
X-MC-Unique: -u8u_gAeNV-pIuF_y9Ntig-1
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-5d62453aeddso978034eaf.2
        for <live-patching@vger.kernel.org>; Thu, 15 Aug 2024 09:24:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723739090; x=1724343890;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G5gZYokzgkCL4xQW4GJraQSqmDBgypT9DDRopqeH444=;
        b=hu174LCzX5NO6phMeqGz6nyq25kr5+NvoMHd1Xxluhe9hC0pJ6Gn+FctmTBrSm48U/
         66SA42Z5HAtgYSStYsLEfl7QMJ0FAAAbtyohjwUTc+uuhUUhu4mylGvZIcYRBlGBb36h
         KxzgbQrsSrKBVb4RDkj7RVHZ0v3CpPqaWG7BWHzApr23MsAnvOfH++Na+qKsEkTZW2gz
         WBNWeV/97DgEJvTNJBWNXd+1A+x3ihhKXFuMBSAPpdAE/HUsGxdE9rV3jPWpPH1ZXCjX
         0yJfgxrDWM1bG+Lx2WYUAgGJm4UxpV582UjfrcEvlhO/Yy7n/bNTrlg8CbgZvOCmXw1a
         GP1Q==
X-Forwarded-Encrypted: i=1; AJvYcCXmKVyq3KlfSs//lKZq7inbT2DF34B4dae2L/15jatK9SwN5dKEXGNz0ZByn2jWGZl0U4XeANdkqzVCQ5iaVpjQ/4J3TrcJLJl6yTFCZg==
X-Gm-Message-State: AOJu0Yw9cXJmgeAei3BfaxFFYT1gqvB+wZP0fbLeBVjDC8FK5Lx/2Bsd
	pdE0tzeG4jDfWRnoCKYHsYs/Al63VETZR9TdsEqaz9yYT4Kl7k9tegkBDKfii45zYx0LF1BJL2n
	2JUl1F8qWJhvQTDgLxeCp+sRMIbdrsp0hFKqDF/d7YGzSZDjJRS2N15HK3MVA6EQ=
X-Received: by 2002:a05:6358:478e:b0:1ac:ef2e:5316 with SMTP id e5c5f4694b2df-1b393312da8mr41348755d.26.1723739089825;
        Thu, 15 Aug 2024 09:24:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEhKEdpbUHkvG8Pr8ui0Xr7jkKYyc52uKUNdYvCcErevOSvpeAWflh+MfknPQLEAegEmwlNRg==
X-Received: by 2002:a05:6358:478e:b0:1ac:ef2e:5316 with SMTP id e5c5f4694b2df-1b393312da8mr41345555d.26.1723739089410;
        Thu, 15 Aug 2024 09:24:49 -0700 (PDT)
Received: from [192.168.1.9] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4ff0e5b09sm76027885a.73.2024.08.15.09.24.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 09:24:48 -0700 (PDT)
Message-ID: <9ec85e72-85dd-e9bc-6531-996413014629@redhat.com>
Date: Thu, 15 Aug 2024 12:24:47 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Ryan Sullivan <rysulliv@redhat.com>, live-patching@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org
Cc: pmladek@suse.com, mbenes@suse.cz, jikos@kernel.org, jpoimboe@kernel.org,
 naveen.n.rao@linux.ibm.com, christophe.leroy@csgroup.eu, mpe@ellerman.id.au,
 npiggin@gmail.com
References: <87ed6q13xk.fsf@mail.lhotse>
 <20240815160712.4689-1-rysulliv@redhat.com>
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH] powerpc/ftrace: restore r2 to caller's stack on livepatch
 sibling call
In-Reply-To: <20240815160712.4689-1-rysulliv@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/24 12:07, Ryan Sullivan wrote:
> Hi Michael,
> 
> The r2 value is stored to the livepatch stack prior to entering into 
> the livepatched code, so accessing it will gurantee the previous value
> is restored.
> 
> Also, yes, this bug is caused by tooling that "scoops out" pre-compiled
> code and places it into the livepatch handler (e.g. kpatch). However, 
> since the large majority of customers interact with the livepatch 
> subsystem through tooling, and this fix would not pose any serious risk
> to either usability or security (other than those already present in 
> livepatching), plus it would solve a large problem for these tools with
> a simple fix, I feel as though this would be a useful update to 
> livepatch.
> 

Right, for kpatch-build binary-diff livepatch creation, the tooling
scans modified code for a sibling call pattern and errors out with a
report to the user:

https://github.com/dynup/kpatch/blob/master/kpatch-build/create-diff-object.c#L3886

and we advise users to manually turn sibling calls off as needed:

https://github.com/dynup/kpatch/blob/master/doc/patch-author-guide.md#sibling-calls

If I understand Ryan's patch, it would remove this restriction from
kpatch creation -- assuming that it is safe and sane for the kernel's
ftrace handler to do so.

-- 
Joe


