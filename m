Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727975AB5B1
	for <lists+live-patching@lfdr.de>; Fri,  2 Sep 2022 17:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237390AbiIBPwC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 2 Sep 2022 11:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237385AbiIBPvq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 2 Sep 2022 11:51:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60236FBA53
        for <live-patching@vger.kernel.org>; Fri,  2 Sep 2022 08:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662133338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iNFDMob7oeqm8W1LCJzHM8bieeKNjOX+wSS0YrSJlRA=;
        b=aKUtJCQ/rzFOmU+ODt7KdgD0CSENEst3vZc5L6T7DQwzrltfAAcNQSh5PgEJdLO7G/hi8z
        KN9o4QDfp76C08bzXL8tBOdbDNxrR1A7o313sxMn5u85cXOF3aV81uGRAgDFCrc6RxJfUB
        QwpJ5DISHTE8SiliGtPbcx8J9Qz49h8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-412-OS0mDKjnOwu92ya0fih0XA-1; Fri, 02 Sep 2022 11:42:15 -0400
X-MC-Unique: OS0mDKjnOwu92ya0fih0XA-1
Received: by mail-qv1-f72.google.com with SMTP id y5-20020a056214016500b004992ae3b0c2so1502067qvs.22
        for <live-patching@vger.kernel.org>; Fri, 02 Sep 2022 08:42:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:subject:from:references:cc:to
         :x-gm-message-state:from:to:cc:subject:date;
        bh=iNFDMob7oeqm8W1LCJzHM8bieeKNjOX+wSS0YrSJlRA=;
        b=vZF15ROmEN79bd7b+01sKNSyIf41fbj7yEZ+mbyKicEIGIdTqN7A+v5Wda7rLeQpsV
         LnaJwcqYyrpPIIJ1w9dsNDDuhKMuuyluWlugvibYMrVmev//LtvnbD8e6Cx3IiXuE7sd
         U+2jIsJfyQGHvKxLvkTzff+GiEIMECU2ZjGkGbUkf/IR42gYaWfanFFNHwZ8eTtBkffc
         6ja7I9+ecf39I7pMicmTskFYxU4bqEsvNDtf34COlG/dIs0OAxi/8t1ZeOBsWxeg5pnr
         ipeCRSxQkDZq3sEFvpxhlP3LUIgA14HwGz19/HI3DCmIFP0JlWhJ0C8qtnj9wzvL8XyO
         uxtg==
X-Gm-Message-State: ACgBeo1prHaj4xdxeCN8sBO5ROavg9c8L56TRgU+QD1vzGc9THbAuGau
        MIkLDTFVDP+9+ZHqyGC8wgHCzok41pt478iMduXmDCSs6tA5X8tWW62H0jcHX/x4Yk48JgIHYXr
        ubMjHvi/Vo9FwlALeviszNtix1w==
X-Received: by 2002:a05:620a:2605:b0:6ba:a981:50ae with SMTP id z5-20020a05620a260500b006baa98150aemr23994706qko.115.1662133335128;
        Fri, 02 Sep 2022 08:42:15 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7kmSEJnLai6QSZWo3s6gTeUnhlLJlx3kK969zexu2ASZUkyYCEOtt56k61uQZf+5vVJPxnvw==
X-Received: by 2002:a05:620a:2605:b0:6ba:a981:50ae with SMTP id z5-20020a05620a260500b006baa98150aemr23994690qko.115.1662133334843;
        Fri, 02 Sep 2022 08:42:14 -0700 (PDT)
Received: from [192.168.1.9] (pool-68-160-135-240.bstnma.fios.verizon.net. [68.160.135.240])
        by smtp.gmail.com with ESMTPSA id fy9-20020a05622a5a0900b0034359fc348fsm1218407qtb.73.2022.09.02.08.42.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 08:42:14 -0700 (PDT)
To:     Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, mbenes@suse.cz, kernel-team@fb.com
References: <20220802010857.3574103-1-song@kernel.org>
 <20220802010857.3574103-3-song@kernel.org>
 <20220902123719.GB25533@pathway.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH v2 2/2] selftests/livepatch: add sysfs test
Message-ID: <8ff51efb-ee7a-f3ba-6391-081d52d800cc@redhat.com>
Date:   Fri, 2 Sep 2022 11:42:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220902123719.GB25533@pathway.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 9/2/22 8:37 AM, Petr Mladek wrote:
> On Mon 2022-08-01 18:08:57, Song Liu wrote:
>> Add a test for livepatch sysfs entries.
>>
>> Signed-off-by: Song Liu <song@kernel.org>
>> ---
>>  tools/testing/selftests/livepatch/Makefile    |  3 +-
>>  .../testing/selftests/livepatch/test-sysfs.sh | 40 +++++++++++++++++++
>>  2 files changed, 42 insertions(+), 1 deletion(-)
>>  create mode 100755 tools/testing/selftests/livepatch/test-sysfs.sh
>>
>> diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
>> index 1acc9e1fa3fb..02fadc9d55e0 100644
>> --- a/tools/testing/selftests/livepatch/Makefile
>> +++ b/tools/testing/selftests/livepatch/Makefile
>> @@ -6,7 +6,8 @@ TEST_PROGS := \
>>  	test-callbacks.sh \
>>  	test-shadow-vars.sh \
>>  	test-state.sh \
>> -	test-ftrace.sh
>> +	test-ftrace.sh \
>> +	test-sysfs.sh
>>  
>>  TEST_FILES := settings
>>  
>> diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
>> new file mode 100755
>> index 000000000000..eb4a69ba1c2c
>> --- /dev/null
>> +++ b/tools/testing/selftests/livepatch/test-sysfs.sh
>> @@ -0,0 +1,40 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (C) 2022 Song Liu <song@kernel.org>
>> +
>> +. $(dirname $0)/functions.sh
>> +
>> +MOD_LIVEPATCH=test_klp_livepatch
>> +
>> +setup_config
>> +
>> +# - load a livepatch and verifies the sysfs entries work as expected
>> +
>> +start_test "sysfs test"
>> +
>> +load_lp $MOD_LIVEPATCH
>> +
>> +grep . "/sys/kernel/livepatch/$MOD_LIVEPATCH"/* > /dev/kmsg
>> +grep . "/sys/kernel/livepatch/$MOD_LIVEPATCH"/*/* > /dev/kmsg
>> +
> 
> I see the following when I run the test:
> 
> host:kernel/linux/tools/testing/selftests/livepatch # ./test-sysfs.sh 
> TEST: sysfs test ... grep: /sys/kernel/livepatch/test_klp_livepatch/force: Permission denied
> grep: /sys/kernel/livepatch/test_klp_livepatch/vmlinux: Is a directory
> grep: /sys/kernel/livepatch/test_klp_livepatch/vmlinux/cmdline_proc_show,1: Is a directory
> ok
> 
> The errors are expected. A solution would be to redirect 2>&1 or
> 2>/dev/null. Both looks a bit ugly to me.
> 
> Instead, I would suggest to create some helper scripts in functions.sh,
> for example:
> 

I realize this was just a code sketch, but a few ideas before
copy/pasting the functions :)

> # check_sysfs_exists(modname, rel_path, expected_rights) - check sysfs interface

# check_sysfs_rights(modname, rel_path, expected_rights) - check sysfs
path permissions

> #	modname - livepatch module creating the sysfs interface
> #	rel_patch - relative patch of the sysfs interface

s/patch/path

> #	expected_rights - expected access rights
> function check_sysfs_rights() {
> 	local mod="$1"; shift
> 	local rel_path="$1"; shift
> 	local expected_rights="$1"; shift
> 
> 	local path="$KLP_SYSFS_DIR/$mod/$rel_path"

Checking for existence here might be cleaner than failing later.  Unless
the caller is going to do it first.  Or should we just have a
check_sysfs_exists() like your function comments hint at?

> 	local rights=`ls -l -d $path | cut -d " " -f 1`

$(/bin/stat --format '%A' "$path") easier?

> 
> 	if test "$rights" != "$expected_rights" ; then
> 	    die "Unexpected access rights of $path: $expected_rights vs. $rights"
> 	fi
> }
> 
> # check_sysfs_exists(modname, rel_path, expected_value) - check sysfs interface

# check_sysfs_value(modname, rel_path, expected_value) - check sysfs value

> #	modname - livepatch module creating the sysfs interface
> #	rel_patch - relative patch of the sysfs interface

s/patch/path

> #	expected_value - expected value read from the file
> function check_sysfs_value() {
> 	local mod="$1"; shift
> 	local rel_path="$1"; shift
> 	local expected_value="$1"; shift
> 
> 	local path="$KLP_SYSFS_DIR/$mod/$rel_path"
> 	local value=`cat $path`
> 
> 	if test "$value" != "$expected_value" ; then
> 	    die "Unexpected value in $path: $expected_value vs. $value"
> 	fi
> }
> 
> It would allow to create a fine tuned tests, for example:
> 
> check_sysfs_rights "$MOD_LIVEPATCH" "" "drwxr-xr-x"
> check_sysfs_rights "$MOD_LIVEPATCH" "enabled" "-rw-r--r--"
> 
> check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"
> 
> 
> 
> Also it would be great to test that the "patched" value is "0"
> when the object is not patched. I would require to create
> a test module that might be livepatched. I mean something like:
> 
> 
> check_sysfs_value  $MOD_LIVEPATCH "$TEST_MODULE/patched" "0"
> load_mod $TEST_MODULE
> check_sysfs_value  $MOD_LIVEPATCH "$TEST_MODULE/patched" "1"
> unload_mod $TEST_MODULE
> check_sysfs_value  $MOD_LIVEPATCH "$TEST_MODULE/patched" "0"
> 
> 

Yes, these helpers would be nice to have to better verify the sysfs
structure and values.

Regards,
-- 
Joe

