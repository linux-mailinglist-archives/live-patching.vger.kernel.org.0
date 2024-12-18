Return-Path: <live-patching+bounces-935-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 981109F6C62
	for <lists+live-patching@lfdr.de>; Wed, 18 Dec 2024 18:35:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9FF3A7A2FD9
	for <lists+live-patching@lfdr.de>; Wed, 18 Dec 2024 17:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A4361F9EA4;
	Wed, 18 Dec 2024 17:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="BDpx71TF"
X-Original-To: live-patching@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20972153BF7;
	Wed, 18 Dec 2024 17:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734543348; cv=none; b=IZLEoUwF58co5N8eHcHoNEJKwhWXFOrvvFlkGwrQ+APWEZJsGIGOIdvlaFKohqUGAQAzUc4AZycFvGi6vP6Ozaf8hNSPcyjjbuFLpLf2EC2RC9bL6ZevpBYNNwxV5KhrZfxJEigioRea9ZeKqOmeZq2UlgBkkVyJjfXViWhvKYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734543348; c=relaxed/simple;
	bh=G0f3CRK4OGezAKhdYo1icwfLcgJFxcR4S8qBiRtil7o=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eGRC591iNoOfEumZz2O5JBUhXoFJgZ20l0d+Fj+4+MApx9DxhKQG1KJqFWHEHKnxjtsmztVu4GPKLJbjEJfk8Bkwsus5SZLh/8BWvR5MG+rGWEgb+7Uo5Ff/UnXU/e8OHl+uku8BJrI6dmJFcLSrwb8wgGdMdkxmLb6EtiT7hvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=BDpx71TF; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [100.65.66.26] (unknown [20.236.11.29])
	by linux.microsoft.com (Postfix) with ESMTPSA id 51685203FC76;
	Wed, 18 Dec 2024 09:35:45 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 51685203FC76
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1734543345;
	bh=kcOrnKDEjBPRMmid+r2VdwuzstviJhoWxPMriTuDVOU=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=BDpx71TFNqkfcoNFP9tlXMkEiZlcyLmnkjtLEmJ+MhBnajYtSKlI+1b5mxS3pw8EJ
	 A4YzRcA8T0PZv5Xeu/cKB94FN+j3kIY8U2C390+PsU7YtHcaqdc2DJzKYxHWBHMwtQ
	 kCNhMQQRza+rJBAliOTmk2objRZIiGlmr+PlV2C8=
Message-ID: <195abda2-8209-45aa-9652-f981a5de2eae@linux.microsoft.com>
Date: Wed, 18 Dec 2024 09:35:46 -0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: eahariha@linux.microsoft.com, Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
 Joe Lawrence <joe.lawrence@redhat.com>, linux-s390@vger.kernel.org,
 linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v4 2/2] livepatch: Convert timeouts to secs_to_jiffies()
To: Christophe Leroy <christophe.leroy@csgroup.eu>,
 Petr Mladek <pmladek@suse.com>, Andrew Morton <akpm@linux-foundation.org>
References: <20241217231000.228677-1-eahariha@linux.microsoft.com>
 <20241217231000.228677-3-eahariha@linux.microsoft.com>
 <Z2KJ8C7nOOK2tJ1X@pathway.suse.cz>
 <f54d34f8-05cd-4081-92a2-85df3f76a35b@csgroup.eu>
From: Easwar Hariharan <eahariha@linux.microsoft.com>
Content-Language: en-US
In-Reply-To: <f54d34f8-05cd-4081-92a2-85df3f76a35b@csgroup.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 12/18/2024 12:48 AM, Christophe Leroy wrote:
> 
> 
> Le 18/12/2024 à 09:38, Petr Mladek a écrit :
>> On Tue 2024-12-17 23:09:59, Easwar Hariharan wrote:
>>> Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
>>> secs_to_jiffies(). As the value here is a multiple of 1000, use
>>> secs_to_jiffies() instead of msecs_to_jiffies to avoid the
>>> multiplication.
>>>
>>> This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci
>>> with
>>> the following Coccinelle rules:
>>>
>>> @@ constant C; @@
>>>
>>> - msecs_to_jiffies(C * 1000)
>>> + secs_to_jiffies(C)
>>>
>>> @@ constant C; @@
>>>
>>> - msecs_to_jiffies(C * MSEC_PER_SEC)
>>> + secs_to_jiffies(C)
>>>
>>> While here, replace the schedule_delayed_work() call with a 0 timeout
>>> with an immediate schedule_work() call.
>>>
>>> --- a/samples/livepatch/livepatch-callbacks-busymod.c
>>> +++ b/samples/livepatch/livepatch-callbacks-busymod.c
>>> @@ -44,8 +44,7 @@ static void busymod_work_func(struct work_struct
>>> *work)
>>>   static int livepatch_callbacks_mod_init(void)
>>>   {
>>>       pr_info("%s\n", __func__);
>>> -    schedule_delayed_work(&work,
>>> -        msecs_to_jiffies(1000 * 0));
>>> +    schedule_work(&work);
>>
>> Is it safe to use schedule_work() for struct delayed_work?
> 
> Should be, but you are right it should then be a standard work not a
> delayed work.
> 
> So probably the easiest is to keep
> 
>     schedule_delayed_work(&work, 0)
> 
> And eventually changing it to a not delayed work could be a follow-up
> patch.
> 
>>

Thanks for the catch, Petr! This suggestion would effectively revert
this patch to the v3 version, albeit with some extra explanation in the
commit message. I'd propose just keeping the v3 in the next branch where
it is.

Andrew, Petr, Christophe, what do you think?



