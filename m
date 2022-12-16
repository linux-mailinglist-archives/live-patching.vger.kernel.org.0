Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5883364EC18
	for <lists+live-patching@lfdr.de>; Fri, 16 Dec 2022 14:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiLPNaI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Dec 2022 08:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiLPNaG (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Dec 2022 08:30:06 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB3433C15
        for <live-patching@vger.kernel.org>; Fri, 16 Dec 2022 05:30:04 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-59-7khLQNjFOCWNJyYbrxwnNQ-1; Fri, 16 Dec 2022 13:30:02 +0000
X-MC-Unique: 7khLQNjFOCWNJyYbrxwnNQ-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 16 Dec
 2022 13:29:59 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Fri, 16 Dec 2022 13:29:59 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Leizhen (ThunderTown)'" <thunder.leizhen@huawei.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Luis Chamberlain" <mcgrof@kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Ingo Molnar" <mingo@redhat.com>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: RE: [PATCH v9] kallsyms: Add self-test facility
Thread-Topic: [PATCH v9] kallsyms: Add self-test facility
Thread-Index: AQHZEUYmzV5WljPUpEGVjsixemOWL65wgKUg
Date:   Fri, 16 Dec 2022 13:29:59 +0000
Message-ID: <52450ec1da164d6d87587063c3b3d3d2@AcuMS.aculab.com>
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
In-Reply-To: <06345dca-0afb-00a5-c9e9-5ba830d8ad05@huawei.com>
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
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

RnJvbTogTGVpemhlbiAoVGh1bmRlclRvd24pDQo+IFNlbnQ6IDE2IERlY2VtYmVyIDIwMjIgMTI6
MDINCj4gDQouLg0KPiA+IE1vdmluZyB0aGUgbTY4ayB2ZXJzaW9uIGluc2lkZSBsaWIvc3RyaW5n
LmMgbWFrZXMgdGhlIHRlc3QgcGFzcywgdG9vLg0KPiA+IFNvIGl0IG11c3QgYmUgcmVsYXRlZCB0
byB0aGUgZnVuY3Rpb24gYmVpbmcgaW5saW5lLCBhbmQgZ2NjIG1ha2luZw0KPiA+IChpbmNvcnJl
Y3QpIGFzc3VtcHRpb25zLi4uDQo+IA0KPiBZZXMsIGl0J3MgdGhlIGNvbXBpbGVyJ3MgZmF1bHQu
IEkganVzdCByZXBsaWVkIERhdmlkIExhaWdodDoNCj4gDQo+IEkgYWRkZWQgJ3ZvbGF0aWxlJyB0
byBwcmV2ZW50IGNvbXBpbGVyIG9wdGltaXphdGlvbnMsIGFuZCBpdCdzIE9LIG5vdy4NCj4gDQo+
IGRpZmYgLS1naXQgYS9hcmNoL202OGsvaW5jbHVkZS9hc20vc3RyaW5nLmggYi9hcmNoL202OGsv
aW5jbHVkZS9hc20vc3RyaW5nLmgNCj4gaW5kZXggZjc1OWQ5NDRjNDQ5OTQwLi4zZGI4MWU1YTc4
M2M3MmEgMTAwNjQ0DQo+IC0tLSBhL2FyY2gvbTY4ay9pbmNsdWRlL2FzbS9zdHJpbmcuaA0KPiAr
KysgYi9hcmNoL202OGsvaW5jbHVkZS9hc20vc3RyaW5nLmgNCj4gQEAgLTQyLDkgKzQyLDkgQEAg
c3RhdGljIGlubGluZSBjaGFyICpzdHJuY3B5KGNoYXIgKmRlc3QsIGNvbnN0IGNoYXIgKnNyYywg
c2l6ZV90IG4pDQo+ICAjZGVmaW5lIF9fSEFWRV9BUkNIX1NUUkNNUA0KPiAgc3RhdGljIGlubGlu
ZSBpbnQgc3RyY21wKGNvbnN0IGNoYXIgKmNzLCBjb25zdCBjaGFyICpjdCkNCj4gIHsNCj4gLSAg
ICAgICBjaGFyIHJlczsNCj4gKyAgICAgICBzaWduZWQgY2hhciByZXM7DQo+IA0KPiAtICAgICAg
IGFzbSAoIlxuIg0KPiArICAgICAgIGFzbSB2b2xhdGlsZSAoIlxuIg0KPiAgICAgICAgICAgICAg
ICAgIjE6ICAgICBtb3ZlLmIgICglMCkrLCUyXG4iICAgICAvKiBnZXQgKmNzICovDQo+ICAgICAg
ICAgICAgICAgICAiICAgICAgIGNtcC5iICAgKCUxKSssJTJcbiIgICAgIC8qIGNvbXBhcmUgYSBi
eXRlICovDQo+ICAgICAgICAgICAgICAgICAiICAgICAgIGpuZSAgICAgMmZcbiIgICAgICAgICAg
IC8qIG5vdCBlcXVhbCwgYnJlYWsgb3V0ICovDQoNCkFkZGluZyAndm9sYXRpbGUnIHRoZXJlIHNo
b3VsZG4ndCBtYWtlIGFueSByZWFsIGRpZmZlcmVuY2UuDQoNCkknZCBkb3VibGUtY2hlY2sgdGhl
IGFzbSBjb25zdHJhaW50cyBmb3IgdGhlIHR3byBwb2ludGVycy4NClRoZXkgYXJlIG1vZGlmaWVk
IGJ5IHRoZSBhc20sIGJ1dCB0aGUgY2FsbGVyJ3MgdmFyaWFibGVzDQptdXN0IG5vdCBiZSBjaGFu
Z2VkLg0KDQpJIHRoaW5rIHRoYXQgbWVhbnMgdGhleSBuZWVkIHRvIGJlIG5vcm1hbCAnaW5wdXQn
IHBhcmFtZXRlcnMNCmFuZCB0aGUgcmVzdWx0IG11c3QgYmUgaW4gZGlmZmVyZW50IHJlZ2lzdGVy
IChlYXJseSBjbG9iYmVyPykuDQpDdXJyZW50bHkgdGhlIHBvaW50ZXJzIGFyZSAiK3IiIC0gd2hp
Y2ggSSB0aGluayBtZWFucyB0aGV5DQphcmUgaW5wdXQtb3V0cHV0IGFuZCBhbnkgY2FsbGVyLXN1
cHBsaWVkIHZhcmlhYmxlIGlzDQpsaWtlbHkgdG8gZ2V0IGNoYW5nZWQuDQoNCglEYXZpZA0KDQoJ
DQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBG
YXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2
IChXYWxlcykNCg==

