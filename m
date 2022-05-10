Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414EE521105
	for <lists+live-patching@lfdr.de>; Tue, 10 May 2022 11:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238928AbiEJJj0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 05:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238978AbiEJJjZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 05:39:25 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B9B28FEAE;
        Tue, 10 May 2022 02:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=kI3usnv3cvSu4CK/ziEmj9I3Q9wcT4zQJngj+G2T8jc=; b=O9nROi0WT4KAsJcqjNTCmI5mNa
        SrMqjABCnuLu9GkShkbEoD2JqLJCcIKwNJ1yRqFQjFpTeKA5GAg93l9k1E7RFM2id432ABdGThpc+
        ZhWI6utuGdVTRxLJvvXGU/nI6EUdaVGSttg/tAawdiaO3XWZxXBcsKpuAyncfs6GElHSZHqTsFvlP
        tku4WPChkK8OWTYEnU9qKUhdn1x49U3EW60E6lX00RcVET8a6o9d+V9CyB7+4NCCPuuZMXyF6NOzu
        pGkA4e6oUpaTiaWO58lteasuiJA5TB5/Ux4f250U9EJgEPsmmdgDlmekkIo5YTUGXykim9kvnryA8
        bsjD5Y1g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noMGs-00Co3Q-WF; Tue, 10 May 2022 09:35:11 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id B7596981011; Tue, 10 May 2022 11:35:08 +0200 (CEST)
Date:   Tue, 10 May 2022 11:35:08 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Rik van Riel <riel@surriel.com>, Song Liu <song@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [RFC] sched,livepatch: call stop_one_cpu in
 klp_check_and_switch_task
Message-ID: <20220510093508.GL76023@worktop.programming.kicks-ass.net>
References: <20220507174628.2086373-1-song@kernel.org>
 <20220509115227.6075105e@imladris.surriel.com>
 <20220509180004.zmvhz65xlncwqrrc@treble>
 <68f91fb233d5bf82e29cc5c6960a62863b297db3.camel@surriel.com>
 <20220509191745.yk2txsa4cv3ypf6k@treble>
 <1f94c48b4e0e7d73a689a076f78f0892095b4d89.camel@surriel.com>
 <20220509200949.vzx4g5xpebomkok4@treble>
 <AD44A5E5-24BA-481A-AF32-4704A3207245@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AD44A5E5-24BA-481A-AF32-4704A3207245@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 10, 2022 at 12:32:02AM +0000, Song Liu wrote:
> cond_sched() feels like a natural “transition point” to me, and it 

You have to think of cond_resched() as a NOP.

