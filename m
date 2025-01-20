Return-Path: <live-patching+bounces-1009-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0677DA166BD
	for <lists+live-patching@lfdr.de>; Mon, 20 Jan 2025 07:43:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 752D91881D23
	for <lists+live-patching@lfdr.de>; Mon, 20 Jan 2025 06:43:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CC14188012;
	Mon, 20 Jan 2025 06:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="PrOwpkRq"
X-Original-To: live-patching@vger.kernel.org
Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9D1537E9
	for <live-patching@vger.kernel.org>; Mon, 20 Jan 2025 06:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737355429; cv=none; b=igzxos1PWYeAPkZ2ZL0kJg1OSF9WftKHEtObU2dDYjUt0A9l4n6SUNb1CL1RrDZq9ZCG+TKrpISqvREQ9G4f6ybTuL6THX79lGE23fc+KrblpVIbKt396w+VqGmsS+3J+CHSJv9jPIux25YgKbIp1py2jftw3XQiypcyJac51zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737355429; c=relaxed/simple;
	bh=huhC3ypQEoywp9mwLJekyvxObCUYAdtr+j8LHvA6apw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fNhHOWv7LGaSVZ2tLZEuhonmb/vYpUqt28tTLLILlp4+vF0xLCZBSqpH42ICxOehk8TH4+4P+q3+ELby6Y9NLsEOhmE7dNhnYWctcvxFxIjM7eMnLtmC/Hh8q6kMXgsvmwUJck/38fTFQvnlzyG9Ae81jTY6zIdJqQHwy3SRNsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=PrOwpkRq; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1737355110;
	bh=6vF9Db7wj3caMSCuiw0PfPeTnmXhE0E3b604ha4k+Xc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PrOwpkRqB8j7C+YVfphYL2fxkxMvGlhVNlVGnJ4KfoH02ZtbKyqw+ewJTGQyyb0um
	 et57AJ3TfIQaptD9jZlF+9ShF9NmopJtZuW7PHt+yXwLnvQxKwq8u1YX6hnH4hJmhm
	 SV245vX28mdE47HBLwX+e3iwSQ8vhvIjZ0KSpcB0=
Received: from [IPV6:2408:832e:4b1:3841:d4ab:d860:704f:675f] ([2408:832e:4b1:3841:d4ab:d860:704f:675f])
	by newxmesmtplogicsvrszc13-0.qq.com (NewEsmtp) with SMTP
	id 99BA8872; Mon, 20 Jan 2025 14:38:27 +0800
X-QQ-mid: xmsmtpt1737355107t8rvzibcy
Message-ID: <tencent_F12F2E389E9A41566950DB55BE41BD4ED306@qq.com>
X-QQ-XMAILINFO: NuS7rJd3cou8Ht3XPTvARtUEHVrD5xAcaB8RK73Nmgmq0GPnkgvjPKfHGUIwM0
	 GCED5uiVQG8aem8D2s7pLoQhdiL7sVkfF8EQdVCi+7ma/ZLxNJFy/gfXvCjEMsOJ3Qv+oxscanwK
	 wufGxFCJsBk7Ctw58Qq38qlpMEgmbIqZtzipHAUJXIJK7RW0/08HjBlPK9Kd7K1M+MO1JR96d6Cu
	 RTYUDmXxZhsvyFOwKbxyfU/I+mBmG+W1g8YfkdnrCz+gjwwFFgdiLy+kxZoKDOjfJx+uC/ahelJh
	 L4oMrXK19pLd+E/wlzFa1PYMRxOy2lngH8easyi9s4Fuom/Xd/baSKR2N81q/oN28FN8ezQXrgVM
	 Iblf4Fw+RX35gW4m2SP/dWpj7gVJBImPh8hzsHDVy4GUZKdZvZE5Vas/9aLyOQIZx0ivpOtu9ho/
	 8qn3VZerANmwWseZu5u5mlvxeI+FfKPGAFyVB3ww91nRpWNj4RkKJekd+eHPaF8g5eybI7V8JpIk
	 F0zBMtXMiWRjzFGuHz9g15hKs2B9dbBy3zvoeTWN76QXQQzeDMFnYd/FUpARkaHYnF1d8cMcEKCe
	 z79Ef+xYXTwotJyiyWpJxci0v2pc1WG6nH9OkTpTNznA5mCQcquu+zlMXGtWZbRRn76cHr36JFoC
	 6+nGY0XZMSHV9ftxrdEte+GI9YKR7QMglaYoSZa1FbygxckgQs8pAs5aOb7LxLakgDAsULqkoBDO
	 LdIHkIhx+TqDXcPsRCtFqFXW6yIQSbuTqm0YA6ZUhwI7MRjKmGBmom9b6D6caRVbZpGWLFJXXd3Z
	 65ZYr+4uS2Zo4I38r6+Br3DoKRLSDRjd6/Ivn4mjX3cw6pk0JIsUwmvmS1HjtBNSsT8fkloFeT6F
	 Vl/S4m/IPv5UcP09QsHlfn7P63voMLcjqgiav4VyWi9od41czw+WeZzgziZaYNNNh9hR//bqISfh
	 vpcTdpMZDsqxwgY6DBEx/4jk7neSW5
X-QQ-XMRINFO: NV153Ut7BKVGqje6viCZjP4=
X-OQ-MSGID: <f5f8adb6-a01f-4fb8-8aa2-1076bb4d86b7@foxmail.com>
Date: Mon, 20 Jan 2025 14:38:28 +0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: selftests/livepatch: question about dmesg "signaling remaining
 tasks"
To: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>, Joe Lawrence <joe.lawrence@redhat.com>,
 "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
References: <TYZPR01MB6878934C04B458FA6FEE011CA6192@TYZPR01MB6878.apcprd01.prod.exchangelabs.com>
 <tencent_D03A5C20BC0603E8D2F936D37C97FAE62607@qq.com>
 <Z4fa0qCWsef0B_ze@pathway.suse.cz>
 <tencent_FB39E787D4AB347DE10AE0811A00946EB40A@qq.com>
 <alpine.LSU.2.21.2501171407520.6283@pobox.suse.cz>
Content-Language: en-US
From: laokz <laokz@foxmail.com>
In-Reply-To: <alpine.LSU.2.21.2501171407520.6283@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Miroslav,

On 1/17/2025 9:10 PM, Miroslav Benes wrote:
> Hi,
> 
>>> Good question. Have you seen this message when running the selftests,
>>> please?
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
>> environment, all tests passed except test-syscall.sh. Mostly it complained the
>> missed dmesg "signaling remaining tasks". I want to confirm from your experts
>> that in theory the failure is expected, or if we could filter out this
>> potential dmesg completely.
> 
> it might also mean that the implementation on risc-v is not complete yet.
> If there are many unreliable stacktraces, for example, the live patching
> infrastructure would retry many times which causes delays and you might
> run into the message eventually. It pays off to enable dynamic_debug for
> kernel/livepatch/ and see if there is anything suspicious in the output.

Yes, this is just an in-progress work and we'll try your suggestion to 
help developing.

Thanks a lot,
laokz


