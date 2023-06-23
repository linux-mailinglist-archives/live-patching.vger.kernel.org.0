Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2626F73BE01
	for <lists+live-patching@lfdr.de>; Fri, 23 Jun 2023 19:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjFWRns (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 23 Jun 2023 13:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbjFWRnr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 23 Jun 2023 13:43:47 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0F152112
        for <live-patching@vger.kernel.org>; Fri, 23 Jun 2023 10:43:45 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id 6a1803df08f44-62ff1cdf079so7958596d6.0
        for <live-patching@vger.kernel.org>; Fri, 23 Jun 2023 10:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687542225; x=1690134225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J6pDsoKf41XC+vkXbEkJ9rVA3o9sl2SegA2QIdl4KVw=;
        b=IJyIW34rvbeUZURr3gAlijQhM/QFa81hQ8KFSiZjvkPpWFRWtNjvsSuIfbDJTKal/F
         X/cF8zpgClgHKfMSEk1fk+xHhCmkFpoubWnbHTW1blxpC3+K+mvVhjObsjFgx6moGwux
         RYygsvZE3b3MbhZisM4oAjOPJiWy6amF/at7s6UJDhPXCmNkc3NjwwLGEP82it3OVI4R
         7DEUkdRdOZ8x0btNwkAVJPQ3oogfeOdCfQR3J0uik+PZdQMs4ifKZty1DgK60wVtSsjd
         5d1XZQmYDu46BTp+3gPbkZsh81tyuwvIb9nycLYHrQk0KyO0YxQ0TSMD0opeozVgBn5+
         qT/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687542225; x=1690134225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J6pDsoKf41XC+vkXbEkJ9rVA3o9sl2SegA2QIdl4KVw=;
        b=j81KsaOtb9FdBYQqOREw02gtVr0TT2XiCLOFBcDMAc3Z5GoakoqeUDmDcygXN41pGm
         TviWzb7UCjqTbjaecPx6seXeXOrrIkQ79fBiKE1ep7DQF2PYciGhzLnN+tdviVdd4Jst
         17zuQFfpF6QLoMQGfc+NdJDdrRZwN+U7iBhMuQmFJwQyCuXnxXiDY3y3/o+iLg1Vy8rK
         3y4e49+l+Od888xa0FOw5EvksoSeK6dwzsiW+Cp9HUbqGCCxT3ftRt4HPy7cPqfY/Mar
         VvJUZP7dwmMDOTNsYSDtMh9GZf/kE+3zEHCJx8X2jBtPDoXBSAIyQxDYfOggb+RXthcc
         Ia+w==
X-Gm-Message-State: AC+VfDwc36qmaNQZMxJl7EQ1hDT1iDStkG2HJq9tfx1pJUrVou6894cu
        yqqodO0p7UtN3+4uFTEsBVDWQcqa2HWZAiAQAvXvhw==
X-Google-Smtp-Source: ACHHUZ6EQba0M8Miwr0ZM/1R64Td91CuaGOecGaJx2EsVCwHofEXUqrRE6cSfgtnuut5Tnivf5nGTTek1KyxWMGifnU=
X-Received: by 2002:a05:6214:5098:b0:630:1faa:a404 with SMTP id
 kk24-20020a056214509800b006301faaa404mr16206732qvb.39.1687542224760; Fri, 23
 Jun 2023 10:43:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230615170048.2382735-1-song@kernel.org> <3c0ea20b-fae7-af68-4c45-9539812ee198@huawei.com>
 <07E7B932-4FE1-4EEF-A7F7-ADA3EED5638F@fb.com> <b6af071b-ec26-850b-2652-b19b0b14bd4b@huawei.com>
 <CAPhsuW6nrQ-O3qL6TsR3rypEk03+X8z0-scGwO3Z5UAGz72Yzw@mail.gmail.com>
 <ZJA8yohmmf6fKsJQ@alley> <47E4EA81-717E-43A2-8D6D-E7E0F2569944@fb.com>
 <ZJK5tiO3wXHiBeBh@alley> <E47B9D18-299C-4F95-B4F6-24DB6A54A79F@fb.com>
 <6df9b18c-d152-942a-b618-bb8417c7b8cd@meta.com> <ZJROPO1ukwMyYFnm@alley> <3c1a953a-c77e-b38c-a7f8-15931ef2d6dd@meta.com>
In-Reply-To: <3c1a953a-c77e-b38c-a7f8-15931ef2d6dd@meta.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Fri, 23 Jun 2023 10:43:33 -0700
Message-ID: <CAKwvOdkvheeuF66LFAuVuYkO1cMM9ixasrmkBFpd=XSagEWgTQ@mail.gmail.com>
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match symbols exactly
To:     Yonghong Song <yhs@meta.com>
Cc:     Petr Mladek <pmladek@suse.com>, Song Liu <songliubraving@meta.com>,
        Song Liu <song@kernel.org>,
        "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        Jack Pham <jackp@codeaurora.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "KE.LI" <like1@oppo.com>,
        Padmanabha Srinivasaiah <treasure4paddy@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Pete Swain <swine@google.com>,
        clang-built-linux <llvm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jun 22, 2023 at 9:11=E2=80=AFAM Yonghong Song <yhs@meta.com> wrote:
>
>
>
> On 6/22/23 6:35 AM, Petr Mladek wrote:
> > Hi,
> >
> > I have added people mentioned in commits which modified
> > cleanup_symbol_name() in kallsyms.c.
> >
> > I think that stripping ".*" suffix does not work for static
> > variables defined locally from symbol does always work,
> > see below.
> >
> >
> >
> > On Wed 2023-06-21 15:34:27, Yonghong Song wrote:
> >> On 6/21/23 12:18 PM, Song Liu wrote:
> >>>> On Jun 21, 2023, at 1:52 AM, Petr Mladek <pmladek@suse.com> wrote:
> >>>> On Tue 2023-06-20 22:36:14, Song Liu wrote:
> >>>>>> On Jun 19, 2023, at 4:32 AM, Petr Mladek <pmladek@suse.com> wrote:
> >>>>>> On Sun 2023-06-18 22:05:19, Song Liu wrote:
> >>>>>>> On Sun, Jun 18, 2023 at 8:32=E2=80=AFPM Leizhen (ThunderTown)
> >>>>>>> <thunder.leizhen@huawei.com> wrote:
> >>>>> I am not quite following the direction here. Do we need more
> >>>>> work for this patch?
> >>>>
> >>>> Good question. I primary tried to add more details so that
> >>>> we better understand the problem.
> >>>>
> >>>> Honestly, I do not know the answer. I am neither familiar with
> >>>> kpatch nor with clang.
> >
> >>> This is pretty complicated.
> >>>
> >>> 1. clang with LTO does not use the suffix to eliminated duplicated
> >>> kallsyms, so old_sympos is still needed. Here is an example:
> >>>
> >>> # grep init_once /proc/kallsyms
> >>> ffffffff8120ba80 t init_once.llvm.14172910296636650566
> >>> ffffffff8120ba90 t inode_init_once
> >>> ffffffff813ea5d0 t bpf_user_rnd_init_once
> >>> ffffffff813fd5b0 t init_once.llvm.17912494158778303782
> >>> ffffffff813ffbf0 t init_once
> >>> ffffffff813ffc60 t init_once
> >>> ffffffff813ffc70 t init_once
> >>> ffffffff813ffcd0 t init_once
> >>> ffffffff813ffce0 t init_once
> >>>
> >>> There are two "init_once" with suffix, but there are also ones
> >>> without them.
> >>
> >> This is correct. At LTO mode, when a static function/variable
> >> is promoted to the global. The '.llvm.<hash>' is added to the
> >> static function/variable name to form a global function name.
> >> The '<hash>' here is computed based on IR of the compiled file
> >> before LTO. So if one file is not modified, then <hash>
> >> won't change after additional code change in other files.
> >
> > OK, so the ".llvm.<hash>" suffix is added when a symbol is promoted
> > from static to global. Right?
>
> Right at lest for llvm >=3D 15.
> There are an alternative format '.llvm.<file_path>' suffix with
> a more involved compilation process.
>
> https://github.com/llvm/llvm-project/blob/main/llvm/test/ThinLTO/X86/prom=
ote-local-name.ll
>
> But for kernel lto build, yes, only '.llvm.<hash>'.
>
> >
> >>> 2. kpatch-build does "Building original source", "Building patched
> >>> source", and then do binary diff of the two. From our experiments,
> >>> the suffix doesn't change between the two builds. However, we need
> >>> to match the build environment (path of kernel source, etc.) to
> >>> make sure suffix from kpatch matches the kernel.
> >>
> >> The goal here is to generate the same IR (hence <hash>) if
> >> file content is not changed. This way, <hash> value will
> >> change only for those changed files.
> >
> > Hmm, how does kpatch match the fixed functions? They are modified
> > so that they should get different IR (hash). Or do I miss
> > anything, please?
>
> If the static function are promoted to global function and the file
> containing static function changed, then that modified static
> function will appear to be a *new* function. Live change should
> be able to do it, right?
>
> >
> >>> 3. The goal of this patch is NOT to resolve different suffix by
> >>> llvm (.llvm.[0-9]+). Instead, we are trying fix issues like:
> >>>
> >>> #  grep bpf_verifier_vlog /proc/kallsyms
> >>> ffffffff81549f60 t bpf_verifier_vlog
> >>> ffffffff8268b430 d bpf_verifier_vlog._entry
> >>> ffffffff8282a958 d bpf_verifier_vlog._entry_ptr
> >>> ffffffff82e12a1f d bpf_verifier_vlog.__already_done
> >
> > And <function>.<symbol> notation seems to be used for static symbols
> > defined inside a function.
>
> That is correct.
>
> >
> > I guess that it is used when the symbols stay statics. It would
> > probably get additional ".llvm.<hash>" when it got promoted
> > from static to global. But this probably never happens.
>
> I have not see a case like this yet.
>
> >
> > Do I get it correctly?
>
> yes, that is correct.
>
> >
> > It means that we have two different types of name changes:
> >
> >    1. .llvm.<hash> suffix
> >
> >       If we remove this suffix then we will not longer distinguish
> >       symbols which stayed static and which were promoted to global
> >       ones.
> >
> >       The result should be basically the same as without LTO.
> >       Some symbols might have duplicated name. But most symbols
> >       would have an unique one.
> >
> >
> >    2. <function>.<symbol> name
> >
> >       In this case, <symbol> is _not_ suffix. It is actually
> >       the original symbol name.
> >
> >       The extra thing is the <function>. prefix.
> >
> >       These static variables seem to have special handling even
> >       with gcc without LTO. gcc adds an extra id instead,
> >       for example:
> >
> >       $> nm vmlinux | grep " _entry_ptr" | head
> >       ffffffff82a2e800 d _entry_ptr.100135
> >       ffffffff82a2e7f8 d _entry_ptr.100178
> >       ffffffff82a32e70 d _entry_ptr.100798
> >       ffffffff82a1e240 d _entry_ptr.10342
> >       ffffffff82a33930 d _entry_ptr.104764
> >       ffffffff82a339c8 d _entry_ptr.104830
> >       ffffffff82a33928 d _entry_ptr.104871
> >       ffffffff82a33920 d _entry_ptr.104877
> >       ffffffff82a33918 d _entry_ptr.104893
> >       ffffffff82a339c0 d _entry_ptr.104905
> >
> >       $> nm vmlinux | grep panic_console_dropped
> >       ffffffff853618e0 b panic_console_dropped.54158
>
> IIRC, yes, these 'id' might change if source code changed.
>
> >
> >
> > Effect from the tracers POV?
> >
> >    1. .llvm.<hash> suffix
> >
> >       The names without the .llvm.<hash> suffix are the same as without
> >       LTO. This is probably why commit 8b8e6b5d3b013b0b ("kallsyms: str=
ip
> >       ThinLTO hashes from static functions") worked. The tracers probab=
ly
> >       wanted to access only the symbols with uniqueue names
> >
> >
> >    2. <function>.<symbol> name
> >
> >       The name without the .<symbol> suffix is the same as the function
> >       name. The result are duplicated function names.
> >
> >       I do not understand why this was not a problem for tracers.
> >       Note that this is pretty common. _entry and _entry_ptr are
> >       added into any function calling printk().
> >
> >       It seems to be working only by chance. Maybe, the tracers always
> >       take the first matched symbol. And the function name, without
> >       any suffix, is always the first one in the sorted list.
>
> Note this only happens in LTO mode. Maybe lto kernel is not used
> wide enough to discover this issue?

Likely.

>
> >
> >
> > Effect from livepatching POV:
> >
> >    1. .llvm.<hash> suffix
> >
> >        Comparing the full symbol name looks fragile to me because
> >        the <hash> might change.
> >
> >        IMHO, it would be better to compare the names without
> >        the .llvm.<hash> suffix even for livepatches.
> >
> >
> >     2. <function>.<symbol> name
> >
> >        The removal of <.symbol> suffix is a bad idea. The livepatch
> >        code is not able to distinguish the symbol of the <function>
> >        and static variables defined in this function.
> >
> >        IMHO, it would be better to compare the full
> >         <function>.<symbol> name.
> >
> >
> > Result:
> >
> > IMHO, cleanup_symbol_name() should remove only .llwn.* suffix.
> > And it should be used for both tracers and livepatching.
> >
> > Does this makes any sense?
>
> Song, does this fix the problem?
>
> I only checked llvm15 and llvm17, not sure what kind of
> suffix'es used for early llvm (>=3D llvm11).
> Nick, could you help answer this question? What kind
> of suffix are used for lto when promoting a local symbol
> to a global one, considering all versions of llvm >=3D 11
> since llvm 11 is the minimum supported version for kernel build.

For ToT for this case, the call chain backtrace looks like:

ModuleSummaryIndex::getGlobalNameForLocal
FunctionImportGlobalProcessing::getPromotedName
FunctionImportGlobalProcessing::processGlobalForThinLTO

This has been the case since release/11.x.

LLVM uses different mangling schemes for different places. For
example, function specialization (that occurs when sinking a constant
into a function) may rename a function from foo to something like
foo.42 where a dot followed by a monotonically increasing counter is
used. Numbers before may be missing from other symbols (where's .41?)
if they are DCE'd (perhaps because they were inlined and have no more
callers).  That is done by:

ValueSymbolTable::makeUniqueName which is eventually called by
FunctionSpecializer::createSpecialization.

That is the cause of common warnings from modpost.

There are likely numerous other special manglings done through llvm.
The above two are slightly more generic, but other passes may do
something more ad-hoc.

>
> >
> > Best Regards,
> > Petr



--=20
Thanks,
~Nick Desaulniers
