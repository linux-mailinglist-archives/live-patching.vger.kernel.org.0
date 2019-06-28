Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE2FC58F99
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2019 03:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfF1BRh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 27 Jun 2019 21:17:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37110 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbfF1BRh (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 27 Jun 2019 21:17:37 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B6BF2307CDD5;
        Fri, 28 Jun 2019 01:17:36 +0000 (UTC)
Received: from treble (ovpn-126-66.rdu2.redhat.com [10.10.126.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AE6215D9D2;
        Fri, 28 Jun 2019 01:17:28 +0000 (UTC)
Date:   Thu, 27 Jun 2019 20:17:25 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] ftrace: Remove possible deadlock between
 register_kprobe() and ftrace_run_update_code()
Message-ID: <20190628011725.rctv3chdlqwkfwcx@treble>
References: <20190627081334.12793-1-pmladek@suse.com>
 <20190627224729.tshtq4bhzhneq24w@treble>
 <20190627190457.703a486e@gandalf.local.home>
 <alpine.DEB.2.21.1906280106360.32342@nanos.tec.linutronix.de>
 <20190627231952.nqkbtcculvo2ddif@treble>
 <20190627211304.7e21fd77@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190627211304.7e21fd77@gandalf.local.home>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Fri, 28 Jun 2019 01:17:36 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jun 27, 2019 at 09:13:04PM -0400, Steven Rostedt wrote:
> On Thu, 27 Jun 2019 18:19:52 -0500
> Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> 
> 
> > Maybe a comment or two would help though.
> > 
> 
> I'm adding the following change.  Care to add a "reviewed-by" for this
> one?
> 
> -- Steve
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

For the patch+comment:

Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
