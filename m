Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94876D6BB2
	for <lists+live-patching@lfdr.de>; Tue, 15 Oct 2019 00:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387502AbfJNWdv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 14 Oct 2019 18:33:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730369AbfJNWbF (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 14 Oct 2019 18:31:05 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3721B18C8921;
        Mon, 14 Oct 2019 22:31:03 +0000 (UTC)
Received: from redhat.com (ovpn-124-23.rdu2.redhat.com [10.10.124.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 195BA19C68;
        Mon, 14 Oct 2019 22:31:02 +0000 (UTC)
Date:   Mon, 14 Oct 2019 18:31:00 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     rostedt@goodmis.org, mingo@redhat.com, jpoimboe@redhat.com,
        jikos@kernel.org, pmladek@suse.com, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: Introduce PERMANENT ftrace_ops flag
Message-ID: <20191014223100.GA16608@redhat.com>
References: <20191014105923.29607-1-mbenes@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014105923.29607-1-mbenes@suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.70]); Mon, 14 Oct 2019 22:31:03 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Oct 14, 2019 at 12:59:23PM +0200, Miroslav Benes wrote:
> Livepatch uses ftrace for redirection to new patched functions. It means
> that if ftrace is disabled, all live patched functions are disabled as
> well. Toggling global 'ftrace_enabled' sysctl thus affect it directly.
> It is not a problem per se, because only administrator can set sysctl
> values, but it still may be surprising.
> 
> Introduce PERMANENT ftrace_ops flag to amend this. If the
> FTRACE_OPS_FL_PERMANENT is set on any ftrace ops, the tracing cannot be
> disabled by disabling ftrace_enabled. Equally, a callback with the flag
> set cannot be registered if ftrace_enabled is disabled.
> 
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> ---
> v1->v2:
> - different logic, proposed by Joe Lawrence
> 
> Two things I am not sure about much:
> 
> - return codes. I chose EBUSY, because it seemed the least
>   inappropriate. I usually pick the wrong one, so suggestions are
>   welcome.
> - I did not add any pr_* reporting the problem to make it consistent
>   with the existing code.
> 
>  Documentation/trace/ftrace-uses.rst |  8 ++++++++
>  Documentation/trace/ftrace.rst      |  4 +++-
>  include/linux/ftrace.h              |  3 +++
>  kernel/livepatch/patch.c            |  3 ++-
>  kernel/trace/ftrace.c               | 23 +++++++++++++++++++++--
>  5 files changed, 37 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/trace/ftrace-uses.rst b/Documentation/trace/ftrace-uses.rst
> index 1fbc69894eed..740bd0224d35 100644
> --- a/Documentation/trace/ftrace-uses.rst
> +++ b/Documentation/trace/ftrace-uses.rst
> @@ -170,6 +170,14 @@ FTRACE_OPS_FL_RCU
>  	a callback may be executed and RCU synchronization will not protect
>  	it.
>  
> +FTRACE_OPS_FL_PERMANENT
> +        If this is set on any ftrace ops, then the tracing cannot disabled by
> +        writing 0 to the proc sysctl ftrace_enabled. Equally, a callback with
> +        the flag set cannot be registered if ftrace_enabled is 0.
> +
> +        Livepatch uses it not to lose the function redirection, so the system
> +        stays protected.
> +
>  
>  Filtering which functions to trace
>  ==================================
> diff --git a/Documentation/trace/ftrace.rst b/Documentation/trace/ftrace.rst
> index e3060eedb22d..d2b5657ed33e 100644
> --- a/Documentation/trace/ftrace.rst
> +++ b/Documentation/trace/ftrace.rst
> @@ -2976,7 +2976,9 @@ Note, the proc sysctl ftrace_enable is a big on/off switch for the
>  function tracer. By default it is enabled (when function tracing is
>  enabled in the kernel). If it is disabled, all function tracing is
>  disabled. This includes not only the function tracers for ftrace, but
> -also for any other uses (perf, kprobes, stack tracing, profiling, etc).
> +also for any other uses (perf, kprobes, stack tracing, profiling, etc). It
> +cannot be disabled if there is a callback with FTRACE_OPS_FL_PERMANENT set
> +registered.
>  
>  Please disable this with care.
>  
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index 8a8cb3c401b2..c2cad29dc557 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -142,6 +142,8 @@ ftrace_func_t ftrace_ops_get_func(struct ftrace_ops *ops);
>   * PID     - Is affected by set_ftrace_pid (allows filtering on those pids)
>   * RCU     - Set when the ops can only be called when RCU is watching.
>   * TRACE_ARRAY - The ops->private points to a trace_array descriptor.
> + * PERMAMENT - Set when the ops is permanent and should not be affected by
> + *             ftrace_enabled.
>   */
>  enum {
>  	FTRACE_OPS_FL_ENABLED			= 1 << 0,
> @@ -160,6 +162,7 @@ enum {
>  	FTRACE_OPS_FL_PID			= 1 << 13,
>  	FTRACE_OPS_FL_RCU			= 1 << 14,
>  	FTRACE_OPS_FL_TRACE_ARRAY		= 1 << 15,
> +	FTRACE_OPS_FL_PERMANENT                 = 1 << 16,
>  };
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE
> diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
> index bd43537702bd..b552cf2d85f8 100644
> --- a/kernel/livepatch/patch.c
> +++ b/kernel/livepatch/patch.c
> @@ -196,7 +196,8 @@ static int klp_patch_func(struct klp_func *func)
>  		ops->fops.func = klp_ftrace_handler;
>  		ops->fops.flags = FTRACE_OPS_FL_SAVE_REGS |
>  				  FTRACE_OPS_FL_DYNAMIC |
> -				  FTRACE_OPS_FL_IPMODIFY;
> +				  FTRACE_OPS_FL_IPMODIFY |
> +				  FTRACE_OPS_FL_PERMANENT;
>  
>  		list_add(&ops->node, &klp_ops);
>  
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 62a50bf399d6..d2992ea29fe1 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -325,6 +325,8 @@ int __register_ftrace_function(struct ftrace_ops *ops)
>  	if (ops->flags & FTRACE_OPS_FL_SAVE_REGS_IF_SUPPORTED)
>  		ops->flags |= FTRACE_OPS_FL_SAVE_REGS;
>  #endif
> +	if (!ftrace_enabled && (ops->flags & FTRACE_OPS_FL_PERMANENT))
> +		return -EBUSY;
>  
>  	if (!core_kernel_data((unsigned long)ops))
>  		ops->flags |= FTRACE_OPS_FL_DYNAMIC;
> @@ -6723,6 +6725,18 @@ int unregister_ftrace_function(struct ftrace_ops *ops)
>  }
>  EXPORT_SYMBOL_GPL(unregister_ftrace_function);
>  
> +static bool is_permanent_ops_registered(void)
> +{
> +	struct ftrace_ops *op;
> +
> +	do_for_each_ftrace_op(op, ftrace_ops_list) {
> +		if (op->flags & FTRACE_OPS_FL_PERMANENT)
> +			return true;
> +	} while_for_each_ftrace_op(op);
> +
> +	return false;
> +}
> +
>  int
>  ftrace_enable_sysctl(struct ctl_table *table, int write,
>  		     void __user *buffer, size_t *lenp,
> @@ -6740,8 +6754,6 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
>  	if (ret || !write || (last_ftrace_enabled == !!ftrace_enabled))
>  		goto out;
>  
> -	last_ftrace_enabled = !!ftrace_enabled;
> -
>  	if (ftrace_enabled) {
>  
>  		/* we are starting ftrace again */
> @@ -6752,12 +6764,19 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
>  		ftrace_startup_sysctl();
>  
>  	} else {
> +		if (is_permanent_ops_registered()) {
> +			ftrace_enabled = last_ftrace_enabled;
> +			ret = -EBUSY;
> +			goto out;
> +		}
> +
>  		/* stopping ftrace calls (just send to ftrace_stub) */
>  		ftrace_trace_function = ftrace_stub;
>  
>  		ftrace_shutdown_sysctl();
>  	}
>  
> +	last_ftrace_enabled = !!ftrace_enabled;
>   out:
>  	mutex_unlock(&ftrace_lock);
>  	return ret;
> -- 
> 2.23.0
>

Hi Miroslav,

Maybe we should add a test to verify this new behavior?  See sample
version below (lightly tested).  We can add to this one, or patch
seperately if you prefer.

-- Joe

-->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8-- -->8--

 
From c8c9f22e3816ca4c90ab7e7159d2ce536eaa5fad Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@redhat.com>
Date: Mon, 14 Oct 2019 18:25:01 -0400
Subject: [PATCH] selftests/livepatch: test interaction with ftrace_enabled

Since livepatching depends upon ftrace handlers to implement "patched"
functionality, verify that the ftrace_enabled sysctl value interacts
with livepatch registration as expected.

Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
---
 tools/testing/selftests/livepatch/Makefile    |  3 +-
 .../testing/selftests/livepatch/functions.sh  | 18 +++++
 .../selftests/livepatch/test-ftrace.sh        | 65 +++++++++++++++++++
 3 files changed, 85 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/livepatch/test-ftrace.sh

diff --git a/tools/testing/selftests/livepatch/Makefile b/tools/testing/selftests/livepatch/Makefile
index fd405402c3ff..1886d9d94b88 100644
--- a/tools/testing/selftests/livepatch/Makefile
+++ b/tools/testing/selftests/livepatch/Makefile
@@ -4,6 +4,7 @@ TEST_PROGS_EXTENDED := functions.sh
 TEST_PROGS := \
 	test-livepatch.sh \
 	test-callbacks.sh \
-	test-shadow-vars.sh
+	test-shadow-vars.sh \
+	test-ftrace.sh
 
 include ../lib.mk
diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
index 79b0affd21fb..556252efece0 100644
--- a/tools/testing/selftests/livepatch/functions.sh
+++ b/tools/testing/selftests/livepatch/functions.sh
@@ -52,6 +52,24 @@ function set_dynamic_debug() {
 		EOF
 }
 
+function push_ftrace_enabled() {
+	FTRACE_ENABLED=$(sysctl --values kernel.ftrace_enabled)
+}
+function pop_ftrace_enabled() {
+	if [[ -n "$FTRACE_ENABLED" ]]; then
+		sysctl kernel.ftrace_enabled="$FTRACE_ENABLED"
+	fi
+}
+# set_ftrace_enabled() - save the current ftrace_enabled config and tweak
+# 			 it for the self-tests.  Set a script exit trap
+#			 that restores the original value.
+function set_ftrace_enabled() {
+	local sysctl="$1"
+        trap pop_ftrace_enabled EXIT INT TERM HUP
+	result=$(sysctl kernel.ftrace_enabled="$1" 2>&1 | paste --serial --delimiters=' ')
+	echo "livepatch: $result" > /dev/kmsg
+}
+
 # loop_until(cmd) - loop a command until it is successful or $MAX_RETRIES,
 #		    sleep $RETRY_INTERVAL between attempts
 #	cmd - command and its arguments to run
diff --git a/tools/testing/selftests/livepatch/test-ftrace.sh b/tools/testing/selftests/livepatch/test-ftrace.sh
new file mode 100755
index 000000000000..016576883a33
--- /dev/null
+++ b/tools/testing/selftests/livepatch/test-ftrace.sh
@@ -0,0 +1,65 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (C) 2019 Joe Lawrence <joe.lawrence@redhat.com>
+
+. $(dirname $0)/functions.sh
+
+MOD_LIVEPATCH=test_klp_livepatch
+
+set_dynamic_debug
+
+
+# TEST: livepatch interaction with ftrace_enabled sysctl
+# - turn ftrace_enabled OFF and verify livepatches can't load
+# - turn ftrace_enabled ON and verify livepatch can load
+# - verify that ftrace_enabled can't be turned OFF while a livepatch is loaded
+
+echo -n "TEST: livepatch interaction with ftrace_enabled sysctl ... "
+dmesg -C
+
+set_ftrace_enabled 0
+load_failing_mod $MOD_LIVEPATCH
+
+set_ftrace_enabled 1
+load_lp $MOD_LIVEPATCH
+if [[ "$(cat /proc/cmdline)" != "$MOD_LIVEPATCH: this has been live patched" ]] ; then
+	echo -e "FAIL\n\n"
+	die "livepatch kselftest(s) failed"
+fi
+
+set_ftrace_enabled 0
+if [[ "$(cat /proc/cmdline)" != "$MOD_LIVEPATCH: this has been live patched" ]] ; then
+	echo -e "FAIL\n\n"
+	die "livepatch kselftest(s) failed"
+fi
+disable_lp $MOD_LIVEPATCH
+unload_lp $MOD_LIVEPATCH
+
+check_result "livepatch: kernel.ftrace_enabled = 0
+% modprobe $MOD_LIVEPATCH
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: failed to register ftrace handler for function 'cmdline_proc_show' (-16)
+livepatch: failed to patch object 'vmlinux'
+livepatch: failed to enable patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': canceling patching transition, going to unpatch
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+modprobe: ERROR: could not insert '$MOD_LIVEPATCH': Device or resource busy
+livepatch: kernel.ftrace_enabled = 1
+% modprobe $MOD_LIVEPATCH
+livepatch: enabling patch '$MOD_LIVEPATCH'
+livepatch: '$MOD_LIVEPATCH': initializing patching transition
+livepatch: '$MOD_LIVEPATCH': starting patching transition
+livepatch: '$MOD_LIVEPATCH': completing patching transition
+livepatch: '$MOD_LIVEPATCH': patching complete
+livepatch: sysctl: setting key \"kernel.ftrace_enabled\": Device or resource busy kernel.ftrace_enabled = 0
+% echo 0 > /sys/kernel/livepatch/$MOD_LIVEPATCH/enabled
+livepatch: '$MOD_LIVEPATCH': initializing unpatching transition
+livepatch: '$MOD_LIVEPATCH': starting unpatching transition
+livepatch: '$MOD_LIVEPATCH': completing unpatching transition
+livepatch: '$MOD_LIVEPATCH': unpatching complete
+% rmmod $MOD_LIVEPATCH"
+
+
+exit 0
-- 
2.21.0

