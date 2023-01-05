Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B56165EBD3
	for <lists+live-patching@lfdr.de>; Thu,  5 Jan 2023 14:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbjAENDi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Jan 2023 08:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234187AbjAEND1 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Jan 2023 08:03:27 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30F6458F9E
        for <live-patching@vger.kernel.org>; Thu,  5 Jan 2023 05:03:26 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DF44823E74;
        Thu,  5 Jan 2023 13:03:19 +0000 (UTC)
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C76222C143;
        Thu,  5 Jan 2023 13:03:07 +0000 (UTC)
Date:   Thu, 5 Jan 2023 14:03:05 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, joe.lawrence@redhat.com,
        Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v7] livepatch: Clear relocation targets on a module
 removal
Message-ID: <Y7bKiZsUG10wAkrW@alley>
References: <20221214174035.1012183-1-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214174035.1012183-1-song@kernel.org>
X-Spamd-Bar: +++++
Authentication-Results: smtp-out2.suse.de;
        dkim=none;
        dmarc=none;
        spf=fail (smtp-out2.suse.de: domain of pmladek@suse.com does not designate 149.44.160.134 as permitted sender) smtp.mailfrom=pmladek@suse.com
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [5.39 / 50.00];
         ARC_NA(0.00)[];
         R_SPF_FAIL(1.00)[-all];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.com];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         RCPT_COUNT_SEVEN(0.00)[7];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_NOT_FQDN(0.50)[]
X-Spam-Score: 5.39
X-Rspamd-Queue-Id: DF44823E74
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-12-14 09:40:35, Song Liu wrote:
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
> --- a/arch/x86/kernel/module.c
> +++ b/arch/x86/kernel/module.c
> @@ -163,40 +165,60 @@ static int __apply_relocate_add(Elf64_Shdr *sechdrs,
>  		case R_X86_64_NONE:
>  			break;
>  		case R_X86_64_64:
> -			if (*(u64 *)loc != 0)
> -				goto invalid_relocation;
> -			write(loc, &val, 8);
> +			if (apply) {
> +				if (*(u64 *)loc != 0)
> +					goto invalid_relocation;
> +				write(loc, &val, 8);
> +			} else {
> +				write(loc, &zero, 8);

It might make sense to check if the cleared value is the
expected one.

				if (*(u64 *)loc != (u64)val)
					goto invalid_relocation;
				write(loc, &zero, 8);

Maybe, we could put this into a helper function or macro that
would do this operation

#define check_and_write(loc, orig_val, new_val, type)	\
({							\
	int err = 0;					\
							\
	if (*(type)loc == (type)old_val)		\
		write(loc, &new_val, sizeof(type));	\
	else						\
		err = -EINVAL;				\
							\
	err;						\
})


It would make it more robust. The relocation might be different
when it it redirected somewhere, for example, by ftrace.
Something might go wrong in this case.

On the other hand. I wonder if the relocation might actually
by redirected intentionally, for example, by apply_alternatives()
or apply_retpolines(). These would be hard to check.

Best Regards,
Petr
