Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B45A132A41
	for <lists+live-patching@lfdr.de>; Tue,  7 Jan 2020 16:43:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgAGPnS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 Jan 2020 10:43:18 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:41832 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727559AbgAGPnS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 Jan 2020 10:43:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578411796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nQfYipj58p9qBQenJC6pYWBxuo9dniYQybqdPmdiHsY=;
        b=P60He5MgPs/2YP59tvutaEoQD2W4s74LPM7CTeo5afhGMZQAAa653uNhYuBt74k5GZ/IMA
        AV9TvvVfBFtVxGWpPd/SObpgfv2lLcgVeLeMcbU1YDJntvn3sJcyLuhiOurRlfXuRagFQP
        3AiMTzGFOt9J9rtNVZneYjK8O+n3pNs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-236-2b8TKyaJNZGIaT04crK-2A-1; Tue, 07 Jan 2020 10:43:13 -0500
X-MC-Unique: 2b8TKyaJNZGIaT04crK-2A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B030B801E76;
        Tue,  7 Jan 2020 15:43:12 +0000 (UTC)
Received: from [10.18.17.119] (dhcp-17-119.bos.redhat.com [10.18.17.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EED25D9CA;
        Tue,  7 Jan 2020 15:43:12 +0000 (UTC)
Subject: Re: [bug report] livepatch: Initialize shadow variables safely by a
 custom callback
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     pmladek@suse.com, live-patching@vger.kernel.org
References: <20200107132929.ficffmrm5ntpzcqa@kili.mountain>
 <4affb6d1-699e-af7e-9a1d-364393adc3a8@redhat.com>
 <20200107152337.GB27042@kadam>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <5fca242f-132a-db4a-cc0d-a51a61d72041@redhat.com>
Date:   Tue, 7 Jan 2020 10:43:11 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200107152337.GB27042@kadam>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 1/7/20 10:23 AM, Dan Carpenter wrote:
> On Tue, Jan 07, 2020 at 10:06:21AM -0500, Joe Lawrence wrote:
>> On 1/7/20 8:29 AM, Dan Carpenter wrote:
>>> Hello Petr Mladek,
>>>
>>> The patch e91c2518a5d2: "livepatch: Initialize shadow variables
>>> safely by a custom callback" from Apr 16, 2018, leads to the
>>> following static checker warning:
>>>
>>> 	samples/livepatch/livepatch-shadow-fix1.c:86 livepatch_fix1_dummy_alloc()
>>> 	error: 'klp_shadow_alloc()' 'leak' too small (4 vs 8)
>>>
>>> samples/livepatch/livepatch-shadow-fix1.c
>>>       53  static int shadow_leak_ctor(void *obj, void *shadow_data, void *ctor_data)
>>>       54  {
>>>       55          void **shadow_leak = shadow_data;
>>>       56          void *leak = ctor_data;
>>>       57
>>>       58          *shadow_leak = leak;
>>>       59          return 0;
>>>       60  }
>>>       61
>>>       62  static struct dummy *livepatch_fix1_dummy_alloc(void)
>>>       63  {
>>>       64          struct dummy *d;
>>>       65          void *leak;
>>>       66
>>>       67          d = kzalloc(sizeof(*d), GFP_KERNEL);
>>>       68          if (!d)
>>>       69                  return NULL;
>>>       70
>>>       71          d->jiffies_expire = jiffies +
>>>       72                  msecs_to_jiffies(1000 * EXPIRE_PERIOD);
>>>       73
>>>       74          /*
>>>       75           * Patch: save the extra memory location into a SV_LEAK shadow
>>>       76           * variable.  A patched dummy_free routine can later fetch this
>>>       77           * pointer to handle resource release.
>>>       78           */
>>>       79          leak = kzalloc(sizeof(int), GFP_KERNEL);
>>>       80          if (!leak) {
>>>       81                  kfree(d);
>>>       82                  return NULL;
>>>       83          }
>>>       84
>>>       85          klp_shadow_alloc(d, SV_LEAK, sizeof(leak), GFP_KERNEL,
>>>                                                ^^^^^^^^^^^^
>>> This doesn't seem right at all?  Leak is a pointer.  Why is leak a void
>>> pointer instead of an int pointer?
>>>
>>
>> Hi Dan,
>>
>> If I remember this code correctly, the shadow variable is tracking the
>> pointer value itself and not its contents, so sizeof(leak) should be correct
>> for the shadow variable data size.
>>
>> (For kernel/livepatch/shadow.c :: __klp_shadow_get_or_alloc() creates new
>> struct klp_shadow with .data[size] to accommodate its meta-data plus the
>> desired data).
>>
>> Why isn't leak an int pointer?  I don't remember why, according to git
>> history it's been that way since the beginning.  I think it was coded to
>> say, "Give me some storage, any size an int will do.  I'm not going to touch
>> it, but I want to demonstrate a memory leak".
>>
>> Would modifying the pointer type satisfy the static code complaint?
>>
>> Since the warning is about a size mismatch, what are the parameters that it
>> is keying on?  [ ... snip ... ]
> 
> It looks at places which call klp_shadow_alloc() and says that sometimes
> the third argument is the size of the last argument.  Then it complains
> when a caller doesn't match.
> 
> I could just make klp_shadow_alloc() an exception.
> 

Ah, I see.  It must also be checking that the last two arguments (ctor, 
ctor_data) are non-null, as that's the simplified calling sequence.

/me runs cscope to find an example ...

Well that's interesting, there really aren't any other 
klp_shadow_alloc() callers aside from 
lib/livepatch/test_klp_shadow_vars.c, which hides it in a wrapper 
routine that probably dodges the static code check.

For a typical out-of-tree example [1], we do a lot of this:

	newpid = klp_shadow_get_or_alloc(p, 0, sizeof(*newpid),
				     GFP_KERNEL, NULL, NULL);
	if (newpid)
		*newpid = ctr++;

as we don't always need the constructor / destructor callbacks for 
simple shadow variables.

Since the ctor/dtor callback part of the API was provided by Petr, I'll 
let him chime in what the code checker should be warning about here.  I 
think it may be more complicated than it's worth, but maybe he has 
another idea.

Regards,

-- Joe

[1] 
https://github.com/dynup/kpatch/blob/master/test/integration/centos-7/shadow-newpid.patch

