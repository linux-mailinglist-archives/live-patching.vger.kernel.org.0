Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C0E2A3148
	for <lists+live-patching@lfdr.de>; Mon,  2 Nov 2020 18:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbgKBRTJ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 2 Nov 2020 12:19:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:39830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgKBRTJ (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 2 Nov 2020 12:19:09 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A960320691;
        Mon,  2 Nov 2020 17:19:04 +0000 (UTC)
Date:   Mon, 2 Nov 2020 12:19:02 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Petr Mladek <pmladek@suse.com>
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
Message-ID: <20201102121902.24d64aec@gandalf.local.home>
In-Reply-To: <20201102120907.457ad2f7@gandalf.local.home>
References: <20201030213142.096102821@goodmis.org>
        <20201030214014.801706340@goodmis.org>
        <20201102164147.GJ20201@alley>
        <20201102120907.457ad2f7@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 2 Nov 2020 12:09:07 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> > > +void ftrace_record_recursion(unsigned long ip, unsigned long parent_ip)
> > > +{
> > > +	int index;
> > > +	int i = 0;
> > > +	unsigned long old;
> > > +
> > > + again:
> > > +	/* First check the last one recorded */
> > > +	if (ip == cached_function)
> > > +		return;
> > > +
> > > +	index = atomic_read(&nr_records);
> > > +	/* nr_records is -1 when clearing records */
> > > +	smp_mb__after_atomic();
> > > +	if (index < 0)
> > > +		return;
> > > +
> > > +	/* See below */
> > > +	if (i > index)
> > > +		index = i;    
> > 
> > This looks like a complicated way to do index++ via "i" variable.
> > I guess that it was needed only in some older variant of the code.
> > See below.  
> 
> Because we reread the index above, and index could be bigger than i (more
> than index + 1).
> 
> >   
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
> 
> But you are correct, that this went through a few iterations. And the first
> ones didn't have the cmpxchg on the ip itself, and that could make it so
> that we don't need this index = i dance.

Playing with this more, I remember why I did this song and dance.

If we have two or more writers, and one beats the other in updating the ip
(with a different function). This one will go and try again. The reason to
look at one passed nr_records, is because of the race between the multiple
writers. This one may loop before the other can update nr_records, and it
will fail to apply it again.

You could just say, "hey we'll just keep looping until the other writer
eventually updates nr_records". But this is where my paranoia gets in. What
happens if that other writer takes an interrupt (interrupts are not
disabled), and then deadlocks, or does something bad? This CPU will not get
locked up spinning.

Unlikely scenario, and it would require a bug someplace else. But I don't
want a bug report stating that it found this recursion locking locking up
the CPU and hide the real culprit.

I'll add a comment to explain this in the code. And also swap the i and
index around to make a little more sense.

-- Steve
