Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 531F540691E
	for <lists+live-patching@lfdr.de>; Fri, 10 Sep 2021 11:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhIJJdb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 10 Sep 2021 05:33:31 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:40614 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbhIJJdb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 10 Sep 2021 05:33:31 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 5A41A2004D;
        Fri, 10 Sep 2021 09:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631266339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9iI6Wt8n6cT0+L9+pbZEEjlML5n5sKDS59UITJvFnag=;
        b=JkFpVAN5ovANPnAV4jiTcsRYWOZmTQTZAsOiVHy65+s4AJKWSrmZYhxR5rn410yB4HRIuY
        V2g+4+uCz46wPJLJ8Y2Es/ND3TcNoMNGvXME1OhzfMh4irPdW9qK3fV8mc+UFbAFab+pTX
        g+v6Te7mqhWFEUF2WDcVjH+7THZIEco=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631266339;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9iI6Wt8n6cT0+L9+pbZEEjlML5n5sKDS59UITJvFnag=;
        b=tUdlh5nWKaFu6yKj7wQaf+1/pZIWrfbR2c8RbSAqT07RklPVW8KH2B/kHLcgVH3TTKYWwF
        OgqJZ6yyFF6+hZDQ==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 32200A3B9E;
        Fri, 10 Sep 2021 09:32:19 +0000 (UTC)
Date:   Fri, 10 Sep 2021 11:32:19 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Vasily Gorbik <gor@linux.ibm.com>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] livepatch: Fix idle cpu's tasks transition
In-Reply-To: <patch.git-a4aad6b1540d.your-ad-here.call-01631177886-ext-3083@work.hours>
Message-ID: <alpine.LSU.2.21.2109101130560.19415@pobox.suse.cz>
References: <patch.git-a4aad6b1540d.your-ad-here.call-01631177886-ext-3083@work.hours>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 9 Sep 2021, Vasily Gorbik wrote:

> On an idle system with large amount of cpus it might happen that
> klp_update_patch_state() is not reached in do_idle() for a long periods
> of time. With debug messages enabled log is filled with:
> [  499.442643] livepatch: klp_try_switch_task: swapper/63:0 is running
> 
> without any signs of progress. Ending up with "failed to complete
> transition".
> 
> On s390 LPAR with 128 cpus not a single transition is able to complete
> and livepatch kselftests fail. Tests on idling x86 kvm instance with 128
> cpus demonstrate similar symptoms with and without CONFIG_NO_HZ.
> 
> To deal with that, since runqueue is already locked in
> klp_try_switch_task() identify idling cpus and trigger rescheduling
> potentially waking them up and making sure idle tasks break out of
> do_idle() inner loop and reach klp_update_patch_state(). This helps to
> speed up transition time while avoiding unnecessary extra system load.
> 
> Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>

Seems reasonable to me.

Acked-by: Miroslav Benes <mbenes@suse.cz>

M
