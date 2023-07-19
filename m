Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7CD875A00C
	for <lists+live-patching@lfdr.de>; Wed, 19 Jul 2023 22:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjGSUl3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 19 Jul 2023 16:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjGSUl2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 19 Jul 2023 16:41:28 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C89939E;
        Wed, 19 Jul 2023 13:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=IFLRLR+CVd0fGygK9/y3WQh0FdrsOl8uBfwPnqmJWno=; b=Qa8T1TOjmaokc5Ti9VatGeWZVu
        D1od/kVme2vcCXmS3L2sgzVgLtnbaTtd5nJvsCwrKCcdiykLyH+HLBW5tFwk5PM/I5Op449zxQILc
        rd7QxgqjFIwweE7IOLZBjYjxfRRzfL2tntWAnqwUR0R63T2VtbguoJFevcfdFyXM7xEF1+VrffetX
        QYOcTu8YtuqoF/GaBWM1JfAbXZLtWCLGimCmppvKdxGxncNS0vHntiV/waVI/j7A7HxU/5HzWhUz1
        lPxkULin9nY0VxMXgR+j9Wi7Xr5INgdsEyO1icMmA7qwelKBxsMtH51i3rK/2VHFQ77h+Rj601Id6
        F6TuVmpg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qMDz3-006S74-16; Wed, 19 Jul 2023 20:41:17 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 8F02530036B;
        Wed, 19 Jul 2023 22:41:16 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 7947926AA535D; Wed, 19 Jul 2023 22:41:16 +0200 (CEST)
Date:   Wed, 19 Jul 2023 22:41:16 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>, Brian Gerst <brgerst@gmail.com>,
        jpoimboe@kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        alyssa.milburn@linux.intel.com, keescook@chromium.org,
        joao@overdrivepizza.com, tim.c.chen@linux.intel.com,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v2 2/2] x86: Rewrite ret_from_fork() in C
Message-ID: <20230719204116.GF3529734@hirez.programming.kicks-ass.net>
References: <20230623225529.34590-1-brgerst@gmail.com>
 <20230623225529.34590-3-brgerst@gmail.com>
 <ZLf_Z5dCSm7zKDel@alley>
 <b6941f79-5c9e-7c22-bee1-a00d32bea009@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6941f79-5c9e-7c22-bee1-a00d32bea009@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 19, 2023 at 04:33:26PM -0400, Joe Lawrence wrote:
> On 7/19/23 11:21, Petr Mladek wrote:
> > On Fri 2023-06-23 18:55:29, Brian Gerst wrote:
> >> When kCFI is enabled, special handling is needed for the indirect call
> >> to the kernel thread function.  Rewrite the ret_from_fork() function in
> >> C so that the compiler can properly handle the indirect call.
> > 
> > This patch broke livepatching. Kthreads never have a reliable stack.
> > It works when I revert it.
> > 
> 
> Just curious -- did the selftests catch this anywhere?  I'm not 100%
> clear on what trees / frequency they all run, so maybe Petr you found
> this by code inspection or other means?

I suspect Petr ran the selftests himself, they're fairly easy to run
(once you figure out the magic incantation) and insta fail.

I'm not sure the robots consistently run this stuff -- I've had these
patches exposed to 0day for weeks...
