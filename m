Return-Path: <live-patching+bounces-874-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EEA109E00C9
	for <lists+live-patching@lfdr.de>; Mon,  2 Dec 2024 12:40:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 561E2B3577F
	for <lists+live-patching@lfdr.de>; Mon,  2 Dec 2024 11:35:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74D671FDE3B;
	Mon,  2 Dec 2024 11:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VRWnhTzB"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0972D1FDE01;
	Mon,  2 Dec 2024 11:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733138958; cv=none; b=QdOXOGHkUuwl2VXW5PFtIz2GjZV8n1+Yqy0ACKyKcyQegJ653HUN3GUpZEnfVAWsfRUVtV0pT5MhsyBJ/M5pkpb9X6dCKYR8KxAZTHuy5JSPcmjXmQSYRYtOuHS5ED/Tr8kYFEFT4x3oCzzv+GW4vJhVuizENOkZ9gKC+kYRwdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733138958; c=relaxed/simple;
	bh=Csw8ja1PIsmYFFcyygVFi+bgMVeERwKudFK3oBAcNPE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=LbrU/hBc2RsD3qBO+mVZotBAmwCjd9CNvcHmlDYmAhAlylV6dMSLZSSCdbjXTPZINCO2OZcfFuoVN/Mp5QPk8w8SWE2M8BdBh4UGW7ji03041nQlxH5YWIMp4YkqEyns/7ln162u6eN/Q8KYiD0asuVvh5CSFSVU9o/KsCI2Nu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VRWnhTzB; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2155312884fso23071925ad.0;
        Mon, 02 Dec 2024 03:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733138956; x=1733743756; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXQKnTwgoCIJ5QyNUZAJLfzMuPN877EJ5ak0q1Yak8c=;
        b=VRWnhTzBxFI7Tn3BEXx7NO46N3qA/KpnQ73bG1DMdeckqZr+9iz4CR/hJF9viiQBSB
         yM0LV09n/iTCCa+cAODKx7DT/5StggLbTRQWJuGAswPSQXm9GFGfiDtFYmMZ+8J7W6ad
         0SHLf/LHamU43vmAAkA3pl1wEpGJSHCszDX2NzLs7+QO5Bm28ueEXmUcndmXdy9i02+5
         OTp74CW0PckXe81+lZqWL69299z7IO7DNyBxbaTUNi3bJJ91GSGZ2NHhiWjAdkD6DBoY
         J7O6fcIA/xbAchD120C3J/+2qgyyCXEJ4vCqu+OlRj9wfDpka2oBX7CIRquUeZmrhtdo
         w6mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733138956; x=1733743756;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DXQKnTwgoCIJ5QyNUZAJLfzMuPN877EJ5ak0q1Yak8c=;
        b=VsMUGnMctgeTUVZqNOs6iEYfLwkmIJil7jZ0NamJh1GUejUFdf3T1VQ61ntTq+kWtl
         k6r8y+BOEbmWEuwO/xLF3nhqvPphwFYjSndvxOkNcJujJkXIdIKsvGnR5yW1Y8W0Ol48
         CVQviQg+PHtDGmyx3ao6wOTpCsyNVEPQ/M3B18DBuG5W0eUV689vdzOVXjMu4aZVCLhf
         smZi3kX4UBrP9Br28wzZm/+V+sUi8IDlOed/av2RcwphDXSi6NVIohu7HhicSttyhoqQ
         q3pNJYy9ToT8FplmlNJ3eNAd7wTyXzaImxECi1ceQ401Z1X7YK47RS5Qp4/11c6HhNCL
         ORqA==
X-Forwarded-Encrypted: i=1; AJvYcCVUIofYmqHCJGEFoxekw0AG9kfxFjc6NofGi4Hvcu6X2Ck01Xu/iwujgS6ZRA29+QcceNltvMn7yTrH/18=@vger.kernel.org, AJvYcCWT/UP6NOdmbCO2Fi8ASUboEDLFyg+YdHrN5/e6p4jpv7dx8XFcUazySrQX7TSaWCgQwi9to9xGTdgY3dK/zg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyStnjczO2yRTjSyzKFkPtlBy+BPXTr+Qt1Tz6txy+TICCQMYC5
	sFVEx6qiYKcq3WDO6Qm8bHr0dr7hpRd7qS/J9Tg1Ar0CmZ24ScBe
X-Gm-Gg: ASbGncvR2rLzWLardX72MfDb19gDoLAEqwv/qz5GA8kpNnTPmFQccwdLWm6kjMLScoi
	08UDez+LPrihs6IVFCyx6oSeibZqUZtWuPqe4jw4eDwZFw9/lkRoqWBa32zDgi1B9vHIWinB9gK
	BdQr6ZSKVDbSfAKGOyYwKk/M1sTbwwmOWMiDVxHuOJ4lrbnsuJewQWM0d6DRUINO6HfTRghMdlC
	KQm12IicyHi33gnxVHya2T162jFG3R6FMzQyE9P/uYWu2gx6IYE4A==
X-Google-Smtp-Source: AGHT+IE3wMm9+Ow79XA8XLc7hnc7EDctPx5LRKrjCMUv56AjuWipSa4aLyiyxxSdM/CbLF48D06CHQ==
X-Received: by 2002:a17:902:cf0d:b0:215:8f2e:eeda with SMTP id d9443c01a7336-2158f2ef529mr55975485ad.52.1733138956393;
        Mon, 02 Dec 2024 03:29:16 -0800 (PST)
Received: from smtpclient.apple ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2158838f640sm21557415ad.49.2024.12.02.03.29.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Dec 2024 03:29:15 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH V3] selftests: livepatch: add test cases of stack_order
 sysfs interface
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <Z02Y4C5a-P0kbaq3@pathway.suse.cz>
Date: Mon, 2 Dec 2024 19:29:01 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <ED27ED23-AD05-4EED-B0FB-BC3ACE5ED4E2@gmail.com>
References: <20241024083530.58775-1-zhangwarden@gmail.com>
 <CD7BF255-7128-412C-86EB-305CEC7FF2B7@gmail.com>
 <Z02Y4C5a-P0kbaq3@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Dec 2, 2024, at 19:24, Petr Mladek <pmladek@suse.com> wrote:
> 
> On Thu 2024-11-21 09:36:25, zhang warden wrote:
>> 
>> 
>>> On Oct 24, 2024, at 16:35, Wardenjohn <zhangwarden@gmail.com> wrote:
>>> 
>>> Add selftest test cases to sysfs attribute 'stack_order'.
>>> 
>>> Suggested-by: Petr Mladek <pmladek@suse.com>
>>> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
>> 
>> Hi, Petr.
>> 
>> Here to remind you not to forget this attribute for linux-6.13.
> 
> I am sorry but I have somehow missed this patch and it is too late
> for 6.13 now.
> 
> Anyway, the feature seems to be ready now. I am going to queue it
> for 6.14. I'll just wait few more days for potential feedback.
> 
> Best Regards,
> Petr


OK. And please help me to fix the kernel version from 6.13 to 6.14
at Documentation/ABI/testing/sysfs-kernel-livepatch :)

Thanks.
Wardenjohn.

