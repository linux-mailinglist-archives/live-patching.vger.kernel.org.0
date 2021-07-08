Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0B43BF87D
	for <lists+live-patching@lfdr.de>; Thu,  8 Jul 2021 12:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhGHKiH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 8 Jul 2021 06:38:07 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:47804 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231332AbhGHKiH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 8 Jul 2021 06:38:07 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C73CF22064;
        Thu,  8 Jul 2021 10:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625740524; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ojxcqkk0kVLlNu7Ta3F99gByfDZzDKUG/V8xaV9TP94=;
        b=H2hzpj0qV36mzJGSsQkGxWTXFCEpTAaz61yprS1BXS5QamKRHLD8Oao0b3MGvTsN9Q0IHu
        IeadmiH9IZk/Nn5Ggrzohd0uJUxVbgvdBixnRFhmygHeHWBAwwKIHZxbuSPVl/GeKZa624
        hYnPD0YT5YyewNLsorY/UMpYiDJewkg=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AC6A4A3B84;
        Thu,  8 Jul 2021 10:35:24 +0000 (UTC)
Date:   Thu, 8 Jul 2021 12:35:24 +0200
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
Message-ID: <YObU7HQ1vUAQzME3@alley>
References: <patch.git-3127eb42c636.your-ad-here.call-01625661963-ext-4010@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <patch.git-3127eb42c636.your-ad-here.call-01625661963-ext-4010@work.hours>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-07-07 14:49:41, Vasily Gorbik wrote:
> That's just a racy hack for now for demonstration purposes.
> 
> On a s390 system with large amount of cpus
> klp_try_complete_transition() often cannot be "complete" from the first
> attempt. klp_try_complete_transition() schedules itself as delayed work
> after a second delay. This accumulates to significant amount of time when
> there are large number of livepatching transitions.
> 
> This patch tries to minimize this delay to counting processes which still
> need to be transitioned and then scheduling
> klp_try_complete_transition() right away.
> 
> For s390 LPAR with 128 cpu this reduces livepatch kselftest run time
> from
> real    1m11.837s
> user    0m0.603s
> sys     0m10.940s
> 
> to
> real    0m14.550s
> user    0m0.420s
> sys     0m5.779s
> 
> And qa_test_klp run time from
> real    5m15.950s
> user    0m34.447s
> sys     15m11.345s
> 
> to
> real    3m51.987s
> user    0m27.074s
> sys     9m37.301s
> 
> Would smth like that be useful for production use cases?
> Any ideas how to approach that more gracefully?

Honestly, I do not see a real life use case for this, except maybe
speeding up a test suite.

The livepatch transition is more about reliability than about speed.
In the real life, a livepatch will be applied only once in a while.

We have spent weeks thinking about and discussing the consistency
model, code, and barriers to handle races correctly. Especially,
klp_update_patch_state() is a super-sensitive beast because it is
called without klp_lock. It might be pretty hard to synchronize
it with klp_reverse_transition() or klp_force_transition().

You would need to come up with a really convincing use case and
numbers to make it worth the effort.

Best Regards,
Petr

