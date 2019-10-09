Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB97D1130
	for <lists+live-patching@lfdr.de>; Wed,  9 Oct 2019 16:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731214AbfJIO06 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Oct 2019 10:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727769AbfJIO05 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Oct 2019 10:26:57 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 869C220B7C;
        Wed,  9 Oct 2019 14:26:56 +0000 (UTC)
Date:   Wed, 9 Oct 2019 10:26:54 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>, jikos@kernel.org,
        jpoimboe@redhat.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH 0/3] ftrace: Introduce PERMANENT ftrace_ops flag
Message-ID: <20191009102654.501ad7c3@gandalf.local.home>
In-Reply-To: <20191009112234.bi7lvp4pvmna26vz@pathway.suse.cz>
References: <20191007081714.20259-1-mbenes@suse.cz>
        <20191008193534.GA16675@redhat.com>
        <20191009112234.bi7lvp4pvmna26vz@pathway.suse.cz>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 9 Oct 2019 13:22:34 +0200
Petr Mladek <pmladek@suse.com> wrote:

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

No, it should affect *all* ftrace_ops (which it currently does). The
addition of the "PERMANENT" flag was going to change that to what you
are saying here. But thinking about this more, I believe that is the
wrong approach.

> 
> By other words, the handlers with FTRACE_OPS_FL_PERMANENT flag and
> only these handlers should ignore the global flag.
> 
> To be even more precise. If a function has registered more ftrace
> handlers then the global ftrace_enable setting shold affect only
> the handlers without the flag.
> 
> Is this the plan, please?

I think Joe's approach is much easier to understand and implement. The
"ftrace_enabled" is a global flag, and affects all things ftrace (the
function bindings). What this patch was doing, was what you said. Make
ftrace_enabled only affect the ftrace_ops without the "PERMANENT" flag
set. But that is complex and requires a bit more accounting in the
ftrace system. Something I think we should try to avoid.

What we are now proposing, is that if "ftrace_enabled" is not set, the
register_ftrace_function() will fail if the ftrace_ops passed to it has
the PERMANENT flag set (which would cause live patching to fail to
load). It also means that if ftrace_enabled was set, and we load a
ftrace_ops with the PERMANENT flag set, and the user tries to clear
ftrace_enabled, that operation will fail. That is, you will not be able
to clear ftrace_enabled if a ftrace_ops is loaded with the PERMANENT
flag set.

You will need to have your live kernel patching user space tooling make
sure that ftrace_enabled is set before loading, but that shouldn't be a
problem.

Does that make sense?

-- Steve

