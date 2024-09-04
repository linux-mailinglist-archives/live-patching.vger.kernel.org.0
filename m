Return-Path: <live-patching+bounces-572-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B91296AE1D
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 03:54:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28B941C230F2
	for <lists+live-patching@lfdr.de>; Wed,  4 Sep 2024 01:54:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D112FC1D;
	Wed,  4 Sep 2024 01:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JINHUFbX"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0403D3C17;
	Wed,  4 Sep 2024 01:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725414873; cv=none; b=WRJlA8rN2v5cWrnCDFXVdnXfVdDXnPlWkNbMZiw4qYETAgmNJvYIjuig6kys6ArFkq7AXIiEHHVwOkEQX5t2krg1AkWqDZBZlfzsLNcQr6jE47B6u1+aoclSCq+ts9BA4fSfaU4b6izbosHcTxUme8+d7BaE5SoPZoDcWDoJcec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725414873; c=relaxed/simple;
	bh=qXG6OeG1AuM2mVo/2L1gULaQIT/pgdfN44BBaUNDpbw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=pBEWC3BI49BqfD9gzxz89t3RXipL4g0w3IjBgk9X4qD186YWCKARTjv9eRc+KjSRRKwqYBNFXunxFwIUH99rmhGVBLxbDVerbrKudy856jT6oVpiZl/Lgov5Ic3iSv2idwgQisl3Z2hsmQrFmOOU/LgQyz7fG9vikxDP2RX7kOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JINHUFbX; arc=none smtp.client-ip=209.85.167.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-3df0519a3ceso3653029b6e.2;
        Tue, 03 Sep 2024 18:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725414870; x=1726019670; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yrYHG7eQk6rW7VBN1NJAxki2bUkI69dy+Qbg9DclfuQ=;
        b=JINHUFbX9UVrdF0smrLYXfjhY/RpRle/bGn6cVj6SeuI3Kb8GVOV09dmFzyVc+5nBw
         CSvK0i1LTNksTaXmD7neN8SUgmDHSCF303UVuW7Y2cQyQ910hsAlerTbam7gmE80xe84
         xxrTzaAsevGWS+1tVgC5YrDgT4oZEss5CGQrpdIT1i3Nh8sZh510pEUFokZIX44OIlBz
         z1TFFG5HEkMRK5WxqLXL5seF+x6ml1EsCQ5CzN4LMWr2e0MusgtDYXEw1M/olrdOYeAb
         paRbKLdoj700MVTZylUPJpMncW/EdR05KYLIyZg2Sfs51TfNLYgLGDlTSwPgV3EZt4pU
         bdcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725414870; x=1726019670;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yrYHG7eQk6rW7VBN1NJAxki2bUkI69dy+Qbg9DclfuQ=;
        b=iUamvvXixxEPVxQuHziPO5njwsVoNOkrsNxRqZOI0wo+WrlWS5xKpEuA2Y+hmU9QeH
         6e/4MOTMwA5+WmjHwPizNC3Cm+qAvS1gPpUqbxprKOwCk+6oQA6uLC9lCroBvfS8Cxjz
         TfzYBsGX9dqNLlTDKDVCZksaX5v4ZLKb1NQt96LDlk0x/hgzRBTDXdQ27KNh8b6ISf+Z
         1Fv8w46cBDHuGYstQ1rbwcxzQe95ch0y2BdPMGOzZVncJ0AuKTqsEcX9unesi7wLKYx3
         cIkjuKqnKfdSNeh6BeV4Q5aNkQHZD9hu/ZsX/5tWjPQxuMoRNYwxBGupE9k8Im/E/Ze2
         10qw==
X-Forwarded-Encrypted: i=1; AJvYcCV1a4TqG4JUznjBEl7OZEzTzM06AuAofDOgvdnpHLOZyzmljxri4jhNcRkGVo/qC31aoPbRQkYVYC7eJIg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvK4+3LqgXGbMHrhD+iM/XhZtzEfPT20B8qg+bYON0M8k+iTK8
	ccQ5xlCG9guP+APKDcSeYSIiR8iR/kjAiRBLISlfOQrc/iQxMr6K
X-Google-Smtp-Source: AGHT+IFQrHM1sVdE9yzS05Lfl8cGGC7Qe6tkr91Lb7p4PVOuMLJ9xvzBev5fsKn1NgCLX3/3btW07A==
X-Received: by 2002:a05:6870:2112:b0:255:2e14:3d9d with SMTP id 586e51a60fabf-2779007542bmr21782985fac.5.1725414870056;
        Tue, 03 Sep 2024 18:54:30 -0700 (PDT)
Received: from smtpclient.apple ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-717785890fasm500433b3a.118.2024.09.03.18.54.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2024 18:54:29 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v4 2/2] livepatch: Add using attribute to klp_func for
 using function show
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20240828022350.71456-3-zhangwarden@gmail.com>
Date: Wed, 4 Sep 2024 09:54:15 +0800
Cc: live-patching@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <2A1B7DE1-07C7-42F5-84ED-598ED538EC43@gmail.com>
References: <20240828022350.71456-1-zhangwarden@gmail.com>
 <20240828022350.71456-3-zhangwarden@gmail.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Aug 28, 2024, at 10:23, Wardenjohn <zhangwarden@gmail.com> wrote:
> 
> One system may contains more than one livepatch module. We can see
> which patch is enabled. If some patches applied to one system
> modifing the same function, livepatch will use the function enabled
> on top of the function stack. However, we can not excatly know
> which function of which patch is now enabling.
> 
> This patch introduce one sysfs attribute of "using" to klp_func.
> For example, if there are serval patches  make changes to function
> "meminfo_proc_show", the attribute "enabled" of all the patch is 1.
> With this attribute, we can easily know the version enabling belongs
> to which patch.
> 
> The "using" is set as three state. 0 is disabled, it means that this
> version of function is not used. 1 is running, it means that this
> version of function is now running. -1 is unknown, it means that
> this version of function is under transition, some task is still
> chaning their running version of this function.
> 
> cat /sys/kernel/livepatch/<patch1>/<object1>/<function1,sympos>/using -> 0
> means that the function1 of patch1 is disabled.
> 
> cat /sys/kernel/livepatch/<patchN>/<object1>/<function1,sympos>/using -> 1
> means that the function1 of patchN is enabled.
> 
> cat /sys/kernel/livepatch/<patchN>/<object1>/<function1,sympos>/using -> -1
> means that the function1 of patchN is under transition and unknown.
> 
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
> 
> 

Hi, Maintainers.

How about this patch? I am looking for your suggestions.

Regards,
Wardenjohn.


