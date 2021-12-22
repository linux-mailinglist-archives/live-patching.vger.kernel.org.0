Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BA347D37F
	for <lists+live-patching@lfdr.de>; Wed, 22 Dec 2021 15:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245649AbhLVOTW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Dec 2021 09:19:22 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:50806 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245647AbhLVOTW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Dec 2021 09:19:22 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id DE13B212B9;
        Wed, 22 Dec 2021 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1640182760; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zhr+Afm9qhm7LXnYhc731sR+IngmPtrNRK+NJVmgKNs=;
        b=xdk2jG0G0otlY+ZrBepZfL4FsYG+3amHldl6XT78E5OMXDCNt53VlsY/4KCA2iGJUbdyPb
        bKqXHEwQ1EMHkmMnofxOOyioayEurrupL+l/HHXnzXaTjI+TCZMo25//m8HN1si2ctz4fS
        anZS9KfAh5j3XE8d19HruXGvd6xixaw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1640182760;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zhr+Afm9qhm7LXnYhc731sR+IngmPtrNRK+NJVmgKNs=;
        b=Ke6NY5LDOqwezFEELCgm1wBttjIxKixV5PSmi3L6yOjKJMWiWNgKI0WPgaKRDjitu9dis3
        DH3vhMXF23LHzxDw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 8B234A3B81;
        Wed, 22 Dec 2021 14:19:20 +0000 (UTC)
Date:   Wed, 22 Dec 2021 15:19:20 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com,
        broonie@kernel.org, madvenka@linux.microsoft.com
Subject: Re: [PATCH v2 09/13] powerpc/ftrace: Implement
 CONFIG_DYNAMIC_FTRACE_WITH_ARGS
In-Reply-To: <5831f711a778fcd6eb51eb5898f1faae4378b35b.1640017960.git.christophe.leroy@csgroup.eu>
Message-ID: <alpine.LSU.2.21.2112221515020.18494@pobox.suse.cz>
References: <cover.1640017960.git.christophe.leroy@csgroup.eu> <5831f711a778fcd6eb51eb5898f1faae4378b35b.1640017960.git.christophe.leroy@csgroup.eu>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 20 Dec 2021, Christophe Leroy wrote:

> Implement CONFIG_DYNAMIC_FTRACE_WITH_ARGS. It accelerates the call
> of livepatching.
> 
> Also note that powerpc being the last one to convert to
> CONFIG_DYNAMIC_FTRACE_WITH_ARGS, it will now be possible to remove
> klp_arch_set_pc() on all architectures.

Correct. We could replace it ftrace_instruction_pointer_set() and that is 
it. In fact, livepatch.h in both arch/x86/include/asm/ and 
arch/s390/include/asm/ could be removed with that.

On the other hand, there is arm64 live patching support being worked on 
and I am not sure what their plans about DYNAMIC_FTRACE_WITH_ARGS are. The 
above would make it a prerequisite.

Adding CCs... you can find the whole thread at 
https://lore.kernel.org/all/cover.1640017960.git.christophe.leroy@csgroup.eu/

Miroslav
