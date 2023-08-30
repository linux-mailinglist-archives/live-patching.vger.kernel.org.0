Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F023978D878
	for <lists+live-patching@lfdr.de>; Wed, 30 Aug 2023 20:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbjH3Sah (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 30 Aug 2023 14:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239978AbjH3Ghv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 30 Aug 2023 02:37:51 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F326122
        for <live-patching@vger.kernel.org>; Tue, 29 Aug 2023 23:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1693377466;
        bh=vRm+U0m7WUTiTK+V6GXUqnaveSMN3SbjFT0m0KXkE2A=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=L/3BFnHHBXlTUXyXo3M3BZs2XZWsABinbhUDMk+ZcKQnnO8F9o9OZ4YsUFVh/7BAl
         l9+iVEiOppz0K3uNJflKLZDNGa60oG7NaTxc5OFuzlt0edO83aIP0DZ9EBpMJgSiar
         zvObsOKVS9WtDHbntPvR1AjviBVPyJBZO4Ay296NYFrKLsUIuFmLTz3G0xA7gLXct2
         iIJb8/bgv7NfIVDwq5qK590LycaXz4lkRyVgulRCmP808vz5KQW9ZFBe7k02NxGaQ1
         FyS6bAaFRo6v/FfXZpce3XBS/CCCkIy+VW9m3MScKL6NvpmA/f8JO7Fn7OyAG17G/o
         oOZPN6IOGcMLQ==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4RbF3G65L3z4wy4;
        Wed, 30 Aug 2023 16:37:46 +1000 (AEST)
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Joe Lawrence <joe.lawrence@redhat.com>,
        linuxppc-dev@lists.ozlabs.org
Cc:     live-patching@vger.kernel.org,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Ryan Sullivan <rysulliv@redhat.com>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: Re: Recent Power changes and stack_trace_save_tsk_reliable?
In-Reply-To: <87o7ipxtdc.fsf@mail.lhotse>
References: <ZO4K6hflM/arMjse@redhat.com> <87o7ipxtdc.fsf@mail.lhotse>
Date:   Wed, 30 Aug 2023 16:37:44 +1000
Message-ID: <87il8xxcg7.fsf@mail.lhotse>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Michael Ellerman <mpe@ellerman.id.au> writes:
> Joe Lawrence <joe.lawrence@redhat.com> writes:
>> Hi ppc-dev list,
>>
>> We noticed that our kpatch integration tests started failing on ppc64le
>> when targeting the upstream v6.4 kernel, and then confirmed that the
>> in-tree livepatching kselftests similarly fail, too.  From the kselftest
>> results, it appears that livepatch transitions are no longer completing.
>
> Hi Joe,
>
> Thanks for the report.
>
> I thought I was running the livepatch tests, but looks like somewhere
> along the line my kernel .config lost CONFIG_TEST_LIVEPATCH=m, so I have
> been running the test but it just skips. :/
>
> I can reproduce the failure, and will see if I can bisect it more
> successfully.

It's caused by:

  eed7c420aac7 ("powerpc: copy_thread differentiate kthreads and user mode threads")

Which is obvious in hindsight :)

The diff below fixes it for me, can you test that on your setup?

A proper fix will need to be a bit bigger because the comments in there
are all slightly wrong now since the above commit.

Possibly we can also rework that code more substantially now that
copy_thread() is more careful about setting things up, but that would be
a follow-up.

diff --git a/arch/powerpc/kernel/stacktrace.c b/arch/powerpc/kernel/stacktrace.c
index 5de8597eaab8..d0b3509f13ee 100644
--- a/arch/powerpc/kernel/stacktrace.c
+++ b/arch/powerpc/kernel/stacktrace.c
@@ -73,7 +73,7 @@ int __no_sanitize_address arch_stack_walk_reliable(stack_trace_consume_fn consum
 	bool firstframe;
 
 	stack_end = stack_page + THREAD_SIZE;
-	if (!is_idle_task(task)) {
+	if (!(task->flags & PF_KTHREAD)) {
 		/*
 		 * For user tasks, this is the SP value loaded on
 		 * kernel entry, see "PACAKSAVE(r13)" in _switch() and


cheers
