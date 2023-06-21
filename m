Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C65737E86
	for <lists+live-patching@lfdr.de>; Wed, 21 Jun 2023 11:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbjFUIx1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 21 Jun 2023 04:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbjFUIxB (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 21 Jun 2023 04:53:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD59E60
        for <live-patching@vger.kernel.org>; Wed, 21 Jun 2023 01:53:00 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 387AF1F8D5;
        Wed, 21 Jun 2023 08:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1687337579; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gRK76ZXDozYLrRne9Ic7tlpT1a9Y2gP2/XLHYnpJnSk=;
        b=C/Cj9aW7Ra0bmWOEC2GcE/kTf16vaDzvL4O6eKTg8pTRLV775vrF2OFjiZJ+cWxfZUOABH
        DisWiF358rQBWq89c8Nuk2aJ0JTZjWE9/AyC2AGhIcZNtQM7sNqwi6L6aB0y7bp5bOuPa+
        Q77nRSrctfih0jEAezHBxHRwJScOQ6Q=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id C37F52C141;
        Wed, 21 Jun 2023 08:52:58 +0000 (UTC)
Date:   Wed, 21 Jun 2023 10:52:55 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <songliubraving@meta.com>
Cc:     Song Liu <song@kernel.org>,
        "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match
 symbols exactly
Message-ID: <ZJK5tiO3wXHiBeBh@alley>
References: <20230615170048.2382735-1-song@kernel.org>
 <3c0ea20b-fae7-af68-4c45-9539812ee198@huawei.com>
 <07E7B932-4FE1-4EEF-A7F7-ADA3EED5638F@fb.com>
 <b6af071b-ec26-850b-2652-b19b0b14bd4b@huawei.com>
 <CAPhsuW6nrQ-O3qL6TsR3rypEk03+X8z0-scGwO3Z5UAGz72Yzw@mail.gmail.com>
 <ZJA8yohmmf6fKsJQ@alley>
 <47E4EA81-717E-43A2-8D6D-E7E0F2569944@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47E4EA81-717E-43A2-8D6D-E7E0F2569944@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2023-06-20 22:36:14, Song Liu wrote:
> > On Jun 19, 2023, at 4:32 AM, Petr Mladek <pmladek@suse.com> wrote:
> > 
> > On Sun 2023-06-18 22:05:19, Song Liu wrote:
> >> On Sun, Jun 18, 2023 at 8:32 PM Leizhen (ThunderTown)
> >> <thunder.leizhen@huawei.com> wrote:
> 
> [...]
> 
> >>>>>> 
> >>>>>> @@ -195,7 +195,7 @@ static int compare_symbol_name(const char *name, char *namebuf)
> >>>>>> if (!ret)
> >>>>>> return ret;
> >>>>>> 
> >>>>>> - if (cleanup_symbol_name(namebuf) && !strcmp(name, namebuf))
> >>>>>> + if (!match_exactly && cleanup_symbol_name(namebuf) && !strcmp(name, namebuf))
> >>>>> 
> >>>>> This may affect the lookup of static functions.
> >>>> 
> >>>> I am not following why would this be a problem. Could you give an
> >>>> example of it?
> >>> 
> >>> Here are the comments in cleanup_symbol_name(). If the compiler adds a suffix to the
> >>> static function, but we do not remove the suffix, will the symbol match fail?
> >>> 
> >>>        /*
> >>>         * LLVM appends various suffixes for local functions and variables that
> >>>         * must be promoted to global scope as part of LTO.  This can break
> >>>         * hooking of static functions with kprobes. '.' is not a valid
> >>>         * character in an identifier in C. Suffixes observed:
> >>>         * - foo.llvm.[0-9a-f]+
> >>>         * - foo.[0-9a-f]+
> >>>         */
> >> 
> >> I think livepatch will not fail, as the tool chain should already match the
> >> suffix for the function being patched. If the tool chain failed to do so,
> >> livepatch can fail for other reasons (missing symbols, etc.)
> > 
> > cleanup_symbol_name() has been added by the commit 8b8e6b5d3b013b0bd8
> > ("kallsyms: strip ThinLTO hashes from static functions"). The
> > motivation is that user space tools pass the symbol names found
> > in sources. They do not know about the "random" suffix added
> > by the "random" compiler.
> 
> I am not quite sure how tracing tools would work without knowing about
> what the compiler did to the code. But I guess we are not addressing
> that part here.

I expect that the tracers access only symbols that are unique even
after removing the extra suffix.

Otherwise they would have the same problem even without suffix.
Each symbol create its own entry in kallsyms. There might be
more static symbols of the same name. This is why there is
"old_sympos" in struct klp_func. See also klp-convert,
https://lore.kernel.org/r/20230306140824.3858543-1-joe.lawrence@redhat.com

Fortunately, the same names are rare and "old_sympos" is used
only rarely. This is why it probably works for the tracers as well.


> > While livepatching might want to work with the full symbol names.
> > It helps to locate avoid duplication and find the right symbol.
> > 
> > At least, this should be beneficial for kpatch tool which works directly
> > with the generated symbols.
> > 
> > Well, in theory, the cleaned symbol names might be useful for
> > source-based livepatches. But there might be problem to
> > distinguish different symbols with the same name and symbols
> > duplicated because of inlining. Well, we tend to livepatch
> > the caller anyway.
> 
> I am not quite following the direction here. Do we need more 
> work for this patch?

Good question. I primary tried to add more details so that
we better understand the problem.

Honestly, I do not know the answer. I am neither familiar with
kpatch nor with clang. Let me think loudly.

kpatch produce livepatches by comparing binaries of the original
and fixed kernel. It adds a symbol into the livepatch when
the same symbol has different code in the two binaries.

So one important question is how clang generates the suffix.
Is the suffix the same in every build? Is it the same even
after the function gets modified by a fix?

If the suffix is always the same then then the full symbol name
would be better for kpatch. kpatch would get it for free.
And kpatch would not longer need to use "old_sympos".

But if the suffix is different then kpatch has a problem.
kpatch would need to match symbols with different suffixes.
It would be easy for symbols which are unique after removing
the suffix. But it would be tricky for comparing symbols
which do not have an unique name. kpatch would need to find
which suffix in the original binary matches an other suffix
in the fixed binary. In this case, it might be easier
to use the stripped symbol names.

And the suffix might be problematic also for source based
livepatches. They define struct klp_func in sources so
they would need to hardcode the suffix there. It might
be easy to keep using the stripped name and "old_sympos".

I expect that this patch actually breaks the livepatch
selftests when the kernel is compiled with clang LTO.

Best Regards,
Petr
