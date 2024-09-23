Return-Path: <live-patching+bounces-673-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A947E97E4CD
	for <lists+live-patching@lfdr.de>; Mon, 23 Sep 2024 04:29:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2BA91C20F8A
	for <lists+live-patching@lfdr.de>; Mon, 23 Sep 2024 02:29:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C902923C9;
	Mon, 23 Sep 2024 02:29:54 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945E21FBA;
	Mon, 23 Sep 2024 02:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727058594; cv=none; b=Cbd4K7jEEvsuMI+W+IsjNyIxdfhU0GJ8pKMJewKGaNegXgJZGu73a3Ro0oGjVhcrYBqXmZRaKhdwTZJtySpf53hM7NKkAouiSD+dOa5XY9VXvWnHxFrKW0JTIB36QuhfgxR6o3rqo/xT/InQqG8Pda9qWYf+jakqYc7UftkC2JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727058594; c=relaxed/simple;
	bh=oLbu1UIRh68sk1NFzBPKuqL60lqqu/zRTN+O1tfi4PI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=W9ZgKWk3UQif/od83nEztRTEw8NnFCxmAe8hy8UdCGaOuUQMyxbGo6xGhTNVHvPBrmYOC9zfq0k8CcZ39YXixN0B7gmgTpUf94Bv0Do/hZXwImJQpLjQo+BvYxOdIQ76HwGK6djsimld/pA7qjlsW6OyZIaRf9JxK4gQDhA+2gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4XBn2h6nGjzpVwj;
	Mon, 23 Sep 2024 10:27:40 +0800 (CST)
Received: from kwepemf500017.china.huawei.com (unknown [7.202.181.4])
	by mail.maildlp.com (Postfix) with ESMTPS id 0092C1800A7;
	Mon, 23 Sep 2024 10:29:44 +0800 (CST)
Received: from [10.67.108.67] (10.67.108.67) by kwepemf500017.china.huawei.com
 (7.202.181.4) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 23 Sep
 2024 10:29:43 +0800
Message-ID: <4936c576-afdb-8aba-b79f-74a03c9702fe@huawei.com>
Date: Mon, 23 Sep 2024 10:29:31 +0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0
Subject: Re: [RFC 00/31] objtool, livepatch: Livepatch module generation
To: Josh Poimboeuf <jpoimboe@kernel.org>, Petr Mladek <pmladek@suse.com>
CC: <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, Miroslav Benes <mbenes@suse.cz>, Joe Lawrence
	<joe.lawrence@redhat.com>, Jiri Kosina <jikos@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Marcos Paulo de Souza <mpdesouza@suse.com>, Song Liu
	<song@kernel.org>
References: <cover.1725334260.git.jpoimboe@kernel.org>
 <ZuGav4txYowDpxqj@pathway.suse.cz> <20240911162005.2zbgqrxs3vbjatsv@treble>
Content-Language: en-US
From: Chen Zhongjin <chenzhongjin@huawei.com>
In-Reply-To: <20240911162005.2zbgqrxs3vbjatsv@treble>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemf500017.china.huawei.com (7.202.181.4)



On 2024/9/12 0:20, Josh Poimboeuf wrote:
...
>> Do not get me wrong. I do not expect that the upstream variant would
>> be feature complete from the beginning. I just want to get a picture
>> how far it is. The code will be maintained only when it would have
>> users. And it would have users only when it would be comparable or
>> better then kPatch.
> 
> I agree it needs to be fully functional before merge, but only for x86.
> 
> Red Hat (and Meta?) will start using it as soon as x86 support is ready,
> because IBT/LTO support is needed, which kpatch-build can't handle.
> 
> Then there will be an intermediate period where both kpatch-build and
> klp-build are used and supported, until the other arches get ported
> over.
> 
> So I think this should be merged once the x86 support is complete, as it
> will have users immediately for those who are running on x86 with IBT
> and/or LTO.
> 
If this is merged on x86, we (Huawei) are interested to port it to other 
arches such as arm64.

Previously for some arches (at least, arm64 has said) the 
functionalities of objtool is not so attractive to merge. If klp-tool 
is added, it will be reasonable to use objtool on other arches. Now we 
have to put a lot of work to add klp for kernel and managing an 
out-of-tree kpatch tool if we want klp on other arches.

Best Regards,
Chen

