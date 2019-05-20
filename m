Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFEF7242A7
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2019 23:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfETVTt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 May 2019 17:19:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58036 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725989AbfETVTt (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 May 2019 17:19:49 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8FDE0301E3D2;
        Mon, 20 May 2019 21:19:40 +0000 (UTC)
Received: from treble (ovpn-125-173.rdu2.redhat.com [10.10.125.173])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C6935D704;
        Mon, 20 May 2019 21:19:33 +0000 (UTC)
Date:   Mon, 20 May 2019 16:19:31 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Johannes Erdfelt <johannes@erdfelt.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Oops caused by race between livepatch and ftrace
Message-ID: <20190520211931.vokbqxkx5kb6k2bz@treble>
References: <20190520194915.GB1646@sventech.com>
 <90f78070-95ec-ce49-1641-19d061abecf4@redhat.com>
 <20190520210905.GC1646@sventech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190520210905.GC1646@sventech.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 20 May 2019 21:19:48 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, May 20, 2019 at 02:09:05PM -0700, Johannes Erdfelt wrote:
> On Mon, May 20, 2019, Joe Lawrence <joe.lawrence@redhat.com> wrote:
> > [ fixed jeyu's email address ]
> 
> Thank you, the bounce message made it seem like my mail server was
> blocked and not that the address didn't exist.
> 
> I think MAINTAINERS needs an update since it still has the @redhat.com
> address.

I think you must have been looking at an old version.

[(v5.2-rc1)] ~/git/linux $ grep jeyu MAINTAINERS
M:	Jessica Yu <jeyu@kernel.org>

> > On 5/20/19 3:49 PM, Johannes Erdfelt wrote:
> > > [ ... snip ... ]
> > > 
> > > I have put together a test case that can reproduce the crash using
> > > KVM. The tarball includes a minimal kernel and initramfs, along with
> > > a script to run qemu and the .config used to build the kernel. By
> > > default it will attempt to reproduce by loading multiple livepatches
> > > at the same time. Passing 'test=ftrace' to the script will attempt to
> > > reproduce by racing with ftrace.
> > > 
> > > My test setup reproduces the race and oops more reliably by loading
> > > multiple livepatches at the same time than with the ftrace method. It's
> > > not 100% reproducible, so the test case may need to be run multiple
> > > times.
> > > 
> > > It can be found here (not attached because of its size):
> > > http://johannes.erdfelt.com/5.2.0-rc1-a188339ca5-livepatch-race.tar.gz
> > 
> > Hi Johannes,
> > 
> > This is cool way to distribute the repro kernel, modules, etc!
> 
> This oops was common in our production environment and was particularly
> annoying since livepatches would load at boot and early enough to happen
> before networking and SSH were started.
> 
> Unfortunately it was difficult to reproduce on other hardware (changing
> the timing just enough) and our production environment is very
> complicated.
> 
> I spent more time than I'd like to admit trying to reproduce this fairly
> reliably. I knew that I needed to help make it as easy as possible to
> reproduce to root cause it and for others to take a look at it as well.

Can you try this patch (completely untested)?

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index 91cd519756d3..2d17e6e364b5 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -30,6 +30,7 @@
 #include <linux/elf.h>
 #include <linux/moduleloader.h>
 #include <linux/completion.h>
+#include <linux/memory.h>
 #include <asm/cacheflush.h>
 #include "core.h"
 #include "patch.h"
@@ -730,16 +731,21 @@ static int klp_init_object_loaded(struct klp_patch *patch,
 	struct klp_func *func;
 	int ret;
 
+	mutex_lock(&text_mutex);
+
 	module_disable_ro(patch->mod);
 	ret = klp_write_object_relocations(patch->mod, obj);
 	if (ret) {
 		module_enable_ro(patch->mod, true);
+		mutex_unlock(&text_mutex);
 		return ret;
 	}
 
 	arch_klp_init_object_loaded(patch, obj);
 	module_enable_ro(patch->mod, true);
 
+	mutex_unlock(&text_mutex);
+
 	klp_for_each_func(obj, func) {
 		ret = klp_find_object_symbol(obj->name, func->old_name,
 					     func->old_sympos,
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index a12aff849c04..8259d4ba8b00 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -34,6 +34,7 @@
 #include <linux/hash.h>
 #include <linux/rcupdate.h>
 #include <linux/kprobes.h>
+#include <linux/memory.h>
 
 #include <trace/events/sched.h>
 
@@ -2610,10 +2611,12 @@ static void ftrace_run_update_code(int command)
 {
 	int ret;
 
+	mutex_lock(&text_mutex);
+
 	ret = ftrace_arch_code_modify_prepare();
 	FTRACE_WARN_ON(ret);
 	if (ret)
-		return;
+		goto out_unlock;
 
 	/*
 	 * By default we use stop_machine() to modify the code.
@@ -2625,6 +2628,9 @@ static void ftrace_run_update_code(int command)
 
 	ret = ftrace_arch_code_modify_post_process();
 	FTRACE_WARN_ON(ret);
+
+out_unlock:
+	mutex_unlock(&text_mutex);
 }
 
 static void ftrace_run_modify_code(struct ftrace_ops *ops, int command,
@@ -5776,6 +5782,7 @@ void ftrace_module_enable(struct module *mod)
 	struct ftrace_page *pg;
 
 	mutex_lock(&ftrace_lock);
+	mutex_lock(&text_mutex);
 
 	if (ftrace_disabled)
 		goto out_unlock;
@@ -5837,6 +5844,7 @@ void ftrace_module_enable(struct module *mod)
 		ftrace_arch_code_modify_post_process();
 
  out_unlock:
+	mutex_unlock(&text_mutex);
 	mutex_unlock(&ftrace_lock);
 
 	process_cached_mods(mod->name);
