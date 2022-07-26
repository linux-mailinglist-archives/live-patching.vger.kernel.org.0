Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96294581840
	for <lists+live-patching@lfdr.de>; Tue, 26 Jul 2022 19:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233999AbiGZRTz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 26 Jul 2022 13:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiGZRTy (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 26 Jul 2022 13:19:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347D31A051;
        Tue, 26 Jul 2022 10:19:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBB04B818BF;
        Tue, 26 Jul 2022 17:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BB0C433D6;
        Tue, 26 Jul 2022 17:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658855990;
        bh=qfN7sU2QjHcpSBNkLFgxr5Bfn9PXkpjv/gAO3PLESVs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CvUlb6RxAI4iOAnGgODfQ66YkVUIQ5nF7awrlSJiQQJpdsYBOO2+gpZFK7Dg+Ccsk
         fjXEAwXGOorffZQ7rLmwqqDXsb/pZ91c+VpeXstALHfP+ZBKz6QkMweSO3eTlEhTJI
         s3vip4BatsRJRsEy075U7oHUnKrCj0OD2qigojzZNW+da3zs9xJUlboQ38aoUHVgM2
         Y6lCEQxbx/IMXJcULNguUhxqg1yV1oPU+6Np0/ElcVHugy58qvUDsUzHzw+BLW1lNV
         UgXEr7EfspRIcwlXqw414XIibFx7FVLe3T/vwO3UM7lEu58JfEY5X3tD2OWSVn9/SK
         su8e44cswuXow==
Received: by mail-yb1-f173.google.com with SMTP id f73so26389856yba.10;
        Tue, 26 Jul 2022 10:19:50 -0700 (PDT)
X-Gm-Message-State: AJIora8nxQnsG2cWgVgmcZ0/M8KA0lsMP94MaRYw7rAQuIO9NkHP4R7Q
        fOL5JRPezJKgdoxY/p0vE3iCYEPbLLoEcJU7Ngs=
X-Google-Smtp-Source: AGRyM1vRn6Dkzdxs6g5RlH8xVIFZP5SAXLR9vijHLbKziJSzSPgIesjZvm0q76tJuJdI+tnFsnwVsRS71c8R/GB3XRw=
X-Received: by 2002:a25:55c5:0:b0:670:96cb:a295 with SMTP id
 j188-20020a2555c5000000b0067096cba295mr13625181ybb.449.1658855989642; Tue, 26
 Jul 2022 10:19:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220721175147.214642-1-song@kernel.org>
In-Reply-To: <20220721175147.214642-1-song@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Tue, 26 Jul 2022 10:19:38 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7PzbtB5Esfjy8b60jM9qqLewKYTc6KADrP=EbbXKUKpg@mail.gmail.com>
Message-ID: <CAPhsuW7PzbtB5Esfjy8b60jM9qqLewKYTc6KADrP=EbbXKUKpg@mail.gmail.com>
Subject: Re: [PATCH v3] livepatch: Clear relocation targets on a module removal
To:     live-patching@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        X86 ML <x86@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi folks,

Could you please share your comments on this one?

Thanks,
Song

On Thu, Jul 21, 2022 at 10:52 AM Song Liu <song@kernel.org> wrote:
>
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
> Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Song Liu <song@kernel.org>
>
> ---
>
> Changes from v2:
> 1. Rewrite x86 changes to match current code style.
> 2. Remove powerpc changes as there is no test coverage in v3.
> 3. Only keep 1/3 of v2.
>
> v2: https://lore.kernel.org/all/20190905124514.8944-1-mbenes@suse.cz/T/#u
> ---
[...]
