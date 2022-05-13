Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DE6526317
	for <lists+live-patching@lfdr.de>; Fri, 13 May 2022 15:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbiEMNt7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 May 2022 09:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381294AbiEMNe2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 May 2022 09:34:28 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BA310F0;
        Fri, 13 May 2022 06:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/2J4OgJGpc1Cb3jgc4qYyZLCbL55xwunzKlfyYoeZdw=; b=H5fwWH/CF298SAz3ALbH2c5z7A
        ciR7XVfqLP2R9vBz+MM7Tt7mIzVpVGIazQK/SwfeM03Y1CMw+rot1fB6EqfwRCpmMCQQ3db4Og1wr
        +oAMRjAqnC6qW6GJxg8gPUVzb1RuKngei/SmD1m8Rqcjv8kfpENiIDCoVIBAdx73tJrXHSNVzGJYe
        LjhjRPpxho7i5tuSUy8poYWdnn32VWijCYNYgtnFyJq/MkMMEIGFvfKSEH/F67s/49q5/+1VpduK1
        SZhzVCB6wwKCqQzkqPS90HVCD6vA9M4EWHmUrceGEpByaycBWTM6Ct1rX8qPS6FNZTawPPDcnVbGK
        ZVKrN0DA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1npVQo-00Do81-V4; Fri, 13 May 2022 13:34:11 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id B3984981018; Fri, 13 May 2022 15:34:08 +0200 (CEST)
Date:   Fri, 13 May 2022 15:34:08 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Song Liu <songliubraving@fb.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Rik van Riel <riel@fb.com>,
        "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Message-ID: <20220513133408.GI76023@worktop.programming.kicks-ass.net>
References: <20220510165244.ikfh64ertnvodxb4@treble>
 <1bd15361edfd4db9fc9271d35e7bbe5edad1b87a.camel@fb.com>
 <20220510184213.l3gjweeleyg7obca@treble>
 <47440502-930F-4CBD-B859-3AC9BBFF8FC6@fb.com>
 <20220510230402.e5ymkwt45sg7bd35@treble>
 <D298A3F1-43A5-4FD5-B198-906364BF4B79@fb.com>
 <20220511003331.clfvwfgpmbr5yx6n@treble>
 <20220511092433.GA26047@pathway.suse.cz>
 <78DFED12-571B-489C-A662-DA333555266B@fb.com>
 <Yn5QHpc9YlAbP1li@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yn5QHpc9YlAbP1li@alley>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, May 13, 2022 at 02:33:34PM +0200, Petr Mladek wrote:

> My concern is that klp_try_complete_transition() checks all processes
> under read_lock(&tasklist_lock). It might create some contention
> on this lock. I am not sure if this lock is fair. It might slow down
> block writers (creating/deleting tasks).

rwlock_t is sorta fair. Is it fair for process contect usage, but
in-interrupt use will have a reader bias.

That said; contention on tasklist_lock is a real scalability concern.

Can't you use RCU here? With RCU traversal of the tasklist you can miss
new entry (which should already run the new code) or miss exits (which
will stop running code).
