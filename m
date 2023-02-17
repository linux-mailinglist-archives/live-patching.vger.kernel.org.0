Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E5B69A7ED
	for <lists+live-patching@lfdr.de>; Fri, 17 Feb 2023 10:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjBQJOi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Feb 2023 04:14:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBQJOh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Feb 2023 04:14:37 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE5F5D3D9;
        Fri, 17 Feb 2023 01:14:36 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id C12B91F461;
        Fri, 17 Feb 2023 09:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676625274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KVQ94b5ESVyoMDh0ZQVNKdPvYG9mBzXtxdNNwIj+DBQ=;
        b=DLdbY0+h7AnSrcZcKD4cQQNl3G1JEK8FexGZZGSyE87yxiGdZxb+q5arrLs6nZaXzZr0Wb
        TPlpqguyqZcZTjMoVtffqis1K0nFM2J0midwnT+7Q26ddE1bdG/50laEoCeoqMaqz49hgv
        ZQVb69N9gVkKv7ryzlfIGKRfG5mJ2GQ=
Received: from suse.cz (unknown [10.163.25.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 575312C142;
        Fri, 17 Feb 2023 09:14:34 +0000 (UTC)
Date:   Fri, 17 Feb 2023 10:14:33 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@digitalocean.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 2/3] livepatch,sched: Add livepatch task switching to
 cond_resched()
Message-ID: <Y+9Fea1svbbbkZ3k@alley>
References: <cover.1675969869.git.jpoimboe@kernel.org>
 <58cd637f7557e829142a2eb255daa91fa57e6321.1675969869.git.jpoimboe@kernel.org>
 <Y+zefMw6wqaXHZSz@alley>
 <20230216022630.h6mfl5cdqt5vbjno@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230216022630.h6mfl5cdqt5vbjno@treble>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2023-02-15 18:26:30, Josh Poimboeuf wrote:
> On Wed, Feb 15, 2023 at 02:30:36PM +0100, Petr Mladek wrote:
> > >  static inline int _cond_resched(void)
> > >  {
> > > +	klp_sched_try_switch();
> > >  	return __cond_resched();
> > 
> > My only concern is if it might cause any performance problems.
> > 
> > On one hand, cond_resched() is used in code paths that are slow
> > on its own. Also it will do nothing most of the time.
> > 
> > On the other hand, cond_resched() is typically used in cycles.
> > One cycle might be fast. The code might be slow because there
> > are too many cycles. Repeating the same failing test might
> > prolong the time significantly.
> 
> Yes, but it should hopefully be very rare to patch a function in the
> call stack of a kthread loop.  In general it's a good idea for the patch
> author to avoid that.

I do not have any data about it.

> > An idea is to try the switch only when it was not done during
> > a real schedule. Something like:
> > 
> > static inline int _cond_resched(void)
> > {
> > 	int scheduled;
> > 
> > 	scheduled = __cond_resched();
> > 	if (scheduled)
> > 		klp_sched_try_switch();
> > 
> > 	return scheduled();
> > }
> > 
> > But it would make it less reliable/predictable. Also it won't work
> > in configurations when cond_resched() is always a nop.
> > 
> > I am probably too careful. We might keep it simple until any real
> > life problems are reported.
> 
> If we can get away with it, I much prefer the simple unconditional
> klp_sched_try_switch() because of the predictability and quickness with
> which the kthread gets patched.

I am fine with keeping it simple now. We could always change it when
it causes problems.

I primary wanted to point out the potential problem and check what
others think about it.

Best Regards,
Petr
