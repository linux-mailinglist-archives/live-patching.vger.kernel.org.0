Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F30057BC3F
	for <lists+live-patching@lfdr.de>; Wed, 20 Jul 2022 19:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiGTREi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 20 Jul 2022 13:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiGTREi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 20 Jul 2022 13:04:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0B06BC0B;
        Wed, 20 Jul 2022 10:04:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 070D261DEC;
        Wed, 20 Jul 2022 17:04:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B66C3411E;
        Wed, 20 Jul 2022 17:04:35 +0000 (UTC)
Date:   Wed, 20 Jul 2022 13:04:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     mingo@redhat.com, linux-kernel@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org
Subject: Re: ftrace_kill() leads to kmalloc-512 UAF
Message-ID: <20220720130433.5f9b1ebb@gandalf.local.home>
In-Reply-To: <YtgxSs79D0r5s4Ch@localhost.localdomain>
References: <YtgdsW8UBSwCKtQW@localhost.localdomain>
        <20220720121102.6cac8f1d@gandalf.local.home>
        <YtgxSs79D0r5s4Ch@localhost.localdomain>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 20 Jul 2022 19:46:02 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Wed, Jul 20, 2022 at 12:11:02PM -0400, Steven Rostedt wrote:
> > 
> > [ Adding live kernel patching folks ]
> > 
> > On Wed, 20 Jul 2022 18:22:25 +0300
> > Alexey Dobriyan <adobriyan@gmail.com> wrote:
> >   
> > > I'm debugging crash of our product which does live kernel patching together
> > > with ISV security scanner which uses ftrace kprobes to do whatever it does.
> > > 
> > > What happens is that is ftrace ever detects .text change, refuses to patch
> > > and prints a warning with FTRACE_WARN_ON_ONCE() then there is reliable way
> > > to cause UAF on kmalloc-512 cache by trying to register kprobe with
> > > perf_event_open() and then unregistering it by exiting the process.
> > > 
> > > 1) live kernel patching happens, first instruction of some function changes  
> > 
> > But live kernel patching uses ftrace to do this, so the question remains,
> > why doesn't ftrace know about this change?  
> 
> That a line from our product which changes first instruction of the function.
> 

So this is an out-of-tree change?

> > > 2) kprobe on that function is registered with perf_event_open()
> > > 
> > > 	WARNING: CPU: 5 PID: 2109 at kernel/trace/ftrace.c:1853 ftrace_bug+0x25d/0x270
> > > 	 [<ffffffff811638ed>] ftrace_bug+0x25d/0x270
> > > 	 [<ffffffff81065571>] ftrace_replace_code+0x2b1/0x420
> > > 	 [<ffffffff81163f9a>] ftrace_modify_all_code+0x6a/0xb0
> > > 	 [<ffffffff810656f0>] arch_ftrace_update_code+0x10/0x20
> > > 	 [<ffffffff81164077>] ftrace_run_update_code+0x17/0x70
> > > 	 [<ffffffff81165512>] ftrace_set_hash+0x1c2/0x1f0
> > > 	 [<ffffffff8126fee0>] ? SyS_dup2+0x60/0x60
> > > 	 [<ffffffff8126fee0>] ? SyS_dup2+0x60/0x60
> > > 	 [<ffffffff811655a0>] ftrace_set_filter_ip+0x60/0x70
> > > 	 [<ffffffff8179624c>] arm_kprobe+0x9c/0x140
> > > 	 [<ffffffff81796368>] enable_kprobe+0x78/0xa0
> > > 	 [<ffffffff81187bab>] enable_trace_kprobe+0x7b/0x120
> > > 	 [<ffffffff81797e5f>] kprobe_register+0x2f/0x60
> > > 	 [<ffffffff8118348a>] perf_trace_event_init+0x1aa/0x230
> > > 	 [<ffffffff811836b7>] perf_kprobe_init+0xa7/0xf0
> > > 	 [<ffffffff811a8919>] perf_kprobe_event_init+0x49/0x70
> > > 	 [<ffffffff811aa569>] perf_try_init_event+0x99/0xc0
> > > 	 [<ffffffff811b29f2>] perf_init_event+0x92/0x150
> > > 	 [<ffffffff811b2fa1>] perf_event_alloc+0x4f1/0x910
> > > 	 [<ffffffff811b3789>] SYSC_perf_event_open+0x3c9/0xe50
> > > 	 [<ffffffff811b4679>] SyS_perf_event_open+0x9/0x10
> > > 	 [<ffffffff81799f92>] system_call_fastpath+0x25/0x2a
> > > 	ftrace failed to modify [<ffffffff8126fee0>] SyS_dup+0x0/0x120
> > > 	 actual: e9:4b:50:2e:3f
> > >   
> > 
> > Again, why did the above happen. This is a kernel bug that needs to be
> > fixed. Everything else after this is unimportant, because it's just fall
> > out to the above bug.  
> 
> I'll double check what we (not KLP) do and maybe even what KLP does!

I would guess the fix is to have your stuff not monkey around with ftrace
locations or to modify your own kernel to have ftrace know about this.

-- Steve
