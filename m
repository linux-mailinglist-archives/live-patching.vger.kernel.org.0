Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFE92A93AD
	for <lists+live-patching@lfdr.de>; Fri,  6 Nov 2020 11:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgKFKH0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 6 Nov 2020 05:07:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:46708 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgKFKH0 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 6 Nov 2020 05:07:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5F249AB8F;
        Fri,  6 Nov 2020 10:07:24 +0000 (UTC)
Date:   Fri, 6 Nov 2020 11:07:24 +0100 (CET)
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
Subject: Re: [PATCH 07/11 v3] livepatch: Trigger WARNING if livepatch function
 fails due to recursion
In-Reply-To: <20201106023547.312639435@goodmis.org>
Message-ID: <alpine.LSU.2.21.2011061106090.10425@pobox.suse.cz>
References: <20201106023235.367190737@goodmis.org> <20201106023547.312639435@goodmis.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 5 Nov 2020, Steven Rostedt wrote:

> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> If for some reason a function is called that triggers the recursion
> detection of live patching, trigger a warning. By not executing the live
> patch code, it is possible that the old unpatched function will be called
> placing the system into an unknown state.
> 
> Link: https://lore.kernel.org/r/20201029145709.GD16774@alley
> 
> Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> Cc: Jiri Kosina <jikos@kernel.org>
> Cc: Joe Lawrence <joe.lawrence@redhat.com>
> Cc: live-patching@vger.kernel.org
> Suggested-by: Miroslav Benes <mbenes@suse.cz>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Acked-by: Miroslav Benes <mbenes@suse.cz>

> ---
> Changes since v2:
> 
>  - Blame Miroslav instead of Petr ;-)

Thanks. Fortunately, if printk is broken in WARN_ON_ONCE(), I can always 
blame Petr again :)

M
