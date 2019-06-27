Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4831B58E55
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2019 01:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbfF0XJu (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 27 Jun 2019 19:09:50 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60043 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfF0XJu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 27 Jun 2019 19:09:50 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgdVt-0002QR-4D; Fri, 28 Jun 2019 01:09:09 +0200
Date:   Fri, 28 Jun 2019 01:09:08 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] ftrace: Remove possible deadlock between register_kprobe()
 and ftrace_run_update_code()
In-Reply-To: <20190627190457.703a486e@gandalf.local.home>
Message-ID: <alpine.DEB.2.21.1906280106360.32342@nanos.tec.linutronix.de>
References: <20190627081334.12793-1-pmladek@suse.com> <20190627224729.tshtq4bhzhneq24w@treble> <20190627190457.703a486e@gandalf.local.home>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 27 Jun 2019, Steven Rostedt wrote:
> On Thu, 27 Jun 2019 17:47:29 -0500
> > Releasing the lock in a separate function seems a bit surprising and
> > fragile, would it be possible to do something like this instead?
> > 
> > diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> > index b38c388d1087..89ea1af6fd13 100644
> > --- a/arch/x86/kernel/ftrace.c
> > +++ b/arch/x86/kernel/ftrace.c
> > @@ -37,15 +37,21 @@
> >  int ftrace_arch_code_modify_prepare(void)
> >  {
> >  	mutex_lock(&text_mutex);
> > +
> >  	set_kernel_text_rw();
> >  	set_all_modules_text_rw();
> > +
> > +	mutex_unlock(&text_mutex);
> >  	return 0;
> >  }
> >  
> >  int ftrace_arch_code_modify_post_process(void)
> >  {
> > +	mutex_lock(&text_mutex);
> > +
> >  	set_all_modules_text_ro();
> >  	set_kernel_text_ro();
> > +
> >  	mutex_unlock(&text_mutex);
> >  	return 0;
> >  }
> 
> I agree with Josh on this. As the original bug was the race between
> ftrace and live patching / modules changing the text from ro to rw and
> vice versa. Just protecting the update to the text permissions is more
> robust, and should be more self documenting when we need to handle
> other architectures for this.

How is that supposed to work?

    ftrace  	     	
	prepare()
	 setrw()
			setro()
	patch <- FAIL

Thanks,

	tglx
