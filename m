Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951B9750B5C
	for <lists+live-patching@lfdr.de>; Wed, 12 Jul 2023 16:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjGLOsQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 12 Jul 2023 10:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjGLOsO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 12 Jul 2023 10:48:14 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51671BB;
        Wed, 12 Jul 2023 07:48:12 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=ydzhang@linux.alibaba.com;NM=1;PH=DW;RN=8;SR=0;TI=W4_0.2.0_DEFAULT_21200BA9_1689173184100_o7001c94n;
Received: from WS-web (ydzhang@linux.alibaba.com[W4_0.2.0_DEFAULT_21200BA9_1689173184100_o7001c94n]) at Wed, 12 Jul 2023 22:48:07 +0800
Date:   Wed, 12 Jul 2023 22:48:07 +0800
From:   "wardenjohn" <ydzhang@linux.alibaba.com>
To:     "Josh Poimboeuf" <jpoimboe@kernel.org>
Cc:     "Bagas Sanjaya" <bagasdotme@gmail.com>, "jikos" <jikos@kernel.org>,
        "mbenes" <mbenes@suse.cz>, "pmladek" <pmladek@suse.com>,
        "joe.lawrence" <joe.lawrence@redhat.com>,
        "Kernel Live Patching" <live-patching@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Reply-To: "wardenjohn" <ydzhang@linux.alibaba.com>
Message-ID: <028ffb37-cbea-47fc-804b-a296e456682d.ydzhang@linux.alibaba.com>
Subject: =?UTF-8?B?UmU6IEZpeCBNQVhfU1RBQ0tfRU5UUklFUyBmcm9tIDEwMCB0byAzMg==?=
X-Mailer: [Alimail-Mailagent revision 85][W4_0.2.0][DEFAULT][Chrome]
MIME-Version: 1.0
References: <931aaecf-66b1-469a-8bc3-7126871a8464.ydzhang@linux.alibaba.com> <ZKpqpamE89nvgslC@debian.me> <b0ed2a6d-c91b-4c72-9cfc-4900f3a37d82.ydzhang@linux.alibaba.com>,<20230710171331.ycxrkttgmtzrwzk4@treble>
x-aliyun-mail-creator: W4_0.2.0_DEFAULT_QvNTW96aWxsYS81LjAgKE1hY2ludG9zaDsgSW50ZWwgTWFjIE9TIFggMTBfMTVfNykgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzExNC4wLjAuMCBTYWZhcmkvNTM3LjM2La
In-Reply-To: <20230710171331.ycxrkttgmtzrwzk4@treble>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

SXQgaXMgYSBwb3dlcmZ1bCBhbmQgY29udmluY2luZyBleHBsYW5hdGlvbiB0byBteSBwYXRjaC4K
VGhhbmtzIGZvciBwYXRpZW50bHkgYW5zd2VyaW5nIG15IHN1Z2dlc3RpbmcuIDopCgoKV2FyZGVu
am9obgotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tCkZyb206Sm9zaCBQb2ltYm9ldWYgPGpwb2ltYm9lQGtlcm5lbC5vcmc+ClNl
bmQgVGltZToyMDIz5bm0N+aciDEx5pelKOaYn+acn+S6jCkgMDE6MTMKVG86d2FyZGVuam9obiA8
eWR6aGFuZ0BsaW51eC5hbGliYWJhLmNvbT4KQ2M6QmFnYXMgU2FuamF5YSA8YmFnYXNkb3RtZUBn
bWFpbC5jb20+OyBqaWtvcyA8amlrb3NAa2VybmVsLm9yZz47IG1iZW5lcyA8bWJlbmVzQHN1c2Uu
Y3o+OyBwbWxhZGVrIDxwbWxhZGVrQHN1c2UuY29tPjsgam9lLmxhd3JlbmNlIDxqb2UubGF3cmVu
Y2VAcmVkaGF0LmNvbT47IEtlcm5lbCBMaXZlIFBhdGNoaW5nIDxsaXZlLXBhdGNoaW5nQHZnZXIu
a2VybmVsLm9yZz47IExpbnV4IEtlcm5lbCBNYWlsaW5nIExpc3QgPGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc+ClN1YmplY3Q6UmU6IEZpeCBNQVhfU1RBQ0tfRU5UUklFUyBmcm9tIDEwMCB0
byAzMgoKCk9uIFN1biwgSnVsIDA5LCAyMDIzIGF0IDA5OjA5OjE0UE0gKzA4MDAsIHdhcmRlbmpv
aG4gd3JvdGU6Cj4gT0ssIEkgd2lsbCByZXN1Ym1pdCB0aGUgcGF0Y2ggYnkgZ2l0LXNlbmQtZW1h
aWwoMSkgaW5zdGVhZC4gOikKPiAKPiBCdXQgSSB3YW50IGFzayBob3cgY2FuIEkgcHJvdmlkZSB0
aGUgTGluayB0byBkaXNjdXNzaW9uPwo+IEFuZCB3aGF0IGlzIHYyIHBhdGNoPwo+IEkgYW0gc29y
cnkgdGhhdCBpdCBpcyBteSBmaXJzdCB0aW1lIHRvIGpvaW4gdGhlIGtlcm5lbCBkaXNjdXNzaW9u
LiAKPiAKPiBJIGFtIGxvb2tpbmcgZm9yd2FyZCB0byBnZXQgdGhlIGd1aWRhbmNlIGZyb20geW91
LiBUaGFua3MhCj4gCj4gVGhlIHJlYXNvbiBvZiByZWR1Y2luZyBNQVhfU1RBQ0tfRU5UUklFUyBm
cm9tIDEwMCB0byAzMiBpcyBhcyBmb2xsb3dzOgo+IEluIG15IGRhaWx5IHdvcmssIEkgZm91bmQg
dGhhdCBhbGwgdGhlIGZ1bmN0aW9uIHN0YWNrIHdpbGwgbm90IGFjaGlldmUgdGhlIG51bWJlciBv
ZiAzMi4KPiBUaGVyZWZvcmUsIHNldHRpbmcgdGhlIGFycmF5IG9mIDEwMCBtYXkgYmUgYSB3YXN0
ZSBvZiBrZXJuZWwgbWVtb3J5LiBUaGVyZWZvcmUsIEkgc3VnZ2VzdAo+IHRvIHJlZHVjZSB0aGUg
bnVtYmVyIG9mIGVudHJpZXMgb2YgdGhlIHN0YWNrIGVudHJpZXMgZnJvbSAxMDAgdG8gMzIuCj4g
Cj4gSGVyZSBpcyBhbiBleGFtcGxlIG9mIHRoZSBjYWxsIHRyYWNlOgo+IFsyMDQwOS41MDU2MDJd
ICBbPGZmZmZmZmZmODExNjg4NjE+XSBncm91cF9zY2hlZF9vdXQrMHg2MS8weGIwCj4gWzIwNDA5
LjUxNDc5MV0gIFs8ZmZmZmZmZmY4MTE2OGJmZD5dIGN0eF9zY2hlZF9vdXQrMHhhZC8weGYwCj4g
WzIwNDA5LjUyMDMwN10gIFs8ZmZmZmZmZmY4MTE2YTAzZD5dIF9fcGVyZl9pbnN0YWxsX2luX2Nv
bnRleHQrMHhiZC8weDFiMAo+IFsyMDQwOS41MjY5NTJdICBbPGZmZmZmZmZmODExNjQ5YjA+XSBy
ZW1vdGVfZnVuY3Rpb24rMHg0MC8weDUwCj4gWzIwNDA5LjUzMjY0NF0gIFs8ZmZmZmZmZmY4MTBm
MTY2Nj5dIGdlbmVyaWNfZXhlY19zaW5nbGUrMHgxNTYvMHgxYTAKPiBbMjA0MDkuNTM4ODY0XSAg
WzxmZmZmZmZmZjgxMTY0OTcwPl0gPyBwZXJmX2V2ZW50X3NldF9vdXRwdXQrMHgxOTAvMHgxOTAK
PiBbMjA0MDkuNTQ1NDI1XSAgWzxmZmZmZmZmZjgxMGYxNzBmPl0gc21wX2NhbGxfZnVuY3Rpb25f
c2luZ2xlKzB4NWYvMHhhMAo+IFsyMDQwOS41NTE4OTVdICBbPGZmZmZmZmZmODExZjVlNzA+XSA/
IGFsbG9jX2ZpbGUrMHhhMC8weGYwCj4gWzIwNDA5LjU1NzMyNl0gIFs8ZmZmZmZmZmY4MTE2MzUy
Mz5dIHRhc2tfZnVuY3Rpb25fY2FsbCsweDUzLzB4ODAKPiBbMjA0MDkuNTYzMjc0XSAgWzxmZmZm
ZmZmZjgxMTY5ZjgwPl0gPyBwZXJmX2NwdV9ocnRpbWVyX2hhbmRsZXIrMHgxYjAvMHgxYjAKPiBb
MjA0MDkuNTcwMDg5XSAgWzxmZmZmZmZmZjgxMTY2Njg4Pl0gcGVyZl9pbnN0YWxsX2luX2NvbnRl
eHQrMHg3OC8weDEyMAo+IFsyMDQwOS41NzY1NThdICBbPGZmZmZmZmZmODExNmRhNTQ+XSBTWVND
X3BlcmZfZXZlbnRfb3BlbisweDc5NC8weGE0MAo+IFsyMDQwOS41ODI4NTJdICBbPGZmZmZmZmZm
ODExNmUxNjk+XSBTeVNfcGVyZl9ldmVudF9vcGVuKzB4OS8weDEwCj4gWzIwNDA5LjU4ODgwM10g
IFs8ZmZmZmZmZmY4MTY2YmYzZD5dIHN5c3RlbV9jYWxsX2Zhc3RwYXRoKzB4MTYvMHgxYgo+IFsy
MDQwOS41OTQ5MjZdICBbPGZmZmZmZmZmODE2NmJkZGQ+XSA/IHN5c3RlbV9jYWxsX2FmdGVyX3N3
YXBncysweGNhLzB4MjE0CgpBY3R1YWxseSwgd2hlbiBJIGJvb3RlZCB3aXRoIENPTkZJR19QUkVF
TVBUK0NPTkZJR19MT0NLREVQLCBJIHNhdyB0aGUKbnVtYmVyIG9mIHN0YWNrIGVudHJpZXMgZ28g
aGlnaGVyIHRoYW4gNjAuICBJIGRpZG4ndCBkbyBleHRlbnNpdmUKdGVzdGluZywgc28gaXQgbWln
aHQgZ28gZXZlbiBoaWdoZXIgdGhhbiB0aGF0LgoKSSdkIHJhdGhlciBsZWF2ZSBpdCBhdCAxMDAg
Zm9yIG5vdywgYXMgd2UgY3VycmVudGx5IGhhdmUgbm8gd2F5IG9mCnJlcG9ydGluZyBpZiB0aGUg
bGltaXQgaXMgZ2V0dGluZyBoaXQgYWNyb3NzIGEgdmFyaWV0eSBvZiBjb25maWdzIGFuZAp1c2Fn
ZSBzY2VuYXJpb3MuICBBbmQgYW55IG1lbW9yeSBzYXZpbmdzIHdvdWxkIGJlIG5lZ2xpZ2libGUg
YW55d2F5LgoKLS0gCkpvc2g=
