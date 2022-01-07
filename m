Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D0C4877EA
	for <lists+live-patching@lfdr.de>; Fri,  7 Jan 2022 14:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347343AbiAGNEX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 7 Jan 2022 08:04:23 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:41722 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiAGNEW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 7 Jan 2022 08:04:22 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4D66B1F397;
        Fri,  7 Jan 2022 13:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641560661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ydS8jbmtTNSvhWKqliTJ11ZJ+8dm8meUoBr5M26AGBs=;
        b=qt9txL8Q9yT8aJ3LdX4wHHomcTGi8nLR32MAdumkrzI1zQINKKFXegLKTnGdo3jU9qnaAN
        v/zrgeWO21SkaEN7XP/vyhAUxp195PZ3aWs09oI5q8D1AMrUMMSWT9RMtlByTcErRyw52W
        zWNLk5dBfO3WW94F7cozZ4+el+0ae5E=
Received: from suse.cz (unknown [10.100.216.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 30B1DA3B84;
        Fri,  7 Jan 2022 13:04:21 +0000 (UTC)
Date:   Fri, 7 Jan 2022 14:03:49 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     David Vernet <void@manifault.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com
Subject: Re: [PATCH] livepatch: Avoid CPU hogging with cond_resched
Message-ID: <Ydg6NYs+gEypq0LK@alley>
References: <20211229215646.830451-1-void@manifault.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211229215646.830451-1-void@manifault.com>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2021-12-29 13:56:47, David Vernet wrote:
> When initializing a 'struct klp_object' in klp_init_object_loaded(), and
> performing relocations in klp_resolve_symbols(), klp_find_object_symbol()
> is invoked to look up the address of a symbol in an already-loaded module
> (or vmlinux). This, in turn, calls kallsyms_on_each_symbol() or
> module_kallsyms_on_each_symbol() to find the address of the symbol that is
> being patched.
> 
> It turns out that symbol lookups often take up the most CPU time when
> enabling and disabling a patch, and may hog the CPU and cause other tasks
> on that CPU's runqueue to starve -- even in paths where interrupts are
> enabled.  For example, under certain workloads, enabling a KLP patch with
> many objects or functions may cause ksoftirqd to be starved, and thus for
> interrupts to be backlogged and delayed. This may end up causing TCP
> retransmits on the host where the KLP patch is being applied, and in
> general, may cause any interrupts serviced by softirqd to be delayed while
> the patch is being applied.
> 
> So as to ensure that kallsyms_on_each_symbol() does not end up hogging the
> CPU, this patch adds a call to cond_resched() in kallsyms_on_each_symbol()
> and module_kallsyms_on_each_symbol(), which are invoked when doing a symbol
> lookup in vmlinux and a module respectively.  Without this patch, if a
> live-patch is applied on a 36-core Intel host with heavy TCP traffic, a
> ~10x spike is observed in TCP retransmits while the patch is being applied.
> Additionally, collecting sched events with perf indicates that ksoftirqd is
> awakened ~1.3 seconds before it's eventually scheduled.  With the patch, no
> increase in TCP retransmit events is observed, and ksoftirqd is scheduled
> shortly after it's awakened.
> 
> Signed-off-by: David Vernet <void@manifault.com>

OK, there was not any strong pushback.

I have committed the patch into livepatch.git, branch for-5.17/kallsyms.

Best Regards,
Petr
