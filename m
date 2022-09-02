Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474CE5AB2F4
	for <lists+live-patching@lfdr.de>; Fri,  2 Sep 2022 16:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238781AbiIBOGh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 2 Sep 2022 10:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238206AbiIBOGR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 2 Sep 2022 10:06:17 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32563876AA
        for <live-patching@vger.kernel.org>; Fri,  2 Sep 2022 06:34:15 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 70CC6345D3;
        Fri,  2 Sep 2022 12:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662122239; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EGJWJn3IGyq8WjqN2lvAPknyamgbZiziM4Y05ZJvNQs=;
        b=ScFhwjMN1RmaJNfng9zUHS1UDx21Tdcg7Y/6ibm5iu1r4iSMNYgrn0YYP34WQWb2ZxTI5K
        pbZThrUNYpSv2LrH7QNIwaUm5f+5qoWhPaTh/riILClXWrhT4hWMiIBvD/hZxl6evxvXnn
        Mkg2KgL5cxvf6G8xGGsMot0QKW4Gr2M=
Received: from suse.cz (pathway.suse.cz [10.100.12.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 517292C141;
        Fri,  2 Sep 2022 12:37:19 +0000 (UTC)
Date:   Fri, 2 Sep 2022 14:37:19 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com,
        kernel-team@fb.com
Subject: Re: [PATCH v2 2/2] selftests/livepatch: add sysfs test
Message-ID: <20220902123719.GB25533@pathway.suse.cz>
References: <20220802010857.3574103-1-song@kernel.org>
 <20220802010857.3574103-3-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802010857.3574103-3-song@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-08-01 18:08:57, Song Liu wrote:
> Add a test for livepatch sysfs entries.
> 
> Signed-off-by: Song Liu <song@kernel.org>
> ---
>  tools/testing/selftests/livepatch/Makefile    |  3 +-
>  .../testing/selftests/livepatch/test-sysfs.sh | 40 +++++++++++++++++++
>  2 files changed, 42 insertions(+), 1 deletion(-)
>  create mode 100755 tools/testing/selftests/livepatch/test-sysfs.sh
> 
> diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
> index 1acc9e1fa3fb..02fadc9d55e0 100644
> --- a/tools/testing/selftests/livepatch/Makefile
> +++ b/tools/testing/selftests/livepatch/Makefile
> @@ -6,7 +6,8 @@ TEST_PROGS := \
>  	test-callbacks.sh \
>  	test-shadow-vars.sh \
>  	test-state.sh \
> -	test-ftrace.sh
> +	test-ftrace.sh \
> +	test-sysfs.sh
>  
>  TEST_FILES := settings
>  
> diff --git a/tools/testing/selftests/livepatch/test-sysfs.sh b/tools/testing/selftests/livepatch/test-sysfs.sh
> new file mode 100755
> index 000000000000..eb4a69ba1c2c
> --- /dev/null
> +++ b/tools/testing/selftests/livepatch/test-sysfs.sh
> @@ -0,0 +1,40 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2022 Song Liu <song@kernel.org>
> +
> +. $(dirname $0)/functions.sh
> +
> +MOD_LIVEPATCH=test_klp_livepatch
> +
> +setup_config
> +
> +# - load a livepatch and verifies the sysfs entries work as expected
> +
> +start_test "sysfs test"
> +
> +load_lp $MOD_LIVEPATCH
> +
> +grep . "/sys/kernel/livepatch/$MOD_LIVEPATCH"/* > /dev/kmsg
> +grep . "/sys/kernel/livepatch/$MOD_LIVEPATCH"/*/* > /dev/kmsg
> +

I see the following when I run the test:

host:kernel/linux/tools/testing/selftests/livepatch # ./test-sysfs.sh 
TEST: sysfs test ... grep: /sys/kernel/livepatch/test_klp_livepatch/force: Permission denied
grep: /sys/kernel/livepatch/test_klp_livepatch/vmlinux: Is a directory
grep: /sys/kernel/livepatch/test_klp_livepatch/vmlinux/cmdline_proc_show,1: Is a directory
ok

The errors are expected. A solution would be to redirect 2>&1 or
2>/dev/null. Both looks a bit ugly to me.

Instead, I would suggest to create some helper scripts in functions.sh,
for example:

# check_sysfs_exists(modname, rel_path, expected_rights) - check sysfs interface
#	modname - livepatch module creating the sysfs interface
#	rel_patch - relative patch of the sysfs interface
#	expected_rights - expected access rights
function check_sysfs_rights() {
	local mod="$1"; shift
	local rel_path="$1"; shift
	local expected_rights="$1"; shift

	local path="$KLP_SYSFS_DIR/$mod/$rel_path"
	local rights=`ls -l -d $path | cut -d " " -f 1`

	if test "$rights" != "$expected_rights" ; then
	    die "Unexpected access rights of $path: $expected_rights vs. $rights"
	fi
}

# check_sysfs_exists(modname, rel_path, expected_value) - check sysfs interface
#	modname - livepatch module creating the sysfs interface
#	rel_patch - relative patch of the sysfs interface
#	expected_value - expected value read from the file
function check_sysfs_value() {
	local mod="$1"; shift
	local rel_path="$1"; shift
	local expected_value="$1"; shift

	local path="$KLP_SYSFS_DIR/$mod/$rel_path"
	local value=`cat $path`

	if test "$value" != "$expected_value" ; then
	    die "Unexpected value in $path: $expected_value vs. $value"
	fi
}

It would allow to create a fine tuned tests, for example:

check_sysfs_rights "$MOD_LIVEPATCH" "" "drwxr-xr-x"
check_sysfs_rights "$MOD_LIVEPATCH" "enabled" "-rw-r--r--"

check_sysfs_value  "$MOD_LIVEPATCH" "enabled" "1"



Also it would be great to test that the "patched" value is "0"
when the object is not patched. I would require to create
a test module that might be livepatched. I mean something like:


check_sysfs_value  $MOD_LIVEPATCH "$TEST_MODULE/patched" "0"
load_mod $TEST_MODULE
check_sysfs_value  $MOD_LIVEPATCH "$TEST_MODULE/patched" "1"
unload_mod $TEST_MODULE
check_sysfs_value  $MOD_LIVEPATCH "$TEST_MODULE/patched" "0"


Best Regards,
Petr
