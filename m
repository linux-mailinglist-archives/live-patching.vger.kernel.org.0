Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4169D29ED9C
	for <lists+live-patching@lfdr.de>; Thu, 29 Oct 2020 14:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbgJ2NvO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 29 Oct 2020 09:51:14 -0400
Received: from mx2.suse.de ([195.135.220.15]:42434 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgJ2NvO (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 29 Oct 2020 09:51:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 08F11B921;
        Thu, 29 Oct 2020 13:51:12 +0000 (UTC)
Date:   Thu, 29 Oct 2020 14:51:06 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 6/9] livepatch/ftrace: Add recursion protection to the
 ftrace callback
In-Reply-To: <20201028115613.291169246@goodmis.org>
Message-ID: <alpine.LSU.2.21.2010291443310.1688@pobox.suse.cz>
References: <20201028115244.995788961@goodmis.org> <20201028115613.291169246@goodmis.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 28 Oct 2020, Steven Rostedt wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> If a ftrace callback does not supply its own recursion protection and
> does not set the RECURSION_SAFE flag in its ftrace_ops, then ftrace will
> make a helper trampoline to do so before calling the callback instead of
> just calling the callback directly.
> 
> The default for ftrace_ops is going to assume recursion protection unless
> otherwise specified.

Hm, I've always thought that we did not need any kind of recursion 
protection for our callback. It is marked as notrace and it does not call 
anything traceable. In fact, it does not call anything. I even have a note 
in my todo list to mark the callback as RECURSION_SAFE :)

At the same time, it probably does not hurt and the patch is still better 
than what we have now without RECURSION_SAFE if I understand the patch set 
correctly.
 
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Miroslav Benes <mbenes@suse.cz>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Joe Lawrence <joe.lawrence@redhat.com>
> Cc: live-patching@vger.kernel.org
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  kernel/livepatch/patch.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
> index b552cf2d85f8..6c0164d24bbd 100644
> --- a/kernel/livepatch/patch.c
> +++ b/kernel/livepatch/patch.c
> @@ -45,9 +45,13 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>  	struct klp_ops *ops;
>  	struct klp_func *func;
>  	int patch_state;
> +	int bit;
>  
>  	ops = container_of(fops, struct klp_ops, fops);
>  
> +	bit = ftrace_test_recursion_trylock();
> +	if (bit < 0)
> +		return;

This means that the original function will be called in case of recursion. 
That's probably fair, but I'm wondering if we should at least WARN about 
it.

Thanks
Miroslav
