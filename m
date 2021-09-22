Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3917A4150EB
	for <lists+live-patching@lfdr.de>; Wed, 22 Sep 2021 22:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237277AbhIVUEU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Sep 2021 16:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237276AbhIVUES (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Sep 2021 16:04:18 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CF07C061574;
        Wed, 22 Sep 2021 13:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xMMkEjEh6E2g/7bmfUoiGSvQRpLkGpcY6eTiqRST8LI=; b=DhzinNwGViZ2LB3qjFCetI4dTu
        vlMTuCI/qLfhGb8MkVX1k6VGrgud5ucv6a9uDOeEx7KTk3/RgXRNbO7tzS1XvBePUE/2c5Aw7eBQs
        ivBVgemAdQiLZApati8fT9X6dKMlYgz4qPWps6YtUlRinWPb5FMVGGPqXF8hKEtWbEf/0DK+idU2X
        hcDNwOzq3y3FTZqPbTRA4fF9hT4uUsLi95lTrMXR7L1tcF+AFhxPu65Ri0EfyH3AQKInXZ3r4T/mx
        UZ5xTy9JFgLcWFJzryobReCmWMwcnO2bTOCEQc7dW2DwQMHiutqBchz9EzsqpovN/PHge4FqIIMfl
        zHZ4WGIQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mT8Rz-0054Hx-70; Wed, 22 Sep 2021 20:02:39 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B672C300250;
        Wed, 22 Sep 2021 22:02:38 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 9D9072C8201A6; Wed, 22 Sep 2021 22:02:38 +0200 (CEST)
Date:   Wed, 22 Sep 2021 22:02:38 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org,
        linux-kernel@vger.kernel.org, joe.lawrence@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de, hca@linux.ibm.com,
        svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org
Subject: Re: [RFC][PATCH 6/7] context_tracking: Provide SMP ordering using RCU
Message-ID: <YUuL3sveLOszCDlj@hirez.programming.kicks-ass.net>
References: <20210922110506.703075504@infradead.org>
 <20210922110836.244770922@infradead.org>
 <20210922151721.GZ880162@paulmck-ThinkPad-P17-Gen-1>
 <YUuFF8+H2PE9m4wy@hirez.programming.kicks-ass.net>
 <20210922195350.GC880162@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210922195350.GC880162@paulmck-ThinkPad-P17-Gen-1>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Sep 22, 2021 at 12:53:50PM -0700, Paul E. McKenney wrote:

> I wasn't saying that the patch doesn't work.  But doesn't it add an IPI?
> Or was I looking at it too early this morning?

Ah, no. The patch allows a user-bound NOHZ_FULL task to be transitioned
remotely. Unlike today, where they'll eventually poke it with a signal
to force a kernel entry, which is bad m'kay :-)

The code in question skips transitioning running tasks, seeing as you
can't tell what they're doing etc.. Howver, with context tracking on
you're supposedly able to tell they're in userspace without disturbing
them -- except you really can't today.

So if you can tell that a current running task is in userspace (hence my
patch) you can allow the task to transition without any further ado,
userspace is a safe state vs kernel text patching.
