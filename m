Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63AE664ED19
	for <lists+live-patching@lfdr.de>; Fri, 16 Dec 2022 15:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiLPOpG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Dec 2022 09:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiLPOpE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Dec 2022 09:45:04 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9685D699
        for <live-patching@vger.kernel.org>; Fri, 16 Dec 2022 06:45:03 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-62-OHQrkBEPO8-3KvAViQxO2w-1; Fri, 16 Dec 2022 14:45:00 +0000
X-MC-Unique: OHQrkBEPO8-3KvAViQxO2w-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Fri, 16 Dec
 2022 14:44:58 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Fri, 16 Dec 2022 14:44:58 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     David Laight <David.Laight@ACULAB.COM>,
        "'Leizhen (ThunderTown)'" <thunder.leizhen@huawei.com>,
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
Thread-Index: AQHZEUYmzV5WljPUpEGVjsixemOWL65wgKUggAAUk7A=
Date:   Fri, 16 Dec 2022 14:44:58 +0000
Message-ID: <592dce7a0de24c62bd31c29f86ce6c1b@AcuMS.aculab.com>
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
In-Reply-To: <52450ec1da164d6d87587063c3b3d3d2@AcuMS.aculab.com>
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

RnJvbTogRGF2aWQgTGFpZ2h0DQo+IFNlbnQ6IDE2IERlY2VtYmVyIDIwMjIgMTM6MzANCj4gDQo+
IEZyb206IExlaXpoZW4gKFRodW5kZXJUb3duKQ0KPiA+IFNlbnQ6IDE2IERlY2VtYmVyIDIwMjIg
MTI6MDINCj4gPg0KPiAuLg0KPiA+ID4gTW92aW5nIHRoZSBtNjhrIHZlcnNpb24gaW5zaWRlIGxp
Yi9zdHJpbmcuYyBtYWtlcyB0aGUgdGVzdCBwYXNzLCB0b28uDQo+ID4gPiBTbyBpdCBtdXN0IGJl
IHJlbGF0ZWQgdG8gdGhlIGZ1bmN0aW9uIGJlaW5nIGlubGluZSwgYW5kIGdjYyBtYWtpbmcNCj4g
PiA+IChpbmNvcnJlY3QpIGFzc3VtcHRpb25zLi4uDQo+ID4NCj4gPiBZZXMsIGl0J3MgdGhlIGNv
bXBpbGVyJ3MgZmF1bHQuIEkganVzdCByZXBsaWVkIERhdmlkIExhaWdodDoNCj4gPg0KPiA+IEkg
YWRkZWQgJ3ZvbGF0aWxlJyB0byBwcmV2ZW50IGNvbXBpbGVyIG9wdGltaXphdGlvbnMsIGFuZCBp
dCdzIE9LIG5vdy4NCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL202OGsvaW5jbHVkZS9hc20v
c3RyaW5nLmggYi9hcmNoL202OGsvaW5jbHVkZS9hc20vc3RyaW5nLmgNCj4gPiBpbmRleCBmNzU5
ZDk0NGM0NDk5NDAuLjNkYjgxZTVhNzgzYzcyYSAxMDA2NDQNCj4gPiAtLS0gYS9hcmNoL202OGsv
aW5jbHVkZS9hc20vc3RyaW5nLmgNCj4gPiArKysgYi9hcmNoL202OGsvaW5jbHVkZS9hc20vc3Ry
aW5nLmgNCj4gPiBAQCAtNDIsOSArNDIsOSBAQCBzdGF0aWMgaW5saW5lIGNoYXIgKnN0cm5jcHko
Y2hhciAqZGVzdCwgY29uc3QgY2hhciAqc3JjLCBzaXplX3QgbikNCj4gPiAgI2RlZmluZSBfX0hB
VkVfQVJDSF9TVFJDTVANCj4gPiAgc3RhdGljIGlubGluZSBpbnQgc3RyY21wKGNvbnN0IGNoYXIg
KmNzLCBjb25zdCBjaGFyICpjdCkNCj4gPiAgew0KPiA+IC0gICAgICAgY2hhciByZXM7DQo+ID4g
KyAgICAgICBzaWduZWQgY2hhciByZXM7DQo+ID4NCj4gPiAtICAgICAgIGFzbSAoIlxuIg0KPiA+
ICsgICAgICAgYXNtIHZvbGF0aWxlICgiXG4iDQo+ID4gICAgICAgICAgICAgICAgICIxOiAgICAg
bW92ZS5iICAoJTApKywlMlxuIiAgICAgLyogZ2V0ICpjcyAqLw0KPiA+ICAgICAgICAgICAgICAg
ICAiICAgICAgIGNtcC5iICAgKCUxKSssJTJcbiIgICAgIC8qIGNvbXBhcmUgYSBieXRlICovDQo+
ID4gICAgICAgICAgICAgICAgICIgICAgICAgam5lICAgICAyZlxuIiAgICAgICAgICAgLyogbm90
IGVxdWFsLCBicmVhayBvdXQgKi8NCj4gDQo+IEFkZGluZyAndm9sYXRpbGUnIHRoZXJlIHNob3Vs
ZG4ndCBtYWtlIGFueSByZWFsIGRpZmZlcmVuY2UuDQo+IA0KPiBJJ2QgZG91YmxlLWNoZWNrIHRo
ZSBhc20gY29uc3RyYWludHMgZm9yIHRoZSB0d28gcG9pbnRlcnMuDQo+IFRoZXkgYXJlIG1vZGlm
aWVkIGJ5IHRoZSBhc20sIGJ1dCB0aGUgY2FsbGVyJ3MgdmFyaWFibGVzDQo+IG11c3Qgbm90IGJl
IGNoYW5nZWQuDQo+IA0KPiBJIHRoaW5rIHRoYXQgbWVhbnMgdGhleSBuZWVkIHRvIGJlIG5vcm1h
bCAnaW5wdXQnIHBhcmFtZXRlcnMNCj4gYW5kIHRoZSByZXN1bHQgbXVzdCBiZSBpbiBkaWZmZXJl
bnQgcmVnaXN0ZXIgKGVhcmx5IGNsb2JiZXI/KS4NCj4gQ3VycmVudGx5IHRoZSBwb2ludGVycyBh
cmUgIityIiAtIHdoaWNoIEkgdGhpbmsgbWVhbnMgdGhleQ0KPiBhcmUgaW5wdXQtb3V0cHV0IGFu
ZCBhbnkgY2FsbGVyLXN1cHBsaWVkIHZhcmlhYmxlIGlzDQo+IGxpa2VseSB0byBnZXQgY2hhbmdl
ZC4NCg0KRGVmaW5pdGVseSBiYWRseSBicm9rZW4uDQonY3MnIGFuZCAnY3QnIHNob3VsZCBiZSBp
bnB1dCBwYXJhbWV0ZXJzLg0KJ3JlcycgbmVlZHMgdG8gYmUgYW4gZWFybHktY2xvYmJlciBvdXRw
dXQgcGFyYW1ldGVyICI9JnIiLg0KDQpTaW5jZSBpdCBpcyBhY3R1YWxseSBhICdzdGF0aWMgaW5s
aW5lJyAobm90IGp1c3QgYSAjZGVmaW5lKQ0KdGhlbiBsZXR0aW5nIGNzL2N0IGJlIGNoYW5nZWQg
cHJvYmFibHkgZG9lc24ndCBtYXR0ZXIuDQoNCkJ1dCB0aGUgbGFjayBvZiAnZWFybHkgY2xvYmJl
cicgd2lsbCBjYXVzZSBncmllZi4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQgQWRkcmVzcyBM
YWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVzLCBNSzEgMVBU
LCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

