Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE8E2D8A04
	for <lists+live-patching@lfdr.de>; Wed, 16 Oct 2019 09:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391191AbfJPHmb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Oct 2019 03:42:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53938 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728201AbfJPHmb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Oct 2019 03:42:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HZk+bV3WLC0Kp3efq7J7NzYocbzHcIWk7+ZyTXdSxy4=; b=Z9FEfEftwdBAqYl5xGywYMCj1
        Bu8Oxg35mWjPBwtU9Ct4ZiRdzAPHhfk0vd4uw++CYEesW7gV/J7HaflSLW1T71OJbz17o1SbEExsa
        N9oqpDZ0qSleAu8M+IiDqv5N5wq2YXUeC2MRXhbHos7NmLflK8orqFlzz8GJ09J2CnuJxP5lkyXGP
        aij33sW+4KbMkp/C+A+lQ/Tivg8eKonAQxoXddjAdaXeFbiCVwrDWNlOSOfUYUlDvsX0LtGXT3pkA
        JxytniYK4UkZGipYAi0TbgSkgwDENkm30cTdP52UWF+0N6LFzBn3Ae7smd62Kdu/PxvL9JxVUg848
        82MCo2gYg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKdwq-00085M-9S; Wed, 16 Oct 2019 07:42:20 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D65213032F8;
        Wed, 16 Oct 2019 09:41:22 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A6F0820B972E4; Wed, 16 Oct 2019 09:42:17 +0200 (CEST)
Date:   Wed, 16 Oct 2019 09:42:17 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Jessica Yu <jeyu@kernel.org>, Miroslav Benes <mbenes@suse.cz>,
        x86@kernel.org, linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jpoimboe@redhat.com,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
Message-ID: <20191016074217.GL2328@hirez.programming.kicks-ass.net>
References: <20191010115449.22044b53@gandalf.local.home>
 <20191010172819.GS2328@hirez.programming.kicks-ass.net>
 <20191011125903.GN2359@hirez.programming.kicks-ass.net>
 <20191015130739.GA23565@linux-8ccs>
 <20191015135634.GK2328@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz>
 <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
 <20191015153120.GA21580@linux-8ccs>
 <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
 <20191015182705.1aeec284@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015182705.1aeec284@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> which are not compatible with livepatching. GCC upstream now has
> -flive-patching option, which disables all those interfering optimizations.

Which, IIRC, has a significant performance impact and should thus really
not be used...

If distros ship that crap, I'm going to laugh at them the next time they
want a single digit performance improvement because *important*.
