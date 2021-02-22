Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04590321E8B
	for <lists+live-patching@lfdr.de>; Mon, 22 Feb 2021 18:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhBVRxZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 22 Feb 2021 12:53:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38186 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230317AbhBVRxY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 22 Feb 2021 12:53:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614016318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q/184qGC08c/X9yZo4h4BJEplxwrcfp8FbIowMgcbh8=;
        b=EnK4qSmoCoPPoWJO1Y1X92E6UDV8m6ZszFohuIJl6bxlw0F585NJy5A03tFN8B4N99LrJx
        GQnnVXEtLZY/1NLVxZbCZ9JDXJ26RbwlXpor5gBkeNf1yZXxSnYojoszKjLRZNfl+o6CHx
        bbB0mLvk/8V9SHvMTyFsOsKJk78Se2Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-RChLU-ryP-K3uWCL8GQBYQ-1; Mon, 22 Feb 2021 12:51:55 -0500
X-MC-Unique: RChLU-ryP-K3uWCL8GQBYQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ACBA3100961C;
        Mon, 22 Feb 2021 17:51:53 +0000 (UTC)
Received: from treble (ovpn-118-117.rdu2.redhat.com [10.10.118.117])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BD5435D6B1;
        Mon, 22 Feb 2021 17:51:52 +0000 (UTC)
Date:   Mon, 22 Feb 2021 11:51:50 -0600
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
Message-ID: <20210222175150.yxgw3sxxaqjqgq56@treble>
References: <09257fb8-3ded-07b0-b3cc-55d5431698d8@virtuozzo.com>
 <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Feb 23, 2021 at 12:05:08AM +0900, Masami Hiramatsu wrote:
> > Of course, one could place probes using absolute addresses of the 
> > functions but that would be less convenient.
> > 
> > This also affects many livepatch modules where the kernel code can be 
> > compiled with -ffunction-sections and each function may end up in a 
> > separate section .text.<function_name>. 'perf probe' cannot be used 
> > there, except with the absolute addresses.
> > 
> > Moreover, if FGKASLR patches are merged 
> > (https://lwn.net/Articles/832434/) and the kernel is built with FGKASLR 
> > enabled, -ffunction-sections will be used too. 'perf probe' will be 
> > unable to see the kernel functions then.
> 
> Hmm, if the FGKASLAR really randomizes the symbol address, perf-probe
> should give up "_text-relative" probe for that kernel, and must fallback
> to the "symbol-based" probe. (Are there any way to check the FGKASLR is on?)
> The problem of "symbol-based" probe is that local (static) symbols
> may share a same name sometimes. In that case, it can not find correct
> symbol. (Maybe I can find a candidate from its size.)
> Anyway, sometimes the security and usability are trade-off.

We had a similar issue with FGKASLR and live patching.  The proposed
solution is a new linker flag which eliminates duplicates: -z
unique-symbol.

https://sourceware.org/bugzilla/show_bug.cgi?id=26391

-- 
Josh

