Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22032A31E6
	for <lists+live-patching@lfdr.de>; Mon,  2 Nov 2020 18:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725982AbgKBRqR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 2 Nov 2020 12:46:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgKBRqN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 2 Nov 2020 12:46:13 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11A0822226;
        Mon,  2 Nov 2020 17:46:07 +0000 (UTC)
Date:   Mon, 2 Nov 2020 12:46:06 -0500
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
Message-ID: <20201102124606.72bd89c5@gandalf.local.home>
In-Reply-To: <20201102123721.4fcce2cb@gandalf.local.home>
References: <20201030213142.096102821@goodmis.org>
        <20201030214014.801706340@goodmis.org>
        <20201102164147.GJ20201@alley>
        <20201102123721.4fcce2cb@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 2 Nov 2020 12:37:21 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:


> The only race that I see that can happen, is the one in the comment I
> showed. And that is after enabling the recursed functions again after
> clearing, one CPU could add a function while another CPU that just added
> that same function could be just exiting this routine, notice that a
> clearing of the array happened, and remove its function (which was the same
> as the one just happened). So we get a "zero" in the array. If this
> happens, it is likely that that function will recurse again and will be
> added later.
> 

Updated version of this function:

-- Steve


void ftrace_record_recursion(unsigned long ip, unsigned long parent_ip)
{
	int index = 0;
	int i;
	unsigned long old;

 again:
	/* First check the last one recorded */
	if (ip == cached_function)
		return;

	i = atomic_read(&nr_records);
	/* nr_records is -1 when clearing records */
	smp_mb__after_atomic();
	if (i < 0)
		return;

	/*
	 * If there's two writers and this writer comes in second,
	 * the cmpxchg() below to update the ip will fail. Then this
	 * writer will try again. It is possible that index will now
	 * be greater than nr_records. This is because the writer
	 * that succeeded has not updated the nr_records yet.
	 * This writer could keep trying again until the other writer
	 * updates nr_records. But if the other writer takes an
	 * interrupt, and that interrupt locks up that CPU, we do
	 * not want this CPU to lock up due to the recursion protection,
	 * and have a bug report showing this CPU as the cause of
	 * locking up the computer. To not lose this record, this
	 * writer will simply use the next position to update the
	 * recursed_functions, and it will update the nr_records
	 * accordingly.
	 */
	if (index < i)
		index = i;
	if (index >= CONFIG_FTRACE_RECORD_RECURSION_SIZE)
		return;

	for (i = index - 1; i >= 0; i--) {
		if (recursed_functions[i].ip == ip) {
			cached_function = ip;
			return;
		}
	}

	cached_function = ip;

	/*
	 * We only want to add a function if it hasn't been added before.
	 * Add to the current location before incrementing the count.
	 * If it fails to add, then increment the index (save in i)
	 * and try again.
	 */
	old = cmpxchg(&recursed_functions[index].ip, 0, ip);
	if (old != 0) {
		/* Did something else already added this for us? */
		if (old == ip)
			return;
		/* Try the next location (use i for the next index) */
		index++;
		goto again;
	}

	recursed_functions[index].parent_ip = parent_ip;

	/*
	 * It's still possible that we could race with the clearing
	 *    CPU0                                    CPU1
	 *    ----                                    ----
	 *                                       ip = func
	 *  nr_records = -1;
	 *  recursed_functions[0] = 0;
	 *                                       i = -1
	 *                                       if (i < 0)
	 *  nr_records = 0;
	 *  (new recursion detected)
	 *      recursed_functions[0] = func
	 *                                            cmpxchg(recursed_functions[0],
	 *                                                    func, 0)
	 *
	 * But the worse that could happen is that we get a zero in
	 * the recursed_functions array, and it's likely that "func" will
	 * be recorded again.
	 */
	i = atomic_read(&nr_records);
	smp_mb__after_atomic();
	if (i < 0)
		cmpxchg(&recursed_functions[index].ip, ip, 0);
	else if (i <= index)
		atomic_cmpxchg(&nr_records, i, index + 1);
}
