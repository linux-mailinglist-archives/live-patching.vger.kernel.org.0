Return-Path: <live-patching+bounces-711-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 736D098F1FD
	for <lists+live-patching@lfdr.de>; Thu,  3 Oct 2024 16:59:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A55C71C216CD
	for <lists+live-patching@lfdr.de>; Thu,  3 Oct 2024 14:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3692919F428;
	Thu,  3 Oct 2024 14:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AKR/hXkY"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9200126C13;
	Thu,  3 Oct 2024 14:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727967569; cv=none; b=ImIrDiSFxG4LJv8vkTtUTC2j79phL44eahl190zJCiYm0yPFnDLE7Mp9Y4Wf2RcklNPIzIdMdw9pEJr1fa7dbb+Z8lZTbQffGLgtyOpxOTg8qN9PkTuFxpCvyYKmGYzy94uONHaPAjmZYW4mL6y0Dlr3K5F48msl8cD9zzIwt2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727967569; c=relaxed/simple;
	bh=nPIjl3iVLvtKYaE9EGYAmiDaJas/EGHupafTygNcNnA=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=CNMRslk4oKY5wuzV5besqAIuXmVsXf6LNh7l+uV1197v33TnShN/TJJ/Yi7qQDUazCWMeljRV/eD/rDLbEmqUlGFkQIX+UB8nJugwlar4jQiruOp4fiLJDnjzqmDiyUmhUyjWoMGEuetvBxuMlGq87V+PiVWO6qgLLQkNRRNOrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AKR/hXkY; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20ba8d92af9so7781775ad.3;
        Thu, 03 Oct 2024 07:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727967567; x=1728572367; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y8mqEgh1sAZ5ZRAlThlSZYqQFb4glRNTor4feadJ11g=;
        b=AKR/hXkYioe2MrkiNReV3SnQ1bZNBm4Kvzg7WwKtLSdk2vSgM+3dGGiP+Hz/2iKokZ
         hN73HII9uYhSxIY9Mblt8kI72uhRRgMdy0SZ5VOACwjfGdspMxFPMxU7+mUFTpWPyRr1
         kr+UdUqmVO1bXkmw2E47hMwtO7xTI0roSBUgqe1yRAyHTT/9UwzvAWezrqdoJvTZXqEq
         dw3oVW5uLwBh/13bMADgi/V10y/iLIrtd8DHiVB2MxTCclGLkkBHGTGplTs0Y+dioxHQ
         Tps7cDlLBJDC5cWHcdtdArjGfMgNOX9QoSpv65LsH5DYQkNMuL8+mvGGGAs4Tb9O9aol
         AETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727967567; x=1728572367;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y8mqEgh1sAZ5ZRAlThlSZYqQFb4glRNTor4feadJ11g=;
        b=BgPSMEqzb4JhFEkOprdflLiJ75hOWvs6L0PSNoC5VGO6lTZeKXm89tBYydUlCdod8b
         qviPmAv+QpluhHI+yBf0PUbQrppoIgIfVNhMvZEHXI9x4aGZkBW5dVBjdO7yKhNUhkPD
         lltrOaCc501069eUi6eNGVyLjYODv27IxHqvKY8yNDzz339He3QusxNdSi5oZiQWEL38
         Oh/H9/MBfDCpmnzQpW5F74C/IgLSxRm4qW2ourlVERMQauF/KI3H5OiE2Y0wiNRlxr2J
         9+k4qoIYbHawcUweLHYMtsSec2n5ys/qmYWmiA8blDS1vLrfUns7Km7abmm3DjzoeE4y
         aYiA==
X-Forwarded-Encrypted: i=1; AJvYcCVSykvqweOR62wKkq5WhE7onahRD4+jegjfp/MJneS4LPoiDPgdINz515S/Cl8RCn4X2oRIDLNDDeVKUik=@vger.kernel.org, AJvYcCXSwoangz3qMqo2fq0gSJCaGm0M/YMbBRDAa3MHlnZkKfjPn6PKkoGObbFyxlMba1Ukz4ZPOghqJ7XdLB4j+A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoDwlDaFVn6QLNy3OkA88Y5fs1W2Jw+VNX7+J94jTp+r+El9oS
	2EZzVEJnSwqfVRFIqqBRzSE7Z166UqVzv6gvwhv9Kh4uN7fwtEVG
X-Google-Smtp-Source: AGHT+IGSpHNL8AOO4yQK2H9f2n1ik5Eu2gS4iKpcwDjZpSd4T+xceLVpbW3aryPLAIFxbWnMnl8NHw==
X-Received: by 2002:a17:902:e743:b0:20b:7e1e:7337 with SMTP id d9443c01a7336-20bc5a0a46bmr111500225ad.13.1727967567023;
        Thu, 03 Oct 2024 07:59:27 -0700 (PDT)
Received: from smtpclient.apple ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20beefad26fsm9764385ad.204.2024.10.03.07.59.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2024 07:59:26 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH V3 1/1] livepatch: Add "stack_order" sysfs attribute
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <Zv6FjZL1VgiRkyaP@pathway.suse.cz>
Date: Thu, 3 Oct 2024 22:59:11 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <A7799C9D-52EF-4C9A-9C22-1B98AAAD997A@gmail.com>
References: <20240929144335.40637-1-zhangwarden@gmail.com>
 <20240929144335.40637-2-zhangwarden@gmail.com>
 <20240930232600.ku2zkttvvkxngdmc@treble>
 <14D5E109-9389-47E7-A3D6-557B85452495@gmail.com>
 <Zv6FjZL1VgiRkyaP@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi, Petr.
> Also please rebase the patch on top of current Linus' master or
> v6.11. There are conflicts with the commit adb68ed26a3e922
> ("livepatch: Add "replace" sysfs attribute").
> 
OK, will fix it.

>>>> +Contact:        live-patching@vger.kernel.org
>>>> +Description:
>>>> + This attribute holds the stack order of a livepatch module applied
>>>> + to the running system.
>>> 
>>> It's probably a good idea to clarify what "stack order" means.  Also,
>>> try to keep the text under 80 columns for consistency.
>>> 
>>> How about:
>>> 
>>> This attribute indicates the order the patch was applied
>>> compared to other patches.  For example, a stack_order value of
>>> '2' indicates the patch was applied after the patch with stack
>>> order '1' and before any other currently applied patches.
>>> 
>> 
>> Or how about:
>> 
>> This attribute indicates the order of the livepatch module 
>> applied to the system. The stack_order value N means 
>> that this module is the Nth applied to the system. If there
>> are serval patches changing the same function, the function
>> version of the biggest stack_order is enabling in the system.
> 
> The 2nd sentence looks superfluous. The 3rd sentence explains
> the important effect.
> 
> Well, the part "is enabling in the system" is a bit cryptic.
> I would write something like:
> 
> This attribute specifies the sequence in which live patch modules
> are applied to the system. If multiple live patches modify the same
> function, the implementation with the highest stack order is used,
> unless a transition is currently in progress.

This description looks good to me. What's the suggestion of 
other maintainers ?

Regards.
Wardenjohn.


