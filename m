Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1C2612306
	for <lists+live-patching@lfdr.de>; Sat, 29 Oct 2022 14:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiJ2MtX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 29 Oct 2022 08:49:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbiJ2MtW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 29 Oct 2022 08:49:22 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845E95EDF8
        for <live-patching@vger.kernel.org>; Sat, 29 Oct 2022 05:49:21 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-252-8G--BZdzMhu3J2EzxiGSXw-1; Sat, 29 Oct 2022 13:49:18 +0100
X-MC-Unique: 8G--BZdzMhu3J2EzxiGSXw-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sat, 29 Oct
 2022 13:49:17 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.042; Sat, 29 Oct 2022 13:49:17 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "'Leizhen (ThunderTown)'" <thunder.leizhen@huawei.com>,
        Luis Chamberlain <mcgrof@kernel.org>
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
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: RE: [PATCH v7 00/11] kallsyms: Optimizes the performance of lookup
 symbols
Thread-Topic: [PATCH v7 00/11] kallsyms: Optimizes the performance of lookup
 symbols
Thread-Index: AQHY623+53cs6bIWsU+vWlwnXrR/Ha4lTb6Q
Date:   Sat, 29 Oct 2022 12:49:17 +0000
Message-ID: <9e4892b540584b25aa5481cc40f1fb42@AcuMS.aculab.com>
References: <20221017064950.2038-1-thunder.leizhen@huawei.com>
 <Y0/nEngJF6bbINEx@bombadil.infradead.org>
 <ad9e51c6-f77d-d9e9-9c13-42fcbbde7147@huawei.com>
 <Y1gisUFzgt1D1Jle@bombadil.infradead.org>
 <77f1c8f0-5e67-0e57-9285-15ba613044fb@huawei.com>
 <Y1mEiIvbld4SX1lx@bombadil.infradead.org>
 <4f06547b-456f-e1ec-c535-16577f502ff1@huawei.com>
 <d7393d45-84bb-9e7b-99f4-412eb9223208@huawei.com>
 <712fae84-aadc-7d29-f311-a3352bab6346@huawei.com>
In-Reply-To: <712fae84-aadc-7d29-f311-a3352bab6346@huawei.com>
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

PiA+PiBPbiAyMDIyLzEwLzI3IDM6MDMsIEx1aXMgQ2hhbWJlcmxhaW4gd3JvdGU6DQo+ID4+PiBP
biBXZWQsIE9jdCAyNiwgMjAyMiBhdCAwMjo0NDozNlBNICswODAwLCBMZWl6aGVuIChUaHVuZGVy
VG93bikgd3JvdGU6DQo+ID4+Pj4gT24gMjAyMi8xMC8yNiAxOjUzLCBMdWlzIENoYW1iZXJsYWlu
IHdyb3RlOg0KPiA+Pj4+PiBUaGlzIGFuc3dlcnMgaG93IHdlIGRvbid0IHVzZSBhIGhhc2ggdGFi
bGUsIHRoZSBxdWVzdGlvbiB3YXMgKnNob3VsZCogd2UNCj4gPj4+Pj4gdXNlIG9uZT8NCg0KKFBy
b2JhYmx5IGJyYWluZmFydCkgdGhvdWdodC4uLg0KDQpJcyB0aGUgY3VycmVudCB0YWJsZSAoZWZm
ZWN0aXZlbHkpIGEgc29ydGVkIGxpc3Qgb2Ygc3RyaW5ncz8NClNvIHRoZSBsb29rdXAgaXMgYSBi
aW5hcnkgY2hvcCAtIHNvIE8obG9nKG4pKS4NCg0KQnV0IHlvdXIgaGFzaGVzIGFyZSBoYXZpbmcg
J3Ryb3VibGUnIHN0b3BwaW5nIG9uZSBjaGFpbg0KYmVpbmcgdmVyeSBsb25nPw0KU28gYSBsaW5l
YXIgc2VhcmNoIG9mIHRoYXQgaGFzaCBjaGFpbiBpcyBzbG93Lg0KSW4gZmFjdCB0aGF0IHNvcnQg
b2YgaGFzaGVkIGxvb2t1cCBpbiBPKG4pLg0KDQpXaGF0IGlmIHRoZSBzeW1ib2xzIHdlcmUgc29y
dGVkIGJ5IGhhc2ggdGhlbiBuYW1lPw0KKFdpdGhvdXQgcHV0dGluZyB0aGUgaGFzaCBpbnRvIGVh
Y2ggZW50cnkuKQ0KVGhlbiB0aGUgY29kZSBjb3VsZCBkbyBhIGJpbmFyeSBjaG9wIHNlYXJjaCBv
dmVyDQp0aGUgc3ltYm9scyB3aXRoIHRoZSBzYW1lIGhhc2ggdmFsdWUuDQpUaGUgYWRkaXRpb25h
bCBkYXRhIGlzIHRoZW4gYW4gYXJyYXkgb2Ygc3ltYm9sIG51bWJlcnMNCmluZGV4ZWQgYnkgdGhl
IGhhc2ggLSAzMiBiaXRzIGZvciBlYWNoIGJ1Y2tldC4NCg0KSWYgdGhlIGhhc2ggdGFibGUgaGFz
IDB4MTAwMCBlbnRyaWVzIGl0IHNhdmVzIDEyIGNvbXBhcmVzLg0KKEFsbCBvZiB3aGljaCBhcmUg
bGlrZWx5IHRvIGJlIGRhdGEgY2FjaGUgbWlzc2VzLikNCg0KSWYgeW91IGFkZCB0aGUgaGFzaCB0
byBlYWNoIHRhYmxlIGVudHJ5IHRoZW4geW91IGNhbiBkbw0KYSBiaW5hcnkgY2hvcCBzZWFyY2gg
Zm9yIHRoZSBoYXNoIGl0c2VsZi4NCldoaWxlIHRoaXMgaXMgdGhlIHNhbWUgc2VhcmNoIGFzIGlz
IGRvbmUgZm9yIHRoZSBzdHJpbmdzDQp0aGUgY29tcGFyaXNvbiAoanVzdCBhIG51bWJlcikgd2ls
bCBiZSBmYXN0ZXIgdGhhbiBhDQpzdHJpbmcgY29tcGFyZS4NCg0KCURhdmlkDQoNCi0NClJlZ2lz
dGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0b24g
S2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykNCg==

