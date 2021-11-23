Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC04B459FA5
	for <lists+live-patching@lfdr.de>; Tue, 23 Nov 2021 10:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhKWKCG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Nov 2021 05:02:06 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:47986 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhKWKCG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Nov 2021 05:02:06 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8C5852171F;
        Tue, 23 Nov 2021 09:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1637661537; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NoVy4KQazGU5uSc9QOg3M3TQIcU7Wtk2LsWzlrWhsQM=;
        b=QUlqugoH9+NhHcYuFfIkkXGYWnDF7M6+jl4X/7ZWBgqa0IzwbB7brf6Vktq47Y6ivO5NRj
        ZlKzaG5CnQKmGp6+b/h9dywc6x7AWNkqQyvyrNkXqJdOIS9tlvNrkd9ZCf/4y6YBuI8OfG
        6oQDGTluO2RLmAkvQqzFYTOlwoljOBQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1637661537;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NoVy4KQazGU5uSc9QOg3M3TQIcU7Wtk2LsWzlrWhsQM=;
        b=LWX7nP8Fi18JDJEePZdYmJmCD4lpdwtWOpU82MZ/dx3DQImn17Fz7neqlk59nENsUA1XZZ
        INf0+YSWooxSbUDQ==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7BFBEA3B85;
        Tue, 23 Nov 2021 09:58:57 +0000 (UTC)
Date:   Tue, 23 Nov 2021 10:58:57 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     joao@overdrivepizza.com
cc:     nstange@suse.de, pmladek@suse.cz,
        Peter Zijlstra <peterz@infradead.org>, jpoimboe@redhat.com,
        joe.lawrence@redhat.com, live-patching@vger.kernel.org
Subject: Re: CET/IBT support and live-patches
In-Reply-To: <70828ca9f840960c7a3f66cd8dc141f5@overdrivepizza.com>
Message-ID: <alpine.LSU.2.21.2111231035460.15177@pobox.suse.cz>
References: <70828ca9f840960c7a3f66cd8dc141f5@overdrivepizza.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

[ adding more CCs ]

On Mon, 22 Nov 2021, joao@overdrivepizza.com wrote:

> Hi Miroslav, Petr and Nicolai,
> 
> Long time no talk, I hope you are all still doing great :)

Everything great here :)

> So, we have been cooking a few patches for enabling Intel CET/IBT support in
> the kernel. The way IBT works is -- whenever you have an indirect branch, the
> control-flow must land in an endbr instruction. The idea is to constrain
> control-flow in a way to make it harder for attackers to achieve meaningful
> computation through pointer/memory corruption (as in, an attacker that can
> corrupt a function pointer by exploiting a memory corruption bug won't be able
> to execute whatever piece of code, being restricted to jump into endbr
> instructions). To make the allowed control-flow graph more restrict, we are
> looking into how to minimize the number of endbrs in the final kernel binary
> -- meaning that if a function is never called indirectly, it shouldn't have an
> endbr instruction, thus increasing the security guarantees of the hardware
> feature.
> 
> Some ref about what is going on --
> https://lore.kernel.org/lkml/20211122170805.149482391@infradead.org/T/

Yes, I noticed something was happening again. There was a thread on this 
in February https://lore.kernel.org/all/20210207104022.GA32127@zn.tnic/ 
and some concerns were raised back then around fentry and int3 patching if 
I remember correctly. Is this still an issue?

> IIRC, live-patching used kallsyms/kallsyms_lookup_name for grabbing pointers
> to the symbols in the running kernel and then used these pointers to invoke
> the functions which reside outside of the live-patch (ie. previously existing
> functions). With the above IBT support, if these functions were considered
> non-indirectly-reachable, and were suppressed of an endbr, this would lead
> into a crash. I remember we were working on klp-convert to fix this through
> special relocations and that there were other proposals... but I'm not sure
> where it went.
>
> So, would you mind giving a quick update on the general state of this? If the
> IBT support would break this (and anything else) regarding live-patching...
> and so on?

Right. So, this really depends on how downstream consumers approach this. 
kpatch-build should be fine if I am not mistaken, because it uses the 
.klp.rela support we have in the kernel. We (at SUSE) have a problem, 
because we still exploit kallsyms/kallsyms_lookup_name to cope with this.

Joe, what is the current state of klp-convert? Do we still want to follow 
that way?

There was an idea a long time ago to actually rewrite all the relocations 
in a live patch module, so that they are relative to a well defined symbol 
(both in vmlinux and in modules. It would have to be created, I guess.). 
It would be easier tooling-wise and kernel module loader would process it 
like everything else. However, FGKASLR with all its reshuffling would 
render it useless. So something like klp-convert is needed.

Thanks

Miroslav
