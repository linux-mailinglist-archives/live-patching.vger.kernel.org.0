Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFDBA58FA1
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2019 03:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbfF1BVT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 27 Jun 2019 21:21:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53530 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726606AbfF1BVT (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 27 Jun 2019 21:21:19 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 88F9A307D91F;
        Fri, 28 Jun 2019 01:21:18 +0000 (UTC)
Received: from treble (ovpn-126-66.rdu2.redhat.com [10.10.126.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 88A9E60BEC;
        Fri, 28 Jun 2019 01:21:12 +0000 (UTC)
Date:   Thu, 27 Jun 2019 20:21:09 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] ftrace/x86: Add a comment to why we take text_mutex in
 ftrace_arch_code_modify_prepare()
Message-ID: <20190628012109.p7a2whpsnad5vjz7@treble>
References: <20190627211819.5a591f52@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190627211819.5a591f52@gandalf.local.home>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Fri, 28 Jun 2019 01:21:18 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jun 27, 2019 at 09:18:19PM -0400, Steven Rostedt wrote:
> 
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> Taking the text_mutex in ftrace_arch_code_modify_prepare() is to fix a
> race against module loading and live kernel patching that might try to
> change the text permissions while ftrace has it as read/write. This
> really needs to be documented in the code. Add a comment that does such.
> 
> Suggested-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/ftrace.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> index 33786044d5ac..d7e93b2783fd 100644
> --- a/arch/x86/kernel/ftrace.c
> +++ b/arch/x86/kernel/ftrace.c
> @@ -36,6 +36,11 @@
>  
>  int ftrace_arch_code_modify_prepare(void)
>  {
> +	/*
> +	 * Need to grab text_mutex to prevent a race from module loading
> +	 * and live kernel patching from changing the text permissions while
> +	 * ftrace has it set to "read/write".
> +	 */
>  	mutex_lock(&text_mutex);
>  	set_kernel_text_rw();
>  	set_all_modules_text_rw();
> -- 
> 2.20.1
> 

Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
