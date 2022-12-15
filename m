Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D515A64DD2F
	for <lists+live-patching@lfdr.de>; Thu, 15 Dec 2022 15:58:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbiLOO6H (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 15 Dec 2022 09:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiLOO6F (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 15 Dec 2022 09:58:05 -0500
X-Greylist: delayed 377 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 15 Dec 2022 06:58:04 PST
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4292F65B;
        Thu, 15 Dec 2022 06:58:03 -0800 (PST)
Received: from frontend03.mail.m-online.net (unknown [192.168.6.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4NXwDH3L4Zz1s7td;
        Thu, 15 Dec 2022 15:51:43 +0100 (CET)
Received: from localhost (dynscan3.mnet-online.de [192.168.6.84])
        by mail.m-online.net (Postfix) with ESMTP id 4NXwDG6gW7z1qqlR;
        Thu, 15 Dec 2022 15:51:42 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan3.mail.m-online.net [192.168.6.84]) (amavisd-new, port 10024)
        with ESMTP id MCfDl9-9q1u1; Thu, 15 Dec 2022 15:51:41 +0100 (CET)
X-Auth-Info: kSr35qTNpPStqMNbyk6H06PVKUXS/dvOYpUkCovEhc47FsWskNcys0YbNBFvy8Yd
Received: from hawking (unknown [81.95.8.244])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Thu, 15 Dec 2022 15:51:41 +0100 (CET)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Laight <David.Laight@aculab.com>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v9] kallsyms: Add self-test facility
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
        <CAMuHMdWM6+pC3yUqy+hHRrAf1BCz2sz1KQv2zxS+Wz-639X-aA@mail.gmail.com>
        <ad09966d-9357-1c32-e491-a402af8dac6e@huawei.com>
        <CAMuHMdW=KXfYc3Rqz6LizJcDxRX3BzUFTPpdTpDB68sw+QPJ=A@mail.gmail.com>
        <b00bcc04-0633-bac9-76ab-572f9470901c@huawei.com>
        <CAMuHMdWPSeieR-sGuozd3kWGjVw85EV40irqM9aErXufifzFNA@mail.gmail.com>
        <49070ac3-02bb-a3b3-b929-ede07e3b2c95@huawei.com>
        <CAMuHMdU2fge6UJwKAKOAFqtsnhVyfX80g703TRUoPRK_aeuu-w@mail.gmail.com>
X-Yow:  Loni Anderson's hair should be LEGALIZED!!
Date:   Thu, 15 Dec 2022 15:51:40 +0100
In-Reply-To: <CAMuHMdU2fge6UJwKAKOAFqtsnhVyfX80g703TRUoPRK_aeuu-w@mail.gmail.com>
        (Geert Uytterhoeven's message of "Thu, 15 Dec 2022 15:43:00 +0100")
Message-ID: <mvmlen8ra83.fsf@linux-m68k.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Dez 15 2022, Geert Uytterhoeven wrote:

>     start
>     kallsyms_lookup_name() for kallsyms_test_func_static failed:
> addr=8dbc, expect 60308
>     kallsyms_lookup_name() for kallsyms_test_func failed: addr=8dbc,
> expect 60318
>     kallsyms_lookup_name() for kallsyms_test_func_weak failed:
> addr=8dbc, expect 6031a
>     kallsyms_lookup_name() for vmalloc failed: addr=8dbc, expect bdc88
>     kallsyms_lookup_name() for vfree failed: addr=8dbc, expect bd6de

Curiously addr always comes out the same.  What symbol does it resolve
to?

>     kallsyms_on_each_match_symbol() for kallsyms_test_func_static
> failed: count=24890, addr=1ee870, expect 60308
>     kallsyms_on_each_match_symbol() for kallsyms_test_func failed:
> count=24890, addr=1ee870, expect 60318
>     kallsyms_on_each_match_symbol() for kallsyms_test_func_weak
> failed: count=24890, addr=1ee870, expect 6031a
>     kallsyms_on_each_match_symbol() for vmalloc failed: count=24890,
> addr=1ee870, expect bdc88
>     kallsyms_on_each_match_symbol() for vfree failed: count=24890,
> addr=1ee870, expect bd6de

Here too.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
