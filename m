Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 202931933B
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 22:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfEIUOi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 16:14:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42844 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbfEIUOi (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 16:14:38 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8CEB030842A9;
        Thu,  9 May 2019 20:14:37 +0000 (UTC)
Received: from treble (ovpn-123-166.rdu2.redhat.com [10.10.123.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C498060CC0;
        Thu,  9 May 2019 20:14:32 +0000 (UTC)
Date:   Thu, 9 May 2019 15:14:30 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC][PATCH] ftrace/x86: Remove mcount support
Message-ID: <20190509201430.2eabpqjv2kw7dwnv@treble>
References: <20190509154902.34ea14f8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190509154902.34ea14f8@gandalf.local.home>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Thu, 09 May 2019 20:14:37 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, May 09, 2019 at 03:49:02PM -0400, Steven Rostedt wrote:
> 
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> There's two methods of enabling function tracing in Linux on x86. One is
> with just "gcc -pg" and the other is "gcc -pg -mfentry". The former will use
> calls to a special function "mcount" after the frame is set up in all C
> functions. The latter will add calls to a special function called "fentry"
> as the very first instruction of all C functions.
> 
> At compile time, there is a check to see if gcc supports, -mfentry, and if
> it does, it will use that, because it is more versatile and less error prone
> for function tracing.
> 
> Starting with v4.19, the minimum gcc supported to build the Linux kernel,
> was raised to version 4.6. That also happens to be the first gcc version to
> support -mfentry. Since on x86, using gcc versions from 4.6 and beyond will
> unconditionally enable the -mfentry, it will no longer use mcount as the
> method for inserting calls into the C functions of the kernel. This means
> that there is no point in continuing to maintain mcount in x86.
> 
> Remove support for using mcount. This makes the code less complex, and will
> also allow it to be simplified in the future.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  arch/x86/include/asm/ftrace.h    |  8 +++----
>  arch/x86/include/asm/livepatch.h |  3 ---
>  arch/x86/kernel/ftrace_32.S      | 36 +++++---------------------------
>  arch/x86/kernel/ftrace_64.S      | 28 +------------------------
>  4 files changed, 9 insertions(+), 66 deletions(-)

I was wondering why you didn't do s/mcount/fentry/ everywhere, but I
guess it's because mcount is still used by other arches, so it still has
a generic meaning tree-wide, right?

Anyway it's nice to finally see this cruft disappear.

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh
