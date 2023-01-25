Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D17D67B839
	for <lists+live-patching@lfdr.de>; Wed, 25 Jan 2023 18:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbjAYRQS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 25 Jan 2023 12:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236153AbjAYRQP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 25 Jan 2023 12:16:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0368E3346D;
        Wed, 25 Jan 2023 09:15:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADB60B81B4A;
        Wed, 25 Jan 2023 17:15:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D799C433D2;
        Wed, 25 Jan 2023 17:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674666908;
        bh=dViYCuwHv8cgGDtm/WpFME/g6pbXHzc1evDj8qsG0rI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eU6Px/VnMOuttF0RHWW5TwEly6XDsrqcsYy1myMerw+pATaq9wt+uHuMdVJ3GwV3w
         mlL358ZF15f3UOHOOmz9wHPezmuNMprFs/VGCiSxtteZ2gp3gY2e5Y2PRkDyvoZDBK
         zwTjkpkQ/WOjAbS+qXLJFWXIEImk8S81hu7PqIKvBh3Co7UXbgMsuSfoSwJGgF4HJS
         8Xh+YP0qSFoit2x0XwUfPzUmPJTfzmJpf164mRDwKQvaeokmuuwcRHRsCoyMCRUU83
         ZMvEPrDdoyaNfQbWP6FYsWmbaF67vjh/z0h9pnGuTPArMxNJJWpvDRYRbHCIGuHq/H
         SyMH80Dt3Cw6A==
Received: by mail-lj1-f179.google.com with SMTP id by7so20112439ljb.6;
        Wed, 25 Jan 2023 09:15:08 -0800 (PST)
X-Gm-Message-State: AFqh2krozd4MgGSz0iZo/Dqc1MmOk8ycYNAsPx5n8UYdJzoPkhL6dDw5
        WwPjMsy30ZfOhzrfuLbDinL1Ed6YCXb03GDX87s=
X-Google-Smtp-Source: AMrXdXuyziWLZ9TMBue6pZrcIPJrNaqb5kHgF5E0hwy7hisLxPQKo7x+e1Zx+xwhC2ZeeW9hjh5yQ14acTlpFOgvNac=
X-Received: by 2002:a2e:2c15:0:b0:280:54b:9ed5 with SMTP id
 s21-20020a2e2c15000000b00280054b9ed5mr1465762ljs.414.1674666906376; Wed, 25
 Jan 2023 09:15:06 -0800 (PST)
MIME-Version: 1.0
References: <20230121004945.697003-1-song@kernel.org> <20230121004945.697003-2-song@kernel.org>
 <c9574e8f-cc1d-862a-465f-cb0b9b5717d7@csgroup.eu>
In-Reply-To: <c9574e8f-cc1d-862a-465f-cb0b9b5717d7@csgroup.eu>
From:   Song Liu <song@kernel.org>
Date:   Wed, 25 Jan 2023 09:14:54 -0800
X-Gmail-Original-Message-ID: <CAPhsuW63R59p_DyRMyrhZMEiOsoNQf2cxrZJU5Z_mgV=XBX1zw@mail.gmail.com>
Message-ID: <CAPhsuW63R59p_DyRMyrhZMEiOsoNQf2cxrZJU5Z_mgV=XBX1zw@mail.gmail.com>
Subject: Re: [PATCH v10 2/2] livepatch,x86: Clear relocation targets on a
 module removal
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 25, 2023 at 1:58 AM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
>
>
>
> Le 21/01/2023 =C3=A0 01:49, Song Liu a =C3=A9crit :
> > Josh reported a bug:
> >
> >    When the object to be patched is a module, and that module is
> >    rmmod'ed and reloaded, it fails to load with:
> >
> >    module: x86/modules: Skipping invalid relocation target, existing va=
lue is nonzero for type 2, loc 00000000ba0302e9, val ffffffffa03e293c
> >    livepatch: failed to initialize patch 'livepatch_nfsd' for module 'n=
fsd' (-8)
> >    livepatch: patch 'livepatch_nfsd' failed for module 'nfsd', refusing=
 to load module 'nfsd'
> >
> >    The livepatch module has a relocation which references a symbol
> >    in the _previous_ loading of nfsd. When apply_relocate_add()
> >    tries to replace the old relocation with a new one, it sees that
> >    the previous one is nonzero and it errors out.
> >
> > He also proposed three different solutions. We could remove the error
> > check in apply_relocate_add() introduced by commit eda9cec4c9a1
> > ("x86/module: Detect and skip invalid relocations"). However the check
> > is useful for detecting corrupted modules.
> >
> > We could also deny the patched modules to be removed. If it proved to b=
e
> > a major drawback for users, we could still implement a different
> > approach. The solution would also complicate the existing code a lot.
> >
> > We thus decided to reverse the relocation patching (clear all relocatio=
n
> > targets on x86_64). The solution is not
> > universal and is too much arch-specific, but it may prove to be simpler
> > in the end.
>
> Would it be possible to not add empty clear_relocate_add() on all
> architecture while only x86 implements it ? Can we make it an empty
> static inline in generic livepatch.h for the architectures not
> implementing it, like we do for most mm functions ?
>
> Another solution would be to define an empty generic weak version of
> clear_relocate_add()

Sure, I will replace these with a week function.

Thanks,
Song
