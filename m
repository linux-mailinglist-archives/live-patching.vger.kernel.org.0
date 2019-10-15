Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7152D7785
	for <lists+live-patching@lfdr.de>; Tue, 15 Oct 2019 15:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730687AbfJONgq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 15 Oct 2019 09:36:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:32806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728880AbfJONgq (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 15 Oct 2019 09:36:46 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 855752064A;
        Tue, 15 Oct 2019 13:36:44 +0000 (UTC)
Date:   Tue, 15 Oct 2019 09:36:42 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Petr Mladek <pmladek@suse.com>, jikos@kernel.org,
        joe.lawrence@redhat.com, jpoimboe@redhat.com, mingo@redhat.com,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: Introduce PERMANENT ftrace_ops flag
Message-ID: <20191015093642.72e872d0@gandalf.local.home>
In-Reply-To: <alpine.LSU.2.21.1910151244550.30206@pobox.suse.cz>
References: <20191014105923.29607-1-mbenes@suse.cz>
        <20191014111719.141bd4fa@gandalf.local.home>
        <20191015074540.bxehllisibls3kk7@pathway.suse.cz>
        <alpine.LSU.2.21.1910151244550.30206@pobox.suse.cz>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 15 Oct 2019 12:50:59 +0200 (CEST)
Miroslav Benes <mbenes@suse.cz> wrote:

> > > > @@ -6752,12 +6764,19 @@ ftrace_enable_sysctl(struct ctl_table *table, int write,
> > > >  		ftrace_startup_sysctl();
> > > >  
> > > >  	} else {
> > > > +		if (is_permanent_ops_registered()) {
> > > > +			ftrace_enabled = last_ftrace_enabled;  
> > > 
> > > Although this is not incorrect, but may be somewhat confusing.
> > > 
> > > At this location, last_ftrace_enabled is always true.
> > > 
> > > I'm thinking this would be better to simply set it to false here.  
> > 
> > IMHO, we want to set ftrace_enabled = true here.

Yes, I meant true (don't know why I said false :-/ )

> > 
> > It was set to "false" by writing to the sysfs file. But the change
> > gets rejected. ftrace will stay enabled. So, we should set
> > the value back to "true".  
> 
> That's correct.
> 
> I can make it explicit as proposed. I just thought that 'ftrace_enabled = 
> last_ftrace_enabled' was clear enough given Petr's explanation.
> 
> > > > +			ret = -EBUSY;
> > > > +			goto out;
> > > > +		}
> > > > +
> > > >  		/* stopping ftrace calls (just send to ftrace_stub) */
> > > >  		ftrace_trace_function = ftrace_stub;
> > > >  
> > > >  		ftrace_shutdown_sysctl();
> > > >  	}
> > > >  
> > > > +	last_ftrace_enabled = !!ftrace_enabled;
> > > >   out:  
> > > 
> > > And move the assignment of last_ftrace_enabled to after the "out:"
> > > label.  
> > 
> > This change might make sense anyway. But it is not strictly necessary
> > from my POV.  
> 
> If it stays before "out:" label, last_ftrace_enabled is set if and only if 
> it has to be set. I think it is better, but I can, of course, move it in 
> v3 if Steven prefers it.

I don't have any strong feelings here. If you want to keep it like
this, I wont argue.

-- Steve

