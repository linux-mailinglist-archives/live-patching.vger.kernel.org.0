Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D25C02583E
	for <lists+live-patching@lfdr.de>; Tue, 21 May 2019 21:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfEUT2F (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 May 2019 15:28:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40938 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbfEUT2F (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 May 2019 15:28:05 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DF10C81E0E;
        Tue, 21 May 2019 19:27:49 +0000 (UTC)
Received: from [10.18.17.208] (dhcp-17-208.bos.redhat.com [10.18.17.208])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF5E5537AD;
        Tue, 21 May 2019 19:27:47 +0000 (UTC)
Subject: Re: Oops caused by race between livepatch and ftrace
From:   Joe Lawrence <joe.lawrence@redhat.com>
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
 <1802c0d2-702f-08ec-6a85-c7f887eb6d14@redhat.com>
Message-ID: <a2075a5b-e048-4a7b-2813-01ed7e75bde8@redhat.com>
Date:   Tue, 21 May 2019 15:27:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1802c0d2-702f-08ec-6a85-c7f887eb6d14@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 21 May 2019 19:28:00 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 5/20/19 5:19 PM, Joe Lawrence wrote:
> On 5/20/19 5:09 PM, Johannes Erdfelt wrote:
>> On Mon, May 20, 2019, Joe Lawrence <joe.lawrence@redhat.com> wrote:
>>> These two testing scenarios might be interesting to add to our selftests
>>> suite.  Can you post or add the source(s) to livepatch-test<n>.ko to the
>>> tarball?
>>
>> I made the livepatches using kpatch-build and this simple patch:
>>
>> diff --git a/fs/proc/version.c b/fs/proc/version.c
>> index 94901e8e700d..6b8a3449f455 100644
>> --- a/fs/proc/version.c
>> +++ b/fs/proc/version.c
>> @@ -12,6 +12,7 @@ static int version_proc_show(struct seq_file *m, void *v)
>>    		utsname()->sysname,
>>    		utsname()->release,
>>    		utsname()->version);
>> +	seq_printf(m, "example livepatch\n");
>>    	return 0;
>>    }
>>
>> I just created enough livepatches with the same source patch so that I
>> could reproduce the issue somewhat reliably.
>>
>> I'll see if I can make something that uses klp directly.
> 
> Ah ok great, I was hoping it was a relatively simply livepatch.  We
> could probably reuse lib/livepatch/test_klp_livepatch.c to do this
> (patching cmdline_proc_show instead).
> 
>> The rest of the userspace in the initramfs is really straight forward
>> with the only interesting parts being a couple of shell scripts.
> 
> Yup.  I'll be on PTO later this week, but I'll see about extracting the
> scripts and building a pile of livepatch .ko's to see how easily it
> reproduces without qemu.
> 

D'oh -- I just remembered that klp doesn't create those klp (arch) 
relocation sections just yet!  Without those, the window for module RO 
-> RW -> RO in klp_init_object_loaded is going to be really small... at 
least I can't reproduce it yet without those special sections.  So maybe 
such selftests need to wait post klp-convert.


BTW, livepatching folks -- speaking of this window, does it make sense 
for klp_init_object_loaded() to unconditionally frob the module section 
permissions?  Should it only bother iff it's going to apply 
relocations/alternatives/paravirt?

-- Joe
