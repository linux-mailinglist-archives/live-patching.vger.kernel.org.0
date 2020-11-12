Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1E62B0411
	for <lists+live-patching@lfdr.de>; Thu, 12 Nov 2020 12:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgKLLkn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 12 Nov 2020 06:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbgKLLjz (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 12 Nov 2020 06:39:55 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83BB1C0617A7;
        Thu, 12 Nov 2020 03:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=b6ATZfVWGAVrJTHLYJ8q8DfRh8F5q774OL7MDaycL9E=; b=lDnDxzUPrpug4qGWJPiQ1cFY+2
        S3j2YMIm055tPZFqM9J1KwtwdUkCv0Yt5hm4gGBNHDYJ5OVC4R+RVaIt2VRTbMldKZwSnLXHqUNti
        Fcjil6yScd/4sYyehst1nWnP4rDtZCp3nxXWUb2h/IhgrkXEG/HZl2gA8suUAdzdPATsfbTcVgkAb
        B7tnG1S3wp4/bJLnl53X2M/oGIY0UojGKj+4+2a9Qc5EsKHpHoimB/r5hZjER3qbZioBn44J6edXj
        7qV8yQ1aR/w6XSfKWoZVio1IU+ot3r0DG+6zqpPAdoeUF2rynRuRbKzm/3t3Ff2hns7oDmmU8MeU8
        QEGwcl/w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kdAx4-00052B-Kw; Thu, 12 Nov 2020 11:39:42 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 39D83305C16;
        Thu, 12 Nov 2020 12:39:40 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id EB14A2C71BAB2; Thu, 12 Nov 2020 12:39:39 +0100 (CET)
Date:   Thu, 12 Nov 2020 12:39:39 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, live-patching@vger.kernel.org
Subject: Re: [PATCH 3/3 v5] livepatch: Use the default ftrace_ops instead of
 REGS when ARGS is available
Message-ID: <20201112113939.GU2651@hirez.programming.kicks-ass.net>
References: <20201112011516.589846126@goodmis.org>
 <20201112011815.755256598@goodmis.org>
 <20201112082144.GS2628@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112082144.GS2628@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Nov 12, 2020 at 09:21:44AM +0100, Peter Zijlstra wrote:
> Also, do you want something like:
> 
> unsigned long ftrace_regs_get_register(struct ftrace_regs *regs, unsigned int offset)
> {

I forgot the full regs case:

	if (regs->regs.cs)
		return regs_get_register(regs->regs, offset);

> 	switch (offset / sizeof(long)) {
> 	case  4: /* RBP */
> 
> 	case  8: /* R9  */
> 	case  9: /* R8  */
> 	case 10: /* RAX */
> 	case 11: /* RCX */
> 	case 12: /* RDX */
> 	case 13: /* RSI */
> 	case 14: /* RDI */
> 	case 15: /* ORIG_RAX */
> 	case 16: /* RIP */
> 		return *(unsigned long *)regs->regs + offset;
> 
> 	default:
> 		WARN_ON_ONCE(1);
> 	}
> 	return 0;
> }
