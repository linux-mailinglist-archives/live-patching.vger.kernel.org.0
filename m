Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E1F4B0CAD
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 12:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240969AbiBJLoz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 06:44:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbiBJLoz (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 06:44:55 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120059.outbound.protection.outlook.com [40.107.12.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091A213A;
        Thu, 10 Feb 2022 03:44:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mu1HD2oFDV+AfSa30Ri2f8os/558AHEGajyi/nnsXw/UhVzrV5n7x/o0f/gkD1LYGqz+Z2OFqJZ+wM3ZL2ljF0Tc5BVamcedmE+LcU+ZIqbAXcmlUVnl0+A2DRcIfJTKwHfmLRHjuZylDyvQATU4tYGU66f/ptCuOypeGhDD5Nbt+F0quVwdufyag8it0G3o4VeVJaet9fvY+AxB/0UJeN1mvFYaO0gXfu47tKwYeFTuUYcnZcm6jyYmiwH4MH+p89WfOxTcuBKkiw1G/OIZYvAKL/qsHER6Sl9sFVz/itj49C1cnTCDeSjqxphEmwcSPcS/RQ8iEmkX9gdRDxcwlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qxI4TPykbGNPQcZM8EhN3Xocjj+uOUicJeuTlG6Bh2g=;
 b=cHm5T+kW2TaKeIygtManH6X0XrYG3leaGbOopcOK6YfI38qiSmGKR4pHRi7eS+diDkyOXfP46m4Hq+sulg5pifI+T5dJAHP/yD7qsd4T8t4MJKWM8ubH6sjdDpIXro8xAofDTbtixMd9DTLZzCNqIT5IoYSavkTIE9vTBCVRj2om5ncOnWwl5TNCoLEH7LgXtDWohy6DMpKzKrEYhgJyUAmhx3a+sLFJMWiwTphdKkYlz3eG6BE/zqMj0camIP/a+F885TVYPWRIwDlMgxjauxX/jP0vhemDyGcgCsLvjA5pCojMBXfFtFituwLIGjmATLWBmCbXK1OGXgk2W4fA8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB2324.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:35::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 11:44:52 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 11:44:52 +0000
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
Subject: Re: [PATCH v5 04/13] module: Move livepatch support to a separate
 file
Thread-Topic: [PATCH v5 04/13] module: Move livepatch support to a separate
 file
Thread-Index: AQHYHdcOi5ABMB2Uu06lEi9Y34AcnayMq4uA
Date:   Thu, 10 Feb 2022 11:44:52 +0000
Message-ID: <c8f97323-fcaa-5316-df79-60fd91c837aa@csgroup.eu>
References: <20220209170358.3266629-1-atomlin@redhat.com>
 <20220209170358.3266629-5-atomlin@redhat.com>
In-Reply-To: <20220209170358.3266629-5-atomlin@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6d0abc9-9aa4-4653-4fff-08d9ec8ac022
x-ms-traffictypediagnostic: MR1P264MB2324:EE_
x-microsoft-antispam-prvs: <MR1P264MB232444C6F76C5470AEDFC170ED2F9@MR1P264MB2324.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u85I5I+NRAbH5f0XVrcDhspZU3CoH4/eSDeCGVQwLyeHtdZRkM8wibVLeynS6QRkp//KniCpI2+FqqQcCyjXUkgwZ+R7FNQOBGqjeWibrGskY9UQT85Y0vB7Lb3YaAZBam93uEjLfGUm3P23gMORzumI/a41aXrf4t+aLHEhsuW06DLXdn099qg5ViZHTzS1x1pZirZEAXBmG6XbguPlAgeAznfLi11GQhdLzGwioMcEv1A9ZeSh9kpjm98KopG0p4UgzQ571DJsdJ2IFbAgbdkNZV0LBX5r3vQQsL0+qi5lPsR8iaqrtgJUw1hO2uG4VR29tClRlL4y9zkeslca6K/YQ84FkWSiIvlLAc8JNhWji311/efdZF3RHNIdoul+4eWQZwMTI7N+rPDzcxfNN1PLdpUuZM8h32EP2Tucu4palUimqRYKI2OVj40nTAAjZD+Yo0hx44WBfwg3ycCR5ZIROlwsZOE0m2tbUTDre5aD44XMgYseFuhr9sEbL4sbQwFBnWrxQowx6NHoOK2ThEI5nQypKToEjn9RRo/vLBZzsN06UkfCQsHrfeGVIhktBKzorgOYj8MGxlu2/pr0O/iAx8/uTyhUTs7ZiEbrwlcXXZ3deFeFoVDap0THweQ8dhn9IF5aRVKuhRuITchLWe2HCiZeGWjpuvTMTGm9pR2lQcI+B9NP1iUJGWMhSa1bsp7R8vOrX6sUSiYAXTfHxCmNYki9tVDZJMcbgW42vtERDI5d2kdjA9Z+d4RJax7brMVJsOzs0ogEnTiAf53WZA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(508600001)(76116006)(66946007)(26005)(91956017)(31696002)(186003)(6512007)(31686004)(83380400001)(6486002)(38070700005)(54906003)(122000001)(36756003)(2906002)(7416002)(2616005)(71200400001)(44832011)(5660300002)(66476007)(66556008)(66446008)(6506007)(110136005)(38100700002)(66574015)(316002)(4326008)(8936002)(64756008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVpCTklTaXR6VjNPMGlLaXNxMEtmbTNrdVdLeE93U0xYbGdJM2s0MjkrY0RV?=
 =?utf-8?B?TnpxTi81cVJ6QTQzNUhGVmpKcC94RlJhL2hoYUd3VEtSMm81eXJ4eUpHcXZw?=
 =?utf-8?B?U2NPSVFseFRVZC9Palo5TkFjdVJNQ1ZMNG41ZFpyc1VhK0hFS2hLZEs0SEc4?=
 =?utf-8?B?WkJlSk5Pci9icGx1YjcvWXN2T1o1MTdiTy9md1M0UEl5Qzg0MUh0QUJJWVFs?=
 =?utf-8?B?Q3FUa3lUazMxOWhjbXVwMjBBVWVlUi82V1lRK3B6c2FLakpONkdHcGhBVzNx?=
 =?utf-8?B?QkFKWnhxSTB4d2ZwdzliMXRQVnFRNEV1c1EwREFsckVuNk1XblBlZDdZemhX?=
 =?utf-8?B?cDdmOTIyek1TUnhzeHNsNkwxYk1aYzhSeVJxeWZWY3FnV3N3aVJOenI4YzA2?=
 =?utf-8?B?QnNyWG1EUGpoU1N3RFNoNFU3OTIwSzRVcGFsRFVDK2ZKN1pSdEQvTlEyajdi?=
 =?utf-8?B?OVFaa1lTQ2U5M1hWamExQy91dDBrVTNZSXNMbVgwOXlGREI2WnN1UFpKT3BP?=
 =?utf-8?B?NWl0RGNxbWhhUjNMek01RFNwM1BHbDhOYkRaTlhUbk9NbGIrS2VYdThjblA4?=
 =?utf-8?B?WkwvQjF1Rkp0VTlIbjh6SFJWeXE3VDdrdGlDaDFOM2pxYmc4a1RyWnhBUzJ3?=
 =?utf-8?B?MXZkenR1WS9WRzU5YU5VbTVPOVJmV2U4UTlLMWtwZUFkbmwySlVqM1RtWnNo?=
 =?utf-8?B?UUFWd216dGUwNjZ4Uzk2S1F0WURtQXdobW56UVk3QnJPVllhM0JvcGZHbEYx?=
 =?utf-8?B?aUVkTlRzeFFzZ1d1Z1VFWmh5eU9Vd3ByNUpJaitUbjNWNm8wc09oVjhQMzhS?=
 =?utf-8?B?VCtDY0ZJS013bEc3T1hnYmpkVHpCV3k2ckg1QmJ6Q0RLWjFVdDdCNjcyaWMy?=
 =?utf-8?B?c0pwcHRveTY0cnFwd1B2QjhhS25uSE9QQlhKZ3kyZ0xZQzZxZENhUDdlV0N3?=
 =?utf-8?B?TGhMMFFzNjVpWWFrV2pUYXlZV2NCUVdDTm5FeGRWb1daYmxmSUpuaGVRcjR6?=
 =?utf-8?B?clBhRzA3R3FnRFg1bDdVMkhJU3VFeHVEdHlHT3FlZUFLdnJYbXlSd1lJV0tG?=
 =?utf-8?B?MFJicG4zK3pGTzMrOFptcWg2ZFI0YnJVN25xOHlTTHFnamt0bHd6cmpuR2t1?=
 =?utf-8?B?Rmo2RlRxeGwwZWtacllZcVhCMlJsUGlwNlNvYm9WR1ZkbFQrY0ppN2ZuL0tN?=
 =?utf-8?B?WDNQRWh0Q0dIK3ZQVUVrcGdxN3RaZ3dURXBhQ09yempHOWd0SjU0VDhsM2hX?=
 =?utf-8?B?UXJMMThaam9KT3BYWi9Hak10V2hZQVBWUHg3aWhZMTVqZVI4ZFZUT3g5Mk1L?=
 =?utf-8?B?NDY5UUZkelJnWCtRMnFqbGxEbFBVYzl6cVE3bmpXR1dKR0tiR0QvcW9TL0wr?=
 =?utf-8?B?VUkwSGxoUWNJNllXN29iVU9tR2JhRnZIeE8wM2FVTWNmUUExMFZKQnAwL0Ex?=
 =?utf-8?B?NUZ0WlNocm0xSjcvWjNSMHFJVFVldWkxOWZuMk1rUDNXQ09yY0s2OE5MeTRa?=
 =?utf-8?B?Q1NwNXp4N0ljOXFMOU5iL0JkYzhsenl2NTV1S1lNYUhDczk2R2tSV2hMSHFa?=
 =?utf-8?B?R2ZweUljOHl6U0lER0FxL1NGenNTSHJqT042M2ttNXhzSXR6SkcxNGg1b0cv?=
 =?utf-8?B?L0k1NjRzb3dHVDFYcGliT0dmelBrUXpqd3pEY2lIN1VuUkt5cGxzSlI5TDVG?=
 =?utf-8?B?amtOMk5SOC9ZNHBIdll3N2J6cEZWMHpjZjZpN3YrbkNib21wYm9VenQwcTlj?=
 =?utf-8?B?SUFCYzJ3cDdkR3lSeFEzR2h3SXFHbm8xeXV4eG5tTzQzdVpiWC9XOTk4ZHZN?=
 =?utf-8?B?c0hreld6a3NpMzQvUVQ2eDZqVUsxUmtoNXo0Q0k5dWYxZmowd1VGUFRWaXh1?=
 =?utf-8?B?WnJCcjVyNjhtNGduNlFWTGxPalBuWGk0SEFtaVRLaUVPelN2TlNVYVplRnpY?=
 =?utf-8?B?aXRCbnJMOXlSbkE2cVNWaGxOVDY4ZjBpdGNiQUE0S2QvRjlIejFNL3JBNVhh?=
 =?utf-8?B?TlV4L0taclYyNDd2MmJ2aDNqYzRMbC91aTUycXZjQkJkNU1kVmtNU0JTVm1P?=
 =?utf-8?B?aS9CK2hLZlk2ZU1lSkxISVhWK21NNlF3S2E1SlpMSmdtNXNmZXUvQXhRR0tR?=
 =?utf-8?B?OFJGd3BHKzlsOHV3NnNzSlRaY1ArbmhCT2JrVmZQUWc3c1F1UjFEZW1XRmF1?=
 =?utf-8?B?UStXQjRHNnZkdkxSZEF5VUVvc0JuVy94eDR5KzhpLy9uemZ0Q3V1SkJDNjZi?=
 =?utf-8?Q?bdDLL8/3N0j5xOflLnZBHMNofFF6RM++uZyJcenGqk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8BAED338C2F63C43A33444BA763D7E9C@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a6d0abc9-9aa4-4653-4fff-08d9ec8ac022
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 11:44:52.1586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /vG4hw3ENSiuGNurze0mFdf5+FR7baTy1WxJ1nMDpy6FZF0GYyySnYvoIpFUWuyFqAzFwnMuvHNKboFfMZ6To9wEtsLy1v5fQq5BF4X0PQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB2324
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDA5LzAyLzIwMjIgw6AgMTg6MDMsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBO
byBmdW5jdGlvbmFsIGNoYW5nZS4NCj4gDQo+IFRoaXMgcGF0Y2ggbWlncmF0ZXMgbGl2ZXBhdGNo
IHN1cHBvcnQgKGkuZS4gdXNlZCBkdXJpbmcgbW9kdWxlDQo+IGFkZC9vciBsb2FkIGFuZCByZW1v
dmUvb3IgZGVsZXRpb24pIGZyb20gY29yZSBtb2R1bGUgY29kZSBpbnRvDQo+IGtlcm5lbC9tb2R1
bGUvbGl2ZXBhdGNoLmMuIEF0IHRoZSBtb21lbnQgaXQgY29udGFpbnMgY29kZSB0bw0KPiBwZXJz
aXN0IEVsZiBpbmZvcm1hdGlvbiBhYm91dCBhIGdpdmVuIGxpdmVwYXRjaCBtb2R1bGUsIG9ubHku
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBBYXJvbiBUb21saW4gPGF0b21saW5AcmVkaGF0LmNvbT4N
Cj4gLS0tDQo+ICAgaW5jbHVkZS9saW51eC9tb2R1bGUuaCAgICB8ICAgNSArLQ0KPiAgIGtlcm5l
bC9tb2R1bGUvTWFrZWZpbGUgICAgfCAgIDMgKysNCj4gICBrZXJuZWwvbW9kdWxlL2ludGVybmFs
LmggIHwgIDE4ICsrKysrKysNCj4gICBrZXJuZWwvbW9kdWxlL2xpdmVwYXRjaC5jIHwgIDgwICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiAgIGtlcm5lbC9tb2R1bGUvbWFpbi5jICAg
ICAgfCAxMDIgKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gICA1IGZp
bGVzIGNoYW5nZWQsIDExMiBpbnNlcnRpb25zKCspLCA5NiBkZWxldGlvbnMoLSkNCj4gICBjcmVh
dGUgbW9kZSAxMDA2NDQga2VybmVsL21vZHVsZS9saXZlcGF0Y2guYw0KPiANCj4gZGlmZiAtLWdp
dCBhL2luY2x1ZGUvbGludXgvbW9kdWxlLmggYi9pbmNsdWRlL2xpbnV4L21vZHVsZS5oDQo+IGlu
ZGV4IDFlMTM1ZmQ1YzA3Ni4uNjgwYjMxZmY1N2ZhIDEwMDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xp
bnV4L21vZHVsZS5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvbW9kdWxlLmgNCj4gQEAgLTY2NCwx
MCArNjY0LDcgQEAgc3RhdGljIGlubGluZSBib29sIG1vZHVsZV9yZXF1ZXN0ZWRfYXN5bmNfcHJv
YmluZyhzdHJ1Y3QgbW9kdWxlICptb2R1bGUpDQo+ICAgfQ0KPiAgIA0KPiAgICNpZmRlZiBDT05G
SUdfTElWRVBBVENIDQo+IC1zdGF0aWMgaW5saW5lIGJvb2wgaXNfbGl2ZXBhdGNoX21vZHVsZShz
dHJ1Y3QgbW9kdWxlICptb2QpDQo+IC17DQo+IC0JcmV0dXJuIG1vZC0+a2xwOw0KPiAtfQ0KPiAr
Ym9vbCBpc19saXZlcGF0Y2hfbW9kdWxlKHN0cnVjdCBtb2R1bGUgKm1vZCk7DQoNClRoaXMgY2hh
bmdlIGlzIHdyb25nLCBidWlsZCBmYWlscyB3aXRoIGl0IGJlY2F1c2UgaXNfbGl2ZXBhdGNoX21v
ZHVsZSgpIA0KaXMgbm93aGVyZSBkZWZpbmVkLg0KDQpZb3UgY291bGQgbW92ZSBpc19saXZlcGF0
Y2hfbW9kdWxlKCkgdG8gaW5jbHVkZS9saW51eC9saXZlcGF0Y2guaCBidXQgYXMgDQphIHNlcGFy
YXRlIHBhdGNoLg0KDQo+ICAgI2Vsc2UgLyogIUNPTkZJR19MSVZFUEFUQ0ggKi8NCj4gICBzdGF0
aWMgaW5saW5lIGJvb2wgaXNfbGl2ZXBhdGNoX21vZHVsZShzdHJ1Y3QgbW9kdWxlICptb2QpDQo+
ICAgew0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL21vZHVsZS9NYWtlZmlsZSBiL2tlcm5lbC9tb2R1
bGUvTWFrZWZpbGUNCj4gaW5kZXggMjkwMmZjN2QwZWYxLi5lZTIwZDg2NGFkMTkgMTAwNjQ0DQo+
IC0tLSBhL2tlcm5lbC9tb2R1bGUvTWFrZWZpbGUNCj4gKysrIGIva2VybmVsL21vZHVsZS9NYWtl
ZmlsZQ0KPiBAQCAtNywzICs3LDYgQEAgb2JqLSQoQ09ORklHX01PRFVMRVMpICs9IG1haW4ubw0K
PiAgIG9iai0kKENPTkZJR19NT0RVTEVfREVDT01QUkVTUykgKz0gZGVjb21wcmVzcy5vDQo+ICAg
b2JqLSQoQ09ORklHX01PRFVMRV9TSUcpICs9IHNpZ25pbmcubw0KPiAgIG9iai0kKENPTkZJR19N
T0RVTEVfU0lHX0ZPUk1BVCkgKz0gc2lnbmF0dXJlLm8NCj4gK2lmZGVmIENPTkZJR19NT0RVTEVT
DQoNCkNPTkZJR19MSVZFUEFUQ0ggZGVwZW5kcyBvbiBDT05GSUdfTU9EVUxFUyBzbyB0aGlzIGlm
ZGVmIGlzIG5vdCBuZWVkZWQgDQooU2VlIGtlcm5lbC9saXZlcGF0Y2gvS2NvbmZpZykNCg0KPiAr
b2JqLSQoQ09ORklHX0xJVkVQQVRDSCkgKz0gbGl2ZXBhdGNoLm8NCj4gK2VuZGlmDQo+IGRpZmYg
LS1naXQgYS9rZXJuZWwvbW9kdWxlL2ludGVybmFsLmggYi9rZXJuZWwvbW9kdWxlL2ludGVybmFs
LmgNCj4gaW5kZXggMWNmNWQ2ZGFiYzk3Li5kMjUyZTBhZjFjNTQgMTAwNjQ0DQo+IC0tLSBhL2tl
cm5lbC9tb2R1bGUvaW50ZXJuYWwuaA0KPiArKysgYi9rZXJuZWwvbW9kdWxlL2ludGVybmFsLmgN
Cj4gQEAgLTU4LDYgKzU4LDI0IEBAIHN0cnVjdCBsb2FkX2luZm8gew0KPiAgIA0KPiAgIGludCBt
b2RfdmVyaWZ5X3NpZyhjb25zdCB2b2lkICptb2QsIHN0cnVjdCBsb2FkX2luZm8gKmluZm8pOw0K
PiAgIA0KPiArI2lmZGVmIENPTkZJR19MSVZFUEFUQ0gNCj4gK2ludCBjb3B5X21vZHVsZV9lbGYo
c3RydWN0IG1vZHVsZSAqbW9kLCBzdHJ1Y3QgbG9hZF9pbmZvICppbmZvKTsNCj4gK3ZvaWQgZnJl
ZV9tb2R1bGVfZWxmKHN0cnVjdCBtb2R1bGUgKm1vZCk7DQo+ICtib29sIHNldF9saXZlcGF0Y2hf
bW9kdWxlKHN0cnVjdCBtb2R1bGUgKm1vZCk7DQo+ICsjZWxzZSAvKiAhQ09ORklHX0xJVkVQQVRD
SCAqLw0KPiArc3RhdGljIGlubGluZSBpbnQgY29weV9tb2R1bGVfZWxmKHN0cnVjdCBtb2R1bGUg
Km1vZCwgc3RydWN0IGxvYWRfaW5mbyAqaW5mbykNCj4gK3sNCj4gKwlyZXR1cm4gMDsNCj4gK30N
Cj4gKw0KPiArc3RhdGljIGlubGluZSBib29sIHNldF9saXZlcGF0Y2hfbW9kdWxlKHN0cnVjdCBt
b2R1bGUgKm1vZCkNCj4gK3sNCj4gKwlyZXR1cm4gZmFsc2U7DQo+ICt9DQo+ICsNCj4gK3N0YXRp
YyBpbmxpbmUgdm9pZCBmcmVlX21vZHVsZV9lbGYoc3RydWN0IG1vZHVsZSAqbW9kKSB7IH0NCj4g
KyNlbmRpZiAvKiBDT05GSUdfTElWRVBBVENIICovDQo+ICsNCj4gICAjaWZkZWYgQ09ORklHX01P
RFVMRV9ERUNPTVBSRVNTDQo+ICAgaW50IG1vZHVsZV9kZWNvbXByZXNzKHN0cnVjdCBsb2FkX2lu
Zm8gKmluZm8sIGNvbnN0IHZvaWQgKmJ1Ziwgc2l6ZV90IHNpemUpOw0KPiAgIHZvaWQgbW9kdWxl
X2RlY29tcHJlc3NfY2xlYW51cChzdHJ1Y3QgbG9hZF9pbmZvICppbmZvKTsNCj4gZGlmZiAtLWdp
dCBhL2tlcm5lbC9tb2R1bGUvbGl2ZXBhdGNoLmMgYi9rZXJuZWwvbW9kdWxlL2xpdmVwYXRjaC5j
DQo+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+IGluZGV4IDAwMDAwMDAwMDAwMC4uN2U5Y2Y1MzBj
M2YwDQo+IC0tLSAvZGV2L251bGwNCj4gKysrIGIva2VybmVsL21vZHVsZS9saXZlcGF0Y2guYw0K
DQpDaGVja3BhdGNoIHJlcG9ydHMgdGhlIGZvbGxvd2luZzoNCg0KV0FSTklORzogYWRkZWQsIG1v
dmVkIG9yIGRlbGV0ZWQgZmlsZShzKSwgZG9lcyBNQUlOVEFJTkVSUyBuZWVkIHVwZGF0aW5nPw0K
IzgwOg0KbmV3IGZpbGUgbW9kZSAxMDA2NDQNCg0KQ0hFQ0s6IENvbXBhcmlzb24gdG8gTlVMTCBj
b3VsZCBiZSB3cml0dGVuICIhbW9kLT5rbHBfaW5mbyINCiMxMDk6IEZJTEU6IGtlcm5lbC9tb2R1
bGUvbGl2ZXBhdGNoLmM6MjU6DQorCWlmIChtb2QtPmtscF9pbmZvID09IE5VTEwpDQoNCkNIRUNL
OiBDb21wYXJpc29uIHRvIE5VTEwgY291bGQgYmUgd3JpdHRlbiAiIW1vZC0+a2xwX2luZm8tPnNl
Y2hkcnMiDQojMTE5OiBGSUxFOiBrZXJuZWwvbW9kdWxlL2xpdmVwYXRjaC5jOjM1Og0KKwlpZiAo
bW9kLT5rbHBfaW5mby0+c2VjaGRycyA9PSBOVUxMKSB7DQoNCkNIRUNLOiBDb21wYXJpc29uIHRv
IE5VTEwgY291bGQgYmUgd3JpdHRlbiAiIW1vZC0+a2xwX2luZm8tPnNlY3N0cmluZ3MiDQojMTI3
OiBGSUxFOiBrZXJuZWwvbW9kdWxlL2xpdmVwYXRjaC5jOjQzOg0KKwlpZiAobW9kLT5rbHBfaW5m
by0+c2Vjc3RyaW5ncyA9PSBOVUxMKSB7DQoNCkNIRUNLOiBObyBzcGFjZSBpcyBuZWNlc3Nhcnkg
YWZ0ZXIgYSBjYXN0DQojMTQyOiBGSUxFOiBrZXJuZWwvbW9kdWxlL2xpdmVwYXRjaC5jOjU4Og0K
Kwltb2QtPmtscF9pbmZvLT5zZWNoZHJzW3N5bW5keF0uc2hfYWRkciA9ICh1bnNpZ25lZCBsb25n
KSANCm1vZC0+Y29yZV9rYWxsc3ltcy5zeW10YWI7DQoNCg0KPiAraW5saW5lIGJvb2wgc2V0X2xp
dmVwYXRjaF9tb2R1bGUoc3RydWN0IG1vZHVsZSAqbW9kKQ0KDQonaW5saW5lJyBrZXl3b3JkIGlz
IHBvaW50bGVzcyBoZXJlLCBhcyBmYXIgYXMgdGhpcyBmdW5jdGlvbiBpcyBpbiBhIC5jIA0KYW5k
IGlzIG5vdCBzdGF0aWMsIGl0IHdvbid0IGJlIGlubGluZWQuDQoNCkdpdmVuIGhvdyBzaW1wbGUg
dGhpcyBmdW5jdGlvbiBpcywgaXQgc2hvdWxkIGJlIGEgJ3N0YXRpYyBpbmxpbmUnIGluIA0KaW50
ZXJuYWwuYw0KDQo+ICt7DQo+ICsJbW9kLT5rbHAgPSB0cnVlOw0KPiArCXJldHVybiB0cnVlOw0K
PiArfQ0KDQoNCg0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL21vZHVsZS9tYWluLmMgYi9rZXJuZWwv
bW9kdWxlL21haW4uYw0KPiBpbmRleCA3NTBlM2FkMjg2NzkuLjVmNWJkNzE1MmI1NSAxMDA2NDQN
Cj4gLS0tIGEva2VybmVsL21vZHVsZS9tYWluLmMNCj4gKysrIGIva2VybmVsL21vZHVsZS9tYWlu
LmMNCg0KPiBAQCAtMzA5MSwzMCArMzAxNiwyMyBAQCBzdGF0aWMgaW50IGNvcHlfY2h1bmtlZF9m
cm9tX3VzZXIodm9pZCAqZHN0LCBjb25zdCB2b2lkIF9fdXNlciAqdXNyYywgdW5zaWduZWQgbA0K
PiAgIAlyZXR1cm4gMDsNCj4gICB9DQo+ICAgDQo+IC0jaWZkZWYgQ09ORklHX0xJVkVQQVRDSA0K
PiAgIHN0YXRpYyBpbnQgY2hlY2tfbW9kaW5mb19saXZlcGF0Y2goc3RydWN0IG1vZHVsZSAqbW9k
LCBzdHJ1Y3QgbG9hZF9pbmZvICppbmZvKQ0KPiAgIHsNCj4gLQlpZiAoZ2V0X21vZGluZm8oaW5m
bywgImxpdmVwYXRjaCIpKSB7DQo+IC0JCW1vZC0+a2xwID0gdHJ1ZTsNCj4gKwlpZiAoIWdldF9t
b2RpbmZvKGluZm8sICJsaXZlcGF0Y2giKSkNCj4gKwkJLyogTm90aGluZyBtb3JlIHRvIGRvICov
DQo+ICsJCXJldHVybiAwOw0KPiArDQo+ICsJaWYgKHNldF9saXZlcGF0Y2hfbW9kdWxlKG1vZCkp
IHsNCj4gICAJCWFkZF90YWludF9tb2R1bGUobW9kLCBUQUlOVF9MSVZFUEFUQ0gsIExPQ0tERVBf
U1RJTExfT0spOw0KPiAgIAkJcHJfbm90aWNlX29uY2UoIiVzOiB0YWludGluZyBrZXJuZWwgd2l0
aCBUQUlOVF9MSVZFUEFUQ0hcbiIsDQo+IC0JCQkgICAgICAgbW9kLT5uYW1lKTsNCj4gLQl9DQo+
IC0NCj4gLQlyZXR1cm4gMDsNCj4gLX0NCj4gLSNlbHNlIC8qICFDT05GSUdfTElWRVBBVENIICov
DQo+IC1zdGF0aWMgaW50IGNoZWNrX21vZGluZm9fbGl2ZXBhdGNoKHN0cnVjdCBtb2R1bGUgKm1v
ZCwgc3RydWN0IGxvYWRfaW5mbyAqaW5mbykNCj4gLXsNCj4gLQlpZiAoZ2V0X21vZGluZm8oaW5m
bywgImxpdmVwYXRjaCIpKSB7DQo+IC0JCXByX2VycigiJXM6IG1vZHVsZSBpcyBtYXJrZWQgYXMg
bGl2ZXBhdGNoIG1vZHVsZSwgYnV0IGxpdmVwYXRjaCBzdXBwb3J0IGlzIGRpc2FibGVkIiwNCj4g
LQkJICAgICAgIG1vZC0+bmFtZSk7DQo+IC0JCXJldHVybiAtRU5PRVhFQzsNCj4gKwkJCQltb2Qt
Pm5hbWUpOw0KDQpUaGlzIGNoYW5nZSBzZWVtcyB3cm9uZywgbW9kLT5uYW1lIG11c3QgcmVtYWlu
IGFsaWduZWQgdG8gb3BlbiBwYXJlbnRoZXNpcy4NCg0KDQo+ICsJCXJldHVybiAwOw0KPiAgIAl9
DQo+ICAgDQo+IC0JcmV0dXJuIDA7DQo+ICsJcHJfZXJyKCIlczogbW9kdWxlIGlzIG1hcmtlZCBh
cyBsaXZlcGF0Y2ggbW9kdWxlLCBidXQgbGl2ZXBhdGNoIHN1cHBvcnQgaXMgZGlzYWJsZWQiLA0K
PiArCQltb2QtPm5hbWUpOw0KDQpDSEVDSzogQWxpZ25tZW50IHNob3VsZCBtYXRjaCBvcGVuIHBh
cmVudGhlc2lzDQojMjg1OiBGSUxFOiBrZXJuZWwvbW9kdWxlL21haW4uYzozMDMzOg0KKwlwcl9l
cnIoIiVzOiBtb2R1bGUgaXMgbWFya2VkIGFzIGxpdmVwYXRjaCBtb2R1bGUsIGJ1dCBsaXZlcGF0
Y2ggDQpzdXBwb3J0IGlzIGRpc2FibGVkIiwNCisJCW1vZC0+bmFtZSk7DQoNCj4gKwlyZXR1cm4g
LUVOT0VYRUM7DQo+ICAgfQ0KPiAtI2VuZGlmIC8qIENPTkZJR19MSVZFUEFUQ0ggKi8NCj4gICAN
Cj4gICBzdGF0aWMgdm9pZCBjaGVja19tb2RpbmZvX3JldHBvbGluZShzdHJ1Y3QgbW9kdWxlICpt
b2QsIHN0cnVjdCBsb2FkX2luZm8gKmluZm8pDQo+ICAgew==
