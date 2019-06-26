Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8613A56CDD
	for <lists+live-patching@lfdr.de>; Wed, 26 Jun 2019 16:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfFZOwi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 26 Jun 2019 10:52:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32822 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbfFZOwi (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 26 Jun 2019 10:52:38 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A728681DEC;
        Wed, 26 Jun 2019 14:52:24 +0000 (UTC)
Received: from treble (ovpn-126-66.rdu2.redhat.com [10.10.126.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1A2560BE5;
        Wed, 26 Jun 2019 14:52:09 +0000 (UTC)
Date:   Wed, 26 Jun 2019 09:52:06 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>,
        Jessica Yu <jeyu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Ingo Molnar <mingo@kernel.org>, mhiramat@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 1/3] module: Fix livepatch/ftrace module text permissions
 race
Message-ID: <20190626145206.vqp4nivxva4oshvw@treble>
References: <cover.1560474114.git.jpoimboe@redhat.com>
 <ab43d56ab909469ac5d2520c5d944ad6d4abd476.1560474114.git.jpoimboe@redhat.com>
 <20190614170408.1b1162dc@gandalf.local.home>
 <alpine.LSU.2.21.1906260908170.22069@pobox.suse.cz>
 <20190626133721.ea2iuqqu4to2jpbv@pathway.suse.cz>
 <alpine.DEB.2.21.1906261643200.32342@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1906261643200.32342@nanos.tec.linutronix.de>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Wed, 26 Jun 2019 14:52:38 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jun 26, 2019 at 04:44:45PM +0200, Thomas Gleixner wrote:
> On Wed, 26 Jun 2019, Petr Mladek wrote:
> > On Wed 2019-06-26 10:22:45, Miroslav Benes wrote:
> > It is similar problem that has been solved by 2d1e38f56622b9bb5af8
> > ("kprobes: Cure hotplug lock ordering issues"). This commit solved
> > it by always taking cpu_hotplug_lock.rw_sem before text_mutex inside.
> > 
> > If we follow the lock ordering then ftrace has to take text_mutex
> > only when stop_machine() is not called or from code called via
> > stop_machine() parameter.
> > 
> > This is not easy with the current design. For example, arm calls
> > set_all_modules_text_rw() already in ftrace_arch_code_modify_prepare(),
> > see arch/arm/kernel/ftrace.c. And it is called:
> > 
> >   + outside stop_machine() from ftrace_run_update_code()
> >   + without stop_machine() from ftrace_module_enable()
> > 
> > A conservative solution for 5.2 release would be to move text_mutex
> > locking from the generic kernel/trace/ftrace.c into
> > arch/x86/kernel/ftrace.c:
> > 
> >    ftrace_arch_code_modify_prepare()
> >    ftrace_arch_code_modify_post_process()
> > 
> > It should be enough to fix the original problem because
> > x86 is the only architecture that calls set_all_modules_text_rw()
> > in ftrace path and supports livepatching at the same time.
> 
> Looks correct, but I've paged out all the gory details vs. lock ordering in
> that area.

Looks good to me as well, Petr can you post a proper patch?

-- 
Josh
