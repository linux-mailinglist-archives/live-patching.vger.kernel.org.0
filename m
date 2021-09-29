Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1747E41CC1B
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 20:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346325AbhI2SuS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 14:50:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:62449 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346078AbhI2SuQ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 14:50:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10122"; a="212270450"
X-IronPort-AV: E=Sophos;i="5.85,334,1624345200"; 
   d="scan'208";a="212270450"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 11:48:34 -0700
X-IronPort-AV: E=Sophos;i="5.85,334,1624345200"; 
   d="scan'208";a="479374879"
Received: from ojefferi-mobl.ger.corp.intel.com (HELO ldmartin-desk2) ([10.212.173.172])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2021 11:48:32 -0700
Date:   Wed, 29 Sep 2021 11:48:31 -0700
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        fstests@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de,
        dgilbert@interlog.com, jeyu@kernel.org, osandov@fb.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] libkmod-module: add support for a patient module
 removal option
Message-ID: <20210929184810.adrqpsvlfybnc5qt@ldmartin-desk2>
X-Patchwork-Hint: comment
References: <20210810051602.3067384-1-mcgrof@kernel.org>
 <20210810051602.3067384-4-mcgrof@kernel.org>
 <20210923085156.scmf5wxr2phc356b@ldmartin-desk2>
 <YVJyIGXN/TR8zdU9@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YVJyIGXN/TR8zdU9@bombadil.infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Sep 27, 2021 at 06:38:40PM -0700, Luis Chamberlain wrote:
>On Thu, Sep 23, 2021 at 01:51:56AM -0700, Lucas De Marchi wrote:
>> On Mon, Aug 09, 2021 at 10:16:02PM -0700, Luis Chamberlain wrote:
>> The story was not kind like that. It wasn't removed "in favor for a 10
>> second sleep" in the sense that the sleep would replace the wait.
>>
>> It was actually for "this wait logic in the kernel is complex and
>> buggy, let's try to remove it". So we decided to deprecate it and add
>> a sleep rmmod to see if anyone complained. 1 year later of no complains
>> we removed it from kernel. This was all after noticing we had never
>> implemented the wait logic in modprobe - it was only done in rmmod.
>
>OK fixed the commit log thanks!
>
>> > --- a/libkmod/libkmod-module.c
>> > +++ b/libkmod/libkmod-module.c
>> > @@ -30,6 +30,9 @@
>> > #include <stdlib.h>
>> > #include <string.h>
>> > #include <unistd.h>
>> > +#include <poll.h>
>> > +#include <time.h>
>> > +#include <math.h>
>> > #include <sys/mman.h>
>> > #include <sys/stat.h>
>> > #include <sys/syscall.h>
>> > @@ -802,6 +805,143 @@ KMOD_EXPORT int kmod_module_remove_module(struct kmod_module *mod,
>> > 	return err;
>> > }
>> >
>> > +static int timespec_to_ms(struct timespec *t)
>> > +{
>> > +	return (t->tv_sec * 1000) + lround(t->tv_nsec / 1000000);
>> > +}
>> > +
>> > +static int time_delta_ms(struct timespec *before, struct timespec *after)
>> > +{
>> > +	if (!before || !after)
>> > +		return 0;
>> > +	return timespec_to_ms(after) - timespec_to_ms(before);
>> > +}
>>
>> we have a similar thing in util.[ch]
>
>Alright, this OK?
>
>diff --git a/shared/util.c b/shared/util.c
>index b487b5f..b911e63 100644
>--- a/shared/util.c
>+++ b/shared/util.c
>@@ -466,6 +466,19 @@ unsigned long long ts_usec(const struct timespec *ts)
> 	       (unsigned long long) ts->tv_nsec / NSEC_PER_USEC;
> }
>
>+unsigned long long ts_msec(const struct timespec *ts)
>+{
>+	return ts_usec(ts) * 1000;
>+}
>+
>+unsigned long long ts_delta_ms(const struct timespec *before,
>+			       const struct timespec *after)
>+{
>+	if (!before || !after)
>+		return 0;
>+	return ts_msec(after) - ts_msec(before);
>+}
>+
> unsigned long long stat_mstamp(const struct stat *st)
> {
> #ifdef HAVE_STRUCT_STAT_ST_MTIM
>diff --git a/shared/util.h b/shared/util.h
>index c6a31df..f8c28e7 100644
>--- a/shared/util.h
>+++ b/shared/util.h
>@@ -43,6 +43,9 @@ int mkdir_p(const char *path, int len, mode_t mode);
> int mkdir_parents(const char *path, mode_t mode);
> unsigned long long stat_mstamp(const struct stat *st);
> unsigned long long ts_usec(const struct timespec *ts);
>+unsigned long long ts_msec(const struct timespec *ts);
>+unsigned long long ts_delta_ms(const struct timespec *before,
>+			       const struct timespec *after);
>
> /* endianess and alignments                                                 */
> /* ************************************************************************ */
>
>> > +/**
>> > + * kmod_module_remove_module_wait:
>> > + * @mod: kmod module
>> > + * @flags: flags to pass to Linux kernel when removing the module. The only valid flag is
>> > + * KMOD_REMOVE_FORCE: force remove module regardless if it's still in
>> > + * use by a kernel subsystem or other process;
>> > + * KMOD_REMOVE_NOWAIT is always enforced, causing us to pass O_NONBLOCK to
>> > + * delete_module(2). We do the waiting in userspace, if a wait was desired.
>> > + *
>> > + * Remove a module from Linux kernel patiently.
>> > + *
>> > + * Returns: 0 on success or < 0 on failure.
>> > + */
>> > +KMOD_EXPORT int kmod_module_remove_module_wait(struct kmod_module *mod,
>> > +					       unsigned int flags,
>> > +					       bool wait)
>>
>> why do you have kmod_get_refcnt_timeout/kmod_set_refcnt_timeout instead
>> of just doing s/bool wait/unsigned int wait_msec/)?
>
>Because it lets us do a smaller change on the respetive tools:
>
>tools/modprobe.c-               flags |= KMOD_REMOVE_FORCE;
>tools/modprobe.c-
>tools/modprobe.c:       err = kmod_module_remove_module_wait(mod, flags, do_remove_patient);
>tools/modprobe.c-       if (err == -EEXIST) {
>tools/modprobe.c-               if (!first_time)
>--
>tools/remove.c-         goto unref;
>tools/remove.c-
>tools/remove.c: err = kmod_module_remove_module_wait(mod, 0, do_remove_patient);
>tools/remove.c- if (err < 0)
>tools/remove.c-         goto unref;
>--
>tools/rmmod.c-          }
>tools/rmmod.c-
>tools/rmmod.c:          err = kmod_module_remove_module_wait(mod, flags,
>tools/rmmod.c- do_remove_patient);
>tools/rmmod.c-          if (err < 0) {
>
>That is, the timeout is contextual of the context.
>
>> > +		if ((refcnt <= 0) || (refcnt > 0 && !wait)) {
>> > +			NOTICE(mod->ctx, "%s refcnt is %d\n", mod->name, (int) refcnt);
>> > +			err_time = clock_gettime(CLOCK_MONOTONIC, &t2);
>> > +			if (err_time != 0)
>> > +				kmod_set_removal_timeout(mod->ctx, 0);
>>
>> I don't follow why kmod_module_get_refcnt_wait() is setting the removal
>> timeout at all. This seems to be doing it behind users back.
>
>Because if clock_gettime() returns something other than 0 then
>your clock is messed up and you should not be using a timeout, so
>yes, we correct that then. We can scream loud, or use a default.
>
>I figured not using one would be better in that case.
>
>> The idea of using the refcnt fd was actually that then
>> users could integrate it on their mainloops (probably using epoll). And
>> then the same impl could be shared by kmod_module_remove_module_wait(),
>> which would do a select().
>>
>> This seems more like a kmod_module_refcnt_wait_zero() using poll()
>> + adjusting the timeout
>
>Sorry don't follow. And since I have one day before vacation, I suppose
>I won't get to this until I get back. But I'd be happy if you massage
>it as you see fit as you're used to the code base and I'm sure have
>a better idea of what likely is best for the library.


sure, np. I will take a look as time permits.

thanks
Lucas De Marchi

>
>> > +	ret = kmod_module_get_refcnt_wait(mod, do_remove_patient);
>>
>> for tool implementation, shouldn't we just ignore
>> kmod_module_get_refcnt() and proceed to
>> kmod_module_remove_module_wait()?
>
>I'll let you decide. Otherwise this will have to wait until I get back
>from vacation.
>
>  Luis
