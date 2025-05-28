Return-Path: <live-patching+bounces-1472-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE06AC6BFB
	for <lists+live-patching@lfdr.de>; Wed, 28 May 2025 16:41:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 660381887151
	for <lists+live-patching@lfdr.de>; Wed, 28 May 2025 14:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD852288CAF;
	Wed, 28 May 2025 14:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W3tI+cQB"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A33288CA8
	for <live-patching@vger.kernel.org>; Wed, 28 May 2025 14:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748443268; cv=none; b=mMY0GQUG0ynb8E2CyNhG3tQKLM3mnAvtJqB4QZfvIbi8oAY73v7GbevDiC5Q5d7YutjIoBkFcm28sRmIXW6zmpPt6Wnr74BY0863ZVdHzoqpFtWNb1gvDINg9KmDIciOHhUIZBXYcJdrG+TER6jD2WCIn1AJkdOEoZWLqGceOjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748443268; c=relaxed/simple;
	bh=Fm5mERkZ5mbb6HoXIl9RdvgtWoN6R79PF710VN5hP1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UZ6mFCjW7WFmvDDlb1BbmXA16o9iGXosejsSRSLlegFxMODA7ZzQsFcxIkRZpjvM8cu/jJDky2PvB3qp7Z1iHsZTpxBhpWFTVQp2lxiJ4kc7Q3DV+QvxeT2bcx0nxvLXqXMi9NlrCBthzdx3jaa78hNy/yZNo/umilM4+JORp0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W3tI+cQB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748443265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cKL8YRgpNYt5G4RoAQa5HP5khXCi0wFujxghLQX798Q=;
	b=W3tI+cQBxZxejE6I8RAgEKlxIPDbLK9kTgJ2HFRMheJaabt67Gn54j9PifnHc6TR4XiIMy
	kvpp9KWB/Qj3BSLPB0zlIVjooNSxYIaEIBWKjfCp2asEZan1TbbRPDvtmX/SEtcg8LaVGw
	XP17gtL1smOhCNIm5aUt/9RsGFvSj6s=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-t7Zk6TpsN3m7UdsV5XztUQ-1; Wed, 28 May 2025 10:40:58 -0400
X-MC-Unique: t7Zk6TpsN3m7UdsV5XztUQ-1
X-Mimecast-MFC-AGG-ID: t7Zk6TpsN3m7UdsV5XztUQ_1748443257
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7c5b9333642so499351985a.3
        for <live-patching@vger.kernel.org>; Wed, 28 May 2025 07:40:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748443257; x=1749048057;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cKL8YRgpNYt5G4RoAQa5HP5khXCi0wFujxghLQX798Q=;
        b=qYofu3FHO0am1z/JyH3M3EezXdilmGgBErpaJnPAdm6X0VQs0yxLwdUGFN3MCSraJc
         oxs2Kphqkcu5fSFR4fdC2Ok3phB3HAskgCZmZf2SYwUwgcJiequHda9vDjDd4ilGs981
         o3C27f2pFcqTIOhZ3rz5tQOizSazfPrBQcAkwvtZG2YE+aDfMuCHJu39lI6SzQUeoEAJ
         kBgaVSs2XmAC8Ddpfxbjq3Q4GdhviBy0kygq/ZaqYENG0MxCFwB2juGwqINn633AWcPn
         a3EMC+XbBgU3OE6jVgImhIkS4xq5E/rhZtdQ7yn5MeGJzy6eHVHAhni2qHSyw1BI4EAz
         meUg==
X-Forwarded-Encrypted: i=1; AJvYcCU1GaxOpQm7gHmMUGbB4yLOISfsA7WEggJLkLYCAX9MWvw4bCxSKc14MgcQS2ktbHvqbqMsXM2xPcbQAYvZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yxj48SIJ1m6EOXs1WoVNY4das5NkVNhAN2lm4WJaVxHaqNY1X8J
	h5asNyRUjYLsHoOqSl1e/5YbLXBZv7gjzlQfakmajPQ6gYv5kngh3rqmGjIP0eQa9N+nTGv6r7f
	Qlcr7cjxrJaPhM+qC3ftIYOyI0B5uJsQ/4xNaJ/EVZkXIdU/LxM2TeGOc9vkTc+aHOvQ=
X-Gm-Gg: ASbGncvz2Ox3e9zRzNXKT2vnMGm8iz0apgH2gg08z4qnrE7Yi4iwtJsndujr0LaHWq6
	uHXZ8xp9hRucZOYwZfkclf3R2QSaL6ncKvtxj5EXlVB9qH/yeSY3uC+1yktq3kGrbREb1IHuROh
	hSQXwllyHjDij9NMjsJEv4YFq51by/QrF4Bmz4R7hKgk3SCsFOZFOrkVWKh6hIqDuxd9BIHpRbC
	Q2Cv5gMmMnRmBsqbdRJxNikM3giz5ajALMaIB7iUSLH4j+68KIS8UueXzwV64Z5GeNBwKNd4HgT
	hV2Mr3ZYBVjA9QH7UJni2vbxiSRtFCjnLcqkVPIeUQ5wHUQ3pI2eaJhsg02Apyej7Uk=
X-Received: by 2002:a05:620a:470b:b0:7ca:cd71:2bea with SMTP id af79cd13be357-7ceecbe06abmr2836880685a.37.1748443257485;
        Wed, 28 May 2025 07:40:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4rSonxKZdNqsFk8pafzF6Bnr5HCcMsto+364S0zQ3gXfJGfRmrOenFL6UZ1DMmdjdyjz1fA==
X-Received: by 2002:a05:620a:470b:b0:7ca:cd71:2bea with SMTP id af79cd13be357-7ceecbe06abmr2836875585a.37.1748443257132;
        Wed, 28 May 2025 07:40:57 -0700 (PDT)
Received: from [192.168.1.17] (pool-68-160-160-85.bstnma.fios.verizon.net. [68.160.160.85])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cfb8212465sm77474585a.43.2025.05.28.07.40.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 May 2025 07:40:56 -0700 (PDT)
Message-ID: <d6940b24-d78f-4da5-a8fa-6a408528822f@redhat.com>
Date: Wed, 28 May 2025 10:40:55 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 45/62] x86/extable: Define ELF section entry size for
 exception tables
To: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>,
 Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
 Song Liu <song@kernel.org>, laokz <laokz@foxmail.com>,
 Jiri Kosina <jikos@kernel.org>, Marcos Paulo de Souza <mpdesouza@suse.com>,
 Weinan Liu <wnliu@google.com>, Fazla Mehrab <a.mehrab@bytedance.com>,
 Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <198cfbd12e54dfce1309828e146b90b1f7b200a5.1746821544.git.jpoimboe@kernel.org>
Content-Language: en-US
From: Joe Lawrence <joe.lawrence@redhat.com>
Autocrypt: addr=joe.lawrence@redhat.com; keydata=
 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
 pNzsRQ==
In-Reply-To: <198cfbd12e54dfce1309828e146b90b1f7b200a5.1746821544.git.jpoimboe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/9/25 4:17 PM, Josh Poimboeuf wrote:
> In preparation for the objtool klp diff subcommand, define the entry
> size for the __ex_table section in its ELF header.  This will allow
> tooling to extract individual entries.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---
>  arch/x86/include/asm/asm.h | 20 ++++++++++++--------
>  kernel/extable.c           |  2 ++
>  2 files changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
> index f963848024a5..62dff336f206 100644
> --- a/arch/x86/include/asm/asm.h
> +++ b/arch/x86/include/asm/asm.h
> @@ -138,15 +138,17 @@ static __always_inline __pure void *rip_rel_ptr(void *p)
>  
>  # include <asm/extable_fixup_types.h>
>  
> +#define EXTABLE_SIZE 12
>
> + > [ ... snip ... ]
>

EXTABLE_SIZE defined in arch/x86/ ...

> diff --git a/kernel/extable.c b/kernel/extable.c
> index 71f482581cab..0ae3ee2ef266 100644
> --- a/kernel/extable.c
> +++ b/kernel/extable.c
> @@ -55,6 +55,8 @@ const struct exception_table_entry *search_exception_tables(unsigned long addr)
>  {
>  	const struct exception_table_entry *e;
>  
> +	BUILD_BUG_ON(EXTABLE_SIZE != sizeof(struct exception_table_entry));
> +

but referenced in kernel/ where a non-x86 build like ppc64le build won't
know what EXTABLE_SIZE is :(

-- 
Joe


