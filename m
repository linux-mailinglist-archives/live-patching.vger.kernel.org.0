Return-Path: <live-patching+bounces-1243-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AE33A4849E
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 17:20:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EF403A4414
	for <lists+live-patching@lfdr.de>; Thu, 27 Feb 2025 16:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0350C21A453;
	Thu, 27 Feb 2025 16:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ylct2VKx"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2FB81DE3BA
	for <live-patching@vger.kernel.org>; Thu, 27 Feb 2025 16:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740672766; cv=none; b=UOT7JrhG8e8YUnsAAN24QzMLFJC2/MW9eZdNj+kFM4LPhNcErOy88QuZP/hxSpInX8UmXhn1nn5ThQqFsS0fsyRr0UhKhMip+9UAGl52Tkzxra88Odvil278BX6Ec78klrmYNvTPc4wLG2hYzeFwxz/KvPhsnxbHUIfr5bZsPTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740672766; c=relaxed/simple;
	bh=1B0baukk8wkKOrWBLrryYto1XBCAZ5THIRI3bdA1or8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B2j5Bj9+KU2KVPnGkXia4mrys6rA7P5ckv55MLLt0J+rcctNYGL9wY/1smlTgBVK4FLusqx3Nr0AYJ9Go/kW247Y9x91env3O6rCk97zlEuv54qW3vIKotTQoYTPebf6JUxd+7+tKv0XqGS2pbGJW4sBPql6h0aZA+KLPl7cPFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ylct2VKx; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5dedae49c63so1935337a12.0
        for <live-patching@vger.kernel.org>; Thu, 27 Feb 2025 08:12:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1740672763; x=1741277563; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+URe4l4GJhqH8ce+Ye1sM1VEzjf+QaS7p2yiXPuh81o=;
        b=Ylct2VKxaWZZpvoVaOoS4MSuId6Ql8tcOV6o6eXWJgb+7ku67keuM9q80UjtGO+bx5
         XAT1AqFja0HUenIOPycNS2nhT27CKd0plfG8kHeytllvhk2prM9vJ705OD6ofi+nbDND
         gBRC8va4a2olvt1O1HHUrqcPjnjLT3+hxIN9G6O1TxduWyTsKrgYLsxIf21uxswGrLMV
         SuAKZ5F8s53OUgqvqF7jsznHPYE9iLC7KvRsAiGEoEyD9aEujkeS3//rjsDb2J+4+CTp
         mcd5UrBDw94pYMfRlR+j0iLClRr44iMPPSRTqT1X0Du1dHAh0EkndHtxaUNBJ1X2eUh2
         wxsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740672763; x=1741277563;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+URe4l4GJhqH8ce+Ye1sM1VEzjf+QaS7p2yiXPuh81o=;
        b=HHg3dVD/g7ij1izYPDbVULor0i0VLKeh4XaZk9JT4hzD/MuIUAP4+CmlbsTfP79qkO
         +VstLgk8dV7ZnFKw7qHqHmcaIk5+TsmqH9Ofu5glKaGo0Cd0sCCu7zlfxB2zeP7WVOlw
         0KHfb+QYX2CZufnrzChzbiQ6rCQYRC/zRcs4dqoE5a21/4Z2yysjuqbReFto7ODyKyK2
         KVDrXLm5PiGL0I4AKpC9kUwcjZ+Gd4vtQrUUMu092yKVMcxsjd/bPHtYhvjmcN0NkSwy
         zW0FmT44UU5s7R3UBloBvY/Lz3vH3MrSLf1tIv+f/tGReK5qnvIEE74RjkuezNHzHFeF
         4Dvw==
X-Forwarded-Encrypted: i=1; AJvYcCUb4sFxOWQYIxoRDsFG3EXeyMcoBCsBY+TR56a53m1Pak4T2SBJZPWKLefTjebHcIoFmVVQnPZSOl2Wte6V@vger.kernel.org
X-Gm-Message-State: AOJu0YwM+Znb22aOVtkup9gI+pLPCIaMyIxHIJpMQ2/rHUPri2UnHenK
	74iRhlASyRvUgjK7P+gTfyT8ODdSciE5X2WjN6LB6d4BCL9lest/FQFhjm3qTfE9BEDGjNcaLtS
	0pBI=
X-Gm-Gg: ASbGncsQkQ56nLCGxS15sSTuTgT7pzim/+7I5ON5dNyd+TGiG/+UWUaxT1uB+zcMq/M
	OQsEUCeU3DoSXx7cMPwcQagzUzVkvyywwy386Ki9VcKBhCLL7mDtl6/R/kfh74HZpm2o6qUNa8w
	0KlOddcjLoD1FaKnkvHj8qV2/CdgzJoUymsTMbfjD0Cd0gAe97+evPOEwuRnO6Xb8aph9znjrJ8
	4MdNqaoyJbZgH/OxXEjeYn5r/71BHTt/qeZsvda6PkGgW87hcJov8IvZ6F+bQiVZjZ16S4Ayjow
	/PFxAQso1EddCZLChyeKISj5kzEK99rTzgQAi13dsEWGl+rufD/SQ9Y1CUMnJ0lbPvtl
X-Google-Smtp-Source: AGHT+IE0fDWdYp4mhDV4izDKRhRUb/i7cABjqRBwrDib2YU3lQR3wBE+FeIurjA8jt4nIowndYjJ4A==
X-Received: by 2002:a17:907:d2a:b0:ab7:fc9a:28e1 with SMTP id a640c23a62f3a-abc0de5a487mr3052219166b.52.1740672763076;
        Thu, 27 Feb 2025 08:12:43 -0800 (PST)
Received: from [192.168.1.57] (93-41-52-155.ip80.fastwebnet.it. [93.41.52.155])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c0dd6ccsm146200766b.57.2025.02.27.08.12.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Feb 2025 08:12:42 -0800 (PST)
Message-ID: <e052eb20-09ff-4917-8841-95af889afd9e@suse.com>
Date: Thu, 27 Feb 2025 17:12:42 +0100
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: livepatch: move text out of code block
To: Jonathan Corbet <corbet@lwn.net>, live-patching@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
 joe.lawrence@redhat.com
References: <20250227150328.124438-1-vincenzo.mezzela@suse.com>
 <87bjunqtg8.fsf@trenco.lwn.net>
Content-Language: en-US
From: Vincenzo Mezzela <vincenzo.mezzela@suse.com>
In-Reply-To: <87bjunqtg8.fsf@trenco.lwn.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/25 4:48 PM, Jonathan Corbet wrote:
> Vincenzo MEZZELA <vincenzo.mezzela@suse.com> writes:
> 
>> Part of the documentation text is included in the readelf output code
>> block. Hence, split the code block and move the affected text outside.
>>
>> Signed-off-by: Vincenzo MEZZELA <vincenzo.mezzela@suse.com>
>> ---
>>   Documentation/livepatch/module-elf-format.rst | 17 ++++++++++++-----
>>   1 file changed, 12 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/livepatch/module-elf-format.rst b/Documentation/livepatch/module-elf-format.rst
>> index a03ed02ec57e..eadcff224335 100644
>> --- a/Documentation/livepatch/module-elf-format.rst
>> +++ b/Documentation/livepatch/module-elf-format.rst
>> @@ -217,16 +217,23 @@ livepatch relocation section refer to their respective symbols with their symbol
>>   indices, and the original symbol indices (and thus the symtab ordering) must be
>>   preserved in order for apply_relocate_add() to find the right symbol.
>>   
>> -For example, take this particular rela from a livepatch module:::
>> +For example, take this particular rela from a livepatch module:
>> +
>> +::
> 
> The right fix here is to just delete the extra ":"
> 
>>     Relocation section '.klp.rela.btrfs.text.btrfs_feature_attr_show' at offset 0x2ba0 contains 4 entries:
>>         Offset             Info             Type               Symbol's Value  Symbol's Name + Addend
>>     000000000000001f  0000005e00000002 R_X86_64_PC32          0000000000000000 .klp.sym.vmlinux.printk,0 - 4
>>   
>> -  This rela refers to the symbol '.klp.sym.vmlinux.printk,0', and the symbol index is encoded
>> -  in 'Info'. Here its symbol index is 0x5e, which is 94 in decimal, which refers to the
>> -  symbol index 94.
>> -  And in this patch module's corresponding symbol table, symbol index 94 refers to that very symbol:
>> +This rela refers to the symbol '.klp.sym.vmlinux.printk,0', and the symbol
>> +index is encoded in 'Info'. Here its symbol index is 0x5e, which is 94 in
>> +decimal, which refers to the symbol index 94.
>> +
>> +And in this patch module's corresponding symbol table, symbol index 94 refers
>> +to that very symbol:
>> +
>> +::
> 
> You can put that extra colon here rather than introducing a separate
> "::" line.
> 

Hi,

You are right. I'll send an updated version.


Thanks for the feedback,

Vincenzo

