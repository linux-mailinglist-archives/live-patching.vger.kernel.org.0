Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91586A5D52
	for <lists+live-patching@lfdr.de>; Tue, 28 Feb 2023 17:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjB1QlL (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 28 Feb 2023 11:41:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjB1QlK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 28 Feb 2023 11:41:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FEA1990;
        Tue, 28 Feb 2023 08:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FA37B80E6C;
        Tue, 28 Feb 2023 16:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D199C433EF;
        Tue, 28 Feb 2023 16:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677602366;
        bh=Z/wlXNN+9C39GLaI00j4vAZ6OYcLB35Inti3PgyXhag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YMP4rTPnWopF+ASWEAdgZRNB9hvqM/g8d9o2gN/HZ7R38NOZMb3jolHwFyhrGAAqQ
         /99+bgDA+Tw/Hd6kdyqrjtvbYyWqXNHmm9AQdISkpk/7fjXlShp1+6gFCuG8pG3riC
         WCPHb6OYu2SmbIpa+PLQoIGOgPaicQOvS4ECczFG38vESN3ZnwjYOErjxMWx7VLX8h
         ildw0ui33wenbbLsT5J41ym5qd21rGg1ABjCkihdpp3tnYqSL2M/IpAz6CzQ9tnjmn
         yO/vqvrqfLl025AvIVWVTAM8Zh+EbYZvNN1MtxgiQ9/eUF0fGmRNpxuQuQnr+ecWbI
         CQbgX0ShkE82A==
Date:   Tue, 28 Feb 2023 10:39:24 -0600
From:   Seth Forshee <sforshee@kernel.org>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v3 0/3] livepatch,sched: Add livepatch task switching to
 cond_resched()
Message-ID: <Y/4uPLqwColTQ859@do-x1extreme>
References: <cover.1677257135.git.jpoimboe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1677257135.git.jpoimboe@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Feb 24, 2023 at 08:49:58AM -0800, Josh Poimboeuf wrote:
> v3:
> - Add barriers (pmladek)
> - Update comments
> 
> v2:
> - Avoid calling klp_cond_resched_disable() in klp_cancel_transition()
> - Fix race in klp_reverse_transition()
> 
> Fix patching stalls caused by busy kthreads.

I ran the v3 patches through my reproducer, still working great.

Thanks,
Seth
