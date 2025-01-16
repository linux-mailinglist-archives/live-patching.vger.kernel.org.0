Return-Path: <live-patching+bounces-1004-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F07F7A13C0D
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2025 15:22:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 37289188B7D0
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2025 14:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1E322B5A1;
	Thu, 16 Jan 2025 14:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="R2NkJqnD"
X-Original-To: live-patching@vger.kernel.org
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 695611F37CE
	for <live-patching@vger.kernel.org>; Thu, 16 Jan 2025 14:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737037341; cv=none; b=i+nl+J9jqNpDzokU1YkGtmegOR0cv6svwaypApqftZ1uiVn2ORIa9TUjZEKWvaZ3TgfKUlEDmoXyE8ChwX4879EfGMVZGczhQ5rPnvqpAJCx/tzttKWC/tyxkWpTj+0+EM8r9k7RT0LWKwK1Ueg+tlfcMaeD6wlaGcBWsdvWJI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737037341; c=relaxed/simple;
	bh=TmfYsJXa/lsrlLx2qBmK0WDjY/j3PjANwPo4qYevHSw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=etw9agUDetyvufOHNKudrdjt2dehfXUjgtwIQnypbYdVl+dzSmBm3hseN5JWNuKEbQd6ucZE490l0CB19Tm5RtQdngXFYDym4KNT34Q8iBBZ/f0hPY8OrdJd+85pRL8diRQbtr826G08ubJwXlozNh9CPISPk7+U3url+VUGmXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=R2NkJqnD; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1737037030;
	bh=NioRxeH+o4B5tHujujK7gRQnl2u5wnY8DhDXJNJ9jDY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=R2NkJqnDC19iZT21ZETUDT+uPN+Pm2Z7a/uPo4/ZT5Yx1l+fETCr/yL9os7xTAtXq
	 UyRM0m7f7JoZztINyB4B6B9O/OXjkNZujaiOi2asW0JmJy+t6VskxyR39r2KtWe5XL
	 1UyeDcZmmUSmVTKul/I8z6dZmnv7E4ZriKt89oB4=
Received: from [IPV6:2408:822e:4b2:8541:b0be:e8c8:2d:a517] ([2408:822e:4b2:8541:b0be:e8c8:2d:a517])
	by newxmesmtplogicsvrszc16-0.qq.com (NewEsmtp) with SMTP
	id 447B30EF; Thu, 16 Jan 2025 22:17:07 +0800
X-QQ-mid: xmsmtpt1737037027tpkj27zvm
Message-ID: <tencent_C0690497030FCC40A2F4ABAD259FAB1EA705@qq.com>
X-QQ-XMAILINFO: M9VsxC5s0NEwr5fdyNCQA3hoCTioSdf+NozUrHP4ht1X/JPSNsHbdYN4UBv/67
	 L/3YSONIZg6kJNGGAcwvjukgtPE+yCvGu+qoZbocMSrzkNkk+BR8MldT/s7qyT8l/H8agZe8gzLv
	 oS9m1tCRBZO0HfNHmvqE3/yVPUpbn8xmaUIRnkqLkGtcH/yb0IFEK3ePTbEUd+c25rrREd4cM6TL
	 M9+pcSuO9xTlqrBbFkQqzHBYoRB+ew+z8ny0iCsJtdMknrWPXP8iEXwEZ2zS46Oht0912cb40uu1
	 2gbgI4tTo0rjPcT5HU6ByoshITw4LIn0EZO+tip+NAM6gGo8dXVAkHrEOQLESznwEJu0zx3ypDgx
	 Bp7geJHGA4YkkvF3D67efCt5HjKS0/0+qg4yjivddEBU2g6Syv2Ch++XGzVS097WrfZw38h8AFSn
	 u2+/dOUGWYkh1iVmz7wJe9laECdzBGIOVMGJm/R+jcMC5CSpOPyBWxZkUL2tOqbt0BMX65oYVMuR
	 xb4HjAevgUbd4PvPoRY8TjIhjGlJKlnjoaNFnZ3YyczB+JWAezTUWWhdKu0n9Y2LbDIvU8frTHXJ
	 RUxXbQRldtLTwrQDCj3CSaMGvYrB4BTAQZ0YQLd9NmEXpxISrrjiMInqOML9tNS7ru3si9lgYy17
	 8oS0XQxHIibuieyy5VvyL2yXSVdaahp81ymoh+HrnllDVgE7GFesbCzr8ZaHvq2wklyteds/Ntxy
	 QY36b7kV4MKGCq2GDFDmuxfwElnE8TtAhiMFyWIyJ0ElVbUkrRXso9AnS0h3/SzDTg3URIU6H4RK
	 taencIZE/lI5WfIO43OLwWOZdqT0cPf/u4mOG7NPlsnTnKijkx15Qe63rliQ+Hegt3+3c4PvH6Yt
	 QRYyTONIHkYNmMjoVxPLBCyuNfmvIiaq4magnZx5zpwnPXM5+ZbAcAExArfrtS4jE82PNM9DtR/N
	 7b5B26AMzlTXc1fXwONNXA+/u7kO48XaB9NJ0cLhNqkN7Cid1sbA==
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-OQ-MSGID: <7343df00-def7-4332-a5c7-a016afaa7e9d@foxmail.com>
Date: Thu, 16 Jan 2025 22:17:08 +0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: selftests/livepatch: question about dmesg "signaling remaining
 tasks"
To: Petr Mladek <pmladek@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>, Joe Lawrence <joe.lawrence@redhat.com>,
 "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
References: <TYZPR01MB6878934C04B458FA6FEE011CA6192@TYZPR01MB6878.apcprd01.prod.exchangelabs.com>
 <tencent_D03A5C20BC0603E8D2F936D37C97FAE62607@qq.com>
 <Z4fa0qCWsef0B_ze@pathway.suse.cz>
 <tencent_FB39E787D4AB347DE10AE0811A00946EB40A@qq.com>
 <Z4jH9By-NdPCKM8f@pathway.suse.cz>
Content-Language: en-US
From: laokz <laokz@foxmail.com>
In-Reply-To: <Z4jH9By-NdPCKM8f@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Petr,

On 1/16/2025 4:48 PM, Petr Mladek wrote:
> On Thu 2025-01-16 13:03:16, laokz wrote:
>> Hi Petr,
>>
>> Thanks for the quick reply.
>>
>> On 1/15/2025 11:57 PM, Petr Mladek wrote:
>>> On Wed 2025-01-15 08:32:12, laokz@foxmail.com wrote:
>>>> When do livepatch transition, kernel call klp_try_complete_transition() which in-turn might call klp_send_signals(). klp_send_signal() has the code:
>>>>
>>>>           if (klp_signals_cnt == SIGNALS_TIMEOUT)
>>>>                   pr_notice("signaling remaining tasks\n");
>>>>
>>>> Do we need to match or filter out this message when check_result?
>>>> And here klp_signals_cnt MUST EQUAL to SIGNALS_TIMEOUT, right?
>>
>> Oops, I misunderstood the 2nd question: (klp_signals_cnt % SIGNALS_TIMEOUT
>> == 0) not always mean equal.
>>
>>> Good question. Have you seen this message when running the selftests, please?
>>>
>>> I wonder which test could trigger it. I do not recall any test
>>> livepatch where the transition might get blocked for too long.
>>>
>>> There is the self test with a blocked transition ("busy target
>>> module") but the waiting is stopped much earlier there.
>>>
>>> The message probably might get printed when the selftests are
>>> called on a huge and very busy system. But then we might get
>>> into troubles also with other timeouts. So it would be nice
>>> to know more details about when this happens.
>>
>> We're trying to port livepatch to RISC-V. In my qemu virt VM in a cloud
>> environment, all tests passed except test-syscall.sh. Mostly it complained
>> the missed dmesg "signaling remaining tasks". I want to confirm from your
>> experts that in theory the failure is expected, or if we could filter out
>> this potential dmesg completely.
> 
> The test-syscall.sh test spawns many processes which are calling the
> SYS_getpid syscall in a busy loop. I could imagine that it might
> cause problems when the virt VM emulates much more virtual CPUs than
> the assigned real CPUs. It might be even worse when the RISC-V
> processor is just emulated on another architecture.
> 
> Anyway, we have already limited the max number of processes because
> they overflow the default log buffer size, see the commit
> 46edf5d7aed54380 ("selftests/livepatch: define max test-syscall
> processes").
> 
> Does it help to reduce the MAXPROC limit from 128 to 64, 32, or 16?
> IMHO, even 16 processes are good enough. We do not need to waste
> that many resources by QA.
> 
> You might also review the setup of your VM and reduce the number
> of emulated CPUs. If the VM is not able to reasonably handle
> high load than it might show false positives in many tests.
> 
> If nothing helps, fell free to send a patch for filtering the
> "signaling remaining tasks" message. IMHO, it is perfectly fine
> to hide this message. Just extend the already existing filter in
> the "check_result" function.

With your help, I tried decrease MAXPROC, not ok; decrease VM '-smp 8' 
to 4, ok, all tests passed all 5 times(MAXPROC not modified). Yes it is 
my emulation environment triggered the false positive. If later we faced 
the same problem in real machine, we'd try patching the filter.

Thanks a lot
laokz


