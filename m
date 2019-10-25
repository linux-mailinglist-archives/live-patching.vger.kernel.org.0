Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 934DDE4823
	for <lists+live-patching@lfdr.de>; Fri, 25 Oct 2019 12:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439363AbfJYKGi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 25 Oct 2019 06:06:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36584 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438337AbfJYKGi (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 25 Oct 2019 06:06:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=q6FFczL57RhsN1t0BzhzZVDPDAgimSM0qYSWHe2kb80=; b=BdoOO1x/Mx78pKJns8iGGvn8w
        MwPIkb/Rp8dGTlpmX4DcXhYJAkdz2yLZTMpQsJcQKxGgODLRU+HVbE+GJ59s7JpWFTiXH1Ywy/SmE
        pFaBsx+s0NNpL6bsKdjio5Owv1HsmkuzcvVrnm4xeoHr8O7QWvjb7yOm3+aiHWw5zP4kIix8ju4Ko
        RgfnyjuBFfIRqLGVhG9Ks/gadccoul6ccLW9HLDnTsRM/GvWbazOZkLAIn/m4ps5apiXqySAMkziY
        pBYjP221fSvKCP36RK+34I7FvVuY7dDKYaHpjbNbhENpgx6ph2fuvtK1CuvTJIW49AuJGgOUq3QpS
        fnQRDNPew==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNwU4-0002JW-Ha; Fri, 25 Oct 2019 10:06:16 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D87D230314F;
        Fri, 25 Oct 2019 12:05:13 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AA12E203C086A; Fri, 25 Oct 2019 12:06:12 +0200 (CEST)
Date:   Fri, 25 Oct 2019 12:06:12 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jeyu@kernel.org,
        live-patching@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 15/16] module: Move where we mark modules RO,X
Message-ID: <20191025100612.GB5671@hirez.programming.kicks-ass.net>
References: <20191018073525.768931536@infradead.org>
 <20191018074634.801435443@infradead.org>
 <20191021135312.jbbxsuipxldocdjk@treble>
 <20191021141402.GI1817@hirez.programming.kicks-ass.net>
 <20191023114835.GT1817@hirez.programming.kicks-ass.net>
 <20191023170025.f34g3vxaqr4f5gqh@treble>
 <20191024131634.GC4131@hirez.programming.kicks-ass.net>
 <20191025064456.6jjrngm4m3mspaxw@pathway.suse.cz>
 <20191025084300.GG4131@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025084300.GG4131@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, Oct 25, 2019 at 10:43:00AM +0200, Peter Zijlstra wrote:

> But none of that explains why apply_alternatives() is also delayed.
> 
> So I'm very tempted to just revert that patchset for doing it all
> wrong.

And I've done just that. This includes Josh's validation patch, the
revert and my klp_appy_relocations_add() patches with the removal of
module_disable_ro().

Josh, can you test or give me clue on how to test? I need to run a few
errands today, but I'll try and have a poke either tonight or tomorrow.

  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git x86/rwx

After this it is waiting for Mark's argh64 patches to land:

  https://lkml.kernel.org/r/20191021163426.9408-5-mark.rutland@arm.com

And then we can go and delete module_disable_ro() entirely -- hooray!
