Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8B1D73EB
	for <lists+live-patching@lfdr.de>; Tue, 15 Oct 2019 12:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfJOKvC (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Oct 2019 06:51:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:39368 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731364AbfJOKvC (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Oct 2019 06:51:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6E6CBB4C2;
        Tue, 15 Oct 2019 10:51:00 +0000 (UTC)
Date:   Tue, 15 Oct 2019 12:50:59 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Petr Mladek <pmladek@suse.com>
cc:     Steven Rostedt <rostedt@goodmis.org>, jikos@kernel.org,
        joe.lawrence@redhat.com, jpoimboe@redhat.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: Introduce PERMANENT ftrace_ops flag
In-Reply-To: <20191015074540.bxehllisibls3kk7@pathway.suse.cz>
Message-ID: <alpine.LSU.2.21.1910151244550.30206@pobox.suse.cz>
References: <20191014105923.29607-1-mbenes@suse.cz> <20191014111719.141bd4fa@gandalf.local.home> <20191015074540.bxehllisibls3kk7@pathway.suse.cz>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 15 Oct 2019, Petr Mladek wrote:

> On Mon 2019-10-14 11:17:19, Steven Rostedt wrote:
> > On Mon, 14 Oct 2019 12:59:23 +0200
> > Miroslav Benes <mbenes@suse.cz> wrote:
> > 
> > >  int
> > >  ftrace_enable_sysctl(struct ctl_table *table, int write,
> > >  		     void __user *buffer, size_t *lenp,
> > > @@ -6740,8 +6754,6 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
> > >  	if (ret || !write || (last_ftrace_enabled == !!ftrace_enabled))
> > >  		goto out;
> > >  
> > > -	last_ftrace_enabled = !!ftrace_enabled;
> > > -
> > >  	if (ftrace_enabled) {
> > >  
> > >  		/* we are starting ftrace again */
> > > @@ -6752,12 +6764,19 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
> > >  		ftrace_startup_sysctl();
> > >  
> > >  	} else {
> > > +		if (is_permanent_ops_registered()) {
> > > +			ftrace_enabled = last_ftrace_enabled;
> > 
> > Although this is not incorrect, but may be somewhat confusing.
> > 
> > At this location, last_ftrace_enabled is always true.
> > 
> > I'm thinking this would be better to simply set it to false here.
> 
> IMHO, we want to set ftrace_enabled = true here.
> 
> It was set to "false" by writing to the sysfs file. But the change
> gets rejected. ftrace will stay enabled. So, we should set
> the value back to "true".

That's correct.

I can make it explicit as proposed. I just thought that 'ftrace_enabled = 
last_ftrace_enabled' was clear enough given Petr's explanation.

> > > +			ret = -EBUSY;
> > > +			goto out;
> > > +		}
> > > +
> > >  		/* stopping ftrace calls (just send to ftrace_stub) */
> > >  		ftrace_trace_function = ftrace_stub;
> > >  
> > >  		ftrace_shutdown_sysctl();
> > >  	}
> > >  
> > > +	last_ftrace_enabled = !!ftrace_enabled;
> > >   out:
> > 
> > And move the assignment of last_ftrace_enabled to after the "out:"
> > label.
> 
> This change might make sense anyway. But it is not strictly necessary
> from my POV.

If it stays before "out:" label, last_ftrace_enabled is set if and only if 
it has to be set. I think it is better, but I can, of course, move it in 
v3 if Steven prefers it.

Thanks
Miroslav


