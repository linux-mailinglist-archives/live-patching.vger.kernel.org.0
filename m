Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A500159FFC
	for <lists+live-patching@lfdr.de>; Fri, 28 Jun 2019 17:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfF1Pvy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 28 Jun 2019 11:51:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34648 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726741AbfF1Pvy (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 28 Jun 2019 11:51:54 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 484E33086204;
        Fri, 28 Jun 2019 15:51:38 +0000 (UTC)
Received: from treble (ovpn-126-66.rdu2.redhat.com [10.10.126.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0487660160;
        Fri, 28 Jun 2019 15:51:31 +0000 (UTC)
Date:   Fri, 28 Jun 2019 10:51:27 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Petr Mladek <pmladek@suse.com>, Miroslav Benes <mbenes@suse.cz>,
        Johannes Erdfelt <johannes@erdfelt.com>,
        Jessica Yu <jeyu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        mhiramat@kernel.org, Ingo Molnar <mingo@kernel.org>,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        Joe Lawrence <joe.lawrence@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: [PATCH] ftrace: Remove possible deadlock between
 register_kprobe() and ftrace_run_update_code()
Message-ID: <20190628155127.b4abyo2wmco6hb2n@treble>
References: <20190627081334.12793-1-pmladek@suse.com>
 <alpine.LSU.2.21.1906280928410.17146@pobox.suse.cz>
 <20190628105232.6arwis5u33li6twr@pathway.suse.cz>
 <20190628095424.1be42e21@gandalf.local.home>
 <20190628114627.411af7c2@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190628114627.411af7c2@gandalf.local.home>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 28 Jun 2019 15:51:54 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Jun 28, 2019 at 11:46:27AM -0400, Steven Rostedt wrote:
> On Fri, 28 Jun 2019 09:54:24 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Fri, 28 Jun 2019 12:52:32 +0200
> > Petr Mladek <pmladek@suse.com> wrote:
> > 
> > > On Fri 2019-06-28 09:32:03, Miroslav Benes wrote:  
> > > > On Thu, 27 Jun 2019, Petr Mladek wrote:    
> > > > > @@ -2611,12 +2610,10 @@ static void ftrace_run_update_code(int command)
> > > > >  {
> > > > >  	int ret;
> > > > >  
> > > > > -	mutex_lock(&text_mutex);
> > > > > -
> > > > >  	ret = ftrace_arch_code_modify_prepare();
> > > > >  	FTRACE_WARN_ON(ret);
> > > > >  	if (ret)
> > > > > -		goto out_unlock;
> > > > > +		return ret;    
> > > > 
> > > > Should be just "return;", because the function is "static void".    
> > > 
> > > Grr, I usually check compiler warnings but I evidently skipped it
> > > in this case :-(
> > > 
> > > Steven, should I send a fixed/folloup patch or will you just
> > > fix it when pushing?
> > >   
> > 
> > I'll fix it up.
> 
> Also note, this would have been caught with my test suite, as it checks
> for any new warnings.

Sadly, I noticed this while reviewing the code, but then somehow got
distracted and it vanished.  Another review fail...

-- 
Josh
