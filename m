Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1A34591AF
	for <lists+live-patching@lfdr.de>; Mon, 22 Nov 2021 16:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240002AbhKVP4c (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 22 Nov 2021 10:56:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41548 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239918AbhKVP4c (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 22 Nov 2021 10:56:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637596405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OJ9xzZY5FeccmukwMdR9fcM2Iiv+nWzTkmOO43/ifUs=;
        b=hIESrfmMydnvjp2zZOwJ9tVLdWQtbVLiOn172JbHZOtwTjfzN5rss3cgOjaNhJ/q6e3UMZ
        WdAeIH6Olx/muOFuzDM7tbg0zA6b1AZ13OVaIzXG5vHEgw1jaDm6C5XDjDJfk2mOLOJS8J
        8zoaQyipFULCSEEEBzVIqJDno683bMM=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-9aUy1Jo6OI6wefmdFziTGw-1; Mon, 22 Nov 2021 10:53:24 -0500
X-MC-Unique: 9aUy1Jo6OI6wefmdFziTGw-1
Received: by mail-qt1-f198.google.com with SMTP id g2-20020ac87d02000000b002b277218d03so10885386qtb.16
        for <live-patching@vger.kernel.org>; Mon, 22 Nov 2021 07:53:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OJ9xzZY5FeccmukwMdR9fcM2Iiv+nWzTkmOO43/ifUs=;
        b=zE4779HYMwq1uBXdcUoWqpx1GwcWX0LfuNNxrAOmLJc9lleU+LgcHM6gd/XlJFt4tQ
         PVqNzKlPC51oKtEI1ILbTGlXlKhVjIuGOQony8N0PTClXn3C9gdE4QIMnbCaaKrJctT3
         I3c5tbU/5BRkf9kKkkUQ3GWlGKfwdMKMzHuiCIg2SfWkJynYmaZAoWgtQj0oaNbd21NH
         gs3JJw/6qXHxWxshv5aAYb5K+6liNMBBp0BEom8/bxpoSY/9ayPgt2XdnXDySvW6o34R
         wqE9IpdtA/5aTgLLm9TQ+shsmiObBjvRDSThHGKvtyGQhEPhUDL4FjOltbbbgIfTFExQ
         BSrw==
X-Gm-Message-State: AOAM5322G/IGBH61xnNa/gRdDZnKcy766W7qQxibXi6Xk0iA1US2hsBr
        E2dnY9OvSPQuQNMleYBZXThIlqEWtTe9NBXChWVskc8KXVytk5UCvOlDIKAkyIqfUMpUpRPpKdI
        xxBMmrkvOY182rTBXAB/I/GYUAg==
X-Received: by 2002:a05:620a:4f6:: with SMTP id b22mr47916391qkh.98.1637596403456;
        Mon, 22 Nov 2021 07:53:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzPD4/b7lgHJ1aacYNO3wJRJsislsVZmoXjxxgp5SWcJOf6UdvGe1TRnOUvngCMxGXcKx7dCg==
X-Received: by 2002:a05:620a:4f6:: with SMTP id b22mr47916359qkh.98.1637596403194;
        Mon, 22 Nov 2021 07:53:23 -0800 (PST)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id x16sm2254188qko.15.2021.11.22.07.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 07:53:22 -0800 (PST)
To:     Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     jikos@kernel.org, pmladek@suse.com, peterz@infradead.org,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        shuah@kernel.org, linux-kselftest@vger.kernel.org
References: <20211119090327.12811-1-mbenes@suse.cz>
 <20211119090327.12811-3-mbenes@suse.cz>
 <20211119182005.t3p5iyxyibzktrbj@treble>
 <alpine.LSU.2.21.2111220853010.5064@pobox.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH 2/3] livepatch: Allow user to specify functions to search
 for on a stack
Message-ID: <40edd48c-6f45-29e3-4749-be37fb61afba@redhat.com>
Date:   Mon, 22 Nov 2021 10:53:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.2111220853010.5064@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 11/22/21 2:57 AM, Miroslav Benes wrote:
> On Fri, 19 Nov 2021, Josh Poimboeuf wrote:
> 
>> Thanks for doing this!  And at peterz-esque speed no less :-)
>>
>> On Fri, Nov 19, 2021 at 10:03:26AM +0100, Miroslav Benes wrote:
>>> livepatch's consistency model requires that no live patched function
>>> must be found on any task's stack during a transition process after a
>>> live patch is applied. It is achieved by walking through stacks of all
>>> blocked tasks.
>>>
>>> The user might also want to define more functions to search for without
>>> them being patched at all. It may either help with preparing a live
>>> patch, which would otherwise require additional touches to achieve the
>>> consistency
>>
>> Do we have any examples of this situation we can add to the commit log?
> 
> I do not have anything at hand. Joe, do you remember the case you 
> mentioned previously about adding a nop to a function?
>  

I went looking in my inbox to see... Unfortunately the closest thing I
found was a kpatchset in which we added nops to coax kpatch-build into
reverting previous patch version changes.  Not applicable here, but I
was certain we entertained the same idea to increase the task stack
check for some other problem.

Maybe adding a hypothetical scenario to the commit log would suffice?

>>> or it can be used to overcome deficiencies the stack
>>> checking inherently has. For example, GCC may optimize a function so
>>> that a part of it is moved to a different section and the function would
>>> jump to it. This child function would not be found on a stack in this
>>> case, but it may be important to search for it so that, again, the
>>> consistency is achieved.
>>>
>>> Allow the user to specify such functions on klp_object level.
>>>
>>> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
>>> ---
>>>  include/linux/livepatch.h     | 11 +++++++++++
>>>  kernel/livepatch/core.c       | 16 ++++++++++++++++
>>>  kernel/livepatch/transition.c | 21 ++++++++++++++++-----
>>>  3 files changed, 43 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
>>> index 2614247a9781..89df578af8c3 100644
>>> --- a/include/linux/livepatch.h
>>> +++ b/include/linux/livepatch.h
>>> @@ -106,9 +106,11 @@ struct klp_callbacks {
>>>   * struct klp_object - kernel object structure for live patching
>>>   * @name:	module name (or NULL for vmlinux)
>>>   * @funcs:	function entries for functions to be patched in the object
>>> + * @funcs_stack:	function entries for functions to be stack checked
>>
>> So there are two arrays/lists of 'klp_func', and two implied meanings of
>> what a 'klp_func' is and how it's initialized.
>>
>> Might it be simpler and more explicit to just add a new external field
>> to 'klp_func' and continue to have a single 'funcs' array?  Similar to
>> what we already do with the special-casing of 'nop', except it would be
>> an external field, e.g. 'no_patch' or 'stack_only'.
>>
>> Then instead of all the extra klp_for_each_func_stack_static()
>> incantations, and the special cases in higher-level callers like
>> klp_init_object() and klp_init_patch_early(), the lower-level functions
>> like klp_init_func() and klp_init_func_early() can check the field to
>> determine which initializations need to be made.  Which is kind of nice
>> IMO as it pushes that detail down more where it belongs.  And makes the
>> different types of 'klp_func' more explicit.
> 
> I thought about doing this for a moment but then I was worried there would 
> be many places which would require special-casing, so I tried to keep it 
> separate. But yes, it would be cleaner, so definitely worth trying for v2.
> 

I'll add that the first thing that came to mind when you raised this
feature idea in the other thread was to support existing klp_funcs array
with NULL new_func's.  I didn't go look to see how invasive it would be,
but it will be interesting to see if a single list approach turns out
any simpler for v2.

-- 
Joe

