Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2D2323195
	for <lists+live-patching@lfdr.de>; Tue, 23 Feb 2021 20:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232754AbhBWTrX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Feb 2021 14:47:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57172 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231858AbhBWTrW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Feb 2021 14:47:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614109556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k6yTUk4uiMxB/J45WOwiwNDUQruhsfoPNbtv/+KOvq4=;
        b=BxNTynZ+GbCYXyQFq7S29WUOcG9xvivZifkiNXH1/GmlLivSNcB1DLx2g7yKZl7sxdociV
        L506hP82hox2UDP1lV/960cMO/q5o4gP7/cEe9Q0NV068Dlq40H56P+e5XsDeeHBTZIKgM
        cHFbStmTr++9q39QuLbfzW/oWMihpZo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-0o9XgixIO7SOTOk_xRElUw-1; Tue, 23 Feb 2021 14:45:51 -0500
X-MC-Unique: 0o9XgixIO7SOTOk_xRElUw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0C78107ACF8;
        Tue, 23 Feb 2021 19:45:49 +0000 (UTC)
Received: from treble (ovpn-118-117.rdu2.redhat.com [10.10.118.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AB5B75C277;
        Tue, 23 Feb 2021 19:45:48 +0000 (UTC)
Date:   Tue, 23 Feb 2021 13:45:46 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: Re: 'perf probe' and symbols from .text.<something>
Message-ID: <20210223194546.dhejf4mpugyw3nqq@treble>
References: <09257fb8-3ded-07b0-b3cc-55d5431698d8@virtuozzo.com>
 <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
 <20210222175150.yxgw3sxxaqjqgq56@treble>
 <20210223102331.147d62de88886a75013c10e0@kernel.org>
 <20210223163619.0cd580a4290165208c8aa7bb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210223163619.0cd580a4290165208c8aa7bb@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Feb 23, 2021 at 04:36:19PM +0900, Masami Hiramatsu wrote:
> On Tue, 23 Feb 2021 10:23:31 +0900
> Masami Hiramatsu <mhiramat@kernel.org> wrote:
> 
> > On Mon, 22 Feb 2021 11:51:50 -0600
> > Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> > 
> > > On Tue, Feb 23, 2021 at 12:05:08AM +0900, Masami Hiramatsu wrote:
> > > > > Of course, one could place probes using absolute addresses of the 
> > > > > functions but that would be less convenient.
> > > > > 
> > > > > This also affects many livepatch modules where the kernel code can be 
> > > > > compiled with -ffunction-sections and each function may end up in a 
> > > > > separate section .text.<function_name>. 'perf probe' cannot be used 
> > > > > there, except with the absolute addresses.
> > > > > 
> > > > > Moreover, if FGKASLR patches are merged 
> > > > > (https://lwn.net/Articles/832434/) and the kernel is built with FGKASLR 
> > > > > enabled, -ffunction-sections will be used too. 'perf probe' will be 
> > > > > unable to see the kernel functions then.
> > > > 
> > > > Hmm, if the FGKASLAR really randomizes the symbol address, perf-probe
> > > > should give up "_text-relative" probe for that kernel, and must fallback
> > > > to the "symbol-based" probe. (Are there any way to check the FGKASLR is on?)
> > > > The problem of "symbol-based" probe is that local (static) symbols
> > > > may share a same name sometimes. In that case, it can not find correct
> > > > symbol. (Maybe I can find a candidate from its size.)
> > > > Anyway, sometimes the security and usability are trade-off.
> > > 
> > > We had a similar issue with FGKASLR and live patching.  The proposed
> > > solution is a new linker flag which eliminates duplicates: -z
> > > unique-symbol.
> > > 
> > > https://sourceware.org/bugzilla/show_bug.cgi?id=26391
> > 
> > Interesting, but it might not be enough for perf-probe.
> > Since the perf-probe has to handle both dwarf and elf, both must be
> > changed. I think the problem is that the dwarf is generated while
> > compiling, but this -z seems converting elf symbols in linkage.
> > As far as I can see, this appends ".COUNT" suffix to the non-unique
> > symbols in the linkage phase. Is that also applied to dwarf too?
> 
> Ah, OK. If there is an offline elf binary with symbol map, I can convert
> DWARF symbol -> address -> offline elf symbol (unique name)-> kallsyms.
> Currently, it directly converts address by kallsyms, so I will change it
> to find elf-symbol and solve address by kallsyms in post processing.

DWARF sections have references to the ELF symbols, which are renamed by
the linker.  So DWARF should automatically show the new symbol name.

And kallsyms is generated after the kernel is linked.  So I'm not sure I
understand the problem.

-- 
Josh

