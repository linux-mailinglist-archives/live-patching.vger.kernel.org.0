Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB97227E87
	for <lists+live-patching@lfdr.de>; Tue, 21 Jul 2020 13:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729469AbgGULRD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 21 Jul 2020 07:17:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:57182 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728159AbgGULRC (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 21 Jul 2020 07:17:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DFB29AFF8;
        Tue, 21 Jul 2020 11:17:07 +0000 (UTC)
Date:   Tue, 21 Jul 2020 13:17:00 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] Revert "kbuild: use -flive-patching when CONFIG_LIVEPATCH
 is enabled"
In-Reply-To: <696262e997359666afa053fe7d1a9fb2bb373964.1595010490.git.jpoimboe@redhat.com>
Message-ID: <alpine.LSU.2.21.2007211316410.31851@pobox.suse.cz>
References: <696262e997359666afa053fe7d1a9fb2bb373964.1595010490.git.jpoimboe@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 17 Jul 2020, Josh Poimboeuf wrote:

> Use of the new -flive-patching flag was introduced with the following
> commit:
> 
>   43bd3a95c98e ("kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled")
> 
> This flag has several drawbacks:
> 
> - It disables some optimizations, so it can have a negative effect on
>   performance.
> 
> - According to the GCC documentation it's not compatible with LTO, which
>   will become a compatibility issue as LTO support gets upstreamed in
>   the kernel.
> 
> - It was intended to be used for source-based patch generation tooling,
>   as opposed to binary-based patch generation tooling (e.g.,
>   kpatch-build).  It probably should have at least been behind a
>   separate config option so as not to negatively affect other livepatch
>   users.
> 
> - Clang doesn't have the flag, so as far as I can tell, this method of
>   generating patches is incompatible with Clang, which like LTO is
>   becoming more mainstream.
> 
> - It breaks GCC's implicit noreturn detection for local functions.  This
>   is the cause of several "unreachable instruction" objtool warnings.
> 
> - The broken noreturn detection is an obvious GCC regression, but we
>   haven't yet gotten GCC developers to acknowledge that, which doesn't
>   inspire confidence in their willingness to keep the feature working as
>   optimizations are added or changed going forward.
> 
> - While there *is* a distro which relies on this flag for their distro
>   livepatch module builds, there's not a publicly documented way to
>   create safe livepatch modules with it.  Its use seems to be based on
>   tribal knowledge.  It serves no benefit to those who don't know how to
>   use it.
> 
>   (In fact, I believe the current livepatch documentation and samples
>   are misleading and dangerous, and should be corrected.  Or at least
>   amended with a disclaimer.  But I don't feel qualified to make such
>   changes.)
> 
> Also, we have an idea for using objtool to detect function changes,
> which could potentially obsolete the need for this flag anyway.
> 
> At this point the flag has no benefits for upstream which would
> counteract the above drawbacks.  Revert it until it becomes more ready.
> 
> This reverts commit 43bd3a95c98e1a86b8b55d97f745c224ecff02b9.
> 
> Fixes: 43bd3a95c98e ("kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>

Acked-by: Miroslav Benes <mbenes@suse.cz>

M
