Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA76B5B4FA6
	for <lists+live-patching@lfdr.de>; Sun, 11 Sep 2022 17:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiIKPbo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 11 Sep 2022 11:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiIKPbm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 11 Sep 2022 11:31:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DF5220C1;
        Sun, 11 Sep 2022 08:31:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAAC361035;
        Sun, 11 Sep 2022 15:31:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D23C43141;
        Sun, 11 Sep 2022 15:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662910300;
        bh=f4ZjQtH1Kb0CE5y0VGooWc8Wwj1HiVheMrl2j8fAjUk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oO8Niz22F7cR9uhxQCzGa6wr02G8Syb9kA9rA9StaItcNtzrQ9KWhSQ8TwS4hZED0
         OtHWcXjICpsCtwg8J3ty45NOtRKK7bIvlpd6UBV1lHAMEsTBb8X8DY1qgRgf19tXxJ
         rQLpRhCGTY7hVuFjg7TJq1pbZxVNEu1pFIDGR4MD7b6RmKxwsFzAaVX/a6bJ7q+NTb
         kEWQK3ZtenVrQeqp0BibUa9OTFhI+w4AY4bz5NrPn5+KBiBsQNBDroF2HBOYqmah/G
         aMFAGA2CW05mXcBKMndx6BdDZQiw4OJpw0hqWLDrFdQb/kD5iiuSUE4eCVaXr/Fe2W
         kIvEc5J3Ay40Q==
Received: by mail-lf1-f50.google.com with SMTP id f14so10006807lfg.5;
        Sun, 11 Sep 2022 08:31:40 -0700 (PDT)
X-Gm-Message-State: ACgBeo2oEA8vS23zVOj7qgQswaFcd4yC3uranno1dYHwyRxwD51Ntx7R
        QHZZbdjYhaQ+jQ/BvQ0NxZUHDhcKNvKlgMtU6+8=
X-Google-Smtp-Source: AA6agR5hxuBvoUADUO4ivCFrh/xCsticI1ehP5Bn50QlfvL3G2hM+MkwsvALBS2FU8Qg9FovT9yybFEh1B7f+I9Z1fU=
X-Received: by 2002:ac2:4431:0:b0:497:aaf5:83eb with SMTP id
 w17-20020ac24431000000b00497aaf583ebmr6784950lfl.228.1662910298289; Sun, 11
 Sep 2022 08:31:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220909180704.jwwed4zhwvin7uyi@treble> <Yx3+GpHakZZYLM1N@hirez.programming.kicks-ass.net>
In-Reply-To: <Yx3+GpHakZZYLM1N@hirez.programming.kicks-ass.net>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sun, 11 Sep 2022 16:31:27 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGKHJHHvKRvZgq6Dy5BaR4vMUx8QXaw4XAqOhHxE3sb3Q@mail.gmail.com>
Message-ID: <CAMj1kXGKHJHHvKRvZgq6Dy5BaR4vMUx8QXaw4XAqOhHxE3sb3Q@mail.gmail.com>
Subject: Re: [RFC] Objtool toolchain proposal: -fannotate-{jump-table,noreturn}
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        linux-toolchains@vger.kernel.org,
        Indu Bhagat <indu.bhagat@oracle.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, "Jose E. Marchesi" <jemarch@gnu.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        live-patching@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Sathvika Vasireddy <sv@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Sun, 11 Sept 2022 at 16:26, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Fri, Sep 09, 2022 at 11:07:04AM -0700, Josh Poimboeuf wrote:
> > Alternatives
> > ------------
> >
> > Another idea which has been floated in the past is for objtool to read
> > DWARF (or .eh_frame) to help it figure out the control flow.  That
> > hasn't been tried yet, but would be considerably more difficult and
> > fragile IMO.
>
> I though Ard played around with that a bit on ARM64. And yes, given that
> most toolchains consider DWARF itself best-effort, I'm not holding my
> breath there.
>

I have patches out that use unwind data to locate pointer auth
sign/authenticate instructions in the code, in order to patch them to
shadow call stack pushes and pops at runtime if pointer authentication
is not supported by the hardware. This has little to do with objtool
or reliable stack traces.

I still think DWARF could help to make objtool's job a bit easier, but
I don't think it will be of any use with jump tables or noreturn
functions in particular.
