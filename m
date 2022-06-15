Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E592354C486
	for <lists+live-patching@lfdr.de>; Wed, 15 Jun 2022 11:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239736AbiFOJVk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Jun 2022 05:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244158AbiFOJVi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Jun 2022 05:21:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A1C369F1
        for <live-patching@vger.kernel.org>; Wed, 15 Jun 2022 02:21:38 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id B5C9F21A3A;
        Wed, 15 Jun 2022 09:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655284896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FLuwSBNAz0Z6aw/O6iwLJJOU5XSfoY8yR8VKE3sHA4M=;
        b=E8lsB6B2lyhQnAZmS/qNQeJxQwz2iTL9fTQrAm4wSCZa60N3/zQwilrhhIq5tRCwhMekJf
        1wpUyHdMvMAWeyng3w3GXzp//Yy0hmZot5XflX9MO0lBXl336Nzvh1YEXnI/01NNcYUTfS
        YUNENVPb3Co3L28mzBXPp8nPbKSwBs0=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8DE772C141;
        Wed, 15 Jun 2022 09:21:36 +0000 (UTC)
Date:   Wed, 15 Jun 2022 11:21:35 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Yannick Cote <ycote@redhat.com>
Subject: Re: [PATCH v2] selftests/livepatch: better synchronize
 test_klp_callbacks_busy
Message-ID: <Yqmkn+gdS0XdidlS@alley>
References: <20220602203233.979681-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602203233.979681-1-joe.lawrence@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-06-02 16:32:33, Joe Lawrence wrote:
> The test_klp_callbacks_busy module conditionally blocks a future
> livepatch transition by busy waiting inside its workqueue function,
> busymod_work_func().  After scheduling this work, a test livepatch is
> loaded, introducing the transition under test.
> 
> Both events are marked in the kernel log for later verification, but
> there is no synchronization to ensure that busymod_work_func() logs its
> function entry message before subsequent selftest commands log their own
> messages.  This can lead to a rare test failure due to unexpected
> ordering like:
> 
>   --- expected
>   +++ result
>   @@ -1,7 +1,7 @@
>    % modprobe test_klp_callbacks_busy block_transition=Y
>    test_klp_callbacks_busy: test_klp_callbacks_busy_init
>   -test_klp_callbacks_busy: busymod_work_func enter
>    % modprobe test_klp_callbacks_demo
>   +test_klp_callbacks_busy: busymod_work_func enter
>    livepatch: enabling patch 'test_klp_callbacks_demo'
>    livepatch: 'test_klp_callbacks_demo': initializing patching transition
>    test_klp_callbacks_demo: pre_patch_callback: vmlinux
> 
> Force the module init function to wait until busymod_work_func() has
> started (and logged its message), before exiting to the next selftest
> steps.
> 
> Fixes: 547840bd5ae5 ("selftests/livepatch: simplify test-klp-callbacks busy target tests")
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> Reviewed-by: Petr Mladek <pmladek@suse.com>

The patch has been committed into livepatching/livepatching.git,
branch for-5.20/selftests-fixes.

Best Regards,
Petr
