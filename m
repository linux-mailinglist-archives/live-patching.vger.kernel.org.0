Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C336D0AC3
	for <lists+live-patching@lfdr.de>; Thu, 30 Mar 2023 18:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjC3QLo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 30 Mar 2023 12:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjC3QLn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 30 Mar 2023 12:11:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BBE4EDB;
        Thu, 30 Mar 2023 09:11:14 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 9E2422184D;
        Thu, 30 Mar 2023 16:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1680192672; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b+9DVFdYT3Dn3D+NXxYza3T0qXNz8w53/vwp8HX6fMg=;
        b=B7zgWGt2zN1mzEhkbs4Ul1m9BgWC5hFUQB5DS8wUzwv76gpHJ2cACiO2YNe6URYw2DBw3N
        EpwJmnh0uXSwDLbHp27rK6dLISY0yTJL3NIYWYUvLZRZbDStF9IKdOHK7LXYD7sYUJe+3i
        1In9k8g5ygOn6gVIEGkJUAcedscPaAM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1680192672;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b+9DVFdYT3Dn3D+NXxYza3T0qXNz8w53/vwp8HX6fMg=;
        b=dPtqdhjZ0KYPGNw+a++Z/y4a/G70Pq0Ygyrt2H1H4volxnQdYSg46aepJUl0h66RE/YwL6
        rwD+Eqhik1t4bhBg==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7C6AD2C141;
        Thu, 30 Mar 2023 16:11:09 +0000 (UTC)
Date:   Thu, 30 Mar 2023 18:11:09 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v3 0/3] livepatch,sched: Add livepatch task switching to
 cond_resched()
In-Reply-To: <cover.1677257135.git.jpoimboe@kernel.org>
Message-ID: <alpine.LSU.2.21.2303301810250.24187@pobox.suse.cz>
References: <cover.1677257135.git.jpoimboe@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 24 Feb 2023, Josh Poimboeuf wrote:

> v3:
> - Add barriers (pmladek)
> - Update comments
> 
> v2:
> - Avoid calling klp_cond_resched_disable() in klp_cancel_transition()
> - Fix race in klp_reverse_transition()
> 
> Fix patching stalls caused by busy kthreads.
> 
> Josh Poimboeuf (3):
>   livepatch: Skip task_call_func() for current task
>   livepatch,sched: Add livepatch task switching to cond_resched()
>   vhost: Fix livepatch timeouts in vhost_worker()
> 
>  drivers/vhost/vhost.c           |   3 +-
>  include/linux/livepatch.h       |   1 +
>  include/linux/livepatch_sched.h |  29 ++++++++
>  include/linux/sched.h           |  20 ++++--
>  kernel/livepatch/core.c         |   1 +
>  kernel/livepatch/transition.c   | 113 +++++++++++++++++++++++++++-----
>  kernel/sched/core.c             |  64 +++++++++++++++---
>  7 files changed, 200 insertions(+), 31 deletions(-)
>  create mode 100644 include/linux/livepatch_sched.h

Late, so just recording it here...

Acked-by: Miroslav Benes <mbenes@suse.cz>

Thanks for improving the situation, Josh.

M
