Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B503A58E81
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2019 01:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfF0XZ3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 27 Jun 2019 19:25:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60058 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbfF0XZ2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 27 Jun 2019 19:25:28 -0400
Received: from p5b06daab.dip0.t-ipconnect.de ([91.6.218.171] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hgdlS-0002m2-TK; Fri, 28 Jun 2019 01:25:15 +0200
Date:   Fri, 28 Jun 2019 01:25:13 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Steven Rostedt <rostedt@goodmis.org>,
        Petr Mladek <pmladek@suse.com>,
        Miroslav Benes <mbenes@suse.cz>, Jessica Yu <jeyu@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] ftrace: Remove possible deadlock between register_kprobe()
 and ftrace_run_update_code()
In-Reply-To: <20190627231952.nqkbtcculvo2ddif@treble>
Message-ID: <alpine.DEB.2.21.1906280124170.32342@nanos.tec.linutronix.de>
References: <20190627081334.12793-1-pmladek@suse.com> <20190627224729.tshtq4bhzhneq24w@treble> <20190627190457.703a486e@gandalf.local.home> <alpine.DEB.2.21.1906280106360.32342@nanos.tec.linutronix.de> <20190627231952.nqkbtcculvo2ddif@treble>
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

On Thu, 27 Jun 2019, Josh Poimboeuf wrote:
> On Fri, Jun 28, 2019 at 01:09:08AM +0200, Thomas Gleixner wrote:
> > On Thu, 27 Jun 2019, Steven Rostedt wrote:
> > > I agree with Josh on this. As the original bug was the race between
> > > ftrace and live patching / modules changing the text from ro to rw and
> > > vice versa. Just protecting the update to the text permissions is more
> > > robust, and should be more self documenting when we need to handle
> > > other architectures for this.
> > 
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

Agreed. That would indeed be useful.

Thanks,

	tglx
