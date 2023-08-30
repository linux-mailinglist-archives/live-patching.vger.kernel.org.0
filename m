Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDA578E1B1
	for <lists+live-patching@lfdr.de>; Wed, 30 Aug 2023 23:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243436AbjH3V4W (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 30 Aug 2023 17:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbjH3V4W (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 30 Aug 2023 17:56:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69DACE9
        for <live-patching@vger.kernel.org>; Wed, 30 Aug 2023 14:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693432442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UUcwBG4nsZ2S/sQ42rRb0yMsRkdTvD9Tq37GYF9pDHA=;
        b=cndJFUbEBUSJBTRqRpN3SIpifu93kOEVS//FjogJmregKFkoGTCPdFceKfBZoQt5+6ltrc
        zU6dFisHcpTN1f+WUN+uDfN0cBxq7JbfssU2nPslp9hpYz4fmP4xFuWVqHkD8XY2pjDK9O
        uOx59NVD6biCCQ4xi25OhKTk2vyYrRA=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-FSBCyKqwN_Kd2Ci_MmYVQQ-1; Wed, 30 Aug 2023 17:47:37 -0400
X-MC-Unique: FSBCyKqwN_Kd2Ci_MmYVQQ-1
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-6bf0d513257so333362a34.1
        for <live-patching@vger.kernel.org>; Wed, 30 Aug 2023 14:47:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693432057; x=1694036857;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UUcwBG4nsZ2S/sQ42rRb0yMsRkdTvD9Tq37GYF9pDHA=;
        b=LUy267qiliRm3m3XkTdc8KsRNYM3JHw6qLO1M04mADwAUgGWTL1TJ/qsyNZx77OG9G
         Jc/BjadnvGgLwrhEyjfmQnr8RV85vr5nTA0pwvPeYepmG4G99er/wY5g1X3XC2VXFtE7
         0s8vNYOkq7YVlG4stMSDIRBBwln93HCrhVq+1zVTR0D7s19+9GTKiDQ3+ue+3tVTQyVH
         G//yC5Lh8Q39dnbVxnURA7uiZHKaWAMWb1W9YBRsa0gql1T10b0HYNvfiWhjNdSPy9dX
         R/4d+nwDO3AEpdyCm2m7iCmE+finktC3M5cNMO+S8J0RRZJzlYGQpXH8VfxNecQpcmkb
         ADvQ==
X-Gm-Message-State: AOJu0Yzq0oPzS+oP4FVudNS0A1JYNlAlvspA61p8NLGY2GxqmQxR4rH6
        cqT7uqmhwDnaOEBUoPYzgujkXlfY1rKdolVcBtsR++EoOpLk/s+mp+OfDRoGiuGpJPrJC1E3RtO
        +2nCc08t9+cfj6PF1wWZRaXjPGg==
X-Received: by 2002:a05:6830:2017:b0:6bd:b10:c321 with SMTP id e23-20020a056830201700b006bd0b10c321mr3792136otp.10.1693432057048;
        Wed, 30 Aug 2023 14:47:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGixZZGfNZpc2TcsPswTDuhkrzYsm6YEBuIj13Oq30Mc6BUMAb9Y3bxVcPusJxHvaZdZGkI/A==
X-Received: by 2002:a05:6830:2017:b0:6bd:b10:c321 with SMTP id e23-20020a056830201700b006bd0b10c321mr3792128otp.10.1693432056807;
        Wed, 30 Aug 2023 14:47:36 -0700 (PDT)
Received: from [192.168.1.17] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id s29-20020a05620a031d00b007671cfe8a18sm43892qkm.13.2023.08.30.14.47.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 14:47:36 -0700 (PDT)
Message-ID: <cca0770c-1510-3a02-d0ba-82ee5a0ae4f2@redhat.com>
Date:   Wed, 30 Aug 2023 17:47:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: Recent Power changes and stack_trace_save_tsk_reliable?
Content-Language: en-US
To:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org
Cc:     live-patching@vger.kernel.org, Ryan Sullivan <rysulliv@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>
References: <ZO4K6hflM/arMjse@redhat.com> <87o7ipxtdc.fsf@mail.lhotse>
 <87il8xxcg7.fsf@mail.lhotse>
From:   Joe Lawrence <joe.lawrence@redhat.com>
In-Reply-To: <87il8xxcg7.fsf@mail.lhotse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 8/30/23 02:37, Michael Ellerman wrote:
> Michael Ellerman <mpe@ellerman.id.au> writes:
>> Joe Lawrence <joe.lawrence@redhat.com> writes:
>>> Hi ppc-dev list,
>>>
>>> We noticed that our kpatch integration tests started failing on ppc64le
>>> when targeting the upstream v6.4 kernel, and then confirmed that the
>>> in-tree livepatching kselftests similarly fail, too.  From the kselftest
>>> results, it appears that livepatch transitions are no longer completing.
>>
>> Hi Joe,
>>
>> Thanks for the report.
>>
>> I thought I was running the livepatch tests, but looks like somewhere
>> along the line my kernel .config lost CONFIG_TEST_LIVEPATCH=m, so I have
>> been running the test but it just skips. :/
>>

That config option is easy to drop if you use `make localmodconfig` to
try and expedite the builds :D  Been there, done that too many times.

>> I can reproduce the failure, and will see if I can bisect it more
>> successfully.
> 
> It's caused by:
> 
>   eed7c420aac7 ("powerpc: copy_thread differentiate kthreads and user mode threads")
> 
> Which is obvious in hindsight :)
> 
> The diff below fixes it for me, can you test that on your setup?
> 

Thanks for the fast triage of this one.  The proposed fix works well on
our setup.  I have yet to try the kpatch integration tests with this,
but I can verify that all of the kernel livepatching kselftests now
happily run.

--
Joe

> A proper fix will need to be a bit bigger because the comments in there
> are all slightly wrong now since the above commit.
> 
> Possibly we can also rework that code more substantially now that
> copy_thread() is more careful about setting things up, but that would be
> a follow-up.
> 
> diff --git a/arch/powerpc/kernel/stacktrace.c b/arch/powerpc/kernel/stacktrace.c
> index 5de8597eaab8..d0b3509f13ee 100644
> --- a/arch/powerpc/kernel/stacktrace.c
> +++ b/arch/powerpc/kernel/stacktrace.c
> @@ -73,7 +73,7 @@ int __no_sanitize_address arch_stack_walk_reliable(stack_trace_consume_fn consum
>  	bool firstframe;
>  
>  	stack_end = stack_page + THREAD_SIZE;
> -	if (!is_idle_task(task)) {
> +	if (!(task->flags & PF_KTHREAD)) {
>  		/*
>  		 * For user tasks, this is the SP value loaded on
>  		 * kernel entry, see "PACAKSAVE(r13)" in _switch() and
> 
> 
> cheers
> 

