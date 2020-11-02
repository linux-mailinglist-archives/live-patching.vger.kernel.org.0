Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192462A3017
	for <lists+live-patching@lfdr.de>; Mon,  2 Nov 2020 17:42:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbgKBQlx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 2 Nov 2020 11:41:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:59286 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727139AbgKBQlw (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 2 Nov 2020 11:41:52 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1604335310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZZ1+8t7uf1F7l3ZBHb45iCoO7eWd2o1ycVfihIUusH8=;
        b=Ujz9LMjaN8SJhVxn50rnawrrA86tblFVcms0tvPZ6z30qdXkdWdaV8CVc/AUzHzdbFv1V2
        IhoFIoAHPiRb7IWyVB1j/sUcCmK6cyUWjPXJIQKp023Mx82tNgLktFrqUxCnDxWjn5Juhp
        fYdZ2HuY/J5qgBTErdjQxOEKWWeOSL4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 13AC8AC65;
        Mon,  2 Nov 2020 16:41:50 +0000 (UTC)
Date:   Mon, 2 Nov 2020 17:41:47 +0100
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
Message-ID: <20201102164147.GJ20201@alley>
References: <20201030213142.096102821@goodmis.org>
 <20201030214014.801706340@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030214014.801706340@goodmis.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2020-10-30 17:31:53, Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> This adds CONFIG_FTRACE_RECORD_RECURSION that will record to a file
> "recursed_functions" all the functions that caused recursion while a
> callback to the function tracer was running.
> 

> --- /dev/null
> +++ b/kernel/trace/trace_recursion_record.c
> @@ -0,0 +1,220 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#include <linux/seq_file.h>
> +#include <linux/kallsyms.h>
> +#include <linux/module.h>
> +#include <linux/ftrace.h>
> +#include <linux/fs.h>
> +
> +#include "trace_output.h"
> +
> +struct recursed_functions {
> +	unsigned long		ip;
> +	unsigned long		parent_ip;
> +};
> +
> +static struct recursed_functions recursed_functions[CONFIG_FTRACE_RECORD_RECURSION_SIZE];

The code tries to be lockless safe as much as possible. It would make
sense to allign the array.


> +static atomic_t nr_records;
> +
> +/*
> + * Cache the last found function. Yes, updates to this is racey, but
> + * so is memory cache ;-)
> + */
> +static unsigned long cached_function;
> +
> +void ftrace_record_recursion(unsigned long ip, unsigned long parent_ip)
> +{
> +	int index;
> +	int i = 0;
> +	unsigned long old;
> +
> + again:
> +	/* First check the last one recorded */
> +	if (ip == cached_function)
> +		return;
> +
> +	index = atomic_read(&nr_records);
> +	/* nr_records is -1 when clearing records */
> +	smp_mb__after_atomic();
> +	if (index < 0)
> +		return;
> +
> +	/* See below */
> +	if (i > index)
> +		index = i;

This looks like a complicated way to do index++ via "i" variable.
I guess that it was needed only in some older variant of the code.
See below.

> +	if (index >= CONFIG_FTRACE_RECORD_RECURSION_SIZE)
> +		return;
> +
> +	for (i = index - 1; i >= 0; i--) {
> +		if (recursed_functions[i].ip == ip) {
> +			cached_function = ip;
> +			return;
> +		}
> +	}
> +
> +	cached_function = ip;
> +
> +	/*
> +	 * We only want to add a function if it hasn't been added before.
> +	 * Add to the current location before incrementing the count.
> +	 * If it fails to add, then increment the index (save in i)
> +	 * and try again.
> +	 */
> +	old = cmpxchg(&recursed_functions[index].ip, 0, ip);
> +	if (old != 0) {
> +		/* Did something else already added this for us? */
> +		if (old == ip)
> +			return;
> +		/* Try the next location (use i for the next index) */
> +		i = index + 1;

What about

		index++;

We basically want to run the code again with index + 1 limit.

Maybe, it even does not make sense to check the array again
and we should just try to store the value into the next slot.

> +		goto again;
> +	}
> +
> +	recursed_functions[index].parent_ip = parent_ip;

WRITE_ONCE() ?

> +
> +	/*
> +	 * It's still possible that we could race with the clearing
> +	 *    CPU0                                    CPU1
> +	 *    ----                                    ----
> +	 *                                       ip = func
> +	 *  nr_records = -1;
> +	 *  recursed_functions[0] = 0;
> +	 *                                       i = -1
> +	 *                                       if (i < 0)
> +	 *  nr_records = 0;
> +	 *  (new recursion detected)
> +	 *      recursed_functions[0] = func
> +	 *                                            cmpxchg(recursed_functions[0],
> +	 *                                                    func, 0)
> +	 *
> +	 * But the worse that could happen is that we get a zero in
> +	 * the recursed_functions array, and it's likely that "func" will
> +	 * be recorded again.
> +	 */
> +	i = atomic_read(&nr_records);
> +	smp_mb__after_atomic();
> +	if (i < 0)
> +		cmpxchg(&recursed_functions[index].ip, ip, 0);
> +	else if (i <= index)
> +		atomic_cmpxchg(&nr_records, i, index + 1);

This looks weird. It would shift nr_records past the record added
in this call. It might skip many slots that were zeroed when clearing.
Also we do not know if our entry was not zeroed as well.

I would suggest to do it some other way (not even compile tested):

void ftrace_record_recursion(unsigned long ip, unsigned long parent_ip)
{
	int index, old_index;
	int i = 0;
	unsigned long old_ip;

 again:
	/* First check the last one recorded. */
	if (ip == READ_ONCE(cached_function))
		return;

	index = atomic_read(&nr_records);
	/* nr_records is -1 when clearing records. */
	smp_mb__after_atomic();
	if (index < 0)
		return;

	/* Already cached? */
	for (i = index - 1; i >= 0; i--) {
		if (recursed_functions[i].ip == ip) {
			WRITE_ONCE(cached_function, ip);
			return;
		}
	}

	if (index >= CONFIG_FTRACE_RECORD_RECURSION_SIZE)
		return;

	/*
	 * Try to reserve the slot. It might be already taken
	 * or the entire cache cleared.
	 */
	old_index = atomic_cmpxchg(&nr_records, index, index + 1);
	if (old_index != index)
		goto again;

	/*
	 * Be careful. The entire cache might have been cleared and reused in
	 * the meantime. Replace only empty slot.
	 */
	old_ip = cmpxchg(&recursed_functions[index].ip, 0, ip);
	if (old_ip != 0)
		goto again;

	old_ip = cmpxchg(&recursed_functions[index].parent_ip, 0, parrent_ip);
	if (old_ip != 0)
		goto again;

	/*
	 * No ip is better than non-consistent one. The race with
	 * clearing should be rare and not worth a perfect solution.
	 */
	if (READ_ONCE(recursed_functions[index].ip) != ip) {
		cmpxchg(&recursed_functions[index].ip, ip, 0UL)
		goto again;
	}
}

The last check probably is not needed. Inconsistent entries
should be prevented by the way how this func is called:

		static atomic_t paranoid_test;				\
		if (!atomic_read(&paranoid_test)) {			\
			atomic_inc(&paranoid_test);			\
			ftrace_record_recursion(ip, pip);		\
			atomic_dec(&paranoid_test);			\
		}							\




The rest of the patchset looks fine. I do not feel comfortable to give
it Reviewed-by because I did not review it in depth.

I spent more time with the above lockless code. I took it is a
training. I need to improve this skill to feel more comfortable with
the lockless printk ring buffer ;-)

Best Regards,
Petr
