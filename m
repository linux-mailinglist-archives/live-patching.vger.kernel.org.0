Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662F9586755
	for <lists+live-patching@lfdr.de>; Mon,  1 Aug 2022 12:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiHAKZF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 1 Aug 2022 06:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiHAKZE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 1 Aug 2022 06:25:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A6713DD4;
        Mon,  1 Aug 2022 03:25:03 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E9DD86124F;
        Mon,  1 Aug 2022 10:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659349501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QJL7yh9qb++H0PmmxKnrcUkjMVoDhypcV5pn4a84vOw=;
        b=q8V89UoHd1DLwoOygs/cYLVvlO6obomnxieeZ/KzTSHx8sXx3Uduqi+2mJ72pLanLgwvva
        fmIorNesi3FrMZHMLWrUYoWlKzgT+D5t4FJkNq5aTpkFo++GkbnSNANxiAwgV38eNXF3Ts
        l4qSw4cwOqXyOa25IFIg8Q4UHDFBiSE=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C84872C141;
        Mon,  1 Aug 2022 10:25:01 +0000 (UTC)
Date:   Mon, 1 Aug 2022 12:24:58 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        live-patching@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        X86 ML <x86@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v3] livepatch: Clear relocation targets on a module
 removal
Message-ID: <Yuep+uKnDc0L2ICi@alley>
References: <20220721175147.214642-1-song@kernel.org>
 <20220726233302.zwloxsammnu7clu4@treble>
 <CAPhsuW7tmRt=yx1+i62HPRJJ4Gp8xB_3XvpVxUC=SyGv6iCBEQ@mail.gmail.com>
 <CAPhsuW4F8f9GLHF9C54oWyFiyJ0eT5HOwfhmoxSJ3HeRr8zCSw@mail.gmail.com>
 <CAPhsuW4VFjyoYta6fEGXg4S1dbg8ynkdKZzuwYSp3FMEGPP0aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW4VFjyoYta6fEGXg4S1dbg8ynkdKZzuwYSp3FMEGPP0aA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sat 2022-07-30 20:20:22, Song Liu wrote:
> On Sat, Jul 30, 2022 at 3:32 PM Song Liu <song@kernel.org> wrote:
> >
> > On Tue, Jul 26, 2022 at 8:54 PM Song Liu <song@kernel.org> wrote:
> > >
> > > On Tue, Jul 26, 2022 at 4:33 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > > >
> > > > On Thu, Jul 21, 2022 at 10:51:47AM -0700, Song Liu wrote:
> > > > > From: Miroslav Benes <mbenes@suse.cz>
> > > > >
> > > > > Josh reported a bug:
> > > > >
> > > > >   When the object to be patched is a module, and that module is
> > > > >   rmmod'ed and reloaded, it fails to load with:
> > > > >
> > > > >   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> > > > >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> > > > >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > > > >
> > > > >   The livepatch module has a relocation which references a symbol
> > > > >   in the _previous_ loading of nfsd. When apply_relocate_add()
> > > > >   tries to replace the old relocation with a new one, it sees that
> > > > >   the previous one is nonzero and it errors out.
> > > > >
> > > > >   On ppc64le, we have a similar issue:
> > > > >
> > > > >   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
> > > > >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> > > > >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> > > > >
> > > > 3) A selftest would be a good idea.
> > >
> >
> > I found it is pretty tricky to run the selftests inside a qemu VM. How about
> > we test it with modules in samples/livepatch? Specifically, we can add a
> > script try to reload livepatch-shadow-mod.ko.
> 
> Actually, livepatch-shadow-mod.ko doesn't have the reload problem before
> the fix. Is this expected?

Good question. I am afraid that there is no easy way to prepare
the selftest at the moment.

There are two situations when a symbol from the livepatched module is
relocated:


1. The livepatch might access a symbol exported by the module via
   EXPORT_SYMBOL(). In this case, it is "normal" external symbol
   and it gets relocated by the module loader.

   But EXPORT_SYMBOL() will create an explicit dependency between the
   livepatch and livepatched module. As a result, the livepatch
   module could be loaded only when the livepatched module is loaded.
   And the livepatched module could not be removed when the livepatch
   module is loaded.

   In this case, the problem will not exist. Well, the developers
   of the livepatch module will probably want to avoid this
   dependency.


2. The livepatch module might access a non-exported symbol from another
   module using the special elf section for klp relocation, see
   section, see Documentation/livepatch/module-elf-format.rst

   These symbols are relocated in klp_apply_section_relocs().

   The problem is that upstream does not have a support to
   create this elf section. There is a patchset for this, see
   https://lore.kernel.org/all/20220216163940.228309-1-joe.lawrence@redhat.com/
   It requires some more review.


Resume: I think that we could not prepare the selftest without
	upstreaming klp-convert tool.

Best Regards,
Petr
