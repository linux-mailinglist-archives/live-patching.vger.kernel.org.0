Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE4E45A1A9
	for <lists+live-patching@lfdr.de>; Tue, 23 Nov 2021 12:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbhKWLmZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Nov 2021 06:42:25 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:55478 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhKWLmY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Nov 2021 06:42:24 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2C14B21709;
        Tue, 23 Nov 2021 11:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1637667556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yrlxPrNNbhBR1Lt01gm8uWdFzOU7ndD7QycX3GVyLNM=;
        b=PHoVscOSezxcNVGwDGB5QCR8vFzn7nJaDyYcfAu0Y3AvQ9K9w3lacB3LHSWJdX+8Us2UyB
        e4njVE9EwCK3Za3MKAu+uZBWp8u3I3J9LNS/zkHCZGKqmuKEzHeW2bksHRSAIvFcGtpyTd
        zizet4+2gnQZuLIKoG6+MBDtb4o3WF4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1637667556;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yrlxPrNNbhBR1Lt01gm8uWdFzOU7ndD7QycX3GVyLNM=;
        b=aQk15tZEv66/sLEg+QgBtHRm2DXGL3mD1CO+o3Irl8xVIekZmlMh1zaUrWhXDvvAaYG9KT
        +wkBKpc6t79YS3Aw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 017C9A3B81;
        Tue, 23 Nov 2021 11:39:15 +0000 (UTC)
Date:   Tue, 23 Nov 2021 12:39:15 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Peter Zijlstra <peterz@infradead.org>
cc:     joao@overdrivepizza.com, nstange@suse.de, pmladek@suse.cz,
        jpoimboe@redhat.com, joe.lawrence@redhat.com,
        live-patching@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        alexei.starovoitov@gmail.com
Subject: Re: CET/IBT support and live-patches
In-Reply-To: <YZzHE+Cze9AX6HCZ@hirez.programming.kicks-ass.net>
Message-ID: <alpine.LSU.2.21.2111231237090.15177@pobox.suse.cz>
References: <70828ca9f840960c7a3f66cd8dc141f5@overdrivepizza.com> <alpine.LSU.2.21.2111231035460.15177@pobox.suse.cz> <YZzHE+Cze9AX6HCZ@hirez.programming.kicks-ass.net>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 23 Nov 2021, Peter Zijlstra wrote:

> On Tue, Nov 23, 2021 at 10:58:57AM +0100, Miroslav Benes wrote:
> > [ adding more CCs ]
> > 
> > On Mon, 22 Nov 2021, joao@overdrivepizza.com wrote:
> > 
> > > Hi Miroslav, Petr and Nicolai,
> > > 
> > > Long time no talk, I hope you are all still doing great :)
> > 
> > Everything great here :)
> > 
> > > So, we have been cooking a few patches for enabling Intel CET/IBT support in
> > > the kernel. The way IBT works is -- whenever you have an indirect branch, the
> > > control-flow must land in an endbr instruction. The idea is to constrain
> > > control-flow in a way to make it harder for attackers to achieve meaningful
> > > computation through pointer/memory corruption (as in, an attacker that can
> > > corrupt a function pointer by exploiting a memory corruption bug won't be able
> > > to execute whatever piece of code, being restricted to jump into endbr
> > > instructions). To make the allowed control-flow graph more restrict, we are
> > > looking into how to minimize the number of endbrs in the final kernel binary
> > > -- meaning that if a function is never called indirectly, it shouldn't have an
> > > endbr instruction, thus increasing the security guarantees of the hardware
> > > feature.
> > > 
> > > Some ref about what is going on --
> > > https://lore.kernel.org/lkml/20211122170805.149482391@infradead.org/T/
> > 
> > Yes, I noticed something was happening again. There was a thread on this 
> > in February https://lore.kernel.org/all/20210207104022.GA32127@zn.tnic/ 
> > and some concerns were raised back then around fentry and int3 patching if 
> > I remember correctly. Is this still an issue?
> 
> The problem was bpf, and probably still is. I've not come around to
> looking at it. Asusming fentry is at +0 is silly (although I would like
> to see that restored for other reasons), but bpf will also need to emit
> ENDBR at least at the start of every JIT'ed program, because entry into
> them is through an indirect branch.
> 
> If nobody beats me to it, I'll get around to it eventually.

Ok. And we would need something like the following for the livepatch (not 
even compile tested).

---

diff --git a/arch/powerpc/include/asm/livepatch.h b/arch/powerpc/include/asm/livepatch.h
index 4fe018cc207b..7b9dcd51af32 100644
--- a/arch/powerpc/include/asm/livepatch.h
+++ b/arch/powerpc/include/asm/livepatch.h
@@ -19,16 +19,6 @@ static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
 	regs_set_return_ip(regs, ip);
 }
 
-#define klp_get_ftrace_location klp_get_ftrace_location
-static inline unsigned long klp_get_ftrace_location(unsigned long faddr)
-{
-	/*
-	 * Live patch works only with -mprofile-kernel on PPC. In this case,
-	 * the ftrace location is always within the first 16 bytes.
-	 */
-	return ftrace_location_range(faddr, faddr + 16);
-}
-
 static inline void klp_init_thread_info(struct task_struct *p)
 {
 	/* + 1 to account for STACK_END_MAGIC */
diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
index fe316c021d73..81cd9235e160 100644
--- a/kernel/livepatch/patch.c
+++ b/kernel/livepatch/patch.c
@@ -127,15 +127,18 @@ static void notrace klp_ftrace_handler(unsigned long ip,
 /*
  * Convert a function address into the appropriate ftrace location.
  *
- * Usually this is just the address of the function, but on some architectures
- * it's more complicated so allow them to provide a custom behaviour.
+ * Usually this is just the address of the function, but there are some
+ * exceptions.
+ *
+ *   * PPC - live patch works only with -mprofile-kernel. In this case,
+ *     the ftrace location is always within the first 16 bytes.
+ *   * x86_64 with CET/IBT enabled - there is ENDBR instruction at +0 offset.
+ *     __fentry__ follows it.
  */
-#ifndef klp_get_ftrace_location
-static unsigned long klp_get_ftrace_location(unsigned long faddr)
+static inline unsigned long klp_get_ftrace_location(unsigned long faddr)
 {
-	return faddr;
+	return ftrace_location_range(faddr, faddr + 16);
 }
-#endif
 
 static void klp_unpatch_func(struct klp_func *func)
 {
 

