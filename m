Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8EAA53EA47
	for <lists+live-patching@lfdr.de>; Mon,  6 Jun 2022 19:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241677AbiFFQUs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 Jun 2022 12:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241556AbiFFQUr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 Jun 2022 12:20:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7CBA62914F1
        for <live-patching@vger.kernel.org>; Mon,  6 Jun 2022 09:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654532441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SiJ9xom7N9pKMOdzxnCK3+PJOWSLJd7EA3DjmLBi34c=;
        b=FFopMXIXaspgU3OsHOiL9zXO23qE0lwEYp0XUY4Em0eh8m4r2LqJWIPImcjI+WlAQ5abp8
        pGQAkh8Rjtors03+cAA9jKfOC01dJTaZpzLueHKkmTWq+o1XH2qT6/RC4OHfhkLJEsyMpn
        0CiXO5UomjCaY8znbFl/qWdwE4mTl6k=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-ob-QVy0oPDSVGQhfzcwpNQ-1; Mon, 06 Jun 2022 12:20:40 -0400
X-MC-Unique: ob-QVy0oPDSVGQhfzcwpNQ-1
Received: by mail-wm1-f72.google.com with SMTP id az7-20020a05600c600700b0039c3ed7fa89so5640356wmb.8
        for <live-patching@vger.kernel.org>; Mon, 06 Jun 2022 09:20:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SiJ9xom7N9pKMOdzxnCK3+PJOWSLJd7EA3DjmLBi34c=;
        b=k2CYsJfJsRtATNlx4/GqEmGMZHwdpbyeFVD2rDMJzdbOa1DycysWyXbPOpxJjEbNAM
         vsNOGDUcqKOc+5xlZsemC4B3dqdRp7N7WGwYiujhcsaW57Z2sMyf/+UIk/6Cthc2dEkN
         rZ7Jet4mPec7kV0L8W/5+m5FY8n5Kbu7FAi+KKXQMUHi9aegXTP2b5syG6T7xPbwZnZ+
         U2JZIRpOoVCC+i+JgzWFa7nl7Az3fLzuO9lO39p8A3RVfZEbgjl4cW5orTUW/nGZUHbI
         fRAQDd2WIRJ8B1kC1vU05z7PGuvybzvnocWAWHJeLROrQrni8hQgF5iLW0QasQR/OfB3
         49qA==
X-Gm-Message-State: AOAM533uREo7U7HR4SHGVJ8XgicTit6OtZ1qfQp0BK4bpK/QEF11VyVJ
        m2r35RLJENprh4WEAHArljG5HFG8Xl/P5xAy1VF4XE2enEgGqhYlIz1ZGMfOOPeWGQwoUby3Ymu
        F4dK8tw5Yt/prhOY6SoZpr6p4dA==
X-Received: by 2002:a05:6000:1c0d:b0:216:c9f4:2b83 with SMTP id ba13-20020a0560001c0d00b00216c9f42b83mr11271680wrb.405.1654532439233;
        Mon, 06 Jun 2022 09:20:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzRaTzbA0QBQEva/7Bqtk+6R9scH/Yt15vQFFNyrQgBRo85G9w3nue1vJbR7yVabCwRBl1RyQ==
X-Received: by 2002:a05:6000:1c0d:b0:216:c9f4:2b83 with SMTP id ba13-20020a0560001c0d00b00216c9f42b83mr11271648wrb.405.1654532438966;
        Mon, 06 Jun 2022 09:20:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id k5-20020adff285000000b002101ed6e70fsm11539684wro.37.2022.06.06.09.20.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jun 2022 09:20:38 -0700 (PDT)
Message-ID: <bf1d4cd1-d902-6efc-a954-58a11d85d9ac@redhat.com>
Date:   Mon, 6 Jun 2022 18:20:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] entry/kvm: Exit to user mode when TIF_NOTIFY_SIGNAL is
 set
Content-Language: en-US
To:     Seth Forshee <sforshee@digitalocean.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Sean Christopherson <seanjc@google.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, kvm@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
References: <20220504180840.2907296-1-sforshee@digitalocean.com>
 <Yp4LpgBHjvBEbyeS@do-x1extreme>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <Yp4LpgBHjvBEbyeS@do-x1extreme>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 6/6/22 16:13, Seth Forshee wrote:
> On Wed, May 04, 2022 at 01:08:40PM -0500, Seth Forshee wrote:
>> A livepatch transition may stall indefinitely when a kvm vCPU is heavily
>> loaded. To the host, the vCPU task is a user thread which is spending a
>> very long time in the ioctl(KVM_RUN) syscall. During livepatch
>> transition, set_notify_signal() will be called on such tasks to
>> interrupt the syscall so that the task can be transitioned. This
>> interrupts guest execution, but when xfer_to_guest_mode_work() sees that
>> TIF_NOTIFY_SIGNAL is set but not TIF_SIGPENDING it concludes that an
>> exit to user mode is unnecessary, and guest execution is resumed without
>> transitioning the task for the livepatch.
>>
>> This handling of TIF_NOTIFY_SIGNAL is incorrect, as set_notify_signal()
>> is expected to break tasks out of interruptible kernel loops and cause
>> them to return to userspace. Change xfer_to_guest_mode_work() to handle
>> TIF_NOTIFY_SIGNAL the same as TIF_SIGPENDING, signaling to the vCPU run
>> loop that an exit to userpsace is needed. Any pending task_work will be
>> run when get_signal() is called from exit_to_user_mode_loop(), so there
>> is no longer any need to run task work from xfer_to_guest_mode_work().
>>
>> Suggested-by: "Eric W. Biederman" <ebiederm@xmission.com>
>> Cc: Petr Mladek <pmladek@suse.com>
>> Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
> 
> Friendly reminder as it seems like this patch may have been forgotten.

Probably AB-BA maintainer deadlock.  I have queued it now.

Paolo

> Thanks,
> Seth
> 
>> ---
>>   kernel/entry/kvm.c | 6 ------
>>   1 file changed, 6 deletions(-)
>>
>> diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
>> index 9d09f489b60e..2e0f75bcb7fd 100644
>> --- a/kernel/entry/kvm.c
>> +++ b/kernel/entry/kvm.c
>> @@ -9,12 +9,6 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
>>   		int ret;
>>   
>>   		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL)) {
>> -			clear_notify_signal();
>> -			if (task_work_pending(current))
>> -				task_work_run();
>> -		}
>> -
>> -		if (ti_work & _TIF_SIGPENDING) {
>>   			kvm_handle_signal_exit(vcpu);
>>   			return -EINTR;
>>   		}
>> -- 
>> 2.32.0
>>
> 

