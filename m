Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE62041CC84
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 21:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245386AbhI2TUO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 15:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245131AbhI2TUN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 15:20:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BBEC06161C;
        Wed, 29 Sep 2021 12:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rDlIUYjTm39b2Z8IS0wdVZ3JLOJjy6yOyLpknJOI2Nk=; b=lGmQZw71exQWPBnjdWDupYTtpl
        D8qQqLKPHK023bQNN4tNkbfBTffbADEjCZunnGWQjBOwSS4aH9ij8l17t7tgIHwTbWcOhMh4MIr3E
        31ancIfRMc6e+1OsxQ7gr9KDO+NX5DZv1+ra8fgd0SHhILuuYvmrRsDLqbXKJiTv/cHM/Ji+qNpLX
        T7dT5w11uy0lerIvt9/KXJ5F47+TRayB+rvQoKngfgfKIB/YgASU0ULQT871sOocBWjQUwdK9R9my
        /NdHjyGL3C0S16BTc7GW1p7Xtu9+tO7VkULafumTPIxUNOsmvXXqHwyJ0WfNTsGl1PkYYUtwspuYI
        z/HXk/+Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVf1D-00C9dK-Am; Wed, 29 Sep 2021 19:14:09 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id D1E8A981431; Wed, 29 Sep 2021 21:13:26 +0200 (CEST)
Date:   Wed, 29 Sep 2021 21:13:26 +0200
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
Message-ID: <20210929191326.GZ4323@worktop.programming.kicks-ass.net>
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

> And what happens to all of this in !CONFIG_CONTEXT_TRACKING kernels?
> Of course, RCU needs it unconditionally.  (There appear to be at least
> parts of it that are unconditionally available, but I figured that I
> should ask.  Especially given the !CONFIG_CONTEXT_TRACKING definition
> of the __context_tracking_cpu_seq() function.)

For !CONFIG_CONTEXT_TRACKING it goes *poof*.

Since the thing was called dynticks, I presumed it was actually dynticks
only, silly me (also, I didn't see any obvious !context_tracking usage
of it, i'll go audit it more carefully.
