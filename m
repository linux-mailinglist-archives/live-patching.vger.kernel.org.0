Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA066A468C
	for <lists+live-patching@lfdr.de>; Mon, 27 Feb 2023 16:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjB0Pz4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 27 Feb 2023 10:55:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjB0Pzz (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 27 Feb 2023 10:55:55 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C3BA2055E;
        Mon, 27 Feb 2023 07:55:54 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0C2BC219F8;
        Mon, 27 Feb 2023 15:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677513353; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wVy7ke8DgpnyB5MxY0IlbIClb/jueZuR98GJS5xVQ1E=;
        b=Nwlqr5Q1pDVSBbv1HNTGP+oLbGv8SgcvFTCc7whqb11+UeaOQQI2tOnEB9OGGrCGfyB13K
        1U2XLoxZjRx1lONfCVkMMDtteJm8MuLMCeyMJ03MTTPK8C9YI0zWmxyKkJp8OTcZzuE4o5
        7gjZCcAVp/LZ4+M6TzDF1M/Ci+QO0cs=
Received: from suse.cz (pmladek.tcp.ovpn1.nue.suse.de [10.163.16.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A43B32C141;
        Mon, 27 Feb 2023 15:55:51 +0000 (UTC)
Date:   Mon, 27 Feb 2023 16:55:47 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
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
Message-ID: <Y/zSgw5LOpbp7e/A@alley>
References: <cover.1677257135.git.jpoimboe@kernel.org>
 <4ae981466b7814ec221014fc2554b2f86f3fb70b.1677257135.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ae981466b7814ec221014fc2554b2f86f3fb70b.1677257135.git.jpoimboe@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2023-02-24 08:50:00, Josh Poimboeuf wrote:
> There have been reports [1][2] of live patches failing to complete
> within a reasonable amount of time due to CPU-bound kthreads.
> 
> Fix it by patching tasks in cond_resched().
> 
> There are four different flavors of cond_resched(), depending on the
> kernel configuration.  Hook into all of them.
> 
> A more elegant solution might be to use a preempt notifier.  However,
> non-ORC unwinders can't unwind a preempted task reliably.
> 
> [1] https://lore.kernel.org/lkml/20220507174628.2086373-1-song@kernel.org/
> [2] https://lkml.kernel.org/lkml/20230120-vhost-klp-switching-v1-0-7c2b65519c43@kernel.org
> 
> Tested-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Just for record, I have double checked the changes against v2
and everything looks good to me.

Best Regards,
Petr
