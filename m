Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC9A4E9273
	for <lists+live-patching@lfdr.de>; Mon, 28 Mar 2022 12:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240195AbiC1K0S (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 28 Mar 2022 06:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbiC1K0S (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 28 Mar 2022 06:26:18 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407F833E85;
        Mon, 28 Mar 2022 03:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=cowTe1SqlS2BOdGmzt26WP+/bS7/jiiuXA3bfaFKWco=; b=ike4utfUXfV67i9TA6zdOS8mNs
        frOWZK9ja5kR0DpwP2JZsKKcNlTXAUWQgTNZ1PxZmZfw0P/YO4O/xLGx4RTU8nsHY++w4ymxFWYD3
        GjLUJ0y8HErEb9MprHuxSla+Xq+Eb/H7h6PQlsvB1uCdbY73ven3GlV0Voax5vXsvDW0ruCm8WeG0
        N2LAVDx0zAeehFxBZZ9fniVMQhP1aAkQEjDvKV3usfXWZvIb5zDb8u4euUSKx9RKjnVrbvsyuyfh4
        6u67ITXkcXlrq/vYwqH/VfRTyejXlP9ltIRIapq5WAxHu76zGm8dr4gqalhJy5Fh9LrVF4zSpbBJh
        c7ulFH3w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nYmXI-00GoqY-SQ; Mon, 28 Mar 2022 10:23:45 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 3D6BC9861F5; Mon, 28 Mar 2022 12:23:42 +0200 (CEST)
Date:   Mon, 28 Mar 2022 12:23:42 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] livepatch: Remove klp_arch_set_pc() and asm/livepatch.h
Message-ID: <20220328102342.GW8939@worktop.programming.kicks-ass.net>
References: <e029c7cfde436f6bbf99148ab14dc2da99add503.1648447981.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e029c7cfde436f6bbf99148ab14dc2da99add503.1648447981.git.christophe.leroy@csgroup.eu>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, Mar 28, 2022 at 08:26:48AM +0200, Christophe Leroy wrote:
> All three versions of klp_arch_set_pc() do exactly the same: they
> call ftrace_instruction_pointer_set().
> 
> Call ftrace_instruction_pointer_set() directly and remove
> klp_arch_set_pc().
> 
> As klp_arch_set_pc() was the only thing remaining in asm/livepatch.h
> on x86 and s390, remove asm/livepatch.h
> 
> livepatch.h remains on powerpc but its content is exclusively used
> by powerpc specific code.

The only remaining thing seems to be a klp_init_thread_info() for ppc64,
but yeah..

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> diff --git a/kernel/livepatch/patch.c b/kernel/livepatch/patch.c
> index c172bf92b576..4c4f5a776d80 100644
> --- a/kernel/livepatch/patch.c
> +++ b/kernel/livepatch/patch.c
> @@ -118,7 +118,7 @@ static void notrace klp_ftrace_handler(unsigned long ip,
>  	if (func->nop)
>  		goto unlock;
>  
> -	klp_arch_set_pc(fregs, (unsigned long)func->new_func);
> +	ftrace_instruction_pointer_set(fregs, (unsigned long)func->new_func);
>  
>  unlock:
>  	ftrace_test_recursion_unlock(bit);

So ptrace has instruction_pointer_set(), I'm not sure why we have yet
another variant in the ftrace_ namespace. Perhaps also delete that?
