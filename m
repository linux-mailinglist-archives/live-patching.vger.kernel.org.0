Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6BF674249
	for <lists+live-patching@lfdr.de>; Thu, 19 Jan 2023 20:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbjASTJB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 19 Jan 2023 14:09:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjASTIa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 19 Jan 2023 14:08:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163EF9B113;
        Thu, 19 Jan 2023 11:07:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02F9661D55;
        Thu, 19 Jan 2023 19:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1C7C433D2;
        Thu, 19 Jan 2023 19:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674155210;
        bh=84wFksc5y+vkdlmosNddXFXLVddcPsdJwTu1PkhnkU8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rGc04UbpBVmqi4/ZK3APXtn4XV5D6LVQvU5RmTz2mq3BvwJJ2wfIck5SiJlkcj8i9
         gRwZswiTyCJH9xIjrW5ribwgXDEa2YOm41YsWsuXwUuVDw6ArG0raUEAEf8NtydewE
         ELcISv52HkMP7nJrPcEboD5Zzn9Na84AiJEOyPWa7DMsB4z5aCSO3ndGfOMersTGR0
         wS7DKxawLsq1ae1i5hm6FZOrGYWV0ls1R0VaKZ91ReiTKDFgXpGo96g6G8oKXFme/o
         dFUVq2JjpBG+cd/wQBIyZXRTNKtwOdsA5iDDEo4pmYtj3sddeBg2IJfk78O2a4Uumx
         MK+KhVRryRK9w==
Received: by mail-lf1-f44.google.com with SMTP id br9so4643809lfb.4;
        Thu, 19 Jan 2023 11:06:50 -0800 (PST)
X-Gm-Message-State: AFqh2kqtqdgOWTaA+m1wB3Cz3AMlZWAlJHQfJFn6rpGYflI6n46M0KzD
        B2tfKuI6ZgP7re5DWa++0hZCRYjTrIBB7SOpkKY=
X-Google-Smtp-Source: AMrXdXt64nUndEGLEDNBdyLij2TTHj/NBNidtKszrhl2R18XJNVEtWClhk8lZ2xXjFti1dqNiqV01TaLB8p/5CE/i34=
X-Received: by 2002:ac2:48b7:0:b0:4b6:e71d:94a6 with SMTP id
 u23-20020ac248b7000000b004b6e71d94a6mr901375lfg.476.1674155208380; Thu, 19
 Jan 2023 11:06:48 -0800 (PST)
MIME-Version: 1.0
References: <20230118204728.1876249-1-song@kernel.org> <20230118220812.dvztwhlmliypefha@treble>
In-Reply-To: <20230118220812.dvztwhlmliypefha@treble>
From:   Song Liu <song@kernel.org>
Date:   Thu, 19 Jan 2023 11:06:35 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6FyHLeG3XMMMJiNnhwzW3dPXKrj3ksyB-C_iK1PNk71Q@mail.gmail.com>
Message-ID: <CAPhsuW6FyHLeG3XMMMJiNnhwzW3dPXKrj3ksyB-C_iK1PNk71Q@mail.gmail.com>
Subject: Re: [PATCH v9] livepatch: Clear relocation targets on a module removal
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        live-patching@vger.kernel.org, x86@kernel.org, jikos@kernel.org,
        pmladek@suse.com, joe.lawrence@redhat.com,
        Miroslav Benes <mbenes@suse.cz>,
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

On Wed, Jan 18, 2023 at 2:08 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> On Wed, Jan 18, 2023 at 12:47:28PM -0800, Song Liu wrote:
> > From: Miroslav Benes <mbenes@suse.cz>
> >
> > Josh reported a bug:
> >
> >   When the object to be patched is a module, and that module is
> >   rmmod'ed and reloaded, it fails to load with:
> >
> >   module: x86/modules: Skipping invalid relocation target, existing value is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
> >
> >   The livepatch module has a relocation which references a symbol
> >   in the _previous_ loading of nfsd. When apply_relocate_add()
> >   tries to replace the old relocation with a new one, it sees that
> >   the previous one is nonzero and it errors out.
> >
> >   On ppc64le, we have a similar issue:
> >
> >   module_64: livepatch_nfsd: Expected nop after call, got e8410018 at e_show+0x60/0x548 [livepatch_nfsd]
> >   livepatch: failed to initialize patch 'livepatch_nfsd' for module 'nfsd' (-8)
> >   livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing to load module 'nfsd'
>
> Shouldn't there also be a fix for this powerpc issue?

There was a working version, but it was not very clean. We couldn't agree
on the path forward for powerpc, so we are hoping to ship the fix to x86 (and
s390?) first [1].

Thanks,
Song

[1] https://lore.kernel.org/live-patching/Y7hLvpHqgY0oJ4GY@alley/#t
