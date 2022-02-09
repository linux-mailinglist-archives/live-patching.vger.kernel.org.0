Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B661F4AF243
	for <lists+live-patching@lfdr.de>; Wed,  9 Feb 2022 14:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbiBINCc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Feb 2022 08:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233322AbiBINCb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Feb 2022 08:02:31 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B3BC0613CA;
        Wed,  9 Feb 2022 05:02:35 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BEC411F383;
        Wed,  9 Feb 2022 13:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644411753; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VZ0LfFGdQiKl3eiw2xncpOIiQjd52yjFcJ6ct5TXgnc=;
        b=MxoCMoXz+Lpj3qNIfzq2Zw+kuMNga08HH7NObScsZ050PvnVt/HeO7Ewzdd/hL4RoZwsTW
        58MLFv2V5bp8ByEvZFgGJK7/cYJJxDejK/y8GB4Fh0hAz+XgqU2s7vmI/vQ3PgbqrsKNuz
        5uUiAuptUb3hO0NA9wOlYrIsneI/jws=
Received: from suse.cz (pathway.suse.cz [10.100.12.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 952E1A3B83;
        Wed,  9 Feb 2022 13:02:33 +0000 (UTC)
Date:   Wed, 9 Feb 2022 14:02:33 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net, kernel-team@fb.com
Subject: Re: [PATCH v2] livepatch: Skip livepatch tests if ftrace cannot be
 configured
Message-ID: <20220209130233.GB8279@pathway.suse.cz>
References: <20220203233205.1554034-1-void@manifault.com>
 <20220204205625.2628328-1-void@manifault.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204205625.2628328-1-void@manifault.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-02-04 12:56:26, David Vernet wrote:
> livepatch has a set of selftests that are used to validate the behavior of
> the livepatching subsystem.  One of the testcases in the livepatch
> testsuite is test-ftrace.sh, which among other things, validates that
> livepatching gracefully fails when ftrace is disabled.  In the event that
> ftrace cannot be disabled using 'sysctl kernel.ftrace_enabled=0', the test
> will fail later due to it unexpectedly successfully loading the
> test_klp_livepatch module.
> 
> While the livepatch selftests are careful to remove any of the livepatch
> test modules between testcases to avoid this situation, ftrace may still
> fail to be disabled if another trace is active on the system that was
> enabled with FTRACE_OPS_FL_PERMANENT.  For example, any active BPF programs
> that use trampolines will cause this test to fail due to the trampoline
> being implemented with register_ftrace_direct().  The following is an
> example of such a trace:
> 
> tcp_drop (1) R I D      tramp: ftrace_regs_caller+0x0/0x58
> (call_direct_funcs+0x0/0x30)
>         direct-->bpf_trampoline_6442550536_0+0x0/0x1000
> 
> In order to make the test more resilient to system state that is out of its
> control, this patch adds a check to set_ftrace_enabled() to skip the tests
> if the sysctl invocation fails.
> 
> Signed-off-by: David Vernet <void@manifault.com>
> ---
> v2:
>   - Fix typo in newly added comment (s/permament/permanent).
>   - Adjust the location of the added newline to be before the new comment
>     rather than that the end of the function.
>   - Make the failure-path check a bit less brittle by checking for the
>     exact expected string, rather than specifically for "Device or resource
>     busy".
> 
>  tools/testing/selftests/livepatch/functions.sh | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
> index 846c7ed71556..32970324dd7e 100644
> --- a/tools/testing/selftests/livepatch/functions.sh
> +++ b/tools/testing/selftests/livepatch/functions.sh
> @@ -78,6 +78,12 @@ function set_ftrace_enabled() {
>  	result=$(sysctl -q kernel.ftrace_enabled="$1" 2>&1 && \
>  		 sysctl kernel.ftrace_enabled 2>&1)
>  	echo "livepatch: $result" > /dev/kmsg
> +
> +	# Skip the test if ftrace is busy.  This can happen under normal system
> +	# conditions if a trace is marked as permanent.
> +	if [[ "$result" != "kernel.ftrace_enabled = $1" ]]; then
> +		skip "failed to set kernel.ftrace_enabled=$1"
> +	fi
>  }
>  

Hmm, test-ftrace.sh fails with this patch:

localhost:/prace/kernel/linux/tools/testing/selftests/livepatch # ./test-ftrace.sh 
TEST: livepatch interaction with ftrace_enabled sysctl ... SKIP: failed to set kernel.ftrace_enabled=0

This is the dmesg output:

[  436.176433] ===== TEST: livepatch interaction with ftrace_enabled sysctl =====
[  436.186942] livepatch: kernel.ftrace_enabled = 0
[  436.187854] % modprobe test_klp_livepatch
[  436.217657] livepatch: enabling patch 'test_klp_livepatch'
[  436.218467] livepatch: 'test_klp_livepatch': initializing patching transition
[  436.219679] livepatch: failed to register ftrace handler for function 'cmdline_proc_show' (-16)
[  436.221003] livepatch: failed to patch object 'vmlinux'
[  436.221786] livepatch: failed to enable patch 'test_klp_livepatch'
[  436.222716] livepatch: 'test_klp_livepatch': canceling patching transition, going to unpatch
[  436.223955] livepatch: 'test_klp_livepatch': completing unpatching transition
[  436.225476] livepatch: 'test_klp_livepatch': unpatching complete
[  436.273295] modprobe: ERROR: could not insert 'test_klp_livepatch': Device or resource busy
[  436.284522] livepatch: kernel.ftrace_enabled = 1
[  436.305353] % modprobe test_klp_livepatch
[  436.334929] livepatch: enabling patch 'test_klp_livepatch'
[  436.335781] livepatch: 'test_klp_livepatch': initializing patching transition
[  436.338099] livepatch: 'test_klp_livepatch': starting patching transition
[  438.082707] livepatch: 'test_klp_livepatch': completing patching transition
[  438.084106] livepatch: 'test_klp_livepatch': patching complete
[  438.199997] livepatch: sysctl: setting key "kernel.ftrace_enabled": Device or resource busy
[  438.201249] kernel.ftrace_enabled = 1
[  438.201929] SKIP: failed to set kernel.ftrace_enabled=0


The problem is the 2nd "set_ftrace_enabled 0" call in
tools/testing/selftests/livepatch/test-ftrace.sh

It is done when "test_klp_livepatch" is loaded. ftrace could not be
disabled because it is used by the livepatch. It is expected behavior
and the test should succeed in this case.

Best Regards,
Petr
