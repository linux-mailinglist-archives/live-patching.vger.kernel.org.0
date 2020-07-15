Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9D0220B2D
	for <lists+live-patching@lfdr.de>; Wed, 15 Jul 2020 13:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731779AbgGOLLU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Jul 2020 07:11:20 -0400
Received: from [195.135.220.15] ([195.135.220.15]:54998 "EHLO mx2.suse.de"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1731799AbgGOLLR (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Jul 2020 07:11:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 26997B5A1;
        Wed, 15 Jul 2020 11:11:18 +0000 (UTC)
Date:   Wed, 15 Jul 2020 13:11:14 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, pmladek@suse.cz,
        live-patching@vger.kernel.org
Subject: Re: linux-next: Tree for Jun 23 (objtool (2))
In-Reply-To: <20200714135747.lcgysd5joguhssas@treble>
Message-ID: <alpine.LSU.2.21.2007151250390.25290@pobox.suse.cz>
References: <20200623162820.3f45feae@canb.auug.org.au> <61df2e8f-75e8-d233-9c3c-5b4fa2b7fbdc@infradead.org> <20200702123555.bjioosahrs5vjovu@treble> <alpine.LSU.2.21.2007141240540.5393@pobox.suse.cz> <20200714135747.lcgysd5joguhssas@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 14 Jul 2020, Josh Poimboeuf wrote:

> On Tue, Jul 14, 2020 at 12:56:21PM +0200, Miroslav Benes wrote:
> > On Thu, 2 Jul 2020, Josh Poimboeuf wrote:
> > 
> > > On Tue, Jun 23, 2020 at 08:06:07AM -0700, Randy Dunlap wrote:
> > > > On 6/22/20 11:28 PM, Stephen Rothwell wrote:
> > > > > Hi all,
> > > > > 
> > > > > Changes since 20200622:
> > > > > 
> > > > 
> > > > on x86_64:
> > > > 
> > > > arch/x86/kernel/cpu/mce/core.o: warning: objtool: mce_timed_out()+0x24: unreachable instruction
> > > > kernel/exit.o: warning: objtool: __x64_sys_exit_group()+0x14: unreachable instruction
> > > > 
> > > > Full randconfig file is attached.
> > > 
> > > More livepatch...
> > 
> > Correct.
> > 
> > Both are known and I thought Josh had fixes queued somewhere for both, but 
> > my memory fails me quite often. See below.
> 
> I did have fixes for some of them in a stash somewhere, but I never
> finished them because I decided it's a GCC bug.

Same here.
 
> > However, I think it is time to decide how to approach this whole saga. It 
> > seems that there are not so many places in the kernel in need of 
> > __noreturn annotation in the end and as jikos argued at least some of 
> > those should be fixed regardless.
> 
> I would agree that global functions like do_group_exit() deserve a
> __noreturn annotation, though it should be in the header file.  But
> static functions shouldn't need it.

Agreed. I'll post the patches for global functions eventually, but see 
below first.

> > Josh, should I prepare proper patches and submit them to relevant
> > maintainers to see where this path is going?
> 
> If that's how you want to handle it, ok, but it doesn't seem right to
> me, for the static functions at least.
> 
> > It would be much better to fix it in GCC, but it has been like banging 
> > one's head against a wall so far. Josh, you wanted to create a bug 
> > for GCC in this respect in the past? Has that happened?
> 
> I didn't open a bug, but I could, if you think that would help.  I
> haven't had a lot of success with GCC bugs in the past.

Understood.

> > If I remember correctly, we discussed briefly a possibility to cope with 
> > that in objtool, but no solution was presented.
> 
> That would also feel like a GCC workaround and might impede objtool's
> ability to find bugs like this one, and possibly more serious bugs.
> 
> > Removing -flive-patching is also a possibility. I don't like it much, but 
> > we discussed it with Petr M. a couple of months ago and it might be a way 
> > too.
> 
> -flive-patching has many problems which I outlined before.  None of them
> have been addressed.  I still feel the same way, that it should be
> reverted until it's ready.  Otherwise it's a drain on upstream.
> 
> Also, if the GCC developers won't acknowledge this bug then it doesn't
> give me confidence in their ability to keep the feature working as
> optimizations are added or changed.

I must admit that I've started to share the sentiment recently. And it is 
probably the main reason for changing my mind about the whole thing.

> I still think a potential alternative exists: objtool could be used as a
> simple tree-wide object diff tool by generating a checksum for each
> function.  Then the patch can be applied and built to see exactly which
> functions have changed, based on the changed checksums.  In which case
> this feature would no longer be needed anyway, would you agree?

Yes.

> I also think that could be a first step for converging our patch
> creation processes.

Yes again.

Petr, would you agree to revert -flive-patching due to reasons above? Is 
there anything you want to add?

Miroslav
