Return-Path: <live-patching+bounces-309-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B59BC8D6A3B
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2024 21:58:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6CB01C26B1C
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2024 19:58:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0DBE17E469;
	Fri, 31 May 2024 19:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aPmnu/i1"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1FF17E44E
	for <live-patching@vger.kernel.org>; Fri, 31 May 2024 19:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717185487; cv=none; b=u8Fg4JXYH6zZmAjiSP/zLlirU0T3ux8xZ8dCG4WcgUWwLPBS39pArFt9Y9gyCfakCEl649NVmLD20z+iAW7lzZmyH8ztubn+iHIRqwRurLTePEII1vFqXbSzsfimzKgRAsTAI8v9FNpq881WkIZsfNHWmhyUWc+KZKP/dnNz8QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717185487; c=relaxed/simple;
	bh=O3IiSbAL9+Pwsd2kGX9sYJ5vsluSfA9Q60apb6/OW2k=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
	 In-Reply-To:Content-Type; b=YZ/nik8MfSvVJH/wjTC+qRlPjU3DLflc3CvoGvFa56zCjpA0et17dSQwBgiwXx3g2Xnt4N8oKoPsBYB6SIhXxmE5fTcLYgGC6nnyVOxlS+0IKxaWwuAgKhNTuQGegzS4QX+wAVv4vkl+gzHJYpKVafutqzEdVk9lPNvOWFvcbMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aPmnu/i1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717185484;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/nl6Y8hA9tFb67R/Sjk+6a1HT3MS13bvblE3whYJwL0=;
	b=aPmnu/i1vV0mDi9ZLBPYp0cvyYQzUiXn2POarwb0+3nbSoaJw2glkhPQm3R8F2xF6TlYkg
	BiROmLFwcTKC3RdDD7llCMOoyH2natnMwR9rHYcSEPXhrc3s5pshT9+1Fd4koWdvK3bm1T
	Qffi3M0kgmGBcGI5qklxhw8Q7Yee7nQ=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-675-MOwo2KCdO2GuIGqpTgjgig-1; Fri, 31 May 2024 15:58:00 -0400
X-MC-Unique: MOwo2KCdO2GuIGqpTgjgig-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-794affd50bcso311446285a.1
        for <live-patching@vger.kernel.org>; Fri, 31 May 2024 12:58:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717185478; x=1717790278;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/nl6Y8hA9tFb67R/Sjk+6a1HT3MS13bvblE3whYJwL0=;
        b=PdgPsV0PgTk9RaWrzh6n9PP+0lISafnXzcvhSTWBdQXwewfBxRlxIeQMrHGIRB765Y
         vQPq2cAClwxmWG3MjpJ9IRpgex4ERmFsDwJVKYc+1YyGv1EaQuyyZFk1sVCG8rmmDAzl
         gb3GQ+fOnH2l+moXnYSW1fapJc7lCI3KqHZwXOvum0hTncoadAdhJ81QlSqqF8CQWROi
         aL5xRmSwGtd6oNVAKtFrPDxLMVfU+g1mHRedQrKLF0Wn5vzirDsJiXxv/Y8hbGxSblDY
         hHvu7fu8C03V0nq/x0YQcQxbgWAB450/Itqw9NB2b3sCDOtgsM3CBh7QTcAGuaaR7pYF
         v7/A==
X-Gm-Message-State: AOJu0Yw3iO2ZbqBn8od5soxbfI3MK7exBRRh/ZcpE+QQ7i7LX0ldGoFN
	jTyElazX8/O35tKYE++qwH61UR/vDMAajzTU3B3Oa2jR9Mpch/nDTgJow/Fkm6mncVZU+DfBcPZ
	kfiLkhA96QMeP8OJNwmzy7wF3bu5hXDml3s+ziOlg6G7Xlyar1GI/e+TVDta2m3PBuqHzwgg=
X-Received: by 2002:a05:620a:664:b0:790:c803:7425 with SMTP id af79cd13be357-794f5c66501mr279074185a.2.1717185478146;
        Fri, 31 May 2024 12:57:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFADsX3LlVJp2rhbpBOhqWa6AFga5ig63FMldaWAgcXQlqM+67tY/cWC3znifvPe3kXDYXLbg==
X-Received: by 2002:a05:620a:664:b0:790:c803:7425 with SMTP id af79cd13be357-794f5c66501mr279072285a.2.1717185477559;
        Fri, 31 May 2024 12:57:57 -0700 (PDT)
Received: from [192.168.1.19] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-794f2f166cdsm82437485a.54.2024.05.31.12.57.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 May 2024 12:57:57 -0700 (PDT)
Message-ID: <a93e9121-4558-0cb7-224b-550738e45641@redhat.com>
Date: Fri, 31 May 2024 15:57:56 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Miroslav Benes <mbenes@suse.cz>
Cc: live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200721161407.26806-1-joe.lawrence@redhat.com>
 <alpine.LSU.2.21.2405311319090.8344@pobox.suse.cz>
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH 0/2] livepatch: Add compiler optimization disclaimer/docs
In-Reply-To: <alpine.LSU.2.21.2405311319090.8344@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/31/24 07:23, Miroslav Benes wrote:
> Hi,
> 
> On Tue, 21 Jul 2020, Joe Lawrence wrote:
> 
>> In light of [PATCH] Revert "kbuild: use -flive-patching when
>> CONFIG_LIVEPATCH is enabled" [1], we should add some loud disclaimers
>> and explanation of the impact compiler optimizations have on
>> livepatching.
>>
>> The first commit provides detailed explanations and examples.  The list
>> was taken mostly from Miroslav's LPC talk a few years back.  This is a
>> bit rough, so corrections and additional suggestions welcome.  Expanding
>> upon the source-based patching approach would be helpful, too.
>>
>> The second commit adds a small README.rst file in the livepatch samples
>> directory pointing the reader to the doc introduced in the first commit.
>>
>> I didn't touch the livepatch kselftests yet as I'm still unsure about
>> how to best account for IPA here.  We could add the same README.rst
>> disclaimer here, too, but perhaps we have a chance to do something more.
>> Possibilities range from checking for renamed functions as part of their
>> build, or the selftest scripts, or even adding something to the kernel
>> API.  I think we'll have a better idea after reviewing the compiler
>> considerations doc.
> 
> thanks to Marcos for resurrecting this.
> 
> Joe, do you have an updated version by any chance? Some things have 
> changed since July 2020 so it calls for a new review. If there was an 
> improved version, it would be easier. If not, no problem at all.
> 

Yea, it's been a little while :) I don't have any newer version than
this one.  I can rebase,  apply all of the v1 suggestions, and see where
it stands.  LMK if you can think of any specifics that could be added.

For example, CONFIG_KERNEL_IBT will be driving some changes soon,
whether it be klp-convert for source-based patches or vmlinux.o binary
comparison for kpatch-build.

I can push a v2 with a few changes, but IIRC, last time we reviewed
this, it kinda begged the question of how someone is creating the
livepatch in the first place.  As long as we're fine holding that
thought for a while longer, this doc may still be useful by itself.

-- 
Joe


