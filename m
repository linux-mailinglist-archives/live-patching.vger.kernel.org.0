Return-Path: <live-patching+bounces-646-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E49C097470A
	for <lists+live-patching@lfdr.de>; Wed, 11 Sep 2024 01:59:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9C1A31F26B24
	for <lists+live-patching@lfdr.de>; Tue, 10 Sep 2024 23:59:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36FCE1AC437;
	Tue, 10 Sep 2024 23:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DINhkYsf"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0E851A7062;
	Tue, 10 Sep 2024 23:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726012411; cv=none; b=EKCGlS4RVDq2unkdenZ/YpHy84VN5WEqPqu7O+eFJiBgsM97PCg8Fq/bfsHnzu1+RN3uBny4RVjwz2Jc37aREeQ73DIFNMkeVeogMpwHoYTIExFSZdIognRaFvUVwE13MiUtWoubrinwE1Y0Am6Xt/I0XgHT7p6Bu5bBz+5oSvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726012411; c=relaxed/simple;
	bh=QBUPbzW5Ujw6G55VRiUeoU7BkiPTrZ8t6vx6VzGLmoE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OLfKAoA5hsEN5R1udAcqLu1e1+t5lUug/Um6SoYp9mrBxXt45NnyA0c056mERqsJ7uSP6mIUq4CDEo978EZQXkYeneh3KngvgWVKNBf0j0YfWFeuuhHtZPtcQIwFy7T2FNp8P3N7IHbiwfGmVS1SSjUI7YQUmpHGmD6Q2YBBgwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DINhkYsf; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2d8a54f1250so4033135a91.0;
        Tue, 10 Sep 2024 16:53:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726012409; x=1726617209; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ci3pK1EZN53j2koe7RgM9dHEDcCi2B70OXSAa1k1MsA=;
        b=DINhkYsfQufQM0jk5oCHSdX7ngSKYkst4XlLNkBLAdkD4sDxTtrOIOf5ZxD0RwIYew
         NxC+3TyKvyi2YprLlYrk4gX8sdAmY0qVrtDk5UmDEiqWPZLoNEylxdvsLRQzJCDtfjhJ
         8oEzm8r/rR5fcmq1kX40ZpoMTKoc/EdPDFhXGrq4YBgHdOZrJWVaYCLtZlyEi+orNIZz
         7Fjm/HzNoP1dkLp465Iub3qAKT7pTbdroSygVaaGnk615zPGIQJGjU03THhQbg1L5hJ0
         TlJtoUQpGgHQw92tND9w6IblJBRV7k7WEAoJsBKBPu//dgmKIQQ210RaWmrpL+ayxrQ8
         aGsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726012409; x=1726617209;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ci3pK1EZN53j2koe7RgM9dHEDcCi2B70OXSAa1k1MsA=;
        b=UY1xmDWY8/wj975IcUZWrr9WD3kuvktX4Pl/F7aTCIdXaUfvuChKn7sNWUYxjErqFn
         tjILjttfN2pUUCq02K8DnOceiXnDfUpla2J9AbUyzVz863v/ja2p35Mzu4bR1sh4u+wH
         y2sUG8zEq0CWjNmCW2AaaX7e36f002Tqzgwm+eUjSc5w6AdZFxY+sW8MffkSfyzIXB+z
         P5RM4WC33O/3QEPqMrm7drP7LN6Ug3LWpJzuoYHa1MO726dyW5zmRMdFrIn5c2TUMnC/
         Ru27popJcZMKu+jSSoPg1bM8UEKv2JRwoowcs8JzuiW+RgsPoJPpX10r6GPX0i2Fv38n
         VKMA==
X-Forwarded-Encrypted: i=1; AJvYcCWbyRTKTuXIGyoZZvQGuGBNCOG6s++L/B6RDfbNsO8Tgw1I7OXP9j6c+iI1ROszdTXlgzHsuqkC+yo=@vger.kernel.org, AJvYcCX0pVFLTxCOCF/KZ0buE7HZlha0Vd/2wYCHHzo294RRaHqPCocEaIMUAN1UQaEqd/26z0wmWdzuH9xYRMDw1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YxrhfTgrFPd7pAK4NToZLcqXjSiUHdxt4jJfEsXM53KC6wjIlkh
	Fm7KXdM87ePyIvN+XT3/1hJfAEyMo2pNrG95o/DalUJoGnzP3Bla
X-Google-Smtp-Source: AGHT+IHLdk3yW2rzj6Myza6eYvFTIJyl7/R6WiSmi8f2nxW0Px5jDXFR7AF9QAWLORdGmuPapoPENA==
X-Received: by 2002:a17:90a:bc9:b0:2d3:ba42:775c with SMTP id 98e67ed59e1d1-2dad4de1446mr19735939a91.1.1726012408905;
        Tue, 10 Sep 2024 16:53:28 -0700 (PDT)
Received: from [192.168.0.106] ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7d8242b3d13sm6268729a12.52.2024.09.10.16.53.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Sep 2024 16:53:28 -0700 (PDT)
Message-ID: <ea2988dd-966a-4ee2-b6d5-9eeceadead7e@gmail.com>
Date: Wed, 11 Sep 2024 06:53:22 +0700
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
 <cd1340e4-f726-4ac4-9caa-8e8a3c369203@gmail.com>
 <ZuAm-pgXO4SySyB5@pathway.suse.cz>
Content-Language: en-US
From: Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <ZuAm-pgXO4SySyB5@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 18:01, Petr Mladek wrote:
> On Tue 2024-09-10 17:27:42, Bagas Sanjaya wrote:
>> On 9/4/24 18:48, Petr Mladek wrote:
>>> On Tue 2024-09-03 09:47:53, Bagas Sanjaya wrote:
>>>> "get" doesn't properly fit as an antonym for "release" in the context
>>>> of locking. Correct it with "acquire".
>>>>
>>>> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
>>>
>>> Reviewed-by: Petr Mladek <pmladek@suse.com>
>>>
>>> The patch is trivial. I have have committed it into livepatching.git,
>>> branch for-6.12/trivial.
>>>
>>
>> Shouldn't this for 6.11 instead? I'm expecting that though...
> 
> I am sorry but the change is not urgent enough to be rushed into 6.11.
> 

OK, thanks!

-- 
An old man doll... just what I always wanted! - Clara

