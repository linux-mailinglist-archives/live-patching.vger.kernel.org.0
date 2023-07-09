Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C93374C440
	for <lists+live-patching@lfdr.de>; Sun,  9 Jul 2023 15:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbjGINJU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 9 Jul 2023 09:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGINJU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 9 Jul 2023 09:09:20 -0400
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77A0132;
        Sun,  9 Jul 2023 06:09:17 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=ydzhang@linux.alibaba.com;NM=1;PH=DW;RN=8;SR=0;TI=W4_0.2.0_DEFAULT_210DC2C5_1688899510528_o7001c987;
Received: from WS-web (ydzhang@linux.alibaba.com[W4_0.2.0_DEFAULT_210DC2C5_1688899510528_o7001c987]) at Sun, 09 Jul 2023 21:09:14 +0800
Date:   Sun, 09 Jul 2023 21:09:14 +0800
From:   "wardenjohn" <ydzhang@linux.alibaba.com>
To:     "Bagas Sanjaya" <bagasdotme@gmail.com>
Cc:     "jpoimboe" <jpoimboe@kernel.org>, "jikos" <jikos@kernel.org>,
        "mbenes" <mbenes@suse.cz>, "pmladek" <pmladek@suse.com>,
        "joe.lawrence" <joe.lawrence@redhat.com>,
        "Kernel Live Patching" <live-patching@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Reply-To: "wardenjohn" <ydzhang@linux.alibaba.com>
Message-ID: <b0ed2a6d-c91b-4c72-9cfc-4900f3a37d82.ydzhang@linux.alibaba.com>
Subject: =?UTF-8?B?UmU6IEZpeCBNQVhfU1RBQ0tfRU5UUklFUyBmcm9tIDEwMCB0byAzMg==?=
X-Mailer: [Alimail-Mailagent revision 85][W4_0.2.0][DEFAULT][Chrome]
MIME-Version: 1.0
References: <931aaecf-66b1-469a-8bc3-7126871a8464.ydzhang@linux.alibaba.com>,<ZKpqpamE89nvgslC@debian.me>
x-aliyun-mail-creator: W4_0.2.0_DEFAULT_QvNTW96aWxsYS81LjAgKE1hY2ludG9zaDsgSW50ZWwgTWFjIE9TIFggMTBfMTVfNykgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzExNC4wLjAuMCBTYWZhcmkvNTM3LjM2La
In-Reply-To: <ZKpqpamE89nvgslC@debian.me>
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

T0ssIEkgd2lsbCByZXN1Ym1pdCB0aGUgcGF0Y2ggYnkgZ2l0LXNlbmQtZW1haWwoMSkgaW5zdGVh
ZC4gOikKCkJ1dCBJIHdhbnQgYXNrIGhvdyBjYW4gSSBwcm92aWRlIHRoZSBMaW5rIHRvIGRpc2N1
c3Npb24/CkFuZCB3aGF0IGlzIHYyIHBhdGNoPwpJIGFtIHNvcnJ5IHRoYXQgaXQgaXMgbXkgZmly
c3QgdGltZSB0byBqb2luIHRoZSBrZXJuZWwgZGlzY3Vzc2lvbi4gCgpJIGFtIGxvb2tpbmcgZm9y
d2FyZCB0byBnZXQgdGhlIGd1aWRhbmNlIGZyb20geW91LiBUaGFua3MhCgpUaGUgcmVhc29uIG9m
IHJlZHVjaW5nIE1BWF9TVEFDS19FTlRSSUVTIGZyb20gMTAwIHRvIDMyIGlzIGFzIGZvbGxvd3M6
CkluIG15IGRhaWx5IHdvcmssIEkgZm91bmQgdGhhdCBhbGwgdGhlIGZ1bmN0aW9uIHN0YWNrIHdp
bGwgbm90IGFjaGlldmUgdGhlIG51bWJlciBvZiAzMi4KVGhlcmVmb3JlLCBzZXR0aW5nIHRoZSBh
cnJheSBvZiAxMDAgbWF5IGJlIGEgd2FzdGUgb2Yga2VybmVsIG1lbW9yeS4gVGhlcmVmb3JlLCBJ
IHN1Z2dlc3QKdG8gcmVkdWNlIHRoZSBudW1iZXIgb2YgZW50cmllcyBvZiB0aGUgc3RhY2sgZW50
cmllcyBmcm9tIDEwMCB0byAzMi4KCkhlcmUgaXMgYW4gZXhhbXBsZSBvZiB0aGUgY2FsbCB0cmFj
ZToKWzIwNDA5LjUwNTYwMl0gIFs8ZmZmZmZmZmY4MTE2ODg2MT5dIGdyb3VwX3NjaGVkX291dCsw
eDYxLzB4YjAKWzIwNDA5LjUxNDc5MV0gIFs8ZmZmZmZmZmY4MTE2OGJmZD5dIGN0eF9zY2hlZF9v
dXQrMHhhZC8weGYwClsyMDQwOS41MjAzMDddICBbPGZmZmZmZmZmODExNmEwM2Q+XSBfX3BlcmZf
aW5zdGFsbF9pbl9jb250ZXh0KzB4YmQvMHgxYjAKWzIwNDA5LjUyNjk1Ml0gIFs8ZmZmZmZmZmY4
MTE2NDliMD5dIHJlbW90ZV9mdW5jdGlvbisweDQwLzB4NTAKWzIwNDA5LjUzMjY0NF0gIFs8ZmZm
ZmZmZmY4MTBmMTY2Nj5dIGdlbmVyaWNfZXhlY19zaW5nbGUrMHgxNTYvMHgxYTAKWzIwNDA5LjUz
ODg2NF0gIFs8ZmZmZmZmZmY4MTE2NDk3MD5dID8gcGVyZl9ldmVudF9zZXRfb3V0cHV0KzB4MTkw
LzB4MTkwClsyMDQwOS41NDU0MjVdICBbPGZmZmZmZmZmODEwZjE3MGY+XSBzbXBfY2FsbF9mdW5j
dGlvbl9zaW5nbGUrMHg1Zi8weGEwClsyMDQwOS41NTE4OTVdICBbPGZmZmZmZmZmODExZjVlNzA+
XSA/IGFsbG9jX2ZpbGUrMHhhMC8weGYwClsyMDQwOS41NTczMjZdICBbPGZmZmZmZmZmODExNjM1
MjM+XSB0YXNrX2Z1bmN0aW9uX2NhbGwrMHg1My8weDgwClsyMDQwOS41NjMyNzRdICBbPGZmZmZm
ZmZmODExNjlmODA+XSA/IHBlcmZfY3B1X2hydGltZXJfaGFuZGxlcisweDFiMC8weDFiMApbMjA0
MDkuNTcwMDg5XSAgWzxmZmZmZmZmZjgxMTY2Njg4Pl0gcGVyZl9pbnN0YWxsX2luX2NvbnRleHQr
MHg3OC8weDEyMApbMjA0MDkuNTc2NTU4XSAgWzxmZmZmZmZmZjgxMTZkYTU0Pl0gU1lTQ19wZXJm
X2V2ZW50X29wZW4rMHg3OTQvMHhhNDAKWzIwNDA5LjU4Mjg1Ml0gIFs8ZmZmZmZmZmY4MTE2ZTE2
OT5dIFN5U19wZXJmX2V2ZW50X29wZW4rMHg5LzB4MTAKWzIwNDA5LjU4ODgwM10gIFs8ZmZmZmZm
ZmY4MTY2YmYzZD5dIHN5c3RlbV9jYWxsX2Zhc3RwYXRoKzB4MTYvMHgxYgpbMjA0MDkuNTk0OTI2
XSAgWzxmZmZmZmZmZjgxNjZiZGRkPl0gPyBzeXN0ZW1fY2FsbF9hZnRlcl9zd2FwZ3MrMHhjYS8w
eDIxNAoKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCkZyb206QmFnYXMgU2FuamF5YSA8YmFnYXNkb3RtZUBnbWFpbC5jb20+
ClNlbmQgVGltZToyMDIz5bm0N+aciDnml6Uo5pif5pyf5pelKSAxNjowNwpUbzp3YXJkZW5qb2hu
IDx5ZHpoYW5nQGxpbnV4LmFsaWJhYmEuY29tPgpDYzpqcG9pbWJvZSA8anBvaW1ib2VAa2VybmVs
Lm9yZz47IGppa29zIDxqaWtvc0BrZXJuZWwub3JnPjsgbWJlbmVzIDxtYmVuZXNAc3VzZS5jej47
IHBtbGFkZWsgPHBtbGFkZWtAc3VzZS5jb20+OyBqb2UubGF3cmVuY2UgPGpvZS5sYXdyZW5jZUBy
ZWRoYXQuY29tPjsgS2VybmVsIExpdmUgUGF0Y2hpbmcgPGxpdmUtcGF0Y2hpbmdAdmdlci5rZXJu
ZWwub3JnPjsgTGludXggS2VybmVsIE1haWxpbmcgTGlzdCA8bGludXgta2VybmVsQHZnZXIua2Vy
bmVsLm9yZz4KU3ViamVjdDpSZTogRml4IE1BWF9TVEFDS19FTlRSSUVTIGZyb20gMTAwIHRvIDMy
CgoKT24gU2F0LCBKdWwgMDgsIDIwMjMgYXQgMDk6NTY6MzRBTSArMDgwMCwgd2FyZGVuam9obiB3
cm90ZToKPiBUaGFua3MgZm9yIHJlYWRpbmcgbXkgc3VnZ2VzdGlvbi4gSSBmb3VuZCB0aGF0IHRo
ZSBhcnJheSBmb3IgdGFzayBzdGFjayBlbnRyaWVzIHdoZW4KPiBkb2luZyBsaXZlcGF0Y2ggZnVu
Y3Rpb24gY2hlY2sgaXMgdG9vIGxhcmdlIHdoaWNoIHNlZW1zIHRvIGJlIHVubmVjZXNzYXJ5LiBU
aGVyZWZvcmUsCj4gSSBzdWdnZXN0IHRvIGZpeCB0aGUgTUFYX1NUQUNLX0VOVFJJRVMgZnJvbSAx
MDAgdG8gMzIuCgpDYW4geW91IHByb3ZpZGUgTGluazogdG8gdGhlIGRpc2N1c3Npb24/IFlldCwg
SSBndWVzcyB0aGlzIGlzIHNvbWVob3cKdjIgcGF0Y2guCgo+IAo+IFRoZSBwYXRjaCBpcyBhcyBm
b2xsb3dzOgo+IAo+IEZyb20gZWUyN2RhNWU2NGRhY2VkMTU5MjU3ZjU0MTcwYTMxMTQxZTk0Mzcx
MCBNb24gU2VwIDE3IDAwOjAwOjAwIDIwMDEKPiBGcm9tOiBZb25nZGUgWmhhbmcgPHlkemhhbmdA
bGludXguYWxpYmFiYS5jb20+Cj4gRGF0ZTogU2F0LCA4IEp1bCAyMDIzIDA5OjQwOjUwICswODAw
Cj4gU3ViamVjdDogW1BBVENIXSBGaXggTUFYX1NUQUNLX0VOVFJJRVMgdG8gMzIKPiAKPiBXaGVu
IGNoZWNraW5nIHRoZSB0YXNrIHN0YWNrLCB1c2luZyBhbiBzdGFjayBhcnJheSBvZiBzaXplIDEw
MCAKPiBzZWVtcyB0byBiZSB0byBsYXJnZSBmb3IgYSB0YXNrIHN0YWNrLiBUaGVyZWZvcmUsIEkg
c3VnZ2VzdCB0bwo+IGNoYW5nZSB0aGUgc3RhY2sgc2l6ZSBmcm9tIDEwMCB0byAzMi4gCgpXaHkg
aXMgTUFYX1NUQUNLX0VOVFJJRVM9MTAwIG92ZXJraWxsPyBBbmQgd2h5IGRvIHlvdSByZWR1Y2Ug
aXQ/Cgo+IAo+IFNpZ25lZC1vZmYtYnk6IFlvbmdkZSBaaGFuZyA8eWR6aGFuZ0BsaW51eC5hbGli
YWJhLmNvbT4KPiAtLS0KPiAga2VybmVsL2xpdmVwYXRjaC90cmFuc2l0aW9uLmMgfCAyICstCj4g
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQo+IAo+IGRpZmYg
LS1naXQgYS9rZXJuZWwvbGl2ZXBhdGNoL3RyYW5zaXRpb24uYyBiL2tlcm5lbC9saXZlcGF0Y2gv
dHJhbnNpdGlvbi5jCj4gaW5kZXggZTU0YzNkNjBhOTA0Li44ZDYxYzYyYjBjMjcgMTAwNjQ0Cj4g
LS0tIGEva2VybmVsL2xpdmVwYXRjaC90cmFuc2l0aW9uLmMKPiArKysgYi9rZXJuZWwvbGl2ZXBh
dGNoL3RyYW5zaXRpb24uYwo+IEBAIC0xNCw3ICsxNCw3IEBACj4gICNpbmNsdWRlICJwYXRjaC5o
Igo+ICAjaW5jbHVkZSAidHJhbnNpdGlvbi5oIgo+ICAKPiAtI2RlZmluZSBNQVhfU1RBQ0tfRU5U
UklFUyAgMTAwCj4gKyNkZWZpbmUgTUFYX1NUQUNLX0VOVFJJRVMgIDMyCj4gIHN0YXRpYyBERUZJ
TkVfUEVSX0NQVSh1bnNpZ25lZCBsb25nW01BWF9TVEFDS19FTlRSSUVTXSwga2xwX3N0YWNrX2Vu
dHJpZXMpOwo+ICAKPiAgI2RlZmluZSBTVEFDS19FUlJfQlVGX1NJWkUgMTI4IAoKWW91ciBwYXRj
aCBpcyBNSU1FJ2QsIHBsZWFzZSBzdWJtaXQgaXQgd2l0aCBnaXQtc2VuZC1lbWFpbCgxKSBpbnN0
ZWFkLgoKVGhhbmtzLgoKLS0gCkFuIG9sZCBtYW4gZG9sbC4uLiBqdXN0IHdoYXQgSSBhbHdheXMg
d2FudGVkISAtIENsYXJh
