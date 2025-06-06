Return-Path: <live-patching+bounces-1498-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58A1EAD0931
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 22:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9909E3B3E8A
	for <lists+live-patching@lfdr.de>; Fri,  6 Jun 2025 20:53:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84CC921420A;
	Fri,  6 Jun 2025 20:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UTRYq178"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2151EDA3C
	for <live-patching@vger.kernel.org>; Fri,  6 Jun 2025 20:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749243236; cv=none; b=d7yI+4sVQwVyXbXvjadKduRnofTN2CMZ6INnCWq7hjnQxOFPpF4JLK8P4RRrvPNY+NkyqIb1HA0crW9ypwizH7fGCWtqWaexfCN7epTyEaPhpssRu4Y349Kh4Ko4TdITnWXXEUT2utHCyNLgubxhuYK8PsdCilQoBpo4a76hsVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749243236; c=relaxed/simple;
	bh=Up+x6akCvEFqBXwDMLKnnBujp/GZxUmeGELAcWIXC+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JYs4eQ0nvblfL5DzYkW5CGp2bfZ/H8spCWsXiwZlFvqdJ1LuPYFoatezm6VEgA1viv1WlJuI3LZOQpCTBr6VM4CiV2Vg2O2tAjZW0N2+DD2uYyNuwuuBpNCSo+nop6EWRkaSG9BOXyjI4cHsi5deHUp7y8xlAOZVPwwbEe0KlYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UTRYq178; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749243233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=DM/wpsf5bNvV+zxr0+R2E64Ci7rD4gOu6WoUfimCvys=;
	b=UTRYq178zx7MYyLY8KVfO+vChTNFBc8s3WMbHudpZwsrQp+wHMyevB4W3dxTHEmOl/j7h6
	Fc21kdXB3VqCZ4jrvEEWv72Oj5Ku278YuSXLHnaGawBvzDwUtinxRpIMGBKvDH6eY4b98T
	rqPwVHcITRmTmDgpMLUMPrdUx1H+/Rs=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-9BH5PuVlOAau6xZC_sjUkw-1; Fri, 06 Jun 2025 16:53:52 -0400
X-MC-Unique: 9BH5PuVlOAau6xZC_sjUkw-1
X-Mimecast-MFC-AGG-ID: 9BH5PuVlOAau6xZC_sjUkw_1749243232
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4a43f155708so43328701cf.2
        for <live-patching@vger.kernel.org>; Fri, 06 Jun 2025 13:53:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749243232; x=1749848032;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DM/wpsf5bNvV+zxr0+R2E64Ci7rD4gOu6WoUfimCvys=;
        b=DGNAyJ6IAGBevrRaiuXrpkrcFWi0UIJbA7Cu8R6UDU4aHmHALI5bLO3DQQZWDpEeNi
         JbD/YxOuViTikGEAPuOOuxB0FSZ7WXoq7LNPwx16pq+cdJSM5Y87ew6ivh2iIwzGxZcP
         mBhI4Hzy3z6tu7QMHrhPKlHuahm/SjQiKzp0eR9mMhftVkUyMJEhMWwyYJEo/jBdK35p
         xwU/U2jGCLjSDi4XbYkTh3vLJlD+HWvgTQNKsnt/tbySZOMj7VvbrczTRfWlG0FFAGwo
         a7gqUOZM1XEH180gLDIMSCP9TOYQZ8s+QO0fopqmxpb/MGfX7d7kPAcVyT/oHs+7iwrU
         dcLA==
X-Forwarded-Encrypted: i=1; AJvYcCWkQehnvRn3EwbA494b2OvbmLDqyIRQuKqUgWp6+Yd4LucgR1zmmqf7feiBT3euJvqz7xaobctKAjCn6MvI@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7p7F6BEHvq3W46tZzKF7qeIOfTFLWztS2033w0oK4vx5h2j3f
	N9rGQ74Zjqyhq3iI+raKel0TtrnJHVjbqn++qnReM+Dik+1d02YqUja9FXjcoLcIpeJvEfhQtLg
	Tp/XaVTI8YeIoYpmArvITZvfD8g/wkk71dZD2kbC77QN+8UxIohL0rCfxufKB5wYeZgA=
X-Gm-Gg: ASbGncsjkbc79hUbDrOIy3w2M2e3JAQ50b0ztyZlhfbPLl6U5n9afyYtZOhXo5LomT/
	Vjlz+XrCLGa1qwTTeKgRSbqLrCHI5Z2HPcFsyD3kG0GKj59E3PwGvgTivHg/3GGYcBd/vo6+tuv
	5DAmSBb1k+3Jx1Ss52qDcTJ1g47AnQ34Msi8l++bofxv1UzSWrSGBEbVMbxuIvu616Of0vY01YV
	0JPGqweK3hh4beAy1k4060nZVYs4euslYusQiukzGsoFfHwkJa/RSXNCT5KNvgE5WUipbqO/rQJ
	H8rX/iFzn+OB/3Y4jEwD/10+FXNh7XqjgovCeUAk09ERvaRg/mEimI3gIjj/YiBZA3Y=
X-Received: by 2002:a05:622a:5c16:b0:494:a2b8:88f0 with SMTP id d75a77b69052e-4a5b9d7a923mr91424611cf.33.1749243232174;
        Fri, 06 Jun 2025 13:53:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjXguAZBo6H2ys4WrzMebLkgCjFXMlP6rUGT+92Ehao/6lv02yGuSQ85yrFcvgoHrqYMiDSg==
X-Received: by 2002:a05:622a:5c16:b0:494:a2b8:88f0 with SMTP id d75a77b69052e-4a5b9d7a923mr91424221cf.33.1749243231829;
        Fri, 06 Jun 2025 13:53:51 -0700 (PDT)
Received: from [192.168.1.17] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4a61986509bsm18419281cf.58.2025.06.06.13.53.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 13:53:50 -0700 (PDT)
Message-ID: <fc7afc33-0167-4e4d-b5f6-433f18457084@redhat.com>
Date: Fri, 6 Jun 2025 16:53:48 -0400
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
 <f97a2e18-d672-41b1-ac26-4d1201528ed7@redhat.com>
 <27bkpjpv4lklcxafb4yifrbdjmfxn2sh67lckom2w7hpmgdyxr@zgty22rlp62q>
 <fo7d53hseij2pes7fml5hf2gnmfbuzlr7glpbc7wij2sgctuxx@mpr223nazmgg>
Content-Language: en-US
From: Joe Lawrence <joe.lawrence@redhat.com>
Autocrypt: addr=joe.lawrence@redhat.com; keydata=
 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
 pNzsRQ==
In-Reply-To: <fo7d53hseij2pes7fml5hf2gnmfbuzlr7glpbc7wij2sgctuxx@mpr223nazmgg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/25 4:28 PM, Josh Poimboeuf wrote:
> On Fri, Jun 06, 2025 at 12:03:45PM -0700, Josh Poimboeuf wrote:
>> On Fri, Jun 06, 2025 at 09:05:59AM -0400, Joe Lawrence wrote:
>>> Should the .cmd file copy come from the reference SRC and not original
>>> ORIG directory?
>>>
>>>   cmd_file="$SRC/$(dirname "$rel_file")/.$(basename "$rel_file").cmd"
>>>
>>> because I don't see any .cmd files in klp-tmp/orig/
>>>
>>> FWIW, I only noticed this after backporting the series to
>>> centos-stream-10.  There, I got this build error:
>>>
>>>   Building original kernel
>>>   Copying original object files
>>>   Fixing patches
>>>   Building patched kernel
>>>   Copying patched object files
>>>   Diffing objects
>>>   vmlinux.o: changed function: cmdline_proc_show
>>>   Building patch module: livepatch-test.ko
>>>   <...>/klp-tmp/kmod/.vmlinux.o.cmd: No such file or directory
>>>   make[2]: *** [scripts/Makefile.modpost:145:
>>> <...>/klp-tmp/kmod/Module.symvers] Error 1
>>>  make[1]: *** [<...>/Makefile:1936: modpost] Error 2
>>>  make: *** [Makefile:236: __sub-make] Error 2
>>>
>>> The above edit worked for both your upstream branch and my downstream
>>> backport.
>>
>> Hm, I broke this in one of my refactorings before posting.
>>
>> Is this with CONFIG_MODVERSIONS?
>>
>> If you get a chance to test, here's a fix (currently untested):
> 
> It was indeed CONFIG_MODVERSIONS.  I verified the fix works.
> 
> All the latest fixes are in my klp-build branch:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git klp-build
> 
> I hope to post v3 next week and then start looking at merging patches --
> if not all of them, then at least the first ~40 dependency patches which
> are mostly standalone improvements.
> 

Ack, I tested this update with CONFIG_MODVERSIONS for both vmlinux and
module cases with success :)

-- 
Joe


