Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E40865EFA7
	for <lists+live-patching@lfdr.de>; Thu,  5 Jan 2023 16:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbjAEPGi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Jan 2023 10:06:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbjAEPG1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Jan 2023 10:06:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F4E5B16A
        for <live-patching@vger.kernel.org>; Thu,  5 Jan 2023 07:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672931135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5sA0C5ALLxU0sJGgCU47jg7/++ReZ43FAVJgJl9ZyHk=;
        b=eoqlJTTEBJsVUeyLAkYiCgP48r+NUEhUyVIV2l7yapPAIoLuXbP6Ix+/oSTW8DJRP6OEBH
        SJ+KF2Rje6Mky0LSXsb9luvZzKJNpTb+cdRKhSWIGqXRuMRXOxUt2FJj0AG41kMe2CjQcI
        OrmbCqHTB6VsRlwxFiGjRldujLTXK4I=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-595-HmJtFymTMnmaVoNTH2iJjQ-1; Thu, 05 Jan 2023 10:05:34 -0500
X-MC-Unique: HmJtFymTMnmaVoNTH2iJjQ-1
Received: by mail-ot1-f70.google.com with SMTP id c7-20020a9d6c87000000b006834828052cso16661715otr.8
        for <live-patching@vger.kernel.org>; Thu, 05 Jan 2023 07:05:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5sA0C5ALLxU0sJGgCU47jg7/++ReZ43FAVJgJl9ZyHk=;
        b=aPiURGA8m779jJ33f7tuvINOMcnJXnz2UrVWWeCVjoxhfy2PGU4IpTXeEfr3QgB4uB
         fyG4ShezW7Vn7E1+x4Rir85ZRW0/PI5bbYdBiKQKY1sKWayTB9gP5sz2DmdV6rK9k8DQ
         boQrYzz8nk33pibuiKMeHGOXtdwjXq9/DjdY+XM30qB3cKsxAw9WFcnimwiqS8xenC2o
         1rusB77MDZvg6ZSooufb9IV163ITwme5U28Ul0Xn1ufascifnBpdlfz8ZqCzgbRULw7W
         6rYYJUm1t4T73CYC8fFRNVHzZaoX5L0nYSNzrFcpnSvyMoExFzZ5wQ8xx6jUu3ydSGvQ
         O/cA==
X-Gm-Message-State: AFqh2krAAcMZOc/6D2Qo2Vd0+jehxl0H13460YEycp8RmCuM2XSOUYY7
        fQNJc/x4bEh0bi50kwomhNudVOwJ0jtaTZdAs3k4CLsOhPxpr8DmO5mSjpESHwzbyLsRVSQGtWt
        wlQHBcWNbwX8fZPjaT83ZVBWAkQ==
X-Received: by 2002:a05:6358:c5a9:b0:e0:43c9:f694 with SMTP id fc41-20020a056358c5a900b000e043c9f694mr1155950rwb.29.1672931133929;
        Thu, 05 Jan 2023 07:05:33 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvZ7WPYB/wqnNX8RAt3alLVaaDTQW/Kc5W1PV0lbyWd1ZtsMIQLSjcQZfcKiwzuBGvp4xfMxg==
X-Received: by 2002:a05:6358:c5a9:b0:e0:43c9:f694 with SMTP id fc41-20020a056358c5a900b000e043c9f694mr1155943rwb.29.1672931133539;
        Thu, 05 Jan 2023 07:05:33 -0800 (PST)
Received: from [192.168.1.13] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id do42-20020a05620a2b2a00b006fcc3858044sm26082442qkb.86.2023.01.05.07.05.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Jan 2023 07:05:33 -0800 (PST)
Message-ID: <bf670f87-e2a1-ff42-a88f-70eab78b4cd1@redhat.com>
Date:   Thu, 5 Jan 2023 10:05:31 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Song Liu <song@kernel.org>, Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20221214174035.1012183-1-song@kernel.org>
 <Y7VUPAEFFFougaoC@alley>
 <CAPhsuW7EAFgUUgh3Q6wbE-PNLGnSFFWmdQaYfOqVW6adM0+G4g@mail.gmail.com>
 <Y7YH7SwveCyNPxWC@redhat.com>
 <CAPhsuW6tje3AN+7mw73uQBO8N=cu=w=7a7wTJ5eeCMV-HS0KSg@mail.gmail.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v7] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <CAPhsuW6tje3AN+7mw73uQBO8N=cu=w=7a7wTJ5eeCMV-HS0KSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 1/5/23 00:59, Song Liu wrote:
> On Wed, Jan 4, 2023 at 3:12 PM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>>
>>
>> Stepping back, this feature is definitely foot-gun capable.
>> Kpatch-build would expect that klp-relocations would only ever be needed
>> in code that will patch the very same module that provides the
>> relocation destination -- that is, it was never intended to reference
>> through one of these klp-relocations unless it resolved to a live
>> module.
>>
>> On the other hand, when writing the selftests, verifying against NULL
>> [1] provided 1) a quick sanity check that something was "cleared" and 2)
>> protected the machine against said foot-gun.
>>
>> [1] https://github.com/joe-lawrence/klp-convert-tree/commit/643acbb8f4c0240030b45b64a542d126370d3e6c
> 
> I don't quite follow the foot-gun here. What's the failure mode?
> 

Kpatch-build, for better or worse, hides the potential problem.  A
typical kpatch scenario would be:

1. A patch modifies module foo's function bar(), which references
symbols local to module foo

2. Kpatch-build creates a livepatch .ko with klp-relocations in the
modified bar() to foo's symbols

3. When loaded, modified bar() code that references through its
klp-relocations to module foo will only ever be active when foo is
loaded, i.e. when the original bar() redirects to the livepatch version.

However, writing source-based livepatches (like the kselftests) offers a
lot more freedom.  There is no implicit guarantee from (3) that the
module is loaded.  One could reference klp-relocations from anywhere in
the livepatch module.

For example, in my test_klp_convert1.c test case, I have a livepatch
module with a sysfs interface (print_debug_set()) that allows the test
bash script to force the module to references through its
klp-relocations (print_static_strings()):

...
static void print_string(const char *label, const char *str)
{
	if (str)
		pr_info("%s: %s\n", label, str);
}
...
static noinline void print_static_strings(void)
{
	print_string("klp_string.12345", klp_string_a);
	print_string("klp_string.67890", klp_string_b);
}

/* provide a sysfs handle to invoke debug functions */
static int print_debug;
static int print_debug_set(const char *val, const struct kernel_param *kp)
{
	print_static_strings();

	return 0;
}
static const struct kernel_param_ops print_debug_ops = {
	.set = print_debug_set,
	.get = param_get_int,
};


When I first wrote test_klp_convert1.c, I did not have wrappers like
print_string(), I simply referenced the symbols directly and send them
to pr_info as "%s" string formatting options.

You can probably see where this is going when I unloaded the module that
provided klp_string_a, klp_string_b, etc. and invoked the sysfs handle.
The stale relocation values point to ... somewhere we shouldn't try to
reference any more.


Perhaps I'm too paranoid about that possibility, but by actually
clearing the values in the relocations on module removal, one could
check them and try to guard against dangling pointer (dangling
relocation?) references.

> [...]
> 
>>> These approaches don't look better to me. But I am ok
>>> with any of them. Please just let me know which one is
>>> most preferable:
>>>
>>> a. current version;
>>> b. clear_ undo everything of apply_ (the sample code
>>>    above)
>>> c. clear_ undo R_PPC_REL24, but _redo_ everything
>>>    of apply_ for other ELF64_R_TYPEs. (should be
>>>   clearer code than option b).
>>>
>>
>> This was my attempt at combining and slightly refactoring the power64
>> version.  There is so much going on here I was tempted to split off it
>> into separate value assignment and write functions.  Some changes I
>> liked, but I wasn't all too happy with the result.  Also, as you
>> mention, completely undoing R_PPC_REL24 is less than trivial... for this
>> arch, there are basically three major tasks:
>>
>>   1) calculate the new value, including range checking
>>   2) special constructs created by restore_r2 / create_stub
>>   3) writing out the value
>>
>> and many cases are similar, but subtly different enough to avoid easy
>> code consolidation.
> 
> Thanks for exploring this direction. I guess this part won't be perfect
> anyway.
> 
> PS: While we discuss a solution for ppc64, how about we ship the
> fix for other archs first? I think there are only a few small things to
> be addressed.
> 

Yeah, the x86_64 version looks a lot simpler and closer to being done.
Though I believe that Petr would prefer a complete solution, but I'll
let him speak to that.

Alternatively, we could roll this into the klp-convert-tree as an early
patch (or separate branch), where development could continue on the
ppc64le and s390x arches as needed.  I'll caution that progress is
rather slow on the entire patchset, so it may remain out of tree for
quite a while. :(

-- 
Joe

