Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58834B0E19
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 14:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241937AbiBJNHZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 08:07:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiBJNHY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 08:07:24 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90045.outbound.protection.outlook.com [40.107.9.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7431FEA;
        Thu, 10 Feb 2022 05:07:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hV9cs0Sj1coj3PWo7XxMwbQlyyFffquMXimWi5ig03lvx6hQoiU4YW4CN9S1Vi12y449ibBcm4nGUtNX4/iRY1Vup+iXMdF9tFakWfNQPbiGbU8sZwWYDz5N7elYl8IW1OdnxsTVoaUSzZTFCpaoWVUJjCDjpNPxus4YhcMsUP6et0R9x8ICoU1SbIuLBef6d78Qdf38vv5+Wk7n6VMkGBaJglAZofiGMeYa+1usomBkLNwNdEOlz2U8ibJrXbiAeffK2YGA8318VqPDXJ9lH7z2tGlZP0pynL+Wpk32WQJ7sugBOTXpprNzGQ6NdBrw6phVzyHicW8771dQ0CwOng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lU40rPxZT2z3K/MRdjj59VhuYHMronRBfJSR8/TMnU4=;
 b=H37YGNCHrC48lgPUrKTlbnfxq5tlJMgDqvKYdyJJ5NKtWRCFeYm9s/gHA0FP/07AgdfrGQekZSYYv4wbkoJlOP+PiTVXXjdEcX35jHwtzwq4tt9YBMcSW+i184u6DtvBQxJ57p7dGgroYmiZFwn7AmFdx/9nWx5IRN2TfQlsk6HGCyqVrCqp3rPLWv25FwmCbdOhUR9yKOtpb43DYhYU6Y+pFQkkofTu3A5eAt2hsfznO1aDyRDno7vQqagoUHHP46DUueWzfjq0vc/cuMcucXxKUwsFJwLRaeywDeF8MJMHHD9T9gn30nSm6D2YyeCKDRENx1i2LG+Bi9+OZ0bRYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB0139.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Thu, 10 Feb
 2022 13:07:22 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 13:07:22 +0000
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
Subject: Re: [PATCH v5 08/13] module: Move kmemleak support to a separate file
Thread-Topic: [PATCH v5 08/13] module: Move kmemleak support to a separate
 file
Thread-Index: AQHYHdekhzOiUJcAzUWTSNEPEB+bqayMwpeA
Date:   Thu, 10 Feb 2022 13:07:22 +0000
Message-ID: <2bee9eb2-d59f-a5cd-d89a-b818d94b74af@csgroup.eu>
References: <20220209170814.3268487-1-atomlin@redhat.com>
 <20220209170814.3268487-2-atomlin@redhat.com>
In-Reply-To: <20220209170814.3268487-2-atomlin@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce31294f-ac3a-4ef2-8ff6-08d9ec9646e1
x-ms-traffictypediagnostic: PR0P264MB0139:EE_
x-microsoft-antispam-prvs: <PR0P264MB0139439A476F3CF1BC663C3CED2F9@PR0P264MB0139.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eoFXDlra0mcHJYJfo/Mnf+gu4xkhWQddaYb8EEO3VO6kwkFlRqA7DiY9DB5a2G2iov9DEMj8Yjjjmev57EkiE2rbZuD+WBECiv64jmlQEJH1Tu1d1XFQEj7vk21kFdYsBu2U6mrYAfnTQ3wonk7vhhFcKMYmxCTa5ecrVACV1a41bnLiVgkIpHPMXsFKt/fdQ8qs7pstyh6a0/rKpc3RuqMyjcJQCTPHTRwdUbfiHnHvt4WoeP9DU0MkICdieUBnaBM3/KsNQqAXeMujLuzXsYZ9Yfu5R8fBhe7h6a+iqSYCZylI1q9OjwVjksq/r+0ubjz077v4Lk76/ntzGec4kN/9C/xGpKrCqY+F5YqBKNYwoZU+w8XrFrPS99AMnCki/k8lVl9sdfmPkF9VEzDfvD+95SjzZLrsB2UXiviLU+Ze9P0T2PuNkD3uaPGTEn2TX6bw9/J0d39K6YXbwvOSRru9JjW6kSMm4mv/PuHOVyiAr4mQZAUZARYjNHmBTMuoj/9u+YmUYMeper7aQNK0JgGpIjtJfhcFgT6sFFYp2TB5uDquTXB8jpZGeez2TTfKhmuPF1zN0cOXf/aDOH9q9ufxUYrkPD3BZQnPyJGdhGyUr/v8p39g9C3mVgOYEj7N/I9V/Tp8HWWvNznS7oWs1LN6S171hghydyx5TCn8INwgNQHH0MOpxhs7h3PQnwXh5gF5EcpOgV76IK76HfGJId+smG7ot1rEQAlmmwjmb1GKN7Zxs2nF4N7sNTBXoA0XMxXwsqXWcwywWwsNNDuFlQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(91956017)(66946007)(6506007)(122000001)(31686004)(38100700002)(2906002)(36756003)(508600001)(38070700005)(316002)(54906003)(110136005)(6512007)(4326008)(6486002)(31696002)(64756008)(86362001)(76116006)(2616005)(66574015)(5660300002)(66476007)(66446008)(66556008)(8936002)(7416002)(71200400001)(83380400001)(44832011)(26005)(186003)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aE1FL29pNUg5cWFNS1NJZ2lValFENnJRSzkvTEVaUFdmcEZWSFZlY3FoU2xH?=
 =?utf-8?B?NzBDRlJNWWcxaDlub2tMT3V2eFJnWGk5bUJGNUNQd2plck9ZUFBoemJyTDBw?=
 =?utf-8?B?bmZzbWx1VUx0bVNFUDduRVJ5clV1aVQ3c1VuRS9pYWY5WDQwTi81WlM5ZTVl?=
 =?utf-8?B?Z3kxOFdxaSt3L2J6bmFYRFNvKzkrRE0xM293L084SFZqV1p2M21oL3ZJZjNu?=
 =?utf-8?B?RkFnZG9EalBOTmd2UEhPYWJ1U0lWT2hGV2o1Z0o4aDBtQ1RUbFF3R25YeVFB?=
 =?utf-8?B?YWFpRXFaSGRiZWJTZmVaZzlzb2E0UEYrYys4dHUrTUNxWkJTNEU0SDZRcjIx?=
 =?utf-8?B?bG90NDBSWU1JVVMrRXdmVHo2MG43MUpWVllaYTBNblZPR09xeFgrTkFwcVpj?=
 =?utf-8?B?U1dkMUpQUmdEU0pwb0VWVW0rWkZVZmhVSzBJR3JmNG9TZlF2clhHdkxncEQ0?=
 =?utf-8?B?Rm9PNjB0cDVtc1p1N0w5dC9YT0xlKzZSUnQ2NVNzd2JoWGRWcG15TXl0OC91?=
 =?utf-8?B?emVhbE94Yk9BTnRpUEo1cFpHbTdyK3NtMnljSmZpZ0dxUlNBNmpiYnMrNGI5?=
 =?utf-8?B?M00wN3BRRlV0MTBCNmhTZy8veHo3dTdaKzJxTDBLVlViK1Qwa1RSeDRBYTRB?=
 =?utf-8?B?cU40TzB2dCtvSFNLbjBJNUY0Z0xGMU9oWndIYkZsd2lQTmYxNXRDV1pYdXM2?=
 =?utf-8?B?SkpIMkg5VmlpcHRqaS9qK0hwa0hnMnlIVkY4bEZxMHVPSjAzcGFuZHVENVNu?=
 =?utf-8?B?UFlYeEMwK2NNM0JCS05PL1RUa0tnL0svWk41UDRmNGJmTlRGQW5pdVFQci8z?=
 =?utf-8?B?dmJhakdBL1dWdU8yWk56dC95UnU5WTBOWlJNc3hCQXk5ZnIxR3JXL0ZRb3Nv?=
 =?utf-8?B?VGJLdGxjU050eUhldHF6Vm85eE5mc3FPNWUzTFlVMEZOOHhVMkp4bTNjTE12?=
 =?utf-8?B?d2w3Q0xYL09WSHl6ZzgyQXNxUExycktQeGx1Y3I2RmxEN2ViM1A3bG9vWEZV?=
 =?utf-8?B?NGR0WTZ5dmw1ZlJtZlY2S2hGZjZDaUs5WUsxY3AzamJ2bzJIdERCNXJNQ3lv?=
 =?utf-8?B?cUxwOVVLcThKTHdRL0E2TkhHM05RRWs1TDl5SXo2T3lBZzZyejFnU3RPUjZ3?=
 =?utf-8?B?RCtZTS9hWVhwQkU3OEpYa0xxanh6N3d6K2JvUTl4Tm1mUllYVjBTdzFnbjBN?=
 =?utf-8?B?THkwaUxYT3A2NmpvbDNROWFCOTRpZFhUaWxGT3B1OC9yM253RTFBZzhUUlNs?=
 =?utf-8?B?Mm1QeXh5Snh6TUk2aThVUUpEaVA5cktQbzJMK2gzMHBLSWM4Tlp4cFlSbXRY?=
 =?utf-8?B?d1piRmV6ellGL0Jqb05CVUtMejRSQ01jdUtJamhIR3pTU3lNMmwvMm9VbWpM?=
 =?utf-8?B?UGxLdENzS2Mzbjh1MDZrUk94Mkh6YTlIN1g4NlBFVjN2K05XVWRyR0Q5ZUVh?=
 =?utf-8?B?b0RNY3dHeGUrZEZCU0tIcUE5VDdFdVg1Uk1qWlg5WnpGSFpuUlJMY2V2R25W?=
 =?utf-8?B?WE1WNURmNjJLMHlJY3NlZjIwRWJtOGhlcE1oNnBEOUp2WVRxdDNGekZRR01M?=
 =?utf-8?B?dmVZMGpwU3RLaTlIZjJBWDJtWW03eVFiK3lTVXpWM0ZkRkJHaVpWMUtKVkh5?=
 =?utf-8?B?cndmVkdzOHhCMDQzM2dicndiaExEb3ZvVlFtNWYwSW9QY3RTSWJqM0J0UEFF?=
 =?utf-8?B?ZnJqM0oxbUNwblRLbWxieWtlZEpMbStrS3M5ZlB4N3JRUm9ZYmd1ZGJtUGox?=
 =?utf-8?B?eHlTU203K0FSM0xlenlrbFdTYU5GMVllcHIwNHFvN1hZQ1FnUlVtaTYvRVJp?=
 =?utf-8?B?K3RmTFZ5eE9nSXF2NXk3MWhLaVBCZkllcTF5Z2tMK2NHQjljOHlKQitFTXpx?=
 =?utf-8?B?TWUxM3pYQjliUmtkcFJhMGFEYm0zT3J0MTN4d2crQWVuaFIzU1RBKzZZYzdM?=
 =?utf-8?B?OUpYc0VmRTJRNjlnZ1I2elRHSnZNUWVjbTVKUWJJTDJvWFc4UnYySlU2dVdK?=
 =?utf-8?B?dHN0b1pmUmJ3MGZwOC9KU3NPTzgrZ2JyaytVM0ZoRmE5U3B6UlRtaCtqaVc4?=
 =?utf-8?B?YitZejlsazdsTnNxaVIvYXMrdyt1S0YzR05ZR0hnenNZbjhFUXZrd1o0bTFC?=
 =?utf-8?B?M1BCWlFwaHM0Vm5DVEM0bjRmdWVvODFBNGFLek04cHFPKzB3aVUrbURzUEhE?=
 =?utf-8?B?S0NjWTUxMmhTbXNRWHBYTkxsNTBvTnlwdHhacVFSazZUSGZ1WFd3Z3RKMEdW?=
 =?utf-8?Q?Jf0FJ/GFMZRPg16f2iETjvxODFctrUAkhGrXlnebqs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E980E04668D15449BAC36F20A3FD5B9D@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ce31294f-ac3a-4ef2-8ff6-08d9ec9646e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 13:07:22.7448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 36RuK0zutclTEmIZjn2c0GC2iY09taH7ybVq4+dpHAnMTnanuLlJd9DuoAZxyKxfuvJrLBUhMrtk+xlvoSl6JuUnGU3UL5bCzDQzVE7xbf8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB0139
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDA5LzAyLzIwMjIgw6AgMTg6MDgsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBO
byBmdW5jdGlvbmFsIGNoYW5nZS4NCj4gDQo+IFRoaXMgcGF0Y2ggbWlncmF0ZXMga21lbWxlYWsg
Y29kZSBvdXQgb2YgY29yZSBtb2R1bGUNCj4gY29kZSBpbnRvIGtlcm5lbC9tb2R1bGUvZGVidWdf
a21lbWxlYWsuYw0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWFyb24gVG9tbGluIDxhdG9tbGluQHJl
ZGhhdC5jb20+DQo+IC0tLQ0KPiAgIGtlcm5lbC9tb2R1bGUvTWFrZWZpbGUgICAgICAgICB8ICAx
ICsNCj4gICBrZXJuZWwvbW9kdWxlL2RlYnVnX2ttZW1sZWFrLmMgfCAzMCArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysNCj4gICBrZXJuZWwvbW9kdWxlL2ludGVybmFsLmggICAgICAgfCAg
NyArKysrKysrDQo+ICAga2VybmVsL21vZHVsZS9tYWluLmMgICAgICAgICAgIHwgMjcgLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ICAgNCBmaWxlcyBjaGFuZ2VkLCAzOCBpbnNlcnRpb25z
KCspLCAyNyBkZWxldGlvbnMoLSkNCj4gICBjcmVhdGUgbW9kZSAxMDA2NDQga2VybmVsL21vZHVs
ZS9kZWJ1Z19rbWVtbGVhay5jDQo+IA0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL21vZHVsZS9NYWtl
ZmlsZSBiL2tlcm5lbC9tb2R1bGUvTWFrZWZpbGUNCj4gaW5kZXggOGYyODU3ZDliYTFlLi42MmM5
ZmM5MWQ0MTEgMTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC9tb2R1bGUvTWFrZWZpbGUNCj4gKysrIGIv
a2VybmVsL21vZHVsZS9NYWtlZmlsZQ0KPiBAQCAtMTEsNCArMTEsNSBAQCBpZmRlZiBDT05GSUdf
TU9EVUxFUw0KPiAgIG9iai0kKENPTkZJR19MSVZFUEFUQ0gpICs9IGxpdmVwYXRjaC5vDQo+ICAg
b2JqLSQoQ09ORklHX01PRFVMRVNfVFJFRV9MT09LVVApICs9IHRyZWVfbG9va3VwLm8NCj4gICBv
YmotJChDT05GSUdfU1RSSUNUX01PRFVMRV9SV1gpICs9IHN0cmljdF9yd3gubw0KPiArb2JqLSQo
Q09ORklHX0RFQlVHX0tNRU1MRUFLKSArPSBkZWJ1Z19rbWVtbGVhay5vDQo+ICAgZW5kaWYNCj4g
ZGlmZiAtLWdpdCBhL2tlcm5lbC9tb2R1bGUvZGVidWdfa21lbWxlYWsuYyBiL2tlcm5lbC9tb2R1
bGUvZGVidWdfa21lbWxlYWsuYw0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAw
MDAwMDAwMDAuLmU4OTZjMjI2ODAxMQ0KPiAtLS0gL2Rldi9udWxsDQo+ICsrKyBiL2tlcm5lbC9t
b2R1bGUvZGVidWdfa21lbWxlYWsuYw0KPiBAQCAtMCwwICsxLDMwIEBADQo+ICsvLyBTUERYLUxp
Y2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vci1sYXRlcg0KPiArLyoNCj4gKyAqIE1vZHVsZSBr
bWVtbGVhayBzdXBwb3J0DQo+ICsgKg0KPiArICogQ29weXJpZ2h0IChDKSAyMDA5IENhdGFsaW4g
TWFyaW5hcw0KPiArICovDQo+ICsNCj4gKyNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCj4gKyNp
bmNsdWRlIDxsaW51eC9rbWVtbGVhay5oPg0KPiArI2luY2x1ZGUgImludGVybmFsLmgiDQo+ICsN
Cj4gK3ZvaWQga21lbWxlYWtfbG9hZF9tb2R1bGUoY29uc3Qgc3RydWN0IG1vZHVsZSAqbW9kLA0K
PiArCQkJCSBjb25zdCBzdHJ1Y3QgbG9hZF9pbmZvICppbmZvKQ0KDQpDSEVDSzogQWxpZ25tZW50
IHNob3VsZCBtYXRjaCBvcGVuIHBhcmVudGhlc2lzDQojNDg6IEZJTEU6IGtlcm5lbC9tb2R1bGUv
ZGVidWdfa21lbWxlYWsuYzoxMzoNCit2b2lkIGttZW1sZWFrX2xvYWRfbW9kdWxlKGNvbnN0IHN0
cnVjdCBtb2R1bGUgKm1vZCwNCisJCQkJIGNvbnN0IHN0cnVjdCBsb2FkX2luZm8gKmluZm8pDQoN
Cg0KDQo+ICt7DQo+ICsJdW5zaWduZWQgaW50IGk7DQo+ICsNCj4gKwkvKiBvbmx5IHNjYW4gdGhl
IHNlY3Rpb25zIGNvbnRhaW5pbmcgZGF0YSAqLw0KPiArCWttZW1sZWFrX3NjYW5fYXJlYShtb2Qs
IHNpemVvZihzdHJ1Y3QgbW9kdWxlKSwgR0ZQX0tFUk5FTCk7DQo+ICsNCj4gKwlmb3IgKGkgPSAx
OyBpIDwgaW5mby0+aGRyLT5lX3NobnVtOyBpKyspIHsNCj4gKwkJLyogU2NhbiBhbGwgd3JpdGFi
bGUgc2VjdGlvbnMgdGhhdCdzIG5vdCBleGVjdXRhYmxlICovDQo+ICsJCWlmICghKGluZm8tPnNl
Y2hkcnNbaV0uc2hfZmxhZ3MgJiBTSEZfQUxMT0MpIHx8DQo+ICsJCSAgICAhKGluZm8tPnNlY2hk
cnNbaV0uc2hfZmxhZ3MgJiBTSEZfV1JJVEUpIHx8DQo+ICsJCSAgICAoaW5mby0+c2VjaGRyc1tp
XS5zaF9mbGFncyAmIFNIRl9FWEVDSU5TVFIpKQ0KPiArCQkJY29udGludWU7DQo+ICsNCj4gKwkJ
a21lbWxlYWtfc2Nhbl9hcmVhKCh2b2lkICopaW5mby0+c2VjaGRyc1tpXS5zaF9hZGRyLA0KPiAr
CQkJCSAgIGluZm8tPnNlY2hkcnNbaV0uc2hfc2l6ZSwgR0ZQX0tFUk5FTCk7DQo+ICsJfQ0KPiAr
fQ0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL21vZHVsZS9pbnRlcm5hbC5oIGIva2VybmVsL21vZHVs
ZS9pbnRlcm5hbC5oDQo+IGluZGV4IDZkNTg5MWNjODQyMS4uMzNkN2JlZmQwNjAyIDEwMDY0NA0K
PiAtLS0gYS9rZXJuZWwvbW9kdWxlL2ludGVybmFsLmgNCj4gKysrIGIva2VybmVsL21vZHVsZS9p
bnRlcm5hbC5oDQo+IEBAIC0xNzEsMyArMTcxLDEwIEBAIHN0YXRpYyBpbmxpbmUgaW50IG1vZHVs
ZV9zaWdfY2hlY2soc3RydWN0IGxvYWRfaW5mbyAqaW5mbywgaW50IGZsYWdzKQ0KPiAgIAlyZXR1
cm4gMDsNCj4gICB9DQo+ICAgI2VuZGlmIC8qICFDT05GSUdfTU9EVUxFX1NJRyAqLw0KPiArDQo+
ICsjaWZkZWYgQ09ORklHX0RFQlVHX0tNRU1MRUFLDQo+ICt2b2lkIGttZW1sZWFrX2xvYWRfbW9k
dWxlKGNvbnN0IHN0cnVjdCBtb2R1bGUgKm1vZCwgY29uc3Qgc3RydWN0IGxvYWRfaW5mbyAqaW5m
byk7DQo+ICsjZWxzZSAvKiAhQ09ORklHX0RFQlVHX0tNRU1MRUFLICovDQo+ICtzdGF0aWMgaW5s
aW5lIHZvaWQgX19tYXliZV91bnVzZWQga21lbWxlYWtfbG9hZF9tb2R1bGUoY29uc3Qgc3RydWN0
IG1vZHVsZSAqbW9kLA0KPiArCQkJCQkJICAgICAgIGNvbnN0IHN0cnVjdCBsb2FkX2luZm8gKmlu
Zm8pIHsgfQ0KDQpSZW1vdmUgX19tYXliZV91bnVzZWQsIG5vdCBuZWVkZWQgZm9yIGEgJ3N0YXRp
YyBpbmxpbmUnIGluIHRoZSAuaA0KDQoNCj4gKyNlbmRpZiAvKiBDT05GSUdfREVCVUdfS01FTUxF
QUsgKi8NCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9tb2R1bGUvbWFpbi5jIGIva2VybmVsL21vZHVs
ZS9tYWluLmMNCj4gaW5kZXggNDAzZjJhYWNiM2Y2Li5jOTkzMTQ3OWUyZWIgMTAwNjQ0DQo+IC0t
LSBhL2tlcm5lbC9tb2R1bGUvbWFpbi5jDQo+ICsrKyBiL2tlcm5lbC9tb2R1bGUvbWFpbi5jDQo+
IEBAIC0yNTE1LDMzICsyNTE1LDYgQEAgYm9vbCBfX3dlYWsgbW9kdWxlX2V4aXRfc2VjdGlvbihj
b25zdCBjaGFyICpuYW1lKQ0KPiAgIAlyZXR1cm4gc3Ryc3RhcnRzKG5hbWUsICIuZXhpdCIpOw0K
PiAgIH0NCj4gICANCj4gLSNpZmRlZiBDT05GSUdfREVCVUdfS01FTUxFQUsNCj4gLXN0YXRpYyB2
b2lkIGttZW1sZWFrX2xvYWRfbW9kdWxlKGNvbnN0IHN0cnVjdCBtb2R1bGUgKm1vZCwNCj4gLQkJ
CQkgY29uc3Qgc3RydWN0IGxvYWRfaW5mbyAqaW5mbykNCj4gLXsNCj4gLQl1bnNpZ25lZCBpbnQg
aTsNCj4gLQ0KPiAtCS8qIG9ubHkgc2NhbiB0aGUgc2VjdGlvbnMgY29udGFpbmluZyBkYXRhICov
DQo+IC0Ja21lbWxlYWtfc2Nhbl9hcmVhKG1vZCwgc2l6ZW9mKHN0cnVjdCBtb2R1bGUpLCBHRlBf
S0VSTkVMKTsNCj4gLQ0KPiAtCWZvciAoaSA9IDE7IGkgPCBpbmZvLT5oZHItPmVfc2hudW07IGkr
Kykgew0KPiAtCQkvKiBTY2FuIGFsbCB3cml0YWJsZSBzZWN0aW9ucyB0aGF0J3Mgbm90IGV4ZWN1
dGFibGUgKi8NCj4gLQkJaWYgKCEoaW5mby0+c2VjaGRyc1tpXS5zaF9mbGFncyAmIFNIRl9BTExP
QykgfHwNCj4gLQkJICAgICEoaW5mby0+c2VjaGRyc1tpXS5zaF9mbGFncyAmIFNIRl9XUklURSkg
fHwNCj4gLQkJICAgIChpbmZvLT5zZWNoZHJzW2ldLnNoX2ZsYWdzICYgU0hGX0VYRUNJTlNUUikp
DQo+IC0JCQljb250aW51ZTsNCj4gLQ0KPiAtCQlrbWVtbGVha19zY2FuX2FyZWEoKHZvaWQgKilp
bmZvLT5zZWNoZHJzW2ldLnNoX2FkZHIsDQo+IC0JCQkJICAgaW5mby0+c2VjaGRyc1tpXS5zaF9z
aXplLCBHRlBfS0VSTkVMKTsNCj4gLQl9DQo+IC19DQo+IC0jZWxzZQ0KPiAtc3RhdGljIGlubGlu
ZSB2b2lkIGttZW1sZWFrX2xvYWRfbW9kdWxlKGNvbnN0IHN0cnVjdCBtb2R1bGUgKm1vZCwNCj4g
LQkJCQkJY29uc3Qgc3RydWN0IGxvYWRfaW5mbyAqaW5mbykNCj4gLXsNCj4gLX0NCj4gLSNlbmRp
Zg0KPiAtDQo+ICAgc3RhdGljIGludCB2YWxpZGF0ZV9zZWN0aW9uX29mZnNldChzdHJ1Y3QgbG9h
ZF9pbmZvICppbmZvLCBFbGZfU2hkciAqc2hkcikNCj4gICB7DQo+ICAgI2lmIGRlZmluZWQoQ09O
RklHXzY0QklUKQ==
