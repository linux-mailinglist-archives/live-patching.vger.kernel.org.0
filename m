Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1208B74BB33
	for <lists+live-patching@lfdr.de>; Sat,  8 Jul 2023 03:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjGHB4k (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 7 Jul 2023 21:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjGHB4j (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 7 Jul 2023 21:56:39 -0400
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BDDCC3;
        Fri,  7 Jul 2023 18:56:37 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R791e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=ydzhang@linux.alibaba.com;NM=1;PH=DW;RN=7;SR=0;TI=W4_0.2.0_DEFAULT_210DF632_1688781163176_o7001c63l;
Received: from WS-web (ydzhang@linux.alibaba.com[W4_0.2.0_DEFAULT_210DF632_1688781163176_o7001c63l]) at Sat, 08 Jul 2023 09:56:34 +0800
Date:   Sat, 08 Jul 2023 09:56:34 +0800
From:   "wardenjohn" <ydzhang@linux.alibaba.com>
To:     "jpoimboe" <jpoimboe@kernel.org>
Cc:     "jikos" <jikos@kernel.org>, "mbenes" <mbenes@suse.cz>,
        "pmladek" <pmladek@suse.com>,
        "joe.lawrence" <joe.lawrence@redhat.com>,
        "live-patching" <live-patching@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Reply-To: "wardenjohn" <ydzhang@linux.alibaba.com>
Message-ID: <931aaecf-66b1-469a-8bc3-7126871a8464.ydzhang@linux.alibaba.com>
Subject: =?UTF-8?B?Rml4IE1BWF9TVEFDS19FTlRSSUVTIGZyb20gMTAwIHRvIDMy?=
X-Mailer: [Alimail-Mailagent revision 85][W4_0.2.0][DEFAULT][Chrome]
MIME-Version: 1.0
x-aliyun-mail-creator: W4_0.2.0_DEFAULT_QvNTW96aWxsYS81LjAgKE1hY2ludG9zaDsgSW50ZWwgTWFjIE9TIFggMTBfMTVfNykgQXBwbGVXZWJLaXQvNTM3LjM2IChLSFRNTCwgbGlrZSBHZWNrbykgQ2hyb21lLzExNC4wLjAuMCBTYWZhcmkvNTM3LjM2La
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

VGhhbmtzIGZvciByZWFkaW5nIG15IHN1Z2dlc3Rpb24uIEkgZm91bmQgdGhhdCB0aGUgYXJyYXkg
Zm9yIHRhc2sgc3RhY2sgZW50cmllcyB3aGVuCmRvaW5nIGxpdmVwYXRjaCBmdW5jdGlvbiBjaGVj
ayBpcyB0b28gbGFyZ2Ugd2hpY2ggc2VlbXMgdG8gYmUgdW5uZWNlc3NhcnkuIFRoZXJlZm9yZSwK
SSBzdWdnZXN0IHRvIGZpeCB0aGUgTUFYX1NUQUNLX0VOVFJJRVMgZnJvbSAxMDAgdG8gMzIuCgpU
aGUgcGF0Y2ggaXMgYXMgZm9sbG93czoKCkZyb20gZWUyN2RhNWU2NGRhY2VkMTU5MjU3ZjU0MTcw
YTMxMTQxZTk0MzcxMCBNb24gU2VwIDE3IDAwOjAwOjAwIDIwMDEKRnJvbTogWW9uZ2RlIFpoYW5n
IDx5ZHpoYW5nQGxpbnV4LmFsaWJhYmEuY29tPgpEYXRlOiBTYXQsIDggSnVsIDIwMjMgMDk6NDA6
NTAgKzA4MDAKU3ViamVjdDogW1BBVENIXSBGaXggTUFYX1NUQUNLX0VOVFJJRVMgdG8gMzIKCldo
ZW4gY2hlY2tpbmcgdGhlIHRhc2sgc3RhY2ssIHVzaW5nIGFuIHN0YWNrIGFycmF5IG9mIHNpemUg
MTAwIApzZWVtcyB0byBiZSB0byBsYXJnZSBmb3IgYSB0YXNrIHN0YWNrLiBUaGVyZWZvcmUsIEkg
c3VnZ2VzdCB0bwpjaGFuZ2UgdGhlIHN0YWNrIHNpemUgZnJvbSAxMDAgdG8gMzIuIAoKU2lnbmVk
LW9mZi1ieTogWW9uZ2RlIFpoYW5nIDx5ZHpoYW5nQGxpbnV4LmFsaWJhYmEuY29tPgotLS0KIGtl
cm5lbC9saXZlcGF0Y2gvdHJhbnNpdGlvbi5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEva2VybmVsL2xpdmVwYXRjaC90
cmFuc2l0aW9uLmMgYi9rZXJuZWwvbGl2ZXBhdGNoL3RyYW5zaXRpb24uYwppbmRleCBlNTRjM2Q2
MGE5MDQuLjhkNjFjNjJiMGMyNyAxMDA2NDQKLS0tIGEva2VybmVsL2xpdmVwYXRjaC90cmFuc2l0
aW9uLmMKKysrIGIva2VybmVsL2xpdmVwYXRjaC90cmFuc2l0aW9uLmMKQEAgLTE0LDcgKzE0LDcg
QEAKICNpbmNsdWRlICJwYXRjaC5oIgogI2luY2x1ZGUgInRyYW5zaXRpb24uaCIKIAotI2RlZmlu
ZSBNQVhfU1RBQ0tfRU5UUklFUyAgMTAwCisjZGVmaW5lIE1BWF9TVEFDS19FTlRSSUVTICAzMgog
c3RhdGljIERFRklORV9QRVJfQ1BVKHVuc2lnbmVkIGxvbmdbTUFYX1NUQUNLX0VOVFJJRVNdLCBr
bHBfc3RhY2tfZW50cmllcyk7CiAKICNkZWZpbmUgU1RBQ0tfRVJSX0JVRl9TSVpFIDEyOCAKLS0g
CjIuMzcuMw==
