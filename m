Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84AEB2A31B4
	for <lists+live-patching@lfdr.de>; Mon,  2 Nov 2020 18:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbgKBRh2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 2 Nov 2020 12:37:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:58612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727693AbgKBRh2 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 2 Nov 2020 12:37:28 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BC1F207BB;
        Mon,  2 Nov 2020 17:37:23 +0000 (UTC)
Date:   Mon, 2 Nov 2020 12:37:21 -0500
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
Message-ID: <20201102123721.4fcce2cb@gandalf.local.home>
In-Reply-To: <20201102164147.GJ20201@alley>
References: <20201030213142.096102821@goodmis.org>
        <20201030214014.801706340@goodmis.org>
        <20201102164147.GJ20201@alley>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 2 Nov 2020 17:41:47 +0100
Petr Mladek <pmladek@suse.com> wrote:

> > +	i = atomic_read(&nr_records);
> > +	smp_mb__after_atomic();
> > +	if (i < 0)
> > +		cmpxchg(&recursed_functions[index].ip, ip, 0);
> > +	else if (i <= index)
> > +		atomic_cmpxchg(&nr_records, i, index + 1);  
> 
> This looks weird. It would shift nr_records past the record added
> in this call. It might skip many slots that were zeroed when clearing.
> Also we do not know if our entry was not zeroed as well.

nr_records always holds the next position to write to.

	index = nr_records;
	recursed_functions[index].ip = ip;
	nr_records++;

Before clearing, we have:

	nr_records = -1;
	smp_mb();
	memset(recursed_functions, 0);
	smp_wmb();
	nr_records = 0;

When we enter this function:

	i = nr_records;
	smp_mb();
	if (i < 0)
		return;


Thus, we just stopped all new updates while clearing the records.

But what about if something is currently updating?

	i = nr_records;
	smp_mb();
	if (i < 0)
		cmpxchg(recursed_functions, ip, 0);

The above shows that if the current updating process notices that the
clearing happens, it will clear the function it added.

	else if (i <= index)
		cmpxchg(nr_records, i, index + 1);

This makes sure that nr_records only grows if it is greater or equal to
zero.

The only race that I see that can happen, is the one in the comment I
showed. And that is after enabling the recursed functions again after
clearing, one CPU could add a function while another CPU that just added
that same function could be just exiting this routine, notice that a
clearing of the array happened, and remove its function (which was the same
as the one just happened). So we get a "zero" in the array. If this
happens, it is likely that that function will recurse again and will be
added later.

-- Steve
