Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE38D441CD6
	for <lists+live-patching@lfdr.de>; Mon,  1 Nov 2021 15:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhKAOxe (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 1 Nov 2021 10:53:34 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56310 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhKAOxe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Nov 2021 10:53:34 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 3667E212C4;
        Mon,  1 Nov 2021 14:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1635778259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S57HysUOBDmaPPkxy9xFNLNnV0qtuzg356ms8vO+zDs=;
        b=nLv/ytfioPKJ2E5inNqVfktlCIOh/RPq/TlUvEwD1rgVLFbnikQWvgIYm0r/+YenHEb510
        +FNTcadrc/mOf1cy8uwCKQFzWvFzNJzejuqTos3otALVjlqAO/6KIk7tU5rWWsiWl115uS
        1Bxs+rsKmQbL/dmXmw8WUxxmkKl2z7U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1635778259;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S57HysUOBDmaPPkxy9xFNLNnV0qtuzg356ms8vO+zDs=;
        b=iyf/3iVAxxHKP+6EEdNXf4jPP4/47uaCQuTqXGFTdNiJUg/ClccGZ5pHL+GGYn0EppdCQC
        bsi3/nLwLHHiOmCg==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8FBF4A3B83;
        Mon,  1 Nov 2021 14:50:58 +0000 (UTC)
Date:   Mon, 1 Nov 2021 15:50:58 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v1 0/5] Implement livepatch on PPC32
In-Reply-To: <cover.1635423081.git.christophe.leroy@csgroup.eu>
Message-ID: <alpine.LSU.2.21.2111011541380.22397@pobox.suse.cz>
References: <cover.1635423081.git.christophe.leroy@csgroup.eu>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

On Thu, 28 Oct 2021, Christophe Leroy wrote:

> This series implements livepatch on PPC32.
> 
> This is largely copied from what's done on PPC64.
> 
> Christophe Leroy (5):
>   livepatch: Fix build failure on 32 bits processors
>   powerpc/ftrace: No need to read LR from stack in _mcount()
>   powerpc/ftrace: Add module_trampoline_target() for PPC32
>   powerpc/ftrace: Activate HAVE_DYNAMIC_FTRACE_WITH_REGS on PPC32
>   powerpc/ftrace: Add support for livepatch to PPC32
> 
>  arch/powerpc/Kconfig                  |   2 +-
>  arch/powerpc/include/asm/livepatch.h  |   4 +-
>  arch/powerpc/kernel/module_32.c       |  33 +++++
>  arch/powerpc/kernel/trace/ftrace.c    |  53 +++-----
>  arch/powerpc/kernel/trace/ftrace_32.S | 187 ++++++++++++++++++++++++--
>  kernel/livepatch/core.c               |   4 +-
>  6 files changed, 230 insertions(+), 53 deletions(-)

thanks for the patch set!

I wondered whether the reliability of stack traces also applies to PPC32. 
This was obviously resolved by accdd093f260 ("powerpc: Activate 
HAVE_RELIABLE_STACKTRACE for all").

Did the patch set pass the selftests in 
tools/testing/selftests/livepatch/ ?

Regards

Miroslav
