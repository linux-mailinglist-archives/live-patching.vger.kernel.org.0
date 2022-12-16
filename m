Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1970F64E994
	for <lists+live-patching@lfdr.de>; Fri, 16 Dec 2022 11:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiLPKkN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Dec 2022 05:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiLPKkL (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Dec 2022 05:40:11 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C6732B9C
        for <live-patching@vger.kernel.org>; Fri, 16 Dec 2022 02:40:09 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-146-QJ7PLL3zPnyq8AQFxhkC5g-1; Fri, 16 Dec 2022 10:40:07 +0000
X-MC-Unique: QJ7PLL3zPnyq8AQFxhkC5g-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 16 Dec
 2022 10:40:05 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Fri, 16 Dec 2022 10:40:05 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Geert Uytterhoeven' <geert@linux-m68k.org>,
        "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
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
Thread-Index: AQHZEIinzV5WljPUpEGVjsixemOWL65wUNlQ
Date:   Fri, 16 Dec 2022 10:40:04 +0000
Message-ID: <d2d6feddc28b4c12af06da84bd48d900@AcuMS.aculab.com>
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
 <CAMuHMdWM6+pC3yUqy+hHRrAf1BCz2sz1KQv2zxS+Wz-639X-aA@mail.gmail.com>
 <ad09966d-9357-1c32-e491-a402af8dac6e@huawei.com>
 <CAMuHMdW=KXfYc3Rqz6LizJcDxRX3BzUFTPpdTpDB68sw+QPJ=A@mail.gmail.com>
 <b00bcc04-0633-bac9-76ab-572f9470901c@huawei.com>
 <CAMuHMdWPSeieR-sGuozd3kWGjVw85EV40irqM9aErXufifzFNA@mail.gmail.com>
In-Reply-To: <CAMuHMdWPSeieR-sGuozd3kWGjVw85EV40irqM9aErXufifzFNA@mail.gmail.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

RnJvbTogR2VlcnQgVXl0dGVyaG9ldmVuIA0KPiBTZW50OiAxNSBEZWNlbWJlciAyMDIyIDEzOjI1
DQouLi4NCj4gTG9va3MgbGlrZSBjb21taXQgM2JjNzUzYzA2ZGQwMmEzNSAoImtidWlsZDogdHJl
YXQgY2hhciBhcyBhbHdheXMNCj4gdW5zaWduZWQiKSBpcyB0byBibGFtZS4NCj4gDQo+IENoYW5n
aW5nOg0KPiANCj4gICAgIC0tLSBhL2FyY2gvbTY4ay9pbmNsdWRlL2FzbS9zdHJpbmcuaA0KPiAg
ICAgKysrIGIvYXJjaC9tNjhrL2luY2x1ZGUvYXNtL3N0cmluZy5oDQo+ICAgICBAQCAtNDIsNyAr
NDIsNyBAQCBzdGF0aWMgaW5saW5lIGNoYXIgKnN0cm5jcHkoY2hhciAqZGVzdCwgY29uc3QNCj4g
Y2hhciAqc3JjLCBzaXplX3QgbikNCj4gICAgICAjZGVmaW5lIF9fSEFWRV9BUkNIX1NUUkNNUA0K
PiAgICAgIHN0YXRpYyBpbmxpbmUgaW50IHN0cmNtcChjb25zdCBjaGFyICpjcywgY29uc3QgY2hh
ciAqY3QpDQo+ICAgICAgew0KPiAgICAgLSAgICAgICBjaGFyIHJlczsNCj4gICAgICsgICAgICAg
c2lnbmVkIGNoYXIgcmVzOw0KPiANCj4gICAgICAgICAgICAgYXNtICgiXG4iDQo+ICAgICAgICAg
ICAgICAgICAgICAgIjE6ICAgICBtb3ZlLmIgICglMCkrLCUyXG4iICAgICAvKiBnZXQgKmNzICov
DQo+IA0KPiBmaXhlcyBzdHJjbXAsIGJ1dCB0aGUgdGVzdCBzdGlsbCBmYWlsczoNCg0KVHJ5ICdp
bnQgcmVzOycgYW5kIGFuIGV4cGxpY2l0IHNpZ24gZXh0ZW5kIChJIHRoaW5rKToNCgkiMzogZXh0
YiAlMlxuIg0KDQpUaGUgc3RyY21wKCkgaXMgc3RpbGwgd3JvbmcgaWYgZWl0aGVyIGlucHV0IHN0
cmluZw0KaGFzIGNoYXJhY3RlcnMgd2l0aCB0aGUgdG9wIGJpdCBzZXQuDQpUaGUgcmVzdWx0IG5l
ZWRzIHRvIGJlIGJhc2VkIG9mIHRoZSBjYXJyeSBmbGFnIG5vdA0KdGhlIHNpZ24gb2YgdGhlIGJ5
dGUgc3VidHJhY3QuDQoNCkl0IGlzIHRvbyBsb25nIHNpbmNlIEkndmUgd3JpdHRlbiBtNjhrIGFz
bS4NCkkndmUgY2hlY2tlZCwgYWxsIGJ5dGUgb3BlcmF0aW9ucyBsZWF2ZSB0aGUgaGlnaCAyNGJp
dHMNCnVuY2hhbmdlZC4NClNvIGl0IGlzIHBvc3NpYmxlIHRoYXQgZ2NjIGlzIG1ha2luZyBhc3N1
bXB0aW9ucyBhbmQNCnNraXBwaW5nIHRoZSBzaWduIGV4dGVuZCB1bmRlciBzb21lIGNpcmN1bXN0
YW5jZXMuDQoNCglEYXZpZA0KDQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1s
ZXkgUm9hZCwgTW91bnQgRmFybSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJh
dGlvbiBObzogMTM5NzM4NiAoV2FsZXMpDQo=

