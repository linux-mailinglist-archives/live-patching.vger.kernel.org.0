Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C074D734B37
	for <lists+live-patching@lfdr.de>; Mon, 19 Jun 2023 07:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjFSFFi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 19 Jun 2023 01:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjFSFFg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 19 Jun 2023 01:05:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10F2E49
        for <live-patching@vger.kernel.org>; Sun, 18 Jun 2023 22:05:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 554F760EB0
        for <live-patching@vger.kernel.org>; Mon, 19 Jun 2023 05:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4885C433CC
        for <live-patching@vger.kernel.org>; Mon, 19 Jun 2023 05:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687151133;
        bh=BdChavIMjU/MF0Gq1cmD5MynIUy19zBRMsLpGpNxsl4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OxQXCVMSVOpos0nnPLy4AoPgcpAFC7/MV387rZEVtNvbZno6l/0rOh0QgWCZRCqk+
         wV8Y6tJ6dlObwLzqmcLZvS4Fz8Vyi9hlBMu7Ib9zfXmzYjtj2bv9gFLLqEcGOasX2F
         CvzUE72xs5DzJvDp3mr9F3w/m+yOsOFNunZt89cjHayEKY1mK3q/uKZ8dGnBwhB9VZ
         yraEvnYXhtMyD/rriMq9lSecSdwfPHdUk+eZJ4iWwbuft7OCX8ObSUFu08gxqIVEOr
         yTBxFpoHwMbnaNRCq6AgtlCl2jOkptyWuZfSJFLcs5Wb1mPo6g5PMbCM+6nv284tlh
         kRYVcnu9kPJBw==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2b46f1256bbso14560131fa.0
        for <live-patching@vger.kernel.org>; Sun, 18 Jun 2023 22:05:33 -0700 (PDT)
X-Gm-Message-State: AC+VfDy5yhkqBAqvwjbnfKU+76HE8nrjVUGzGVaDmE5YLDmlJAQhiTLG
        3/LKmfpB2HitYK73xFgPRbqi7TWZY3qxXRM5KHw=
X-Google-Smtp-Source: ACHHUZ6PcA3Uc6HD/JNvZVkEp1m2dD4csU2/OZAPtUmvABEDhHUuVhHy7onJcoKY47clOmmgcF6/LUSPzmiVPwPAgNE=
X-Received: by 2002:a05:6512:3d12:b0:4f7:557b:fca4 with SMTP id
 d18-20020a0565123d1200b004f7557bfca4mr5355900lfv.26.1687151131630; Sun, 18
 Jun 2023 22:05:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230615170048.2382735-1-song@kernel.org> <3c0ea20b-fae7-af68-4c45-9539812ee198@huawei.com>
 <07E7B932-4FE1-4EEF-A7F7-ADA3EED5638F@fb.com> <b6af071b-ec26-850b-2652-b19b0b14bd4b@huawei.com>
In-Reply-To: <b6af071b-ec26-850b-2652-b19b0b14bd4b@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Sun, 18 Jun 2023 22:05:19 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6nrQ-O3qL6TsR3rypEk03+X8z0-scGwO3Z5UAGz72Yzw@mail.gmail.com>
Message-ID: <CAPhsuW6nrQ-O3qL6TsR3rypEk03+X8z0-scGwO3Z5UAGz72Yzw@mail.gmail.com>
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match symbols exactly
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Song Liu <songliubraving@meta.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun, Jun 18, 2023 at 8:32=E2=80=AFPM Leizhen (ThunderTown)
<thunder.leizhen@huawei.com> wrote:
>
>
>
> On 2023/6/17 1:37, Song Liu wrote:
> >
> >
> >> On Jun 16, 2023, at 2:31 AM, Leizhen (ThunderTown) <thunder.leizhen@hu=
awei.com> wrote:
> >>
> >>
> >>
> >> On 2023/6/16 1:00, Song Liu wrote:
> >>> With CONFIG_LTO_CLANG, kallsyms.c:cleanup_symbol_name() removes symbo=
ls
> >>> suffixes during comparison. This is problematic for livepatch, as
> >>> kallsyms_on_each_match_symbol may find multiple matches for the same
> >>> symbol, and fail with:
> >>>
> >>>  livepatch: unresolvable ambiguity for symbol 'xxx' in object 'yyy'
> >>>
> >>> Make kallsyms_on_each_match_symbol() to match symbols exactly. Since
> >>> livepatch is the only user of kallsyms_on_each_match_symbol(), this
> >>> change is safe.
> >>>
> >>> Signed-off-by: Song Liu <song@kernel.org>
> >>> ---
> >>> kernel/kallsyms.c | 17 +++++++++--------
> >>> 1 file changed, 9 insertions(+), 8 deletions(-)
> >>>
> >>> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> >>> index 77747391f49b..2ab459b43084 100644
> >>> --- a/kernel/kallsyms.c
> >>> +++ b/kernel/kallsyms.c
> >>> @@ -187,7 +187,7 @@ static bool cleanup_symbol_name(char *s)
> >>> return false;
> >>> }
> >>>
> >>> -static int compare_symbol_name(const char *name, char *namebuf)
> >>> +static int compare_symbol_name(const char *name, char *namebuf, bool=
 match_exactly)
> >>> {
> >>> int ret;
> >>>
> >>> @@ -195,7 +195,7 @@ static int compare_symbol_name(const char *name, =
char *namebuf)
> >>> if (!ret)
> >>> return ret;
> >>>
> >>> - if (cleanup_symbol_name(namebuf) && !strcmp(name, namebuf))
> >>> + if (!match_exactly && cleanup_symbol_name(namebuf) && !strcmp(name,=
 namebuf))
> >>
> >> This may affect the lookup of static functions.
> >
> > I am not following why would this be a problem. Could you give an
> > example of it?
>
> Here are the comments in cleanup_symbol_name(). If the compiler adds a su=
ffix to the
> static function, but we do not remove the suffix, will the symbol match f=
ail?
>
>         /*
>          * LLVM appends various suffixes for local functions and variable=
s that
>          * must be promoted to global scope as part of LTO.  This can bre=
ak
>          * hooking of static functions with kprobes. '.' is not a valid
>          * character in an identifier in C. Suffixes observed:
>          * - foo.llvm.[0-9a-f]+
>          * - foo.[0-9a-f]+
>          */

I think livepatch will not fail, as the tool chain should already match the
suffix for the function being patched. If the tool chain failed to do so,
livepatch can fail for other reasons (missing symbols, etc.)

Thanks,
Song
