Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9D7F671E01
	for <lists+live-patching@lfdr.de>; Wed, 18 Jan 2023 14:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjARNfr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 18 Jan 2023 08:35:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjARNfU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 18 Jan 2023 08:35:20 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7655EAA5CD
        for <live-patching@vger.kernel.org>; Wed, 18 Jan 2023 05:02:51 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 2BD263F6FC;
        Wed, 18 Jan 2023 13:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674046970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HDumPFkLRnjxKj5Eymq437UKAXQ3huCxhX35sk7YbpQ=;
        b=cxGRjTG3cEMADgBSsgtUH6YbzBzHRfsjsIuf0GpoWLFVDVp+63cKnAV8p/qqI+w0gsMo8R
        MheCySAnkWIQOaYwMB3go5QQRtB2M5vEQPqOFS3wYKnSnMpeaEr2K42eS2UcUsH2DrhCzn
        wRSCuaazPf5hRXI5VhJed1uBjmDMbbY=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 098642C141;
        Wed, 18 Jan 2023 13:02:50 +0000 (UTC)
Date:   Wed, 18 Jan 2023 14:02:47 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, joe.lawrence@redhat.com,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v8] livepatch: Clear relocation targets on a module
 removal
Message-ID: <Y8ft97xn7F92oWyn@alley>
References: <20230106200109.2546997-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106200109.2546997-1-song@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2023-01-06 12:01:09, Song Liu wrote:
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
> We thus decided to reverse the relocation patching (clear all relocation
> targets on x86_64). The solution is not
> universal and is too much arch-specific, but it may prove to be simpler
> in the end.
> 
> --- a/arch/x86/kernel/module.c
> +++ b/arch/x86/kernel/module.c
> @@ -162,56 +167,53 @@ static int __apply_relocate_add(Elf64_Shdr *sechdrs,
>  
>  		switch (ELF64_R_TYPE(rel[i].r_info)) {
>  		case R_X86_64_NONE:
> -			break;
> +			continue;  /* nothing to write */
>  		case R_X86_64_64:
> -			if (*(u64 *)loc != 0)
> -				goto invalid_relocation;
> -			write(loc, &val, 8);
> +			write_size = 8;
>  			break;
>  		case R_X86_64_32:
> -			if (*(u32 *)loc != 0)
> -				goto invalid_relocation;
> -			write(loc, &val, 4);
> -			if (val != *(u32 *)loc)
> +			if (val != *(u32 *)&val)
>  				goto overflow;
>  			break;
>  		case R_X86_64_32S:
> -			if (*(s32 *)loc != 0)
> -				goto invalid_relocation;
> -			write(loc, &val, 4);
> -			if ((s64)val != *(s32 *)loc)
> +			if ((s64)val != *(s32 *)&val)
>  				goto overflow;
>  			break;
>  		case R_X86_64_PC32:
>  		case R_X86_64_PLT32:
> -			if (*(u32 *)loc != 0)
> -				goto invalid_relocation;
> -			val -= (u64)loc;
> -			write(loc, &val, 4);
>  #if 0
> -			if ((s64)val != *(s32 *)loc)
> +			if ((s64)val != *(s32 *)&val)
>  				goto overflow;

This is supposed to check the to-be-written value.

>  #endif
> +			val -= (u64)loc;

This is modifying the to-be-written value. It should be computed before
the overflow check.

I know that the check is not really compiled in but we should
not break it.


>  			break;

Otherwise, it looks fine.


Now, I agree with Miroslav that we should get an approval from x86
maintainers. Sigh, I think that I have already asked for this earlier:

!!! Please add x86@kernel.org and linux-kernel@vger.kernel.org at
minimum into CC when sending V9 !!!

The more people know about this change the better. And it is really
important to make maintainers of the touched subsystem aware of
proposed changes.

It is a good practice to add people that are printed by
./scripts/get_maintainer.pl. In this case, it is:

$> ./scripts/get_maintainer.pl arch/x86/kernel/module.c 
Thomas Gleixner <tglx@linutronix.de> (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT),authored:2/12=17%,added_lines:24/74=32%,removed_lines:5/26=19%)
Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Borislav Petkov <bp@alien8.de> (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT),commit_signer:4/12=33%)
Dave Hansen <dave.hansen@linux.intel.com> (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
"H. Peter Anvin" <hpa@zytor.com> (reviewer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
Peter Zijlstra <peterz@infradead.org> (commit_signer:8/12=67%,authored:4/12=33%,added_lines:41/74=55%,removed_lines:8/26=31%)
Kees Cook <keescook@chromium.org> (commit_signer:4/12=33%)
Greg Kroah-Hartman <gregkh@linuxfoundation.org> (commit_signer:3/12=25%)
"Jason A. Donenfeld" <Jason@zx2c4.com> (commit_signer:3/12=25%,authored:3/12=25%,removed_lines:3/26=12%)
Julian Pidancet <julian.pidancet@oracle.com> (authored:1/12=8%,added_lines:5/74=7%,removed_lines:6/26=23%)
Ard Biesheuvel <ardb@kernel.org> (authored:1/12=8%,removed_lines:3/26=12%)
linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT))

Best Regards,
Petr
