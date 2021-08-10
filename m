Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A643E52A3
	for <lists+live-patching@lfdr.de>; Tue, 10 Aug 2021 07:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbhHJFQm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 Aug 2021 01:16:42 -0400
Received: from mail-pj1-f42.google.com ([209.85.216.42]:43806 "EHLO
        mail-pj1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237573AbhHJFQg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 Aug 2021 01:16:36 -0400
Received: by mail-pj1-f42.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so3604511pjb.2;
        Mon, 09 Aug 2021 22:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q5qOXfZS/zXt7fdy7MsPY7B9+ZvdaypoJrU+DGw4sFc=;
        b=lkh6ov8QuiRPOmXSJRj7e23RrjgHBigiLH0bH+ywLdb+Npm3aCZvxKQ8+VD2A1lsJK
         cUVsf78/af8qdiXpCF5gGWuO8HXPziuhbyN4YrrN8+1ODTTyIXhp8gGlHU9RoEsy7Iou
         /3Yex5znZ8NW3KzxZIg8vfj8nKYNfHEJ+gxkCo/fbrWWKovguQfwJJXBlbq/WM90od7w
         VLEnY42qBb+UF9wNoU1tvo+k++5JrIn/nznGxxcwOafRaMg4Mbxj0DPNcOBwcBHXA8cQ
         YWu6Mjcx+rvlxWPgbl5q6fKs28b2hArNt2UoRIHw1MI1wj8RX6odFWtCbQI5Xj2l/C/q
         W9Uw==
X-Gm-Message-State: AOAM531DrnmPmhORMnv8LuH5M/bMPdSnT/ALOVU+grubhTrVDm98Hen/
        hRQZZ9dX1wbHd9CgWbGIoFs=
X-Google-Smtp-Source: ABdhPJzP9lbUAomZuWhrJF94Ud8SOyRpE6sQuY3b74/kc4VTOgkH9JHnEkVziVXMuEpuvcBWboQf7Q==
X-Received: by 2002:a05:6a00:1a90:b029:3ca:5812:fe60 with SMTP id e16-20020a056a001a90b02903ca5812fe60mr12657629pfv.12.1628572573196;
        Mon, 09 Aug 2021 22:16:13 -0700 (PDT)
Received: from localhost ([191.96.121.128])
        by smtp.gmail.com with ESMTPSA id x19sm22406432pfa.104.2021.08.09.22.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 22:16:12 -0700 (PDT)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     lucas.demarchi@intel.com, linux-modules@vger.kernel.org
Cc:     live-patching@vger.kernel.org, fstests@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, dgilbert@interlog.com,
        jeyu@kernel.org, osandov@fb.com, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 3/3] libkmod-module: add support for a patient module removal option
Date:   Mon,  9 Aug 2021 22:16:02 -0700
Message-Id: <20210810051602.3067384-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210810051602.3067384-1-mcgrof@kernel.org>
References: <20210810051602.3067384-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

When doing tests with modules such as scsi_debug, on test
frameworks such as fstests [0] you may run into situations
where false positives are triggered and a test fails but
the reality is that the test did not fail, but what did
fail was the removal of the module since the refcnt is
not yet 0. There are many races possible with modules,
and each subsystem would have their own quirks for why
these races exist. Additionally, even after the refcnt is
0, userspace cannot be sure in any way that the refcnt
will remain 0, and so its easy to run into a situation
where the refcnt is bumped from 0 after modprobe just
saw it as 0.

The scsi_debug races are all documented on korg#21233 [1],
some issues are part scsi_debug alone, however other parts
of the race issue are completely due to incomplete described
semantics for modules and the inability for userspace to be
100% sure that a race cannot happen to bump the refcnt
once it observes the refcnt is 0.

I've written a script mod-refcnt-race.sh attached to
korg#214015 [2] which helps us easily reproduce the races
described and abstracts them away from fstests. This can be
used to both verify the issue and also test the new kmod
patient module remover. The same bug report also has a
simple busy-open-block-device-sleep.c which busy opens
a block device, sleep 4 seconds in a loop, closes the
file descriptor, which can easily be used to force failure
of the module removal (delete_module()) and test this
new patient removal.

Although there are patches for fstests to account for
this [3] and work around it, a much suitable solution
long term is for these hacks to use a patient module
remover from kmod and modprobe directly. This patch does
just that, it adds these new arguments to modprobe and
rmmod:

 -p | --remove-patiently   patiently removes the module
 -t | --timeout            timeout in ms to remove the module

The patient removal works by polling until the module refcnt
/sys/module/name/refcnt goes to 0. One that does happens it
tries to also patiently remove the module. This second step
is required as a new temporary refcnt bump can occur after
a module refcnt becomes 0. By default modprobe and rmmod
will wait forever, however a timeout can be specified to
in milliseconds to ensure only that amount of time is
spent trying to remove the module.

If a timeout is used it applies cumulatively to both the
refcnt wait, and for trying to remove the module once
modprobe sees the refcnt is already 0.

This new fatures is useful for cases where you know the
refcnt is going to become 0, and it is just a matter of time,
such as with many fstests / blktests tests.

It is worth noting that prior to kernel v3.13 the kernel
module delete system call used to support a wait flag,
this was removed via commit 3f2b9c9cdf389 ("module: remove
rmmod --wait option.") in favor for a 10 second sleep in
kmod. A 10 second sleep does not address the issues, and
so we must implement a patient removal properly in kmod.

[0] git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
[1] https://bugzilla.kernel.org/show_bug.cgi?id=21233
[2] https://bugzilla.kernel.org/show_bug.cgi?id=214015
[3] https://lkml.kernel.org/r/20210727201045.2540681-1-mcgrof@kernel.org
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 libkmod/docs/libkmod-sections.txt  |   4 +
 libkmod/libkmod-module.c           | 328 +++++++++++++++++++++++++++++
 libkmod/libkmod.c                  |  71 +++++++
 libkmod/libkmod.h                  |   7 +
 libkmod/libkmod.sym                |   4 +
 libkmod/python/kmod/_libkmod_h.pxd |   3 +
 libkmod/python/kmod/module.pyx     |   4 +
 man/modprobe.xml                   |  59 ++++++
 man/rmmod.xml                      |  60 ++++++
 tools/modprobe.c                   |  21 +-
 tools/remove.c                     |  12 +-
 tools/rmmod.c                      |  27 ++-
 12 files changed, 584 insertions(+), 16 deletions(-)

diff --git a/libkmod/docs/libkmod-sections.txt b/libkmod/docs/libkmod-sections.txt
index e59ab7a..a5b71d2 100644
--- a/libkmod/docs/libkmod-sections.txt
+++ b/libkmod/docs/libkmod-sections.txt
@@ -12,6 +12,8 @@ kmod_dump_index
 
 kmod_set_log_priority
 kmod_get_log_priority
+kmod_get_refcnt_timeout
+kmod_set_refcnt_timeout
 kmod_set_log_fn
 kmod_get_userdata
 kmod_set_userdata
@@ -56,6 +58,7 @@ kmod_module_unref_list
 kmod_module_insert_module
 kmod_module_probe_insert_module
 kmod_module_remove_module
+kmod_module_remove_module_wait
 
 kmod_module_get_module
 kmod_module_get_dependencies
@@ -102,5 +105,6 @@ kmod_module_get_initstate
 kmod_module_initstate_str
 kmod_module_get_size
 kmod_module_get_refcnt
+kmod_module_get_refcnt_wait
 kmod_module_get_holders
 </SECTION>
diff --git a/libkmod/libkmod-module.c b/libkmod/libkmod-module.c
index 04bb4d9..2d54d1a 100644
--- a/libkmod/libkmod-module.c
+++ b/libkmod/libkmod-module.c
@@ -30,6 +30,9 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <poll.h>
+#include <time.h>
+#include <math.h>
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/syscall.h>
@@ -802,6 +805,143 @@ KMOD_EXPORT int kmod_module_remove_module(struct kmod_module *mod,
 	return err;
 }
 
+static int timespec_to_ms(struct timespec *t)
+{
+	return (t->tv_sec * 1000) + lround(t->tv_nsec / 1000000);
+}
+
+static int time_delta_ms(struct timespec *before, struct timespec *after)
+{
+	if (!before || !after)
+		return 0;
+	return timespec_to_ms(after) - timespec_to_ms(before);
+}
+
+/**
+ * kmod_module_remove_module_wait:
+ * @mod: kmod module
+ * @flags: flags to pass to Linux kernel when removing the module. The only valid flag is
+ * KMOD_REMOVE_FORCE: force remove module regardless if it's still in
+ * use by a kernel subsystem or other process;
+ * KMOD_REMOVE_NOWAIT is always enforced, causing us to pass O_NONBLOCK to
+ * delete_module(2). We do the waiting in userspace, if a wait was desired.
+ *
+ * Remove a module from Linux kernel patiently.
+ *
+ * Returns: 0 on success or < 0 on failure.
+ */
+KMOD_EXPORT int kmod_module_remove_module_wait(struct kmod_module *mod,
+					       unsigned int flags,
+					       bool wait)
+{
+	int err, err_time, t_delta, t_delta_print, orig_timeout;
+	int time_between_prints = 500; /* 1/2 second */
+	int timeout_ms;
+	struct timespec t1, t2, t_print = { .tv_sec = 0, .tv_nsec = 0};
+	bool printed_msg = false;
+
+	if (mod == NULL)
+		return -ENOENT;
+
+	if (wait)
+		timeout_ms = kmod_get_refcnt_timeout(mod->ctx);
+
+	if (!wait || !timeout_ms)
+		return kmod_module_remove_module(mod, flags);
+
+	err_time = clock_gettime(CLOCK_MONOTONIC, &t1);
+	if (err_time != 0)
+		return kmod_module_remove_module(mod, flags);
+
+	/*
+	 * We now know an original patient removal was requested and
+	 * an associated timeout was also provided. timeout_removal_ms
+	 * should be set with what we are left with.
+	 */
+	timeout_ms = orig_timeout = kmod_get_removal_timeout(mod->ctx);
+	DBG(mod->ctx, "removal timeout is %d for '%s'\n", timeout_ms, mod->name);
+
+	/*
+	 * Filter out other flags and force ONONBLOCK
+	 *
+	 * This is true even for the patient removal. The wait flag was
+	 * a now deprecated flag, see kernel commits:
+	 *
+	 * 3f2b9c9cdf389e ("module: remove rmmod --wait option." on v3.13
+	 * 79465d2fd48e68 ("module: remove warning about waiting module removal.") on v3.15
+	 *
+	 * Patient removal is a userspace implementation.
+	 */
+	flags &= KMOD_REMOVE_FORCE;
+	flags |= KMOD_REMOVE_NOWAIT;
+
+	while (true) {
+		err = delete_module(mod->name, flags);
+		if (err == 0)
+			return 0;
+		err = -errno;
+
+		if (timeout_ms == 0) {
+			ERR(mod->ctx, "timeout (%d) trying to remove module immediately '%s': %m %s\n",
+			    timeout_ms, mod->name, strerror(errno));
+			return err;
+		}
+
+		/* Wait forever request */
+		if (timeout_ms < 0) {
+			if (!printed_msg) {
+				NOTICE(mod->ctx, "%s trying forever to remove...\n",
+				       mod->name);
+				printed_msg = true;
+			}
+			continue;
+		}
+
+		/* All below is when we know we have a timeout */
+
+		err_time = clock_gettime(CLOCK_MONOTONIC, &t2);
+		if (err_time != 0) {
+			ERR(mod->ctx, "Using CLOCK_MONOTONIC failed, cannot wait, prior module removal module failed for '%s': %m %s\n",
+			    mod->name, strerror(errno));
+			return err;
+		}
+
+		t_delta = time_delta_ms(&t1, &t2);
+		DBG(mod->ctx, "%s removal time delta: %d ms\n", mod->name, t_delta);
+
+		if (t_delta >= orig_timeout) {
+			ERR(mod->ctx, "timeout (%d) trying to remove module '%s': %m %s\n",
+			    timeout_ms, mod->name, strerror(errno));
+			return err;
+		}
+
+		/*
+		 * We have more time to remove the module. The above check
+		 * also ensures that timeout_ms won't ever be 0.
+		 */
+		timeout_ms = orig_timeout - t_delta;
+
+		if (!printed_msg) {
+			NOTICE(mod->ctx, "%s removal failed. Re-trying for %d more ms (total timeout of %d ms)\n",
+			       mod->name, timeout_ms, orig_timeout);
+			t_print = t2;
+			printed_msg = true;
+		} else {
+			/*
+			 * Computes the delta between our last print
+			 * and the time of our current current
+			 * evaluation.
+			 */
+			t_delta_print = time_delta_ms(&t_print, &t2);
+			if (t_delta_print < time_between_prints)
+				continue;
+			NOTICE(mod->ctx, "%s removal failed. Re-trying for %d more ms (total timeout of %d ms)\n",
+			       mod->name, timeout_ms, orig_timeout);
+			t_print = t2;
+		}
+	}
+}
+
 extern long init_module(const void *mem, unsigned long len, const char *args);
 
 /**
@@ -1926,6 +2066,194 @@ KMOD_EXPORT int kmod_module_get_refcnt(const struct kmod_module *mod)
 	return (int)refcnt;
 }
 
+/**
+ * kmod_module_get_refcnt_wait:
+ * @mod: kmod module
+ * @wait: if true will wait until the refcnt is 0 patiently forever
+ *
+ * Get the ref count of this @mod, as returned by Linux Kernel, by reading
+ * /sys filesystem and wait patiently until the refcnt is 0, if the wait bool
+ * argument is set to true, otherwise this behaves just as the call
+ * kmod_module_get_refcnt(). Enabling wait is useful if you know for sure that
+ * the module is quiescing soon, and so you should be able to remove it soon.
+ * If wait is enabled, we wait a predetermined timeout setting which is
+ * is configurable with kmod_set_refcnt_timeout(), by default we wait
+ * forever.
+ *
+ * Returns: the reference count on success or < 0 on failure.
+ */
+KMOD_EXPORT int kmod_module_get_refcnt_wait(const struct kmod_module *mod, bool wait)
+{
+	struct pollfd fdset;
+	int err, err_time, num_fds=1, t_delta, t_delta_print, orig_timeout;
+	int time_between_prints = 500; /* 1/2 second */
+	int timeout_ms;
+	long refcnt;
+	struct timespec t1, t2, t_print = { .tv_sec = 0, .tv_nsec = 0};
+	bool printed_msg = false;
+
+	if (wait)
+		timeout_ms = kmod_get_refcnt_timeout(mod->ctx);
+
+	if (!wait || !timeout_ms)
+		return kmod_module_get_refcnt(mod);
+
+	orig_timeout = timeout_ms;
+
+	/*
+	 * The refcnt may be something like 2, and poll() may return when
+	 * the refcnt becomes 1, and so we must also check for the overall
+	 * time ran and on each instance make the timeout available shorter
+	 *
+	 * If using the CLOCK_MONOTONIC failed and we have a timeout set, we
+	 * simply cannot wait as we cannot trust time differences.
+	 */
+	err_time = clock_gettime(CLOCK_MONOTONIC, &t1);
+	if (err_time != 0) {
+		ERR(mod->ctx, "Using the CLOCK_MONOTONIC failed (%s) so processing removal for %s without a wait for the refcnt\n",
+		    strerror(errno), mod->name);
+		return kmod_module_get_refcnt(mod);
+	}
+
+	kmod_set_removal_timeout(mod->ctx, orig_timeout);
+
+	while (true) {
+		DBG(mod->ctx, "%s about to poll for refcnt using timeout %d ms\n", mod->name, timeout_ms);
+		memset(&fdset, 0, sizeof(struct pollfd));
+		fdset.events = POLLPRI | POLLIN;
+		fdset.fd = kmod_module_get_refcnt_fd(mod);
+		if (fdset.fd < 0)
+			return fdset.fd;
+		err = poll(&fdset, num_fds, timeout_ms);
+		if (err == -1) {
+			DBG(mod->ctx, "%s refcnt poll failed with err: %s\n", mod->name, strerror(errno));
+			goto err;
+		}
+		if (err == 0) { /* timeout before fds were read */
+			NOTICE(mod->ctx, "%s refcnt did not become 0 after %d ms\n",
+			       mod->name, orig_timeout);
+			kmod_set_removal_timeout(mod->ctx, 0);
+			err = -ETIMEDOUT;
+			goto err;
+		}
+		if (err != num_fds) { /* on success, we only asked for one fd */
+			err = -EINVAL;
+			goto err;
+		}
+		if (!fdset.revents) {
+			close(fdset.fd);
+			continue;
+		}
+		if ((!fdset.revents & POLLIN)) {
+			err = -EINVAL;
+			goto err;
+		}
+
+		err = read_str_long(fdset.fd, &refcnt, 10);
+		if (err < 0)
+			goto err;
+
+		close(fdset.fd);
+
+		if ((refcnt <= 0) || (refcnt > 0 && !wait)) {
+			NOTICE(mod->ctx, "%s refcnt is %d\n", mod->name, (int) refcnt);
+			err_time = clock_gettime(CLOCK_MONOTONIC, &t2);
+			if (err_time != 0)
+				kmod_set_removal_timeout(mod->ctx, 0);
+			else {
+				t_delta = time_delta_ms(&t1, &t2);
+				/*
+				 * We only do adjustments for removal when an
+				 * original timeout was set. If we happen to
+				 * have run out of time but refcnt is 0 we'll
+				 * try removal once.
+				 */
+				if (timeout_ms <= 0)
+					kmod_set_removal_timeout(mod->ctx, timeout_ms);
+				if (t_delta >= orig_timeout)
+					kmod_set_removal_timeout(mod->ctx, 0);
+				kmod_set_removal_timeout(mod->ctx, orig_timeout - t_delta);
+			}
+			return (int) refcnt;
+		}
+
+		/*
+		 * At this point we know refcnt is greater than 0.
+		 */
+
+		err_time = clock_gettime(CLOCK_MONOTONIC, &t2);
+		if (err_time != 0) {
+			ERR(mod->ctx, "Using the CLOCK_MONOTONIC failed a second time so processing removal for %s without a wait for the refcnt\n",
+			    mod->name);
+			kmod_set_removal_timeout(mod->ctx, 0);
+			return kmod_module_get_refcnt(mod);
+		}
+
+		t_delta = time_delta_ms(&t1, &t2);
+		DBG(mod->ctx, "%s refcnt delta: %d ms\n", mod->name, t_delta);
+
+		/*
+		 * When the timeout is negative we leave the the interpretation
+		 * of the used timeout value to poll() by design. Adjustments
+		 * only make sense if a sensible timeout was set. We dealt
+		 * with a 0 timeout at the beginning but we check here just
+		 * for posterity.
+		 */
+		if (!timeout_ms) {
+			kmod_set_removal_timeout(mod->ctx, 0);
+			return kmod_module_get_refcnt(mod);
+		}
+
+		if (timeout_ms < 0) {
+			if (!printed_msg) {
+				NOTICE(mod->ctx, "%s refcnt is %ld waiting forever for it to become 0\n",
+				       mod->name, refcnt);
+				printed_msg = true;
+				t_print = t2;
+			}
+			continue;
+		}
+
+		/* timeout_ms must be > 0 below */
+
+		if (t_delta >= orig_timeout) {
+			NOTICE(mod->ctx, "%s refcnt did not become 0 after a total of %d ms we waited %d ms\n",
+			       mod->name, orig_timeout, t_delta);
+			kmod_set_removal_timeout(mod->ctx, 0);
+			return -ETIMEDOUT;
+		}
+
+		/*
+		 * We have more time to run. The above check also ensure that
+		 * timeout_ms won't ever be 0.
+		 */
+		timeout_ms = orig_timeout - t_delta;
+
+		if (!printed_msg) {
+			NOTICE(mod->ctx, "%s refcnt is %ld waiting %d more ms (total timeout of %d ms) for it to become 0\n",
+			       mod->name, refcnt, timeout_ms, orig_timeout);
+			t_print = t2;
+			printed_msg = true;
+		} else {
+			/*
+			 * Computes the delta between our last print
+			 * and the time of our current current
+			 * evaluation.
+			 */
+			t_delta_print = time_delta_ms(&t_print, &t2);
+			if (t_delta_print < time_between_prints)
+				continue;
+			NOTICE(mod->ctx, "%s refcnt is %ld waiting %d more ms (total timeout of %d ms) for it to become 0\n",
+			       mod->name, refcnt, timeout_ms, orig_timeout);
+			t_print = t2;
+		}
+	}
+
+err:
+	close(fdset.fd);
+	return err;
+}
+
 /**
  * kmod_module_get_holders:
  * @mod: kmod module
diff --git a/libkmod/libkmod.c b/libkmod/libkmod.c
index 7c2b889..09615a6 100644
--- a/libkmod/libkmod.c
+++ b/libkmod/libkmod.c
@@ -77,6 +77,8 @@ static const char *default_config_paths[] = {
 struct kmod_ctx {
 	int refcount;
 	int log_priority;
+	int timeout_refcnt_ms;
+	int timeout_removal_ms;
 	void (*log_fn)(void *data,
 			int priority, const char *file, int line,
 			const char *fn, const char *format, va_list args);
@@ -264,6 +266,7 @@ KMOD_EXPORT struct kmod_ctx *kmod_new(const char *dirname,
 	ctx->log_fn = log_filep;
 	ctx->log_data = stderr;
 	ctx->log_priority = LOG_ERR;
+	ctx->timeout_refcnt_ms = -1; /* forever */
 
 	ctx->dirname = get_kernel_release(dirname);
 
@@ -395,6 +398,74 @@ KMOD_EXPORT void kmod_set_log_priority(struct kmod_ctx *ctx, int priority)
 	ctx->log_priority = priority;
 }
 
+/**
+ * kmod_get_refcnt_timeout
+ * @ctx: kmod library context
+ *
+ * Returns: the timeout for waiting for refcnt to become 0
+ */
+KMOD_EXPORT int kmod_get_refcnt_timeout(const struct kmod_ctx *ctx)
+{
+	if (ctx == NULL)
+		return -1;
+	return ctx->timeout_refcnt_ms;
+}
+
+/**
+ * kmod_set_refcnt_timeout_ms:
+ * @ctx: kmod library context
+ * @timeout_ms: time timeout to wait for the recnt to become 0 in ms
+ *
+ * Sets the timeout which will be used to wait for the refcnt to become
+ * 0 when trying to remove a module. This timeout is only used on library
+ * calls which explicitly document support for it.
+ *
+ * We use the timeout with poll(2) and so a negative means infinite, so we
+ * would run forever where used unless the refcnt becomes 0. A value of
+ * 0 means poll() will return immediately, even if the refcnt has not
+ * changed.
+ *
+ * If kmod_set_refcnt_timeout() is never called, the default timeout is
+ * forever, and so calls which rely on the timeout_refcnt_ms will wait
+ * forever until the refcnt becomes 0.
+ */
+KMOD_EXPORT void kmod_set_refcnt_timeout(struct kmod_ctx *ctx, int timeout_ms)
+{
+	if (ctx == NULL)
+		return;
+	ctx->timeout_refcnt_ms = timeout_ms;
+}
+
+/**
+ * kmod_get_removal_timeout
+ * @ctx: kmod library context
+ *
+ * Returns: the timeout for waiting remove the module.
+ */
+KMOD_EXPORT int kmod_get_removal_timeout(const struct kmod_ctx *ctx)
+{
+	if (ctx == NULL)
+		return -1;
+	return ctx->timeout_removal_ms;
+}
+
+/**
+ * kmod_set_removal_timeout_ms:
+ * @ctx: kmod library context
+ * @timeout_ms: time timeout to wait for trying to remove the module in ms
+ *
+ * Sets the timeout which will be used to try to keep trying to remove the
+ * module. A timeout of 0 means we just try once. A negative timeout means
+ * we try forever.
+ */
+KMOD_EXPORT void kmod_set_removal_timeout(struct kmod_ctx *ctx, int timeout_ms)
+{
+	if (ctx == NULL)
+		return;
+	ctx->timeout_removal_ms = timeout_ms;
+}
+
+
 struct kmod_module *kmod_pool_get_module(struct kmod_ctx *ctx,
 							const char *key)
 {
diff --git a/libkmod/libkmod.h b/libkmod/libkmod.h
index 3cab2e5..acf3c2a 100644
--- a/libkmod/libkmod.h
+++ b/libkmod/libkmod.h
@@ -48,6 +48,10 @@ void kmod_set_log_fn(struct kmod_ctx *ctx,
 			const void *data);
 int kmod_get_log_priority(const struct kmod_ctx *ctx);
 void kmod_set_log_priority(struct kmod_ctx *ctx, int priority);
+int kmod_get_refcnt_timeout(const struct kmod_ctx *ctx);
+void kmod_set_refcnt_timeout(struct kmod_ctx *ctx, int timeout_ms);
+int kmod_get_removal_timeout(const struct kmod_ctx *ctx);
+void kmod_set_removal_timeout(struct kmod_ctx *ctx, int timeout_ms);
 void *kmod_get_userdata(const struct kmod_ctx *ctx);
 void kmod_set_userdata(struct kmod_ctx *ctx, const void *userdata);
 
@@ -172,6 +176,8 @@ enum kmod_filter {
 };
 
 int kmod_module_remove_module(struct kmod_module *mod, unsigned int flags);
+int kmod_module_remove_module_wait(struct kmod_module *mod, unsigned int flags,
+				   bool wait);
 int kmod_module_insert_module(struct kmod_module *mod, unsigned int flags,
 							const char *options);
 int kmod_module_probe_insert_module(struct kmod_module *mod,
@@ -217,6 +223,7 @@ enum kmod_module_initstate {
 const char *kmod_module_initstate_str(enum kmod_module_initstate state);
 int kmod_module_get_initstate(const struct kmod_module *mod);
 int kmod_module_get_refcnt(const struct kmod_module *mod);
+int kmod_module_get_refcnt_wait(const struct kmod_module *mod, bool wait);
 struct kmod_list *kmod_module_get_holders(const struct kmod_module *mod);
 struct kmod_list *kmod_module_get_sections(const struct kmod_module *mod);
 const char *kmod_module_section_get_name(const struct kmod_list *entry);
diff --git a/libkmod/libkmod.sym b/libkmod/libkmod.sym
index 5f5e1fb..8802784 100644
--- a/libkmod/libkmod.sym
+++ b/libkmod/libkmod.sym
@@ -6,6 +6,8 @@ global:
 	kmod_ref;
 	kmod_set_log_fn;
 	kmod_set_log_priority;
+	kmod_get_refcnt_timeout_ms;
+	kmod_set_refcnt_timeout;
 	kmod_set_userdata;
 	kmod_unref;
 	kmod_list_next;
@@ -36,6 +38,7 @@ global:
 	kmod_module_unref_list;
 	kmod_module_get_module;
 	kmod_module_remove_module;
+	kmod_module_remove_module_wait;
 	kmod_module_insert_module;
 	kmod_module_probe_insert_module;
 
@@ -49,6 +52,7 @@ global:
 	kmod_module_initstate_str;
 	kmod_module_get_initstate;
 	kmod_module_get_refcnt;
+	kmod_module_get_refcnt_wait;
 	kmod_module_get_sections;
 	kmod_module_section_free_list;
 	kmod_module_section_get_name;
diff --git a/libkmod/python/kmod/_libkmod_h.pxd b/libkmod/python/kmod/_libkmod_h.pxd
index 7191953..29ba3e7 100644
--- a/libkmod/python/kmod/_libkmod_h.pxd
+++ b/libkmod/python/kmod/_libkmod_h.pxd
@@ -79,6 +79,8 @@ cdef extern from 'libkmod/libkmod.h':
 
     int kmod_module_remove_module(
         kmod_module *mod, unsigned int flags)
+    int kmod_module_remove_module_wait(
+        kmod_module *mod, unsigned int flags, bool wait)
     int kmod_module_insert_module(
         kmod_module *mod, unsigned int flags, const_char_ptr options)
     int kmod_module_probe_insert_module(
@@ -99,6 +101,7 @@ cdef extern from 'libkmod/libkmod.h':
     # Information regarding "live information" from module's state, as
     # returned by kernel
     int kmod_module_get_refcnt(const_kmod_module_ptr mod)
+    int kmod_module_get_refcnt_wait(const_kmod_module_ptr mod, bool install)
     long kmod_module_get_size(const_kmod_module_ptr mod)
 
     # Information retrieved from ELF headers and section
diff --git a/libkmod/python/kmod/module.pyx b/libkmod/python/kmod/module.pyx
index 42aa92e..45fe774 100644
--- a/libkmod/python/kmod/module.pyx
+++ b/libkmod/python/kmod/module.pyx
@@ -72,6 +72,10 @@ cdef class Module (object):
         return _libkmod_h.kmod_module_get_refcnt(self.module)
     refcnt = property(fget=_refcnt_get)
 
+    def _refcnt_get_wait(self, wait=False):
+        return _libkmod_h.kmod_module_get_refcnt_wait(self.module, wait)
+    refcnt = property(fget=_refcnt_get_wait)
+
     def _size_get(self):
         return _libkmod_h.kmod_module_get_size(self.module)
     size = property(fget=_size_get)
diff --git a/man/modprobe.xml b/man/modprobe.xml
index 0372b6b..592276a 100644
--- a/man/modprobe.xml
+++ b/man/modprobe.xml
@@ -388,6 +388,65 @@
           </para>
         </listitem>
       </varlistentry>
+      <varlistentry>
+        <term>
+          <option>-p</option>
+        </term>
+        <term>
+          <option>--remove-patiently</option>
+        </term>
+        <listitem>
+          <para>
+            This option causes <command>modprobe</command> to try to patiently
+	    remove a module by waiting until its refcnt is 0 and then trying to
+	    remove it. The patient removal polls the module's refcnt sysfs file,
+	    typically /sys/module/module/refcnt, for changes and will end
+	    polling this file if it becomes 0, an error has ocurred, or we
+	    ran out of time waiting for the refcnt.
+
+	    A programmable timeout is available to be set, which modifies how
+	    long modprobe will wait for the refcnt to become 0. By default the
+	    timeout is set to wait forever. Refer to the -t option below for
+	    more information on the setting the timeout.
+
+	    Once the refcnt is found to be 0, <command>modprobe</command>
+	    will try to use the remaining time left from our progammed timeout
+	    to remove the module in a busy loop. By default we loop forever
+	    trying to remove the module when the patient module remover is
+	    used.
+          </para>
+          <para>
+            Removing modules may be done by test infrastruture code, it can also
+            be done to remove a live kernel patch.
+          </para>
+        </listitem>
+      </varlistentry>
+      <varlistentry>
+        <term>
+          <option>-t</option>
+        </term>
+        <term>
+          <option>--timeout</option>
+        </term>
+        <listitem>
+          <para>
+            This option provides the timeout in millisecond for module removal.
+            The timeout is used first to wait for the refcnt to become 0, and
+            once it is found to be 0 it will use the remaining time from the
+            provided timeout trying to remove the module. A timeout is ignored
+            unless the patient removal option is used, -p. A timeout of 0
+            means no timeout is used. A negative timeout means we wait forever.
+            Systems where clock_gettime(CLOCK_MONOTONIC, t) does not work will
+            have the timeout ignored and removal will be attempted in one shot
+            just as if <command>modprobe -r</command> was called.
+          </para>
+          <para>
+            Removing modules may be done by test infrastruture code, it can also
+            be done to remove a live kernel patch if supported
+            by your distribution.
+          </para>
+        </listitem>
+      </varlistentry>
       <varlistentry>
         <term>
           <option>-S</option>
diff --git a/man/rmmod.xml b/man/rmmod.xml
index e7c7e5f..1b64f12 100644
--- a/man/rmmod.xml
+++ b/man/rmmod.xml
@@ -39,6 +39,7 @@
     <cmdsynopsis>
       <command>rmmod</command>
       <arg><option>-f</option></arg>
+      <arg><option>-p</option></arg>
       <arg><option>-s</option></arg>
       <arg><option>-v</option></arg>
       <arg><replaceable>modulename</replaceable></arg>
@@ -92,6 +93,65 @@
           </para>
         </listitem>
       </varlistentry>
+      <varlistentry>
+        <term>
+          <option>-p</option>
+        </term>
+        <term>
+          <option>--remove-patiently</option>
+        </term>
+        <listitem>
+          <para>
+            This option causes <command>modprobe</command> to try to patiently
+	    remove a module by waiting until its refcnt is 0 and then trying to
+	    remove it. The patient removal polls the module's refcnt sysfs file,
+	    typically /sys/module/module/refcnt, for changes and will end
+	    polling this file if it becomes 0, an error has ocurred, or we
+	    ran out of time waiting for the refcnt.
+
+	    A programmable timeout is available to be set, which modifies how
+	    long modprobe will wait for the refcnt to become 0. By default the
+	    timeout is set to wait forever. Refer to the -t option below for
+	    more information on the setting the timeout.
+
+	    Once the refcnt is found to be 0, <command>modprobe</command>
+	    will try to use the remaining time left from our progammed timeout
+	    to remove the module in a busy loop. By default we loop forever
+	    trying to remove the module when the patient module remover is
+	    used.
+          </para>
+          <para>
+            Removing modules may be done by test infrastruture code, it can also
+            be done to remove a live kernel patch if supported
+            by your distribution.
+          </para>
+        </listitem>
+      </varlistentry>
+      <varlistentry>
+        <term>
+          <option>-t</option>
+        </term>
+        <term>
+          <option>--timeout</option>
+        </term>
+        <listitem>
+          <para>
+            This option provides the timeout in millisecond for module removal.
+            The timeout is used first to wait for the refcnt to become 0, and
+            once it is found to be 0 it will use the remaining time from the
+            provided timeout trying to remove the module. A timeout is ignored
+            unless the patient removal option is used, -p. A timeout of 0
+            means no timeout is used. A negative timeout means we wait forever.
+            Systems where clock_gettime(CLOCK_MONOTONIC, t) does not work will
+            have the timeout ignored and removal will be attempted in one shot
+            just as if <command>modprobe -r</command> was called.
+          </para>
+          <para>
+            Removing modules may be done by test infrastruture code, it can also
+            be done to remove a live kernel patch.
+          </para>
+        </listitem>
+      </varlistentry>
       <varlistentry>
         <term>
           <option>-s</option>
diff --git a/tools/modprobe.c b/tools/modprobe.c
index 9387537..bf11dd3 100644
--- a/tools/modprobe.c
+++ b/tools/modprobe.c
@@ -56,11 +56,14 @@ static int strip_modversion = 0;
 static int strip_vermagic = 0;
 static int remove_dependencies = 0;
 static int quiet_inuse = 0;
+static int do_remove_patient = 0;
+static int use_timeout_ms = 0;
 
-static const char cmdopts_s[] = "arRibfDcnC:d:S:sqvVh";
+static const char cmdopts_s[] = "arpRibfDcnC:d:S:st:qvVh";
 static const struct option cmdopts[] = {
 	{"all", no_argument, 0, 'a'},
 	{"remove", no_argument, 0, 'r'},
+	{"remove-patiently", no_argument, 0, 'p'},
 	{"remove-dependencies", no_argument, 0, 5},
 	{"resolve-alias", no_argument, 0, 'R'},
 	{"first-time", no_argument, 0, 3},
@@ -81,6 +84,7 @@ static const struct option cmdopts[] = {
 	{"dry-run", no_argument, 0, 'n'},
 	{"show", no_argument, 0, 'n'},
 
+	{"timeout", required_argument, 0, 't'},
 	{"config", required_argument, 0, 'C'},
 	{"dirname", required_argument, 0, 'd'},
 	{"set-version", required_argument, 0, 'S'},
@@ -107,6 +111,8 @@ static void help(void)
 		"\t                            be a module name to be inserted\n"
 		"\t                            or removed (-r)\n"
 		"\t-r, --remove                Remove modules instead of inserting\n"
+		"\t-p, --remove-patiently      Patiently wait until the refcnt is 0 to remove\n"
+		"\t-t, --timeout               Timeout in ms to use for patient removal\n"
 		"\t    --remove-dependencies   Also remove modules depending on it\n"
 		"\t-R, --resolve-alias         Only lookup and print alias and exit\n"
 		"\t    --first-time            Fail if module already inserted or removed\n"
@@ -331,7 +337,7 @@ static int rmmod_do_remove_module(struct kmod_module *mod)
 	if (force)
 		flags |= KMOD_REMOVE_FORCE;
 
-	err = kmod_module_remove_module(mod, flags);
+	err = kmod_module_remove_module_wait(mod, flags, do_remove_patient);
 	if (err == -EEXIST) {
 		if (!first_time)
 			err = 0;
@@ -424,7 +430,7 @@ static int rmmod_do_module(struct kmod_module *mod, int flags)
 	}
 
 	if (!ignore_loaded && !cmd) {
-		int usage = kmod_module_get_refcnt(mod);
+		int usage = kmod_module_get_refcnt_wait(mod, do_remove_patient);
 
 		if (usage > 0) {
 			if (!quiet_inuse)
@@ -785,6 +791,10 @@ static int do_modprobe(int argc, char **orig_argv)
 		case 'r':
 			do_remove = 1;
 			break;
+		case 'p':
+			do_remove = 1;
+			do_remove_patient = 1;
+			break;
 		case 5:
 			remove_dependencies = 1;
 			break;
@@ -843,6 +853,9 @@ static int do_modprobe(int argc, char **orig_argv)
 			env_modprobe_options_append(optarg);
 			break;
 		}
+		case 't':
+			use_timeout_ms = atoi(optarg);
+			break;
 		case 'd':
 			root = optarg;
 			break;
@@ -921,6 +934,8 @@ static int do_modprobe(int argc, char **orig_argv)
 	log_setup_kmod_log(ctx, verbose);
 
 	kmod_load_resources(ctx);
+	if (use_timeout_ms)
+		kmod_set_refcnt_timeout(ctx, use_timeout_ms);
 
 	if (do_show_config)
 		err = show_config(ctx);
diff --git a/tools/remove.c b/tools/remove.c
index 387ef0e..8436c95 100644
--- a/tools/remove.c
+++ b/tools/remove.c
@@ -27,9 +27,12 @@
 
 #include "kmod.h"
 
-static const char cmdopts_s[] = "h";
+static int do_remove_patient = 0;
+
+static const char cmdopts_s[] = "hp";
 static const struct option cmdopts[] = {
 	{"help", no_argument, 0, 'h'},
+	{"remove-patiently", no_argument, 0, 'p'},
 	{ }
 };
 
@@ -74,7 +77,7 @@ static int check_module_inuse(struct kmod_module *mod) {
 		return -EBUSY;
 	}
 
-	ret = kmod_module_get_refcnt(mod);
+	ret = kmod_module_get_refcnt_wait(mod, do_remove_patient);
 	if (ret > 0) {
 		ERR("Module %s is in use\n", kmod_module_get_name(mod));
 		return -EBUSY;
@@ -101,6 +104,9 @@ static int do_remove(int argc, char *argv[])
 		case 'h':
 			help();
 			return EXIT_SUCCESS;
+		case 'p':
+			do_remove_patient = 1;
+			break;
 
 		default:
 			ERR("Unexpected getopt_long() value '%c'.\n", c);
@@ -130,7 +136,7 @@ static int do_remove(int argc, char *argv[])
 	if (err < 0)
 		goto unref;
 
-	err = kmod_module_remove_module(mod, 0);
+	err = kmod_module_remove_module_wait(mod, 0, do_remove_patient);
 	if (err < 0)
 		goto unref;
 
diff --git a/tools/rmmod.c b/tools/rmmod.c
index 3942e7b..77c813a 100644
--- a/tools/rmmod.c
+++ b/tools/rmmod.c
@@ -35,10 +35,12 @@
 #define DEFAULT_VERBOSE LOG_ERR
 static int verbose = DEFAULT_VERBOSE;
 static int use_syslog;
+static int do_remove_patient;
 
-static const char cmdopts_s[] = "fsvVwh";
+static const char cmdopts_s[] = "fpsvVwh";
 static const struct option cmdopts[] = {
 	{"force", no_argument, 0, 'f'},
+	{"remove-patiently", no_argument, 0, 'p'},
 	{"syslog", no_argument, 0, 's'},
 	{"verbose", no_argument, 0, 'v'},
 	{"version", no_argument, 0, 'V'},
@@ -51,13 +53,14 @@ static void help(void)
 	printf("Usage:\n"
 		"\t%s [options] modulename ...\n"
 		"Options:\n"
-		"\t-f, --force       forces a module unload and may crash your\n"
-		"\t                  machine. This requires Forced Module Removal\n"
-		"\t                  option in your kernel. DANGEROUS\n"
-		"\t-s, --syslog      print to syslog, not stderr\n"
-		"\t-v, --verbose     enables more messages\n"
-		"\t-V, --version     show version\n"
-		"\t-h, --help        show this help\n",
+		"\t-f, --force            forces a module unload and may crash your\n"
+		"\t                       machine. This requires Forced Module Removal\n"
+		"\t                       option in your kernel. DANGEROUS\n"
+		"\t-p, --remove-patiently patiently tries to remove the module\n"
+		"\t-s, --syslog           print to syslog, not stderr\n"
+		"\t-v, --verbose          enables more messages\n"
+		"\t-V, --version          show version\n"
+		"\t-h, --help             show this help\n",
 		program_invocation_short_name);
 }
 
@@ -93,7 +96,7 @@ static int check_module_inuse(struct kmod_module *mod) {
 		return -EBUSY;
 	}
 
-	ret = kmod_module_get_refcnt(mod);
+	ret = kmod_module_get_refcnt_wait(mod, do_remove_patient);
 	if (ret > 0) {
 		ERR("Module %s is in use\n", kmod_module_get_name(mod));
 		return -EBUSY;
@@ -120,6 +123,9 @@ static int do_rmmod(int argc, char *argv[])
 		case 'f':
 			flags |= KMOD_REMOVE_FORCE;
 			break;
+		case 'p':
+			do_remove_patient = 1;
+			break;
 		case 's':
 			use_syslog = 1;
 			break;
@@ -178,7 +184,8 @@ static int do_rmmod(int argc, char *argv[])
 			goto next;
 		}
 
-		err = kmod_module_remove_module(mod, flags);
+		err = kmod_module_remove_module_wait(mod, flags,
+						     do_remove_patient);
 		if (err < 0) {
 			ERR("could not remove module %s: %s\n", arg,
 			    strerror(-err));
-- 
2.30.2

