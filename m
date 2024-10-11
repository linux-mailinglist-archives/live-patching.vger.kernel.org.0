Return-Path: <live-patching+bounces-733-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7575999F65
	for <lists+live-patching@lfdr.de>; Fri, 11 Oct 2024 10:55:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 235D71C20F46
	for <lists+live-patching@lfdr.de>; Fri, 11 Oct 2024 08:55:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3899320C46B;
	Fri, 11 Oct 2024 08:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="HoUf0a9D"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A4D20ADE7
	for <live-patching@vger.kernel.org>; Fri, 11 Oct 2024 08:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728636920; cv=none; b=mq/3ZUNyo3YxENKBXr0mDmjYzGE+yvrcyersTGqa1UkxwPMbORnbAk0ezW991EGu7d0guClHomCyAnwemp98av+zKNxH41BIvIMK6HACF/fDLCgovXbPWXcUtt7esK5+IRF7OXIJLobQ3F+MfRZDS3yjUqxrplmJjdk+C86gxKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728636920; c=relaxed/simple;
	bh=ZaZIZPL75FN7F2Xka8N1vKtFdsaNKv70SY2RDWflhuk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/e+ohcDSOHS9YSAxiiVJvU5AOf3IWvYjkbM20Ct/vXO130zyp5FKDma8kfb0mA2rugA6Yy0YQMkv4ghvIwUE6WxEdccQtZVdJaWnvG5IO1rtgkFYc7teF6T0gM3fPqauQh6rzh9zXqN8mADmCwrkPvay1L4WV2bJXnwcG94OZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=HoUf0a9D; arc=none smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2facf48166bso19098091fa.0
        for <live-patching@vger.kernel.org>; Fri, 11 Oct 2024 01:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1728636915; x=1729241715; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X7wBNfh83lXnA+3o4O/+GyuwzB4d/XfOcAHO7ievXKU=;
        b=HoUf0a9Dtc7XjwAxoZ+UrNfBF/f2x6stKUf/9oej7GGTjfurylQd1Wt208e/pLhfr/
         oJOkbe8om3izCp8Ao2M8Xn1ELpXglGm3UPV4NiKcv1nvNEQcQHYAzK8lxsrrqnYcbNPo
         VoflyiMnmaTcvqVzm5WLebfwMvIaDqkTMslmOsD1nIq9/zaOpZXfQX6gds0bhM8QF2Zb
         CMjZoxcEhBZhBKQhaYdF/JH+xX1zk76Z1yHi/Cj9U7blijssbGByCQ5enHU2hXyI8cy4
         VaT/QXDmitXfR9tG3otxacoldvva5FU9L9GmnmDqKh6f3nloMFPMpwENmF1iFZNXQGFF
         W9Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728636915; x=1729241715;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X7wBNfh83lXnA+3o4O/+GyuwzB4d/XfOcAHO7ievXKU=;
        b=CxiZ7ERwMVUetUb7Y9RJd+Dnn2GFXhuSFZMYPtwSuJotFC0bNT0GXs5ZnnitRGSDNm
         N1UehAUqV5mioE+LeC1s9QomL64IhjjqIYXVMd9jsMqF2e/7Wv58uJKM+v+WEXaA+8C/
         Srw8yRjsA8k24wd30mOUFXH0qMyPXBjCA7qb6pkGXmLk94KZPb7UPDnMEJ91B2fF2/Va
         IylVWtf92u30pAEhNfq2LTULSmeETz/SMeiduEhBukczWs3XOEEz6mXBcmVmtP3UbKyH
         PP3P3OirqCo6zNlx+VfceJPfMZfZIcrBOstTxl9IpkRu22TbGaO7uOfMVDicHxdZUF7K
         CUDw==
X-Forwarded-Encrypted: i=1; AJvYcCVTjmHkLH9n5J32L9qHMwahw6gSAyCvTVAc+CxgSlqP/s/J9PJ1eqAcb6tO2F44X6a/AK/NjzkF3xiE1QWJ@vger.kernel.org
X-Gm-Message-State: AOJu0YwvNyXD+kz8csTb6xtDPcrT4yCHxHKtZyQiMcrCJktVOFWS5zZH
	TOkPWO68RCL7F/uGlj9USbi4GHauyMD3dPYfmUM53jBf/MBg8/1VDMi33NskEEM=
X-Google-Smtp-Source: AGHT+IH6smBqfgsJtAybZTxVKbMCj9FyiXCKYp1jarZHpl/dwusozZ/5eF82l5M+CGUTW/K/5X4FGQ==
X-Received: by 2002:a2e:a988:0:b0:2fa:cf82:a1b2 with SMTP id 38308e7fff4ca-2fb327b22demr9136071fa.31.1728636915325;
        Fri, 11 Oct 2024 01:55:15 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c937118d39sm1700349a12.21.2024.10.11.01.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2024 01:55:15 -0700 (PDT)
Date: Fri, 11 Oct 2024 10:55:13 +0200
From: Petr Mladek <pmladek@suse.com>
To: Wardenjohn <zhangwarden@gmail.com>
Cc: jpoimboe@kernel.org, mbenes@suse.cz, jikos@kernel.org,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V5 1/1] livepatch: Add stack_order sysfs attribute
Message-ID: <Zwjn8YzCZFdoCDBB@pathway.suse.cz>
References: <20241008014856.3729-1-zhangwarden@gmail.com>
 <20241008014856.3729-2-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241008014856.3729-2-zhangwarden@gmail.com>

On Tue 2024-10-08 09:48:56, Wardenjohn wrote:
> Add "stack_order" sysfs attribute which holds the order in which a live
> patch module was loaded into the system. A user can then determine an
> active live patched version of a function.
> 
> cat /sys/kernel/livepatch/livepatch_1/stack_order -> 1
> 
> means that livepatch_1 is the first live patch applied
> 
> cat /sys/kernel/livepatch/livepatch_module/stack_order -> N
> 
> means that livepatch_module is the Nth live patch applied
> 
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Suggested-by: Miroslav Benes <mbenes@suse.cz>
> Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

Looks and works fine:

Reviewed-by: Petr Mladek <pmladek@suse.com>
Tested-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

PS: I'll wait for the selftest before pushing this change.
    It would be nice to send both patches together in a single
    thread.

