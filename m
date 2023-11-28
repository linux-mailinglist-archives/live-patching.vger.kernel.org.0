Return-Path: <live-patching+bounces-47-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 89CAB7FBF12
	for <lists+live-patching@lfdr.de>; Tue, 28 Nov 2023 17:18:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D8201B212F9
	for <lists+live-patching@lfdr.de>; Tue, 28 Nov 2023 16:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 536A637D2E;
	Tue, 28 Nov 2023 16:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="C0ZRrpJq"
X-Original-To: live-patching@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B2C1B5;
	Tue, 28 Nov 2023 08:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=V1WnKx0mNAa03IEWmc37OFz377UE9cZb+Km5Xefp1Ig=; b=C0ZRrpJq0LDHq8RIXd2ExZ4sXy
	O4mtpphrw9MK6ViAUZRvrozzydvNCAmGRiumtJyRQNviWjfkPMwyQQfakMUA38LhkgB/UxZqnImF3
	io4KzM/7/83HA1vaVEttoBiBf493QjtIpP4xpe93W9zDwDpur+G9lczCYuy56CEZZQ4PawPtwngWt
	L+nBUP0Y5Q4a+J0O/2v1bfRfljRxCcEMKGfeWL6fH0XQKDCQ6WDVKKVLCMGHaXL8Fcx64O8LrlTQo
	faaxFY8sxQ1040mnwdteL++9kk0t1EjmCLgvPp2OcBlgZloMvzt2nbGOttTVeCXKNjnDpj4ZWN0HK
	hXzye7AA==;
Received: from [50.53.46.231] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r80nH-005nLP-2m;
	Tue, 28 Nov 2023 16:18:39 +0000
Message-ID: <0e7941d8-d9b2-4253-9ad5-0f7806e45e2e@infradead.org>
Date: Tue, 28 Nov 2023 08:18:37 -0800
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Took care of some grammatical mistakes
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>
Cc: attreyee-muk <tintinm2017@gmail.com>, jpoimboe@kernel.org,
 jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, joe.lawrence@redhat.com,
 corbet@lwn.net, live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231127155758.33070-1-tintinm2017@gmail.com>
 <202dbdf5-1adf-4ffa-a50d-0424967286ba@infradead.org>
 <ZWX1ZB5p5Vhz7WD2@casper.infradead.org>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <ZWX1ZB5p5Vhz7WD2@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 11/28/23 06:12, Matthew Wilcox wrote:
> On Mon, Nov 27, 2023 at 11:41:31AM -0800, Randy Dunlap wrote:
>> Hi,
>>
>> On 11/27/23 07:57, attreyee-muk wrote:
>>> Respected Maintainers, 
>>>
>>> I have made some grammatical changes in the livepatch.rst file where I
>>> felt that the sentence would have sounded more correct and would have become easy for
>>> beginners to understand by reading. 
>>> Requesting review of my proposed changes from the mainatiners. 
>>>
>>> Thank You
>>> Attreyee Mukherjee
>>>
>>> Signed-off-by: attreyee-muk <tintinm2017@gmail.com>
>>> ---
>>>  Documentation/livepatch/livepatch.rst | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
>>> index 68e3651e8af9..a2d2317b7d6b 100644
>>> --- a/Documentation/livepatch/livepatch.rst
>>> +++ b/Documentation/livepatch/livepatch.rst
>>> @@ -35,11 +35,11 @@ and livepatching:
>>>  
>>>  All three approaches need to modify the existing code at runtime. Therefore
>>> -they need to be aware of each other and not step over each other's toes.
>>> +they need to be aware of each other and not step over each others' toes.
>>
>> I've never seen that written like that, so I disagree here. FWIW.
> 
> "Step over" is new to me too.  I see "step on" much more often.

Agreed.

> As far as placement of the apostrophe,
> https://ludwig.guru/s/step+on+each+others+toes
> suggests either omitting the apostrophe or placing it after the s,
> as attreyee-muk has done is most common.

Apparently you can find anything on the internet.  :)

Here's the other side:

https://jakubmarian.com/each-others-vs-each-others-in-english/


-- 
~Randy

