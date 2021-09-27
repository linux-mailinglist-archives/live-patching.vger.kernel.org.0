Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B0D419675
	for <lists+live-patching@lfdr.de>; Mon, 27 Sep 2021 16:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbhI0Oet (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 27 Sep 2021 10:34:49 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47740 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbhI0Oet (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 27 Sep 2021 10:34:49 -0400
Received: from relay1.suse.de (relay1.suse.de [149.44.160.133])
        by smtp-out2.suse.de (Postfix) with ESMTP id A996620123;
        Mon, 27 Sep 2021 14:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632753190; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8sRfJ93TTmGOFGZU8ki6FPLOxhHNL/86eQfL7gvj9gQ=;
        b=a/WYLTWiEM9GJYgC5HzGv8VcH4DK/a7cGtQ/cs6cuyVDt3izc7Z6qSGi9Uf+NmYqOlRitB
        8HTV0UlyNeGA3URQpOCd141qS9GEL+7lcyqV7KEcmGuHsKjRLljdPnhclSsk10jp1x2J2e
        nh11fNJsasqPbuSY8Obt4NyZGF139Ps=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay1.suse.de (Postfix) with ESMTPS id 849F02646C;
        Mon, 27 Sep 2021 14:33:10 +0000 (UTC)
Date:   Mon, 27 Sep 2021 16:33:10 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Joel Savitz <jsavitz@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, gor@linux.ibm.com,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: Re: [RFC][PATCH 6/7] context_tracking: Provide SMP ordering using RCU
Message-ID: <YVHWJi6AQwyH2Eys@alley>
References: <20210922110506.703075504@infradead.org>
 <20210922110836.244770922@infradead.org>
 <20210924185705.GA1264192@jsavitz.bos.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210924185705.GA1264192@jsavitz.bos.csb>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2021-09-24 14:57:05, Joel Savitz wrote:
> On Wed, Sep 22, 2021 at 01:05:12PM +0200, Peter Zijlstra wrote:
> > ---
> >  include/linux/context_tracking_state.h |   12 ++++++++++++
> >  kernel/context_tracking.c              |    7 ++++---
> >  2 files changed, 16 insertions(+), 3 deletions(-)
> > 
> > --- a/include/linux/context_tracking_state.h
> > +++ b/include/linux/context_tracking_state.h
> > @@ -45,11 +45,23 @@ static __always_inline bool context_trac
> >  {
> >  	return __this_cpu_read(context_tracking.state) == CONTEXT_USER;
> >  }
> > +
> > +static __always_inline bool context_tracking_state_cpu(int cpu)
> > +{
> > +	struct context_tracking *ct = per_cpu_ptr(&context_tracking);
> > +
> > +	if (!context_tracking_enabled() || !ct->active)
> > +		return CONTEXT_DISABLED;
> > +
> > +	return ct->state;
> > +}
> > +
> >  #else
> >  static inline bool context_tracking_in_user(void) { return false; }
> >  static inline bool context_tracking_enabled(void) { return false; }
> >  static inline bool context_tracking_enabled_cpu(int cpu) { return false; }
> >  static inline bool context_tracking_enabled_this_cpu(void) { return false; }
> > +static inline bool context_tracking_state_cpu(int cpu) { return CONTEXT_DISABLED; }
> >  #endif /* CONFIG_CONTEXT_TRACKING */
> >  
> >  #endif
> 
> Should context_tracking_state_cpu return an enum ctx_state rather than a
> bool? It appears to be doing an implicit cast.

Great catch!

> I don't know if it possible to run livepatch with
> CONFIG_CONTEXT_TRACKING disabled,

It should work with CONFIG_CONTEXT_TRACKING. The original code
migrates the task only when it is not running on any CPU and patched
functions are not on the stack. The stack check covers also
the user context.

> modified by patch 7 will always consider the transition complete even if
> the current task is in kernel mode. Also in the general case, the CPU
> will consider the task complete if has ctx_state CONTEXT_GUEST though the
> condition does not make it explicit.

Yup, we should avoid the enum -> bool cast, definitely.

Best Regards,
Petr
