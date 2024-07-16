Return-Path: <live-patching+bounces-396-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C6592932367
	for <lists+live-patching@lfdr.de>; Tue, 16 Jul 2024 11:53:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 44F801F23A83
	for <lists+live-patching@lfdr.de>; Tue, 16 Jul 2024 09:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F02195F17;
	Tue, 16 Jul 2024 09:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KgGIOtYd"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAF22E832
	for <live-patching@vger.kernel.org>; Tue, 16 Jul 2024 09:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721123609; cv=none; b=uY1dGjwUw103rH1iCLYycuAvslfvENXeketDCrC19nw8vUv0DQmpSM0j/2Pm9cvjxH9xt3tF/e/Pd69F8oAwKFIt9uHZ9S3+9yhWhFviS1gBVZeLNpPQU864z7aHjB/WRkfW3BZSsDJzdkYxfMwzA3SPH5WCwXxe1FA7oIQUTWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721123609; c=relaxed/simple;
	bh=n1ItywNCBtFF0nO7c05+oEsX8pHDW5WUJKtEZqgM4xY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XoReNfnnr4dGyC/XvzkThj0gLrdZPyaeDTDdOj6mqoFKo3+vdcAlklZMfk6vpP20xo+kZPMN7XaPm9dc0iF/dhU1lcsnb46QQ+3L/KN2FHlId2QrQtWT07F+aTuECBFJ2jSdetTyaCMAOhtZtrf0DuWFSRU6LdmWujCekwFlp/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KgGIOtYd; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-42793fc0a6dso35655325e9.0
        for <live-patching@vger.kernel.org>; Tue, 16 Jul 2024 02:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721123605; x=1721728405; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gOf2tPCV0PfnOAIsjc/7dsJtwUILuCK9qbAqpvx8fkA=;
        b=KgGIOtYdlvA605cSGKOyHn+6+rkIQp0SqqYQ0C6up04APyzxyWSQCwK2C6P56GOXMt
         W0ntizSU55XhRY5+ij2PcwxCzCfaCYZYfOSBkv570H6tanIr7ZVSpfePcXau+CdW3wVt
         0trkv92dRCJQjo439r9rRqUK34O4y94+RvAqw0GRn91bnZmMe08ttEfrsH/Vzjuq2ckl
         zfwvcuRGLvrOzgC7EBax/6VX581wtRann4pX9HNoLcROhh2caFKDcm2KMIIiodhgQZ4c
         5of1KQtZXcCMCrOLpjlZneuwRXsSDUln51lzNgLTDPKPurp4ILcK1cKBQKlbmb/7RK6B
         8MTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721123605; x=1721728405;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gOf2tPCV0PfnOAIsjc/7dsJtwUILuCK9qbAqpvx8fkA=;
        b=BU9xjHuBBux78BRu66yh3/++SYwSqXS/3wrKSvlV3NASuztuXq8u0E0P6GYs8YePwI
         HE2i/MUVlrEZRm3BDrfN+51RDNHHJLYMKLy+SzrSonbfD4QDebAEIQQLa92SBMh9EqNg
         Xe6eYLBXqfOVjVoSP7LSleS3IK4/jBs8M2J+OXZJ4YjSk9wm40cp+hr8GvW4m3KxnNj7
         OFny3byWa4bDHCplUB6TC/ALvo2fIpp5MGpLT+bdSgxmp3WkvAjSR1TZEIBjQ2zZnJib
         eNBolq7XXzy9CAlwxJB3d+srQeJdNOxFMgtRuXIkEhS1c86NqPs89AKpM2Olu7zYnhSy
         sCpw==
X-Gm-Message-State: AOJu0YwhdCs1EvdPw4PvPMcJPA8t30q5EaneXMeJPuxLLeqdO6zH2AID
	R6BAVXxe6KasMnLkRQYRxAc8UOiA4/U62W3fxsnsbqqa35CpgNuA
X-Google-Smtp-Source: AGHT+IHfiUfT8VnmCtECmBAmHWtfMuDqn7bRQfbnSCPxHU2/XZUQ/RIzrD8Jvf6vR1+MOgMxIml5Ww==
X-Received: by 2002:a05:600c:3b92:b0:426:654e:16d0 with SMTP id 5b1f17b1804b1-427ba4a3da0mr11995105e9.0.1721123605251;
        Tue, 16 Jul 2024 02:53:25 -0700 (PDT)
Received: from [192.168.26.5] ([77.222.24.25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4279f2d73bdsm153617875e9.43.2024.07.16.02.53.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 02:53:25 -0700 (PDT)
Message-ID: <36e58ac7-3b38-4a67-b726-64886eaf20c6@gmail.com>
Date: Tue, 16 Jul 2024 11:53:23 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re:
To: Nicolai Stange <nstange@suse.de>, Joe Lawrence <joe.lawrence@redhat.com>
Cc: live-patching@vger.kernel.org, pmladek@suse.com, mbenes@suse.cz,
 jikos@kernel.org, jpoimboe@kernel.org
References: <20240714195958.692313-1-raschupkin.ri@gmail.com>
 <ZpWEifTpQ1vc1naA@redhat.com>
 <66963d60.170a0220.70a9a.8866SMTPIN_ADDED_BROKEN@mx.google.com>
Content-Language: en-US
From: Roman Rashchupkin <raschupkin.ri@gmail.com>
In-Reply-To: <66963d60.170a0220.70a9a.8866SMTPIN_ADDED_BROKEN@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

 >> The first thing that comes to mind is that this might be solved using
 >> the existing shadow variable API.

 > Same.

I just don't have enough experience using live-patch shadow-variables, 
so I agree that probably that's a better general solution for problem 
(1) of refcount underflow, than mine refholder flags.

 > I can confirm that this scenario happens quite often with real world CVE
 > fixes and there's currently no way to implement such changes safely from
 > a livepatch. But I also believe this is an instance of a broader problem
 > class we attempted to solve with that "enhanced" states API proposed and
 > discussed at LPC ([1], there's a link to a recording at the bottom). For
 > reference, see Petr's POC from [2].

About (2) of incorrect refcount_t value left after unpatch, it seems as 
a bit different and more special problem with counters, compared to the 
support of live-patch states, which can be solved for refcount_t in a 
simpler way.

IMHO adding temporary kprefcount_t variable for the time of live-patch 
being applied, modifying only this kprefcount_t variable by all added in 
livepatch inc()/dec(), provides correct refcounting during live-patch is 
applied. Then at the unpatch this temporaray variable can just safely be 
discarded. This way the only additional code to live-patch would be 
functions with original refcount_dec_and_test() calls.

---

Roman Rashchupkin

On 7/16/24 11:28, Nicolai Stange wrote:
> Hi all,
>
> Joe Lawrence <joe.lawrence@redhat.com> writes:
>
>> On Sun, Jul 14, 2024 at 09:59:32PM +0200, raschupkin.ri@gmail.com wrote:
>> But first, let me see if I understand the problem correctly.  Let's say
>> points A and A' below represent the original kernel code reference
>> get/put pairing in task execution flow.  A livepatch adds a new get/put
>> pair, B and B' in the middle like so:
>>
>>    ---  execution flow  --->
>>    -- A  B       B'  A'  -->
>>
>> There are potential issues if the livepatch is (de)activated
>> mid-sequence, between the new pairings:
>>
>>    problem 1:
>>    -- A      .   B'  A'  -->                   'B, but no B =  extra put!
>>              ^ livepatch is activated here
>>
>>    problem 2:
>>    -- A  B   .       A'  -->                   B, but no B' =  extra get!
>>              ^ livepatch is deactivated here
> I can confirm that this scenario happens quite often with real world CVE
> fixes and there's currently no way to implement such changes safely from
> a livepatch. But I also believe this is an instance of a broader problem
> class we attempted to solve with that "enhanced" states API proposed and
> discussed at LPC ([1], there's a link to a recording at the bottom). For
> reference, see Petr's POC from [2].
>
>
>> The first thing that comes to mind is that this might be solved using
>> the existing shadow variable API.
> Same.
>
>
>> When the livepatch takes the new
>> reference (B), it could create a new <struct, NEW_REF> shadow variable
>> instance.  The livepatch code to return the reference (B') would then
>> check on the shadow variable existence before doing so.  This would
>> solve problem 1.
>>
>> The second problem is a little trickier.  Perhaps the shadow variable
>> approach still works as long as a pre-unpatch hook* were to iterate
>> through all the <*, NEW_REF> shadow variable instances and returned
>> their reference before freeing the shadow variable and declaring the
>> livepatch inactive.
> I think the problem of consistently maintaining shadowed reference
> counts (or anything shadowed for that matter) could be solved with the
> help of aforementioned states API enhancements, so I would propose to
> revive Petr's IMO more generic patchset as an alternative.
>
> Thoughts?
>
> Thanks,
>
> Nicolai
>
> [1] https://lpc.events/event/17/contributions/1541/
> [2] https://lore.kernel.org/r/20231110170428.6664-1-pmladek@suse.com
>

