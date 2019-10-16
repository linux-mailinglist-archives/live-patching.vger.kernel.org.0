Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6BCFD8A3D
	for <lists+live-patching@lfdr.de>; Wed, 16 Oct 2019 09:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391364AbfJPHuD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Oct 2019 03:50:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57086 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391302AbfJPHuD (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Oct 2019 03:50:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gHzug1GaUc7ezNj7bFyKz/sT6qVftQ/c/eZSM2ZX/yA=; b=KCZ+f1LSz+WgwwiREH87xcTq/
        gdAvldI5Mhnc/Q14EWgLX8/WgPcNqstNJEAWsC5WoFJHN+AxJtLVDmeP9Qmf1IRwh/ho/R4hTHGgw
        MVY8hfrR2oLY+aCCeR8uMeudZ2hNu21TKkPW4RZkvYIAcIes4+edKfjInFEG10Yg9y/t0UwCGAEws
        0Tsp1c2BB+5htwUkDzZuv8VVC5p3AahL7ThhupbnCqduKuC+6NSo9mg9AH8eE+jllee2nJ6eV8pmZ
        GRzY87IwtVS1UFmc2euekMg/WlWdrK0MQkIjkt5aXdrTqY66a5Z8c2OEQrIoCowYWG3LeTHMl+HoP
        0C78MuyDw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKe49-0001yz-LA; Wed, 16 Oct 2019 07:49:54 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6F197303C1E;
        Wed, 16 Oct 2019 09:48:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3936520B972E4; Wed, 16 Oct 2019 09:49:51 +0200 (CEST)
Date:   Wed, 16 Oct 2019 09:49:51 +0200
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
Message-ID: <20191016074951.GM2328@hirez.programming.kicks-ass.net>
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

On Tue, Oct 15, 2019 at 06:27:05PM -0400, Steven Rostedt wrote:

> (7) Seventh session, titled "klp-convert and livepatch relocations", was led
> by Joe Lawrence.
> 
> Joe started the session with problem statement: accessing non exported / static
> symbols from inside the patch module. One possible workardound is manually via
> kallsyms. Second workaround is klp-convert, which actually creates proper
> relocations inside the livepatch module from the symbol database during the
> final .ko link.
> Currently module loader looks for special livepatch relocations and resolves
> those during runtime; kernel support for these relocations have so far been
> added for x86 only. Special livepatch relocations are supported and processed
> also on other architectures. Special quirks/sections are not yet supported.
> Plus klp-convert would still be needed even with late module patching update.
> vmlinux or modules could have ambiguous static symbols.
> 
> It turns out that the features / bugs below have to be resolved before we
> can claim the klp-convert support for relocation complete:
>     - handle all the corner cases (jump labels, static keys, ...) properly and
>       have a good regression tests in place

I suppose all the patches in this series-of-series here will make life
harder for KLP, static_call() and 2 byte jumps etc..

>     - one day we might (or might not) add support for out-of-tree modules which
>       need klp-convert
>     - BFD bug 24456 (multiple relocations to the same .text section)


