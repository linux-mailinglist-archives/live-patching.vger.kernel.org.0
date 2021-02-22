Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42856321AC2
	for <lists+live-patching@lfdr.de>; Mon, 22 Feb 2021 16:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhBVPGF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 22 Feb 2021 10:06:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230512AbhBVPFy (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 22 Feb 2021 10:05:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAE1E64F03;
        Mon, 22 Feb 2021 15:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614006312;
        bh=N2sUrb5DtS0t0bdhotzAGrC+vNB1CWHSJkakZPoy060=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sSUqtF1ZHzKthBDohVu7u7wOxXB45KRoMAgbgZ4gSvOOHks6pzg1XicT9XzhwiI/E
         1z+JlxkrWYIYRhU6fG0SqLR2ETNzE8wp/y9RDaMk1E4o4+WVVQ25rg5GAn53THx/yn
         tOnBZRmS/AtF+IAUAWngMh5Wo6BDUR8DAm+cLNFZAUo0cx0Dv1oBSp5cCaSS97iwtX
         nZgfDfsiUF6/RzK5NlalXWtbNgB/z7iH4oU+mcpcC5m3Uga9prSfTxLztVYX7lqUKy
         rM8dCM/SUmVLZJnTDDLLygfELp58l05rvdYg4xXuaWA0GANxn4aZrM4VlIeON1abEH
         Mk2I65swSsSCw==
Date:   Tue, 23 Feb 2021 00:05:08 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: Re: 'perf probe' and symbols from .text.<something>
Message-Id: <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
In-Reply-To: <09257fb8-3ded-07b0-b3cc-55d5431698d8@virtuozzo.com>
References: <09257fb8-3ded-07b0-b3cc-55d5431698d8@virtuozzo.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi Evgenii,

On Thu, 18 Feb 2021 20:09:17 +0300
Evgenii Shatokhin <eshatokhin@virtuozzo.com> wrote:

> Hi,
> 
> It seems, 'perf probe' can only see functions from .text section in the 
> kernel modules, but not from .text.unlikely or other .text.* sections.
> 
> For example, with kernel 5.11 and nf_conntrack.ko with debug info, 'perf 
> probe' succeeds for nf_conntrack_attach() from .text and fails for 
> nf_ct_resolve_clash() from .text.unlikely:

Thanks for reporting it!

> 
> ------------
> # perf probe -v -m nf_conntrack nf_ct_resolve_clash
> probe-definition(0): nf_ct_resolve_clash
> symbol:nf_ct_resolve_clash file:(null) line:0 offset:0 return:0 lazy:(null)
> 0 arguments
> Failed to get build-id from nf_conntrack.
> Cache open error: -1
> Open Debuginfo file: 
> /lib/modules/5.11.0-test01/kernel/net/netfilter/nf_conntrack.ko
> Try to find probe point from debuginfo.
> Matched function: nf_ct_resolve_clash [33616]
> Probe point found: nf_ct_resolve_clash+0
> Found 1 probe_trace_events.
> Post processing failed or all events are skipped. (-2)
> Probe point 'nf_ct_resolve_clash' not found.
>    Error: Failed to add events. Reason: No such file or directory (Code: -2)

The above log shows, an error occured while post_process_probe_trace_events(),
and the error code is -ENOENT (-2).
  ----
                pr_debug("Found %d probe_trace_events.\n", ntevs);
                ret = post_process_probe_trace_events(pev, *tevs, ntevs,
                                        pev->target, pev->uprobes, dinfo);
                if (ret < 0 || ret == ntevs) {
                        pr_debug("Post processing failed or all events are skipped. (%d)\n", ret);
  ----

In that function, map__find_symbol() failure will return -ENOENT.

  ----
/* Adjust symbol name and address */
static int post_process_probe_trace_point(struct probe_trace_point *tp,
                                           struct map *map, unsigned long offs)
{
        struct symbol *sym;
        u64 addr = tp->address - offs;

        sym = map__find_symbol(map, addr);
        if (!sym)
                return -ENOENT;
  ----

So it seems "map" may not load the symbol out of ".text".
This need to be fixed, since the map is widely used in the perf.

Anyway, since this is on a module, so even if it can not find the symbol
from map (or failed to load a map), it can fail back to the original symbol.
Let me fix that.

> # perf probe -v -m nf_conntrack nf_conntrack_attach
> probe-definition(0): nf_conntrack_attach
> symbol:nf_conntrack_attach file:(null) line:0 offset:0 return:0 lazy:(null)
> 0 arguments
> Failed to get build-id from nf_conntrack.
> Cache open error: -1
> Open Debuginfo file: 
> /lib/modules/5.11.0-test01/kernel/net/netfilter/nf_conntrack.ko
> Try to find probe point from debuginfo.
> Matched function: nf_conntrack_attach [2c8c3]
> Probe point found: nf_conntrack_attach+0
> Found 1 probe_trace_events.
> Opening /sys/kernel/tracing//kprobe_events write=1
> Opening /sys/kernel/tracing//README write=0
> Writing event: p:probe/nf_conntrack_attach 
> nf_conntrack:nf_conntrack_attach+0
> Added new event:
>    probe:nf_conntrack_attach (on nf_conntrack_attach in nf_conntrack)
> ------------
> 
> Is there a way to allow probing of functions in .text.<something> ?

I need to check how machine__kernel_maps() generated maps cut down .text.unlikely.
Arnaldo, I thought the maps in machine__kernel_maps() are generated from
kallsyms (doesn't check .text) right?

> 
> Of course, one could place probes using absolute addresses of the 
> functions but that would be less convenient.
> 
> This also affects many livepatch modules where the kernel code can be 
> compiled with -ffunction-sections and each function may end up in a 
> separate section .text.<function_name>. 'perf probe' cannot be used 
> there, except with the absolute addresses.
> 
> Moreover, if FGKASLR patches are merged 
> (https://lwn.net/Articles/832434/) and the kernel is built with FGKASLR 
> enabled, -ffunction-sections will be used too. 'perf probe' will be 
> unable to see the kernel functions then.

Hmm, if the FGKASLAR really randomizes the symbol address, perf-probe
should give up "_text-relative" probe for that kernel, and must fallback
to the "symbol-based" probe. (Are there any way to check the FGKASLR is on?)
The problem of "symbol-based" probe is that local (static) symbols
may share a same name sometimes. In that case, it can not find correct
symbol. (Maybe I can find a candidate from its size.)
Anyway, sometimes the security and usability are trade-off.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
