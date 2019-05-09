Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6781A19323
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 22:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfEIUAS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 16:00:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33654 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfEIUAS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 16:00:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=d7rDRzrT2gGMKM2EcsXcEBtZ+OsAWszYJnXBx+B7r9Q=; b=OaBknxIXs6Dsq6oPP38/LiXZp
        CgkLkTNSYG+MdVPV3qVtfKAh/8OhXdAc7lgTNGX2OM2fH1EM2MfRQuIM8O5MInhcGnGwvNgSObP4B
        7KbggnUGd3JQWFFiOpDyn9lCvgnET6X8yKXeyBSvKusocU77Uxw3/r/21a8KODEYniYhTSj+v8oCO
        xMRhQwqj6233DKUzfHjfBtVh+/jlcsC/sjTvOKYJ17BqiTUCh3rTI+c52WVKcIM8P9skVOA2EQ3d2
        mZBHSCCfL+F0DDvNOyzAEfYttY1fDygYrb0mPQWcQCM3vpwFh7RfacvzoGZe1qjHTNLNBnFFIT8LG
        w8tfrfn1g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hOpCh-0006Ew-T1; Thu, 09 May 2019 19:59:44 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 1DB832143093C; Thu,  9 May 2019 21:59:42 +0200 (CEST)
Date:   Thu, 9 May 2019 21:59:42 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC][PATCH] ftrace/x86: Remove mcount support
Message-ID: <20190509195942.GE2623@hirez.programming.kicks-ass.net>
References: <20190509154902.34ea14f8@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509154902.34ea14f8@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
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

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
