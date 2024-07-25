Return-Path: <live-patching+bounces-413-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A41F93C58E
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 16:52:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C4C61C214E2
	for <lists+live-patching@lfdr.de>; Thu, 25 Jul 2024 14:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 139F719CCF7;
	Thu, 25 Jul 2024 14:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dScS6FqH"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E55419AD93
	for <live-patching@vger.kernel.org>; Thu, 25 Jul 2024 14:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919166; cv=none; b=MLIech0CFotNpUNY/HXlNdhV4w8BHU/nPwY/BNf0l/OGO/pa9Sis5IW5yb7Qu85pzVLVZ7UqDJraJekz+DF2pXiC/e55T2i57Vr35nguOVHJoyepaUTvLxtYqaOIs4+5rsxwkNMfSDt4v9KVXv3FrpidUhrZCg5ndQjK+/iaVkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919166; c=relaxed/simple;
	bh=fG7YqrM07ptvCpL/68vHoYbzqmpR4h5NQCfaPOHHZGk=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
	 In-Reply-To:Content-Type; b=lEVBRMYEfN0os7s3kcTnji4J0pYquPbFxQOzhoS9s2dsGPRVznqsaNe5/SaDBDfxTd3SMpiuF/uIFD+M2uOT1ffCZLYOTcOwkDM4Gp24ktcYK5scmmMnYYI/+sq7GjG+qv7ZDkVUBROuYDY6ODIeLTD+n8zZ5rFXSa1s8N75MkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dScS6FqH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721919163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HLc1wOjcMJYXdHhgLNlJhYIg0mm8oAd61iV5uPGYDEM=;
	b=dScS6FqH4jgR5+KbXwYATHpccsALkETCiTMsBZuSLJ77BJqsr2jHEKiN8+kDJf783I7sVM
	h53eJtt5FProhKXoXpz6ByKHqR3JPcNpx58IbETHPfyQUOfrKPY51bDe4Sgr4ZLWR0b5J8
	xxk9higInO8DWUT0Q4Q5qVGNjatx4LQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-67-MMN3oybuNSKQiLxq0zZpiQ-1; Thu, 25 Jul 2024 10:52:39 -0400
X-MC-Unique: MMN3oybuNSKQiLxq0zZpiQ-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-7a1d961ccf4so96348985a.0
        for <live-patching@vger.kernel.org>; Thu, 25 Jul 2024 07:52:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721919159; x=1722523959;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HLc1wOjcMJYXdHhgLNlJhYIg0mm8oAd61iV5uPGYDEM=;
        b=PnD6PuFguyP5HelWlnBbT95T+pawOKk2z5lfpSxG50rAW1al5q89BVOptNPAahJ3fm
         PUzEqo+uDWmoxohZ2NgtvTjwNRXmrE7x5gXfnm3kGLRr4ym+jXapZhNh8A5f81ehaU9w
         ycvuVF6c5H9Z2HMG+D9Q0GAqLWhe508cXHwYLq2K5LvI3scJ/T5XGLZ+b/+JRZRjtyH6
         sguvrgnfxR8g7PSoArYMaCWAiWQ90uSTD7ISBkn1lAFpluP078PW32e7znXyWfPbDSkx
         Tz2Nun74g5/BClrMqmQua17lgOGJXf6Myf5uKIoyQH7uRRm01FOoU7yzmNipbH8czink
         K7iw==
X-Gm-Message-State: AOJu0YxtguZ89h5eX66SI/WWhLnPSwHUhhWgRZNYFbZp40mefK3+ggJj
	g+RwAlV930KcsyN6P5UqKq6ou9tKQ3/iqkJm7r9YAqR+14KMvI4Dx0FKFm0d1cpnric6fTAwGc0
	t0XigqpsKdF68ZE02R9IqmTVQBH+ltskXdn1n0L+THDcwARWRVZkuPfbxT8YCHpA=
X-Received: by 2002:a05:620a:468d:b0:79d:5f82:a404 with SMTP id af79cd13be357-7a1d5cbc415mr451292485a.64.1721919159506;
        Thu, 25 Jul 2024 07:52:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFvTL9//UupkeSMy62uw4tC4N3AbfTYF8Ljqp90GEIf2UwGIPco6ZuZ4nHP+yl/nJZBkhfdrQ==
X-Received: by 2002:a05:620a:468d:b0:79d:5f82:a404 with SMTP id af79cd13be357-7a1d5cbc415mr451289985a.64.1721919159128;
        Thu, 25 Jul 2024 07:52:39 -0700 (PDT)
Received: from [192.168.1.14] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a1d73e7dd5sm89048685a.57.2024.07.25.07.52.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jul 2024 07:52:38 -0700 (PDT)
Message-ID: <559918f8-24ec-58a3-218c-ec580d8c9001@redhat.com>
Date: Thu, 25 Jul 2024 10:52:37 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Roman Rashchupkin <raschupkin.ri@gmail.com>,
 Nicolai Stange <nstange@suse.de>
Cc: live-patching@vger.kernel.org, pmladek@suse.com, mbenes@suse.cz,
 jikos@kernel.org, jpoimboe@kernel.org
References: <20240714195958.692313-1-raschupkin.ri@gmail.com>
 <ZpWEifTpQ1vc1naA@redhat.com>
 <66963d60.170a0220.70a9a.8866SMTPIN_ADDED_BROKEN@mx.google.com>
 <36e58ac7-3b38-4a67-b726-64886eaf20c6@gmail.com>
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re:
In-Reply-To: <36e58ac7-3b38-4a67-b726-64886eaf20c6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/16/24 05:53, Roman Rashchupkin wrote:
>>> The first thing that comes to mind is that this might be solved using
>>> the existing shadow variable API.
> 
>> Same.
> 
> I just don't have enough experience using live-patch shadow-variables,
> so I agree that probably that's a better general solution for problem
> (1) of refcount underflow, than mine refholder flags.
> 

Yes, a general solution could cover the same problem but for different
datatypes, including locks, mutex, etc.

>> I can confirm that this scenario happens quite often with real world CVE
>> fixes and there's currently no way to implement such changes safely from
>> a livepatch. But I also believe this is an instance of a broader problem
>> class we attempted to solve with that "enhanced" states API proposed and
>> discussed at LPC ([1], there's a link to a recording at the bottom). For
>> reference, see Petr's POC from [2].

Thanks for the link -- I thought of that grand-unified
shadow/callback/states patch but couldn't find the latest version.  (I
see that Miroslav has just resurrected it with a fresh review, too.)

>> I think the problem of consistently maintaining shadowed reference
>> counts (or anything shadowed for that matter) could be solved with the
>> help of aforementioned states API enhancements, so I would propose to
>> revive Petr's IMO more generic patchset as an alternative.
>>
>> Thoughts?
>>

I definitely think the states API enhancement could be used to handle
the cases here via shadow variables.

In the meantime, are you using the kprefcount_t API currently via a
livepatch support module?  i.e. we don't need this in the kernel asap to
solve these problems, right?

-- 
Joe


