Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866E17355DF
	for <lists+live-patching@lfdr.de>; Mon, 19 Jun 2023 13:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjFSLci (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 19 Jun 2023 07:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjFSLch (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 19 Jun 2023 07:32:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF6D102
        for <live-patching@vger.kernel.org>; Mon, 19 Jun 2023 04:32:32 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id EE1C4218E1;
        Mon, 19 Jun 2023 11:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1687174350; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kBcDVB4DKRGLeI75Aj7b29t5pitvqF4tewNGIApogO8=;
        b=HiLV/kvzZU9an8u0lrXKAa04VdvYk4FxHpSCmduFurTSUFs/QRjiusaaQC1iEnrB3uENsB
        nYfPCQBVbvEus0q3Pn4iwKU+L4W65b+qHP3+q6sAKcwoIzoUjDr85uLg8wDUzvNjvM0I0y
        xomxxw2ukxJ9BQ4Z0KVtNIvPN34/ER0=
Received: from suse.cz (pmladek.tcp.ovpn2.prg.suse.de [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A736C2C141;
        Mon, 19 Jun 2023 11:32:30 +0000 (UTC)
Date:   Mon, 19 Jun 2023 13:32:26 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        Song Liu <songliubraving@meta.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match
 symbols exactly
Message-ID: <ZJA8yohmmf6fKsJQ@alley>
References: <20230615170048.2382735-1-song@kernel.org>
 <3c0ea20b-fae7-af68-4c45-9539812ee198@huawei.com>
 <07E7B932-4FE1-4EEF-A7F7-ADA3EED5638F@fb.com>
 <b6af071b-ec26-850b-2652-b19b0b14bd4b@huawei.com>
 <CAPhsuW6nrQ-O3qL6TsR3rypEk03+X8z0-scGwO3Z5UAGz72Yzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW6nrQ-O3qL6TsR3rypEk03+X8z0-scGwO3Z5UAGz72Yzw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun 2023-06-18 22:05:19, Song Liu wrote:
> On Sun, Jun 18, 2023 at 8:32 PM Leizhen (ThunderTown)
> <thunder.leizhen@huawei.com> wrote:
> >
> >
> >
> > On 2023/6/17 1:37, Song Liu wrote:
> > >
> > >
> > >> On Jun 16, 2023, at 2:31 AM, Leizhen (ThunderTown) <thunder.leizhen@huawei.com> wrote:
> > >>
> > >>
> > >>
> > >> On 2023/6/16 1:00, Song Liu wrote:
> > >>> With CONFIG_LTO_CLANG, kallsyms.c:cleanup_symbol_name() removes symbols
> > >>> suffixes during comparison. This is problematic for livepatch, as
> > >>> kallsyms_on_each_match_symbol may find multiple matches for the same
> > >>> symbol, and fail with:
> > >>>
> > >>>  livepatch: unresolvable ambiguity for symbol 'xxx' in object 'yyy'
> > >>>
> > >>> Make kallsyms_on_each_match_symbol() to match symbols exactly. Since
> > >>> livepatch is the only user of kallsyms_on_each_match_symbol(), this
> > >>> change is safe.
> > >>>
> > >>> Signed-off-by: Song Liu <song@kernel.org>
> > >>> ---
> > >>> kernel/kallsyms.c | 17 +++++++++--------
> > >>> 1 file changed, 9 insertions(+), 8 deletions(-)
> > >>>
> > >>> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> > >>> index 77747391f49b..2ab459b43084 100644
> > >>> --- a/kernel/kallsyms.c
> > >>> +++ b/kernel/kallsyms.c
> > >>> @@ -187,7 +187,7 @@ static bool cleanup_symbol_name(char *s)
> > >>> return false;
> > >>> }
> > >>>
> > >>> -static int compare_symbol_name(const char *name, char *namebuf)
> > >>> +static int compare_symbol_name(const char *name, char *namebuf, bool match_exactly)
> > >>> {
> > >>> int ret;
> > >>>
> > >>> @@ -195,7 +195,7 @@ static int compare_symbol_name(const char *name, char *namebuf)
> > >>> if (!ret)
> > >>> return ret;
> > >>>
> > >>> - if (cleanup_symbol_name(namebuf) && !strcmp(name, namebuf))
> > >>> + if (!match_exactly && cleanup_symbol_name(namebuf) && !strcmp(name, namebuf))
> > >>
> > >> This may affect the lookup of static functions.
> > >
> > > I am not following why would this be a problem. Could you give an
> > > example of it?
> >
> > Here are the comments in cleanup_symbol_name(). If the compiler adds a suffix to the
> > static function, but we do not remove the suffix, will the symbol match fail?
> >
> >         /*
> >          * LLVM appends various suffixes for local functions and variables that
> >          * must be promoted to global scope as part of LTO.  This can break
> >          * hooking of static functions with kprobes. '.' is not a valid
> >          * character in an identifier in C. Suffixes observed:
> >          * - foo.llvm.[0-9a-f]+
> >          * - foo.[0-9a-f]+
> >          */
> 
> I think livepatch will not fail, as the tool chain should already match the
> suffix for the function being patched. If the tool chain failed to do so,
> livepatch can fail for other reasons (missing symbols, etc.)

cleanup_symbol_name() has been added by the commit 8b8e6b5d3b013b0bd8
("kallsyms: strip ThinLTO hashes from static functions"). The
motivation is that user space tools pass the symbol names found
in sources. They do not know about the "random" suffix added
by the "random" compiler.

While livepatching might want to work with the full symbol names.
It helps to locate avoid duplication and find the right symbol.

At least, this should be beneficial for kpatch tool which works directly
with the generated symbols.

Well, in theory, the cleaned symbol names might be useful for
source-based livepatches. But there might be problem to
distinguish different symbols with the same name and symbols
duplicated because of inlining. Well, we tend to livepatch
the caller anyway.

Best Regards,
Petr
