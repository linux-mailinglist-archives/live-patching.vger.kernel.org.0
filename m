Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98AE5242EE
	for <lists+live-patching@lfdr.de>; Mon, 20 May 2019 23:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbfETVjN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 20 May 2019 17:39:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbfETVjN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 20 May 2019 17:39:13 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0548D2171F;
        Mon, 20 May 2019 21:39:11 +0000 (UTC)
Date:   Mon, 20 May 2019 17:39:10 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Johannes Erdfelt <johannes@erdfelt.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Oops caused by race between livepatch and ftrace
Message-ID: <20190520173910.6da9ddaf@gandalf.local.home>
In-Reply-To: <20190520211931.vokbqxkx5kb6k2bz@treble>
References: <20190520194915.GB1646@sventech.com>
        <90f78070-95ec-ce49-1641-19d061abecf4@redhat.com>
        <20190520210905.GC1646@sventech.com>
        <20190520211931.vokbqxkx5kb6k2bz@treble>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 20 May 2019 16:19:31 -0500
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index a12aff849c04..8259d4ba8b00 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -34,6 +34,7 @@
>  #include <linux/hash.h>
>  #include <linux/rcupdate.h>
>  #include <linux/kprobes.h>
> +#include <linux/memory.h>
>  
>  #include <trace/events/sched.h>
>  
> @@ -2610,10 +2611,12 @@ static void ftrace_run_update_code(int command)
>  {
>  	int ret;
>  
> +	mutex_lock(&text_mutex);
> +

Hmm, this may blow up with lockdep, as I believe we already have a
locking dependency of:

 text_mutex -> ftrace_lock

And this will reverses it. (kprobes appears to take the locks in this
order).

Perhaps have live kernel patching grab ftrace_lock?

-- Steve


>  	ret = ftrace_arch_code_modify_prepare();
>  	FTRACE_WARN_ON(ret);
>  	if (ret)
> -		return;
> +		goto out_unlock;
>  
>  	/*
>  	 * By default we use stop_machine() to modify the code.
> @@ -2625,6 +2628,9 @@ static void ftrace_run_update_code(int command)
>  
>  	ret = ftrace_arch_code_modify_post_process();
>  	FTRACE_WARN_ON(ret);
> +
> +out_unlock:
> +	mutex_unlock(&text_mutex);
>  }
>  
>  static void ftrace_run_modify_code(struct ftrace_ops *ops, int command,
> @@ -5776,6 +5782,7 @@ void ftrace_module_enable(struct module *mod)
>  	struct ftrace_page *pg;
>  
>  	mutex_lock(&ftrace_lock);
> +	mutex_lock(&text_mutex);
>  
>  	if (ftrace_disabled)
>  		goto out_unlock;
> @@ -5837,6 +5844,7 @@ void ftrace_module_enable(struct module *mod)
>  		ftrace_arch_code_modify_post_process();
>  
>   out_unlock:
> +	mutex_unlock(&text_mutex);
>  	mutex_unlock(&ftrace_lock);
>  
>  	process_cached_mods(mod->name);

