Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650BD5200BD
	for <lists+live-patching@lfdr.de>; Mon,  9 May 2022 17:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237997AbiEIPLM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 May 2022 11:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238081AbiEIPLD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 May 2022 11:11:03 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D67289AE;
        Mon,  9 May 2022 08:07:06 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 9018F1F953;
        Mon,  9 May 2022 15:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652108825; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9gqDS5q/MKc74BdYPGpBWDc3d446H1BDCKvzO0bJI4k=;
        b=Qn6WT/0iH8XKFNs88aKfKy7QSFhbERAl+NzJ7IWEcySAlsNYgNV9xOzToGe6+sXxBkhI1h
        5FIDvWW5IFIcWCx5XKIpiQERUjAVdb5Pi9VB5aD7o0AZq/g5HAa9+7+ZZGkX075uuX14b4
        GqSMwQtg+RE8+GiNN1588iZmFUY6zIc=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 698B92C141;
        Mon,  9 May 2022 15:07:05 +0000 (UTC)
Date:   Mon, 9 May 2022 17:07:02 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com, kernel-team@fb.com
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Message-ID: <YnkuFrm1YR46OFx/@alley>
References: <20220507174628.2086373-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220507174628.2086373-1-song@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat 2022-05-07 10:46:28, Song Liu wrote:
> Busy kernel threads may block the transition of livepatch. Call
> klp_try_switch_task from __cond_resched to make the transition easier.

Do you have some numbers how this speeds up the transition
and how it slows down the scheduler, please?

cond_resched() is typically called in cycles with many interactions
where the task might spend a lot of time. There are two possibilities.
cond_resched() is called in:

   + livepatched function

     In this case, klp_try_switch_task(current) will always fail.
     And it will non-necessarily slow down every iteration by
     checking the very same stack.


   + non-livepatched function

     In this case, the transition will succeed on the first attempt.
     OK, but it would succeed also without that patch. The task would
     most likely sleep in this cond_resched() so that it might
     be successfully transitioned on the next occasion.


From my POV this patch this patch brings more harm than good.

Note that scheduling is a fast path. It is repeated zillion-times
on any system. But livepatch transition is a slow path. It does not
matter if it takes 1 second or 1 hour.

Best Regards,
Petr
