Return-Path: <live-patching+bounces-230-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 584598B9BAB
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2024 15:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13750284104
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2024 13:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DDFD13C671;
	Thu,  2 May 2024 13:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aaaG3v98"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70B513C818
	for <live-patching@vger.kernel.org>; Thu,  2 May 2024 13:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714656630; cv=none; b=Ngg3B981JEfeMHBJ1BW5jGM0uaND7lZc5WWJojfT51yVs/JSrGM89+U4sNsZDkXyXQ5KpGR4I0zLFZpdrzwwIYPCqDvAn6fmBMZUNoyQUieRLC8ZWOnhJ5aq+z8YUrJiLKDVekL+2X0S5W/AqYiKHX0EHYA9vf2a7ZMxzU18XPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714656630; c=relaxed/simple;
	bh=vgpTnubJXGZnOqYlf9mWu/CDROcLP2EtMNYYpsuMLEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rbd5KOavP53tREmqoWWboPCOFvEsCcdlqAlS1i+v6cH4tSfImjlt1ZPDjlCiXGGLjQc8kuy0K97MjAWPxXfs4kFxZONctyMIzZYGypRi1ur/2s7dmgJ1zJg0bPDxk+9BA0z+Y2GBbgyFUk8aDhBE/kB86Yf1XVfQ8Y0CCqMmcIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aaaG3v98; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714656627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xe2Sxs+5bqG8uFONaIHGL24PCOqziXWrRn2P/mghR50=;
	b=aaaG3v98plNUbSPBNF0DpaGsce23q6VRVu2WZd+m0FLxAVz4Y69FPL96bspTTdufI0eQV+
	VgYJTuxK0RMc0mPgA5yyQcfLTD55GSvxs1jiNd24yzSTYUWzpLj7KNcpyguSAmgPenP/qg
	pyrhzp7Q6PPRg49aIiWeSkATdOsQcOk=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-592-CgYPlc71Odivn4joWQKn-w-1; Thu, 02 May 2024 09:30:25 -0400
X-MC-Unique: CgYPlc71Odivn4joWQKn-w-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6ee32f18a61so6015456a34.3
        for <live-patching@vger.kernel.org>; Thu, 02 May 2024 06:30:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714656624; x=1715261424;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xe2Sxs+5bqG8uFONaIHGL24PCOqziXWrRn2P/mghR50=;
        b=d0NSJPM+9e/1iofrKyAmVDdaKoOC1O9EM7WSWcjCrsHN1waCzkgZQwANVcyy36zGjb
         8ybBO2iuH5OiJXVK0+iMMwSwDyXZrIchkLp7i7pNMvGgWFA3C4S9BTLCDZaQ1AaIzgY2
         hUNGSe1RyFi+kAka6ZJ9PL8za5kb4rbsGOZnts3PzeSXwZRhVxRaJV87Iokmi6J7YbZh
         nxySS8RWEzwLRay77k56x5ZSucwu/jCDN/jX4EsCWVgMa3KiE+dSMQIAH4Yk2nDRNR1q
         W/HrSp9sxiGqH5dVrielL+oJH2I9n08pcSM45opIdh9aVGxmLEQI71mXcKlx58W1VLUO
         /YiQ==
X-Gm-Message-State: AOJu0YwYw7KCbj+QhZ4Ea9ujXGIPT4yT8ZwOXoTVv28sWz1x0k9d9RcK
	za85/k0/RQizi5odpBiIlw0LY/y6BZVfJzDnaPUCFNnsfn6LncpZTxGuGIQWIqqXVLTxAhdkNzc
	bg6Dbi0N7fMUQcWsqP7mt4upTPtmsi0IzoI/g5Wm8KOQGLgwZ3KToAIFHAp5HmJA=
X-Received: by 2002:a05:6870:a9aa:b0:23c:904e:a24f with SMTP id ep42-20020a056870a9aa00b0023c904ea24fmr2363573oab.31.1714656624764;
        Thu, 02 May 2024 06:30:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGG9aAgjibRgP9ku7O4mF+TrZ+wFxwq/MOYNQ53a8CwzLaYZYhJT1F9dWSw8d2+zptUbV2tCA==
X-Received: by 2002:a05:6870:a9aa:b0:23c:904e:a24f with SMTP id ep42-20020a056870a9aa00b0023c904ea24fmr2363541oab.31.1714656624378;
        Thu, 02 May 2024 06:30:24 -0700 (PDT)
Received: from [192.168.1.9] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id z6-20020a05622a124600b0043781985244sm468499qtx.59.2024.05.02.06.30.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 May 2024 06:30:23 -0700 (PDT)
Message-ID: <8da6b0eb-6e44-b533-5318-f19f6f917781@redhat.com>
Date: Thu, 2 May 2024 09:30:22 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 0/2] livepatch, module: Delete the associated module of
 disabled livepatch
Content-Language: en-US
To: Yafang Shao <laoar.shao@gmail.com>, jpoimboe@kernel.org,
 jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, mcgrof@kernel.org
Cc: live-patching@vger.kernel.org, linux-modules@vger.kernel.org
References: <20240407035730.20282-1-laoar.shao@gmail.com>
From: Joe Lawrence <joe.lawrence@redhat.com>
In-Reply-To: <20240407035730.20282-1-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/6/24 23:57, Yafang Shao wrote:
> In our production environment, upon loading a new atomic replace livepatch,
> we encountered an issue where the kernel module of the old livepatch
> remained, despite being replaced by the new one. The detailed steps to
> reproduce that issue can be found in patch #2.
> 
> Detecting which livepatch will be replaced by the new one from userspace is
> not reliable, necessitating the need for the operation to be performed
> within the kernel itself.
> 
> This patchset aims to address this issue by automatically deleting the
> associated module of a disabled livepatch. Since a disabled livepatch can't
> be enabled again and the kernel module becomes redundant, it is safe to
> remove it in this manner.
> 
> Changes:
> - v1->v2:
>   - Avoid using kpatch utility in the example (Joe, Petr)
>   - Fix race around changing mod->state (Joe, Petr)
>   - Don't set mod->state outside of kernel/module dir (Joe, Petr)
>   - Alter selftests accordingly (Joe)
>   - Split it into two patches (Petr, Miroslav)
>   - Don't delete module from the path klp_enable_patch() (Petr, Miroslav)
>   - Make delete_module() safe (Petr)  
> 
> Yafang Shao (2):
>   module: Add a new helper delete_module()
>   livepatch: Delete the associated module of disabled livepatch
> 
>  include/linux/module.h                        |  1 +
>  kernel/livepatch/core.c                       | 16 ++--
>  kernel/module/main.c                          | 82 +++++++++++++++----
>  .../testing/selftests/livepatch/functions.sh  |  2 +
>  .../selftests/livepatch/test-callbacks.sh     | 24 ++----
>  .../selftests/livepatch/test-ftrace.sh        |  3 +-
>  .../selftests/livepatch/test-livepatch.sh     | 11 +--
>  .../testing/selftests/livepatch/test-state.sh | 15 +---
>  .../selftests/livepatch/test-syscall.sh       |  3 +-
>  .../testing/selftests/livepatch/test-sysfs.sh |  6 +-
>  10 files changed, 95 insertions(+), 68 deletions(-)
> 

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

-- 
Joe


