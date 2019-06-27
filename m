Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C17C658DD7
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2019 00:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfF0WSl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 27 Jun 2019 18:18:41 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:59964 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfF0WSk (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 27 Jun 2019 18:18:40 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgciL-0001Za-QE; Fri, 28 Jun 2019 00:17:58 +0200
Date:   Fri, 28 Jun 2019 00:17:56 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Petr Mladek <pmladek@suse.com>
cc:     Steven Rostedt <rostedt@goodmis.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] ftrace: Remove possible deadlock between register_kprobe()
 and ftrace_run_update_code()
In-Reply-To: <20190627081334.12793-1-pmladek@suse.com>
Message-ID: <alpine.DEB.2.21.1906280017000.32342@nanos.tec.linutronix.de>
References: <20190627081334.12793-1-pmladek@suse.com>
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

On Thu, 27 Jun 2019, Petr Mladek wrote:
> Fortunately, the problematic fix is needed only on x86_64. It is
> the only architecture that calls set_all_modules_text_rw()
> in ftrace path and supports livepatching at the same time.
> 
> Therefore it is enough to move text_mutex handling from the generic
> kernel/trace/ftrace.c into arch/x86/kernel/ftrace.c:
> 
>    ftrace_arch_code_modify_prepare()
>    ftrace_arch_code_modify_post_process()
> 
> This patch basically reverts the ftrace part of the problematic

  ^^^^^^^^^ Sigh

> commit 9f255b632bf12c4dd7 ("module: Fix livepatch/ftrace module
> text permissions race"). And provides x86_64 specific-fix.
> 
> Some refactoring of the ftrace code will be needed when livepatching
> is implemented for arm or nds32. These architectures call
> set_all_modules_text_rw() and use stop_machine() at the same time.
> 
> Fixes: 9f255b632bf12c4dd7 ("module: Fix livepatch/ftrace module text permissions race")
> Signed-off-by: Petr Mladek <pmladek@suse.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>
