Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA7E4B119B
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 16:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243582AbiBJPXY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 10:23:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243585AbiBJPXT (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 10:23:19 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAE7CF1;
        Thu, 10 Feb 2022 07:23:19 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id AB4C91F391;
        Thu, 10 Feb 2022 15:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1644506598; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u9yiWpL3QTdWtKRF1nIK3pxOJWeowc9+eKgRGgx1SLQ=;
        b=CbK8UkeiMD5ZYFXUtL+pogEW8gtYKkyBQL8Vjp5YV8aPOuYmrzB85suypw0QXAmXg+O4w9
        B7CfjE9YJa/48erYX2qsxj7VQa19qUHlsW0IB3jdDKSigijmPFOyqp2Fm3SzPd4ew4/2V0
        ZDLoRQ5wdETVFhp4dzsu/r9C5cSS1Qg=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7779AA3B88;
        Thu, 10 Feb 2022 15:23:18 +0000 (UTC)
Date:   Thu, 10 Feb 2022 16:23:15 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net, kernel-team@fb.com
Subject: Re: [PATCH v2] livepatch: Skip livepatch tests if ftrace cannot be
 configured
Message-ID: <YgUt4+XGLOB4+0H3@alley>
References: <20220203233205.1554034-1-void@manifault.com>
 <20220204205625.2628328-1-void@manifault.com>
 <20220209130233.GB8279@pathway.suse.cz>
 <20220209154934.5w5k5tqcqldbfjt3@dev0025.ash9.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209154934.5w5k5tqcqldbfjt3@dev0025.ash9.facebook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-02-09 07:49:34, David Vernet wrote:
> On Wed, Feb 09, 2022 at 02:02:33PM +0100, Petr Mladek wrote:
> > Hmm, test-ftrace.sh fails with this patch:
> > 
> > localhost:/prace/kernel/linux/tools/testing/selftests/livepatch # ./test-ftrace.sh 
> > TEST: livepatch interaction with ftrace_enabled sysctl ... SKIP: failed to set kernel.ftrace_enabled=0
> > 
> > This is the dmesg output:
> > 
> > [  436.176433] ===== TEST: livepatch interaction with ftrace_enabled sysctl =====
> > [  436.186942] livepatch: kernel.ftrace_enabled = 0
> > [  436.187854] % modprobe test_klp_livepatch
> > [  436.217657] livepatch: enabling patch 'test_klp_livepatch'
> > [  436.218467] livepatch: 'test_klp_livepatch': initializing patching transition
> > [  436.219679] livepatch: failed to register ftrace handler for function 'cmdline_proc_show' (-16)
> > [  436.221003] livepatch: failed to patch object 'vmlinux'
> > [  436.221786] livepatch: failed to enable patch 'test_klp_livepatch'
> > [  436.222716] livepatch: 'test_klp_livepatch': canceling patching transition, going to unpatch
> > [  436.223955] livepatch: 'test_klp_livepatch': completing unpatching transition
> > [  436.225476] livepatch: 'test_klp_livepatch': unpatching complete
> > [  436.273295] modprobe: ERROR: could not insert 'test_klp_livepatch': Device or resource busy
> > [  436.284522] livepatch: kernel.ftrace_enabled = 1
> > [  436.305353] % modprobe test_klp_livepatch
> > [  436.334929] livepatch: enabling patch 'test_klp_livepatch'
> > [  436.335781] livepatch: 'test_klp_livepatch': initializing patching transition
> > [  436.338099] livepatch: 'test_klp_livepatch': starting patching transition
> > [  438.082707] livepatch: 'test_klp_livepatch': completing patching transition
> > [  438.084106] livepatch: 'test_klp_livepatch': patching complete
> > [  438.199997] livepatch: sysctl: setting key "kernel.ftrace_enabled": Device or resource busy
> > [  438.201249] kernel.ftrace_enabled = 1
> > [  438.201929] SKIP: failed to set kernel.ftrace_enabled=0
> > 
> > 
> > The problem is the 2nd "set_ftrace_enabled 0" call in
> > tools/testing/selftests/livepatch/test-ftrace.sh
> > 
> > It is done when "test_klp_livepatch" is loaded. ftrace could not be
> > disabled because it is used by the livepatch. It is expected behavior
> > and the test should succeed in this case.
> 
> Ah, I missed this because in my configuration I was expecting the test to
> be skipped. What do we think is the preferred alternative?  Perhaps we
> could add an optional argument to set_trace_enabled() that specifies the
> expected value of kernel.ftrace_enabled after invoking sysctl?
> 
> What do you think of something like this:
> 
> +
> +	if [[ "$result" != "kernel.ftrace_enabled = $1" ]]; then
> +		if [[ -z "$2" || "$2" == "$1" ]]; then

Hmm, the check "$2" == "$1" is strange and pretty confusing.

It would be better to use "$result" == "$2" except that "$result"
includes also the variable name.

> +			skip "failed to set kernel.ftrace_enabled=$1"
> +		fi
> +	elif [[ -n "$2" && "$2" != "$1" ]]; then
> +		die "Unexpectedly set kernel.ftrace_enabled=$1"
> +	fi

This looks too paranoid to me. But I do not have strong opinion.

> test-ftrace.sh could then specify 'set_ftrace_enabled 0 1' when validating
> that ftrace can't be disabled when it's being used by livepatch.  Not sure
> if it makes sense to use skip() in the first case and die() in the latter
> case, but being able to unexpectedly set kernel.ftrace_enabled seems more
> problematic and within the control of the test than not being able to set
> it. I could also just leave off the elif case as it's not needed for the
> test suite as it exists today, but I think it makes the
> set_ftrace_enabled() API more consistent and intuitive.

OK, what about the following change:

   1. Store only the value (number) in $result
   2. Add optional --fail parameter

Hmm, the 1st step is not needed after several iterations here ;-)
Anyway, it should be easier to maintain it in the long term when the
sysctl output might change. We should probably do it in a separate patch.


diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 846c7ed71556..7b624d0fd7c0 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -75,9 +75,25 @@ function set_dynamic_debug() {
 }
 
 function set_ftrace_enabled() {
-	result=$(sysctl -q kernel.ftrace_enabled="$1" 2>&1 && \
-		 sysctl kernel.ftrace_enabled 2>&1)
-	echo "livepatch: $result" > /dev/kmsg
+	can_fail=0
+	if [[ "$1" == "--fail" ]] ; then
+		can_fail=1
+		shift
+	fi
+
+	err=$(sysctl -q kernel.ftrace_enabled="$1" 2>&1)
+	result=$(sysctl --values kernel.ftrace_enabled)
+
+	if [[ "$result" != "$1" ]] ; then
+		if [[ $can_fail -eq 1 ]] ; then
+			echo "livepatch: $err" > /dev/kmsg
+			return
+		fi
+
+		skip "failed to set kernel.ftrace_enabled = $1"
+	fi
+
+	echo "livepatch: kernel.ftrace_enabled = $result" > /dev/kmsg
 }
 
 function cleanup() {
diff --git a/tools/testing/selftests/livepatch/test-ftrace.sh b/tools/testing/selftests/livepatch/test-ftrace.sh
index 552e165512f4..825540a5194d 100755
--- a/tools/testing/selftests/livepatch/test-ftrace.sh
+++ b/tools/testing/selftests/livepatch/test-ftrace.sh
@@ -25,7 +25,8 @@ if [[ "$(cat /proc/cmdline)" != "$MOD_LIVEPATCH: this has been live patched" ]]
 	die "livepatch kselftest(s) failed"
 fi
 
-set_ftrace_enabled 0
+# Check that ftrace could not get disabled when a livepatch is enabled
+set_ftrace_enabled --fail 0
 if [[ "$(cat /proc/cmdline)" != "$MOD_LIVEPATCH: this has been live patched" ]] ; then
 	echo -e "FAIL\n\n"
 	die "livepatch kselftest(s) failed"



Best Regards,
Petr
