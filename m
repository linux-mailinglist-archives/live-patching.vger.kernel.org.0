Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11DB3C1585
	for <lists+live-patching@lfdr.de>; Thu,  8 Jul 2021 16:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231792AbhGHO7r (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Jul 2021 10:59:47 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:35670 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbhGHO7q (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Jul 2021 10:59:46 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id BFF27201EA;
        Thu,  8 Jul 2021 14:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625756223; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d+w+ftWQRSGcaS7USD2rNrsIWh5yIVNwfoY5jSFqupE=;
        b=J876vjgxxb1UxT9ci9UL8oQtz1KU3XMqZRhRpNDfal/B+eVett1CrKyXY/FAzPlmWTJMUa
        h4sYgc/pIOrZ4xKz3MtFMRsjzDMBzKeUFv9P2hXSf+5Yu/uD1A4YDQMXWGK22IlYO+jaeT
        RZgeXLhXXzQOVXve2CpC3EVHD63i7V0=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A5098A3B87;
        Thu,  8 Jul 2021 14:57:03 +0000 (UTC)
Date:   Thu, 8 Jul 2021 16:57:03 +0200
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
Subject: Re: [RFC PATCH] livepatch: Speed up transition retries
Message-ID: <YOcSP7LZPtF5p6XT@alley>
References: <patch.git-3127eb42c636.your-ad-here.call-01625661963-ext-4010@work.hours>
 <YObU7HQ1vUAQzME3@alley>
 <your-ad-here.call-01625750365-ext-6037@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <your-ad-here.call-01625750365-ext-6037@work.hours>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2021-07-08 15:19:25, Vasily Gorbik wrote:
> On Thu, Jul 08, 2021 at 12:35:24PM +0200, Petr Mladek wrote:
> > On Wed 2021-07-07 14:49:41, Vasily Gorbik wrote:
> > > That's just a racy hack for now for demonstration purposes.
> > > 
> > > For s390 LPAR with 128 cpu this reduces livepatch kselftest run time
> > > from
> > > real    1m11.837s
> > > user    0m0.603s
> > > sys     0m10.940s
> > > 
> > > to
> > > real    0m14.550s
> > > user    0m0.420s
> > > sys     0m5.779s
> > > 
> > > Would smth like that be useful for production use cases?
> > > Any ideas how to approach that more gracefully?
> > 
> > Honestly, I do not see a real life use case for this, except maybe
> > speeding up a test suite.
> > 
> > The livepatch transition is more about reliability than about speed.
> > In the real life, a livepatch will be applied only once in a while.
> 
> That's what I thought. Thanks for looking. Dropping this one.

If you still wanted to speed up the transition from some reason
then an easy win might be to call klp_send_signals() earlier.

Well, my view is the following. The primary livepatching task is
to fix some broken/vulnerable functionality on a running kernel.
It should ideally happen on background and do not affect or slow
down the existing work load.

klp_send_signals() is not ideal. The fake signal interrupts syscalls
and they need to get restarted. Also the function wakes up a lot of
tasks and might increase load. Hence, it is used as a last resort that
allows to finish the transition in a reasonable time frame.

That said, the current timeouts are arbitrary chosen values based
rather on a common sense than on some measurement. I could imagine that
we could modify them or allow to trigger klp_send_signal() via
sysfs when there is a good reason.

Best Regards,
Petr
