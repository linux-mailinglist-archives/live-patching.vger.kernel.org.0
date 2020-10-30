Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557712A0557
	for <lists+live-patching@lfdr.de>; Fri, 30 Oct 2020 13:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgJ3M3C (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 30 Oct 2020 08:29:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:51060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726586AbgJ3M2h (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 30 Oct 2020 08:28:37 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55D4820728;
        Fri, 30 Oct 2020 12:28:34 +0000 (UTC)
Date:   Fri, 30 Oct 2020 08:28:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 6/9] livepatch/ftrace: Add recursion protection to the
 ftrace callback
Message-ID: <20201030082831.5142be16@oasis.local.home>
In-Reply-To: <20201029103744.0f7f52dc@gandalf.local.home>
References: <20201028115244.995788961@goodmis.org>
 <20201028115613.291169246@goodmis.org>
 <alpine.LSU.2.21.2010291443310.1688@pobox.suse.cz>
 <20201029103744.0f7f52dc@gandalf.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 29 Oct 2020 10:37:44 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> I also plan on adding code that reports when recursion has happened,
> because even if it's not a problem, recursion adds extra overhead.

I did the above (will be posting that later, maybe next week), and
found two bugs with the recursion code. :-/

One was in the nmi handling, where it never cleared the nmi bit
(because it was zero, and thus ignored), and that caused all functions
in NMI handlers to not be traced (because it thought it was a
recursion).
(see https://lore.kernel.org/r/20201030002722.766a22df@oasis.local.home)

The second was the recursion algorithm depends on the preempt_count()
being accurate, but when it transitions between context, and there's
tracing in that transition, it could falsely record it as a recursion.

I have a fix for both of these bugs and will be sending them up marked
for stable after I finish testing them.

This goes to show that the recursion reported should be implemented
(but that will be for the next merge window).

-- Steve
