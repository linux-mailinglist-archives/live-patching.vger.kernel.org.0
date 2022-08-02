Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14165883AF
	for <lists+live-patching@lfdr.de>; Tue,  2 Aug 2022 23:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbiHBVg2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 2 Aug 2022 17:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235808AbiHBVg1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 2 Aug 2022 17:36:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0C511011
        for <live-patching@vger.kernel.org>; Tue,  2 Aug 2022 14:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659476185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dEi6zuW2eihS+VXBOkbyCaV/7jkd+e5kNtj8cL/MyEk=;
        b=eVBFspnSLx8/Mk4njljbDfhmiflxec3glRq/JrV06h9+lKOnsEJd30f6GnRajxpI0GYKcR
        zvshp615D7t667LvyA4iZyK6zqwn0oL/kbbc+lUp6uUUsWuV0WIty8tdKhKF10J3Ru7Ek8
        U4XTfn5k+WwGSaFaUsPaVir4JYWS7e4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-553-aDjzMq8vOp2EP8I-KhRkYw-1; Tue, 02 Aug 2022 17:36:20 -0400
X-MC-Unique: aDjzMq8vOp2EP8I-KhRkYw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 96F7B8032F1;
        Tue,  2 Aug 2022 21:36:19 +0000 (UTC)
Received: from redhat.com (unknown [10.22.18.194])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 386CB40149A8;
        Tue,  2 Aug 2022 21:36:19 +0000 (UTC)
Date:   Tue, 2 Aug 2022 17:36:17 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
        kernel-team@fb.com
Subject: Re: [PATCH v2 2/2] selftests/livepatch: add sysfs test
Message-ID: <YumY0ZFUHG+boLcQ@redhat.com>
References: <20220802010857.3574103-1-song@kernel.org>
 <20220802010857.3574103-3-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802010857.3574103-3-song@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Aug 01, 2022 at 06:08:57PM -0700, Song Liu wrote:
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

Clever grep.  I like to use `head -n100 <pattern>` to dump debugging
filenames and content, but this "grep anything" is nice for one liner
files :)

> +
> +disable_lp $MOD_LIVEPATCH
> +
> +unload_lp $MOD_LIVEPATCH
> +
> +check_result "% modprobe $MOD_LIVEPATCH
> +livepatch: enabling patch '$MOD_LIVEPATCH'
> +livepatch: '$MOD_LIVEPATCH': initializing patching transition
> +livepatch: '$MOD_LIVEPATCH': starting patching transition
> +livepatch: '$MOD_LIVEPATCH': completing patching transition
> +livepatch: '$MOD_LIVEPATCH': patching complete
> +/sys/kernel/livepatch/test_klp_livepatch/enabled:1
> +/sys/kernel/livepatch/test_klp_livepatch/transition:0
> +/sys/kernel/livepatch/test_klp_livepatch/vmlinux/patched:1
> +% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
> +livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
> +livepatch: '$MOD_LIVEPATCH': starting unpatching transition
> +livepatch: '$MOD_LIVEPATCH': completing unpatching transition
> +livepatch: '$MOD_LIVEPATCH': unpatching complete
> +% rmmod $MOD_LIVEPATCH"
> +
> +exit 0
> -- 
> 2.30.2
> 

The patch and test look fine.  I wonder how we'll modify these type of
tests if we can decouple the selftests from the kernel version.  In that
case we may need to individually verify files only if they exist.  The
upside to this version is that it will remind anyone who adds another
file to update the expected check_result value.

Also, I believe Red Hat QE has a few internal tests that verify sysfs
values during transitions, etc.  I'll inquire about those in case we can
follow up with even more sysfs verification.

--
Joe

