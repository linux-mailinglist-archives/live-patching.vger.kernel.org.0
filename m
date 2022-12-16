Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D891464F03C
	for <lists+live-patching@lfdr.de>; Fri, 16 Dec 2022 18:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiLPRTy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Dec 2022 12:19:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiLPRTx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Dec 2022 12:19:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3799E29CAE;
        Fri, 16 Dec 2022 09:19:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5D70621B9;
        Fri, 16 Dec 2022 17:19:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09401C433EF;
        Fri, 16 Dec 2022 17:19:48 +0000 (UTC)
Date:   Fri, 16 Dec 2022 12:19:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Andreas Schwab' <schwab@linux-m68k.org>,
        "'Leizhen (ThunderTown)'" <thunder.leizhen@huawei.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        "Joe Lawrence" <joe.lawrence@redhat.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luis Chamberlain" <mcgrof@kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v9] kallsyms: Add self-test facility
Message-ID: <20221216121947.7d03b651@gandalf.local.home>
In-Reply-To: <ecf4939dbff84709a1782a8e8851b29f@AcuMS.aculab.com>
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
        <CAMuHMdWPSeieR-sGuozd3kWGjVw85EV40irqM9aErXufifzFNA@mail.gmail.com>
        <49070ac3-02bb-a3b3-b929-ede07e3b2c95@huawei.com>
        <e81710a9-2c45-0724-ec5f-727977202858@huawei.com>
        <CAMuHMdWAAQNJd21fhodDONb40LFMae3V_517iT22FykCqG90Og@mail.gmail.com>
        <4aaede14-8bd3-6071-f17b-7efcb5f0de42@huawei.com>
        <66ec4021-b633-09ba-73ee-b24cdb3fa25a@huawei.com>
        <CAMuHMdVUvPRvEvGNmB9WO0yg=w04g4q2_1hfOypqEnrYkFr6YQ@mail.gmail.com>
        <06345dca-0afb-00a5-c9e9-5ba830d8ad05@huawei.com>
        <52450ec1da164d6d87587063c3b3d3d2@AcuMS.aculab.com>
        <592dce7a0de24c62bd31c29f86ce6c1b@AcuMS.aculab.com>
        <87pmcjidfe.fsf@igel.home>
        <1ba1fadb39994a4d91edabdfd9d69fa6@AcuMS.aculab.com>
        <87len7ibtt.fsf@igel.home>
        <c7cebe9da0474eb880ab14124ba290d0@AcuMS.aculab.com>
        <87fsdfib07.fsf@igel.home>
        <819801284eb745d9a4189759bad297f5@AcuMS.aculab.com>
        <20221216115314.6120beb7@gandalf.local.home>
        <ecf4939dbff84709a1782a8e8851b29f@AcuMS.aculab.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri, 16 Dec 2022 16:57:54 +0000
David Laight <David.Laight@ACULAB.COM> wrote:

> > I don't know m68k assembly, but I'm guessing the (%O)+ and the (%1)+ only
> > modifies the register being used, and no memory is being touched.  
> 
> Memory is being read so a clobber is needed to ensure that all pending
> writes have been done.
> Although, in this case, the memory being read is effectively
> read only so nothing should be

I would think that if the memory being read is the address of what the
input parameters being passed into it are, then the compiler should be
smart enough to know that there's a relation. Especially if the input
parameters are pointers.

I assumed that "memory" was for memory unrelated to the input constraints.

-- Steve
