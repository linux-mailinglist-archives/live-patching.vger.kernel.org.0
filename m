Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA2AD7762
	for <lists+live-patching@lfdr.de>; Tue, 15 Oct 2019 15:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731936AbfJONZs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Oct 2019 09:25:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35280 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728372AbfJONZs (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Oct 2019 09:25:48 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7FBAF306F4AE;
        Tue, 15 Oct 2019 13:25:47 +0000 (UTC)
Received: from [10.18.17.119] (dhcp-17-119.bos.redhat.com [10.18.17.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FFE46012E;
        Tue, 15 Oct 2019 13:25:46 +0000 (UTC)
Subject: Re: [PATCH v2] ftrace: Introduce PERMANENT ftrace_ops flag
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     rostedt@goodmis.org, mingo@redhat.com, jpoimboe@redhat.com,
        jikos@kernel.org, pmladek@suse.com, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
References: <20191014105923.29607-1-mbenes@suse.cz>
 <20191014223100.GA16608@redhat.com>
 <alpine.LSU.2.21.1910151259220.30206@pobox.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <f82e57ce-f33f-4ace-514e-75fcba42b5ba@redhat.com>
Date:   Tue, 15 Oct 2019 09:25:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.1910151259220.30206@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Tue, 15 Oct 2019 13:25:47 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 10/15/19 7:23 AM, Miroslav Benes wrote:
>> Hi Miroslav,
>>
>> Maybe we should add a test to verify this new behavior?  See sample
>> version below (lightly tested).  We can add to this one, or patch
>> seperately if you prefer.
> 
> Thanks a lot, Joe. It looks nice. I'll include it in v3. One question
> below.
>   
>> -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--
>>
>>   
>> >From c8c9f22e3816ca4c90ab7e7159d2ce536eaa5fad Mon Sep 17 00:00:00 2001
>> From: Joe Lawrence <joe.lawrence@redhat.com>
>> Date: Mon, 14 Oct 2019 18:25:01 -0400
>> Subject: [PATCH] selftests/livepatch: test interaction with ftrace_enabled
>>
>> Since livepatching depends upon ftrace handlers to implement "patched"
>> functionality, verify that the ftrace_enabled sysctl value interacts
>> with livepatch registration as expected.
>>
>> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
>> ---
>>   tools/testing/selftests/livepatch/Makefile    |  3 +-
>>   .../testing/selftests/livepatch/functions.sh  | 18 +++++
>>   .../selftests/livepatch/test-ftrace.sh        | 65 +++++++++++++++++++
>>   3 files changed, 85 insertions(+), 1 deletion(-)
>>   create mode 100755 tools/testing/selftests/livepatch/test-ftrace.sh
>>
>> diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
>> index fd405402c3ff..1886d9d94b88 100644
>> --- a/tools/testing/selftests/livepatch/Makefile
>> +++ b/tools/testing/selftests/livepatch/Makefile
>> @@ -4,6 +4,7 @@ TEST_PROGS_EXTENDED := functions.sh
>>   TEST_PROGS := \
>>   	test-livepatch.sh \
>>   	test-callbacks.sh \
>> -	test-shadow-vars.sh
>> +	test-shadow-vars.sh \
>> +	test-ftrace.sh
>>   
>>   include ../lib.mk
>> diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
>> index 79b0affd21fb..556252efece0 100644
>> --- a/tools/testing/selftests/livepatch/functions.sh
>> +++ b/tools/testing/selftests/livepatch/functions.sh
>> @@ -52,6 +52,24 @@ function set_dynamic_debug() {
>>   		EOF
>>   }
>>   
>> +function push_ftrace_enabled() {
>> +	FTRACE_ENABLED=$(sysctl --values kernel.ftrace_enabled)
>> +}
> 
> Shouldn't we call push_ftrace_enabled() somewhere at the beginning of the
> test script? set_dynamic_debug() calls its push_dynamic_debug() directly,
> but set_ftrace_enabled() is different, because it is called more than once
> in the script.
> 
> One could argue that ftrace_enabled has to be true at the beginning of
> testing anyway, but I think it would be cleaner. Btw, we should probably
> guarantee that ftrace_enabled is true when livepatch selftests are
> invoked.
> 

Ah yes, that occurred to me while creating that piece of the patch. 
Something like setup_test_config() that pushes both ftrace and the 
debugfs, etc. would be cleaner for all scripts.  If you're onboard with 
that idea, I can make that revision.

-- Joe
