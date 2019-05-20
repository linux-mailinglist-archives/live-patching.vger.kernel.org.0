Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C16A724283
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2019 23:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbfETVJH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 May 2019 17:09:07 -0400
Received: from out.bound.email ([141.193.244.10]:40639 "EHLO out.bound.email"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726011AbfETVJG (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 May 2019 17:09:06 -0400
Received: from mail.sventech.com (localhost [127.0.0.1])
        by out.bound.email (Postfix) with ESMTP id 439CD8A0E7F;
        Mon, 20 May 2019 14:09:05 -0700 (PDT)
Received: by mail.sventech.com (Postfix, from userid 1000)
        id 274081600410; Mon, 20 May 2019 14:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=erdfelt.com;
        s=default; t=1558386545;
        bh=xU6g15EXGCMbWAOPauiN9nJkNv/D1JF1EBTbDw6AtOI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tB4t0kZC5E/HYsUSpHa9Hko6uEJYa3Dp5ba3SKIR3feB7Uw9YEkZ42j0CmEQrXl97
         tQuESjH9q4FN90SMBDRC3UwcZAg5AZGoTbD9utYf7/Ju+i9YZtR8bD5/tPQBUwjn9v
         nL3S0G5LBwRWQ5rnjl3BWUJnAGKAk481dQBlGAus=
Date:   Mon, 20 May 2019 14:09:05 -0700
From:   Johannes Erdfelt <johannes@erdfelt.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, Jessica Yu <jeyu@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Oops caused by race between livepatch and ftrace
Message-ID: <20190520210905.GC1646@sventech.com>
References: <20190520194915.GB1646@sventech.com>
 <90f78070-95ec-ce49-1641-19d061abecf4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90f78070-95ec-ce49-1641-19d061abecf4@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, May 20, 2019, Joe Lawrence <joe.lawrence@redhat.com> wrote:
> [ fixed jeyu's email address ]

Thank you, the bounce message made it seem like my mail server was
blocked and not that the address didn't exist.

I think MAINTAINERS needs an update since it still has the @redhat.com
address.

> On 5/20/19 3:49 PM, Johannes Erdfelt wrote:
> > [ ... snip ... ]
> > 
> > I have put together a test case that can reproduce the crash using
> > KVM. The tarball includes a minimal kernel and initramfs, along with
> > a script to run qemu and the .config used to build the kernel. By
> > default it will attempt to reproduce by loading multiple livepatches
> > at the same time. Passing 'test=ftrace' to the script will attempt to
> > reproduce by racing with ftrace.
> > 
> > My test setup reproduces the race and oops more reliably by loading
> > multiple livepatches at the same time than with the ftrace method. It's
> > not 100% reproducible, so the test case may need to be run multiple
> > times.
> > 
> > It can be found here (not attached because of its size):
> > http://johannes.erdfelt.com/5.2.0-rc1-a188339ca5-livepatch-race.tar.gz
> 
> Hi Johannes,
> 
> This is cool way to distribute the repro kernel, modules, etc!

This oops was common in our production environment and was particularly
annoying since livepatches would load at boot and early enough to happen
before networking and SSH were started.

Unfortunately it was difficult to reproduce on other hardware (changing
the timing just enough) and our production environment is very
complicated.

I spent more time than I'd like to admit trying to reproduce this fairly
reliably. I knew that I needed to help make it as easy as possible to
reproduce to root cause it and for others to take a look at it as well.

> These two testing scenarios might be interesting to add to our selftests
> suite.  Can you post or add the source(s) to livepatch-test<n>.ko to the
> tarball?

I made the livepatches using kpatch-build and this simple patch:

diff --git a/fs/proc/version.c b/fs/proc/version.c
index 94901e8e700d..6b8a3449f455 100644
--- a/fs/proc/version.c
+++ b/fs/proc/version.c
@@ -12,6 +12,7 @@ static int version_proc_show(struct seq_file *m, void *v)
 		utsname()->sysname,
 		utsname()->release,
 		utsname()->version);
+	seq_printf(m, "example livepatch\n");
 	return 0;
 }

I just created enough livepatches with the same source patch so that I
could reproduce the issue somewhat reliably.

I'll see if I can make something that uses klp directly.

The rest of the userspace in the initramfs is really straight forward
with the only interesting parts being a couple of shell scripts.

JE
 
