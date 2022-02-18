Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6FA64BB49F
	for <lists+live-patching@lfdr.de>; Fri, 18 Feb 2022 09:54:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbiBRIyq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 18 Feb 2022 03:54:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbiBRIyp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 18 Feb 2022 03:54:45 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EAC3585C;
        Fri, 18 Feb 2022 00:54:28 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0F0752110B;
        Fri, 18 Feb 2022 08:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645174467; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OJw/bIOB3GcVMcRFyUSJ/5yEeGaaB9j9QsVCODKATK0=;
        b=iLjczQHoU5aSLTK1yFu3WJ89XknoT+vbrLX1mXvrMjdQDDEHkMcG+SH68eHBdtvnK1mci7
        nrwI1wmaarhpoKaau1yw70HYGij5qPgS5FwCdBjuy3h73aimfnytO8aWdG3BDmizsSj/qO
        77l1xQuQwir0w/Q+lZcOYerhw9W1OaA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645174467;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OJw/bIOB3GcVMcRFyUSJ/5yEeGaaB9j9QsVCODKATK0=;
        b=CNWI6vwqT4Xb1Wv9yTJStMpSAZAELur7H+2WdJ0fMDgNfERqFfMByPFIbXybtL4u2kMjIO
        0YHj67rFrM/reWCQ==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D3808A3B81;
        Fri, 18 Feb 2022 08:54:26 +0000 (UTC)
Date:   Fri, 18 Feb 2022 09:54:26 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     David Vernet <void@manifault.com>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, pmladek@suse.com, jikos@kernel.org,
        joe.lawrence@redhat.com, corbet@lwn.net, kernel-team@fb.com
Subject: Re: [PATCH v3] livepatch: Skip livepatch tests if ftrace cannot be
 configured
In-Reply-To: <20220216161100.3243100-1-void@manifault.com>
Message-ID: <alpine.LSU.2.21.2202180954080.10602@pobox.suse.cz>
References: <20220216161100.3243100-1-void@manifault.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 16 Feb 2022, David Vernet wrote:

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

Acked-by: Miroslav Benes <mbenes@suse.cz>

M
