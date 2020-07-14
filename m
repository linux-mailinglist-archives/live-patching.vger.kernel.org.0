Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC2CE21EE6C
	for <lists+live-patching@lfdr.de>; Tue, 14 Jul 2020 12:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgGNK4X (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Jul 2020 06:56:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:33508 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726729AbgGNK4X (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Jul 2020 06:56:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 47770AD1A;
        Tue, 14 Jul 2020 10:56:24 +0000 (UTC)
Date:   Tue, 14 Jul 2020 12:56:21 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, pmladek@suse.cz,
        live-patching@vger.kernel.org
Subject: Re: linux-next: Tree for Jun 23 (objtool (2))
In-Reply-To: <20200702123555.bjioosahrs5vjovu@treble>
Message-ID: <alpine.LSU.2.21.2007141240540.5393@pobox.suse.cz>
References: <20200623162820.3f45feae@canb.auug.org.au> <61df2e8f-75e8-d233-9c3c-5b4fa2b7fbdc@infradead.org> <20200702123555.bjioosahrs5vjovu@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 2 Jul 2020, Josh Poimboeuf wrote:

> On Tue, Jun 23, 2020 at 08:06:07AM -0700, Randy Dunlap wrote:
> > On 6/22/20 11:28 PM, Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Changes since 20200622:
> > > 
> > 
> > on x86_64:
> > 
> > arch/x86/kernel/cpu/mce/core.o: warning: objtool: mce_timed_out()+0x24: unreachable instruction
> > kernel/exit.o: warning: objtool: __x64_sys_exit_group()+0x14: unreachable instruction
> > 
> > Full randconfig file is attached.
> 
> More livepatch...

Correct.

Both are known and I thought Josh had fixes queued somewhere for both, but 
my memory fails me quite often. See below.

However, I think it is time to decide how to approach this whole saga. It 
seems that there are not so many places in the kernel in need of 
__noreturn annotation in the end and as jikos argued at least some of 
those should be fixed regardless. Josh, should I prepare proper patches 
and submit them to relevant maintainers to see where this path is going?

It would be much better to fix it in GCC, but it has been like banging 
one's head against a wall so far. Josh, you wanted to create a bug 
for GCC in this respect in the past? Has that happened?

If I remember correctly, we discussed briefly a possibility to cope with 
that in objtool, but no solution was presented.

Removing -flive-patching is also a possibility. I don't like it much, but 
we discussed it with Petr M. a couple of months ago and it might be a way 
too.

Thanks
Miroslav

---

diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 14e4b4d17ee5..469a71ecea3c 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -279,7 +279,7 @@ static int fake_panic;
 static atomic_t mce_fake_panicked;
 
 /* Panic in progress. Enable interrupts and wait for final IPI */
-static void wait_for_panic(void)
+static void __noreturn wait_for_panic(void)
 {
        long timeout = PANIC_TIMEOUT*USEC_PER_SEC;
 
diff --git a/kernel/exit.c b/kernel/exit.c
index 727150f28103..570649152e7f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -877,7 +877,7 @@ SYSCALL_DEFINE1(exit, int, error_code)
  * as well as by sys_exit_group (below).
  */
 void
-do_group_exit(int exit_code)
+__noreturn do_group_exit(int exit_code)
 {
        struct signal_struct *sig = current->signal;

