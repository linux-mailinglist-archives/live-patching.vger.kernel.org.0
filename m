Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8DC51F54F
	for <lists+live-patching@lfdr.de>; Mon,  9 May 2022 09:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiEIH3y (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 May 2022 03:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235887AbiEIHJ6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 May 2022 03:09:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011E513D723;
        Mon,  9 May 2022 00:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IEBJMR9knINcGvQb0wARdyX8e/aHy299zvPAiP70voY=; b=NG5Rn2x5w0j1AiKj2swLASyaKD
        qwSADVMuzFYg3aamsse/IeeWzY7ksO0qv5vrv2Yq8yhxdCMCp9MTnAK84KZwXqcgjF63mPVoMqxgc
        UkURpVDkQgS3rCuDNQG1dejYtXlvFNzhAKVegQPqn7qB668T0Yyrb+yuV3090l9bw4SvxdsFNZpbT
        BF+LoVNRNYLUlsGC/o5Kvz8+/neVLAwv8Ala4DKkCYHWRBPov2yDGsBt4SmcgXl4Tp+H8X4tbSZoG
        4rpyWuBpA8MZloolgVoGB1x2uNElpfLvaZEmyAYTtcjKP1sS4GKFk5INg5O/8xakzwjTnPwSXn04M
        kTEPokAw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nnxRf-003DIj-NP; Mon, 09 May 2022 07:04:39 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 19958980E93; Mon,  9 May 2022 09:04:37 +0200 (CEST)
Date:   Mon, 9 May 2022 09:04:37 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <song@kernel.org>
Cc:     linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        mingo@redhat.com, vincent.guittot@linaro.org, jpoimboe@redhat.com,
        joe.lawrence@redhat.com, kernel-team@fb.com
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Message-ID: <20220509070437.GC76023@worktop.programming.kicks-ass.net>
References: <20220507174628.2086373-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220507174628.2086373-1-song@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat, May 07, 2022 at 10:46:28AM -0700, Song Liu wrote:
> Busy kernel threads may block the transition of livepatch. Call
> klp_try_switch_task from __cond_resched to make the transition easier.

What will a PREEMPT=y kernel do? How is it not a problem there, and if
it is, this will not help that.

That is; I don't think this can be right.
