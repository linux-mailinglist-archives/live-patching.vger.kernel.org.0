Return-Path: <live-patching+bounces-934-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7481C9F6076
	for <lists+live-patching@lfdr.de>; Wed, 18 Dec 2024 09:49:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15BB416F297
	for <lists+live-patching@lfdr.de>; Wed, 18 Dec 2024 08:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 116391922C0;
	Wed, 18 Dec 2024 08:48:45 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07796158A09;
	Wed, 18 Dec 2024 08:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.17.235.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734511725; cv=none; b=OJ3GkQ4FRVXWf7ESPBuTO++CZn7pI+wr5OkP+QiMy/Otrt62YWDC6+rjtYGeVER1hCM750rqY/hdKgaB2SNka4X5k8yTjHg1Kq6Fsy5AfGAyh1F3pt08w5BzA325jdTdPnbco3ZvitTk3OHKH9wxdk7I0a1Nvd1RSpal5KaoUBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734511725; c=relaxed/simple;
	bh=Pouj6qimBJ53670s+sRVPDpsh7i7m5uISvYfGuRVIfA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W/QFVo488RY0n+ZI4GJF4jvSpAyucFbxd6beP9r+e359OyOb+CTAiVbNefk0Tho4w5geeAX+BYuXeEWzwt6wUNnVBEF1NApXEs+T6VOLjV2H8MiVKztCefx7d/UcW2JQr/Jb3i4ivd8iqEkyjS4gAWWJpgp+jobdtusPRXSf6pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu; spf=pass smtp.mailfrom=csgroup.eu; arc=none smtp.client-ip=93.17.235.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=csgroup.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csgroup.eu
Received: from localhost (mailhub3.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4YCnQY4M61z9sPd;
	Wed, 18 Dec 2024 09:48:37 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9LlyafyZwqKN; Wed, 18 Dec 2024 09:48:37 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4YCnQY3Tdhz9rvV;
	Wed, 18 Dec 2024 09:48:37 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 6273C8B770;
	Wed, 18 Dec 2024 09:48:37 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id DTdjbkc_KzTr; Wed, 18 Dec 2024 09:48:37 +0100 (CET)
Received: from [10.25.209.139] (unknown [10.25.209.139])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 3733D8B763;
	Wed, 18 Dec 2024 09:48:37 +0100 (CET)
Message-ID: <f54d34f8-05cd-4081-92a2-85df3f76a35b@csgroup.eu>
Date: Wed, 18 Dec 2024 09:48:36 +0100
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] livepatch: Convert timeouts to secs_to_jiffies()
To: Petr Mladek <pmladek@suse.com>,
 Easwar Hariharan <eahariha@linux.microsoft.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
 Joe Lawrence <joe.lawrence@redhat.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
References: <20241217231000.228677-1-eahariha@linux.microsoft.com>
 <20241217231000.228677-3-eahariha@linux.microsoft.com>
 <Z2KJ8C7nOOK2tJ1X@pathway.suse.cz>
Content-Language: fr-FR
From: Christophe Leroy <christophe.leroy@csgroup.eu>
In-Reply-To: <Z2KJ8C7nOOK2tJ1X@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



Le 18/12/2024 à 09:38, Petr Mladek a écrit :
> On Tue 2024-12-17 23:09:59, Easwar Hariharan wrote:
>> Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
>> secs_to_jiffies(). As the value here is a multiple of 1000, use
>> secs_to_jiffies() instead of msecs_to_jiffies to avoid the multiplication.
>>
>> This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
>> the following Coccinelle rules:
>>
>> @@ constant C; @@
>>
>> - msecs_to_jiffies(C * 1000)
>> + secs_to_jiffies(C)
>>
>> @@ constant C; @@
>>
>> - msecs_to_jiffies(C * MSEC_PER_SEC)
>> + secs_to_jiffies(C)
>>
>> While here, replace the schedule_delayed_work() call with a 0 timeout
>> with an immediate schedule_work() call.
>>
>> --- a/samples/livepatch/livepatch-callbacks-busymod.c
>> +++ b/samples/livepatch/livepatch-callbacks-busymod.c
>> @@ -44,8 +44,7 @@ static void busymod_work_func(struct work_struct *work)
>>   static int livepatch_callbacks_mod_init(void)
>>   {
>>   	pr_info("%s\n", __func__);
>> -	schedule_delayed_work(&work,
>> -		msecs_to_jiffies(1000 * 0));
>> +	schedule_work(&work);
> 
> Is it safe to use schedule_work() for struct delayed_work?

Should be, but you are right it should then be a standard work not a 
delayed work.

So probably the easiest is to keep

	schedule_delayed_work(&work, 0)

And eventually changing it to a not delayed work could be a follow-up patch.

> 
> It might work in theory but I do not feel comfortable with it.
> Also I would expect a compiler warning.

__queue_delayed_work() does :

	if (!delay) {
		__queue_work(cpu, wq, &dwork->work);
		return;
	}


> 
> If you really want to use schedule_work() then please
> also define the structure with DECLARE_WORK()
> and use cancel_work_sync() in livepatch_callbacks_mod_exit().
> 
> Best Regards,
> Petr


