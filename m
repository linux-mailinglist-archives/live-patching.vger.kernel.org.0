Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3973DD1119
	for <lists+live-patching@lfdr.de>; Wed,  9 Oct 2019 16:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbfJIOX2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Oct 2019 10:23:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46476 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729491AbfJIOX2 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Oct 2019 10:23:28 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 05C0030BD1AE;
        Wed,  9 Oct 2019 14:23:28 +0000 (UTC)
Received: from redhat.com (dhcp-17-119.bos.redhat.com [10.18.17.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C9B85D6B2;
        Wed,  9 Oct 2019 14:23:26 +0000 (UTC)
Date:   Wed, 9 Oct 2019 10:23:25 -0400
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, rostedt@goodmis.org,
        jikos@kernel.org, jpoimboe@redhat.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH 0/3] ftrace: Introduce PERMANENT ftrace_ops flag
Message-ID: <20191009142325.GA3333@redhat.com>
References: <20191007081714.20259-1-mbenes@suse.cz>
 <20191008193534.GA16675@redhat.com>
 <20191009112234.bi7lvp4pvmna26vz@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009112234.bi7lvp4pvmna26vz@pathway.suse.cz>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 09 Oct 2019 14:23:28 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Oct 09, 2019 at 01:22:34PM +0200, Petr Mladek wrote:
> On Tue 2019-10-08 15:35:34, Joe Lawrence wrote:
> > On Mon, Oct 07, 2019 at 10:17:11AM +0200, Miroslav Benes wrote:
> > > Livepatch uses ftrace for redirection to new patched functions. It is
> > > thus directly affected by ftrace sysctl knobs such as ftrace_enabled.
> > > Setting ftrace_enabled to 0 also disables all live patched functions. It
> > > is not a problem per se, because only administrator can set sysctl
> > > values, but it still may be surprising.
> > > 
> > > Introduce PERMANENT ftrace_ops flag to amend this. If the
> > > FTRACE_OPS_FL_PERMANENT is set, the tracing of the function is not
> > > disabled. Such ftrace_ops can still be unregistered in a standard way.
> > > 
> > > The patch set passes ftrace and livepatch kselftests.
> > > 
> > > Miroslav Benes (3):
> > >   ftrace: Make test_rec_ops_needs_regs() generic
> > >   ftrace: Introduce PERMANENT ftrace_ops flag
> > >   livepatch: Use FTRACE_OPS_FL_PERMANENT
> > > 
> > >  Documentation/trace/ftrace-uses.rst |  6 ++++
> > >  Documentation/trace/ftrace.rst      |  2 ++
> > >  include/linux/ftrace.h              |  8 +++--
> > >  kernel/livepatch/patch.c            |  3 +-
> > >  kernel/trace/ftrace.c               | 47 ++++++++++++++++++++++++-----
> > >  5 files changed, 55 insertions(+), 11 deletions(-)
> > > 
> > > -- 
> > > 2.23.0
> > > 
> > 
> > Hi Miroslav,
> > 
> > I wonder if the opposite would be more intuitive: when ftrace_enabled is
> > not set, don't allow livepatches to register ftrace filters and
> > likewise, don't allow ftrace_enabled to be unset if any livepatches are
> > already registered.  I guess you could make an argument either way, but
> > just offering another option.  Perhaps livepatches should follow similar
> > behavior of other ftrace clients (like perf probes?)
> 
> I am not sure that I understand it correctly.
> 
> ftrace_enables is a global flag. My expectation is that it can be
> manipulated at any time. But it should affect only ftrace handlers
> without FTRACE_OPS_FL_PERMANENT flag.
> 
> By other words, the handlers with FTRACE_OPS_FL_PERMANENT flag and
> only these handlers should ignore the global flag.
> 
> To be even more precise. If a function has registered more ftrace
> handlers then the global ftrace_enable setting shold affect only
> the handlers without the flag.
> 

Petr,

I believe this is more or less what the patchset implemented.  I
pointed out a small inconsistency in that livepatches loaded after
ftrace_enable=0 successfully transitioned despite the ftrace handlers
not being enabled for that livepatch.  Toggling ftrace_enable would have
the side effect of enabling those handlers.

From the POV of ftrace I suppose this may be expected behavior and
nobody should be mucking with sysctl's that they don't fully understand.
However if I put on my sysadmin hat, I think I would find this slightly
confusing.  At the very least, the livepatch load should make some
mention that its replacement functions aren't actually live.

Shoring up this quirk so that the FTRACE_OPS_FL_PERMANENT always
registers and fires might be simple enough solution...


On the other hand, I suggested that the presence of
FTRACE_OPS_FL_PERMANENT flags could prevent turning off ftrace_enable
and vice versa.  That would offer the user immediate feedback without
introducing potentially unexpected (and silent) behavior.

I'm happy with either solution as long as it's consistent for the user
and easy to maintain :)

-- Joe
