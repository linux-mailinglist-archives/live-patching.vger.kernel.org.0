Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC515AD64
	for <lists+live-patching@lfdr.de>; Sat, 29 Jun 2019 22:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbfF2U4x (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 29 Jun 2019 16:56:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbfF2U4w (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sat, 29 Jun 2019 16:56:52 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0C69215EA;
        Sat, 29 Jun 2019 20:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561841812;
        bh=1GATgUgx4TSdm9N8D/IejkdbWqAZYPBdzUp9aXWmaW4=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=e46obZ95/P32fuOjgyk3QyyDQpNBl3MoON02R7Ps4h+tbBwHu3kuBG47yfTK4WFiZ
         R7VBvq7HruteZUYHEndFjhkfnJfpCr+b3sxsi6e22kjpzKT/REQGo4gaiJHO6jmD4e
         etcc0YEZ+RCMRh9dzhj/czO2euLuagCoNGuPz7T4=
Date:   Sat, 29 Jun 2019 22:56:47 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] ftrace: Remove possible deadlock between register_kprobe()
 and ftrace_run_update_code()
In-Reply-To: <20190628133702.16a54ccf@gandalf.local.home>
Message-ID: <nycvar.YFH.7.76.1906292256100.27227@cbobk.fhfr.pm>
References: <20190627081334.12793-1-pmladek@suse.com> <20190627224729.tshtq4bhzhneq24w@treble> <20190627190457.703a486e@gandalf.local.home> <alpine.DEB.2.21.1906280106360.32342@nanos.tec.linutronix.de> <20190627231952.nqkbtcculvo2ddif@treble>
 <nycvar.YFH.7.76.1906281932360.27227@cbobk.fhfr.pm> <20190628133702.16a54ccf@gandalf.local.home>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 28 Jun 2019, Steven Rostedt wrote:

> > > > How is that supposed to work?
> > > > 
> > > >     ftrace  	     	
> > > > 	prepare()
> > > > 	 setrw()
> > > > 			setro()
> > > > 	patch <- FAIL  
> > > 
> > > /me dodges frozen shark
> > > 
> > > You are right of course.  My brain has apparently already shut off for
> > > the day.
> > > 
> > > Maybe a comment or two would help though.  
> > 
> > I'd actually prefer (perhaps in parallel to the comment) using the 
> > __acquires() and __releases() anotations, so that sparse and friends don't 
> > get confused by that either.
> > 
> 
> Care to send a patch? :-)

From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] ftrace/x86: anotate text_mutex split between ftrace_arch_code_modify_post_process() and ftrace_arch_code_modify_prepare()

ftrace_arch_code_modify_prepare() is acquiring text_mutex, while the 
corresponding release is happening in ftrace_arch_code_modify_post_process().

This has already been documented in the code, but let's also make the fact 
that this is intentional clear to the semantic analysis tools such as 
sparse.

Fixes: 39611265edc1a ("ftrace/x86: Add a comment to why we take text_mutex in ftrace_arch_code_modify_prepare()")
Fixes: d5b844a2cf507 ("ftrace/x86: Remove possible deadlock between register_kprobe() and ftrace_run_update_code()")
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 arch/x86/kernel/ftrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index d7e93b2783fd..76228525acd0 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -35,6 +35,7 @@
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 int ftrace_arch_code_modify_prepare(void)
+    __acquires(&text_mutex)
 {
 	/*
 	 * Need to grab text_mutex to prevent a race from module loading
@@ -48,6 +49,7 @@ int ftrace_arch_code_modify_prepare(void)
 }
 
 int ftrace_arch_code_modify_post_process(void)
+    __releases(&text_mutex)
 {
 	set_all_modules_text_ro();
 	set_kernel_text_ro();

-- 
Jiri Kosina
SUSE Labs

