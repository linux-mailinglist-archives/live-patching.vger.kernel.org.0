Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819F92A30A0
	for <lists+live-patching@lfdr.de>; Mon,  2 Nov 2020 17:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgKBQ4n (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 2 Nov 2020 11:56:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:55124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbgKBQ4n (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 2 Nov 2020 11:56:43 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA828206F9;
        Mon,  2 Nov 2020 16:56:41 +0000 (UTC)
Date:   Mon, 2 Nov 2020 11:56:39 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 07/11 v2] livepatch: Trigger WARNING if livepatch
 function fails due to recursion
Message-ID: <20201102115639.43e139cd@gandalf.local.home>
In-Reply-To: <20201102144109.GI20201@alley>
References: <20201030213142.096102821@goodmis.org>
        <20201030214014.167613723@goodmis.org>
        <20201102144109.GI20201@alley>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 2 Nov 2020 15:41:09 +0100
Petr Mladek <pmladek@suse.com> wrote:

> On Fri 2020-10-30 17:31:49, Steven Rostedt wrote:
> > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> > 
> > If for some reason a function is called that triggers the recursion
> > detection of live patching, trigger a warning. By not executing the live
> > patch code, it is possible that the old unpatched function will be called
> > placing the system into an unknown state.
> > 
> > Link: https://lore.kernel.org/r/20201029145709.GD16774@alley
> > 
> > Cc: Josh Poimboeuf <jpoimboe@redhat.com>
> > Cc: Jiri Kosina <jikos@kernel.org>
> > Cc: Miroslav Benes <mbenes@suse.cz>
> > Cc: Joe Lawrence <joe.lawrence@redhat.com>
> > Cc: live-patching@vger.kernel.org
> > Suggested-by: Petr Mladek <pmladek@suse.com>  
> 
> It has actually been first suggested by Miroslav. He might want
> to take the fame and eventual shame ;-)

I'll switch suggested by to Miroslav.

> 
> > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>  
> 
> Reviewed-by: Petr Mladek <pmladek@suse.com>

Thanks!

-- Steve

