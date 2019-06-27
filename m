Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C98558E3C
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2019 01:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfF0XFB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 27 Jun 2019 19:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbfF0XFB (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 27 Jun 2019 19:05:01 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69A26208E3;
        Thu, 27 Jun 2019 23:04:59 +0000 (UTC)
Date:   Thu, 27 Jun 2019 19:04:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
        Jessica Yu <jeyu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH] ftrace: Remove possible deadlock between
 register_kprobe() and ftrace_run_update_code()
Message-ID: <20190627190457.703a486e@gandalf.local.home>
In-Reply-To: <20190627224729.tshtq4bhzhneq24w@treble>
References: <20190627081334.12793-1-pmladek@suse.com>
        <20190627224729.tshtq4bhzhneq24w@treble>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 27 Jun 2019 17:47:29 -0500
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> Thanks a lot for fixing this Petr.
> 
> On Thu, Jun 27, 2019 at 10:13:34AM +0200, Petr Mladek wrote:
> > @@ -35,6 +36,7 @@
> >  
> >  int ftrace_arch_code_modify_prepare(void)
> >  {
> > +	mutex_lock(&text_mutex);
> >  	set_kernel_text_rw();
> >  	set_all_modules_text_rw();
> >  	return 0;
> > @@ -44,6 +46,7 @@ int ftrace_arch_code_modify_post_process(void)
> >  {
> >  	set_all_modules_text_ro();
> >  	set_kernel_text_ro();
> > +	mutex_unlock(&text_mutex);
> >  	return 0;
> >  }  
> 
> Releasing the lock in a separate function seems a bit surprising and
> fragile, would it be possible to do something like this instead?
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index b38c388d1087..89ea1af6fd13 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -37,15 +37,21 @@
>  int ftrace_arch_code_modify_prepare(void)
>  {
>  	mutex_lock(&text_mutex);
> +
>  	set_kernel_text_rw();
>  	set_all_modules_text_rw();
> +
> +	mutex_unlock(&text_mutex);
>  	return 0;
>  }
>  
>  int ftrace_arch_code_modify_post_process(void)
>  {
> +	mutex_lock(&text_mutex);
> +
>  	set_all_modules_text_ro();
>  	set_kernel_text_ro();
> +
>  	mutex_unlock(&text_mutex);
>  	return 0;
>  }

I agree with Josh on this. As the original bug was the race between
ftrace and live patching / modules changing the text from ro to rw and
vice versa. Just protecting the update to the text permissions is more
robust, and should be more self documenting when we need to handle
other architectures for this.

-- Steve
