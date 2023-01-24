Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01CC6797E3
	for <lists+live-patching@lfdr.de>; Tue, 24 Jan 2023 13:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbjAXMZO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 24 Jan 2023 07:25:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233889AbjAXMZN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 24 Jan 2023 07:25:13 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726D53C2A6;
        Tue, 24 Jan 2023 04:24:36 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 06BAC2188B;
        Tue, 24 Jan 2023 12:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674563058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LERYfcoY7Br0MatyvmWjDynukO2x4aKPQySf93qqKIo=;
        b=nIiZa9SAETllTox4m0UfwaOLX6w+mxKxwAjE2q16uaA8yDXcvpo4inB1fMhhwIFjYuOHN0
        DyH0+Pv7maDk+q3COtFKeeNhntCuIyQrLhuhvEiWstwMTPUNHZSp5Nl9LrCThczRb7xWHF
        +Zdtp3MmgQjGf78cVU0cG2cMx8IaulM=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id D3E172C141;
        Tue, 24 Jan 2023 12:24:17 +0000 (UTC)
Date:   Tue, 24 Jan 2023 13:24:15 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, x86@kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Subject: Re: [PATCH v10 2/2] livepatch,x86: Clear relocation targets on a
 module removal
Message-ID: <Y8/N7zMLUnMh259N@alley>
References: <20230121004945.697003-1-song@kernel.org>
 <20230121004945.697003-2-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230121004945.697003-2-song@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2023-01-20 16:49:45, Song Liu wrote:
> Josh reported a bug:
> 
>   When the object to be patched is a module, and that module is
>   rmmod'ed and reloaded, it fails to load with:
> 
>   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> 
>   The livepatch module has a relocation which references a symbol
>   in the _previous_ loading of nfsd. When apply_relocate_add()
>   tries to replace the old relocation with a new one, it sees that
>   the previous one is nonzero and it errors out.
> 
> He also proposed three different solutions. We could remove the error
> check in apply_relocate_add() introduced by commit eda9cec4c9a1
> ("x86/module: Detect and skip invalid relocations"). However the check
> is useful for detecting corrupted modules.
> 
> We could also deny the patched modules to be removed. If it proved to be
> a major drawback for users, we could still implement a different
> approach. The solution would also complicate the existing code a lot.
> 
> We thus decided to reverse the relocation patching (clear all relocation
> targets on x86_64). The solution is not
> universal and is too much arch-specific, but it may prove to be simpler
> in the end.
> 
> Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Originally-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Song Liu <song@kernel.org>
> Acked-by: Miroslav Benes <mbenes@suse.cz>
> 
> --- a/arch/x86/kernel/module.c
> +++ b/arch/x86/kernel/module.c
> @@ -129,22 +129,27 @@ int apply_relocate(Elf32_Shdr *sechdrs,
>  	return 0;
>  }
>  #else /*X86_64*/
> -static int __apply_relocate_add(Elf64_Shdr *sechdrs,
> +static int __write_relocate_add(Elf64_Shdr *sechdrs,
>  		   const char *strtab,
>  		   unsigned int symindex,
>  		   unsigned int relsec,
>  		   struct module *me,
> -		   void *(*write)(void *dest, const void *src, size_t len))
> +		   void *(*write)(void *dest, const void *src, size_t len),
> +		   bool apply)
>  {
>  	unsigned int i;
>  	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
>  	Elf64_Sym *sym;
>  	void *loc;
>  	u64 val;
> +	u64 zero = 0ULL;
>  
> -	DEBUGP("Applying relocate section %u to %u\n",
> +	DEBUGP("%s relocate section %u to %u\n",
> +	       apply ? "Applying" : "Clearing",
>  	       relsec, sechdrs[relsec].sh_info);
>  	for (i = 0; i < sechdrs[relsec].sh_size / sizeof(*rel); i++) {
> +		int size = 0;

The value 0 should never be used. It is better to do not initialize
it at all so that the compiler would warn when the variable might be
used uninitialized.

Note that this warning is not enabled by default. It can be enabled
with 

	$> make W=2 arch/x86/kernel/module.o

> +
>  		/* This is where to make the change */
>  		loc = (void *)sechdrs[sechdrs[relsec].sh_info].sh_addr
>  			+ rel[i].r_offset;

Otherwise, it looks good.

With the removed initialization, feel free to use:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr
