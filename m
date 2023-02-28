Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB636A5DC8
	for <lists+live-patching@lfdr.de>; Tue, 28 Feb 2023 17:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjB1Q45 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Feb 2023 11:56:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjB1Q4w (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Feb 2023 11:56:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF1C34C34;
        Tue, 28 Feb 2023 08:56:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7BCA6115E;
        Tue, 28 Feb 2023 16:56:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9FA5C4339B;
        Tue, 28 Feb 2023 16:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677603370;
        bh=xiZq7iewVf3UXNS6XCUHwQP0qyPR2dZE/YN+i//wffw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b+9pdoUft7k5rlUdwwAufxA0NQ+AWGxY4ovmg0iMvrWK0iyOdlxX+uZe98HDqEabz
         D08Vbyu6wOMoR4mTBx2zocj7bKy6wou3xN/Zlm3+LfO+1qRtxxdOPR4QTZYHi5VPw5
         +gIDs7hfVhxpnmsCgh8zcJ73f3uem7dkWYf0yu+kFeAW4Qm46m3HDW5r2yBYEgBn5g
         zAVV9laYqTWABYoABreMb08aQXsp5tMvbcCBP9ugOFad+ztCVGHpp3GTW7CSBPp886
         1Dnh6/lojvXT9K0MHuyVxyZ2oZVUJe4/d4+GciZmhB1jXR1SLRcL2BEO68BGLhDJxS
         JkElb3pTnBoZA==
Date:   Tue, 28 Feb 2023 08:56:08 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v3 2/3] livepatch,sched: Add livepatch task switching to
 cond_resched()
Message-ID: <20230228165608.kumgxziaietsjaz3@treble>
References: <cover.1677257135.git.jpoimboe@kernel.org>
 <4ae981466b7814ec221014fc2554b2f86f3fb70b.1677257135.git.jpoimboe@kernel.org>
 <Y/zSgw5LOpbp7e/A@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/zSgw5LOpbp7e/A@alley>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Feb 27, 2023 at 04:55:47PM +0100, Petr Mladek wrote:
> On Fri 2023-02-24 08:50:00, Josh Poimboeuf wrote:
> > There have been reports [1][2] of live patches failing to complete
> > within a reasonable amount of time due to CPU-bound kthreads.
> > 
> > Fix it by patching tasks in cond_resched().
> > 
> > There are four different flavors of cond_resched(), depending on the
> > kernel configuration.  Hook into all of them.
> > 
> > A more elegant solution might be to use a preempt notifier.  However,
> > non-ORC unwinders can't unwind a preempted task reliably.
> > 
> > [1] https://lore.kernel.org/lkml/20220507174628.2086373-1-song@kernel.org/
> > [2] https://lkml.kernel.org/lkml/20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org
> > 
> > Tested-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
> > Reviewed-by: Petr Mladek <pmladek@suse.com>
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> 
> Just for record, I have double checked the changes against v2
> and everything looks good to me.

Whoops, so I found another little surprise:

static int klp_check_stack(struct task_struct *task, const char **oldname)
{
        static unsigned long entries[MAX_STACK_ENTRIES];
	^^^^^^

That entries array is shared between the klp_mutex owner and all
cond_resched() callers.

MAX_STACK_ENTRIES is 100, which seems excessive.  If we halved that, the
array would be "only" 400 bytes, which is *almost* reasonable to
allocate on the stack?

Alternatively we could have a percpu entries array... :-/

-- 
Josh
