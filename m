Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52FCCE6FCF
	for <lists+live-patching@lfdr.de>; Mon, 28 Oct 2019 11:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732924AbfJ1Knq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 28 Oct 2019 06:43:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35926 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732891AbfJ1Knq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 28 Oct 2019 06:43:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=nar9Iq7Q7mTUudrNdJ/jj69T2ZUNiLNNiPhobZAvyPM=; b=FgDpTFpvRAHkibxg6VtMsFgC2
        sDSt8Yp+REORhqdfaPb8sB455Z0xfr7MDZlIap8nAU8BjZg/gZXg/MUjeilLECHPtSPIfPvxnq5Af
        yEMTOmUzzTWra7TXvpnhHnNJ+mZl3jSCl3gdsJ7XgrNUBrRKODUdR5eckaVSoonpOHQSL1SaC7d0D
        /WFWsV4WVGS+M9+Vx9WM+nAGspV7Z9YdaocylsyTYr2qNF3/k+pLAqTW1GyhJXzHV3db3nNz4dMR8
        CkK7UEflpptcaMx+tKo6F7SBb+I/W/bJFp6LZtzLHrv/gG4zSEM+2Uoydv/XmamDWiYU/kTUl+hQ1
        /kVvEXfKA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iP2Uo-0003zV-N0; Mon, 28 Oct 2019 10:43:34 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D5332300E4D;
        Mon, 28 Oct 2019 11:42:31 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 10EE120761E44; Mon, 28 Oct 2019 11:43:32 +0100 (CET)
Date:   Mon, 28 Oct 2019 11:43:32 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jeyu@kernel.org,
        live-patching@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 15/16] module: Move where we mark modules RO,X
Message-ID: <20191028104332.GL4131@hirez.programming.kicks-ass.net>
References: <20191018074634.801435443@infradead.org>
 <20191021135312.jbbxsuipxldocdjk@treble>
 <20191021141402.GI1817@hirez.programming.kicks-ass.net>
 <20191023114835.GT1817@hirez.programming.kicks-ass.net>
 <20191023170025.f34g3vxaqr4f5gqh@treble>
 <20191024131634.GC4131@hirez.programming.kicks-ass.net>
 <20191025064456.6jjrngm4m3mspaxw@pathway.suse.cz>
 <20191025084300.GG4131@hirez.programming.kicks-ass.net>
 <20191025100612.GB5671@hirez.programming.kicks-ass.net>
 <20191026011741.xywerjv62vdmz6sp@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191026011741.xywerjv62vdmz6sp@treble>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Oct 25, 2019 at 08:17:41PM -0500, Josh Poimboeuf wrote:

> I can take over the livepatch-specific patches if you want.  Or however
> you want to do it.

Sure, feel free to take and route the livepatch patches. Then I'll wait
until those and the ARM64 patches land before I'll pick this up again.
