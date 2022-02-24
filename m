Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D3E4C277F
	for <lists+live-patching@lfdr.de>; Thu, 24 Feb 2022 10:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiBXJIj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 24 Feb 2022 04:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbiBXJIi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 24 Feb 2022 04:08:38 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8DB17E350;
        Thu, 24 Feb 2022 01:08:08 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 3CD9A1F39D;
        Thu, 24 Feb 2022 09:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1645693687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SOS58/Bk0jKt+GavRMbVhq34RQGZyQEnbVqDH0PQCGE=;
        b=ZsfDmmWGDWnxshaHwmwmEhWUX1QGdDuJiNaD2YQ/OFV33n6U2JmpLg5dRYmwsJ9kESmK+8
        Wo5dp0J8aD/XZvDrZYXZ7S58V7FkfrX8My0Qqwl7Vppn0K6YwNU3nJI1avf9pNEGV90Wgr
        yrHGX2DgwyafYkezoGxqX6Utxbg6mLY=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 20AD7A3BC5;
        Thu, 24 Feb 2022 09:08:07 +0000 (UTC)
Date:   Thu, 24 Feb 2022 10:08:06 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net, kernel-team@fb.com
Subject: Re: [PATCH v3] livepatch: Skip livepatch tests if ftrace cannot be
 configured
Message-ID: <YhdK9pjtyiKW8j3J@alley>
References: <20220216161100.3243100-1-void@manifault.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216161100.3243100-1-void@manifault.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-02-16 08:11:01, David Vernet wrote:
> livepatch has a set of selftests that are used to validate the behavior of
> the livepatching subsystem.  One of the testcases in the livepatch
> testsuite is test-ftrace.sh, which among other things, validates that
> livepatching gracefully fails when ftrace is disabled.  In the event that
> ftrace cannot be disabled using 'sysctl kernel.ftrace_enabled=0', the test
> will fail later due to it unexpectedly successfully loading the
> test_klp_livepatch module.
> 
> While the livepatch selftests are careful to remove any of the livepatch
> test modules between testcases to avoid this situation, ftrace may still
> fail to be disabled if another trace is active on the system that was
> enabled with FTRACE_OPS_FL_PERMANENT.  For example, any active BPF programs
> that use trampolines will cause this test to fail due to the trampoline
> being implemented with register_ftrace_direct().  The following is an
> example of such a trace:
> 
> tcp_drop (1) R I D      tramp: ftrace_regs_caller+0x0/0x58
> (call_direct_funcs+0x0/0x30)
>         direct-->bpf_trampoline_6442550536_0+0x0/0x1000
> 
> In order to make the test more resilient to system state that is out of its
> control, this patch updates set_ftrace_enabled() to detect sysctl failures,
> and skip the testrun when appropriate.
> 
> Suggested-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: David Vernet <void@manifault.com>

The patch has been committed into livepatch/livepatch.git,
branch for-5.18/selftests-fixes.

Best Regards,
Petr
