Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8148957BB1C
	for <lists+live-patching@lfdr.de>; Wed, 20 Jul 2022 18:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiGTQLL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 20 Jul 2022 12:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGTQLK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 20 Jul 2022 12:11:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2B052E59;
        Wed, 20 Jul 2022 09:11:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C598FCE21A6;
        Wed, 20 Jul 2022 16:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C8AC341CB;
        Wed, 20 Jul 2022 16:11:03 +0000 (UTC)
Date:   Wed, 20 Jul 2022 12:11:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alexey Dobriyan <adobriyan@gmail.com>
Cc:     mingo@redhat.com, linux-kernel@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org
Subject: Re: ftrace_kill() leads to kmalloc-512 UAF
Message-ID: <20220720121102.6cac8f1d@gandalf.local.home>
In-Reply-To: <YtgdsW8UBSwCKtQW@localhost.localdomain>
References: <YtgdsW8UBSwCKtQW@localhost.localdomain>
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


[ Adding live kernel patching folks ]

On Wed, 20 Jul 2022 18:22:25 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> I'm debugging crash of our product which does live kernel patching together
> with ISV security scanner which uses ftrace kprobes to do whatever it does.
> 
> What happens is that is ftrace ever detects .text change, refuses to patch
> and prints a warning with FTRACE_WARN_ON_ONCE() then there is reliable way
> to cause UAF on kmalloc-512 cache by trying to register kprobe with
> perf_event_open() and then unregistering it by exiting the process.
> 
> 1) live kernel patching happens, first instruction of some function changes

But live kernel patching uses ftrace to do this, so the question remains,
why doesn't ftrace know about this change?

> 
> 2) kprobe on that function is registered with perf_event_open()
> 
> 	WARNING: CPU: 5 PID: 2109 at kernel/trace/ftrace.c:1853 ftrace_bug+0x25d/0x270
> 	 [<ffffffff811638ed>] ftrace_bug+0x25d/0x270
> 	 [<ffffffff81065571>] ftrace_replace_code+0x2b1/0x420
> 	 [<ffffffff81163f9a>] ftrace_modify_all_code+0x6a/0xb0
> 	 [<ffffffff810656f0>] arch_ftrace_update_code+0x10/0x20
> 	 [<ffffffff81164077>] ftrace_run_update_code+0x17/0x70
> 	 [<ffffffff81165512>] ftrace_set_hash+0x1c2/0x1f0
> 	 [<ffffffff8126fee0>] ? SyS_dup2+0x60/0x60
> 	 [<ffffffff8126fee0>] ? SyS_dup2+0x60/0x60
> 	 [<ffffffff811655a0>] ftrace_set_filter_ip+0x60/0x70
> 	 [<ffffffff8179624c>] arm_kprobe+0x9c/0x140
> 	 [<ffffffff81796368>] enable_kprobe+0x78/0xa0
> 	 [<ffffffff81187bab>] enable_trace_kprobe+0x7b/0x120
> 	 [<ffffffff81797e5f>] kprobe_register+0x2f/0x60
> 	 [<ffffffff8118348a>] perf_trace_event_init+0x1aa/0x230
> 	 [<ffffffff811836b7>] perf_kprobe_init+0xa7/0xf0
> 	 [<ffffffff811a8919>] perf_kprobe_event_init+0x49/0x70
> 	 [<ffffffff811aa569>] perf_try_init_event+0x99/0xc0
> 	 [<ffffffff811b29f2>] perf_init_event+0x92/0x150
> 	 [<ffffffff811b2fa1>] perf_event_alloc+0x4f1/0x910
> 	 [<ffffffff811b3789>] SYSC_perf_event_open+0x3c9/0xe50
> 	 [<ffffffff811b4679>] SyS_perf_event_open+0x9/0x10
> 	 [<ffffffff81799f92>] system_call_fastpath+0x25/0x2a
> 	ftrace failed to modify [<ffffffff8126fee0>] SyS_dup+0x0/0x120
> 	 actual: e9:4b:50:2e:3f
> 

Again, why did the above happen. This is a kernel bug that needs to be
fixed. Everything else after this is unimportant, because it's just fall
out to the above bug.

-- Steve



> 3) FTRACE_WARN_ON_ONCE() calls ftrace_kill() which sets ftrace_disabled:
> 
> 	ftrace_disabled = 1;
> 
> 4) process exits, all kprobes are unregistered but "ftrace_disabled" is 1 now
>    so disarming fails with -ENODEV:
> 
> 	[  253.042821] WARNING: CPU: 2 PID: 1682 at kernel/kprobes.c:1006 disarm_kprobe+0x102/0x180
> 	[  253.044424] Failed to disarm kprobe-ftrace at do_exit+0x0/0xa30 (-19)
> 	[  253.086658]  [<ffffffff811655a0>] ? ftrace_set_filter_ip+0x60/0x70
> 	[  253.089599]  [<ffffffff810a1810>] ? mm_update_next_owner+0x230/0x230
> 	[  253.090878]  [<ffffffff81796492>] disarm_kprobe+0x102/0x180
> 	[  253.092084]  [<ffffffff817965dd>] __disable_kprobe+0xcd/0xf0
> 	[  253.093242]  [<ffffffff81796c13>] disable_kprobe+0x23/0x40
> 	[  253.094390]  [<ffffffff81187d14>] disable_trace_kprobe+0xc4/0x100
> 	[  253.095751]  [<ffffffff81797e53>] kprobe_register+0x23/0x60
> 	[  253.097420]  [<ffffffff8118327c>] perf_trace_event_unreg.isra.1+0x3c/0xa0
> 	[  253.098866]  [<ffffffff81183730>] perf_kprobe_destroy+0x30/0x40
> 	[  253.100085]  [<ffffffff811af50a>] _free_event+0xfa/0x2f0
> 	[  253.101147]  [<ffffffff811af769>] put_event+0x19/0x20
> 	[  253.102154]  [<ffffffff811af993>] perf_event_release_kernel+0x223/0x300
> 	[  253.103457]  [<ffffffff811afa80>] perf_release+0x10/0x20
> 	[  253.106188]  [<ffffffff8125063c>] __fput+0xec/0x230
> 
> and more importantly underlying kprobe is not removed from "kprobe_table" hashtable:
> 
> 	unregister_kprobe
> 	unregister_kprobes
> 	__unregister_kprobe_top
> 	__disable_kprobe
> 		ret = disarm_kprobe(orig_p, true);
> 			disarm_kprobe_ftrace
> 			__disarm_kprobe_ftrace
> 			ftrace_set_filter_ip
> 			ftrace_set_addr
> 			ftrace_set_hash
> 			        if (unlikely(ftrace_disabled))
> 			                return -ENODEV;
> 
> 				// BOOM, function does nothing!!!
> 
> 		if (ret) {
> 			p->flags &= ~KPROBE_FLAG_DISABLED;
> 			return ERR_PTR(ret);
> 		}	
> 
> 
> perf_kprobe_destroy() will free the containing kprobe with inner kprobe
> still in hashtable manifesting the bug as regular oopses, mystical oopses
> in unrelated processes and doublefaults even.
> 
> 	void perf_kprobe_destroy(struct perf_event *p_event)
> 	{
> 	        perf_trace_event_close(p_event);
> 
> 		// does more or less nothing
> 	        perf_trace_event_unreg(p_event);
> 		// does kfree
> 	        destroy_local_trace_kprobe(p_event->tp_event);
> 	}
> 
> 
> crash> p kprobe_table  
> kprobe_table = $1 =
>  {{
>   }, {
>     first = 0xffff880135e9ddd8
>   }, {
> 	...
> 
> crash> struct kprobe 0xffff880135e9ddd8  
> struct kprobe {
>   hlist = {
>     next = 0x6b6b6b6b6b6b6b6b,
>     pprev = 0x6b6b6b6b6b6b6b6b
>   },
>   list = {
>     next = 0x6b6b6b6b6b6b6b6b,
>     prev = 0x6b6b6b6b6b6b6b6b
>   },
>   nmissed = 7740398493674204011,
>   addr = 0x6b6b6b6b6b6b6b6b <Address 0x6b6b6b6b6b6b6b6b out of bounds>,
> 		....
> 
> This is much easier to reproduce by adding the following BUG_ON:
> 
> 	--- a/kernel/trace/trace_kprobe.c.orig  2022-07-20 14:35:06.760511285 +0300
> 	+++ b/kernel/trace/trace_kprobe.c       2022-07-20 14:41:14.699877744 +0300
> 	@@ -512,8 +512,10 @@ static void __unregister_trace_kprobe(st
> 	        if (trace_probe_is_registered(&tk->tp)) {
> 	                if (trace_kprobe_is_return(tk))
> 	                        unregister_kretprobe(&tk->rp);
> 	-               else
> 	+               else {
> 	                        unregister_kprobe(&tk->rp.kp);
> 	+                       BUG_ON(!hlist_unhashed(&tk->rp.kp.hlist));
> 	+               }
> 	                tk->tp.flags &= ~TP_FLAG_REGISTERED;
> 	                /* Cleanup kprobe for reuse */
> 	                if (tk->rp.kp.symbol_name)
> 
> Basically, if ftrace_kill() is ever called ever there is a ticking UAFbomb.
> 
> 	Alexey (CloudLinux)

