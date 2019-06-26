Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF1B56C7E
	for <lists+live-patching@lfdr.de>; Wed, 26 Jun 2019 16:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfFZOp1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Jun 2019 10:45:27 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:48888 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbfFZOp1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Jun 2019 10:45:27 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hg9AE-00046N-A6; Wed, 26 Jun 2019 16:44:46 +0200
Date:   Wed, 26 Jun 2019 16:44:45 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Petr Mladek <pmladek@suse.com>
cc:     Miroslav Benes <mbenes@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 1/3] module: Fix livepatch/ftrace module text permissions
 race
In-Reply-To: <20190626133721.ea2iuqqu4to2jpbv@pathway.suse.cz>
Message-ID: <alpine.DEB.2.21.1906261643200.32342@nanos.tec.linutronix.de>
References: <cover.1560474114.git.jpoimboe@redhat.com> <ab43d56ab909469ac5d2520c5d944ad6d4abd476.1560474114.git.jpoimboe@redhat.com> <20190614170408.1b1162dc@gandalf.local.home> <alpine.LSU.2.21.1906260908170.22069@pobox.suse.cz>
 <20190626133721.ea2iuqqu4to2jpbv@pathway.suse.cz>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 26 Jun 2019, Petr Mladek wrote:
> On Wed 2019-06-26 10:22:45, Miroslav Benes wrote:
> It is similar problem that has been solved by 2d1e38f56622b9bb5af8
> ("kprobes: Cure hotplug lock ordering issues"). This commit solved
> it by always taking cpu_hotplug_lock.rw_sem before text_mutex inside.
> 
> If we follow the lock ordering then ftrace has to take text_mutex
> only when stop_machine() is not called or from code called via
> stop_machine() parameter.
> 
> This is not easy with the current design. For example, arm calls
> set_all_modules_text_rw() already in ftrace_arch_code_modify_prepare(),
> see arch/arm/kernel/ftrace.c. And it is called:
> 
>   + outside stop_machine() from ftrace_run_update_code()
>   + without stop_machine() from ftrace_module_enable()
> 
> A conservative solution for 5.2 release would be to move text_mutex
> locking from the generic kernel/trace/ftrace.c into
> arch/x86/kernel/ftrace.c:
> 
>    ftrace_arch_code_modify_prepare()
>    ftrace_arch_code_modify_post_process()
> 
> It should be enough to fix the original problem because
> x86 is the only architecture that calls set_all_modules_text_rw()
> in ftrace path and supports livepatching at the same time.

Looks correct, but I've paged out all the gory details vs. lock ordering in
that area.

Thanks,

	tglx
