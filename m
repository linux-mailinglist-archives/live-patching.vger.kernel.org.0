Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 127B56EC68
	for <lists+live-patching@lfdr.de>; Sat, 20 Jul 2019 00:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbfGSWLN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 19 Jul 2019 18:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:59754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727344AbfGSWLN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 19 Jul 2019 18:11:13 -0400
Received: from [172.20.8.67] (fs96f9c61d.tkyc509.ap.nuro.jp [150.249.198.29])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2F9B2184E;
        Fri, 19 Jul 2019 22:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563574273;
        bh=CJKeacO6+Fz48FQ2UIIH5GFAeHwDu2ZUhvMvJNtHMr8=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=yUKUVjeaNhnOIrnJZmdIu4GPHZtiFh7WQX6cQ1itU5EnJgKT7pQSgyUH6HIyHwuyb
         s1rxtfVqOq+ivHoTSMA2xs3/gN3Eckh0ycJg+Tm6Zc4uJLn07tghuV1hMdYioTzyyN
         XoQQ8W1u/MZ0KtdlXWVGxoSuuHS9gbKYtqj18VoM=
Subject: Re: [PATCH] selftests/livepatch: add test skip handling
To:     Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
        shuah <shuah@kernel.org>
References: <20190714142829.29458-1-joe.lawrence@redhat.com>
 <20190714143306.GA29501@redhat.com>
From:   shuah <shuah@kernel.org>
Message-ID: <5535ff5e-0f75-9185-11bb-400465f09f5c@kernel.org>
Date:   Fri, 19 Jul 2019 16:11:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190714143306.GA29501@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 7/14/19 8:33 AM, Joe Lawrence wrote:
> On Sun, Jul 14, 2019 at 10:28:29AM -0400, Joe Lawrence wrote:
>> Before running a livpeatch self-test, first verify that we've built and
>> installed the livepatch self-test kernel modules by running a 'modprobe
>> --dry-run'.  This should catch a few environment issues, including
>> !CONFIG_LIVEPATCH and !CONFIG_TEST_LIVEPATCH.  In these cases, exit
>> gracefully with test-skip status rather than test-fail status.
>>
>> Reported-by: Jiri Benc <jbenc@redhat.com>
>> Suggested-by: Shuah Khan <shuah@kernel.org>
>> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
>> ---
>>   tools/testing/selftests/livepatch/functions.sh | 18 ++++++++++++++++++
>>   .../selftests/livepatch/test-callbacks.sh      |  5 +++++
>>   .../selftests/livepatch/test-livepatch.sh      |  3 +++
>>   .../selftests/livepatch/test-shadow-vars.sh    |  2 ++
>>   4 files changed, 28 insertions(+)
>>
>> diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
>> index 30195449c63c..92d6cfb49365 100644
>> --- a/tools/testing/selftests/livepatch/functions.sh
>> +++ b/tools/testing/selftests/livepatch/functions.sh
>> @@ -13,6 +13,14 @@ function log() {
>>   	echo "$1" > /dev/kmsg
>>   }
>>   
>> +# skip(msg) - testing can't proceed
>> +#	msg - explanation
>> +function skip() {
>> +	log "SKIP: $1"
>> +	echo "SKIP: $1" >&2
>> +	exit 4
>> +}
>> +
>>   # die(msg) - game over, man
>>   #	msg - dying words
>>   function die() {
>> @@ -43,6 +51,16 @@ function loop_until() {
>>   	done
>>   }
>>   
>> +function assert_mod() {
>> +	local mod="$1"
>> +
>> +	if ! modprobe --dry-run "$mod" &>/dev/null ; then
>> +		skip "Failed modprobe --dry-run of module: $mod"
>> +	fi
>> +
>> +	return 1
>> +}
>> +
>>   function is_livepatch_mod() {
>>   	local mod="$1"
>>   
>> diff --git a/tools/testing/selftests/livepatch/test-callbacks.sh b/tools/testing/selftests/livepatch/test-callbacks.sh
>> index e97a9dcb73c7..87a407cee7fd 100755
>> --- a/tools/testing/selftests/livepatch/test-callbacks.sh
>> +++ b/tools/testing/selftests/livepatch/test-callbacks.sh
>> @@ -9,6 +9,11 @@ MOD_LIVEPATCH2=test_klp_callbacks_demo2
>>   MOD_TARGET=test_klp_callbacks_mod
>>   MOD_TARGET_BUSY=test_klp_callbacks_busy
>>   
>> +assert_mod $MOD_LIVEPATCH
>> +assert_mod $MOD_LIVEPATCH2
>> +assert_mod $MOD_TARGET
>> +assert_mod $MOD_TARGET_BUSY
>> +
>>   set_dynamic_debug
>>   
>>   
>> diff --git a/tools/testing/selftests/livepatch/test-livepatch.sh b/tools/testing/selftests/livepatch/test-livepatch.sh
>> index f05268aea859..8d3b75ceeeff 100755
>> --- a/tools/testing/selftests/livepatch/test-livepatch.sh
>> +++ b/tools/testing/selftests/livepatch/test-livepatch.sh
>> @@ -7,6 +7,9 @@
>>   MOD_LIVEPATCH=test_klp_livepatch
>>   MOD_REPLACE=test_klp_atomic_replace
>>   
>> +assert_mod $MOD_LIVEPATCH
>> +assert_mod $MOD_REPLACE
>> +
>>   set_dynamic_debug
>>   
>>   
>> diff --git a/tools/testing/selftests/livepatch/test-shadow-vars.sh b/tools/testing/selftests/livepatch/test-shadow-vars.sh
>> index 04a37831e204..1ab09bc50363 100755
>> --- a/tools/testing/selftests/livepatch/test-shadow-vars.sh
>> +++ b/tools/testing/selftests/livepatch/test-shadow-vars.sh
>> @@ -6,6 +6,8 @@
>>   
>>   MOD_TEST=test_klp_shadow_vars
>>   
>> +assert_mod $MOD_TEST
>> +
>>   set_dynamic_debug
>>   
>>   
>> -- 
>> 2.21.0
>>
> 
> Testing:
> 
> Here's the output if modprobe --dry-run doesn't like the modules (not
> built, etc.):
> 
>    TAP version 13
>    selftests: livepatch: test-livepatch.sh
>    ========================================
>    SKIP: Failed modprobe --dry-run of module: test_klp_livepatch
>    not ok 1..1 selftests: livepatch: test-livepatch.sh [SKIP]
>    selftests: livepatch: test-callbacks.sh
>    ========================================
>    SKIP: Failed modprobe --dry-run of module: test_klp_callbacks_demo
>    not ok 1..2 selftests: livepatch: test-callbacks.sh [SKIP]
>    selftests: livepatch: test-shadow-vars.sh
>    ========================================
>    SKIP: Failed modprobe --dry-run of module: test_klp_shadow_vars
>    not ok 1..3 selftests: livepatch: test-shadow-vars.sh [SKIP]
> 
> We could fold assert_mod() into __load_mod() if folks perfer.  I
> don't have strong opinion either way.
> 

Please refine these messages to say what users should do. In addition
to what failed, also add what is missing - enable config option etc.

thanks,
-- Shuah

