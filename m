Return-Path: <live-patching+bounces-213-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E4E4E895585
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 15:39:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AFE4E1C21634
	for <lists+live-patching@lfdr.de>; Tue,  2 Apr 2024 13:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AFD58405D;
	Tue,  2 Apr 2024 13:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TwxX9fiw"
X-Original-To: live-patching@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5B933D1
	for <live-patching@vger.kernel.org>; Tue,  2 Apr 2024 13:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712065173; cv=none; b=S0LD7jz5EUQZf/u3pOENW3sjJ1a5VIL28T6JfonSGsyPz71ipyTKTWtXmxzNzXkjV5EgiYuQty944orlMaXbdrrWDgpFbGbC2vL6EJ+6AK/naAEDs9e6ZmQDug0El02uKFpjw2krU49hB2tYyQ4j2tkdNMKDRXDZj6DJTX9uXoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712065173; c=relaxed/simple;
	bh=0eERlPNpqBk7p87baO1sWVeDh6UKxluHdLHaO039lqM=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:Subject:
	 In-Reply-To:Content-Type; b=OsLH5Im0l9H5uBCKQl2B3dazLPb/3MZfN9b/WUMKpwd07X8b6Obw6acbHNdMdmsqrNRT6c3x9xLNC3x+Omd+MOrW2/UUAo98sJgPxHWJYWGgESoUpFTw+JOKHevenLXSCyzdNCDiO2po2HBCPSlcW2OOYOUAIvvEdRDWOmKz51I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TwxX9fiw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712065170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IvJRsOTWy2WNkKPLPyUqDhV14gTMv6DLmU0SB+9xQG4=;
	b=TwxX9fiwEWX8jot+ieP4HklBBGqUdhNh/U0fyi26RXI8STEqWF3XmedPB+2WS2xxr/nA4C
	AeheMFOlLgLTEGjY25Um7Pme3kTIHpCWheyfpcQXQQR2ZmLJ2Z1g0URlM0mV+GfHT0vn1s
	ovOXzyUL4mtwnQc6keiC/JUQyNg+fE4=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-1l1a-q1AOFeuLXeUT_tfGg-1; Tue, 02 Apr 2024 09:39:29 -0400
X-MC-Unique: 1l1a-q1AOFeuLXeUT_tfGg-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3c4e9d60b1cso1522169b6e.3
        for <live-patching@vger.kernel.org>; Tue, 02 Apr 2024 06:39:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712065167; x=1712669967;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IvJRsOTWy2WNkKPLPyUqDhV14gTMv6DLmU0SB+9xQG4=;
        b=WIcc84DoYxfyzswfcUyGi7itLUEgs4jlLJhRAA4TComUx9Zk+wTcv/cYkX+Hx7xtT+
         8jhA4bkqxX2QAouX+TlggVLftZ3am01tQFT1+iP065f/kZlC80IMbCDXvLLBqoSIdjoX
         gvU+Kfh5wqFlM+7Mhg6xPXCNaSYUfCaWGLrsee5mjXAOOu8F9xeTACStwh5t8Kf/Ph/V
         n2phhlxUjuD2z5x1+PZdHmZUqFI4uwMivJ44wgdM0SCr56k6HXmf1bEXIekaCpPJadO7
         q+nJ/yPXzJuOyPyd0Sz3vfkxQS+nxzp8yjGpmC3Ns1FAgQccr4f4T6utKtXwaOLQp2Ze
         MluQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWaWkykSBp2ALzK1EfvNP/OsssQQo4d+wW+PvnmYa1Wt5JyukFJTQMgL7vzkIGuz4i8N6+97pzXDpVzIgI650QcnOae9OcuxZuyDB+ZQ==
X-Gm-Message-State: AOJu0YwRhaBvRja+FGJ3jW34k6GDunb3/7FkW/Dp68PZkMs9JVLgKB8+
	b+vGWA7E5Q8+wd3xWO7nyUJiXMHVN/mrZ5QaUxy2ItIKoponQ17lEDskQjZKhOBVC3EXnujem30
	qqwwZ8vo8a1JCJXuoMckFWoWVjCNMelC8BxLxrzm3QGcTs0m81EesjFtBH7EoR4PmltT19DQ=
X-Received: by 2002:a05:6808:2023:b0:3c3:8822:dc36 with SMTP id q35-20020a056808202300b003c38822dc36mr15867507oiw.28.1712065166798;
        Tue, 02 Apr 2024 06:39:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG/GFTYK7xpSSV0N+UCmqT6UlsH+IDd/aVCXjTy4KkM9mXjUX7DNu+NBrYoah+Cqx4ASkV4/Q==
X-Received: by 2002:a05:6808:2023:b0:3c3:8822:dc36 with SMTP id q35-20020a056808202300b003c38822dc36mr15867480oiw.28.1712065166459;
        Tue, 02 Apr 2024 06:39:26 -0700 (PDT)
Received: from [192.168.1.32] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id ks28-20020a056214311c00b00696893597cfsm5524568qvb.13.2024.04.02.06.39.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 06:39:25 -0700 (PDT)
Message-ID: <f9780cb7-1071-7cb3-c18a-0681a741e0b4@redhat.com>
Date: Tue, 2 Apr 2024 09:39:24 -0400
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Yafang Shao <laoar.shao@gmail.com>, mbenes@suse.cz, pmladek@suse.com
Cc: jpoimboe@kernel.org, jikos@kernel.org, mcgrof@kernel.org,
 live-patching@vger.kernel.org, linux-modules@vger.kernel.org
References: <20240331133839.18316-1-laoar.shao@gmail.com>
 <ZgrMfYBo8TynjSKX@redhat.com>
 <CALOAHbDWiO+TbRnjxCN3j9YWD3Cz9NOg9g-xOhVqmaPmexqNoQ@mail.gmail.com>
From: Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH] livepatch: Delete the associated module when replacing an
 old livepatch
In-Reply-To: <CALOAHbDWiO+TbRnjxCN3j9YWD3Cz9NOg9g-xOhVqmaPmexqNoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/1/24 22:45, Yafang Shao wrote:
> On Mon, Apr 1, 2024 at 11:02 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>>
>> On Sun, Mar 31, 2024 at 09:38:39PM +0800, Yafang Shao wrote:
>>> Enhance the functionality of kpatch to automatically remove the associated
>>> module when replacing an old livepatch with a new one. This ensures that no
>>> leftover modules remain in the system. For instance:
>>>
>>> - Load the first livepatch
>>>   $ kpatch load 6.9.0-rc1+/livepatch-test_0.ko
>>>   loading patch module: 6.9.0-rc1+/livepatch-test_0.ko
>>>   waiting (up to 15 seconds) for patch transition to complete...
>>>   transition complete (2 seconds)
>>>
>>>   $ kpatch list
>>>   Loaded patch modules:
>>>   livepatch_test_0 [enabled]
>>>
>>>   $ lsmod |grep livepatch
>>>   livepatch_test_0       16384  1
>>>
>>> - Load a new livepatch
>>>   $ kpatch load 6.9.0-rc1+/livepatch-test_1.ko
>>>   loading patch module: 6.9.0-rc1+/livepatch-test_1.ko
>>>   waiting (up to 15 seconds) for patch transition to complete...
>>>   transition complete (2 seconds)
>>>
>>>   $ kpatch list
>>>   Loaded patch modules:
>>>   livepatch_test_1 [enabled]
>>>
>>>   $ lsmod |grep livepatch
>>>   livepatch_test_1       16384  1
>>>   livepatch_test_0       16384  0   <<<< leftover
>>>
>>> With this improvement, executing
>>> `kpatch load 6.9.0-rc1+/livepatch-test_1.ko` will automatically remove the
>>> livepatch-test_0.ko module.
>>>
>>
>> Hi Yafang,
>>
>> I think it would be better if the commit message reasoning used
>> insmod/modprobe directly rather than the kpatch user utility wrapper.
>> That would be more generic and remove any potential kpatch utility
>> variants from the picture.  (For example, it is possible to add `rmmod`
>> in the wrapper and then this patch would be redundant.)
> 
> Hi Joe,
> 
> I attempted to incorporate an `rmmod` operation within the kpatch
> replacement process, but encountered challenges in devising a safe and
> effective solution. The difficulty arises from the uncertainty
> regarding which livepatch will be replaced in userspace, necessitating
> the operation to be conducted within the kernel itself.
> 

I wasn't suggesting that the kpatch user utility should or could solve
this problem, just that this scenario is not specific to kpatch.  And
since this is a kernel patch, it would be consistent to speak in terms
of livepatches: the repro can be phrased in terms of modprobe/insmod,
/sys/kernel/livepatch/ sysfs, rmmod, etc. for which those not using the
kpatch utility are more familiar with.

>>
>>> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
>>> ---
>>>  include/linux/module.h  |  1 +
>>>  kernel/livepatch/core.c | 11 +++++++++--
>>>  kernel/module/main.c    | 43 ++++++++++++++++++++++++-----------------
>>>  3 files changed, 35 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/include/linux/module.h b/include/linux/module.h
>>> index 1153b0d99a80..9a95174a919b 100644
>>> --- a/include/linux/module.h
>>> +++ b/include/linux/module.h
>>> @@ -75,6 +75,7 @@ extern struct module_attribute module_uevent;
>>>  /* These are either module local, or the kernel's dummy ones. */
>>>  extern int init_module(void);
>>>  extern void cleanup_module(void);
>>> +extern void delete_module(struct module *mod);
>>>
>>>  #ifndef MODULE
>>>  /**
>>> diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
>>> index ecbc9b6aba3a..f1edc999f3ef 100644
>>> --- a/kernel/livepatch/core.c
>>> +++ b/kernel/livepatch/core.c
>>> @@ -711,6 +711,8 @@ static void klp_free_patch_start(struct klp_patch *patch)
>>>   */
>>>  static void klp_free_patch_finish(struct klp_patch *patch)
>>>  {
>>> +     struct module *mod = patch->mod;
>>> +
>>>       /*
>>>        * Avoid deadlock with enabled_store() sysfs callback by
>>>        * calling this outside klp_mutex. It is safe because
>>> @@ -721,8 +723,13 @@ static void klp_free_patch_finish(struct klp_patch *patch)
>>>       wait_for_completion(&patch->finish);
>>>
>>>       /* Put the module after the last access to struct klp_patch. */
>>> -     if (!patch->forced)
>>> -             module_put(patch->mod);
>>> +     if (!patch->forced)  {
>>> +             module_put(mod);
>>> +             if (module_refcount(mod))
>>> +                     return;
>>> +             mod->state = MODULE_STATE_GOING;
>>> +             delete_module(mod);
>>> +     }

I'm gonna have to read study code in kernel/module/ to be confident that
this is completely safe.  What happens if this code races a concurrent
`rmmod` from the user (perhaps that pesky kpatch utility)?  Can a stray
module reference sneak between the code here.  Etc.  The existing
delete_module syscall does some additional safety checks under the
module_mutex, which may or may not make sense for this use case... Petr,
Miroslav any thoughts?

Also, code-wise, it would be nice if the mod->state were only assigned
inside the kernel/module/main.c code... maybe this little sequence can
be pushed into that file so it's all in one place?

>>>  }
>>>
>>>  /*
>>> diff --git a/kernel/module/main.c b/kernel/module/main.c
>>> index e1e8a7a9d6c1..e863e1f87dfd 100644
>>> --- a/kernel/module/main.c
>>> +++ b/kernel/module/main.c
>>> @@ -695,12 +695,35 @@ EXPORT_SYMBOL(module_refcount);
>>>  /* This exists whether we can unload or not */
>>>  static void free_module(struct module *mod);
>>>
>>> +void delete_module(struct module *mod)
>>> +{
>>> +     char buf[MODULE_FLAGS_BUF_SIZE];
>>> +
>>> +     /* Final destruction now no one is using it. */
>>> +     if (mod->exit != NULL)
>>> +             mod->exit();
>>> +     blocking_notifier_call_chain(&module_notify_list,
>>> +                                  MODULE_STATE_GOING, mod);
>>> +     klp_module_going(mod);
>>> +     ftrace_release_mod(mod);
>>> +
>>> +     async_synchronize_full();
>>> +
>>> +     /* Store the name and taints of the last unloaded module for diagnostic purposes */
>>> +     strscpy(last_unloaded_module.name, mod->name, sizeof(last_unloaded_module.name));
>>> +     strscpy(last_unloaded_module.taints, module_flags(mod, buf, false),
>>> +             sizeof(last_unloaded_module.taints));
>>> +
>>> +     free_module(mod);
>>> +     /* someone could wait for the module in add_unformed_module() */
>>> +     wake_up_all(&module_wq);
>>> +}
>>> +
>>>  SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>>>               unsigned int, flags)
>>>  {
>>>       struct module *mod;
>>>       char name[MODULE_NAME_LEN];
>>> -     char buf[MODULE_FLAGS_BUF_SIZE];
>>>       int ret, forced = 0;
>>>
>>>       if (!capable(CAP_SYS_MODULE) || modules_disabled)
>>> @@ -750,23 +773,7 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
>>>               goto out;
>>>
>>>       mutex_unlock(&module_mutex);
>>> -     /* Final destruction now no one is using it. */
>>> -     if (mod->exit != NULL)
>>> -             mod->exit();
>>> -     blocking_notifier_call_chain(&module_notify_list,
>>> -                                  MODULE_STATE_GOING, mod);
>>> -     klp_module_going(mod);
>>> -     ftrace_release_mod(mod);
>>> -
>>> -     async_synchronize_full();
>>> -
>>> -     /* Store the name and taints of the last unloaded module for diagnostic purposes */
>>> -     strscpy(last_unloaded_module.name, mod->name, sizeof(last_unloaded_module.name));
>>> -     strscpy(last_unloaded_module.taints, module_flags(mod, buf, false), sizeof(last_unloaded_module.taints));
>>> -
>>> -     free_module(mod);
>>> -     /* someone could wait for the module in add_unformed_module() */
>>> -     wake_up_all(&module_wq);
>>> +     delete_module(mod);
>>>       return 0;
>>>  out:
>>>       mutex_unlock(&module_mutex);
>>> --
>>> 2.39.1
>>>
>>
>> It's been a while since atomic replace was added and so I forget why the
>> implementation doesn't try this -- is it possible for the livepatch
>> module to have additional references that this patch would force its way
>> through?
> 
> In the klp_free_patch_finish() function, a check is performed on the
> reference count of the livepatch module. If the reference count is not
> zero, the function will skip further processing.
> 
>>
>> Also, this patch will break the "atomic replace livepatch" kselftest in
>> test-livepatch.sh [1].  I think it would need to drop the `unload_lp
>> $MOD_LIVEPATCH` command, the following 'live patched' greps and their
>> corresponding dmesg output in the test's final check_result() call.
> 
> Thanks for your information. I will check it.
> 

Let me know if you have any questions, I'm more familiar with that code
than the atomic replace / module interactions :)

-- 
Joe


