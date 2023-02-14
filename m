Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D38696D8F
	for <lists+live-patching@lfdr.de>; Tue, 14 Feb 2023 20:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjBNTFr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 14 Feb 2023 14:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBNTFq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 14 Feb 2023 14:05:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F977AF;
        Tue, 14 Feb 2023 11:05:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B2BFBCE21FC;
        Tue, 14 Feb 2023 19:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71630C433D2;
        Tue, 14 Feb 2023 19:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676401541;
        bh=6CvhNlhlczrt07CSDD97YV9/+SY/oi147S3AKQHXDB4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Z5XTXQWOjJ0n8gkG/RnphlIvcBWRnBHurpzJ3H0j02CxUUjGq8q+aDDQCWNPpBA3F
         pqBAB7NqKRSDG55F0+bZIxue6tcvAwziZprRtFfP33Pyvj7nVZzfjYNsVITRQ3CMsE
         lT7J0dmGxau7CoVoxkwuV3UopTTWV8MXgNfZudvSUY1zHr9eoN5JMXWDqEuBkIcQTx
         7Gj3iuf78zIZ8uNhGgGV9K4tdG881Y+PP8Q5q6OM8Bh1wBBNEBNMXaFqjdC/Kl3S0A
         3V+7DHzaM7hZc2lpPlk0JhqfuVb947Jcn8R9LQiJC3U0raD6T9bgOWr/qClobOQTyA
         QMX7FUVWSdYLg==
Date:   Tue, 14 Feb 2023 11:05:39 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <sforshee@digitalocean.com>,
        Song Liu <song@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Jiri Kosina <jikos@kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 0/3] livepatch,sched: Add livepatch task switching to
 cond_resched()
Message-ID: <20230214190539.6xw3djyma3zaw2ps@treble>
References: <cover.1675969869.git.jpoimboe@kernel.org>
 <Y+t5tmbmKaUwNzdJ@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y+t5tmbmKaUwNzdJ@hirez.programming.kicks-ass.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Feb 14, 2023 at 01:08:22PM +0100, Peter Zijlstra wrote:
> On Thu, Feb 09, 2023 at 11:17:46AM -0800, Josh Poimboeuf wrote:
> > Fix patching stalls caused by busy kthreads.
> > 
> > Josh Poimboeuf (3):
> >   livepatch: Skip task_call_func() for current task
> >   livepatch,sched: Add livepatch task switching to cond_resched()
> >   vhost: Fix livepatch timeouts in vhost_worker()
> 
> Seems reasonable, you want me to take them through the sched tree?

That would be great, though first I'd like to get an ack from at least
another livepatch maintainer.

-- 
Josh
