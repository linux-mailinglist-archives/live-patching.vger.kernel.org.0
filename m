Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947D164EDD3
	for <lists+live-patching@lfdr.de>; Fri, 16 Dec 2022 16:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiLPPZv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Dec 2022 10:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiLPPZu (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Dec 2022 10:25:50 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16A021E1A
        for <live-patching@vger.kernel.org>; Fri, 16 Dec 2022 07:25:48 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-80-_OXu78BEO5abMLAtHBU1jQ-1; Fri, 16 Dec 2022 15:25:46 +0000
X-MC-Unique: _OXu78BEO5abMLAtHBU1jQ-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 16 Dec
 2022 15:25:42 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Fri, 16 Dec 2022 15:25:42 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Andreas Schwab' <schwab@linux-m68k.org>
CC:     "'Leizhen (ThunderTown)'" <thunder.leizhen@huawei.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Masahiro Yamada" <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "Jiri Olsa" <jolsa@kernel.org>, Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: RE: [PATCH v9] kallsyms: Add self-test facility
Thread-Topic: [PATCH v9] kallsyms: Add self-test facility
Thread-Index: AQHZEWHMzV5WljPUpEGVjsixemOWL65wodIQ
Date:   Fri, 16 Dec 2022 15:25:42 +0000
Message-ID: <1ba1fadb39994a4d91edabdfd9d69fa6@AcuMS.aculab.com>
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
        <CAMuHMdWM6+pC3yUqy+hHRrAf1BCz2sz1KQv2zxS+Wz-639X-aA@mail.gmail.com>
        <ad09966d-9357-1c32-e491-a402af8dac6e@huawei.com>
        <CAMuHMdW=KXfYc3Rqz6LizJcDxRX3BzUFTPpdTpDB68sw+QPJ=A@mail.gmail.com>
        <b00bcc04-0633-bac9-76ab-572f9470901c@huawei.com>
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
In-Reply-To: <87pmcjidfe.fsf@igel.home>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Andreas Schwab <schwab@linux-m68k.org>
> Sent: 16 December 2022 15:20
> 
> On Dez 16 2022, David Laight wrote:
> 
> > 'cs' and 'ct' should be input parameters.
> 
> They are (and output as well).

Right, but the 'output' values aren't needed and get
discarded because the asm block in inside a static inline.

It could be a recipe just waiting to go wrong.

But I bet the actual problem is the output register
aliasing one of the inputs and then reading from very
low user addresses - I bet they don't fault on m68k.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

