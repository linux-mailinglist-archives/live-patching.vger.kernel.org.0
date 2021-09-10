Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AFE406827
	for <lists+live-patching@lfdr.de>; Fri, 10 Sep 2021 10:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbhIJIKL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 10 Sep 2021 04:10:11 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:54960 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhIJIKL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 10 Sep 2021 04:10:11 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id AE3352004C;
        Fri, 10 Sep 2021 08:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1631261339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=s3YO21RL5B4bIYQW/pvfgxRmZIFg+04XQ1r4GlVCaHM=;
        b=Vl6K96n0ceSaujzU8wf4tTVN60AwLJpnN0TiIWN/T8wFljxQ7joXK3xmBEMhcqVn4oCZRk
        A910UPSOKm37b+4lgiTuGogoZesUuU+oqs9VIM43BKnlCfh7GB7/s4489jlyYsXxsjeaV+
        KdwcIe5LhPJL/2kVWxrGSbaPYYj+0gI=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 91147A3BA2;
        Fri, 10 Sep 2021 08:08:59 +0000 (UTC)
Date:   Fri, 10 Sep 2021 10:08:56 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Vasily Gorbik <gor@linux.ibm.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] livepatch: Kick idle cpu's tasks to perform
 transition
Message-ID: <YTsSmC3vGWa+kf5l@alley>
References: <patch.git-b76842ceb035.your-ad-here.call-01625661932-ext-1304@work.hours>
 <YSjgj+ZzOutFxevl@alley>
 <your-ad-here.call-01631177645-ext-9742@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <your-ad-here.call-01631177645-ext-9742@work.hours>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2021-09-09 10:54:05, Vasily Gorbik wrote:
> On Fri, Aug 27, 2021 at 02:54:39PM +0200, Petr Mladek wrote:
> > On Wed 2021-07-07 14:49:38, Vasily Gorbik wrote:
> > > --- a/kernel/livepatch/transition.c
> > > +++ b/kernel/livepatch/transition.c
> > > @@ -415,8 +415,11 @@ void klp_try_complete_transition(void)
> > >  	for_each_possible_cpu(cpu) {
> > >  		task = idle_task(cpu);
> > >  		if (cpu_online(cpu)) {
> > > -			if (!klp_try_switch_task(task))
> > > +			if (!klp_try_switch_task(task)) {
> > >  				complete = false;
> > > +				set_tsk_need_resched(task);
> > 
> > Is this really needed?
> 
> Yes, otherwise the inner idle loop is not left and
> klp_update_patch_state() is not reached. Only waking up idle
> cpus is not enough.

I see.

> > Also, please do this in klp_send_signals(). We kick there all other
> > tasks that block the transition for too long.
> 
> #define SIGNALS_TIMEOUT 15
> 
> Hm, kicking the idle threads in klp_send_signals() means extra 15 seconds
> delay for every transition in our case and failing kselftests:
>
> I understand this 15 seconds delay for loaded system and tasks doing real
> work is good,

Yup. Also normal processes should not stay in the running state
for this long. They are typically migrated quickly. But the idle task is
special.

> but those lazy idle "running" tasks could be kicked right
> away with no harm done, right?

Fair enough.

Best Regards,
Petr
