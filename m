Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0A464FB57
	for <lists+live-patching@lfdr.de>; Sat, 17 Dec 2022 18:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiLQRhW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 17 Dec 2022 12:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLQRhV (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 17 Dec 2022 12:37:21 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06BB1144E
        for <live-patching@vger.kernel.org>; Sat, 17 Dec 2022 09:37:19 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-180-orGdr5X-MxKcGNPDPyiq_g-1; Sat, 17 Dec 2022 17:37:16 +0000
X-MC-Unique: orGdr5X-MxKcGNPDPyiq_g-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sat, 17 Dec
 2022 17:37:14 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.044; Sat, 17 Dec 2022 17:37:14 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Geert Uytterhoeven' <geert@linux-m68k.org>,
        "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
CC:     Steven Rostedt <rostedt@goodmis.org>,
        Andreas Schwab <schwab@linux-m68k.org>,
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
        Ingo Molnar <mingo@redhat.com>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: RE: [PATCH v9] kallsyms: Add self-test facility
Thread-Topic: [PATCH v9] kallsyms: Add self-test facility
Thread-Index: AQHZEWkbzV5WljPUpEGVjsixemOWL65wtOBggAAGFACAAAApIIAADHsSgAAbgaCAATN6O4AAPulA
Date:   Sat, 17 Dec 2022 17:37:14 +0000
Message-ID: <b673f98db7d14d53a6e1a1957ef81741@AcuMS.aculab.com>
References: <20221115083349.1662-1-thunder.leizhen@huawei.com>
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
 <83701d57c0064c709669c03cecc38356@AcuMS.aculab.com>
 <066d4a61-3df9-b9c8-81a2-40dfcd3c73ef@huawei.com>
 <CAMuHMdXeusQbcfymQpKD4EWjBgKF4Wr8o2LyJhyaj3tS2MKTiQ@mail.gmail.com>
In-Reply-To: <CAMuHMdXeusQbcfymQpKD4EWjBgKF4Wr8o2LyJhyaj3tS2MKTiQ@mail.gmail.com>
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

RnJvbTogR2VlcnQgVXl0dGVyaG9ldmVuDQo+IFNlbnQ6IDE3IERlY2VtYmVyIDIwMjIgMTM6MzcN
Ci4uLg0KPiA+IFNvIGl0J3MgcXVpdGUgcG9zc2libGUgKEkgZGlkbid0IGRpc2Fzc2VtYmxlIHZt
bGludXgsIGJlY2F1c2UgSSBkaWRuJ3QgbGVhcm4gbTY4ayk6DQoNClByZXR0eSBlYXN5IHRvIHJl
YWQgaXQuDQoNCi4uLg0KPiA+IC8vYmluYXJ5IHNlYXJjaA0KPiA+IHdoaWxlIChsb3cgPD0gaGln
aCkgew0KPiA+ICAgICAuLi4NCj4gPiAgICAgcmV0ID0gY29tcGFyZV9zeW1ib2xfbmFtZShuYW1l
LCBuYW1lYnVmKTsgICAtLS0tPiAoMSkNCj4gPiAgICAgaWYgKCFyZXQpDQo+ID4gICAgICAgICBi
cmVhazsNCj4gPiB9DQo+ID4NCj4gPiBsb3cgPSBtaWQ7DQo+ID4gd2hpbGUgKGxvdykgew0KPiA+
ICAgICAuLi4NCj4gPiAgICAgaWYgKGNvbXBhcmVfc3ltYm9sX25hbWUobmFtZSwgbmFtZWJ1Zikp
ICAgICAtLS0tPiAoMikNCj4gPiAgICAgICAgIGJyZWFrOw0KPiA+ICAgICBsb3ctLTsNCj4gPiB9
DQo+ID4NCj4gPiBUaGUgcG9pbnRlciAnbmFtZScgYW5kICduYW1lYnVmJyBvZiAoMSkgYW5kICgy
KSBhcmUgdGhlIHNhbWUsDQo+ID4gc28gdGhlICdpZicgc3RhdGVtZW50IG9mICgyKSBtYXliZSBv
bWl0dGVkIGJ5IGNvbXBpbGVyLg0KPiANCj4gQW5kIHRoYXQgaXMgZXhhY3RseSB3aGF0IGlzIGhh
cHBlbmluZzogdGhlcmUgYXJlIDMgY2FsbHMgdG8gc3RyY21wKCkNCj4gd2l0aCB0aGUgZXhhY3Qg
c2FtZSBwYXJhbWV0ZXJzLCBhbmQgZ2NjIG9taXRzIHR3byBvZiB0aGVtLCBiZWNhdXNlIGl0DQo+
IGFzc3VtZXMgaXQgY2FuIHByZWRpY3QgdGhlIG91dGNvbWUsIGFzIHRoZSBwYXJhbWV0ZXJzIGhh
dmVuJ3QgY2hhbmdlZC4NCg0KQWRkaXRpb25hbGx5IGlmIGthbGxzeW1zX2V4cGFuZF9zeW1ib2wo
KSBpcyBpbmxpbmVkIGFsbCB0aGUgd3JpdGVzDQppdCBkb2VzIHRvIG5hbWVidWZbXSBjYW4gZ2V0
IGRpc2NhcmRlZCAtIGJlY2F1c2UgdGhleSBhcmUgdXNlZC4NCldoaWNoIHByb2JhYmx5IGNhdXNl
cyB0aGUgZW50aXJlIGZ1bmN0aW9uIHRvIGdldCBvcHRpbWlzZWQgYXdheS4NCk1vcmUgY29kZSBm
b2xsb3dzIC0gdGhlcmUgY291bGQgZWFzaWx5IGJlIG5vdGhpbmcgbGVmdCBleGNlcHQNCnRoZSBi
aW5hcnkgY2hvcCBpdHNlbGYgdGhhdCBlbnN1cmVzIHRoZSBsb29wIHRlcm1pbmF0ZXMuDQoNCj4g
Tm93LCB3aHkgaGF2ZSB3ZSBuZXZlciBub3RpY2VkIHRoaXMgYmVmb3JlPyBJIGd1ZXNzIGJlY2F1
c2UgaXQgaXMgdmVyeQ0KPiB1bmNvbW1vbiBmb3IgYSBmdW5jdGlvbiBjYWxsaW5nIHN0cmNtcCgp
IG11bHRpcGxlIHRpbWVzIHdpdGggdGhlIGV4YWN0DQo+IHNhbWUgcG9pbnRlciBwYXJhbWV0ZXJz
LiAgQ29tbW9uIHVzZXJzIGNoYW5nZSB0aGUgcG9pbnRlcnMgYmVmb3JlDQo+IGV2ZXJ5IGNhbGws
IGluc3RlYWQgb2Yga2VlcGluZyB0aGUgcG9pbnRlciwgYnV0IGNoYW5naW5nIHRoZSBidWZmZXJz
Jw0KPiBjb250ZW50cyB0aGUgcG9pbnRlcnMgcG9pbnQgdG8uDQo+IA0KPiA+IEJ5IHRoZSB3YXks
IEkgdHJpZWQgbm8gdm9sYXRpbGUgYnV0IHdpdGgNCj4gPiArICAgICAgICAgICAgICAgOiA6ICJt
ZW1vcnkiKTsNCj4gPiBJdCBhbHNvIHdvcmtzIHdlbGwuDQo+IA0KPiBJbmRlZWQsIGdjYyB2ZXJz
aW9uIDkuNC4wIChVYnVudHUgOS40LjAtMXVidW50dTF+MjAuMDQpIGdlbmVyYXRlcyB0aGUNCj4g
c2FtZSBjb2RlIGZvciBlaXRoZXIgYWRkaW5nIHRoZSB2b2xhdGlsZSBvciB0aGUgbWVtb3J5IGNs
b2JiZXIuDQo+IA0KPiBOb3RlIHRoYXQgc3RyY21wKCkgaXMgdGhlIG9ubHkgZnVuY3Rpb24gaW4g
YXJjaC9tNjhrL2luY2x1ZGUvYXNtL3N0cmluZy5oDQo+IHVzaW5nIGlubGluZSBhc20gd2l0aG91
dCB0aGUgdm9sYXRpbGUga2V5d29yZC4gIEkgZ3Vlc3Mgd2Ugd291bGQNCj4gc2VlIHNpbWlsYXIg
aXNzdWVzIHdpdGggc3RybmxlbigpICh3aGljaCBhbHNvIGRvZXNuJ3QgbW9kaWZ5IG1lbW9yeSkN
Cj4gd2hlbiBkcm9wcGluZyB0aGUgdm9sYXRpbGUuDQoNClRoZSAndm9sYXRpbGUnIGVuc3VyZXMg
dGhhdCBzdHJjbXAoKSBkb2Vzbid0IGdldCB0aHJvd24gYXdheS4NCkl0IGRvZXNuJ3QgZW5zdXJl
IHRoYXQgdGhlIHdyaXRlcyB0byBuYW1lYnVmW10gYXJlbid0IG9wdGltaXNlZCBhd2F5Lg0KDQpP
bmx5IHRoZSBtZW1vcnkgY2xvYmJlciBkb2VzIHRoYXQuDQoNClNvIGFsbCB0aG9zZSBhc20gZnVu
Y3Rpb25zIG5lZWQgdGhlIG1lbW9yeSBjbG9iYmVyLg0KVGhleSBwcm9iYWJseSBkb24ndCBuZWVk
IHZvbGF0aWxlIC0gc2luY2UgdGhlIGNhbGwgaGFzDQphIHJlc3VsdC4NCkluZGVlZCBzaW5jZSB0
aGUgbWVtb3J5IGNsb2JiZXIgYWxzbyBzYXlzICd3cml0ZXMgdG8gbWVtb3J5Jw0KaXQgbWF5IG1h
a2UgdGhlIHZvbGF0aWxlIHBvaW50bGVzcy4NCg0KSSdkIGFsc28gYWRkIHRoZSAnZWFybHkgY2xv
YmJlcicgYW5ub3RhdGlvbiB0byB0aGUgcmVzdWx0Lg0KSXQgbWF5IG5vdCBtYXR0ZXIgc2luY2Ug
dGhlIHBvaW50ZXJzIGFyZSBpbi1vdXQsIGJ1dCBzaW5jZQ0KdGhlIHBvaW50ZXIgb3V0cHV0cyBh
cmUgZGlzY2FyZGVkIHNvbWUgJ2JyYWluLWRhbWFnZWQnDQpyZWdpc3RlciBhbGxvY2F0aW9uIG1p
Z2h0IGFzc2lnbiB0aGUgc2FtZSByZWdpc3Rlci4NCg0KCURhdmlkDQoNCi0NClJlZ2lzdGVyZWQg
QWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24gS2V5bmVz
LCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

