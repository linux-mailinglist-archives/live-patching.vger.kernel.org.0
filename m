Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C61CE671EB9
	for <lists+live-patching@lfdr.de>; Wed, 18 Jan 2023 15:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjAROB0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 18 Jan 2023 09:01:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjAROBG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 18 Jan 2023 09:01:06 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33B78728C
        for <live-patching@vger.kernel.org>; Wed, 18 Jan 2023 05:35:01 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C840C3E8A6;
        Wed, 18 Jan 2023 13:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674048899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QCnYNYnWqyOf6SsgnfN+3NvmiwWWWcMIPO/+zLa7vz8=;
        b=CFL1Tbn+9B1XUEITTT5oqyp+CmA2J5JqKBwCRS9pg4ZArLGefr+ZV6I+rjFcFboUy0gxsO
        WClhJ7GqlVADAX8akYZF1k5c5QDutQc3M/58VLg39UcK0VUCxmMv9ooD7cseFhMopA2sF0
        G67mb6lPV0xBA5s5ZiEnqq+5FRhaj+o=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A39D42C141;
        Wed, 18 Jan 2023 13:34:59 +0000 (UTC)
Date:   Wed, 18 Jan 2023 14:34:59 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     Miroslav Benes <mbenes@suse.cz>, X86 ML <x86@kernel.org>,
        live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, joe.lawrence@redhat.com,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v8] livepatch: Clear relocation targets on a module
 removal
Message-ID: <Y8f1g62ouKsmjwpL@alley>
References: <20230106200109.2546997-1-song@kernel.org>
 <alpine.LSU.2.21.2301131012110.1565@pobox.suse.cz>
 <CAPhsuW6JKSYjfPab9k_SCtoPQMGTX2ZXkSTMnZEOCMf-yo29rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW6JKSYjfPab9k_SCtoPQMGTX2ZXkSTMnZEOCMf-yo29rg@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2023-01-13 11:55:25, Song Liu wrote:
> On Fri, Jan 13, 2023 at 1:18 AM Miroslav Benes <mbenes@suse.cz> wrote:
> >
> > Hi,
> >
> > On Fri, 6 Jan 2023, Song Liu wrote:
> >
> > > From: Miroslav Benes <mbenes@suse.cz>
> > >
> > > Josh reported a bug:
> > >
> > >   When the object to be patched is a module, and that module is
> > >   rmmod'ed and reloaded, it fails to load with:
> > >
> > >   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> > >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> > >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > >
> > >   The livepatch module has a relocation which references a symbol
> > >   in the _previous_ loading of nfsd. When apply_relocate_add()
> > >   tries to replace the old relocation with a new one, it sees that
> > >   the previous one is nonzero and it errors out.
> > >
> > >   On ppc64le, we have a similar issue:
> > >
> > >   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
> > >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> > >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > >
> > > He also proposed three different solutions. We could remove the error
> > > check in apply_relocate_add() introduced by commit eda9cec4c9a1
> > > ("x86/module: Detect and skip invalid relocations"). However the check
> > > is useful for detecting corrupted modules.
> > >
> > > We could also deny the patched modules to be removed. If it proved to be
> > > a major drawback for users, we could still implement a different
> > > approach. The solution would also complicate the existing code a lot.
> > >
> > > We thus decided to reverse the relocation patching (clear all relocation
> > > targets on x86_64). The solution is not
> > > universal and is too much arch-specific, but it may prove to be simpler
> > > in the end.
> > >
> > > Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> > > Signed-off-by: Song Liu <song@kernel.org>
> > > Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> >
> > I would be fine if you just claimed the authorship (and include my
> > Originally-by: tag for example), because you have reworked it quite a lot
> > since my first attempts.
> 
> I am ok with either way. Or maybe with
> 
> Co-developed-by: Song Liu <song@kernel.org>
> 
> >
> > > +int klp_apply_section_relocs(struct module *pmod, Elf_Shdr *sechdrs,
> > > +                          const char *shstrtab, const char *strtab,
> > > +                          unsigned int symndx, unsigned int secndx,
> > > +                          const char *objname)
> > > +{
> > > +     return klp_write_section_relocs(pmod, sechdrs, shstrtab, strtab, symndx,
> > > +                                     secndx, objname, true);
> > >  }

I think that I proposed this wrapper :-)

> > Is this redirection needed somewhere? You could just replace
> > klp_apply_section_relocs() with klp_write_section_relocs() in
> > include/linux/livepatch.h and kernel/module/main.c.
> >
> > It may be cleaned up later.
> 
> It might be a good practice to keep _write_ static in this file, and
> only expose _apply_ (maybe also _clear_ in the future)?

And I think that this was the reason. Also it looks better in
kernel/module/main.c in apply_relocations() that calls few more
*_apply_*reloc*() functions.

The idea is that functions with the same naming pattern do
the same operation. Also it is supposed to hide the true/false
parameter and self-explain the meaning by the function name.


> I don't have a strong preference either way.

I would prefer to keep the wrapper. But I do not resist on it :-)

Best Regards,
Petr
