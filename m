Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDE4041A4C4
	for <lists+live-patching@lfdr.de>; Tue, 28 Sep 2021 03:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238503AbhI1BkV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 27 Sep 2021 21:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238458AbhI1BkU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 27 Sep 2021 21:40:20 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D7FC061604;
        Mon, 27 Sep 2021 18:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xwta8/zLIpEcQkAo4oHfj0Dkwhwuhu/ZvQ6AUzjotmM=; b=eFLSa5qDbEwz7lGAPa61BV3kja
        0/wtVVb/HNao3rYKvQRCv5VYnO6QNgbEGMzWnGCQ/TE6HEGqe2qmzVaKs+Whnx2Zyfbw1ea3e4Otv
        JA/Y1ipbTjzWcUbp79Xm6dhG0LUOKAc5sRfDe8hDTVqZdyBtAIQfSk6nBv9vC3UhOEnwKA53PKQAJ
        DbYqxVtC2sv+emCbJ0UsqmVbCtUsiYksYsjoa+vL4A3rTJVbXhizjrdZxducXLSuQpYESffeqPcTh
        yb2Wz+tc7PsgzV12g0G2TvnfiXWKVwZzMQG8oqPpkfFhFZsdD1PJSzi05CMkU1eINfbHQr6SBoCzO
        ThOPf2Wg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mV24u-0056Lv-71; Tue, 28 Sep 2021 01:38:40 +0000
Date:   Mon, 27 Sep 2021 18:38:40 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        fstests@vger.kernel.org, linux-block@vger.kernel.org, hare@suse.de,
        dgilbert@interlog.com, jeyu@kernel.org, osandov@fb.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] libkmod-module: add support for a patient module
 removal option
Message-ID: <YVJyIGXN/TR8zdU9@bombadil.infradead.org>
References: <20210810051602.3067384-1-mcgrof@kernel.org>
 <20210810051602.3067384-4-mcgrof@kernel.org>
 <20210923085156.scmf5wxr2phc356b@ldmartin-desk2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923085156.scmf5wxr2phc356b@ldmartin-desk2>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Sep 23, 2021 at 01:51:56AM -0700, Lucas De Marchi wrote:
> On Mon, Aug 09, 2021 at 10:16:02PM -0700, Luis Chamberlain wrote:
> The story was not kind like that. It wasn't removed "in favor for a 10
> second sleep" in the sense that the sleep would replace the wait.
> 
> It was actually for "this wait logic in the kernel is complex and
> buggy, let's try to remove it". So we decided to deprecate it and add
> a sleep rmmod to see if anyone complained. 1 year later of no complains
> we removed it from kernel. This was all after noticing we had never
> implemented the wait logic in modprobe - it was only done in rmmod.

OK fixed the commit log thanks!

> > --- a/libkmod/libkmod-module.c
> > +++ b/libkmod/libkmod-module.c
> > @@ -30,6 +30,9 @@
> > #include <stdlib.h>
> > #include <string.h>
> > #include <unistd.h>
> > +#include <poll.h>
> > +#include <time.h>
> > +#include <math.h>
> > #include <sys/mman.h>
> > #include <sys/stat.h>
> > #include <sys/syscall.h>
> > @@ -802,6 +805,143 @@ KMOD_EXPORT int kmod_module_remove_module(struct kmod_module *mod,
> > 	return err;
> > }
> > 
> > +static int timespec_to_ms(struct timespec *t)
> > +{
> > +	return (t->tv_sec * 1000) + lround(t->tv_nsec / 1000000);
> > +}
> > +
> > +static int time_delta_ms(struct timespec *before, struct timespec *after)
> > +{
> > +	if (!before || !after)
> > +		return 0;
> > +	return timespec_to_ms(after) - timespec_to_ms(before);
> > +}
> 
> we have a similar thing in util.[ch]

Alright, this OK?

diff --git a/shared/util.c b/shared/util.c
index b487b5f..b911e63 100644
--- a/shared/util.c
+++ b/shared/util.c
@@ -466,6 +466,19 @@ unsigned long long ts_usec(const struct timespec *ts)
 	       (unsigned long long) ts->tv_nsec / NSEC_PER_USEC;
 }
 
+unsigned long long ts_msec(const struct timespec *ts)
+{
+	return ts_usec(ts) * 1000;
+}
+
+unsigned long long ts_delta_ms(const struct timespec *before,
+			       const struct timespec *after)
+{
+	if (!before || !after)
+		return 0;
+	return ts_msec(after) - ts_msec(before);
+}
+
 unsigned long long stat_mstamp(const struct stat *st)
 {
 #ifdef HAVE_STRUCT_STAT_ST_MTIM
diff --git a/shared/util.h b/shared/util.h
index c6a31df..f8c28e7 100644
--- a/shared/util.h
+++ b/shared/util.h
@@ -43,6 +43,9 @@ int mkdir_p(const char *path, int len, mode_t mode);
 int mkdir_parents(const char *path, mode_t mode);
 unsigned long long stat_mstamp(const struct stat *st);
 unsigned long long ts_usec(const struct timespec *ts);
+unsigned long long ts_msec(const struct timespec *ts);
+unsigned long long ts_delta_ms(const struct timespec *before,
+			       const struct timespec *after);
 
 /* endianess and alignments                                                 */
 /* ************************************************************************ */

> > +/**
> > + * kmod_module_remove_module_wait:
> > + * @mod: kmod module
> > + * @flags: flags to pass to Linux kernel when removing the module. The only valid flag is
> > + * KMOD_REMOVE_FORCE: force remove module regardless if it's still in
> > + * use by a kernel subsystem or other process;
> > + * KMOD_REMOVE_NOWAIT is always enforced, causing us to pass O_NONBLOCK to
> > + * delete_module(2). We do the waiting in userspace, if a wait was desired.
> > + *
> > + * Remove a module from Linux kernel patiently.
> > + *
> > + * Returns: 0 on success or < 0 on failure.
> > + */
> > +KMOD_EXPORT int kmod_module_remove_module_wait(struct kmod_module *mod,
> > +					       unsigned int flags,
> > +					       bool wait)
> 
> why do you have kmod_get_refcnt_timeout/kmod_set_refcnt_timeout instead
> of just doing s/bool wait/unsigned int wait_msec/)?

Because it lets us do a smaller change on the respetive tools:

tools/modprobe.c-               flags |= KMOD_REMOVE_FORCE;
tools/modprobe.c-
tools/modprobe.c:       err = kmod_module_remove_module_wait(mod, flags, do_remove_patient);
tools/modprobe.c-       if (err == -EEXIST) {
tools/modprobe.c-               if (!first_time)
--
tools/remove.c-         goto unref;
tools/remove.c-
tools/remove.c: err = kmod_module_remove_module_wait(mod, 0, do_remove_patient);
tools/remove.c- if (err < 0)
tools/remove.c-         goto unref;
--
tools/rmmod.c-          }
tools/rmmod.c-
tools/rmmod.c:          err = kmod_module_remove_module_wait(mod, flags,
tools/rmmod.c- do_remove_patient);
tools/rmmod.c-          if (err < 0) {

That is, the timeout is contextual of the context.

> > +		if ((refcnt <= 0) || (refcnt > 0 && !wait)) {
> > +			NOTICE(mod->ctx, "%s refcnt is %d\n", mod->name, (int) refcnt);
> > +			err_time = clock_gettime(CLOCK_MONOTONIC, &t2);
> > +			if (err_time != 0)
> > +				kmod_set_removal_timeout(mod->ctx, 0);
> 
> I don't follow why kmod_module_get_refcnt_wait() is setting the removal
> timeout at all. This seems to be doing it behind users back.

Because if clock_gettime() returns something other than 0 then
your clock is messed up and you should not be using a timeout, so
yes, we correct that then. We can scream loud, or use a default.

I figured not using one would be better in that case.

> The idea of using the refcnt fd was actually that then
> users could integrate it on their mainloops (probably using epoll). And
> then the same impl could be shared by kmod_module_remove_module_wait(),
> which would do a select().
> 
> This seems more like a kmod_module_refcnt_wait_zero() using poll()
> + adjusting the timeout

Sorry don't follow. And since I have one day before vacation, I suppose
I won't get to this until I get back. But I'd be happy if you massage
it as you see fit as you're used to the code base and I'm sure have
a better idea of what likely is best for the library.

> > +	ret = kmod_module_get_refcnt_wait(mod, do_remove_patient);
> 
> for tool implementation, shouldn't we just ignore
> kmod_module_get_refcnt() and proceed to
> kmod_module_remove_module_wait()?

I'll let you decide. Otherwise this will have to wait until I get back
from vacation.

  Luis
