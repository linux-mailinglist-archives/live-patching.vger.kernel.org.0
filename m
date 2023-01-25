Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 804E167BA02
	for <lists+live-patching@lfdr.de>; Wed, 25 Jan 2023 19:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbjAYS7Q (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 25 Jan 2023 13:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjAYS7P (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 25 Jan 2023 13:59:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC4BC156;
        Wed, 25 Jan 2023 10:59:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29792B81B43;
        Wed, 25 Jan 2023 18:59:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AC9C433D2;
        Wed, 25 Jan 2023 18:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674673151;
        bh=1+fHPNsuc4MyRUEsG4OdIGfRnRLw/JQerFclCCmF56o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PTde9w7imqgs0pgPP6AqVjnLW+GuwUYHndQE3/GBWOz2x+UXEndbbAH95Lc94uKE0
         H4nVaq/lOQfRx7jAKyK9F6uczAF+QnnrJUfCjD1Ica5mbRUJxx8uxD8X+b4sHJxZEF
         AnT9PgkUHJkVUi1g11p4w1nYcj+/D2ea5MKdhlOadsJUhnCIpmQZGpaSV3CAUNnLC0
         lnbtLu4xaFBmRSKybFU37U1NxmTKzWhQaTZwHS0nVrPLk4kmX9Uiv7yOyagZ06SGWx
         Z3VrcsPehxqFOyrY+qEMLhikPeWirZzXdF/DAPWxX0D92cxbzsIQ44cfs6z8hsxUvS
         k5dxobTPjTV1A==
Received: by mail-lj1-f180.google.com with SMTP id c3so21498518ljh.1;
        Wed, 25 Jan 2023 10:59:11 -0800 (PST)
X-Gm-Message-State: AFqh2krmVWVPhmtKdnosbA/oqYTnHnY5AWAOjEcriL/nZazlSbtmtdTd
        iupC215mr71m5ADQ8H46ZJgQnI9/V/lGRih2x4M=
X-Google-Smtp-Source: AMrXdXv5/kxhPToUvpAcQu8ja3HWxsLjrG6uN+5VHpPT8t0KrrGIMo8aNaNviaMEEDEZKicHQfY3v4UDdpkfnNn7PSA=
X-Received: by 2002:a2e:b166:0:b0:284:b05a:9e82 with SMTP id
 a6-20020a2eb166000000b00284b05a9e82mr2072294ljm.479.1674673149881; Wed, 25
 Jan 2023 10:59:09 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674617130.git.jpoimboe@kernel.org> <2f6329ffd9674df6ff57e03edeb2ca54414770ab.1674617130.git.jpoimboe@kernel.org>
 <CAPhsuW40jEiyp0ogsO6oH_frpFCmiioSHrMOKkwGcZ8_6w5dZA@mail.gmail.com>
 <20230125164609.wvuarciciyoqa3tb@treble> <CAPhsuW45k8Avx=Zfid1pxaeHAbLGgOcxbN_=DQOb8WdPx7fB+Q@mail.gmail.com>
 <20230125185316.ebvxecd7gsvgtudr@treble>
In-Reply-To: <20230125185316.ebvxecd7gsvgtudr@treble>
From:   Song Liu <song@kernel.org>
Date:   Wed, 25 Jan 2023 10:58:57 -0800
X-Gmail-Original-Message-ID: <CAPhsuW56Ztn7JGci7=tPO__EFTNP0Ccp-WSNRUnQ2e81kBZMNw@mail.gmail.com>
Message-ID: <CAPhsuW56Ztn7JGci7=tPO__EFTNP0Ccp-WSNRUnQ2e81kBZMNw@mail.gmail.com>
Subject: Re: [PATCH 2/2] powerpc/module_64: Fix "expected nop" error on module re-patching
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     live-patching@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jan 25, 2023 at 10:53 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> On Wed, Jan 25, 2023 at 09:36:02AM -0800, Song Liu wrote:
> > On Wed, Jan 25, 2023 at 8:46 AM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > >
> > > On Tue, Jan 24, 2023 at 10:09:56PM -0800, Song Liu wrote:
> > > > > @@ -514,9 +515,18 @@ static int restore_r2(const char *name, u32 *instruction, struct module *me)
> > > > >         if (!instr_is_relative_link_branch(ppc_inst(*prev_insn)))
> > > > >                 return 0;
> > > > >
> > > > > -       if (*instruction != PPC_RAW_NOP()) {
> > > > > +       /*
> > > > > +        * For livepatch, the restore r2 instruction might have already been
> > > > > +        * written previously, if the referenced symbol is in a previously
> > > > > +        * unloaded module which is now being loaded again.  In that case, skip
> > > > > +        * the warning and the instruction write.
> > > > > +        */
> > > > > +       if (insn_val == PPC_INST_LD_TOC)
> > > > > +               return 0;
> > > >
> > > > Do we need "sym->st_shndx == SHN_LIVEPATCH" here?
> > >
> > > My original patch had that check, but I dropped it for simplicity.
> > >
> > > In the non-livepatch case, the condition should never be true, but it
> > > doesn't hurt to check it anyway.
> >
> > While this is the only place we use PPC_INST_LD_TOC, there is another
> > place we use "PPC_RAW_STD(_R2, _R1, R2_STACK_OFFSET)", which
> > is identical to PPC_INST_LD_TOC. So I am not quite sure whether this
> > happens for non-livepatch.
>
> It's not actually identical.  That's the "store r2 to the stack"
> counterpart to the load in PPC_INST_LD_TOC, which loads r2 from the
> stack.

Ooops.. I misread the code.

>
> For R_PPC_REL24 relocations, when calling a function which lives outside
> the module, 24 bits isn't enough to encode the relative branch target
> address.  So it has to save r2 (TOC pointer) to the stack, and branch to
> a stub, which then branches to the external function.
>
> When the external function returns execution to the instruction after
> the original branch, that instruction needs to restore the TOC pointer
> from the stack to r2.
>
> The compiler knows this, and emits the instruction after the branch as a
> NOP.  The module code replaces that NOP with a "restore r2 from the
> stack".  That's what restore_r2() does.
>
> Long story short, restore_r2() needs to ensure the instruction after the
> branch restores r2 from the stack.  If that instruction is already
> there, it doesn't need to do anything.

Thanks for the explanation!

Acked-by: Song Liu <song@kernel.org>
