Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D69871A4F6
	for <lists+live-patching@lfdr.de>; Fri, 10 May 2019 23:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfEJVyG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 10 May 2019 17:54:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727828AbfEJVyG (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 10 May 2019 17:54:06 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35C4F217D6;
        Fri, 10 May 2019 21:54:04 +0000 (UTC)
Date:   Fri, 10 May 2019 17:54:02 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC][PATCH 3/2] livepatch: remove klp_check_compiler_support()
Message-ID: <20190510175402.173e0cf8@gandalf.local.home>
In-Reply-To: <nycvar.YFH.7.76.1905102346100.17054@cbobk.fhfr.pm>
References: <20190510163519.794235443@goodmis.org>
        <nycvar.YFH.7.76.1905102346100.17054@cbobk.fhfr.pm>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 10 May 2019 23:47:50 +0200 (CEST)
Jiri Kosina <jikos@kernel.org> wrote:

> From: Jiri Kosina <jkosina@suse.cz>
> 
> The only purpose of klp_check_compiler_support() is to make sure that we 
> are not using ftrace on x86 via mcount (because that's executed only after 
> prologue has already happened, and that's too late for livepatching 
> purposes).
> 
> Now that mcount is not supported by ftrace any more, there is no need for 
> klp_check_compiler_support() either.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
> 
> I guess it makes most sense to merge this together with mcount removal in 
> one go.

Thanks, I applied it to my queue and will start running it through my
tests.

-- Steve
