Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4277C45D01E
	for <lists+live-patching@lfdr.de>; Wed, 24 Nov 2021 23:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344172AbhKXWiO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 24 Nov 2021 17:38:14 -0500
Received: from gandalf.ozlabs.org ([150.107.74.76]:45447 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243451AbhKXWiJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 24 Nov 2021 17:38:09 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Hzwmw4294z4xbC;
        Thu, 25 Nov 2021 09:34:56 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1637793297;
        bh=VE6ywgXDc5ARYmbnjMdxfl9Cysjsei4YMDMFRtpcZs4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=EpMGMGimlu+zzxOMdQEPMnAXhvMm8RLamGGMuiFBurebn0lzKi3C9NzMK5Azx8J2R
         Ff4Mu3yqv2IK5vQNV7XsWbTcZNnLEeAumtYW6ozjHUJcrOrS6481iKV0FlrdKrGMW1
         y9sncSGXfuYobI89Kk1Vfx3rwEtuFSntMxvmE6uzysakUYUrIQyGnqoden90/EvBwM
         TRRwZvQNslddpkLGHvCVQ6gQVwm7xyNznkHDeDtcWzXNehN1fo+guPCtt4qeGN8IrF
         9FWzPy8Ec81vJ0du1BY668GonvjvqQz3npz6CYA7VT/xtmEd3xLyHzswoZmSdi3CC+
         /zePjev5c1jHQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     live-patching@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/5] Implement livepatch on PPC32
In-Reply-To: <cover.1635423081.git.christophe.leroy@csgroup.eu>
References: <cover.1635423081.git.christophe.leroy@csgroup.eu>
Date:   Thu, 25 Nov 2021 09:34:52 +1100
Message-ID: <87r1b5p4hf.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Christophe Leroy <christophe.leroy@csgroup.eu> writes:
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

I think we know patch 5 will need a respin because of the STRICT RWX vs
livepatching issue (https://github.com/linuxppc/issues/issues/375).

So should I take patches 2,3,4 for now?

cheers
