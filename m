Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB90932262B
	for <lists+live-patching@lfdr.de>; Tue, 23 Feb 2021 08:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhBWHKY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Feb 2021 02:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:33990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229999AbhBWHKW (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Feb 2021 02:10:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35AD364DF5;
        Tue, 23 Feb 2021 07:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614064180;
        bh=cHjGiKXHdsfh6IXz5BdpbiOLiJ8lvc+EMmClna0j4SY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dNKIKJuqKUM+8hSSOmT8wTsLcjGlinYVEFcZM36Ipvb0qNSGQ+6l5s1IElwBdJzmD
         EVPDqhwf+Vhi01EvwRXTIc23FMBjDT8nUiLnbRnrwX7BX4S3kR+9asfDRpk75zLDwY
         FT7Wt+PU3AXPtfxIyFRFX3LEsOsTlvFrvsXw6WjIhWAGUhoCsiaVkOt+mP4HEAxiTn
         5dXyCt4dpmh+vU4Upuf6vKJrDNdjIDDXQsHrrHuOCQ+fvI+MLANsvCnBtbkVO2cBEc
         pP6YrX3Gk6Ox/xQ0NG1KQ1+NxWRQLkLIEiyJ21B7xCH8+K9Rouy0bUIHNc8ldkBL1y
         3JJ+PqfRotIng==
Date:   Tue, 23 Feb 2021 16:09:35 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Konstantin Khorenko <khorenko@virtuozzo.com>
Subject: Re: 'perf probe' and symbols from .text.<something>
Message-Id: <20210223160935.82b2a9c42f637ce5449a7497@kernel.org>
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

Hi,

On Tue, 23 Feb 2021 00:05:08 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

>   ----
> /* Adjust symbol name and address */
> static int post_process_probe_trace_point(struct probe_trace_point *tp,
>                                            struct map *map, unsigned long offs)
> {
>         struct symbol *sym;
>         u64 addr = tp->address - offs;
> 
>         sym = map__find_symbol(map, addr);
>         if (!sym)
>                 return -ENOENT;
>   ----
> 
> So it seems "map" may not load the symbol out of ".text".
> This need to be fixed, since the map is widely used in the perf.

OK, I found a root cause of this issue.
dso__process_kernel_symbol() (which invoked from map__load() path) only adds the
symbols in ".text" section to the symbol list. It must be fixed.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
