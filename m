Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3FA4850EC
	for <lists+live-patching@lfdr.de>; Wed,  5 Jan 2022 11:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbiAEKR0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 5 Jan 2022 05:17:26 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:44892 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235244AbiAEKRZ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 5 Jan 2022 05:17:25 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 736C22110B;
        Wed,  5 Jan 2022 10:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1641377843; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R3a4/jDffI/RE5UZn9PXmI80o+ierKeptaswzlJpcyo=;
        b=RxikGIxLDjGHCsCe9FuOETZmtVE3HYzG1kGVdliKVZ4FiW2Doh7xiyAM4LGof5z6w7F4zx
        gNpKekcjDGu0YqrSYJAaFjLKGFTykOrPJUJl3xL2kXj7rcYC7/k9LpVmWX+r2j/KGx2H4s
        DMTDWh1QV/GtNe4wp75ldw8K6eSX0sY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1641377843;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R3a4/jDffI/RE5UZn9PXmI80o+ierKeptaswzlJpcyo=;
        b=L2a7f1n0FrbGB+86/a1M9bqdPqG9ljjfyu30BlMf7g3qgHrbXhVMZ88NiBMwmdUQU48h3J
        mVQyYqZmoxC+P+CA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 59557A3B84;
        Wed,  5 Jan 2022 10:17:23 +0000 (UTC)
Date:   Wed, 5 Jan 2022 11:17:23 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     David Vernet <void@manifault.com>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, pmladek@suse.com, jikos@kernel.org,
        joe.lawrence@redhat.com
Subject: Re: [PATCH] livepatch: Avoid CPU hogging with cond_resched
In-Reply-To: <20211229215646.830451-1-void@manifault.com>
Message-ID: <alpine.LSU.2.21.2201051045540.12365@pobox.suse.cz>
References: <20211229215646.830451-1-void@manifault.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, 29 Dec 2021, David Vernet wrote:

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

Acked-by: Miroslav Benes <mbenes@suse.cz>

I had similar ideas Petr mentioned elsewhere, but I, also, have no strong 
opinion about it. Especially when livepatch is the only user of the said 
interface.

M
