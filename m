Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62F556647BF
	for <lists+live-patching@lfdr.de>; Tue, 10 Jan 2023 18:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235334AbjAJRxE (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 Jan 2023 12:53:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238600AbjAJRwq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 Jan 2023 12:52:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E27A88DDC
        for <live-patching@vger.kernel.org>; Tue, 10 Jan 2023 09:51:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E3F4B818FE
        for <live-patching@vger.kernel.org>; Tue, 10 Jan 2023 17:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60D6C43392
        for <live-patching@vger.kernel.org>; Tue, 10 Jan 2023 17:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673373106;
        bh=j/aPRxunaNVzdXnGvuf60KQdLG4lZWXFnRtlM0xGUSQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ldRa912ckU6DcFIdxWg/OI1MpQ4DAAnLiIdAo1CDCS8GnjrcnW2/0Vr+zVuW5YLUo
         Oe14GawAnFaB1QFAwIKnDXAKtMaezyqoGwKho6cr0wD+weTohYCAcJNtUCpXemc5cv
         AfRUZc4O9hb13FaoW0/5R9AUM9PFcGwSmTbwrZ33LW5+79tWgwjTM2a7S669NGDOXZ
         wtMAo4sKyapWTiDTchcOLN0p/If3jfUoo8wz9sf7w0ovy4bwLUp6QseA14xcokvtCN
         vOxdZ3nkKtElrgMQAGfS27PV0P5uS/POLMqlD5XhoiJYTqyWC/yvExFh8PFz3K79hT
         lc++RRyJNJVJw==
Received: by mail-lj1-f181.google.com with SMTP id g14so13324854ljh.10
        for <live-patching@vger.kernel.org>; Tue, 10 Jan 2023 09:51:46 -0800 (PST)
X-Gm-Message-State: AFqh2kruZXV0cTLGGmcOMq7sbLFuVqf2TYqHrI5tZv6BTHZyuBzOgMaR
        UweYHM2VSsBg3UZtek2q8ady1S5bqahoDaLoI0w=
X-Google-Smtp-Source: AMrXdXs9Eme5J/Uwby6CcGiVpx2is3eFAHOIJZRSIm1kxF2EM4uExEfOrKXBU47le91jxk4hjP22Q9o+FLWSPj65urw=
X-Received: by 2002:a2e:8e2f:0:b0:27f:eb62:c529 with SMTP id
 r15-20020a2e8e2f000000b0027feb62c529mr1469308ljk.98.1673373104794; Tue, 10
 Jan 2023 09:51:44 -0800 (PST)
MIME-Version: 1.0
References: <20230106200109.2546997-1-song@kernel.org>
In-Reply-To: <20230106200109.2546997-1-song@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Tue, 10 Jan 2023 09:51:32 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4NqF97FrZtLqF27377by1AUKtFUuE_kKpVdhHfF+s5pg@mail.gmail.com>
Message-ID: <CAPhsuW4NqF97FrZtLqF27377by1AUKtFUuE_kKpVdhHfF+s5pg@mail.gmail.com>
Subject: Re: [PATCH v8] livepatch: Clear relocation targets on a module removal
To:     live-patching@vger.kernel.org
Cc:     jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi folks,

Could you please share your comments on v8 patch?

Thanks,
Song

On Fri, Jan 6, 2023 at 12:01 PM Song Liu <song@kernel.org> wrote:
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
> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
> Signed-off-by: Song Liu <song@kernel.org>
> Reported-by: Josh Poimboeuf <jpoimboe@redhat.com>
>
> ---
>
> NOTE: powerpc32 code is only compile tested.
>
> Changes v7 = v8:
> 1. Remove the logic in powerpc/kernel/module_64.c, as there is ongoing
>    discussions.
> 2. For x86_64, add check for expected value during clear_relocate_add().
>    (Petr Mladek)
> 3. Optimize the logic in klp_write_section_relocs(). (Petr Mladek)
> 4. Optimize __write_relocate_add (x86_64). (Joe Lawrence)
>
> Changes v6 = v7:
> 1. Reduce code duplication in livepatch/core.c and x86/kernel/module.c.
> 2. Add more comments to powerpc/kernel/module_64.c.
> 3. Added Joe's Tested-by (which I should have added in v6).

[...]
