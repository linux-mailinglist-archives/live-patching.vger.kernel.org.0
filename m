Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0E5416040
	for <lists+live-patching@lfdr.de>; Thu, 23 Sep 2021 15:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhIWNt2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Sep 2021 09:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbhIWNt2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Sep 2021 09:49:28 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977CFC061574;
        Thu, 23 Sep 2021 06:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AACjuct2gGMa4ayO2xuoqolC1Rv6/bwwwAa1aD3p+b0=; b=WNIKsfJy8+K1rIn4ZOJB1ZHhl+
        ih0IfCVb/e/LSuQEi8jr9OjP0PjQ75BU6dKM9AENCUUyHFeFIt3hho9XnQTEA6R7OM3FWMqmGXF0v
        CYtowvaBRf1damLuadcRRz98u2VRO7mGrY5uCk6AGtx9c491kl7BeHwaty3XBFMS6Ii454K6qlJLv
        t/EgQdf0aj64Gc5fMsqFPc3pxbNM5/sC0SgetHpstEUsGGdivwsa37KrBrmf4V5dTbvkbx84IhFzo
        nwf6hakOLZAzDpVgT0ezQnJXFBOpLRGBx3K968fB2V8Nr/x6oE6MFh01vCETA1ni5z6hwLCUZqWKL
        gJQdBJXw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mTP4k-005EsR-T0; Thu, 23 Sep 2021 13:47:47 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 22F33300328;
        Thu, 23 Sep 2021 15:47:46 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0A0EC2026C876; Thu, 23 Sep 2021 15:47:46 +0200 (CEST)
Date:   Thu, 23 Sep 2021 15:47:46 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     gor@linux.ibm.com, jpoimboe@redhat.com, jikos@kernel.org,
        mbenes@suse.cz, mingo@kernel.org, linux-kernel@vger.kernel.org,
        joe.lawrence@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        hca@linux.ibm.com, svens@linux.ibm.com, sumanthk@linux.ibm.com,
        live-patching@vger.kernel.org, paulmck@kernel.org
Subject: Re: [RFC][PATCH 3/7] sched,livepatch: Use task_try_func()
Message-ID: <YUyFgtOSB4J6wnDC@hirez.programming.kicks-ass.net>
References: <20210922110506.703075504@infradead.org>
 <20210922110836.065940560@infradead.org>
 <YUxtbCthpr+l9XM0@alley>
 <YUx+XcYQlQ4SqEj8@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUx+XcYQlQ4SqEj8@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Sep 23, 2021 at 03:17:17PM +0200, Peter Zijlstra wrote:
> On Thu, Sep 23, 2021 at 02:05:00PM +0200, Petr Mladek wrote:
> > I would prefer to be on the safe side and catch error codes that might
> > eventually appear in the future.
> > 
> > 	case 0:
> > 		/* success */
> > 		break;
> 
> 	case -EAGAIN:
> 		/* task_try_func() raced */
> 		break;

Also, I'll try and see if I can get rid of that one.
