Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91E1C4B0BF8
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 12:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240594AbiBJLLb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 06:11:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235688AbiBJLL3 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 06:11:29 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90085.outbound.protection.outlook.com [40.107.9.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53C0B71;
        Thu, 10 Feb 2022 03:11:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNIIIcM64mgpJgHOqXl4E/VQRaXbhTOh6O6/h+PG2iTRV4Hq9p75LQM0fhcEZ7Y/hxiLnYhVijPvoOvud14nOCT5HSwxVhxgcWy4Oq63W1C04gJhEjel3sXBFwjSrr6saitQcurm6UR48HYfbcfMJEqfr8OSIAd9L9K4x+gFDhhBSlU6eXSb6NFG4b02LbhS2rOI10wBDdDdE/kjruQBeqyMCrOwBEpYn7ssUfLAdcTRsvffQyJ6UWzBIv1omUgBoz42NMRoNOQtwEcPRBuFktBVdaPiCeMRk2kiRjVEh1eBvmizsdGopNxd7VfHVRDjQQ9VOhkcIp5KweatBWgMUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TUddsljlvZcdiu9qfBnOw0vsKywjqlTT/YTGyR/NznY=;
 b=g29CHD9Z3CVUPW+kB9BiT5RfB1ZLK9BlEfXJ807MSqcbrPWZlLbQgJDvjjUv39ALcoxRyRFtLyAjCCLOYuiCgOXCosyFDUuPaydT8orgHoFQHmrz+ITTLajxoxA+jaVA5Al02UZGDmoi9AYUSUi5Sxzkcw6ODLc7AfxiuuFTn+UTEAC6/yFs0oiDmbDGYC1LYhzJeChtqLj6yTYOWhJYJWdozWyG0GxFckDX3C4RE2bS/qo646FZUlN3sVWhfOuShLdX7IFb7jhzFEOwCuHoYHYZGyD/Bx07wnkbRg6CAvH4TqtDs5xTYJ1KL6Vm97phy0matFkGouO3FCA4ovneCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB0027.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 11:11:26 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 11:11:26 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Aaron Tomlin <atomlin@redhat.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>
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
Subject: Re: [PATCH v5 01/13] module: Move all into module/
Thread-Topic: [PATCH v5 01/13] module: Move all into module/
Thread-Index: AQHYHdcOZbcYShmy7UiO2/BJOpfjRqyMojSA
Date:   Thu, 10 Feb 2022 11:11:26 +0000
Message-ID: <a22eb1b0-3fb5-a70e-cf6f-022571538efb@csgroup.eu>
References: <20220209170358.3266629-1-atomlin@redhat.com>
 <20220209170358.3266629-2-atomlin@redhat.com>
In-Reply-To: <20220209170358.3266629-2-atomlin@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17bec8e5-255f-4143-3d18-08d9ec8614ab
x-ms-traffictypediagnostic: PR0P264MB0027:EE_
x-microsoft-antispam-prvs: <PR0P264MB00272F4A5C1D9CDA25D80C8BED2F9@PR0P264MB0027.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XS7BiqvIsRgWUnPzqmkqYvJbUEjxPUMsowvI0lFP1g5nvbBI3n9hqcRWFvH+RRv3Ru2q8c+1GOetUafBxLN78C0v49KEIwK8M3UaZSY+ujDzCBD/SiU5O6gANC4bQzQmezN3pmzC+xah0X1uHpiOI5GqWSDeNgo69wTFFtqQLQ8nD6guVpJbfCRze5W8SyKGWWmRcQtzAuqC/LHS0GXN8omnZORBhN0r44PI/kZXG2WoIr7OBmaVU0FiWr8EgCsydKkOnh5PCCTdnMci/7QEG05NclSGG7E+CkU7q8gnG8QGco9ANHPhVHh8jGzO3Tj7Kw9N2NWLmLkbSuxJgrEbsT6htmMoAfTdk8nr+9/RIzMzq7Q36joDPepUcaOsGItm3jBqMgCb8iFyH1fkDkM7ksPNsDM3+/n23upxx9XEEkZr4pNBkZqVXdjEeCr+Te359cowEI6UJyVmRCjlYGpDhw/7nCBnhnFOLteapIDVMl+Sp3o7We10NEErfVoRtdtklFp40Zk62rn3e6lQEtZBkkrsa63RJz785n8bEIiY49pukEcIGywY94dcC7HToOiRVGG2uvP/NqLCc9fBtaupmBwky4Vm3dirq9jYU7b6t12kH5MrLaBOaps/XqNeigSdfSUWyf4swfRwY4PVePMI2oH2VvakIY+ZWGmmvQGD94ngDX4Rzu7y1wBKkuK/oO1cA0JO/SsHGhAmRyUWkP7yQrr71tOG685J6muvSzeV3K1d59MlL4SNTIVv7mN5Au6iumFCfp+LRjOc1LUH2JLD2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(64756008)(122000001)(7416002)(66476007)(8936002)(86362001)(8676002)(6486002)(31696002)(91956017)(83380400001)(5660300002)(38100700002)(38070700005)(4326008)(66446008)(54906003)(110136005)(66556008)(66574015)(316002)(76116006)(508600001)(71200400001)(2616005)(31686004)(66946007)(26005)(6506007)(2906002)(186003)(36756003)(6512007)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MklGOXJlN08weDNFMEhPOHRWWnZxUEc5d2lybWxWVVphZFErL3p2MHZGbFRG?=
 =?utf-8?B?Nm5YNU91RWdPUFh4T1B1TTAyeC82OUhsLzE5VXBQeGZvY3ROYUkxd2FGR2M5?=
 =?utf-8?B?em50QWtIZ3NsN21YTVEzb2ZPS1NvbzF4TVlSczJVZVRGa2RnNnJQTlZHU2JK?=
 =?utf-8?B?MUNDdmJSMzhJWi80ZFNhV3FxT2RzdTV3dUhqZTR5UGhpeXdVMldCM0hPbHd1?=
 =?utf-8?B?d0JZUGUzUmVWT0NONTVLWEs3WmJJclZoV2ltNWdqeis5d1MycXBsbUd0TUdy?=
 =?utf-8?B?UmxYRHBxekVHeG5FLys2NjJwTVNMbDFla3lEQklOZERCMjBUcFh0enpsMzM4?=
 =?utf-8?B?YWcxekJ0cFltbVJXWDM1cUhwVlBneFhvdkI0M2V4RmdlR1FWU1dZRDdpemZG?=
 =?utf-8?B?Z3VpNnNCaXBOVkRBNmVKRSttMDdCRzNIWmRGM3FBMTFKcWV3S1pENWVVTVhp?=
 =?utf-8?B?YTdqSHlocVhqRlFhRDRSVHRsNHhpVVJmTnBUeE03ZmYvc0xvdzZXOHVtWTNT?=
 =?utf-8?B?d2NYQU1sazA4azZUM3RFKzR0SVFkTE42UlFBSDFCZWhyRVNKcFlCUGlPZC9u?=
 =?utf-8?B?S0dHTkRxZ1RXbHpNcjJVQSt2cDNCNGUrRDd5TVNQbXZZbW5GemI3WGhaYTdj?=
 =?utf-8?B?NXFHQUVzZDNmN2VKV0NTWGxlTXZYQVZHMzdvMUw0bzVmbi9CWDBzMmRDQW9q?=
 =?utf-8?B?WE1Ub0tSWHhYejVrWkxpREJtQWw4YlY4SHNOVURlempDdS9iTWsvc253L2Ro?=
 =?utf-8?B?NUY5UFJBTmF6NVRyK3B5dWg1d05RTWpEOWR3cGh3US9NV2xZOEFIc0dFK2xn?=
 =?utf-8?B?R08reDFyZjIrOFJ0S09ZUDFYVVI2RGl2M1FCSEkrR3dnZnpYNWpMS3pyOWVP?=
 =?utf-8?B?VWpxejl0aTNYeHcrYWg1WDFpWU0rSW5WbE11bTFwbm9FV2JidlZRRlpteFlT?=
 =?utf-8?B?UGJCbk02a0lXd2JoRUgxTWtibWpRbERkWHJOeUxWQ2lhVk9ZeTZMT0ROY3gz?=
 =?utf-8?B?dlE2QnpES3BBM212MHEvZm12Wm50aGFBd01yQ3hCM0ZPcjVkcEZmc1QzVW53?=
 =?utf-8?B?MlJsb2Z2Q1ZBQ2Rjd2FReUZtTGpSL2hHRHJ6T2N3MlU5V1ZvTzVIYnFkZ0hl?=
 =?utf-8?B?Q1orYzBhTHhmbXdUSVlFQURCNXZITkR4cGhSWE85ODBkOHk0bFR1M21ha2FW?=
 =?utf-8?B?RmgwclloS1V3NW85Q2lUVFVVTUFDd3VUaW10RytscHhFUldMN2piMzZjNG9F?=
 =?utf-8?B?eUN3NjlXNU9kWHova290K3Y3RFE4SFluM0tBUDJ4NHdxcXRSSUZHUTg5MlRi?=
 =?utf-8?B?RFJLMG5uZ0hDN1AzVitMT3kwbUJBejBuVm1qL3BBYWZ3SkkrLy83b3F2LzBP?=
 =?utf-8?B?VHJVOUIwL0p5VURTTUpKT0tlcUhSbHBtK3ZlbnRONHVtRU5pcXY1YTFLM1pD?=
 =?utf-8?B?T0dpYlpvNzZoVW9kZzRpajM5ZTkvQUxMTk8yUVRHNjZuQTJsbmVWYXBENEpP?=
 =?utf-8?B?NkpPd0p4UjUwbGZ3RUxRWWhiV2VEMDVzWkU3eVFLOWpHaUJEdjNvc0RtSklx?=
 =?utf-8?B?SmFCcHVVa05JZVFja2lRenF2a3JEeTdCRDNtMmp2bWgrVzl3a1VzY3ZmU2ZT?=
 =?utf-8?B?SC9Mb3dkYWMxVGZvb0l3Q0FzSGZ0Q1RCL1VXSi8rb0laQzdSM2lUUlNLNWw1?=
 =?utf-8?B?R05WUWtqZUhtbk9vQ21lMWtQRXFrMTlzMkFVNWFjanFFekNlRDRrSGRZVnhY?=
 =?utf-8?B?U0s0bHV1c3ZxMk56SksxMW12VlRvREw1TDUvRmljWXd2U1c2cXhEd1JUc1Bo?=
 =?utf-8?B?NGlUVmExc3BIaTQ3Rm13ZVhxTjR5elNpR0RST3BtY1ZwcVdLTzljZ1FzaGtL?=
 =?utf-8?B?Qjh1d0MwOW5mQXZJRXd1WXA5VDBhYnNScTVwZEJZTDc2d1NqRFcydE43eUhu?=
 =?utf-8?B?bjRUMEcvZlJZNXIzR1NxRVhBRzB2NU90Z2dTalNteFloYncvRzYrZ01yUDQ2?=
 =?utf-8?B?TFd1Y0dKejB6c3ZOSWtnT1dsYzNib3FVK0x5Z3RNR29IeTlrdUdzOE9KdVJi?=
 =?utf-8?B?RHZkWDlETzBzYTNFMURwTkRSajZWcXIwc1ZrT3pac3Z2T2V6eThROE1qZk1G?=
 =?utf-8?B?NXNaRk1XRTRzaTNyS2YwNEViYms5MjhuN2MzWmkrWGhUT1k3a3ZOa2xhRlpj?=
 =?utf-8?B?M29UN3RPbnJwNTNySmFrYnNOaCt6a1NQMGpVZ0NlenprNmJvbUwyS2VIK3R6?=
 =?utf-8?Q?6PlFdp8ggsw1rGYdCbwq4kpowVwTwuoBJktIeoZQE8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CD9970F050A2E408FF162B1F60BB4AC@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 17bec8e5-255f-4143-3d18-08d9ec8614ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 11:11:26.5706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m4aVtfEsq6WKqnsxLqDlfJcYsXj50+J2RC6G2EWNFuo+tjHBvf5ushBQuZ2NEUb0P/lzB5RiitzODy7qktM/upmZd2S74Lohyc9BQtKPst4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB0027
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDA5LzAyLzIwMjIgw6AgMTg6MDMsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBO
byBmdW5jdGlvbmFsIGNoYW5nZXMuDQo+IA0KPiBUaGlzIHBhdGNoIG1vdmVzIGFsbCBtb2R1bGUg
cmVsYXRlZCBjb2RlIGludG8gYSBzZXBhcmF0ZSBkaXJlY3RvcnksDQo+IG1vZGlmaWVzIGVhY2gg
ZmlsZSBuYW1lIGFuZCBjcmVhdGVzIGEgbmV3IE1ha2VmaWxlLiBOb3RlOiB0aGlzIGVmZm9ydA0K
PiBpcyBpbiBwcmVwYXJhdGlvbiB0byByZWZhY3RvciBjb3JlIG1vZHVsZSBjb2RlLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQWFyb24gVG9tbGluIDxhdG9tbGluQHJlZGhhdC5jb20+DQo+IC0tLQ0K
PiAgIE1BSU5UQUlORVJTICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8
IDIgKy0NCj4gICBrZXJuZWwvTWFrZWZpbGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCA1ICstLS0tDQo+ICAga2VybmVsL21vZHVsZS9NYWtlZmlsZSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgOSArKysrKysrKysNCj4gICBrZXJuZWwve21vZHVsZV9kZWNvbXBy
ZXNzLmMgPT4gbW9kdWxlL2RlY29tcHJlc3MuY30gfCAyICstDQo+ICAga2VybmVsL3ttb2R1bGUt
aW50ZXJuYWwuaCA9PiBtb2R1bGUvaW50ZXJuYWwuaH0gICAgIHwgMSArDQo+ICAga2VybmVsL3tt
b2R1bGUuYyA9PiBtb2R1bGUvbWFpbi5jfSAgICAgICAgICAgICAgICAgIHwgMiArLQ0KPiAgIGtl
cm5lbC97bW9kdWxlX3NpZ25hdHVyZS5jID0+IG1vZHVsZS9zaWduYXR1cmUuY30gICB8IDANCj4g
ICBrZXJuZWwve21vZHVsZV9zaWduaW5nLmMgPT4gbW9kdWxlL3NpZ25pbmcuY30gICAgICAgfCAy
ICstDQo+ICAgOCBmaWxlcyBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygt
KQ0KPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBrZXJuZWwvbW9kdWxlL01ha2VmaWxlDQo+ICAgcmVu
YW1lIGtlcm5lbC97bW9kdWxlX2RlY29tcHJlc3MuYyA9PiBtb2R1bGUvZGVjb21wcmVzcy5jfSAo
OTklKQ0KPiAgIHJlbmFtZSBrZXJuZWwve21vZHVsZS1pbnRlcm5hbC5oID0+IG1vZHVsZS9pbnRl
cm5hbC5ofSAoOTklKQ0KPiAgIHJlbmFtZSBrZXJuZWwve21vZHVsZS5jID0+IG1vZHVsZS9tYWlu
LmN9ICg5OSUpDQo+ICAgcmVuYW1lIGtlcm5lbC97bW9kdWxlX3NpZ25hdHVyZS5jID0+IG1vZHVs
ZS9zaWduYXR1cmUuY30gKDEwMCUpDQo+ICAgcmVuYW1lIGtlcm5lbC97bW9kdWxlX3NpZ25pbmcu
YyA9PiBtb2R1bGUvc2lnbmluZy5jfSAoOTclKQ0KPiANCj4gZGlmZiAtLWdpdCBhL01BSU5UQUlO
RVJTIGIvTUFJTlRBSU5FUlMNCj4gaW5kZXggM2U0NjFkYjljZDkxLi43ZTYyMzJiZDE1ZjUgMTAw
NjQ0DQo+IC0tLSBhL01BSU5UQUlORVJTDQo+ICsrKyBiL01BSU5UQUlORVJTDQo+IEBAIC0xMzAw
MSw3ICsxMzAwMSw3IEBAIEw6CWxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gICBTOglN
YWludGFpbmVkDQo+ICAgVDoJZ2l0IGdpdDovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgv
a2VybmVsL2dpdC9tY2dyb2YvbGludXguZ2l0IG1vZHVsZXMtbmV4dA0KPiAgIEY6CWluY2x1ZGUv
bGludXgvbW9kdWxlLmgNCj4gLUY6CWtlcm5lbC9tb2R1bGUuYw0KPiArRjoJa2VybmVsL21vZHVs
ZS9tYWluLmMNCg0KU2hvdWxkbid0IGl0IGJlIHRoZSBlbnRpcmUgZGlyZWN0b3J5ID8NCg0KT3Ro
ZXJ3aXNlIHlvdSBoYXZlIHRvIGFkZCBhbGwgbmV3IGZpbGVzIChhbmQgSSBkaWRuJ3QgZG8gaXQp
Lg0KDQo+ICAgDQo+ICAgTU9OT0xJVEhJQyBQT1dFUiBTWVNURU0gUE1JQyBEUklWRVINCj4gICBN
OglTYXJhdmFuYW4gU2VrYXIgPHNyYXZhbmhvbWVAZ21haWwuY29tPg0KPiBkaWZmIC0tZ2l0IGEv
a2VybmVsL01ha2VmaWxlIGIva2VybmVsL01ha2VmaWxlDQo+IGluZGV4IDU2ZjRlZTk3ZjMyOC4u
M2E2MzgwOTc1YzU3IDEwMDY0NA0KPiAtLS0gYS9rZXJuZWwvTWFrZWZpbGUNCj4gKysrIGIva2Vy
bmVsL01ha2VmaWxlDQo+IEBAIC01Myw2ICs1Myw3IEBAIG9iai15ICs9IHJjdS8NCj4gICBvYmot
eSArPSBsaXZlcGF0Y2gvDQo+ICAgb2JqLXkgKz0gZG1hLw0KPiAgIG9iai15ICs9IGVudHJ5Lw0K
PiArb2JqLXkgKz0gbW9kdWxlLw0KPiAgIA0KPiAgIG9iai0kKENPTkZJR19LQ01QKSArPSBrY21w
Lm8NCj4gICBvYmotJChDT05GSUdfRlJFRVpFUikgKz0gZnJlZXplci5vDQo+IEBAIC02NiwxMCAr
NjcsNiBAQCBpZm5lcSAoJChDT05GSUdfU01QKSx5KQ0KPiAgIG9iai15ICs9IHVwLm8NCj4gICBl
bmRpZg0KPiAgIG9iai0kKENPTkZJR19VSUQxNikgKz0gdWlkMTYubw0KPiAtb2JqLSQoQ09ORklH
X01PRFVMRVMpICs9IG1vZHVsZS5vDQo+IC1vYmotJChDT05GSUdfTU9EVUxFX0RFQ09NUFJFU1Mp
ICs9IG1vZHVsZV9kZWNvbXByZXNzLm8NCj4gLW9iai0kKENPTkZJR19NT0RVTEVfU0lHKSArPSBt
b2R1bGVfc2lnbmluZy5vDQo+IC1vYmotJChDT05GSUdfTU9EVUxFX1NJR19GT1JNQVQpICs9IG1v
ZHVsZV9zaWduYXR1cmUubw0KPiAgIG9iai0kKENPTkZJR19LQUxMU1lNUykgKz0ga2FsbHN5bXMu
bw0KPiAgIG9iai0kKENPTkZJR19CU0RfUFJPQ0VTU19BQ0NUKSArPSBhY2N0Lm8NCj4gICBvYmot
JChDT05GSUdfQ1JBU0hfQ09SRSkgKz0gY3Jhc2hfY29yZS5vDQo+IGRpZmYgLS1naXQgYS9rZXJu
ZWwvbW9kdWxlL01ha2VmaWxlIGIva2VybmVsL21vZHVsZS9NYWtlZmlsZQ0KPiBuZXcgZmlsZSBt
b2RlIDEwMDY0NA0KPiBpbmRleCAwMDAwMDAwMDAwMDAuLjI5MDJmYzdkMGVmMQ0KPiAtLS0gL2Rl
di9udWxsDQo+ICsrKyBiL2tlcm5lbC9tb2R1bGUvTWFrZWZpbGUNCj4gQEAgLTAsMCArMSw5IEBA
DQo+ICsjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkNCj4gKyMNCj4gKyMg
TWFrZWZpbGUgZm9yIGxpbnV4IGtlcm5lbCBtb2R1bGUgc3VwcG9ydA0KPiArIw0KPiArDQo+ICtv
YmotJChDT05GSUdfTU9EVUxFUykgKz0gbWFpbi5vDQo+ICtvYmotJChDT05GSUdfTU9EVUxFX0RF
Q09NUFJFU1MpICs9IGRlY29tcHJlc3Mubw0KPiArb2JqLSQoQ09ORklHX01PRFVMRV9TSUcpICs9
IHNpZ25pbmcubw0KPiArb2JqLSQoQ09ORklHX01PRFVMRV9TSUdfRk9STUFUKSArPSBzaWduYXR1
cmUubw0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL21vZHVsZV9kZWNvbXByZXNzLmMgYi9rZXJuZWwv
bW9kdWxlL2RlY29tcHJlc3MuYw0KPiBzaW1pbGFyaXR5IGluZGV4IDk5JQ0KPiByZW5hbWUgZnJv
bSBrZXJuZWwvbW9kdWxlX2RlY29tcHJlc3MuYw0KPiByZW5hbWUgdG8ga2VybmVsL21vZHVsZS9k
ZWNvbXByZXNzLmMNCj4gaW5kZXggYjAxYzY5YzJmZjk5Li5jMTUzZmQ4YTQ0NDQgMTAwNjQ0DQo+
IC0tLSBhL2tlcm5lbC9tb2R1bGVfZGVjb21wcmVzcy5jDQo+ICsrKyBiL2tlcm5lbC9tb2R1bGUv
ZGVjb21wcmVzcy5jDQo+IEBAIC0xMiw3ICsxMiw3IEBADQo+ICAgI2luY2x1ZGUgPGxpbnV4L3N5
c2ZzLmg+DQo+ICAgI2luY2x1ZGUgPGxpbnV4L3ZtYWxsb2MuaD4NCj4gICANCj4gLSNpbmNsdWRl
ICJtb2R1bGUtaW50ZXJuYWwuaCINCj4gKyNpbmNsdWRlICJpbnRlcm5hbC5oIg0KPiAgIA0KPiAg
IHN0YXRpYyBpbnQgbW9kdWxlX2V4dGVuZF9tYXhfcGFnZXMoc3RydWN0IGxvYWRfaW5mbyAqaW5m
bywgdW5zaWduZWQgaW50IGV4dGVudCkNCj4gICB7DQo+IGRpZmYgLS1naXQgYS9rZXJuZWwvbW9k
dWxlLWludGVybmFsLmggYi9rZXJuZWwvbW9kdWxlL2ludGVybmFsLmgNCj4gc2ltaWxhcml0eSBp
bmRleCA5OSUNCj4gcmVuYW1lIGZyb20ga2VybmVsL21vZHVsZS1pbnRlcm5hbC5oDQo+IHJlbmFt
ZSB0byBrZXJuZWwvbW9kdWxlL2ludGVybmFsLmgNCj4gaW5kZXggOGMzODFjOTkwNjJmLi5jNDk4
OTYzNjhmN2YgMTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC9tb2R1bGUtaW50ZXJuYWwuaA0KPiArKysg
Yi9rZXJuZWwvbW9kdWxlL2ludGVybmFsLmgNCj4gQEAgLTQ0LDYgKzQ0LDcgQEAgc3RhdGljIGlu
bGluZSBpbnQgbW9kdWxlX2RlY29tcHJlc3Moc3RydWN0IGxvYWRfaW5mbyAqaW5mbywNCj4gICB7
DQo+ICAgCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gICB9DQo+ICsNCg0KVGhpcyBuZXcgbGluZSBz
aG91bGQgYmUgaW4gcGF0Y2ggMyBpbnN0ZWFkLg0KDQo+ICAgc3RhdGljIGlubGluZSB2b2lkIG1v
ZHVsZV9kZWNvbXByZXNzX2NsZWFudXAoc3RydWN0IGxvYWRfaW5mbyAqaW5mbykNCj4gICB7DQo+
ICAgfQ0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL21vZHVsZS5jIGIva2VybmVsL21vZHVsZS9tYWlu
LmMNCj4gc2ltaWxhcml0eSBpbmRleCA5OSUNCj4gcmVuYW1lIGZyb20ga2VybmVsL21vZHVsZS5j
DQo+IHJlbmFtZSB0byBrZXJuZWwvbW9kdWxlL21haW4uYw0KPiBpbmRleCA0NmE1YzJlZDE5Mjgu
LjM0YTJiMGNmM2MzZSAxMDA2NDQNCj4gLS0tIGEva2VybmVsL21vZHVsZS5jDQo+ICsrKyBiL2tl
cm5lbC9tb2R1bGUvbWFpbi5jDQo+IEBAIC01OCw3ICs1OCw3IEBADQo+ICAgI2luY2x1ZGUgPGxp
bnV4L2R5bmFtaWNfZGVidWcuaD4NCj4gICAjaW5jbHVkZSA8bGludXgvYXVkaXQuaD4NCj4gICAj
aW5jbHVkZSA8dWFwaS9saW51eC9tb2R1bGUuaD4NCj4gLSNpbmNsdWRlICJtb2R1bGUtaW50ZXJu
YWwuaCINCj4gKyNpbmNsdWRlICJpbnRlcm5hbC5oIg0KPiAgIA0KPiAgICNkZWZpbmUgQ1JFQVRF
X1RSQUNFX1BPSU5UUw0KPiAgICNpbmNsdWRlIDx0cmFjZS9ldmVudHMvbW9kdWxlLmg+DQo+IGRp
ZmYgLS1naXQgYS9rZXJuZWwvbW9kdWxlX3NpZ25hdHVyZS5jIGIva2VybmVsL21vZHVsZS9zaWdu
YXR1cmUuYw0KPiBzaW1pbGFyaXR5IGluZGV4IDEwMCUNCj4gcmVuYW1lIGZyb20ga2VybmVsL21v
ZHVsZV9zaWduYXR1cmUuYw0KPiByZW5hbWUgdG8ga2VybmVsL21vZHVsZS9zaWduYXR1cmUuYw0K
PiBkaWZmIC0tZ2l0IGEva2VybmVsL21vZHVsZV9zaWduaW5nLmMgYi9rZXJuZWwvbW9kdWxlL3Np
Z25pbmcuYw0KPiBzaW1pbGFyaXR5IGluZGV4IDk3JQ0KPiByZW5hbWUgZnJvbSBrZXJuZWwvbW9k
dWxlX3NpZ25pbmcuYw0KPiByZW5hbWUgdG8ga2VybmVsL21vZHVsZS9zaWduaW5nLmMNCj4gaW5k
ZXggODcyM2FlNzBlYTFmLi44YWViNmQyZWU5NGIgMTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC9tb2R1
bGVfc2lnbmluZy5jDQo+ICsrKyBiL2tlcm5lbC9tb2R1bGUvc2lnbmluZy5jDQo+IEBAIC0xMiw3
ICsxMiw3IEBADQo+ICAgI2luY2x1ZGUgPGxpbnV4L3N0cmluZy5oPg0KPiAgICNpbmNsdWRlIDxs
aW51eC92ZXJpZmljYXRpb24uaD4NCj4gICAjaW5jbHVkZSA8Y3J5cHRvL3B1YmxpY19rZXkuaD4N
Cj4gLSNpbmNsdWRlICJtb2R1bGUtaW50ZXJuYWwuaCINCj4gKyNpbmNsdWRlICJpbnRlcm5hbC5o
Ig0KPiAgIA0KPiAgIC8qDQo+ICAgICogVmVyaWZ5IHRoZSBzaWduYXR1cmUgb24gYSBtb2R1bGUu
