Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A404E132998
	for <lists+live-patching@lfdr.de>; Tue,  7 Jan 2020 16:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgAGPGZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 7 Jan 2020 10:06:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28898 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727880AbgAGPGZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 7 Jan 2020 10:06:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578409585;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0JAhnkvc8pporiQLbxE3ups+ust8j/0+WLXJ4rQSLEo=;
        b=DYDd1E/GDfUIKDuKVkbhifkfOjpZJW+LsEwKBrn55kLUG7Hm+cuH89awkNnibP+yonqtwb
        L9T/vJu+/ppb/l1cEQrr8Hrfx9M6qTdRrXD0RGAHL2bArwXGaKypWfC5NL6rZMNAY9PyK2
        /GeVgYDSqR9AUYcdQFDplP6Qd7XpR2U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-3vx8A6YdNOWrs0QEbFfGnA-1; Tue, 07 Jan 2020 10:06:23 -0500
X-MC-Unique: 3vx8A6YdNOWrs0QEbFfGnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DD9D801E72;
        Tue,  7 Jan 2020 15:06:22 +0000 (UTC)
Received: from [10.18.17.119] (dhcp-17-119.bos.redhat.com [10.18.17.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ED1041036D00;
        Tue,  7 Jan 2020 15:06:21 +0000 (UTC)
Subject: Re: [bug report] livepatch: Initialize shadow variables safely by a
 custom callback
To:     Dan Carpenter <dan.carpenter@oracle.com>, pmladek@suse.com
Cc:     live-patching@vger.kernel.org
References: <20200107132929.ficffmrm5ntpzcqa@kili.mountain>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <4affb6d1-699e-af7e-9a1d-364393adc3a8@redhat.com>
Date:   Tue, 7 Jan 2020 10:06:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200107132929.ficffmrm5ntpzcqa@kili.mountain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 1/7/20 8:29 AM, Dan Carpenter wrote:
> Hello Petr Mladek,
> 
> The patch e91c2518a5d2: "livepatch: Initialize shadow variables
> safely by a custom callback" from Apr 16, 2018, leads to the
> following static checker warning:
> 
> 	samples/livepatch/livepatch-shadow-fix1.c:86 livepatch_fix1_dummy_alloc()
> 	error: 'klp_shadow_alloc()' 'leak' too small (4 vs 8)
> 
> samples/livepatch/livepatch-shadow-fix1.c
>      53  static int shadow_leak_ctor(void *obj, void *shadow_data, void *ctor_data)
>      54  {
>      55          void **shadow_leak = shadow_data;
>      56          void *leak = ctor_data;
>      57
>      58          *shadow_leak = leak;
>      59          return 0;
>      60  }
>      61
>      62  static struct dummy *livepatch_fix1_dummy_alloc(void)
>      63  {
>      64          struct dummy *d;
>      65          void *leak;
>      66
>      67          d = kzalloc(sizeof(*d), GFP_KERNEL);
>      68          if (!d)
>      69                  return NULL;
>      70
>      71          d->jiffies_expire = jiffies +
>      72                  msecs_to_jiffies(1000 * EXPIRE_PERIOD);
>      73
>      74          /*
>      75           * Patch: save the extra memory location into a SV_LEAK shadow
>      76           * variable.  A patched dummy_free routine can later fetch this
>      77           * pointer to handle resource release.
>      78           */
>      79          leak = kzalloc(sizeof(int), GFP_KERNEL);
>      80          if (!leak) {
>      81                  kfree(d);
>      82                  return NULL;
>      83          }
>      84
>      85          klp_shadow_alloc(d, SV_LEAK, sizeof(leak), GFP_KERNEL,
>                                               ^^^^^^^^^^^^
> This doesn't seem right at all?  Leak is a pointer.  Why is leak a void
> pointer instead of an int pointer?
> 

Hi Dan,

If I remember this code correctly, the shadow variable is tracking the 
pointer value itself and not its contents, so sizeof(leak) should be 
correct for the shadow variable data size.

(For kernel/livepatch/shadow.c :: __klp_shadow_get_or_alloc() creates 
new struct klp_shadow with .data[size] to accommodate its meta-data plus 
the desired data).

Why isn't leak an int pointer?  I don't remember why, according to git 
history it's been that way since the beginning.  I think it was coded to 
say, "Give me some storage, any size an int will do.  I'm not going to 
touch it, but I want to demonstrate a memory leak".

Would modifying the pointer type satisfy the static code complaint?

Since the warning is about a size mismatch, what are the parameters that 
it is keying on?  Does it expect to see the typical allocation pattern like:

   int *foo = alloc(sizeof(*foo))

and not:

   int *foo = alloc(sizeof(foo))


Thanks,

-- Joe

>      86                           shadow_leak_ctor, leak);
>      87
>      88          pr_info("%s: dummy @ %p, expires @ %lx\n",
>      89                  __func__, d, d->jiffies_expire);
>      90
>      91          return d;
>      92  }
> 
> regards,
> dan carpenter
> 

