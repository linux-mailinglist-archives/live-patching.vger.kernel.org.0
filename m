Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68C5B2A4AEC
	for <lists+live-patching@lfdr.de>; Tue,  3 Nov 2020 17:14:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgKCQO1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 3 Nov 2020 11:14:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgKCQO1 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 3 Nov 2020 11:14:27 -0500
Received: from rorschach.local.home (unknown [172.58.235.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3326C223AB;
        Tue,  3 Nov 2020 16:14:15 +0000 (UTC)
Date:   Tue, 3 Nov 2020 11:14:10 -0500
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
Subject: Re: [PATCH 11/11 v2.2] ftrace: Add recording of functions that
 caused recursion
Message-ID: <20201103111410.64feac6c@rorschach.local.home>
In-Reply-To: <20201103141043.GO20201@alley>
References: <20201030213142.096102821@goodmis.org>
        <20201030214014.801706340@goodmis.org>
        <20201102164147.GJ20201@alley>
        <20201102123721.4fcce2cb@gandalf.local.home>
        <20201102124606.72bd89c5@gandalf.local.home>
        <20201102142254.7e148f8a@gandalf.local.home>
        <20201103141043.GO20201@alley>
X-Mailer: Claws Mail 3.17.4git76 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 3 Nov 2020 15:10:43 +0100
Petr Mladek <pmladek@suse.com> wrote:

> BTW: What is actually the purpose of paranoid_test, please?
> 
> It prevents nested ftrace_record_recursion() calls on the same CPU
> (recursion, nesting from IRQ, NMI context).
> 
> Parallel calls from different CPUs are still possible:
> 
> CPU0					CPU1
> if (!atomic_read(&paranoid_test))	if (!atomic_read(&paranoid_test))
>    // passes				  // passes
>    atomic_inc(&paranoid_test);            atomic_inc(&paranoid_test);
> 
> 
> I do not see how a nested call could cause crash while a parallel
> one would be OK.
> 

Yeah, I should make that per cpu, but was lazy. ;-)

It was added at the end.

I'll update that to a per cpu, and local inc operations.

-- Steve
