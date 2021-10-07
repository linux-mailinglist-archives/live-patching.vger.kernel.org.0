Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7180B4250A7
	for <lists+live-patching@lfdr.de>; Thu,  7 Oct 2021 12:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhJGKGD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 7 Oct 2021 06:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231557AbhJGKGC (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 7 Oct 2021 06:06:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92587C061746;
        Thu,  7 Oct 2021 03:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=C8wTja1/kNUPKbovecpb0COkPHJCc/AwdIEERYXPS3g=; b=hsy9x2gpcaQsHrFVuuuXQzyKXy
        oAdAPhrpG2+4MhvS6n3LneR4vyxV1XvXxFdvDrUhgfzo3XeJVwTEeUf1WczMm1CAkT5cLy2+MT3u6
        BLUd8mSKbgiVv5Qs5YSlzKGMiMJ78y0Wfn1VXa+JzODV3ZEx86RdUjE5R0H0+hFrcCxemMOjoGIJS
        hu9Pn/CKZtrNdxajvNAM5FpBPYAJ/auaQrXTgMKzoz4UxVDR6MFfeVZmlNHY9cbEBYBzwWzvUojBO
        bYxYpJpZMiEXv30FH/nbYw8XhNBO0Un/nUTGwIvoCTS+vZkqycjuUeC/WQimwcbybOp3NBu9wAnz5
        gY/4KzyA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mYQEc-001jh7-9U; Thu, 07 Oct 2021 10:02:53 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 94C549811BB; Thu,  7 Oct 2021 12:02:41 +0200 (CEST)
Date:   Thu, 7 Oct 2021 12:02:41 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Vasily Gorbik <gor@linux.ibm.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, jpoimboe@redhat.com,
        jikos@kernel.org, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: Re: [PATCH v2 05/11] sched,livepatch: Use wake_up_if_idle()
Message-ID: <20211007100241.GR174703@worktop.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152428.828064133@infradead.org>
 <alpine.LSU.2.21.2110061115270.2311@pobox.suse.cz>
 <your-ad-here.call-01633598293-ext-3109@work.hours>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <your-ad-here.call-01633598293-ext-3109@work.hours>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Oct 07, 2021 at 11:18:13AM +0200, Vasily Gorbik wrote:

> Patches 1-6 work nicely, for them
> 
> Acked-by: Vasily Gorbik <gor@linux.ibm.com>
> Tested-by: Vasily Gorbik <gor@linux.ibm.com> # on s390
> 
> Thanks a lot!

Thanks, will add tags.

> Starting with patch 8 is where I start seeing this with my config:

Yeah, I properly wrecked things there.. still trying to work out how to
fix it :-)
