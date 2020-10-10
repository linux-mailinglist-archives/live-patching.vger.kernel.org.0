Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA55D28A341
	for <lists+live-patching@lfdr.de>; Sun, 11 Oct 2020 01:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390468AbgJJW5T (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 10 Oct 2020 18:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732037AbgJJTj0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 10 Oct 2020 15:39:26 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92415C08EA6B
        for <live-patching@vger.kernel.org>; Sat, 10 Oct 2020 09:53:47 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 34so9965524pgo.13
        for <live-patching@vger.kernel.org>; Sat, 10 Oct 2020 09:53:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=U5tstZmbDyXUeuyJdKt9QDTRSJ8ywOxt/350RTralow=;
        b=fV2CRHhh/jZjFZgK1JZuqdHlALHsMbDSgonO53L3hZcF/PBA+ICKWfJkPo3keOU4hs
         HQPwmPc/yBBPsyQRlgbiwL4BH+znU5JatWtHIroIGIs96L4fYlo9m28zkxA9iHn3cNKA
         yEGWqWdG2ve28AgxSbipJv1NR5+3HwVoX4oqmA5wAgFJSg9XEkxmkwBtQXGCg1q40V29
         VSDXj/Ono/DPDFSiyyqiqfVUS0WmTj+Cv0EqL597Vj8BhVNqKg39PvRntNY+1a64prAE
         Rc2S2CZDVgUUFyNLe3uA7vgnVyOMqNmKSBciIXUX4mCr+zpXTLmXblcIhwR2PhgJtpjj
         /gkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U5tstZmbDyXUeuyJdKt9QDTRSJ8ywOxt/350RTralow=;
        b=qtn4haxfS/U38jW/sb9tYh810QLfNJ/VxHjbR3MxQjcsUkBaczBa8CJWsKf6DI7g9f
         fAU2wqubvwOuVGtUzT3YPQ8Iyx5qICSc26AAeNYJZojf5VsVqhuu0btJcJeKLXIcR1sz
         wzhhIS0ArsOLnSlwlCIvrfzg7VS30G3nOgi8gyO746rMh6aJcRcOC3jtyQtbTLwS+OB+
         UH0Xg8slbONXOOZkeXVb6OYATLLiYwtXSpPLgaZFyv6ACC1WMUNCadFEq5rdDpS5EnHc
         y/gQq/nCVTqPv4HGs2swxpTq5nNQwsFBhWLsxx9v6rk9+vHE135kdXzxE8R5o4G0gfTz
         PK8Q==
X-Gm-Message-State: AOAM530HPxvZzmbCNpCWwQP50C7E7RchbRStnHCsSGtXoo/OpyB+cO39
        vfNuEcxusMt8IreHp5N66sN9Ib/6igcJS33K
X-Google-Smtp-Source: ABdhPJyx7x8Hz+dyaDtDo4bWS5tG2lI8kBMcU772SoKNz7qVPfAHzTMep5GdpnoIgKhgRgKeqJ8TdA==
X-Received: by 2002:a17:90a:62c2:: with SMTP id k2mr10477618pjs.78.1602348826635;
        Sat, 10 Oct 2020 09:53:46 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id m34sm14606722pgl.94.2020.10.10.09.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2020 09:53:45 -0700 (PDT)
Subject: Re: [PATCHSET RFC v3 0/6] Add support for TIF_NOTIFY_SIGNAL
From:   Jens Axboe <axboe@kernel.dk>
To:     Miroslav Benes <mbenes@suse.cz>, Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de,
        live-patching@vger.kernel.org
References: <20201005150438.6628-1-axboe@kernel.dk>
 <20201008145610.GK9995@redhat.com>
 <alpine.LSU.2.21.2010090959260.23400@pobox.suse.cz>
 <e33ec671-3143-d720-176b-a8815996fd1c@kernel.dk>
Message-ID: <9a01ab10-3140-3fa6-0fcf-07d3179973f2@kernel.dk>
Date:   Sat, 10 Oct 2020 10:53:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e33ec671-3143-d720-176b-a8815996fd1c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 10/9/20 9:21 AM, Jens Axboe wrote:
> On 10/9/20 2:01 AM, Miroslav Benes wrote:
>> On Thu, 8 Oct 2020, Oleg Nesterov wrote:
>>
>>> On 10/05, Jens Axboe wrote:
>>>>
>>>> Hi,
>>>>
>>>> The goal is this patch series is to decouple TWA_SIGNAL based task_work
>>>> from real signals and signal delivery.
>>>
>>> I think TIF_NOTIFY_SIGNAL can have more users. Say, we can move
>>> try_to_freeze() from get_signal() to tracehook_notify_signal(), kill
>>> fake_signal_wake_up(), and remove freezing() from recalc_sigpending().
>>>
>>> Probably the same for TIF_PATCH_PENDING, klp_send_signals() can use
>>> set_notify_signal() rather than signal_wake_up().
>>
>> Yes, that was my impression from the patch set too, when I accidentally 
>> noticed it.
>>
>> Jens, could you CC our live patching ML when you submit v4, please? It 
>> would be a nice cleanup.
> 
> Definitely, though it'd be v5 at this point. But we really need to get
> all archs supporting TIF_NOTIFY_SIGNAL first. Once we have that, there's
> a whole slew of cleanups that'll fall out naturally:
> 
> - Removal of JOBCTL_TASK_WORK
> - Removal of special path for TWA_SIGNAL in task_work
> - TIF_PATCH_PENDING can be converted and then removed
> - try_to_freeze() cleanup that Oleg mentioned
> 
> And probably more I'm not thinking of right now :-)

Here's the current series, I took a stab at converting all archs to
support TIF_NOTIFY_SIGNAL so we have a base to build on top of. Most
of them were straight forward, but I need someone to fixup powerpc,
verify arm and s390.

But it's a decent start I think, and means that we can drop various
bits as is done at the end of the series. I could swap things around
a bit and avoid having the intermediate step, but I envision that
getting this in all archs will take a bit longer than just signing off
on the generic/x86 bits. So probably best to keep the series as it is
for now, and work on getting the arch bits verified/fixed/tested.

https://git.kernel.dk/cgit/linux-block/log/?h=tif-task_work

-- 
Jens Axboe

