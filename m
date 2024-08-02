Return-Path: <live-patching+bounces-425-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB23E9455E9
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 03:18:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21F221C21896
	for <lists+live-patching@lfdr.de>; Fri,  2 Aug 2024 01:18:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C182BA47;
	Fri,  2 Aug 2024 01:18:48 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F5D2595;
	Fri,  2 Aug 2024 01:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722561528; cv=none; b=E5fXw2jLm82E9/3/pr8fDfQ7SNdrSFpzVAGkLYo7bf8tJvcD0Cg/bcHtlcWO4/8STu5Jx+SM74dc/atS4Lg3l+92mhse6iIW0CQCLVxSuytEcB4BnbC4OVSQUPStaGKFsHeFOogPCuLm/opSO9yFbtUNhamSjwBP6q3kYCYze3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722561528; c=relaxed/simple;
	bh=kK79Z0IWKmAhQGWjJXUlj6idoSSo7dm+zG6M8zr2fYw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=roog2kBKnTfSNfL/uRe8lLhpPID7i8uBHgCdwdNeMXi2X9+zbKgxxBdQ9e15gTokhmLtavO28gNU/Uz6+D0mZhJmlbNh1RlrUowMQSiTq/GxUkHXqEHl6mvi8nMPjOGhzg/4FynXK7L0fVlAr8VNogrktnhk4j2jfMCrxqUzfG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WZnyw6xVBz4f3jjk;
	Fri,  2 Aug 2024 09:18:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B15E21A0568;
	Fri,  2 Aug 2024 09:18:41 +0800 (CST)
Received: from [10.174.178.55] (unknown [10.174.178.55])
	by APP4 (Coremail) with SMTP id gCh0CgB37ILvM6xmro8SAg--.53496S3;
	Fri, 02 Aug 2024 09:18:41 +0800 (CST)
Subject: Re: [PATCH 2/3] kallsyms: Add APIs to match symbol without
 .llmv.<hash> suffix.
To: Song Liu <songliubraving@meta.com>, Masami Hiramatsu <mhiramat@kernel.org>
Cc: Song Liu <song@kernel.org>,
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
From: "Leizhen (ThunderTown)" <thunder.leizhen@huaweicloud.com>
Message-ID: <9f6c6c81-c8d1-adaf-2570-7e40a10ee0b8@huaweicloud.com>
Date: Fri, 2 Aug 2024 09:18:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <5E9D7211-5902-47D3-9F4D-8DEFD8365B57@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB37ILvM6xmro8SAg--.53496S3
X-Coremail-Antispam: 1UD129KBjvJXoWxArWUGr1fZw17tr1rJr4UCFg_yoW5Ww4fpF
	yrKF4qyrWDJFWrCw1Ik3yrAFWSkr4Dtr45Jrn5KF9ruas8XFySvF4xKF4Ykr98Jr4vyw12
	vayDAr9rt3WUArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Ib4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJb
	IYCTnIWIevJa73UjIFyTuYvjxUIa0PDUUUU
X-CM-SenderInfo: hwkx0vthuozvpl2kv046kxt4xhlfz01xgou0bp/



On 2024/7/31 9:00, Song Liu wrote:
> Hi Masami, 
> 
>> On Jul 30, 2024, at 6:03 AM, Masami Hiramatsu <mhiramat@kernel.org> wrote:
>>
>> On Mon, 29 Jul 2024 17:54:32 -0700
>> Song Liu <song@kernel.org> wrote:
>>
>>> With CONFIG_LTO_CLANG=y, the compiler may add suffix to function names
>>> to avoid duplication. This causes confusion with users of kallsyms.
>>> On one hand, users like livepatch are required to match the symbols
>>> exactly. On the other hand, users like kprobe would like to match to
>>> original function names.
>>>
>>> Solve this by splitting kallsyms APIs. Specifically, existing APIs now
>>> should match the symbols exactly. Add two APIs that matches the full
>>> symbol, or only the part without .llvm.suffix. Specifically, the following
>>> two APIs are added:
>>>
>>> 1. kallsyms_lookup_name_or_prefix()
>>> 2. kallsyms_on_each_match_symbol_or_prefix()
>>
>> Since this API only removes the suffix, "match prefix" is a bit confusing.
>> (this sounds like matching "foo" with "foo" and "foo_bar", but in reality,
>> it only matches "foo" and "foo.llvm.*")
>> What about the name below?
>>
>> kallsyms_lookup_name_without_suffix()
>> kallsyms_on_each_match_symbol_without_suffix()
> 
> I am open to name suggestions. I named it as xx or prefix to highlight
> that these two APIs will try match full name first, and they only match
> the symbol without suffix when there is no full name match. 
> 
> Maybe we can call them: 
> - kallsyms_lookup_name_or_without_suffix()
> - kallsyms_on_each_match_symbol_or_without_suffix()
> 
> Again, I am open to any name selections here. 

Only static functions have suffixes. In my opinion, explicitly marking static
might be a little clearer.
kallsyms_lookup_static_name()
kallsyms_on_each_match_static_symbol()

> 
>>
>>>
>>> These APIs will be used by kprobe.
>>
>> No other user need this?
> 
> AFACIT, kprobe is the only use case here. Sami, please correct 
> me if I missed any users. 
> 
> 
> More thoughts on this: 
> 
> I actually hope we don't need these two new APIs, as they are 
> confusing. Modern compilers can do many things to the code 
> (inlining, etc.). So when we are tracing a function, we are not 
> really tracing "function in the source code". Instead, we are 
> tracing "function in the binary". If a function is inlined, it 
> will not show up in the binary. If a function is _partially_ 
> inlined (inlined by some callers, but not by others), it will 
> show up in the binary, but we won't be tracing it as it appears
> in the source code. Therefore, tracing functions by their names 
> in the source code only works under certain assumptions. And 
> these assumptions may not hold with modern compilers. Ideally, 
> I think we cannot promise the user can use name "ping_table" to
> trace function "ping_table.llvm.15394922576589127018"
> 
> Does this make sense?
> 
> Thanks,
> Song
> 
> 
> [...]
> 

-- 
Regards,
  Zhen Lei


