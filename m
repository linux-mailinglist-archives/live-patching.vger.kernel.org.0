Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11C74B0E07
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 14:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241898AbiBJNBp (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 08:01:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238200AbiBJNBo (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 08:01:44 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90078.outbound.protection.outlook.com [40.107.9.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEDAA10C8;
        Thu, 10 Feb 2022 05:01:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8Jrl9l5UK4dZKZdKHcfs6QAjN6O6oYQcZXezdXEIXChb+rguaw3DwhBst3w4L0k2ejhp5tBNdjuq6PmLOcLOJprYWgF91H9fis/S5j1Dng2z2R3K7zWbyZbOPoJSpUDOrZbOVP8DdvAcIDyMiFyiQGkuus3ZvxrqqNeirdbaNVgGlhaqmUp+d6NQ+wQt0OTMNp6BBsoyA8wJi/7W9phqRN6gT7SD13DBf0oLy27G7VVTbNwa47B58Pgb5NdLHQ8u3ECWhmX1IL675Gk3mtPm7n21oiOZhkQF4ogYoGwbW11CLvk5EKHJWHsMZ2Xs7fZoNuFYPyJ3OPn/RA0yQAyXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZwkxkpFBYYxCnxvp7R0egDtL2qmI95Zyz0VicLryFyQ=;
 b=kE/ir0MRG2VZvXkh99Pc+HX8uNzVyOzJd4Fv0vY+QkqmRiZ+J50MevZqKcOQod+LX7dpUDKPfdmwjDW7H/uNRAoGzOFdryV2Yv94i1Y7bqIi8OoM6+xPua5QbzmElfAQYZ1x3InrdkIXO0Osoj++5j5c675TWkkiwgTeUMVXeucAhgxgvI9UdlnOY1Ij74VSVNrVUVHpdcZgc6mPJsPi4nHqXywRxBIIO/JUtu+0i5Wxh08lOONxxYT+XNk6Ml+Ir9UD2MKTlBey3G7VmOrJ2EoSg9ZWywzalWQIzQMCkX4m/ATTzRzuYLKxoAmqwoCglj7E30CYaN3nGbJxIh8Q8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB0395.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Thu, 10 Feb
 2022 13:01:41 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 13:01:41 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "20220209170358.3266629-1-atomlin@redhat.com" 
        <20220209170358.3266629-1-atomlin@redhat.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        Aaron Tomlin <atomlin@redhat.com>
CC:     "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "atomlin@atomlin.com" <atomlin@atomlin.com>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "void@manifault.com" <void@manifault.com>,
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Subject: Re: [PATCH v5 07/13] module: Move extra signature support out of core
 code
Thread-Topic: [PATCH v5 07/13] module: Move extra signature support out of
 core code
Thread-Index: AQHYHdeoMtkp/gewo0musFt6p4TNLayMwQAA
Date:   Thu, 10 Feb 2022 13:01:40 +0000
Message-ID: <8b7988be-488e-f570-b499-5892c57f5e04@csgroup.eu>
References: <20220209170814.3268487-1-atomlin@redhat.com>
In-Reply-To: <20220209170814.3268487-1-atomlin@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cba3020f-700e-4adc-de0e-08d9ec957b28
x-ms-traffictypediagnostic: PR0P264MB0395:EE_
x-microsoft-antispam-prvs: <PR0P264MB0395BA4A7350A2E223E89905ED2F9@PR0P264MB0395.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gx3QSGYEBTpt9XRlxVBEqlj/Rj2wel18MasmfjrggI50u76yls5lHYQ4wwbqkYVXIxZqzOtfMOjT/820nRpWzRlqgObH/VSGv2yRDubCVYg2fJjVHfqIgfmRvvYtz5w9QSF/lKvsYGvCu6r1mD8k5DsKELSVeTrg9NyGAGQnUYXs5i1o76yqe9mNSZSJsVTQaFnAPdGsVEDeUV4TBdGILd3nw58P5ODhG8lxhIG88vgjCmsRbNhVNY/KRxQ5PnnlqGO+c7clexsjgSsib3mZ0rJgfriNAC4KYt8MH4+DhJ4WGqf+cRgfXn2Qn4BJA/jS7VvFeEendsPzle8nAgdRiQiFdojOFt6CicIpYdsetScaHdAnIOZwRM+5pGoLeyNaYY20ybj9mtTDkITw24487GcbduTTP/INxyxM78SY+mDGYKuDsYghS8NgT7G+Lpr5stE7vUnmXnINYzUNbiwSPcTEvFgHuPvVhVEg3Q5jQUvo7OIPXfIgiGGkTzOQqyOQ481cGIisD/Qu/B/RQ2LAJqhwCSjVvEjxCMu9eLgUxtf9MYH6kCS7ZoqyhaV2psYG+zByocolg2DMaFWxZuKtVad/U+dVvwBMN9cKKpZEI3S66A1hEJ7fIrY/dwxL9RdgBEsgJsfPtZ4cwmhey3DDAlc+d+cc+TXP+yA/D+dKm7V7x+nOxaf//d0tkOWdgwVMKJuxxznsjy7LJ0J96+YuaQPvd8PtcfKVX6psVT78I5A6S/lfPezE7tUcBm1IZpxj8VCSoT8y2kKyFP9LmWLMow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(5660300002)(44832011)(8936002)(36756003)(83380400001)(64756008)(31686004)(71200400001)(508600001)(6486002)(38100700002)(26005)(122000001)(186003)(31696002)(86362001)(38070700005)(66946007)(66476007)(4326008)(66446008)(91956017)(6512007)(2616005)(6506007)(66556008)(316002)(66574015)(2906002)(8676002)(110136005)(76116006)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFg0dndnWTZ3L2NnUkt6OXBnNHkzSDBYV0FWZ2RYYlBrTnRKZk11bFczMVlW?=
 =?utf-8?B?TlZPUjdYOFVwNEMzaTAyQ3R0TDFxNnAySG1OSVk4aVJFRndRRk5wWjZtK0Ux?=
 =?utf-8?B?ZVI2NjhHcVI4UDhZUmt5anovVWdnNllVMm44cDMyNEhJMmxpNlJEdjJwbDcr?=
 =?utf-8?B?WHgxN1FNeDc5M1JIZ0djV00yRmtrbnlsN2xidkpzWGl6RmFkcGY3QldVcTF4?=
 =?utf-8?B?aHBkSWdKa2JsQ2tCWFIrMUkrUlRZK1UrUTB1S1o5ai9GcmdNNDVLNlUxZVNx?=
 =?utf-8?B?ODNlQnVGQUJPWlphT0FGb0VuNnVwMHR3T1hUM0VKMmJubkY0V005RUxhanNh?=
 =?utf-8?B?RzB2MzZMbHROWE9jVUxKRGxLYURnWHBKNmhNQ3FqdWE5T3FDRmNtblBiNkJk?=
 =?utf-8?B?ODViaEF1Q3Q3bWRlK1RDQU4wVmdySFBudmJKMG1iODB3MzlaSjFINWRlZ0JK?=
 =?utf-8?B?STk5Tk0xMEQ0SXA1M2FIWWgwa082aWhyU2NUSTZTTksrNXZvOW91MHdiMGJj?=
 =?utf-8?B?UFRtWDhUeUVIZGxPMTVRYlRBNVExZ0dlRkM2a3doSFVnUkR2ODNPVjJVNWtI?=
 =?utf-8?B?UUlyOGRWMDdaV040V2JuZzBkTGdoalQ5RU9YYkRrNjZOV3h2aWM1VDRWdk8r?=
 =?utf-8?B?eXI4RW1RVXVMYUUrN0l5V1BiNytLTEQvaTZTclNKN25oZjB2QmIwN2pTWkhL?=
 =?utf-8?B?M2RWS0w5clhxRU04Q0trSGZhNEp4ZG85VUt2U1l0OS9TOXNmd3RIdXBzbUp1?=
 =?utf-8?B?bWVqSDdjTWN4UURLWWh6NSt5b0lZdnprTndYdytRSkp0Wml2UlpZbE1DNUNN?=
 =?utf-8?B?L2tGbWFjWnJpdUozelhXalBKQ2ZFcHNrSjM1aWY5U2hQc1J3UXdkSG9MTnlD?=
 =?utf-8?B?WHdZeUNFUVplOFBQbXVCNzEwM0pjR3ROVm9JRjU2anYrL0N5WnkxL1UzOW5s?=
 =?utf-8?B?UVJCTmMzRVVGZlVoTzBOMDZjNWt1QmRYUXRIQ0V3Yk9ZREZqMTBudk5ZQ05s?=
 =?utf-8?B?a0VrVU4vVzhQWkF2S29IS1ZCZ2M0eXYzc1ljTjA5bXVYVXB2OHBTZXBnM0Rx?=
 =?utf-8?B?ejVGWWhxTUxOSmRudXBaYWhoY3drUGNvUjhkWC9JOVJFdDRZQWxvV2NpTXpU?=
 =?utf-8?B?N2lhc2hZbi9BMUEza05IempkWVNwT1UrUzByS1FLWGkzcDdORlNuQ2JsaEg3?=
 =?utf-8?B?eU5zOXBob2hkMDI3N3VydVVCTUxHc1MrZ2crWnJnbG42cXlCc3plYmF4VVdt?=
 =?utf-8?B?M0RCZFV6aTY2a2t0dWZqdUx3UTdneEcrcTlCb2h1by9kK094OGMyc1FkTlZy?=
 =?utf-8?B?bDRFVmZsdGZVYXNYQnZRSkJvYnRJR1hHUW92dk5CVmJnQzFGTVY0MVFRSjY0?=
 =?utf-8?B?WVhHdUZzK25vbEQ3QXZuMW5QQVpHR3QvRXhqek41Q0wrQVkzTzZ4alduMEk3?=
 =?utf-8?B?MzVFSm5QeWZRN01FU2tJNUh6RHU1NU5sNGFzbktwVUZVRnBSMUc0eDRvVmpC?=
 =?utf-8?B?QzgwZUxJQXRVNFdkVDhPbDBvajR0SGcwNVVNYVJyOTlmWkhNU2FYZlBza3l5?=
 =?utf-8?B?c3BScDBpOTZYZ1p2SmlHSzUzbFVFVllJZXBOc0k5NitlQ3Fzc25YZUZ4ek9p?=
 =?utf-8?B?ZGZpOC9mV3V5OVZYYkpoU29HQTd4NFp2WmVmbGpZejBKWHZMOFE1c1I3bGh1?=
 =?utf-8?B?azcrcmVHcEpPM0VvRzNNQnpLam9jTGVPRnVFTkkvNFI0QzlkMmFFSEsyWGxR?=
 =?utf-8?B?cnVUeFViZ1ZzMVhTakhRV2drZUI5enMvTVk1b0NoK3BRU3ZTVHRaU2xwUVJ3?=
 =?utf-8?B?eFd4aWdVbWpyNFRyU1UrcmhZRDkzOWpweGZ6ODRDVzNpN1hhdG43bWM4RWE4?=
 =?utf-8?B?eFcvOFJzS1NQaEdhNU5wRzB0WGlpQTVDb3h6ZCthbEp2UFZoek4vQlgyMzlX?=
 =?utf-8?B?aXRKeVdQSDNPM0t6bEgxaEJQTE5WaVJESGtnNmw1MmhneXlub2hQbk1CUmZa?=
 =?utf-8?B?bFdyMnJUcmwyWTFUMWF1a1FzU1ZHQVJ6SjZkYVJkcmtDVjBJdW9mZTRKOURO?=
 =?utf-8?B?YlNoR3k3Wk5ONGJzelhaN1o5SHZWODZKQ3kwdy9EcnNoK0NFQUFOenpJMXpr?=
 =?utf-8?B?NFdpZTJPaTJ6MU51b2VWcXhaeVlZMkRHRERUNnlUbWkrMjhPem1qQmpkU3RY?=
 =?utf-8?B?QXZQWG02ZDNyay9JWndZSWIvaWYyc0kxSkNzOUNJWWdXNzBXUE50NVVqNkJN?=
 =?utf-8?Q?39axNNmyXLpX7Zba/POhJhZOLvVhtzVbaEAPpFgFD4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25FC4EAFE4E84F4F8FF28963A87DFF63@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: cba3020f-700e-4adc-de0e-08d9ec957b28
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 13:01:40.9712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TxsQxqkid5EESC0WGzGFYs8Avt+KSU/xjfUxPkNA4Tq1R3dYhoD1Pj/dWwFkTuMPvAJNIWVFPNl56HypavRwxuIAh+oB/xS5AWFoQVxHJXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB0395
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

V2h5IGRvIHBhdGNoZXMgNyB0byAxMyBoYXZlIGEgUmVwbHktdG86IA0KMjAyMjAyMDkxNzAzNTgu
MzI2NjYyOS0xLWF0b21saW5AcmVkaGF0LmNvbSBhbmQgbm90IHBhdGNoZXMgMSB0byA2ID8NCg0K
TGUgMDkvMDIvMjAyMiDDoCAxODowOCwgQWFyb24gVG9tbGluIGEgw6ljcml0wqA6DQo+IE5vIGZ1
bmN0aW9uYWwgY2hhbmdlLg0KPiANCj4gVGhpcyBwYXRjaCBtaWdyYXRlcyBhZGRpdGlvbmFsIG1v
ZHVsZSBzaWduYXR1cmUgY2hlY2sNCj4gY29kZSBmcm9tIGNvcmUgbW9kdWxlIGNvZGUgaW50byBr
ZXJuZWwvbW9kdWxlL3NpZ25pbmcuYy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFhcm9uIFRvbWxp
biA8YXRvbWxpbkByZWRoYXQuY29tPg0KPiAtLS0NCj4gICBpbmNsdWRlL2xpbnV4L21vZHVsZS5o
ICAgfCAgMSArDQo+ICAga2VybmVsL21vZHVsZS9pbnRlcm5hbC5oIHwgIDkgKysrKysNCj4gICBr
ZXJuZWwvbW9kdWxlL21haW4uYyAgICAgfCA4NyAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tDQo+ICAga2VybmVsL21vZHVsZS9zaWduaW5nLmMgIHwgNzUgKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgIDQgZmlsZXMgY2hhbmdlZCwgODUgaW5zZXJ0
aW9ucygrKSwgODcgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51
eC9tb2R1bGUuaCBiL2luY2x1ZGUvbGludXgvbW9kdWxlLmgNCj4gaW5kZXggZmQ2MTYxZDc4MTI3
Li5hZWEwZmZkOTRhNDEgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvbW9kdWxlLmgNCj4g
KysrIGIvaW5jbHVkZS9saW51eC9tb2R1bGUuaA0KPiBAQCAtODYzLDYgKzg2Myw3IEBAIHN0YXRp
YyBpbmxpbmUgYm9vbCBtb2R1bGVfc2lnX29rKHN0cnVjdCBtb2R1bGUgKm1vZHVsZSkNCj4gICB7
DQo+ICAgCXJldHVybiB0cnVlOw0KPiAgIH0NCj4gKyNkZWZpbmUgc2lnX2VuZm9yY2UgZmFsc2UN
Cg0KSGF2aW5nIHRoYXQgaXMgbW9kdWxlLmggIGl0IG1heSByZWRlZmluZSBzb21lIGV4aXN0aW5n
IHN5bWJvbCwgbGlrZSBpbiANCnNlY3VyaXR5L2ludGVncml0eS9pbWEvaW1hX21haW4uYw0KDQpz
aWdfZW5mb3JjZSBpcyB1c2VkIG9ubHkgaW4gc2lnbmluZy5jIHNvIGl0IHNob3VsZCBiZSBkZWZp
bmVkIHRoZXJlIA0KZXhjbHVzaXZlbHkuIFRoaXMgI2RlZmluZSBzaG91bGRuJ3QgYmUgbmVlZGVk
IGF0IGFsbC4NCg0KDQoNCkFuZCBjaGVja3BhdGNoIGlzIG5vdCBoYXBweToNCg0KQ0hFQ0s6IFBs
ZWFzZSB1c2UgYSBibGFuayBsaW5lIGFmdGVyIGZ1bmN0aW9uL3N0cnVjdC91bmlvbi9lbnVtIGRl
Y2xhcmF0aW9ucw0KIzI3OiBGSUxFOiBpbmNsdWRlL2xpbnV4L21vZHVsZS5oOjg2NjoNCiAgfQ0K
KyNkZWZpbmUgc2lnX2VuZm9yY2UgZmFsc2UNCg0KDQo+ICAgI2VuZGlmCS8qIENPTkZJR19NT0RV
TEVfU0lHICovDQo+ICAgDQo+ICAgaW50IG1vZHVsZV9rYWxsc3ltc19vbl9lYWNoX3N5bWJvbChp
bnQgKCpmbikodm9pZCAqLCBjb25zdCBjaGFyICos
