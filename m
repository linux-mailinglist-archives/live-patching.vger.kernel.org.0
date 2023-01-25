Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2244967AA21
	for <lists+live-patching@lfdr.de>; Wed, 25 Jan 2023 06:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbjAYFyP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 25 Jan 2023 00:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbjAYFyO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 25 Jan 2023 00:54:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7194892;
        Tue, 24 Jan 2023 21:54:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07D476141D;
        Wed, 25 Jan 2023 05:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9B4C433D2;
        Wed, 25 Jan 2023 05:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674626052;
        bh=JIber7cTfE9ThxMrYyG/mxwkbRzILpS6h12Z6O1fhcs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MkZysPwqbD6HWPhFavr6Z+uZa5RCwE0rTC1iC87F4+bWo0kZ0wVUe/sLgSOEJuaJb
         Pr4V8dbEiTwOXcMgUFWpZl02JaVM/N2ZHa+xvnmI9DKqdM/hj/r750X2oW4CdTOZPv
         tnldu7QNioehfjwh3MKWekpzNFDYAEyg9RvCG10oYn5zXLV7twWU3YNgvxN67e3n8F
         WdyLYrc7+N0/4yqMEirm9tB2wc39ccGkJT5BRyQL6hbjkU755zkP1pkY+pMm5sCFkD
         Sm60X7pFWBazZGXpUkxJ/fPLqUHGinWytoN9YitlSO5Fhha+AYRZW5JA1Engy73NtU
         zU1TCD2CeXZrA==
Received: by mail-lj1-f175.google.com with SMTP id y9so15425304lji.2;
        Tue, 24 Jan 2023 21:54:12 -0800 (PST)
X-Gm-Message-State: AFqh2kpsgIcAwlcA4kP0sqYen79R6kpIasOiZY/ifoEMDx/4/EEgROmO
        9chY1y2CaeSsWnr954dsYpIW26SYnLpnjsDb5jA=
X-Google-Smtp-Source: AMrXdXvwTh3TnItQH+Of30p8yazMgU0vmxKOZ3BJ+NF7tXNDrhWd6Q3bd7TrD/6soqGyBgQ+RLdt+h4NEd3WVYVD+B8=
X-Received: by 2002:a2e:a304:0:b0:287:14be:5d05 with SMTP id
 l4-20020a2ea304000000b0028714be5d05mr1494540lje.495.1674626050411; Tue, 24
 Jan 2023 21:54:10 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674617130.git.jpoimboe@kernel.org> <15baf76c271a0ae09f7b8556e50f2b4251e7049d.1674617130.git.jpoimboe@kernel.org>
In-Reply-To: <15baf76c271a0ae09f7b8556e50f2b4251e7049d.1674617130.git.jpoimboe@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Tue, 24 Jan 2023 21:53:58 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6Ee+RT86MUffgS+4zvJjG3JFAz=qp=LHeTW=RWPhCYzw@mail.gmail.com>
Message-ID: <CAPhsuW6Ee+RT86MUffgS+4zvJjG3JFAz=qp=LHeTW=RWPhCYzw@mail.gmail.com>
Subject: Re: [PATCH 1/2] powerpc/module_64: Improve restore_r2() return semantics
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        live-patching@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jan 24, 2023 at 7:38 PM Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>
> restore_r2() returns 1 on success, which is surprising for a non-boolean
> function.  Change it to return 0 on success and -errno on error to match
> kernel coding convention.
>
> Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>

Acked-by: Song Liu <song@kernel.org>
