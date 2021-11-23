Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D36145AD7C
	for <lists+live-patching@lfdr.de>; Tue, 23 Nov 2021 21:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhKWUoH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Nov 2021 15:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbhKWUoE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Nov 2021 15:44:04 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC0DDC061574
        for <live-patching@vger.kernel.org>; Tue, 23 Nov 2021 12:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mj5i4rADjLu/laWRAJiX8EK9zd7fNQSaV0qkwpWf9wk=; b=SrIUQb+4Ea7EKjYXfkCFpTvhE2
        WMpl9mXffmKBUkNdj5hjqmsifnsad/EifSCyH93tSvRNVAuvfNjEIAaT5Ynopxco+ggtWeq/RkLJj
        E5mBCloc4iIKdWiVAugm98tAhsHNEEbH6ka14fZVbfaLh4JSBX7pSzLnGUW/cipnvGk1rqO0tIfeh
        R10AV78gdrhsFINcjXip8GzLllgd0SW7JJJSKU5iHhYJeeV6vnC0HT3B/Jd1189mvugF3v8qLxId9
        jBg/zCevLoZO6/5cJ4Y0B312naQnfC93WrjvXmpljWm8/OqI1C0HZUPQ+UdazybExn4bh6frcQzcX
        W0ZSgJZg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mpcan-0008TA-4X; Tue, 23 Nov 2021 20:40:41 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id CE4C5984951; Tue, 23 Nov 2021 21:40:39 +0100 (CET)
Date:   Tue, 23 Nov 2021 21:40:39 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Miroslav Benes <mbenes@suse.cz>, joao@overdrivepizza.com,
        nstange@suse.de, pmladek@suse.cz, jpoimboe@redhat.com,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org,
        alexei.starovoitov@gmail.com
Subject: Re: CET/IBT support and live-patches
Message-ID: <20211123204039.GC721624@worktop.programming.kicks-ass.net>
References: <70828ca9f840960c7a3f66cd8dc141f5@overdrivepizza.com>
 <alpine.LSU.2.21.2111231035460.15177@pobox.suse.cz>
 <YZzHE+Cze9AX6HCZ@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.2111231237090.15177@pobox.suse.cz>
 <20211123110320.75990e0b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211123110320.75990e0b@gandalf.local.home>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Nov 23, 2021 at 11:03:20AM -0500, Steven Rostedt wrote:
> On Tue, 23 Nov 2021 12:39:15 +0100 (CET)
> Miroslav Benes <mbenes@suse.cz> wrote:
> 
> > +++ b/kernel/livepatch/patch.c
> > @@ -127,15 +127,18 @@ static void notrace klp_ftrace_handler(unsigned long ip,
> >  /*
> >   * Convert a function address into the appropriate ftrace location.
> >   *
> > - * Usually this is just the address of the function, but on some architectures
> > - * it's more complicated so allow them to provide a custom behaviour.
> > + * Usually this is just the address of the function, but there are some
> > + * exceptions.
> > + *
> > + *   * PPC - live patch works only with -mprofile-kernel. In this case,
> > + *     the ftrace location is always within the first 16 bytes.
> > + *   * x86_64 with CET/IBT enabled - there is ENDBR instruction at +0 offset.
> > + *     __fentry__ follows it.
> >   */
> > -#ifndef klp_get_ftrace_location
> > -static unsigned long klp_get_ftrace_location(unsigned long faddr)
> > +static inline unsigned long klp_get_ftrace_location(unsigned long faddr)
> 
> Why make this the default function? It should only do this for powerpc and
> x86 *if* CET/IBT is enabled.

Well, only this variant of IBT. Once Joao gets his clang patches
together we'll probably have it back at +0.

Something like the below would be more robust, it also gets us something
grep-able for when the IBT code-gen changes yet again.

diff --git a/arch/x86/include/asm/livepatch.h b/arch/x86/include/asm/livepatch.h
index 7c5cc6660e4b..4e683a1aa411 100644
--- a/arch/x86/include/asm/livepatch.h
+++ b/arch/x86/include/asm/livepatch.h
@@ -17,4 +17,13 @@ static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
 	ftrace_instruction_pointer_set(fregs, ip);
 }
 
+#define klp_get_ftrace_location klp_get_ftrace_location
+static inline unsigned long klp_get_ftrace_location(unsigned long faddr)
+{
+	unsigned long addr = faddr_location(faddr);
+	if (!addr && IS_ENABLED(CONFIG_X86_IBT))
+		addr = faddr_location(faddr + 4);
+	return addr;
+}
+
 #endif /* _ASM_X86_LIVEPATCH_H */
diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index fe316c021d73..fd295bbbcbc7 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -133,7 +133,7 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 #ifndef klp_get_ftrace_location
 static unsigned long klp_get_ftrace_location(unsigned long faddr)
 {
-	return faddr;
+	return ftrace_location(faddr);
 }
 #endif
 
