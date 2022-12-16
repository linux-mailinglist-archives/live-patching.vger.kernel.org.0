Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5820F64EB87
	for <lists+live-patching@lfdr.de>; Fri, 16 Dec 2022 13:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiLPMjS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Dec 2022 07:39:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiLPMjP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Dec 2022 07:39:15 -0500
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16C53136F;
        Fri, 16 Dec 2022 04:39:14 -0800 (PST)
Received: from frontend03.mail.m-online.net (unknown [192.168.6.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 4NYTDv24YLz1s94H;
        Fri, 16 Dec 2022 13:39:11 +0100 (CET)
Received: from localhost (dynscan3.mnet-online.de [192.168.6.84])
        by mail.m-online.net (Postfix) with ESMTP id 4NYTDt5Nxjz1qqlR;
        Fri, 16 Dec 2022 13:39:10 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan3.mail.m-online.net [192.168.6.84]) (amavisd-new, port 10024)
        with ESMTP id rTxTLGbYhnjR; Fri, 16 Dec 2022 13:39:09 +0100 (CET)
X-Auth-Info: S6wIooAYwydxgRhoxevAMWGBKEnrNIOuXeqxYKDO76yya3cZo4Z8xmmMmTU8T2uU
Received: from igel.home (aftr-62-216-205-197.dynamic.mnet-online.de [62.216.205.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 16 Dec 2022 13:39:09 +0100 (CET)
Received: by igel.home (Postfix, from userid 1000)
        id 010052C31C2; Fri, 16 Dec 2022 13:39:08 +0100 (CET)
From:   Andreas Schwab <schwab@linux-m68k.org>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        <live-patching@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        <linux-modules@vger.kernel.org>,
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
        <87len7k1yn.fsf@igel.home>
        <9f2d4035-c647-4bd9-ffff-b970a88bcc88@huawei.com>
X-Yow:  I want the presidency so bad I can already taste the hors d'oeuvres.
Date:   Fri, 16 Dec 2022 13:39:08 +0100
In-Reply-To: <9f2d4035-c647-4bd9-ffff-b970a88bcc88@huawei.com> (Leizhen's
        message of "Fri, 16 Dec 2022 19:57:51 +0800")
Message-ID: <87a63njzf7.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Dez 16 2022, Leizhen (ThunderTown) wrote:

> Why consider the high bit? It is not memcmp(). If the high bit is set,
> it is the user's fault.

Nope, the semantics of strcmp are defined on the full CHAR_MIN to
CHAR_MAX range.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 7578 EB47 D4E5 4D69 2510  2552 DF73 E780 A9DA AEC1
"And now for something completely different."
