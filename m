Return-Path: <live-patching+bounces-1434-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DD69AB6900
	for <lists+live-patching@lfdr.de>; Wed, 14 May 2025 12:38:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8D46B7A645A
	for <lists+live-patching@lfdr.de>; Wed, 14 May 2025 10:36:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2611270556;
	Wed, 14 May 2025 10:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="FSXoj7xB"
X-Original-To: live-patching@vger.kernel.org
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F16227BA2;
	Wed, 14 May 2025 10:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747219070; cv=none; b=RueSamcOHkv5MmVKKwQb+e1UNBGS6RocEkVSbYfxjq46lwpKs+CJH0QEEaTvSX9ee2E3iSGvfcwNZglb45wwTtlA4jijNlbtfqD/KGu0tOTHWav8y3C7rIXBSQBWgOVeLTCEC2IpfOeuuTh6e8vVoqfOAjS++axynxB8FzFL+2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747219070; c=relaxed/simple;
	bh=DyFXiTcMAkicdWTVDAKnT/4bbZdHgYHMQphd7Xj8oq4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bPvEoIz1gnKsLt/aZsIK/q8ReTCDPj1MuxbwAkHlEequPxr68zwwoxfEfMaCIMLkFfodLirh08sPupcHBNTS0dAJ2ym3qTgZ+cGXOVv0sJcBOzTMwUSz1uNOSjenSgOTHzAWwACa0UMYRV3eOrmWJFR9jBEdzsjLC9eEYUWMHOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=FSXoj7xB; arc=none smtp.client-ip=162.62.57.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1747218755;
	bh=7dNO5ovMYH1mWfxjDIePge4MNb8pZoHkoH4FCjpkoGM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FSXoj7xByPT3d6/Fz5Zoy7IH3KAZAeXALVWGXacOn8FUQN3yhQvfTME5QWogDFQDJ
	 Cq5GnGpb3R4ooTvO7JfncVFvPt0FxHPYpJusO7mhAGytVYgDQnD8aVCQjXh8Ks2QBa
	 EPLsrMcy5n8TNgqirHYXMexaaQcJpYhK8/Dm/U6k=
Received: from [IPV6:2408:822e:4b0:fb41:1d81:21ec:4709:dc61] ([2408:822e:4b0:fb41:1d81:21ec:4709:dc61])
	by newxmesmtplogicsvrszb20-0.qq.com (NewEsmtp) with SMTP
	id 8209080A; Wed, 14 May 2025 18:32:32 +0800
X-QQ-mid: xmsmtpt1747218752tcrmi01u7
Message-ID: <tencent_984AF5DAF2F307EA419A747031F0920C7C09@qq.com>
X-QQ-XMAILINFO: MtZ6QPwsmM9Xc4kQFqh/DnQ+d6a0cPXvuLpK4kC59gnGC4fa2b7/ItgsCafU4t
	 YJU0t3WjecYSE66bKOjpuTmMwV4cT2618krSETTAGOuKB2L5ESsiGHcE+r8CpQYaa5TvjXXxsYTN
	 CQ5QoX5c3NhLkVup5VvNJdqit/6LEZPlo/ZUyMrcOUm/um4EUgOqIWJiRq/ABH7RE4ZAmWTHZymq
	 laxOoRsVdh3Ci6GJ8L7FqvKjyyCNj6Lc+OP2As4OZs/SLXspriUlQ7tOpREJX9KrI4iERWsPR7Fr
	 BekXctBPq+zlIccbI/1GqWFhTM9B/BaebwkQeohFEgYNR+L/XOex7J1f2SeqGNOqbxGJTfQ3ZWab
	 /N71Ju4plBC3UjO9tFJzXH9ZAo9GWXsnHzYr+FM1qmne6a/OGzA9H+96KLsWz3WwOT3ESHD8CD/B
	 FNPSVUwGMbm/NgyTlbfN88RFloKEXGevemcWONln6qsPMB7e138Q0fSdBcvT0b0IQB8bk9tKOtcD
	 aglHVuC/2fWKJ+dj5o3vrVu71M0yOBgJ2s5KHQU2rz1vejgphKs7/0MY6L4FxyFFx3jp5l1fT4XQ
	 balvg0amN466HmB3TcRyezrHK3paqePrhvCgQEwMe7IArcqvkVI2VWykbK9tyb1ReChZ1PjMYRg1
	 j/ajjugBilYAE2jC3HZ4EwhFH+R153ujgknU6RSlKvpkU9X9fhZAOuiaVpf7XlLqlQ0R7br/pit0
	 h8Bht/49A7FTipRAm2cT923VLmZdFx8kmF4W4DJlIYe4+JHyRea5ACf8qK7daYqUEK+czItBPdV5
	 Bt6wyQsOeEoBWoEpD/qcx+zv5GRO98aX3eL3/q9BR9h6ciBWotlbLvR4hn3Y+VKS58GAr9VVA0PM
	 hObLGidqR/H+BWjWfe4XvaAE/gYbcagQVnVgKCtTzJpB7NvAhf2ARPHhm46ljqfvGSQI+7elA9Ng
	 cQld0tpVPjIXbxws9WKg==
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
X-OQ-MSGID: <cc1104ab-89df-40ad-b3f9-ff15f4012008@foxmail.com>
Date: Wed, 14 May 2025 18:32:32 +0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 52/62] objtool/klp: Introduce klp diff subcommand for
 diffing object files
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
 Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
 Joe Lawrence <joe.lawrence@redhat.com>, live-patching@vger.kernel.org,
 Song Liu <song@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Marcos Paulo de Souza <mpdesouza@suse.com>, Weinan Liu <wnliu@google.com>,
 Fazla Mehrab <a.mehrab@bytedance.com>,
 Chen Zhongjin <chenzhongjin@huawei.com>, Puranjay Mohan <puranjay@kernel.org>
References: <cover.1746821544.git.jpoimboe@kernel.org>
 <f6ffe58daf771670a6732fd0f741ca83b19ee253.1746821544.git.jpoimboe@kernel.org>
 <tencent_8AACB6DF7CFB7A9826455C093C0903B15207@qq.com>
 <c63auxjhv2lanvir4rryy3kp6qpni4q7p62ng6hnvoo4w4idvf@i4mx3asblvis>
Content-Language: en-US
From: laokz <laokz@foxmail.com>
In-Reply-To: <c63auxjhv2lanvir4rryy3kp6qpni4q7p62ng6hnvoo4w4idvf@i4mx3asblvis>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/2025 4:45 AM, Josh Poimboeuf wrote:
> On Tue, May 13, 2025 at 10:49:59PM +0800, laokz wrote:
>> On 5/10/2025 4:17 AM, Josh Poimboeuf wrote:
>>> +
>>> +#define sym_for_each_reloc(elf, sym, reloc)				\
>>> +	for (reloc = find_reloc_by_dest_range(elf, sym->sec,		\
>>> +					      sym->offset, sym->len);	\
>>> +	     reloc && reloc_offset(reloc) <  sym->offset + sym->len;	\
>>> +	     reloc = rsec_next_reloc(sym->sec->rsec, reloc))
>>
>> This macro intents to walk through ALL relocations for the 'sym'. It seems
>> we have the assumption that, there is at most one single relocation for the
>> same offset and find_reloc_by_dest_range only needs to do 'less than' offset
>> comparison:
>>
>> 	elf_hash_for_each_possible(reloc, reloc, hash,
>> 				   sec_offset_hash(rsec, o)) {
>> 		if (reloc->sec != rsec)
>> 			continue;
>> 		if (reloc_offset(reloc) >= offset &&
>> 		    reloc_offset(reloc) < offset + len) {
>> less than ==>		if (!r || reloc_offset(reloc) < reloc_offset(r))
>> 					r = reloc;
>>
>> Because if there were multiple relocations for the same offset, the returned
>> one would be the last one in section entry order(hash list has reverse order
>> against section order), then broken the intention.
> 
> Right.  Is that a problem?  I don't believe I've ever seen two
> relocations for the same offset.
> 

Thanks for the clarification. I asked this because I noticed the 
patchset have done some code refactoring, so guess if we could make it 
more general to other architectures which not support objtool yet. Such 
as RISC-V, it is not unusual having multiple relocs for same offset, 
like vmlinux.o might have:

000c 0000010a00000017 R_RISCV_PCREL_HI20 0000000000000000 .LANCHOR0 + 48
000c 0000000000000033 R_RISCV_RELAX                         48

0044 0000061700000023 R_RISCV_ADD32   0000000000000048 pe_head_start + 0
0044 000dd5b900000027 R_RISCV_SUB32   0000000000000002 _start + 0

But it is a bit off-topic:/

Regards,
laokz


