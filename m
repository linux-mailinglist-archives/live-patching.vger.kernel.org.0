Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D658229EE6C
	for <lists+live-patching@lfdr.de>; Thu, 29 Oct 2020 15:37:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgJ2Ohs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 29 Oct 2020 10:37:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbgJ2Ohr (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 29 Oct 2020 10:37:47 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FEE7204EF;
        Thu, 29 Oct 2020 14:37:46 +0000 (UTC)
Date:   Thu, 29 Oct 2020 10:37:44 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 6/9] livepatch/ftrace: Add recursion protection to the
 ftrace callback
Message-ID: <20201029103744.0f7f52dc@gandalf.local.home>
In-Reply-To: <alpine.LSU.2.21.2010291443310.1688@pobox.suse.cz>
References: <20201028115244.995788961@goodmis.org>
        <20201028115613.291169246@goodmis.org>
        <alpine.LSU.2.21.2010291443310.1688@pobox.suse.cz>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 29 Oct 2020 14:51:06 +0100 (CET)
Miroslav Benes <mbenes@suse.cz> wrote:

> > index b552cf2d85f8..6c0164d24bbd 100644
> > --- a/kernel/livepatch/patch.c
> > +++ b/kernel/livepatch/patch.c
> > @@ -45,9 +45,13 @@ static void notrace klp_ftrace_handler(unsigned long ip,
> >  	struct klp_ops *ops;
> >  	struct klp_func *func;
> >  	int patch_state;
> > +	int bit;
> >  
> >  	ops = container_of(fops, struct klp_ops, fops);
> >  
> > +	bit = ftrace_test_recursion_trylock();
> > +	if (bit < 0)
> > +		return;  
> 
> This means that the original function will be called in case of recursion. 
> That's probably fair, but I'm wondering if we should at least WARN about 
> it.

It's probably what happens today. But if you add a WARN_ON_ONCE() it may
not hurt.

I also plan on adding code that reports when recursion has happened,
because even if it's not a problem, recursion adds extra overhead.

-- Steve
