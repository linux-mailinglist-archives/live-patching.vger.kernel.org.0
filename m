Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11188487406
	for <lists+live-patching@lfdr.de>; Fri,  7 Jan 2022 09:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbiAGIR5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 7 Jan 2022 03:17:57 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:54684 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235696AbiAGIR4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 7 Jan 2022 03:17:56 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id A368121114;
        Fri,  7 Jan 2022 08:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641543475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fBWoZvne85rEbRlJqY2EZN7RAnPgn5jVLOkXhqM7y5I=;
        b=aSGVh24xTxv2XTH1fwG3zQLbHEK62BfATWkGN6eFhMcGSGaU7IYL45hmLExdtJf5Ujcb3/
        fsaL0c+le7G8p/NFo5WiPKKUGtyvWzEyi2Smom3zcHKbpYQ1UcDu8ftfxZBrXzOcAI9oMQ
        HG9fpwq+cMZW402bNgdYiDVcRVJE3Ec=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6F255A3B85;
        Fri,  7 Jan 2022 08:17:55 +0000 (UTC)
Date:   Fri, 7 Jan 2022 09:17:52 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     void@manifault.com, live-patching@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>, jpoimboe@redhat.com,
        jikos@kernel.org, mbenes@suse.cz, joe.lawrence@redhat.com
Subject: Re: [PATCH] livepatch: Avoid CPU hogging with cond_resched
Message-ID: <Ydf3MBet/B+lUdRv@alley>
References: <20211229215646.830451-1-void@manifault.com>
 <CAPhsuW5PL1w_72Hrbsp2b3jA-SGyzv5oLfgybkq=s8J5KL6kmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW5PL1w_72Hrbsp2b3jA-SGyzv5oLfgybkq=s8J5KL6kmw@mail.gmail.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-01-06 16:21:18, Song Liu wrote:
> On Wed, Dec 29, 2021 at 1:57 PM David Vernet <void@manifault.com> wrote:
> >
> > When initializing a 'struct klp_object' in klp_init_object_loaded(), and
> > performing relocations in klp_resolve_symbols(), klp_find_object_symbol()
> > is invoked to look up the address of a symbol in an already-loaded module
> > (or vmlinux). This, in turn, calls kallsyms_on_each_symbol() or
> > module_kallsyms_on_each_symbol() to find the address of the symbol that is
> > being patched.
> >
> > It turns out that symbol lookups often take up the most CPU time when
> > enabling and disabling a patch, and may hog the CPU and cause other tasks
> > on that CPU's runqueue to starve -- even in paths where interrupts are
> > enabled.  For example, under certain workloads, enabling a KLP patch with
> > many objects or functions may cause ksoftirqd to be starved, and thus for
> > interrupts to be backlogged and delayed. This may end up causing TCP
> > retransmits on the host where the KLP patch is being applied, and in
> > general, may cause any interrupts serviced by softirqd to be delayed while
> > the patch is being applied.
> >
> > So as to ensure that kallsyms_on_each_symbol() does not end up hogging the
> > CPU, this patch adds a call to cond_resched() in kallsyms_on_each_symbol()
> > and module_kallsyms_on_each_symbol(), which are invoked when doing a symbol
> > lookup in vmlinux and a module respectively.  Without this patch, if a
> > live-patch is applied on a 36-core Intel host with heavy TCP traffic, a
> > ~10x spike is observed in TCP retransmits while the patch is being applied.
> > Additionally, collecting sched events with perf indicates that ksoftirqd is
> > awakened ~1.3 seconds before it's eventually scheduled.  With the patch, no
> > increase in TCP retransmit events is observed, and ksoftirqd is scheduled
> > shortly after it's awakened.
> >
> > Signed-off-by: David Vernet <void@manifault.com>
> 
> Acked-by: Song Liu <song@kernel.org>
> 
> PS: Do we observe livepatch takes a longer time to load after this change?
> (I believe longer time shouldn't be a problem at all. Just curious.)

It should depend on the load of the system and the number of patched
symbols. The module is typically loaded with a normal priority
process.

The commit message talks about 1.3 seconds delay of ksoftirq. In
principle, the change caused that this 1.3 sec of a single CPU time
was interleaved with other scheduled tasks on the same CPU. I would
expect that it prolonged the load just by a couple of seconds in
the described use case.

Note that the change has effect only with voluntary scheduling.
Well, it is typically used on servers where the livepatching
makes sense.

Best Regards,
Petr
