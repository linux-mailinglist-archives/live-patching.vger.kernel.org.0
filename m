Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44896415A52
	for <lists+live-patching@lfdr.de>; Thu, 23 Sep 2021 10:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240023AbhIWIxa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Sep 2021 04:53:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:52007 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239985AbhIWIx3 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Sep 2021 04:53:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10115"; a="246248261"
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="246248261"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2021 01:51:57 -0700
X-IronPort-AV: E=Sophos;i="5.85,316,1624345200"; 
   d="scan'208";a="474784008"
Received: from eugenias-mobl.amr.corp.intel.com (HELO ldmartin-desk2) ([10.252.133.66])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2021 01:51:56 -0700
Date:   Thu, 23 Sep 2021 01:51:56 -0700
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        fstests@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de,
        dgilbert@interlog.com, jeyu@kernel.org, osandov@fb.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] libkmod-module: add support for a patient module
 removal option
Message-ID: <20210923085156.scmf5wxr2phc356b@ldmartin-desk2>
References: <20210810051602.3067384-1-mcgrof@kernel.org>
 <20210810051602.3067384-4-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210810051602.3067384-4-mcgrof@kernel.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Aug 09, 2021 at 10:16:02PM -0700, Luis Chamberlain wrote:
>When doing tests with modules such as scsi_debug, on test
>frameworks such as fstests [0] you may run into situations
>where false positives are triggered and a test fails but
>the reality is that the test did not fail, but what did
>fail was the removal of the module since the refcnt is
>not yet 0. There are many races possible with modules,
>and each subsystem would have their own quirks for why
>these races exist. Additionally, even after the refcnt is
>0, userspace cannot be sure in any way that the refcnt
>will remain 0, and so its easy to run into a situation
>where the refcnt is bumped from 0 after modprobe just
>saw it as 0.
>
>The scsi_debug races are all documented on korg#21233 [1],
>some issues are part scsi_debug alone, however other parts
>of the race issue are completely due to incomplete described
>semantics for modules and the inability for userspace to be
>100% sure that a race cannot happen to bump the refcnt
>once it observes the refcnt is 0.
>
>I've written a script mod-refcnt-race.sh attached to
>korg#214015 [2] which helps us easily reproduce the races
>described and abstracts them away from fstests. This can be
>used to both verify the issue and also test the new kmod
>patient module remover. The same bug report also has a
>simple busy-open-block-device-sleep.c which busy opens
>a block device, sleep 4 seconds in a loop, closes the
>file descriptor, which can easily be used to force failure
>of the module removal (delete_module()) and test this
>new patient removal.
>
>Although there are patches for fstests to account for
>this [3] and work around it, a much suitable solution
>long term is for these hacks to use a patient module
>remover from kmod and modprobe directly. This patch does
>just that, it adds these new arguments to modprobe and
>rmmod:
>
> -p | --remove-patiently   patiently removes the module
> -t | --timeout            timeout in ms to remove the module
>
>The patient removal works by polling until the module refcnt
>/sys/module/name/refcnt goes to 0. One that does happens it
>tries to also patiently remove the module. This second step
>is required as a new temporary refcnt bump can occur after
>a module refcnt becomes 0. By default modprobe and rmmod
>will wait forever, however a timeout can be specified to
>in milliseconds to ensure only that amount of time is
>spent trying to remove the module.
>
>If a timeout is used it applies cumulatively to both the
>refcnt wait, and for trying to remove the module once
>modprobe sees the refcnt is already 0.
>
>This new fatures is useful for cases where you know the
>refcnt is going to become 0, and it is just a matter of time,
>such as with many fstests / blktests tests.
>
>It is worth noting that prior to kernel v3.13 the kernel
>module delete system call used to support a wait flag,
>this was removed via commit 3f2b9c9cdf389 ("module: remove
>rmmod --wait option.") in favor for a 10 second sleep in
>kmod. A 10 second sleep does not address the issues, and
>so we must implement a patient removal properly in kmod.

The story was not kind like that. It wasn't removed "in favor for a 10
second sleep" in the sense that the sleep would replace the wait.

It was actually for "this wait logic in the kernel is complex and
buggy, let's try to remove it". So we decided to deprecate it and add
a sleep rmmod to see if anyone complained. 1 year later of no complains
we removed it from kernel. This was all after noticing we had never
implemented the wait logic in modprobe - it was only done in rmmod.


>
>[0] git://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git
>[1] https://bugzilla.kernel.org/show_bug.cgi?id=21233
>[2] https://bugzilla.kernel.org/show_bug.cgi?id=214015
>[3] https://lkml.kernel.org/r/20210727201045.2540681-1-mcgrof@kernel.org
>Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
>---
> libkmod/docs/libkmod-sections.txt  |   4 +
> libkmod/libkmod-module.c           | 328 +++++++++++++++++++++++++++++
> libkmod/libkmod.c                  |  71 +++++++
> libkmod/libkmod.h                  |   7 +
> libkmod/libkmod.sym                |   4 +
> libkmod/python/kmod/_libkmod_h.pxd |   3 +
> libkmod/python/kmod/module.pyx     |   4 +
> man/modprobe.xml                   |  59 ++++++
> man/rmmod.xml                      |  60 ++++++
> tools/modprobe.c                   |  21 +-
> tools/remove.c                     |  12 +-
> tools/rmmod.c                      |  27 ++-
> 12 files changed, 584 insertions(+), 16 deletions(-)
>
>diff --git a/libkmod/docs/libkmod-sections.txt b/libkmod/docs/libkmod-sections.txt
>index e59ab7a..a5b71d2 100644
>--- a/libkmod/docs/libkmod-sections.txt
>+++ b/libkmod/docs/libkmod-sections.txt
>@@ -12,6 +12,8 @@ kmod_dump_index
>
> kmod_set_log_priority
> kmod_get_log_priority
>+kmod_get_refcnt_timeout
>+kmod_set_refcnt_timeout
> kmod_set_log_fn
> kmod_get_userdata
> kmod_set_userdata
>@@ -56,6 +58,7 @@ kmod_module_unref_list
> kmod_module_insert_module
> kmod_module_probe_insert_module
> kmod_module_remove_module
>+kmod_module_remove_module_wait
>
> kmod_module_get_module
> kmod_module_get_dependencies
>@@ -102,5 +105,6 @@ kmod_module_get_initstate
> kmod_module_initstate_str
> kmod_module_get_size
> kmod_module_get_refcnt
>+kmod_module_get_refcnt_wait
> kmod_module_get_holders
> </SECTION>
>diff --git a/libkmod/libkmod-module.c b/libkmod/libkmod-module.c
>index 04bb4d9..2d54d1a 100644
>--- a/libkmod/libkmod-module.c
>+++ b/libkmod/libkmod-module.c
>@@ -30,6 +30,9 @@
> #include <stdlib.h>
> #include <string.h>
> #include <unistd.h>
>+#include <poll.h>
>+#include <time.h>
>+#include <math.h>
> #include <sys/mman.h>
> #include <sys/stat.h>
> #include <sys/syscall.h>
>@@ -802,6 +805,143 @@ KMOD_EXPORT int kmod_module_remove_module(struct kmod_module *mod,
> 	return err;
> }
>
>+static int timespec_to_ms(struct timespec *t)
>+{
>+	return (t->tv_sec * 1000) + lround(t->tv_nsec / 1000000);
>+}
>+
>+static int time_delta_ms(struct timespec *before, struct timespec *after)
>+{
>+	if (!before || !after)
>+		return 0;
>+	return timespec_to_ms(after) - timespec_to_ms(before);
>+}

we have a similar thing in util.[ch]

>+
>+/**
>+ * kmod_module_remove_module_wait:
>+ * @mod: kmod module
>+ * @flags: flags to pass to Linux kernel when removing the module. The only valid flag is
>+ * KMOD_REMOVE_FORCE: force remove module regardless if it's still in
>+ * use by a kernel subsystem or other process;
>+ * KMOD_REMOVE_NOWAIT is always enforced, causing us to pass O_NONBLOCK to
>+ * delete_module(2). We do the waiting in userspace, if a wait was desired.
>+ *
>+ * Remove a module from Linux kernel patiently.
>+ *
>+ * Returns: 0 on success or < 0 on failure.
>+ */
>+KMOD_EXPORT int kmod_module_remove_module_wait(struct kmod_module *mod,
>+					       unsigned int flags,
>+					       bool wait)

why do you have kmod_get_refcnt_timeout/kmod_set_refcnt_timeout instead
of just doing s/bool wait/unsigned int wait_msec/)?

>+{
>+	int err, err_time, t_delta, t_delta_print, orig_timeout;
>+	int time_between_prints = 500; /* 1/2 second */
>+	int timeout_ms;
>+	struct timespec t1, t2, t_print = { .tv_sec = 0, .tv_nsec = 0};
>+	bool printed_msg = false;
>+
>+	if (mod == NULL)
>+		return -ENOENT;
>+
>+	if (wait)
>+		timeout_ms = kmod_get_refcnt_timeout(mod->ctx);
>+
>+	if (!wait || !timeout_ms)
>+		return kmod_module_remove_module(mod, flags);
>+
>+	err_time = clock_gettime(CLOCK_MONOTONIC, &t1);
>+	if (err_time != 0)
>+		return kmod_module_remove_module(mod, flags);
>+
>+	/*
>+	 * We now know an original patient removal was requested and
>+	 * an associated timeout was also provided. timeout_removal_ms
>+	 * should be set with what we are left with.
>+	 */
>+	timeout_ms = orig_timeout = kmod_get_removal_timeout(mod->ctx);
>+	DBG(mod->ctx, "removal timeout is %d for '%s'\n", timeout_ms, mod->name);
>+
>+	/*
>+	 * Filter out other flags and force ONONBLOCK
>+	 *
>+	 * This is true even for the patient removal. The wait flag was
>+	 * a now deprecated flag, see kernel commits:
>+	 *
>+	 * 3f2b9c9cdf389e ("module: remove rmmod --wait option." on v3.13
>+	 * 79465d2fd48e68 ("module: remove warning about waiting module removal.") on v3.15
>+	 *
>+	 * Patient removal is a userspace implementation.
>+	 */
>+	flags &= KMOD_REMOVE_FORCE;
>+	flags |= KMOD_REMOVE_NOWAIT;
>+
>+	while (true) {
>+		err = delete_module(mod->name, flags);
>+		if (err == 0)
>+			return 0;
>+		err = -errno;
>+
>+		if (timeout_ms == 0) {
>+			ERR(mod->ctx, "timeout (%d) trying to remove module immediately '%s': %m %s\n",
>+			    timeout_ms, mod->name, strerror(errno));
>+			return err;
>+		}
>+
>+		/* Wait forever request */
>+		if (timeout_ms < 0) {
>+			if (!printed_msg) {
>+				NOTICE(mod->ctx, "%s trying forever to remove...\n",
>+				       mod->name);
>+				printed_msg = true;
>+			}
>+			continue;
>+		}
>+
>+		/* All below is when we know we have a timeout */
>+
>+		err_time = clock_gettime(CLOCK_MONOTONIC, &t2);
>+		if (err_time != 0) {
>+			ERR(mod->ctx, "Using CLOCK_MONOTONIC failed, cannot wait, prior module removal module failed for '%s': %m %s\n",
>+			    mod->name, strerror(errno));
>+			return err;
>+		}
>+
>+		t_delta = time_delta_ms(&t1, &t2);
>+		DBG(mod->ctx, "%s removal time delta: %d ms\n", mod->name, t_delta);
>+
>+		if (t_delta >= orig_timeout) {
>+			ERR(mod->ctx, "timeout (%d) trying to remove module '%s': %m %s\n",
>+			    timeout_ms, mod->name, strerror(errno));
>+			return err;
>+		}
>+
>+		/*
>+		 * We have more time to remove the module. The above check
>+		 * also ensures that timeout_ms won't ever be 0.
>+		 */
>+		timeout_ms = orig_timeout - t_delta;
>+
>+		if (!printed_msg) {
>+			NOTICE(mod->ctx, "%s removal failed. Re-trying for %d more ms (total timeout of %d ms)\n",
>+			       mod->name, timeout_ms, orig_timeout);
>+			t_print = t2;
>+			printed_msg = true;
>+		} else {
>+			/*
>+			 * Computes the delta between our last print
>+			 * and the time of our current current
>+			 * evaluation.
>+			 */
>+			t_delta_print = time_delta_ms(&t_print, &t2);
>+			if (t_delta_print < time_between_prints)
>+				continue;
>+			NOTICE(mod->ctx, "%s removal failed. Re-trying for %d more ms (total timeout of %d ms)\n",
>+			       mod->name, timeout_ms, orig_timeout);
>+			t_print = t2;
>+		}
>+	}
>+}
>+
> extern long init_module(const void *mem, unsigned long len, const char *args);
>
> /**
>@@ -1926,6 +2066,194 @@ KMOD_EXPORT int kmod_module_get_refcnt(const struct kmod_module *mod)
> 	return (int)refcnt;
> }
>
>+/**
>+ * kmod_module_get_refcnt_wait:
>+ * @mod: kmod module
>+ * @wait: if true will wait until the refcnt is 0 patiently forever
>+ *
>+ * Get the ref count of this @mod, as returned by Linux Kernel, by reading
>+ * /sys filesystem and wait patiently until the refcnt is 0, if the wait bool
>+ * argument is set to true, otherwise this behaves just as the call
>+ * kmod_module_get_refcnt(). Enabling wait is useful if you know for sure that
>+ * the module is quiescing soon, and so you should be able to remove it soon.
>+ * If wait is enabled, we wait a predetermined timeout setting which is
>+ * is configurable with kmod_set_refcnt_timeout(), by default we wait
>+ * forever.
>+ *
>+ * Returns: the reference count on success or < 0 on failure.
>+ */
>+KMOD_EXPORT int kmod_module_get_refcnt_wait(const struct kmod_module *mod, bool wait)
>+{
>+	struct pollfd fdset;
>+	int err, err_time, num_fds=1, t_delta, t_delta_print, orig_timeout;
>+	int time_between_prints = 500; /* 1/2 second */
>+	int timeout_ms;
>+	long refcnt;
>+	struct timespec t1, t2, t_print = { .tv_sec = 0, .tv_nsec = 0};
>+	bool printed_msg = false;
>+
>+	if (wait)
>+		timeout_ms = kmod_get_refcnt_timeout(mod->ctx);
>+
>+	if (!wait || !timeout_ms)
>+		return kmod_module_get_refcnt(mod);
>+
>+	orig_timeout = timeout_ms;
>+
>+	/*
>+	 * The refcnt may be something like 2, and poll() may return when
>+	 * the refcnt becomes 1, and so we must also check for the overall
>+	 * time ran and on each instance make the timeout available shorter
>+	 *
>+	 * If using the CLOCK_MONOTONIC failed and we have a timeout set, we
>+	 * simply cannot wait as we cannot trust time differences.
>+	 */
>+	err_time = clock_gettime(CLOCK_MONOTONIC, &t1);
>+	if (err_time != 0) {
>+		ERR(mod->ctx, "Using the CLOCK_MONOTONIC failed (%s) so processing removal for %s without a wait for the refcnt\n",
>+		    strerror(errno), mod->name);
>+		return kmod_module_get_refcnt(mod);
>+	}
>+
>+	kmod_set_removal_timeout(mod->ctx, orig_timeout);
>+
>+	while (true) {
>+		DBG(mod->ctx, "%s about to poll for refcnt using timeout %d ms\n", mod->name, timeout_ms);
>+		memset(&fdset, 0, sizeof(struct pollfd));
>+		fdset.events = POLLPRI | POLLIN;
>+		fdset.fd = kmod_module_get_refcnt_fd(mod);
>+		if (fdset.fd < 0)
>+			return fdset.fd;
>+		err = poll(&fdset, num_fds, timeout_ms);
>+		if (err == -1) {
>+			DBG(mod->ctx, "%s refcnt poll failed with err: %s\n", mod->name, strerror(errno));
>+			goto err;
>+		}
>+		if (err == 0) { /* timeout before fds were read */
>+			NOTICE(mod->ctx, "%s refcnt did not become 0 after %d ms\n",
>+			       mod->name, orig_timeout);
>+			kmod_set_removal_timeout(mod->ctx, 0);
>+			err = -ETIMEDOUT;
>+			goto err;
>+		}
>+		if (err != num_fds) { /* on success, we only asked for one fd */
>+			err = -EINVAL;
>+			goto err;
>+		}
>+		if (!fdset.revents) {
>+			close(fdset.fd);
>+			continue;
>+		}
>+		if ((!fdset.revents & POLLIN)) {
>+			err = -EINVAL;
>+			goto err;
>+		}
>+
>+		err = read_str_long(fdset.fd, &refcnt, 10);
>+		if (err < 0)
>+			goto err;
>+
>+		close(fdset.fd);
>+
>+		if ((refcnt <= 0) || (refcnt > 0 && !wait)) {
>+			NOTICE(mod->ctx, "%s refcnt is %d\n", mod->name, (int) refcnt);
>+			err_time = clock_gettime(CLOCK_MONOTONIC, &t2);
>+			if (err_time != 0)
>+				kmod_set_removal_timeout(mod->ctx, 0);

I don't follow why kmod_module_get_refcnt_wait() is setting the removal
timeout at all. This seems to be doing it behind users back.

The idea of using the refcnt fd was actually that then
users could integrate it on their mainloops (probably using epoll). And
then the same impl could be shared by kmod_module_remove_module_wait(),
which would do a select().

This seems more like a kmod_module_refcnt_wait_zero() using poll()
+ adjusting the timeout

...

>diff --git a/tools/rmmod.c b/tools/rmmod.c
>index 3942e7b..77c813a 100644
>--- a/tools/rmmod.c
>+++ b/tools/rmmod.c
>@@ -35,10 +35,12 @@
> #define DEFAULT_VERBOSE LOG_ERR
> static int verbose = DEFAULT_VERBOSE;
> static int use_syslog;
>+static int do_remove_patient;
>
>-static const char cmdopts_s[] = "fsvVwh";
>+static const char cmdopts_s[] = "fpsvVwh";
> static const struct option cmdopts[] = {
> 	{"force", no_argument, 0, 'f'},
>+	{"remove-patiently", no_argument, 0, 'p'},
> 	{"syslog", no_argument, 0, 's'},
> 	{"verbose", no_argument, 0, 'v'},
> 	{"version", no_argument, 0, 'V'},
>@@ -51,13 +53,14 @@ static void help(void)
> 	printf("Usage:\n"
> 		"\t%s [options] modulename ...\n"
> 		"Options:\n"
>-		"\t-f, --force       forces a module unload and may crash your\n"
>-		"\t                  machine. This requires Forced Module Removal\n"
>-		"\t                  option in your kernel. DANGEROUS\n"
>-		"\t-s, --syslog      print to syslog, not stderr\n"
>-		"\t-v, --verbose     enables more messages\n"
>-		"\t-V, --version     show version\n"
>-		"\t-h, --help        show this help\n",
>+		"\t-f, --force            forces a module unload and may crash your\n"
>+		"\t                       machine. This requires Forced Module Removal\n"
>+		"\t                       option in your kernel. DANGEROUS\n"
>+		"\t-p, --remove-patiently patiently tries to remove the module\n"
>+		"\t-s, --syslog           print to syslog, not stderr\n"
>+		"\t-v, --verbose          enables more messages\n"
>+		"\t-V, --version          show version\n"
>+		"\t-h, --help             show this help\n",
> 		program_invocation_short_name);
> }
>
>@@ -93,7 +96,7 @@ static int check_module_inuse(struct kmod_module *mod) {
> 		return -EBUSY;
> 	}
>
>-	ret = kmod_module_get_refcnt(mod);
>+	ret = kmod_module_get_refcnt_wait(mod, do_remove_patient);

for tool implementation, shouldn't we just ignore
kmod_module_get_refcnt() and proceed to
kmod_module_remove_module_wait()?

> 	if (ret > 0) {
> 		ERR("Module %s is in use\n", kmod_module_get_name(mod));
> 		return -EBUSY;
>@@ -120,6 +123,9 @@ static int do_rmmod(int argc, char *argv[])
> 		case 'f':
> 			flags |= KMOD_REMOVE_FORCE;
> 			break;
>+		case 'p':
>+			do_remove_patient = 1;
>+			break;
> 		case 's':
> 			use_syslog = 1;
> 			break;
>@@ -178,7 +184,8 @@ static int do_rmmod(int argc, char *argv[])
> 			goto next;
> 		}
>
>-		err = kmod_module_remove_module(mod, flags);
>+		err = kmod_module_remove_module_wait(mod, flags,
>+						     do_remove_patient);
> 		if (err < 0) {
> 			ERR("could not remove module %s: %s\n", arg,
> 			    strerror(-err));
>-- 
>2.30.2
>
