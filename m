Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228252A434F
	for <lists+live-patching@lfdr.de>; Tue,  3 Nov 2020 11:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727668AbgKCKky (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 3 Nov 2020 05:40:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:50220 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726388AbgKCKkx (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 3 Nov 2020 05:40:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604400051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OpLXhG7xm+V2xdBg1+KjOIVd448NLhIB6otcbwQQTDI=;
        b=XSdNy7mxSwPPbuLKLXZRfCFfjOJHautUQu++n50tMCvpfkaBXlr+bOunNRM8+xoxvQYvi5
        mY40GKHAydPd5jnotGgN8FQylfnmTxCAY7Xg9pOTx1xVd1OxQtnbCqyriarK0Ndrtzt94h
        IzlzFUKI+hnTAEK+ASYY8dP7/EOox/U=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CFA08ACD8;
        Tue,  3 Nov 2020 10:40:50 +0000 (UTC)
Date:   Tue, 3 Nov 2020 11:40:49 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Jonathan Corbet <corbet@lwn.net>, Guo Ren <guoren@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
        Helge Deller <deller@gmx.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kees Cook <keescook@chromium.org>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-doc@vger.kernel.org, linux-csky@vger.kernel.org,
        linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH 11/11 v2] ftrace: Add recording of functions that caused
 recursion
Message-ID: <20201103104049.GN20201@alley>
References: <20201030213142.096102821@goodmis.org>
 <20201030214014.801706340@goodmis.org>
 <20201102164147.GJ20201@alley>
 <20201102120907.457ad2f7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102120907.457ad2f7@gandalf.local.home>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2020-11-02 12:09:07, Steven Rostedt wrote:
> On Mon, 2 Nov 2020 17:41:47 +0100
> Petr Mladek <pmladek@suse.com> wrote:
> 
> > On Fri 2020-10-30 17:31:53, Steven Rostedt wrote:
> > > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> > > 
> > > This adds CONFIG_FTRACE_RECORD_RECURSION that will record to a file
> > > "recursed_functions" all the functions that caused recursion while a
> > > callback to the function tracer was running.
> > >   
> > 
> > > --- /dev/null
> > > +++ b/kernel/trace/trace_recursion_record.c
> > > +	if (index >= CONFIG_FTRACE_RECORD_RECURSION_SIZE)
> > > +		return;
> > > +
> > > +	for (i = index - 1; i >= 0; i--) {
> > > +		if (recursed_functions[i].ip == ip) {
> > > +			cached_function = ip;
> > > +			return;
> > > +		}
> > > +	}
> > > +
> > > +	cached_function = ip;
> > > +
> > > +	/*
> > > +	 * We only want to add a function if it hasn't been added before.
> > > +	 * Add to the current location before incrementing the count.
> > > +	 * If it fails to add, then increment the index (save in i)
> > > +	 * and try again.
> > > +	 */
> > > +	old = cmpxchg(&recursed_functions[index].ip, 0, ip);
> > > +	if (old != 0) {
> > > +		/* Did something else already added this for us? */
> > > +		if (old == ip)
> > > +			return;
> > > +		/* Try the next location (use i for the next index) */
> > > +		i = index + 1;  
> > 
> > What about
> > 
> > 		index++;
> > 
> > We basically want to run the code again with index + 1 limit.
> 
> But something else could update nr_records, and we want to use that if
> nr_records is greater than i.
> 
> Now, we could swap the use case, and have
> 
> 	int index = 0;
> 
> 	[..]
> 	i = atomic_read(&nr_records);
> 	if (i > index)
> 		index = i;
> 
> 	[..]
> 
> 		index++;
> 		goto again;
> 
> 
> > 
> > Maybe, it even does not make sense to check the array again
> > and we should just try to store the value into the next slot.
> 
> We do this dance to prevent duplicates.

I see.

My code was wrong. It reserved slot for the new "ip" by cmpxchg
on nr_records. The "ip" was stored later so that any parallel
call need not see that it is a dumplicate.

Your code reserves the slot by cmpxchg of "ip".
Any parallel call would fail to take the slot and see
the "ip" in the next iteration.

Best Regards,
Petr
