Return-Path: <live-patching+bounces-427-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7760C945849
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 08:54:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 214FB1F241F0
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 06:54:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F08A4595D;
	Fri,  2 Aug 2024 06:54:02 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F617481AA;
	Fri,  2 Aug 2024 06:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722581642; cv=none; b=by01ut0GoPaXGHv6Hegki9hkseNcaRtacy/VoE36zE0qDXe7up9zPL5/o+w305GUJBvYeM410GAu/Jp5Xc8QSUP/RoAmMglk2CDEApVkpdRypgQhbzOz0SmAJuvakfW3Rcw75k8YrPqwvYwQNumZbFov5weJfKP2xWW6Ibs2p9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722581642; c=relaxed/simple;
	bh=qmsI4avS4y1dJQhRAG+h3KNcF8cMb4N/Ektrb5rnaEY=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=jtuiijIF3SOY1yjdzToGos7cxhmd3K7hN+zP01MlFrzaK4xXjgmdPC62Tm0imAAvI0Ly1aIjSh6/H+moCBDMqcSf4PuUaltanxZTnTHM0Mp386hZGaqnLykn3uzu2Ta4v5au4gXOWQFgRxcouHrL5WpteEh/Kjbd8rQfzkD0NTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WZxPd0KwPz4f3jjn;
	Fri,  2 Aug 2024 14:53:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C18311A058E;
	Fri,  2 Aug 2024 14:53:49 +0800 (CST)
Received: from [10.174.178.55] (unknown [10.174.178.55])
	by APP4 (Coremail) with SMTP id gCh0CgCXv4V7gqxm25YoAg--.65018S3;
	Fri, 02 Aug 2024 14:53:49 +0800 (CST)
Subject: Re: [PATCH 2/3] kallsyms: Add APIs to match symbol without
 .llmv.<hash> suffix.
To: Song Liu <songliubraving@meta.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Song Liu <song@kernel.org>,
 "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>, Nathan Chancellor
 <nathan@kernel.org>, "morbo@google.com" <morbo@google.com>,
 Justin Stitt <justinstitt@google.com>, Luis Chamberlain <mcgrof@kernel.org>,
 Leizhen <thunder.leizhen@huawei.com>, "kees@kernel.org" <kees@kernel.org>,
 Kernel Team <kernel-team@meta.com>, Matthew Maurer <mmaurer@google.com>,
 Sami Tolvanen <samitolvanen@google.com>, Steven Rostedt <rostedt@goodmis.org>
References: <20240730005433.3559731-1-song@kernel.org>
 <20240730005433.3559731-3-song@kernel.org>
 <20240730220304.558355ff215d0ee74b56a04b@kernel.org>
 <5E9D7211-5902-47D3-9F4D-8DEFD8365B57@fb.com>
 <9f6c6c81-c8d1-adaf-2570-7e40a10ee0b8@huaweicloud.com>
 <FE4F231A-5D24-4337-AE00-9B251733EC53@fb.com>
From: "Leizhen (ThunderTown)" <thunder.leizhen@huaweicloud.com>
Message-ID: <17533605-ec23-d806-2759-a054492384e4@huaweicloud.com>
Date: Fri, 2 Aug 2024 14:53:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <FE4F231A-5D24-4337-AE00-9B251733EC53@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXv4V7gqxm25YoAg--.65018S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGr4UCry5AFy8uryUJFykGrg_yoW5Jw1Upr
	WrKF42kayDJFWrAws7K3y8AFWakr4qqr1DX3s5Ka4DCF90qFyFvF4xKw1YkFyDWrs3Gr12
	vanrtF9IqF1UArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU92b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS
	07AlzVAYIcxG8wCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJV
	WUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
	6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x07jIksgUUUUU=
X-CM-SenderInfo: hwkx0vthuozvpl2kv046kxt4xhlfz01xgou0bp/



On 2024/8/2 11:45, Song Liu wrote:
> 
> 
>> On Aug 1, 2024, at 6:18 PM, Leizhen (ThunderTown) <thunder.leizhen@huaweicloud.com> wrote:
>>
>> On 2024/7/31 9:00, Song Liu wrote:
>>> Hi Masami, 
>>>
>>>> On Jul 30, 2024, at 6:03 AM, Masami Hiramatsu <mhiramat@kernel.org> wrote:
>>>>
>>>> On Mon, 29 Jul 2024 17:54:32 -0700
>>>> Song Liu <song@kernel.org> wrote:
>>>>
>>>>> With CONFIG_LTO_CLANG=y, the compiler may add suffix to function names
>>>>> to avoid duplication. This causes confusion with users of kallsyms.
>>>>> On one hand, users like livepatch are required to match the symbols
>>>>> exactly. On the other hand, users like kprobe would like to match to
>>>>> original function names.
>>>>>
>>>>> Solve this by splitting kallsyms APIs. Specifically, existing APIs now
>>>>> should match the symbols exactly. Add two APIs that matches the full
>>>>> symbol, or only the part without .llvm.suffix. Specifically, the following
>>>>> two APIs are added:
>>>>>
>>>>> 1. kallsyms_lookup_name_or_prefix()
>>>>> 2. kallsyms_on_each_match_symbol_or_prefix()
>>>>
>>>> Since this API only removes the suffix, "match prefix" is a bit confusing.
>>>> (this sounds like matching "foo" with "foo" and "foo_bar", but in reality,
>>>> it only matches "foo" and "foo.llvm.*")
>>>> What about the name below?
>>>>
>>>> kallsyms_lookup_name_without_suffix()
>>>> kallsyms_on_each_match_symbol_without_suffix()
>>>
>>> I am open to name suggestions. I named it as xx or prefix to highlight
>>> that these two APIs will try match full name first, and they only match
>>> the symbol without suffix when there is no full name match. 
>>>
>>> Maybe we can call them: 
>>> - kallsyms_lookup_name_or_without_suffix()
>>> - kallsyms_on_each_match_symbol_or_without_suffix()
>>>
>>> Again, I am open to any name selections here.
>>
>> Only static functions have suffixes. In my opinion, explicitly marking static
>> might be a little clearer.
>> kallsyms_lookup_static_name()
>> kallsyms_on_each_match_static_symbol()
> 
> While these names are shorter, I think they are more confusing. Not all
> folks know that only static functions can have suffixes. 
> 
> Maybe we should not hide the "try match full name first first" in the
> API, and let the users handle it. Then, we can safely call the new APIs
> *_without_suffix(), as Masami suggested. 

Yes, that would be clearer.

> 
> If there is no objections, I will send v2 based on this direction. 
> 
> Thanks,
> Song
> 

-- 
Regards,
  Zhen Lei


