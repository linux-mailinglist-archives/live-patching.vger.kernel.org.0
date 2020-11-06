Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96FC2A939F
	for <lists+live-patching@lfdr.de>; Fri,  6 Nov 2020 11:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbgKFKFU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Nov 2020 05:05:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:43070 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgKFKFU (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Nov 2020 05:05:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 73D98AD0B;
        Fri,  6 Nov 2020 10:05:18 +0000 (UTC)
Date:   Fri, 6 Nov 2020 11:05:17 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Steven Rostedt <rostedt@goodmis.org>
cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 06/11 v3] livepatch/ftrace: Add recursion protection to
 the ftrace callback
In-Reply-To: <20201106023547.122802424@goodmis.org>
Message-ID: <alpine.LSU.2.21.2011061105030.10425@pobox.suse.cz>
References: <20201106023235.367190737@goodmis.org> <20201106023547.122802424@goodmis.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 5 Nov 2020, Steven Rostedt wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> If a ftrace callback does not supply its own recursion protection and
> does not set the RECURSION_SAFE flag in its ftrace_ops, then ftrace will
> make a helper trampoline to do so before calling the callback instead of
> just calling the callback directly.
> 
> The default for ftrace_ops is going to change. It will expect that handlers
> provide their own recursion protection, unless its ftrace_ops states
> otherwise.
> 
> Link: https://lkml.kernel.org/r/20201028115613.291169246@goodmis.org
> 
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Miroslav Benes <mbenes@suse.cz>
> Cc: Joe Lawrence <joe.lawrence@redhat.com>
> Cc: live-patching@vger.kernel.org
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Acked-by: Miroslav Benes <mbenes@suse.cz>

M
