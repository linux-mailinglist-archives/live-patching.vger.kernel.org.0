Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A73705A276
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2019 19:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfF1Rdf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 28 Jun 2019 13:33:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726408AbfF1Rdf (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 28 Jun 2019 13:33:35 -0400
Received: from pobox.suse.cz (prg-ext-pat.suse.com [213.151.95.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51963205F4;
        Fri, 28 Jun 2019 17:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561743214;
        bh=YxLIbKTsXkeNGBeOgLGxsdbSlVn+lJmPvWdqZxXTY9o=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=lZNM7yCzcrOSyI3/CgtnTokCk4mMR6mCJmdqoLmYGM1WM5otsXUNnnQEp0vRhmrDq
         Be6O2NjBK4O85riWi67JSswsP7XxCWR0O1K3HXuuZBuHKlfc3bHbbL1+oloZqOWHdA
         fDE89s425UzPn+xbOWWKx4qBmOuMM6jiJ7/fUSYE=
Date:   Fri, 28 Jun 2019 19:33:30 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] ftrace: Remove possible deadlock between register_kprobe()
 and ftrace_run_update_code()
In-Reply-To: <20190627231952.nqkbtcculvo2ddif@treble>
Message-ID: <nycvar.YFH.7.76.1906281932360.27227@cbobk.fhfr.pm>
References: <20190627081334.12793-1-pmladek@suse.com> <20190627224729.tshtq4bhzhneq24w@treble> <20190627190457.703a486e@gandalf.local.home> <alpine.DEB.2.21.1906280106360.32342@nanos.tec.linutronix.de> <20190627231952.nqkbtcculvo2ddif@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 27 Jun 2019, Josh Poimboeuf wrote:

> > How is that supposed to work?
> > 
> >     ftrace  	     	
> > 	prepare()
> > 	 setrw()
> > 			setro()
> > 	patch <- FAIL
> 
> /me dodges frozen shark
> 
> You are right of course.  My brain has apparently already shut off for
> the day.
> 
> Maybe a comment or two would help though.

I'd actually prefer (perhaps in parallel to the comment) using the 
__acquires() and __releases() anotations, so that sparse and friends don't 
get confused by that either.

-- 
Jiri Kosina
SUSE Labs

