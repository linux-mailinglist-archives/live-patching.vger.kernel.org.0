Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C895241CC68
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 21:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344473AbhI2TOG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 15:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346491AbhI2TN7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 15:13:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18975C06161C;
        Wed, 29 Sep 2021 12:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8/woToWXwl+2dOjjt6TDxk1idEoF1XMtSstAROXdXrs=; b=hZAQ+lLct0B9S3W6o72fvNY7lL
        DGkzWPKuoRwcZcBRrlVuExJOPIJQ7GorhcbNfnih+lMaqvsCTRWECBOeOalUUml6P0q9teFNmTmlk
        2pO/rPPbZZAwjBLbTfwAnBPw+GbNg+pPx9jFlvQE32Y6dunSUYVPmhjbyHUVDj5nm3vgvNFVHLSJf
        6MoKD5kBcTAh4RtdyyUXle3gIBu0rhud8GSh3AqDPxHckUwbsWhVWa9y8jmmHM4jJWUNu4IEG20rO
        NyXc66+DoMMWZUCzjw8MK44iAiZL35f1OJRIZmuwqoOEu0jkxNnSVmFTif1ONNKd6WruatUnC6Nt/
        mz7zYtDg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVexU-00C9Ps-RJ; Wed, 29 Sep 2021 19:09:52 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id C6501981431; Wed, 29 Sep 2021 21:09:35 +0200 (CEST)
Date:   Wed, 29 Sep 2021 21:09:35 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, rostedt@goodmis.org, x86@kernel.org
Subject: Re: [RFC][PATCH v2 08/11] context_tracking,rcu: Replace RCU dynticks
 counter with context_tracking
Message-ID: <20210929190935.GX4323@worktop.programming.kicks-ass.net>
References: <20210929151723.162004989@infradead.org>
 <20210929152429.007420590@infradead.org>
 <20210929183701.GY880162@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929183701.GY880162@paulmck-ThinkPad-P17-Gen-1>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 29, 2021 at 11:37:01AM -0700, Paul E. McKenney wrote:
> On Wed, Sep 29, 2021 at 05:17:31PM +0200, Peter Zijlstra wrote:
> The CT_SEQ_WORK bit means neither idle nor nohz_full user, correct?

That bit is indeed independent, it can get set remotely by cmpxchg when
in user/eqs state and will be tested and (eventually) cleared when
leaving user/eqs state.

> So let's see if I intuited the decoder ring, where "kernel" means that
> portion of the kernel that is non-noinstr...
> 
> CT_SEQ_WORK	CT_SEQ_NMI	CT_SEQ_USER	Description?
> 0		0		0		Idle or non-nohz_full user
> 0		0		1		nohz_full user
> 0		1		0		NMI from 0,0,0
> 0		1		1		NMI from 0,0,1
> 1		0		0		Non-idle kernel
> 1		0		1		Cannot happen?
> 1		1		0		NMI from 1,0,1
> 1		1		1		NMI from cannot happen
> 
> And of course if a state cannot happen, Murphy says that you will take
> an NMI in that state.

Urgh, you have the bits the 'wrong' way around :-)

MSB     3210
|-------||||

Where [MSB-3] is the actual sequence number, [21] is the state and [0]
is the work-pending bit.

The table for [21] is like:

USER NMI
 0    0		kernel
 0    1		kernel took nmi
 1    0		user
 1    1		user took nmi

So effectively EQS is 10 only, the other 3 states are kernel.

