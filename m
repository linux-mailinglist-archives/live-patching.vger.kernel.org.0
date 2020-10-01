Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661C6280190
	for <lists+live-patching@lfdr.de>; Thu,  1 Oct 2020 16:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732207AbgJAOq2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Oct 2020 10:46:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:42740 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732020AbgJAOq2 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Oct 2020 10:46:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601563586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wMUjizX9UbGmkXAcw083UhorT2AvvT5lsb8qLN7jOLA=;
        b=JoWeAKr6mtRIvVhZz4Aeg2KnML3BKtho4VLz7L6s55/fLvhb7e6UTBnXFApYVuZZpBOZSz
        NuE5/hsUVLVj8Zf24XSAd+W3255KDavArn6ThUWWVL6Nys8DKfmtkzxdsOyOh7ZNU322Kv
        c9h5IYLBJj4ETQ6E8CpwfUbneYcRWsg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A5ED5AD03;
        Thu,  1 Oct 2020 14:46:26 +0000 (UTC)
Date:   Thu, 1 Oct 2020 16:46:26 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        live-patching@vger.kernel.org, nstange@suse.de
Subject: Re: Patching kthread functions
Message-ID: <20201001144625.GE17717@alley>
References: <9c9e5b82-660e-a666-b55c-a357dd7482cb@virtuozzo.com>
 <alpine.LSU.2.21.2010011300450.6689@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2010011300450.6689@pobox.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2020-10-01 13:13:07, Miroslav Benes wrote:
> On Wed, 30 Sep 2020, Evgenii Shatokhin wrote:
> 
> > Hi,
> > 
> > I wonder, can livepatch from the current mainline kernel patch the main
> > functions of kthreads, which are running or sleeping constantly? Are there any
> > best practices here?
> 
> No. It is a "known" limitation, "" because we discussed it a couple of 
> times (at least with Petr), but it is not documented :(
> 
> I wonder if it is really an issue practically. I haven't met a case 
> yet when we wanted to patch such thing. But yes, you're correct, it is not 
> possible.
>  
> > I mean, suppose we have a function which runs in a kthread (passed to
> > kthread_create()) and is organized like this:
> > 
> > while (!kthread_should_stop()) {
> >   ...
> >   DEFINE_WAIT(_wait);
> >   for (;;) {
> >     prepare_to_wait(waitq, &_wait, TASK_INTERRUPTIBLE);
> >     if (we_have_requests_to_process || kthread_should_stop())
> >       break;
> >     schedule();
> >   }
> >   finish_wait(waitq, &_wait);
> >   ...
> >   if (we_have_requests_to_process)
> >     process_one_request();
> >   ...
> > }

Crazy hack would be to patch only process_one_request() the following way:

1. Put the fixed main loop into the new process_one_request() function.

2. Put the original process_one_request() code into another function,
   e.g. do_process_one_request_for_real() and call it from the
   fixed loop.

Does it make any sense or should I provide some code?

Be aware that such patch could not get reverted because it would never
leave the new main loop.

Best Regards,
Petr
