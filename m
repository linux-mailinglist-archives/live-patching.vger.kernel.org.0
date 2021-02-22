Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C497321AE2
	for <lists+live-patching@lfdr.de>; Mon, 22 Feb 2021 16:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbhBVPM6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 22 Feb 2021 10:12:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230378AbhBVPMv (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 22 Feb 2021 10:12:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B9F564E61;
        Mon, 22 Feb 2021 15:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614006725;
        bh=NDgZTqFZ6L94F/HVezS1Spyd2g4LoZ+F846hPirmNbA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tWrOZaT2AURA9mEIP8mlw8AFHJqdT8KxHGbvKVexcD6uTOqVixaqssbcR3wBPIE8E
         QF7uzowYMhST48vWyDWYi+UuueqEIYXcqxLpU+EKaxfw46p05e+Av6oKi7Da74hFYA
         HeydWYDr745b1uAkS6oGi2d8beJJmLg2gxTQpB1cWB0prPzT90cAlWXUUlkJ1MTm2v
         AUMmK7naH69pTokCVgtJKq3yj0RSIEvYOebNLlWSsUPL9QIbALx8kJ+6PncrL9NO6d
         abhi+UHslg7IwJ1a9v+Hw3SfnOM9lHDb4JnKqHTB9epPyye+1ElMBb0F4QvxJJy23e
         wufjIgry68WuQ==
Date:   Tue, 23 Feb 2021 00:12:01 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: Re: 'perf probe' and symbols from .text.<something>
Message-Id: <20210223001201.c478d4cb6481385d31b3f09b@kernel.org>
In-Reply-To: <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
References: <09257fb8-3ded-07b0-b3cc-55d5431698d8@virtuozzo.com>
        <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 23 Feb 2021 00:05:08 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> Hi Evgenii,
> 
> On Thu, 18 Feb 2021 20:09:17 +0300
> Evgenii Shatokhin <eshatokhin@virtuozzo.com> wrote:
> 
> > Hi,
> > 
> > It seems, 'perf probe' can only see functions from .text section in the 
> > kernel modules, but not from .text.unlikely or other .text.* sections.
> > 
> > For example, with kernel 5.11 and nf_conntrack.ko with debug info, 'perf 
> > probe' succeeds for nf_conntrack_attach() from .text and fails for 
> > nf_ct_resolve_clash() from .text.unlikely:
> 
> Thanks for reporting it!
> 
> > 
> > ------------
> > # perf probe -v -m nf_conntrack nf_ct_resolve_clash
> > probe-definition(0): nf_ct_resolve_clash
> > symbol:nf_ct_resolve_clash file:(null) line:0 offset:0 return:0 lazy:(null)
> > 0 arguments
> > Failed to get build-id from nf_conntrack.
> > Cache open error: -1
> > Open Debuginfo file: 
> > /lib/modules/5.11.0-test01/kernel/net/netfilter/nf_conntrack.ko
> > Try to find probe point from debuginfo.
> > Matched function: nf_ct_resolve_clash [33616]
> > Probe point found: nf_ct_resolve_clash+0
> > Found 1 probe_trace_events.
> > Post processing failed or all events are skipped. (-2)
> > Probe point 'nf_ct_resolve_clash' not found.
> >    Error: Failed to add events. Reason: No such file or directory (Code: -2)
> 
[...]

> > Is there a way to allow probing of functions in .text.<something> ?

BTW, just for putting a probe on nf_ct_resolve_clash, please give the module *path*
instead of the module *name*. For example,

perf probe -v -m /lib/modules/5.11.0-test01/kernel/net/netfilter/nf_conntrack.ko nf_ct_resolve_clash

This should work (at least works for me), because it directly loads the symbols from the .ko file.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
