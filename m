Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D665242A9
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2019 23:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfETVUC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 May 2019 17:20:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47172 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfETVUC (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 May 2019 17:20:02 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EC9D585365;
        Mon, 20 May 2019 21:20:01 +0000 (UTC)
Received: from [10.18.17.208] (dhcp-17-208.bos.redhat.com [10.18.17.208])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E980D60BF3;
        Mon, 20 May 2019 21:19:59 +0000 (UTC)
Subject: Re: Oops caused by race between livepatch and ftrace
To:     Johannes Erdfelt <johannes@erdfelt.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, Jessica Yu <jeyu@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190520194915.GB1646@sventech.com>
 <90f78070-95ec-ce49-1641-19d061abecf4@redhat.com>
 <20190520210905.GC1646@sventech.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <1802c0d2-702f-08ec-6a85-c7f887eb6d14@redhat.com>
Date:   Mon, 20 May 2019 17:19:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520210905.GC1646@sventech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Mon, 20 May 2019 21:20:02 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 5/20/19 5:09 PM, Johannes Erdfelt wrote:
> On Mon, May 20, 2019, Joe Lawrence <joe.lawrence@redhat.com> wrote:
>> [ fixed jeyu's email address ]
> 
> Thank you, the bounce message made it seem like my mail server was
> blocked and not that the address didn't exist.
> 
> I think MAINTAINERS needs an update since it still has the @redhat.com
> address.
> 

Here's how it looks on my end:

% git describe HEAD
v5.1-12317-ga6a4b66bd8f4

% grep M:.*jeyu MAINTAINERS
M:      Jessica Yu <jeyu@kernel.org>

>> On 5/20/19 3:49 PM, Johannes Erdfelt wrote:
>>> [ ... snip ... ]
>>>
>>> I have put together a test case that can reproduce the crash using
>>> KVM. The tarball includes a minimal kernel and initramfs, along with
>>> a script to run qemu and the .config used to build the kernel. By
>>> default it will attempt to reproduce by loading multiple livepatches
>>> at the same time. Passing 'test=ftrace' to the script will attempt to
>>> reproduce by racing with ftrace.
>>>
>>> My test setup reproduces the race and oops more reliably by loading
>>> multiple livepatches at the same time than with the ftrace method. It's
>>> not 100% reproducible, so the test case may need to be run multiple
>>> times.
>>>
>>> It can be found here (not attached because of its size):
>>> http://johannes.erdfelt.com/5.2.0-rc1-a188339ca5-livepatch-race.tar.gz
>>
>> Hi Johannes,
>>
>> This is cool way to distribute the repro kernel, modules, etc!
> 
> This oops was common in our production environment and was particularly
> annoying since livepatches would load at boot and early enough to happen
> before networking and SSH were started.
> 
> Unfortunately it was difficult to reproduce on other hardware (changing
> the timing just enough) and our production environment is very
> complicated.
> 
> I spent more time than I'd like to admit trying to reproduce this fairly
> reliably. I knew that I needed to help make it as easy as possible to
> reproduce to root cause it and for others to take a look at it as well.
> 

Thanks for building this test image -- it repro'd on the first try for me.

Hmmm, I wonder then how reproducible it would be if we simply extracted 
the .ko's and test scripts from out of your initramfs and ran it on 
arbitrary machines.

I think the rcutorture self-tests use qemu/kvm to fire up test VMs, but 
I dunno if livepatch self-tests are ready for level of sophistication 
yet :)  Will need to think on that a bit.

>> These two testing scenarios might be interesting to add to our selftests
>> suite.  Can you post or add the source(s) to livepatch-test<n>.ko to the
>> tarball?
> 
> I made the livepatches using kpatch-build and this simple patch:
> 
> diff --git a/fs/proc/version.c b/fs/proc/version.c
> index 94901e8e700d..6b8a3449f455 100644
> --- a/fs/proc/version.c
> +++ b/fs/proc/version.c
> @@ -12,6 +12,7 @@ static int version_proc_show(struct seq_file *m, void *v)
>   		utsname()->sysname,
>   		utsname()->release,
>   		utsname()->version);
> +	seq_printf(m, "example livepatch\n");
>   	return 0;
>   }
> 
> I just created enough livepatches with the same source patch so that I
> could reproduce the issue somewhat reliably.
> 
> I'll see if I can make something that uses klp directly.

Ah ok great, I was hoping it was a relatively simply livepatch.  We 
could probably reuse lib/livepatch/test_klp_livepatch.c to do this 
(patching cmdline_proc_show instead).

> The rest of the userspace in the initramfs is really straight forward
> with the only interesting parts being a couple of shell scripts.

Yup.  I'll be on PTO later this week, but I'll see about extracting the 
scripts and building a pile of livepatch .ko's to see how easily it 
reproduces without qemu.

Thanks,

-- Joe
