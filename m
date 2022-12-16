Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B23B64F1CA
	for <lists+live-patching@lfdr.de>; Fri, 16 Dec 2022 20:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiLPT11 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Dec 2022 14:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231739AbiLPT1N (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Dec 2022 14:27:13 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA91205E3
        for <live-patching@vger.kernel.org>; Fri, 16 Dec 2022 11:27:11 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-232-f6oopNjgN3u_Fg6iRUy8Sg-1; Fri, 16 Dec 2022 19:27:08 +0000
X-MC-Unique: f6oopNjgN3u_Fg6iRUy8Sg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 16 Dec
 2022 19:27:06 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Fri, 16 Dec 2022 19:27:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Steven Rostedt' <rostedt@goodmis.org>
CC:     'Andreas Schwab' <schwab@linux-m68k.org>,
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
Subject: RE: [PATCH v9] kallsyms: Add self-test facility
Thread-Topic: [PATCH v9] kallsyms: Add self-test facility
Thread-Index: AQHZEWkbzV5WljPUpEGVjsixemOWL65wtOBggAAGFACAAAApIIAADHsSgAAbgaA=
Date:   Fri, 16 Dec 2022 19:27:06 +0000
Message-ID: <83701d57c0064c709669c03cecc38356@AcuMS.aculab.com>
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
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
        <20221216121947.7d03b651@gandalf.local.home>
 <20221216123805.6eba002c@gandalf.local.home>
In-Reply-To: <20221216123805.6eba002c@gandalf.local.home>
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

From: Steven Rostedt
> Sent: 16 December 2022 17:38
> 
> On Fri, 16 Dec 2022 12:19:47 -0500
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > I assumed that "memory" was for memory unrelated to the input constraints.
> 
> Well, it looks like you do need a "memory" barrier.
> 
>   https://gcc.gnu.org/onlinedocs/gcc/Extended-Asm.html
> 
> "memory"
> 
>       The "memory" clobber tells the compiler that the assembly code
>       performs memory reads or writes to items other than those listed in
>       the input and output operands (for example, accessing the memory
>       pointed to by one of the input parameters). To ensure memory contains
>       correct values, GCC may need to flush specific register values to
>       memory before executing the asm. Further, the compiler does not
>       assume that any values read from memory before an asm remain
>       unchanged after that asm; it reloads them as needed. Using the
>       "memory" clobber effectively forms a read/write memory barrier for
>       the compiler.
> 
> As the "(for example, accessing the memory pointed to by one of the input
> parameters)" is exactly this case.

Without the memory clobber code like:
int f(const char *s)
{
	char c[4] = "abc";
	return strcmp(s, c);
}
is very like to get optimised so that c[] is never written.

However, in this case, the strings have all existed for ages.
So that won't be the problem.

It might be obvious what is wrong from the asm output.
Although the binary-chop lookup is suspect I'd also check
that the sorted index is plausible - just tracing the first
20 entries might be enough.
No point peering at the search code if the setup is wrong.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

