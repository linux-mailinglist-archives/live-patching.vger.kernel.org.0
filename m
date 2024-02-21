Return-Path: <live-patching+bounces-184-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E341F85E5F9
	for <lists+live-patching@lfdr.de>; Wed, 21 Feb 2024 19:29:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1284A1C240C1
	for <lists+live-patching@lfdr.de>; Wed, 21 Feb 2024 18:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FF7F8613A;
	Wed, 21 Feb 2024 18:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CLVDsAxY"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142F485958
	for <live-patching@vger.kernel.org>; Wed, 21 Feb 2024 18:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708540026; cv=none; b=lZ9o+jRps1pLffswDd6yRIMkJhjxhJtdMyjJL3zIb5sfQdgh4CJVFNcdGDtGhc7oXuBZg+1Y2qa2m9udWwm2QLgS/SywwBYHKMoYH5dZXEcSUiQ9G/OD2/9sjRP/TyE6xdS3pQIP3sJno0c7XmuyD7L/2+CMGWWfZX8Qdxa0ZUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708540026; c=relaxed/simple;
	bh=6VC1qcHGtWcfwYOSabJJ8ZSmJ/99a6jDL4crh0KLPVk=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
	 In-Reply-To:Content-Type; b=hKtGjPq214vo5FByRtjlrseuE9p/MRUiQ/v1yj7R3meVzAK6WLvjVO5pe/d/A53fiTxVeKJagBLI7WfsawELXGo6iST2HX8X7/TBrUR10IqzPcmUWJPPJ3fv3tbMIQms9uMULwisxgKhJAZu5zBibWpOH5e3TVHcXL/7N0MeUC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CLVDsAxY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708540023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oEojIl750TYVuyYtzldN9G7sEW6mfeIF1z8MGEw+SFo=;
	b=CLVDsAxYLhXKcGL2R5HxJuvtbaQKf5ZUGzNJdEECsxPI7E2J5fUy5exjhJrEv0E0FXqxtP
	D+QiM22Yh3BNk2GTGrD5RqEcxiXzVUv3tgKNnZdK9Wz5Hu0fYIysBma3OIn4XmNSCtti2q
	EYcdyekKGhlhnxTbbg5s532zIXH+bIg=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-271-tcCPprMdM1qtChd_vqYiSw-1; Wed, 21 Feb 2024 13:26:59 -0500
X-MC-Unique: tcCPprMdM1qtChd_vqYiSw-1
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-4c78b0c7579so979859e0c.0
        for <live-patching@vger.kernel.org>; Wed, 21 Feb 2024 10:26:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708540019; x=1709144819;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oEojIl750TYVuyYtzldN9G7sEW6mfeIF1z8MGEw+SFo=;
        b=kO3YVY0GaNm6UqgzcU9eaENTgtE57U7/DiMjvQmMyYF0F+7H6Z7Q2GitHvED4FLlis
         id5Y4EzMVMXo02Xp/xE43DjqW6rrpkKgLiP5vXuKn0iEK2BDseH5ujmvCMg0RP0MzLTf
         NWmJqK6l0zHJrNQYu5myjS79AR+d2CBgDFgXnWAm+kHIL9KSbsw/CGJJLmCS1nn8trvo
         ALq5M2dDij+XdVXYEYcWks4meH/Ac5ewN1X1bLB6bGQrZ9u6HJ/IUZVT1mwsA8+eSfZp
         RSlGoJdS/pvVSlQ34n1e0ahu08fNJIUfnEZmRUyYwo3g79PuBrJDaxhDnzw85sBQ4vPY
         2wpQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJbBpzf0kcaJLrNLLzDkZm740dWusIi6BTc6MbFe5QQZft/+7uBICKy57CRPljqL2NEf9h9fklaBq85YQycJ2uYVly0lNVQrrJwVo9KQ==
X-Gm-Message-State: AOJu0YwgqyiB8PIXih5X3g5LuKCfmiL/SiSLecfEXP8CNkBsf8eUN3M6
	QJvx1jUKNoAjkMBzbU9RS5hM/Wi8IBCDxNPVwQjQh/u/3ajk7BgXdAYbZVCrswpC8ypL7yn/0m6
	aV4hVeGgZVTmM1uNSeM7376LDOHwv79OZpY8RVrFW9GAMk30scRZNem5+yPGENL4=
X-Received: by 2002:a05:6122:4f05:b0:4d1:34a1:c887 with SMTP id gh5-20020a0561224f0500b004d134a1c887mr3318939vkb.9.1708540019321;
        Wed, 21 Feb 2024 10:26:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFVeAkg3MpsRAS/vobA8hq7pIispK+lnPkq/9Wp7nPrxR6fPAfqKmvjqwfiX/cWcrVq6/8GSQ==
X-Received: by 2002:a05:6122:4f05:b0:4d1:34a1:c887 with SMTP id gh5-20020a0561224f0500b004d134a1c887mr3318929vkb.9.1708540018987;
        Wed, 21 Feb 2024 10:26:58 -0800 (PST)
Received: from [192.168.1.35] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id ny13-20020a056214398d00b006862b537412sm5803551qvb.123.2024.02.21.10.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Feb 2024 10:26:58 -0800 (PST)
Message-ID: <88672d5a-1b12-a6f2-bf7b-8670eeddc711@redhat.com>
Date: Wed, 21 Feb 2024 13:26:57 -0500
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Nicolai Stange <nstange@suse.de>,
 Shresth Prasad <shresthprasad7@gmail.com>
Cc: zhangwarden@gmail.com, jikos@kernel.org, jpoimboe@kernel.org,
 linux-kernel-mentees@lists.linuxfoundation.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 live-patching@vger.kernel.org, mbenes@suse.cz, mpdesouza@suse.com,
 pmladek@suse.com, shuah@kernel.org, skhan@linuxfoundation.org
References: <ff1078b2-447d-4ae7-8287-d0affd23588d@gmail.com>
 <22981.124022107441100115@us-mta-655.us.mimecast.lan>
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH] Fix implicit cast warning in test_klp_state.c
In-Reply-To: <22981.124022107441100115@us-mta-655.us.mimecast.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/21/24 07:44, Nicolai Stange wrote:
> Shresth Prasad <shresthprasad7@gmail.com> writes:
> 
>> I checked the source code and yes I am on the latest Linux next repo.
>>
>> Here's the warning:
>> /home/shresthp/dev/linux_work/linux_next/tools/testing/selftests/livepatch/test_modules/test_klp_state.c:38:24: warning: assignment to ‘struct klp_state *’ from ‘int’ makes pointer from integer without a cast [-Wint-conversion]
>>    38 |         loglevel_state = klp_get_state(&patch, CONSOLE_LOGLEVEL_STATE);
>>       |                        ^
> 
> 
> Is the declaration of klp_get_state() visible at that point, i.e. is
> there perhaps any warning about missing declarations above that?
> 
> Otherwise C rules would default to assume an 'int' return type.
> 

This is an interesting clue.  I thought I might be able to reproduce the
build error by modifying include/livepatch.h and running `make -j15 -C
tools/testing/selftests/livepatch` ... but that seemed to work fine on
my system.  I even removed the entire include/ subdir from my tree and
it still built the test module.  Huh?

Then I moved /lib/modules/$(uname -r)/build out of the way and saw that
the compilation failed.  Ah hah -- that's right, it's using the system
build tree.  That version of livepatch.h may have a missing or
completely different definition of klp_get_state().

How does this sequence work for you, Shresth:

  # Verify that kernel livepatching is turned on
  $ grep LIVEPATCH .config
  CONFIG_HAVE_LIVEPATCH=y
  CONFIG_LIVEPATCH=y

  # Build linux-next kernel tree and then the livepatch selftests,
  # pointing KDIR to this tree
  $ make -j$(nproc) vmlinux && \
    make -j$(nproc) KDIR=$(pwd) -C tools/testing/selftests/livepatch

-- 
Joe


