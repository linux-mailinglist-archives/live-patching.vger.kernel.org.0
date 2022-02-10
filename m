Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4602F4B0FAB
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 15:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242615AbiBJOF7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 09:05:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242612AbiBJOF6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 09:05:58 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120081.outbound.protection.outlook.com [40.107.12.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A39771D6;
        Thu, 10 Feb 2022 06:05:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHTftz84yvlO/9GLjc1tor2CplgSK3zvIW+yrRfGBnazDPnJUVrlMblQ3DM/sCsj+YM+/WilFFOnpbBQJb7CJ/Trj7oqokmtlIW6Uaipo8lSLGEssMWZleSfU9OPn+9X37gPJXujCaHJdMh0NLesy5xkkv4N4dadmnEq3VD1k2nIoZmpqPw/6ElMjqWtVe+R3Dz5j2fteg1QFoCqOuEQHnaTwvdduS0IqW1LNKBZH/3SJG5N16H5W5AgP4R1srxHoylhm+ceJCgbiEfklkHD3+A1PFsN36rpDynVvM+4A5SAaHlvjlw122TBsQXfwsbTRmDpebgnUecQ7YktvH564Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YYZs9tTFP1zLbQJnpofTSBipm/y2YmAaP3w8KfXKNXU=;
 b=SexcwfsFckX6ZAt1RIvBfKS2L733JNzYCWqW0JVZGfCFpkQg7ttGc28CxU/qAdD0S6tSPfujJOHeFVlCpVU5K97fBnCLOdo7eBxCgtaqNbdhUaqyGOeR0vwLN1agNC+MWCy+236JdgO/oZ5MlsSoiyomz8ux77lVzWg/bY1iqf0pA3lwoZYwVy5TcqeSSeeOleDncrFvYiBW8jYIMmTv6rEgzG4rCEUsoJGdMgBVRnxxjuoFBtQQaGdBgZoj8Og3qj3DWrgyam3sUwSAicdVZ9PCZYOVBIoU6/F8NDhd66r1QTnPUwwNZZfIOPjjzzPTuPSvV9w/p6mxXb5kCG2qTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB3046.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 14:05:57 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 14:05:57 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "mcgrof@kernel.org" <mcgrof@kernel.org>,
        Aaron Tomlin <atomlin@atomlin.com>
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
Subject: Re: [PATCH v5 12/13] module: Move kdb_modules list out of core code
Thread-Topic: [PATCH v5 12/13] module: Move kdb_modules list out of core code
Thread-Index: AQHYHdgSRLFUcirHYkqIwQZT+pBbYayM0vQA
Date:   Thu, 10 Feb 2022 14:05:57 +0000
Message-ID: <3a3cc6b3-7bac-3cfd-ce56-7c71abb2de60@csgroup.eu>
References: <20220209171118.3269581-1-atomlin@redhat.com>
 <20220209171118.3269581-2-atomlin@redhat.com>
In-Reply-To: <20220209171118.3269581-2-atomlin@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca418218-cadc-4ac5-deab-08d9ec9e75cd
x-ms-traffictypediagnostic: PR0P264MB3046:EE_
x-microsoft-antispam-prvs: <PR0P264MB304639DA68BA6B58D255EE45ED2F9@PR0P264MB3046.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DMdiQvthdD+dXAaC6s+GtsRWl06dB9EhrW9BAUl/W2jVllAgrgRgX6kIOEbJY9ivD0qTqLrTASylG+NZZ9h4AV6hxGkVa6WgdeOwyo6wYtGqvvE/qxJzr8c1ArhjOt3o4Pe1Lw1+DNCzJ+bZ9GUd3aU3rZGB08QlMy0dwkZrjeKjwcFiKQmJg8UPfsp4dowEasyI303/nhHZQL7T4U6GGEFYUlqxUQFc+6+e1NDQlrPQTeDOpv2qg1ijxpepGttJ+J+LHwzoDy4PoJvVFA2hHlXYOdsZXsQlCbWWATx7DJOsrRUbNt6UfYevineD1r75VGGpm1DdQaa3zj9AoPT7tCvS8mdZNHsMj+b16kXH0/yIwuy1JVUW4j3RKoaYatmBEJGt5exb7gb8fGzCGKZMRNDEMy0OIPygmNqKXA3v5bYHYMb0d2x5pHsuNi8SILjNUv2VIijskbPx5LVoVL2yzSxEjKsKLngMtU6qAUQUneKRw0nGErMkew6+gWYSULsdwMs3t5qGFehwtg5f4t3NnL853DR4zDJhh84FLjfzZHdJoG4+xfbnpdyH/hClGITtyhf3GQsQQhTCj00v3HCCDKGhHxu49lqj4aBkPhi4b0VWUOTsBldAQ2AzAWP7JTtsMYr5OU5LDDZ69p34W9Pv5gbYycB+kJBCGPK2wZ/xxsqahpCfy++6iOes6ZBXzwGgvaqcVtdlRuH6B4CpGoCAu0IXz5MPE9Jx3nYUyXEgL7jSe6T4ArotQk/O/v87Gemd+SnR5rrCC6ud79hbskaNTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31696002)(64756008)(66476007)(66556008)(66946007)(66446008)(4326008)(186003)(26005)(2906002)(122000001)(86362001)(83380400001)(7416002)(76116006)(5660300002)(38100700002)(8676002)(66574015)(44832011)(110136005)(54906003)(38070700005)(36756003)(2616005)(8936002)(6506007)(6512007)(6486002)(31686004)(508600001)(71200400001)(316002)(91956017)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MHlqeEhSUzZPQmpkN2JNN1crSS9CaU5NOVhYY1RhbjJxZVljVVN3YlUyYTRT?=
 =?utf-8?B?TjFHNXh4Z3F1TjFTcUNyR0RUMFRUanZDa1VwOUpya3MxcjJZQmU3WnpmTGE4?=
 =?utf-8?B?eVpXNUlZWkFsTVNudzV0K0xEVUxSYnlCNENPUWRoNTNXY2RFa2QwWVZJUVlC?=
 =?utf-8?B?QStzK1BrWGRpM2s2aGk4aHRDOHVhdUdiUzRHVFVSYmF5dkZxUlMxeWhhZlFF?=
 =?utf-8?B?U1V5TUZMczNHU3MyVGNreUtTOVFpVlkxY0M3dTNtWXFzamRMZDVWT0VIQmJJ?=
 =?utf-8?B?LzRpclpWVXk4MHUzTjFyWE9jQWpaMEp2andPMDZKRUVURWZwWEtkaGhhUGlr?=
 =?utf-8?B?UURPSG5OVTJIS0xXUEp6Q3JiZkRLSmNTc0FYRUp4aEl6OEJiMktMczF3ZXI3?=
 =?utf-8?B?WHRCVUw2bzVEelJHZ0x6UnUyRkVJQWordXJyL1pJS1REVFdtVGtQT2svRFcx?=
 =?utf-8?B?OGt2YWV4SE9UdWg1WTNwZ3FWOHU0NUYyU0FZRVhQZm1Hdkt2RWpVSUdENVhy?=
 =?utf-8?B?TGNkSUhXc29PQXk5bENlbXZsUlJlTEJnb0lVeTdCeXBLd2taeGhxWmQ0QnR2?=
 =?utf-8?B?dVd3TmhnQ0xwZitCdmRsVDFRUWhBclFRbEwrbGZ4UmhaVHRNWGwwanBmQXFp?=
 =?utf-8?B?NE9lcWxkdks4S2VuWWN0aGFTZlF1OGhDdDZXUCtPUUJnRmZaVlNOYzU5V2xo?=
 =?utf-8?B?QTBsZFlaTFFhWVVwZTlwZUE2UEN6QmhDakg3TWpTd0V3eTRoU3ZpRU1velJC?=
 =?utf-8?B?K1lUdGlUd3RnUEU0VTVDWTBOMjlVN1NwMlkxYjVMbCtmclZJNGVEN1pUZzBZ?=
 =?utf-8?B?dWdtOFUrT0Q1aXNTTm1vcGdETDNDby9sRVNaV3lBMjV3QUZmdkEyZGRPOEtt?=
 =?utf-8?B?STUrakVZT3NKR1NLdjZ1dHdSNGx6MzVqZDdpWGJGWmlaZjhaQ3BEY05lVC9P?=
 =?utf-8?B?dXNrMC9rVmVkcEp2RytwNlBNNEp3Nmhtamw3QnQ2NWlnaVZDWkFNUk1vbjVh?=
 =?utf-8?B?VXZic1VIZ3duVWFYd3AwendpcWRSV2VhS1c4WklkakIrVVhTMHpKWWNEc1oy?=
 =?utf-8?B?QzRQem1NWnlNRStheVp1VEM4K2RoTGZNNDFrTndQVkhjTURXNi9aTEswNllq?=
 =?utf-8?B?MnVBc1BzeWpaUlNVMUZVeWlMaVhLRXVZMkZQYmptU1ZCbTByRVJYZHVWbnZE?=
 =?utf-8?B?SXdVcm1DWW1OWUt5S3JoZ3RKaVNZSVluYkV3MjJUUEtDRHh2OGZONXRKVnk0?=
 =?utf-8?B?eENHRGdsWjl1RmdzS0M4cWR5anpsaTBXVGppMzgvRGpMcVR3amNqVHUxV0Ur?=
 =?utf-8?B?L3ZsNlpLZEVvR1d2dGx5VE9QOThKb1B6K0h0QjZJY0lPaHB2SkRFU2c1dkcr?=
 =?utf-8?B?TmpzUVVpVzFxMDlvVEFNczNxa3U5WC9rVnBVZUVUVDNtZmkzaXJlV0VHclV2?=
 =?utf-8?B?cTIveWx3TEJvYWdNVStHWi9DUDdLWktJVlcwTGErSEJXNVk0VUNUemFnQVJq?=
 =?utf-8?B?RFFQcjZzNUlmc1JWQmxLQWl5aVM0bExmanhDbU5YaXJZdTl2Vldjai9VQTAx?=
 =?utf-8?B?dHpKSGY1YUQxNld6R1M5YU1hdGI2cW5KbWI1cG1hNDM2QU5pUlZnalJ5ajFI?=
 =?utf-8?B?bUd0NW9menNTYjNJWHF0TzNCUzE4d2YwVFJuQTB6MjBuallTdGhhSlp3YmRZ?=
 =?utf-8?B?TGdmejhFaDN2TWM5WUhpaVN1RGtpUkxGTnFsbnVhMmtIMmIwM1BCRitiMzli?=
 =?utf-8?B?dXZHSXErcnVNMFlycG9hbEErSUNmb0U4eWY5cmxvbXpDVEdkSmk0Z2Z3VElP?=
 =?utf-8?B?TzdxdFpXMG9KV3d2K0hqaEpCMW8wT0F5SC9zdVlTbC90THhVM21xUk9CTEFF?=
 =?utf-8?B?WFdubFpuMVZmeDJHRzZaQm0zU2tjTnBNOUtKT2V4YjIwUHBFYXo3bnBzelVD?=
 =?utf-8?B?RENNOHNwYUV3aWQ3ZjF3a0tCRTFnS1dDT3o0cS8rMHhHWFFucWQxdEYyMFJV?=
 =?utf-8?B?TjAxT2hKVDQwelFaSHp4RE0vcTd4Z3JsWTU1dFA2aVdUWXJYM0Y0RTJEZXph?=
 =?utf-8?B?MGIrQzNTU2ZDMWxpTEZNTG45enJJcHA0elFCSmhmdlRQeHNkWXQxU21NTFdV?=
 =?utf-8?B?M1JOUHhtZzBsVHBzWkk4YWFTWHJIenZJRDRRWS8rZWYxd3BpSWtRUTdsN003?=
 =?utf-8?B?NklleFJFWkp1Zkd1aVhadlZ6c0daM2FvWEdrSDZweHBUYnZOV3E3MSswbmdF?=
 =?utf-8?Q?tYuR+0zz/jTIdJQDxgvjCjAXXPTnv3SnpDcc52LC28=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4DF065A840FEB4CA98F6CD597FCA70D@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ca418218-cadc-4ac5-deab-08d9ec9e75cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 14:05:57.4581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eVHW6Nt8PtYyGZpn8GgN2biixpj1ndnH/NOs1kE3EJRZG2ONEFeGAS8zVnolyjskvofx79HpBYfZeih5LuGb/x+cIVSiTrZj3uijN7VOiSs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB3046
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDA5LzAyLzIwMjIgw6AgMTg6MTEsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBO
byBmdW5jdGlvbmFsIGNoYW5nZS4NCj4gDQo+IFRoaXMgcGF0Y2ggbWlncmF0ZXMga2RiX21vZHVs
ZXMgbGlzdCB0byBjb3JlIGtkYiBjb2RlDQo+IHNpbmNlIHRoZSBsaXN0IG9mIGFkZGVkL29yIGxv
YWRlZCBtb2R1bGVzIGlzIG5vIGxvbmdlcg0KPiBwcml2YXRlLg0KPiANCj4gU2lnbmVkLW9mZi1i
eTogQWFyb24gVG9tbGluIDxhdG9tbGluQHJlZGhhdC5jb20+DQo+IC0tLQ0KPiAgIGtlcm5lbC9k
ZWJ1Zy9rZGIva2RiX21haW4uYyB8IDUgKysrKysNCj4gICBrZXJuZWwvbW9kdWxlL2ludGVybmFs
LmggICAgfCAxICsNCj4gICBrZXJuZWwvbW9kdWxlL21haW4uYyAgICAgICAgfCA0IC0tLS0NCj4g
ICAzIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS9rZXJuZWwvZGVidWcva2RiL2tkYl9tYWluLmMgYi9rZXJuZWwvZGVidWcv
a2RiL2tkYl9tYWluLmMNCj4gaW5kZXggMDg1MmE1MzdkYWQ0Li5mMTAxZjVmMDc4ZjQgMTAwNjQ0
DQo+IC0tLSBhL2tlcm5lbC9kZWJ1Zy9rZGIva2RiX21haW4uYw0KPiArKysgYi9rZXJuZWwvZGVi
dWcva2RiL2tkYl9tYWluLmMNCj4gQEAgLTU5LDYgKzU5LDExIEBAIEVYUE9SVF9TWU1CT0woa2Ri
X2dyZXBwaW5nX2ZsYWcpOw0KPiAgIGludCBrZGJfZ3JlcF9sZWFkaW5nOw0KPiAgIGludCBrZGJf
Z3JlcF90cmFpbGluZzsNCj4gICANCj4gKyNpZmRlZiBDT05GSUdfTU9EVUxFUw0KPiArZXh0ZXJu
IHN0cnVjdCBsaXN0X2hlYWQgbW9kdWxlczsNCg0KU2hvdWxkIGdvIGluIG1vZHVsZS5oDQoNCj4g
K3N0cnVjdCBsaXN0X2hlYWQgKmtkYl9tb2R1bGVzID0gJm1vZHVsZXM7IC8qIGtkYiBuZWVkcyB0
aGUgbGlzdCBvZiBtb2R1bGVzICovDQoNClNob3VsZCBiZSBzdGF0aWMgYW5kIHNob3VsZCBiZSBy
ZW1vdmVkIGZyb20ga2VybmVsL2RlYnVnL2tkYi9rZGJfcHJpdmF0ZS5oDQoNCj4gKyNlbmRpZiAv
KiBDT05GSUdfTU9EVUxFUyAqLw0KPiArDQo+ICAgLyoNCj4gICAgKiBLZXJuZWwgZGVidWdnZXIg
c3RhdGUgZmxhZ3MNCj4gICAgKi8NCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9tb2R1bGUvaW50ZXJu
YWwuaCBiL2tlcm5lbC9tb2R1bGUvaW50ZXJuYWwuaA0KPiBpbmRleCA1MmQzMGJmNmQ2YjAuLmM0
OWI0OTAwYjMwYiAxMDA2NDQNCj4gLS0tIGEva2VybmVsL21vZHVsZS9pbnRlcm5hbC5oDQo+ICsr
KyBiL2tlcm5lbC9tb2R1bGUvaW50ZXJuYWwuaA0KPiBAQCAtMjI1LDYgKzIyNSw3IEBAIHN0YXRp
YyBpbnQgbW9kX3N5c2ZzX3NldHVwKHN0cnVjdCBtb2R1bGUgKm1vZCwNCj4gICB7DQo+ICAgCXJl
dHVybiAwOw0KPiAgIH0NCj4gKw0KDQpUaGlzIHNob3VsZCBnbyBpbiBwcmV2aW91cyBwYXRjaCBp
ZiBuZWVkZWQgKHBhdGNoIDExIHN5c2ZzKQ0KDQoNCj4gICBzdGF0aWMgaW5saW5lIHZvaWQgbW9k
X3N5c2ZzX2Zpbmkoc3RydWN0IG1vZHVsZSAqbW9kKSB7IH0NCj4gICBzdGF0aWMgaW5saW5lIHZv
aWQgbW9kdWxlX3JlbW92ZV9tb2RpbmZvX2F0dHJzKHN0cnVjdCBtb2R1bGUgKm1vZCwgaW50IGVu
ZCkgeyB9DQo+ICAgc3RhdGljIGlubGluZSB2b2lkIGRlbF91c2FnZV9saW5rcyhzdHJ1Y3QgbW9k
dWxlICptb2QpIHsgfQ0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL21vZHVsZS9tYWluLmMgYi9rZXJu
ZWwvbW9kdWxlL21haW4uYw0KPiBpbmRleCBjMjI1NTk1NGI3ZGYuLjUxOWM1MzM1ZjdhNiAxMDA2
NDQNCj4gLS0tIGEva2VybmVsL21vZHVsZS9tYWluLmMNCj4gKysrIGIva2VybmVsL21vZHVsZS9t
YWluLmMNCj4gQEAgLTEwNSwxMCArMTA1LDYgQEAgc3RhdGljIHZvaWQgbW9kX3VwZGF0ZV9ib3Vu
ZHMoc3RydWN0IG1vZHVsZSAqbW9kKQ0KPiAgIAkJX19tb2RfdXBkYXRlX2JvdW5kcyhtb2QtPmlu
aXRfbGF5b3V0LmJhc2UsIG1vZC0+aW5pdF9sYXlvdXQuc2l6ZSk7DQo+ICAgfQ0KPiAgIA0KPiAt
I2lmZGVmIENPTkZJR19LR0RCX0tEQg0KPiAtc3RydWN0IGxpc3RfaGVhZCAqa2RiX21vZHVsZXMg
PSAmbW9kdWxlczsgLyoga2RiIG5lZWRzIHRoZSBsaXN0IG9mIG1vZHVsZXMgKi8NCj4gLSNlbmRp
ZiAvKiBDT05GSUdfS0dEQl9LREIgKi8NCj4gLQ0KPiAgIHN0YXRpYyB2b2lkIG1vZHVsZV9hc3Nl
cnRfbXV0ZXhfb3JfcHJlZW1wdCh2b2lkKQ0KPiAgIHsNCj4gICAjaWZkZWYgQ09ORklHX0xPQ0tE
RVA=
