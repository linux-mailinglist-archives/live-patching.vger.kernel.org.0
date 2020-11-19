Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B1F2B976A
	for <lists+live-patching@lfdr.de>; Thu, 19 Nov 2020 17:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgKSQHx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 19 Nov 2020 11:07:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:41676 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727940AbgKSQHx (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 19 Nov 2020 11:07:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1605802070; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4jFe/antxe2FdZg8tiI+iVpO8o5c97eszsK32kDY/L0=;
        b=XjEKbQF+CRK7Grbmpu4QGNIoe8yvloChqKqubPlpPVMBd2KPctnIOX3s05U43AGV47bI43
        tCq/dZ1VMlCouCOpESzUA+W044kdlRXB+5M65TNCoJw5OF94MhSrdcmZNhWnXQ9dZXQPfB
        QsC3TXlgoI+95hGKB1Txie+i8//BLrM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BDF31AA4F;
        Thu, 19 Nov 2020 16:07:50 +0000 (UTC)
Date:   Thu, 19 Nov 2020 17:07:50 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org
Subject: Re: [PATCH 3/3 v7] livepatch: Use the default ftrace_ops instead of
 REGS when ARGS is available
Message-ID: <X7aYVgRa5uP8sAMM@alley>
References: <20201113171811.288150055@goodmis.org>
 <20201113171939.455339580@goodmis.org>
 <X7ZcYIWJEPXW6Z9s@alley>
 <20201119091235.60be696e@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119091235.60be696e@gandalf.local.home>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2020-11-19 09:12:35, Steven Rostedt wrote:
> On Thu, 19 Nov 2020 12:52:00 +0100
> Petr Mladek <pmladek@suse.com> wrote:
> 
> > >  #ifdef CONFIG_LIVEPATCH
> > > -static inline void klp_arch_set_pc(struct pt_regs *regs, unsigned long ip)
> > > +static inline void klp_arch_set_pc(struct ftrace_regs *fregs, unsigned long ip)
> > >  {
> > > +	struct pt_regs *regs = ftrace_get_regs(fregs);  
> > 
> > Should we check for NULL pointer here?
> 
> As mentioned in my last email. regs could have been NULL for the same
> reasons before this patch, and we didn't check it then. Why should we check
> it now?
> 
> The ftrace_get_regs() only makes sure that a ftrace_ops that set
> FL_SAVE_REGS gets it, and those that did not, don't.
> 
> But that's not entirely true either. If there's two callbacks to the same
> function, and one has FL_SAVE_REGS set, they both can have access to the
> regs (before and after this patch). It's just that the one that did not
> have FL_SAVE_REGS set, isn't guaranteed to have it.

Makes sense. Thanks for explanation. Feel free to use:

Acked-by: Petr Mladek <pmladek@suse.com>

I actually did review of all patches and they looked fine to me.
I just did not check all corner cases, assembly, and did not test
it, so I give it just my ack. I believe your testing ;-)

Best Regards,
Petr
