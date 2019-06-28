Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEFB58F8D
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2019 03:13:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfF1BNI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 27 Jun 2019 21:13:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:48332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbfF1BNI (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 27 Jun 2019 21:13:08 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20CA6206A2;
        Fri, 28 Jun 2019 01:13:06 +0000 (UTC)
Date:   Thu, 27 Jun 2019 21:13:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
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
Message-ID: <20190627211304.7e21fd77@gandalf.local.home>
In-Reply-To: <20190627231952.nqkbtcculvo2ddif@treble>
References: <20190627081334.12793-1-pmladek@suse.com>
        <20190627224729.tshtq4bhzhneq24w@treble>
        <20190627190457.703a486e@gandalf.local.home>
        <alpine.DEB.2.21.1906280106360.32342@nanos.tec.linutronix.de>
        <20190627231952.nqkbtcculvo2ddif@treble>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 27 Jun 2019 18:19:52 -0500
Josh Poimboeuf <jpoimboe@redhat.com> wrote:


> Maybe a comment or two would help though.
> 

I'm adding the following change.  Care to add a "reviewed-by" for this
one?

-- Steve

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 33786044d5ac..d7e93b2783fd 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -36,6 +36,11 @@
 
 int ftrace_arch_code_modify_prepare(void)
 {
+	/*
+	 * Need to grab text_mutex to prevent a race from module loading
+	 * and live kernel patching from changing the text permissions while
+	 * ftrace has it set to "read/write".
+	 */
 	mutex_lock(&text_mutex);
 	set_kernel_text_rw();
 	set_all_modules_text_rw();
