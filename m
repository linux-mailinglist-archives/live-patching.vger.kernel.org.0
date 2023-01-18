Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A9367281C
	for <lists+live-patching@lfdr.de>; Wed, 18 Jan 2023 20:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbjARTXw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 18 Jan 2023 14:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjARTXv (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 18 Jan 2023 14:23:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1405898A
        for <live-patching@vger.kernel.org>; Wed, 18 Jan 2023 11:23:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1AB7B81E10
        for <live-patching@vger.kernel.org>; Wed, 18 Jan 2023 19:23:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696C1C433D2
        for <live-patching@vger.kernel.org>; Wed, 18 Jan 2023 19:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674069824;
        bh=dDEUFSKAxmLwSeQGuWrJ9gctd/6EpfuLG1MtZ7V/oAU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=pImx9LNBhLEGt0hh9WOu77q+rm+dZC1Oh8w7bhj34EOlbDqHeZ06Nh/m73D7YfIzI
         gGTFQbPOdTVGihBt0epJVtlFlxoY5wqZJc0lQwF5QOJxxMvnvfr0T9HfKMWtHbyfbf
         B01tkFp+9l11xjKlIv1uzQWZeCFBoX1l6RuR2vluHF7WQgXVPkK0GWpUeRIBf6pfBV
         AYr1TUUQBFJc1DUH3fP49C7FC7imjaGN5xRaQdgg5Qa7etehb3iCSBS1CZRote+eNM
         UQ0QHE5qAgyoopV8KhDRu3E0A2suK0VhtjVuvszpQTIOgyIZerQyz+Y+mKbySIakkk
         W95hrcnT0Bvpw==
Received: by mail-lf1-f52.google.com with SMTP id g13so53148006lfv.7
        for <live-patching@vger.kernel.org>; Wed, 18 Jan 2023 11:23:44 -0800 (PST)
X-Gm-Message-State: AFqh2kprP4nr1x8hZPkLKCpuT98ALEQ78MEBQWhcGvELTIZpCcEl/bmN
        wyLgNRKuIAOXleydnVImcsfOthZozMfWZgXCfBU=
X-Google-Smtp-Source: AMrXdXseu/WqocizinHMmKrLZwisVy1MIfbuciqALW+ilTY2QseXt9GA92Bi2zScNcTHf9UwOZY9sBkCJd1j/eKaI6U=
X-Received: by 2002:ac2:4bc7:0:b0:4d5:95a9:f3c0 with SMTP id
 o7-20020ac24bc7000000b004d595a9f3c0mr191602lfq.89.1674069822422; Wed, 18 Jan
 2023 11:23:42 -0800 (PST)
MIME-Version: 1.0
References: <20230106200109.2546997-1-song@kernel.org> <Y8ft97xn7F92oWyn@alley>
In-Reply-To: <Y8ft97xn7F92oWyn@alley>
From:   Song Liu <song@kernel.org>
Date:   Wed, 18 Jan 2023 11:23:28 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7qXRb4ye0vsp=n0LbUiDWNTRUJJWS_hhTpXiF+6Qgupg@mail.gmail.com>
Message-ID: <CAPhsuW7qXRb4ye0vsp=n0LbUiDWNTRUJJWS_hhTpXiF+6Qgupg@mail.gmail.com>
Subject: Re: [PATCH v8] livepatch: Clear relocation targets on a module removal
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, jpoimboe@kernel.org,
        jikos@kernel.org, joe.lawrence@redhat.com,
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

On Wed, Jan 18, 2023 at 5:03 AM Petr Mladek <pmladek@suse.com> wrote:
>
[...]
> >               case R_X86_64_PC32:
> >               case R_X86_64_PLT32:
> > -                     if (*(u32 *)loc != 0)
> > -                             goto invalid_relocation;
> > -                     val -= (u64)loc;
> > -                     write(loc, &val, 4);
> >  #if 0
> > -                     if ((s64)val != *(s32 *)loc)
> > +                     if ((s64)val != *(s32 *)&val)
> >                               goto overflow;
>
> This is supposed to check the to-be-written value.

Great catch! Fixed it in v9.

>
> >  #endif
> > +                     val -= (u64)loc;
>
> This is modifying the to-be-written value. It should be computed before
> the overflow check.
>
> I know that the check is not really compiled in but we should
> not break it.
>
>
> >                       break;
>
> Otherwise, it looks fine.
>
>
> Now, I agree with Miroslav that we should get an approval from x86
> maintainers. Sigh, I think that I have already asked for this earlier:
>
> !!! Please add x86@kernel.org and linux-kernel@vger.kernel.org at
> minimum into CC when sending V9 !!!

I am sorry I missed this request.

>
> The more people know about this change the better. And it is really
> important to make maintainers of the touched subsystem aware of
> proposed changes.
>
> It is a good practice to add people that are printed by
> ./scripts/get_maintainer.pl. In this case, it is:
>
> $> ./scripts/get_maintainer.pl arch/x86/kernel/module.c
> Thomas Gleixner <tglx@linutronix.de> (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT),authored:2/12=17%,added_lines:24/74=32%,removed_lines:5/26=19%)
> Ingo Molnar <mingo@redhat.com> (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
> Borislav Petkov <bp@alien8.de> (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT),commit_signer:4/12=33%)
> Dave Hansen <dave.hansen@linux.intel.com> (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
> x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
> "H. Peter Anvin" <hpa@zytor.com> (reviewer:X86 ARCHITECTURE (32-BIT AND 64-BIT))
> Peter Zijlstra <peterz@infradead.org> (commit_signer:8/12=67%,authored:4/12=33%,added_lines:41/74=55%,removed_lines:8/26=31%)
> Kees Cook <keescook@chromium.org> (commit_signer:4/12=33%)
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> (commit_signer:3/12=25%)
> "Jason A. Donenfeld" <Jason@zx2c4.com> (commit_signer:3/12=25%,authored:3/12=25%,removed_lines:3/26=12%)
> Julian Pidancet <julian.pidancet@oracle.com> (authored:1/12=8%,added_lines:5/74=7%,removed_lines:6/26=23%)
> Ard Biesheuvel <ardb@kernel.org> (authored:1/12=8%,removed_lines:3/26=12%)
> linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND 64-BIT))

vger.kernel.org usually drops my email when the CC list is so long.
I am trying to fix it. For v9, I will CC x86@kernel.org,
linux-kernel@vger.kernel.org, and linux-modules@vger.kernel.org.

Thanks,
Song
