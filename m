Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5DE41479E
	for <lists+live-patching@lfdr.de>; Wed, 22 Sep 2021 13:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbhIVLR7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Sep 2021 07:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235793AbhIVLRo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Sep 2021 07:17:44 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0677C0617A8;
        Wed, 22 Sep 2021 04:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Subject:Cc:To:From:Date:Message-ID:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=JcZ5QAxn15NhEcpAEQ8Jw/2enl+cx8LbV4bsPqWrHz4=; b=du84JBwYWdmRUNXNvUDJXSx7+B
        Pswq88E6gViiq6G+MSZMgISnFuvCdXYWLcUP0JIJfxW6k2SmRH7IDMKEP7ICA6B2aDux5XknsDKCt
        GMQDRq9uMeVq1ERHGuKYC/NwGTVa4O+7WMzLzj4sbdttI/ksw2gT9HIMiZS9OvzNGZTrsJ+xaYXaX
        f2qeoKJGZpz3HNEa0IEwdEsLBfhu90GLJE1V+Bcky5P9YoBixylq7TQSUbe9893+6MH3OfCz7LG0E
        0mxgmASm9f9R5Bnzex/sO4m0fv+MaA1JZ97uZB9GfgOLvC4m+/sBXBEau6IymG7ka2VWOFKZ4Z0NG
        /vx+NwuA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mT09o-004irK-0n; Wed, 22 Sep 2021 11:11:28 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B78DA300DD8;
        Wed, 22 Sep 2021 13:11:18 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 751342024E452; Wed, 22 Sep 2021 13:11:18 +0200 (CEST)
Message-ID: <20210922110506.703075504@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 22 Sep 2021 13:05:06 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: [RFC][PATCH 0/7] sched,rcu,context_tracking,livepatch: Improve livepatch task transitions for idle and NOHZ_FULL cpus
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

Compile tested only, please consider carefully, esp. the last few patches that
concern context_tracking and nohz_full.

