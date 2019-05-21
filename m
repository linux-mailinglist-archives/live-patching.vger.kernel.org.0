Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA41D251B2
	for <lists+live-patching@lfdr.de>; Tue, 21 May 2019 16:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfEUOQm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 May 2019 10:16:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726750AbfEUOQm (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 May 2019 10:16:42 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 12CA47FDEC;
        Tue, 21 May 2019 14:16:37 +0000 (UTC)
Received: from treble (ovpn-125-173.rdu2.redhat.com [10.10.125.173])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5774F17A73;
        Tue, 21 May 2019 14:16:31 +0000 (UTC)
Date:   Tue, 21 May 2019 09:16:29 -0500
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Johannes Erdfelt <johannes@erdfelt.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Oops caused by race between livepatch and ftrace
Message-ID: <20190521141629.bmk5onsaab26qoaw@treble>
References: <20190520194915.GB1646@sventech.com>
 <90f78070-95ec-ce49-1641-19d061abecf4@redhat.com>
 <20190520210905.GC1646@sventech.com>
 <20190520211931.vokbqxkx5kb6k2bz@treble>
 <20190520173910.6da9ddaf@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190520173910.6da9ddaf@gandalf.local.home>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 21 May 2019 14:16:42 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, May 20, 2019 at 05:39:10PM -0400, Steven Rostedt wrote:
> On Mon, 20 May 2019 16:19:31 -0500
> Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> 
> > diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> > index a12aff849c04..8259d4ba8b00 100644
> > --- a/kernel/trace/ftrace.c
> > +++ b/kernel/trace/ftrace.c
> > @@ -34,6 +34,7 @@
> >  #include <linux/hash.h>
> >  #include <linux/rcupdate.h>
> >  #include <linux/kprobes.h>
> > +#include <linux/memory.h>
> >  
> >  #include <trace/events/sched.h>
> >  
> > @@ -2610,10 +2611,12 @@ static void ftrace_run_update_code(int command)
> >  {
> >  	int ret;
> >  
> > +	mutex_lock(&text_mutex);
> > +
> 
> Hmm, this may blow up with lockdep, as I believe we already have a
> locking dependency of:
> 
>  text_mutex -> ftrace_lock
> 
> And this will reverses it. (kprobes appears to take the locks in this
> order).
> 
> Perhaps have live kernel patching grab ftrace_lock?

Where does kprobes call into ftrace with the text_mutex?  I couldn't
find it.

-- 
Josh
