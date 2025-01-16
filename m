Return-Path: <live-patching+bounces-1000-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44E07A13234
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2025 06:03:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A930E3A6107
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2025 05:03:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87EA126AF6;
	Thu, 16 Jan 2025 05:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="Z9ZpfxqP"
X-Original-To: live-patching@vger.kernel.org
Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6245661
	for <live-patching@vger.kernel.org>; Thu, 16 Jan 2025 05:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737003810; cv=none; b=K/GJQgD2NI/tl/XeR/YPfHXrrYySqExXi4xbm4Y0b96l2hreEh224BVmZTktCWLjM9c37QES6sn64TZ+LnT4RYKgrcWBNnT13yhGkLGLDN2ZnQPH+85H6+y09Ja4D0+OULtpwy4yaxKyQMJxib4pAE6GWPnwZ8I9I84wmzMabJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737003810; c=relaxed/simple;
	bh=+xqF42oPKA5CXNHUYRJQPIl7lv0Bettg+YfPYcynUs8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A8APIWmdw+I1PafxoZLNrK4NTBwWc8wZR1XvYvdwO1ilDwk4nx7ZJx5AgBibpGDY6IksCMUvpnQfgtRzc8fg6DUBCYsevonWjTBL3gz1J9NS/fg5ncdARyHsY/CYV2SK7xLQK/Y0IvRPGx3N9jmPvOtnVUakn3XoaEaBtfLi+Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=Z9ZpfxqP; arc=none smtp.client-ip=203.205.221.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1737003795;
	bh=JjDA7y8pKYpN7nyAQxsWkQ6LBC7+3xo5vNB1P1Subfc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z9ZpfxqP6USx5T0U4HdWUh9wUzzvZXUWKAUcp2o7cgKR2da0E/Ag0zo0F2p8/3lpL
	 JtMtz1RboWcoy5C1f60eUn4o1bss5jSEpK3zIrxdUAPMm33vc738Ybf11iBWHtNwZT
	 8mtdN1f8wGOqw1gUORLKEyUnMU2UUm9gE8f71Pi4=
Received: from [IPV6:2408:822e:4b2:8541:b0be:e8c8:2d:a517] ([2408:822e:4b2:8541:b0be:e8c8:2d:a517])
	by newxmesmtplogicsvrszc16-0.qq.com (NewEsmtp) with SMTP
	id CD25480; Thu, 16 Jan 2025 13:03:13 +0800
X-QQ-mid: xmsmtpt1737003793tq8gow1n3
Message-ID: <tencent_FB39E787D4AB347DE10AE0811A00946EB40A@qq.com>
X-QQ-XMAILINFO: MJf32pulH481lXwJhsvE/2S1sZUY4OZx6gGcANpSjfWs6aXQCr/CAwkT2XFMRL
	 fHsOK4YrBxPjaZG/ooCMCwRbczNSCJB8tFFNaBPkQ7QtDIt2GkJkOsQ+XPf7YCcvdlRJYiK72S5H
	 5QYGr6DLoVWxGX4FrAg2CXTmrjxbgSM9soC+4puQFH8m0OI3IAXrb9v18xwNVZlW+UzvtFJvjP8f
	 IiJvFax307kOKzF8mauALuVg49lfdGGdrNqCh+ck9HvBlQLi7eszONl8tFuYft9azXy3UlcoKMrY
	 6Qykp1lgGSxO7fC69SqG5DzhpTISSDqICsVc2HaGM/cyF6aSNafl1WGwI7REkAZeAQPY07I8NeVR
	 sTgpZ+0HWaGuLnUzwODW7MDaOD8KTaJaZk0+XjzT1sL99Rd2GQE2stWWD9Ivtxrpv8S7TZcN0IgO
	 25BMQ+gG7/ScO4ZdnpM8GvfmkiO29cTZULcYDJGuaIXfl1dwI/pq2r1Dt33Q88VCbN3bdMgoAknW
	 XqnE2pLP5C3Ox0b84NiFLdeY4zl0k0rnAv7jmVRTZmfUr+oJuPWgMq8hcrIWeMmO5Nx6ykQF9tXg
	 g6r2KXlHfuwUmDdjfbUYeYHuZcNR+Dki2o10v+TKmB/XxnjlCyGWPsbCrOEIkEhpKaQtC5MBX8c5
	 UbgujqCeWFjLehIMtdJc70VhYyQONKkPKrOG7PP5hrz4SyOR4LCHKeUv71BQbyM1hw3a318OqZLo
	 4YcJtfCDE+75MU+4wqJ8SXaxOG+JVN8ITCi5JtGE4xQX9MOzSGCLCSmxtqtNnbZanFESBqDg6sm5
	 xKKdPYM4qOtE5hdZxxvQjF37KEg6sd6mXUXspLVx1EQSstc9gFg0PAaerYCJnY+vYmvfVzyxU0ql
	 iQtgvYkiLAiyR1jZzUHp2QW6Ef4ud0fqMiKwxbDJ9akQttQrfGSN4uA2yZI8NxUvynefn29O7aBP
	 rSefSTbY6u+YsW/Hvh8aETYeohqr05TYQ6nE1YKMyKv5CW8HAm7Q==
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-OQ-MSGID: <e9fcc41a-53ab-44e2-8f3b-c5ed70a49b94@foxmail.com>
Date: Thu, 16 Jan 2025 13:03:16 +0800
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
Content-Language: en-US
From: laokz <laokz@foxmail.com>
In-Reply-To: <Z4fa0qCWsef0B_ze@pathway.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Petr,

Thanks for the quick reply.

On 1/15/2025 11:57 PM, Petr Mladek wrote:
> On Wed 2025-01-15 08:32:12, laokz@foxmail.com wrote:
>> When do livepatch transition, kernel call klp_try_complete_transition() which in-turn might call klp_send_signals(). klp_send_signal() has the code:
>>
>>          if (klp_signals_cnt == SIGNALS_TIMEOUT)
>>                  pr_notice("signaling remaining tasks\n");
>>
>> Do we need to match or filter out this message when check_result? And here klp_signals_cnt MUST EQUAL to SIGNALS_TIMEOUT, right? 

Oops, I misunderstood the 2nd question: (klp_signals_cnt % 
SIGNALS_TIMEOUT == 0) not always mean equal.

> Good question. Have you seen this message when running the selftests, please?
> 
> I wonder which test could trigger it. I do not recall any test
> livepatch where the transition might get blocked for too long.
> 
> There is the self test with a blocked transition ("busy target
> module") but the waiting is stopped much earlier there.
> 
> The message probably might get printed when the selftests are
> called on a huge and very busy system. But then we might get
> into troubles also with other timeouts. So it would be nice
> to know more details about when this happens.

We're trying to port livepatch to RISC-V. In my qemu virt VM in a cloud 
environment, all tests passed except test-syscall.sh. Mostly it 
complained the missed dmesg "signaling remaining tasks". I want to 
confirm from your experts that in theory the failure is expected, or if 
we could filter out this potential dmesg completely.

Thanks,
laokz


