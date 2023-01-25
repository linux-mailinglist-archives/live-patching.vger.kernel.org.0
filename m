Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33E567B8AE
	for <lists+live-patching@lfdr.de>; Wed, 25 Jan 2023 18:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235476AbjAYRgT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 25 Jan 2023 12:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjAYRgS (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 25 Jan 2023 12:36:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B733618B1D;
        Wed, 25 Jan 2023 09:36:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51F39615A1;
        Wed, 25 Jan 2023 17:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49AAC4339C;
        Wed, 25 Jan 2023 17:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674668176;
        bh=HIRhQFRsenIpGbfr60wVwlvaqGvdjpK2FqZYpaiCKwo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=aJ55On6TL/U9WNEaQakd6jSX0Dc5vKvgiohGPnAkWpdRKG9os8X9C7JhUyAbRwYCT
         bzYDMjmCKbx8Qt7aqHtSFKGPDZDysodYMWsoOlZWBtoHgfmKuOIyVZpWEX0glWuuQk
         egxUp1/OwtGlhTPSmAk+YYc2pfJf37HFCBwQjbHPAdI3dWwzasXhEtKnzTN63kq1Ne
         Ou6srYLqxXeJOQOvMaiqBLdifsuOVMmgJF+S5ZjMEjKP/dqATwDNDtxyxXFf771sOZ
         0RpBFtzT2IwIvQnjME667DoMJV7kCI2hVIALOz0f09aM9K5OCPnkptFYGUc/qNQCsg
         Gmbdx/zQX7V5w==
Received: by mail-lf1-f48.google.com with SMTP id w11so26484403lfu.11;
        Wed, 25 Jan 2023 09:36:16 -0800 (PST)
X-Gm-Message-State: AFqh2kp+dgGMDIOXszZ6qNC9UHeUnwen8uKlV2tCVgICmqNMeQ/Y7Fxp
        kze5jvLzrg4zT1/WIrzcPHGyxs6BXV1VEKKN/qE=
X-Google-Smtp-Source: AMrXdXvhPt/s3DaLoFekOs0k/EkuWPTCApiwCxC5zZ9oekC5jwXgYcZfDtkaPZzojcQseFAKz4Wb7VdPPjbKlkUBJX0=
X-Received: by 2002:a05:6512:2115:b0:4cb:1d3e:685b with SMTP id
 q21-20020a056512211500b004cb1d3e685bmr1788108lfr.126.1674668174651; Wed, 25
 Jan 2023 09:36:14 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674617130.git.jpoimboe@kernel.org> <2f6329ffd9674df6ff57e03edeb2ca54414770ab.1674617130.git.jpoimboe@kernel.org>
 <CAPhsuW40jEiyp0ogsO6oH_frpFCmiioSHrMOKkwGcZ8_6w5dZA@mail.gmail.com> <20230125164609.wvuarciciyoqa3tb@treble>
In-Reply-To: <20230125164609.wvuarciciyoqa3tb@treble>
From:   Song Liu <song@kernel.org>
Date:   Wed, 25 Jan 2023 09:36:02 -0800
X-Gmail-Original-Message-ID: <CAPhsuW45k8Avx=Zfid1pxaeHAbLGgOcxbN_=DQOb8WdPx7fB+Q@mail.gmail.com>
Message-ID: <CAPhsuW45k8Avx=Zfid1pxaeHAbLGgOcxbN_=DQOb8WdPx7fB+Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] powerpc/module_64: Fix "expected nop" error on module re-patching
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        live-patching@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 25, 2023 at 8:46 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> On Tue, Jan 24, 2023 at 10:09:56PM -0800, Song Liu wrote:
> > > @@ -514,9 +515,18 @@ static int restore_r2(const char *name, u32 *instruction, struct module *me)
> > >         if (!instr_is_relative_link_branch(ppc_inst(*prev_insn)))
> > >                 return 0;
> > >
> > > -       if (*instruction != PPC_RAW_NOP()) {
> > > +       /*
> > > +        * For livepatch, the restore r2 instruction might have already been
> > > +        * written previously, if the referenced symbol is in a previously
> > > +        * unloaded module which is now being loaded again.  In that case, skip
> > > +        * the warning and the instruction write.
> > > +        */
> > > +       if (insn_val == PPC_INST_LD_TOC)
> > > +               return 0;
> >
> > Do we need "sym->st_shndx == SHN_LIVEPATCH" here?
>
> My original patch had that check, but I dropped it for simplicity.
>
> In the non-livepatch case, the condition should never be true, but it
> doesn't hurt to check it anyway.

While this is the only place we use PPC_INST_LD_TOC, there is another
place we use "PPC_RAW_STD(_R2, _R1, R2_STACK_OFFSET)", which
is identical to PPC_INST_LD_TOC. So I am not quite sure whether this
happens for non-livepatch.

Thanks,
Song
