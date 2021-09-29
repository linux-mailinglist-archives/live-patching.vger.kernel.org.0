Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8052841C8DD
	for <lists+live-patching@lfdr.de>; Wed, 29 Sep 2021 17:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344380AbhI2P7p (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Sep 2021 11:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344228AbhI2P7n (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Sep 2021 11:59:43 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C78C061766;
        Wed, 29 Sep 2021 08:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Subject:Cc:To:From:Date:Message-ID:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=6u1WcyZyWjDQwws0YDrWPYTLefo0b0n5cCFkPDJEy5g=; b=eEgl7fk39tz1T5wON0xKDtL1io
        mhGGSdJWEIcoy0YCsueJVi7xh+TI9JxY0CVHH/bhJ2dxazuWMJvNK/kXfVCNNHNdbvX8a3O93oe5L
        00KpM/0GYw9MJTAH3lyoTVR6XBMhDTE/xbiRAPXfE8IuNxLCYRBO6akO/Mj8WUcSRYRFcsWmqZvQU
        VgG5ItLaymCP+i5af6wZyyheboQE015UxWJE0HVJk9F7IHOWoiOZVwZfr7vqdB9NmI3VJ2T4+XnhS
        /CNQMKu+/nMrfbQt7BJ3MYVLqzpM05rKMyMzCD2ZZ9dbeO6jIFuubzxCcLFork01U0GclKPaA6WZQ
        knY5vk6w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mVbxi-006jom-Mx; Wed, 29 Sep 2021 15:57:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2A78830029A;
        Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 170BA2C78F4F3; Wed, 29 Sep 2021 17:57:37 +0200 (CEST)
Message-ID: <20210929151723.162004989@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 29 Sep 2021 17:17:23 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, mingo@kernel.org
Cc:     linux-kernel@vger.kernel.org, peterz@infradead.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org,
        rostedt@goodmis.org, x86@kernel.org
Subject: [PATCH v2 00/11] sched,rcu,context_tracking,livepatch: Improve livepatch task transitions for idle and NOHZ_FULL
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

One series in two parts; the first part (patches 1-5) should be in reasonable
shape and ought to fix the original issues that got this whole thing started.

The second part (patches 6-11) are still marked RFC and do scary things to try
and make NOHZ_FULL work better.

Please consider..

PS. Paul, I did do break RCU a bit and I'm not sure about the best way to put
it back together, please see patch 8 for details.

