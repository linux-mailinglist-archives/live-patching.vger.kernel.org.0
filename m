Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDCA41CB6F
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 20:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245760AbhI2SFA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 14:05:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:50818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245613AbhI2SE7 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 14:04:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4624661406;
        Wed, 29 Sep 2021 18:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632938598;
        bh=eql6yhbPlBH5tPqTT53mKEmOi18SpoRI4mOYctOI/jQ=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=W2snQrx8gdJB/cKZd3PkOquuT1K5kzzQHXU3uFXco+jdBPR05q9WxLVycTOQLPAYO
         HZ5g5whd8GZ+vOILbZnBvF3Qe7u2eQMSw7Epri5ipFdSYrZUNLZP0HxuEvZHsXU1+x
         B2rDp3UBGZzhrLT5dn9yNu/YrwcdfoaD25z9bhzzGqJjOWvPA7h58AbbTTKUjwzGEa
         EkmQE28atMZd/lJ09/6UfFTE/Axe5aAldPvtZjT+in6BhjiBEJjIeFtZdt97viG3py
         QVxX3Z9gSy8fIOe6jBf7UHZqiIAxzICrj7g8Vkl4KGi2Jn27XIsCI4zgsV2sKGatx2
         5Y5E2B6HQQI0g==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 140015C06B9; Wed, 29 Sep 2021 11:03:18 -0700 (PDT)
Date:   Wed, 29 Sep 2021 11:03:18 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, rostedt@goodmis.org, x86@kernel.org
Subject: Re: [PATCH v2 00/11] sched,rcu,context_tracking,livepatch: Improve
 livepatch task transitions for idle and NOHZ_FULL
Message-ID: <20210929180318.GX880162@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210929151723.162004989@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929151723.162004989@infradead.org>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 29, 2021 at 05:17:23PM +0200, Peter Zijlstra wrote:
> Hi,
> 
> One series in two parts; the first part (patches 1-5) should be in reasonable
> shape and ought to fix the original issues that got this whole thing started.
> 
> The second part (patches 6-11) are still marked RFC and do scary things to try
> and make NOHZ_FULL work better.
> 
> Please consider..
> 
> PS. Paul, I did do break RCU a bit and I'm not sure about the best way to put
> it back together, please see patch 8 for details.

Hey, wait!!!  Breaking RCU is -my- job!!!  ;-)

							Thanx, Paul
