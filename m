Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4A06692D3
	for <lists+live-patching@lfdr.de>; Fri, 13 Jan 2023 10:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233125AbjAMJ0n (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 13 Jan 2023 04:26:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232678AbjAMJZr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 13 Jan 2023 04:25:47 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263E918B3F
        for <live-patching@vger.kernel.org>; Fri, 13 Jan 2023 01:18:31 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 6238F3FEA2;
        Fri, 13 Jan 2023 09:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1673601509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NscoSNWLVGX6pZx+d/w/51/pGMDpuU/PeMsGBtDZckw=;
        b=ULHihY+VIJumm2qH12kbub+PJHYrPhUrV92EoGCrIqNbiMPan4vtw+8remaYVoe0YU4MgO
        wxqueISqyDObvz/sGI95WSCNbiPI9FY8eUhOyy/ofM/vUgueLVvQSPiAj3iyHcGDdSotLP
        Fwb4vKky6PzuhorUoZPFWKTbPElZC+Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1673601509;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NscoSNWLVGX6pZx+d/w/51/pGMDpuU/PeMsGBtDZckw=;
        b=FIQoT4Q5zkAIXfycZJdLO0EJ2rJkzXKF03vtXbKF0SPhO5y/Tkhnua2rGjeUDkzkl87hL3
        IU3e7qbom8lxGKAw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 356B42C141;
        Fri, 13 Jan 2023 09:18:29 +0000 (UTC)
Date:   Fri, 13 Jan 2023 10:18:33 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Song Liu <song@kernel.org>
cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, pmladek@suse.com, joe.lawrence@redhat.com,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v8] livepatch: Clear relocation targets on a module
 removal
In-Reply-To: <20230106200109.2546997-1-song@kernel.org>
Message-ID: <alpine.LSU.2.21.2301131012110.1565@pobox.suse.cz>
References: <20230106200109.2546997-1-song@kernel.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

On Fri, 6 Jan 2023, Song Liu wrote:

> From: Miroslav Benes <mbenes@suse.cz>
> 
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
>   On ppc64le, we have a similar issue:
> 
>   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
>   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
>   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
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
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Song Liu <song@kernel.org>
> Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>

I would be fine if you just claimed the authorship (and include my 
Originally-by: tag for example), because you have reworked it quite a lot 
since my first attempts.

> +int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> +			     const char *shstrtab, const char *strtab,
> +			     unsigned int symndx, unsigned int secndx,
> +			     const char *objname)
> +{
> +	return klp_write_section_relocs(pmod, sechdrs, shstrtab, strtab, symndx,
> +					secndx, objname, true);
>  }

Is this redirection needed somewhere? You could just replace 
klp_apply_section_relocs() with klp_write_section_relocs() in 
include/linux/livepatch.h and kernel/module/main.c.

It may be cleaned up later.

Acked-by: Miroslav Benes <mbenes@suse.cz>

It would be nice to get an Acked-by from a x86 maintainter as well.

Thanks
Miroslav
