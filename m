Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A45A4AC73D
	for <lists+live-patching@lfdr.de>; Mon,  7 Feb 2022 18:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235668AbiBGRZi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 7 Feb 2022 12:25:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358420AbiBGRRl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 7 Feb 2022 12:17:41 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120058.outbound.protection.outlook.com [40.107.12.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5D6C0401E0;
        Mon,  7 Feb 2022 09:17:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvsAnM77d6vUbAWMr6VRaNPWCqGzi4z4rKDAgVf1wR3yT4T4n7xWFHGOZ+1nzyUbeYAN1HcWzSps5hGUPO5sYGQKXznDlQVKrMX31ipEhHqH9m2PmiC1ORhgfLzMtNbat/tRFH1k6cArF+218qw7vydzU6RX5l39yJdk076bYu1zGveVRTIDT6/N2bqvpsKepDqHtz37nM47OPaDLC3K/vivQ3a1f011gAjqx3a8UKjty7DXLZ6Jh6vwOdceY/U9/MScPrRsuddfnMtsJbzYWF4zGC7jyAzpMfqi5AuXVqtyi1Uooo3qEVCBURVRb46tsPcul6AS57988AS872gyiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YBBUbW6w5GlrOX3NM7Fiqnrx+0pf7b0VuPzioxzHAjg=;
 b=ZmsP3dEUuI6KhK+39g4S0IPmq8OC1V1kjhaKH20QRdEq1w9IUszQF4L3t0NrKQ3JbWElAaDX3SuaAx7jb9M8Y/7A1NHXMrg65v3Qbuz+hcx5CWrmWulH2RTWhGUttfGW9gKoHCMOhJ+8KRK4U2/VAi3/oeMJR0M1/GRMBIxycuFdQuxpL/S9b5VdfQl1NAAZYP5MZpvEW1MWOhdfSBm1BGVSG8ZQ3nPRKMPhz6/+2IkNdrUY3QhLxfHfd8uL9j3U1/uyfXdsFhMhwDWiLarPdl6GVDdLFzRBBAAqi2ebIyJYTKrCa8E1W/ptl2YHwuI0ZZ/vkh4nrHpsEh29zFaBtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3d::7) by
 PR0P264MB3128.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1d7::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Mon, 7 Feb 2022 17:17:35 +0000
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::1927:fecc:c58a:ad42]) by MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::1927:fecc:c58a:ad42%3]) with mapi id 15.20.4951.018; Mon, 7 Feb 2022
 17:17:35 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Aaron Tomlin <atomlin@atomlin.com>
CC:     Luis Chamberlain <mcgrof@kernel.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Michal Suchanek <msuchanek@suse.de>,
        "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "void@manifault.com" <void@manifault.com>,
        "joe@perches.com" <joe@perches.com>
Subject: Re: [RFC PATCH v4 00/13] module: core code clean up
Thread-Topic: [RFC PATCH v4 00/13] module: core code clean up
Thread-Index: AQHYGJPj0SgwpYxqsU+2qmwMGXXo0qyCHvGAgAY0jICAAAiMAA==
Date:   Mon, 7 Feb 2022 17:17:35 +0000
Message-ID: <b0a54f00-b9ac-df55-e8d2-d3eb95039a95@csgroup.eu>
References: <20220130213214.1042497-1-atomlin@redhat.com>
 <Yfsf2SGELhQ71Ovo@bombadil.infradead.org>
 <1ae3a950-8c1e-a212-e557-8f112a16457d@csgroup.eu>
 <20220207164659.ap42at2nphxu4q6o@ava.usersys.com>
In-Reply-To: <20220207164659.ap42at2nphxu4q6o@ava.usersys.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f3dff3f-3679-4d12-a1e0-08d9ea5dbbcd
x-ms-traffictypediagnostic: PR0P264MB3128:EE_
x-microsoft-antispam-prvs: <PR0P264MB3128BD8CE780A4B06927DCC5ED2C9@PR0P264MB3128.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WXj4DiJWfLDO1Ccb/yEY6nyDBYr//WvuLV+HE+Stx7zp1MN4Z2GkFUhXQcqR+Rud+6g/h96PM3wO2VRdw/0SavqqPCK4vUpDXR59OLo1v/vXBWJVI+GJoQhjM7QE65sZ61x0JFWmh1phn+uTV9WuriLX7WBs6rU74YI544xqR1Nbrxy62RDdMSIF53KJO2BW9eARlK34bdjfojqgx5MlnEu6PIddUejHym49RY/04D55s9NBjY8k01zac2WdAqQpj5lO9kzfyAtlX6bZER+fmhj5+z7m6eLKaKueXrt2e3EHr3WMA8rYBd8oE80tUHWDv9/2TN6Uoe4pcMA/Evh4K+QrbCHhjgzyPBSZ5rxmXLapWHm95Pk8nnaLAdQH3P3me6mNRpZ5ywyZ2ozMyKIQ9Gc4PjK8/rLdwzprF+h6EIwlHHgB4OiwU3DK6oPtgElE6oK6ODXUVEt/PnnIxKDasL2DAl4D2DHcEt+VZ4ek1yVDlNQ71N+TzwZycQCBvfCvT+Qk423CuCS50ilOLzSp2zmp44EzjG5B9BNEcudSrxWVRAmxORSfBaf35pHv7zxWRWTGL9M0836hDupC8dwMuejmgtCmrI9jHP7HRQiB0yVtCDu+o967bBt/dvLwTBGPzUTRMp/68W1GOZkLI7Zn0hP32kaNFQdoiCZLfSABb6hBRpHQD+puoE/gLtchx6ho/paTF9Ov9YOxAyFmxNaK59PUgzvrq0hSXBoxbvh9IexPfOkXziSwK0/NpoQswZmFhoWi3IWHIQIPKjhMZHqZ4sCHz+wE3xgHhqa0640dlrVPU8xA1RTtOODl03R/s6zFgZ9P91tc1ATU4YXzl0NzY3HQxiwUySUzGNi0vNlmtlU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(8936002)(66556008)(4326008)(66446008)(64756008)(66476007)(91956017)(31686004)(8676002)(36756003)(508600001)(6486002)(966005)(26005)(54906003)(6506007)(86362001)(31696002)(6512007)(5660300002)(38070700005)(38100700002)(44832011)(122000001)(7416002)(76116006)(66946007)(6916009)(2906002)(71200400001)(316002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2pMc0JNeXo1QlRzQk9KYjBGZEVZNzdHcEMrTDdNL2ttU0JBT0xNWVMwQjQ4?=
 =?utf-8?B?c1hzZnp6ZFJMemhXNHB2RzdLc0w0dVVNWnpDQUhKTXRraWM2MWp5S2Fac2Na?=
 =?utf-8?B?MGtEZWwyaHlEWWhYY0JiWGdCRmxKVDFaeFRqZEZwRFByOVIzNER4OXE0MWU3?=
 =?utf-8?B?dDZHNEFaL05ZN3ByaGZPczNzZkd4V2JsVGYvVmM3TFlGUmZPSFBuWEMyL2Nx?=
 =?utf-8?B?YUM5N1F3T0syZllvSVg0MHdpNFpSTW0xL0pmUCsxeFJJVy9ERDF2SllKcUls?=
 =?utf-8?B?NjdoMUoxVFVJMjgvemYyUVBocGRlNTJYSUdQanBMRXROUDVIMGNGV0hEWkI2?=
 =?utf-8?B?NWFocTJUK3VIUHpZOWEvT2tpL1N2R01KbG04MitDc2p4RTV2dmtWTE85UFJ4?=
 =?utf-8?B?VnJxczUrMkk4dVFiMmpMSE1XK0NEWlRKeTFjdFBPRmVYQndzbW9teDZvTGFX?=
 =?utf-8?B?OGZuTHIrcEo3L2pLQWxza25nTVhRSDV2cnBUMnBvY3hFd1lCSWphNjFJT3dw?=
 =?utf-8?B?TXk1SFE5MTZyVWI4NE5aN3I5RUZDekFjRTBUVmhkNjkzM0lhYzNRNnBnT3hS?=
 =?utf-8?B?UURjcnZFTWJsTjZOd3JFbjMvZUwzRlp1ejJZakdmQ3NJWEduMDVFb0ZZYjls?=
 =?utf-8?B?MTFhV09qTzBpTjBQN1ZrRFEwdlEwRUZ0Y3lzcGlGQ2hXTS8zenpCU21aZ2ZV?=
 =?utf-8?B?QVFJNWZUb3VKWkZhQmduNURxUHRUQnM3T3VqU2RuZHZNd1c4OXpDNHorTU96?=
 =?utf-8?B?cGlMWTd6SXRxNk5yb1F1Qjg2S3AvUEZQMHRyN2ppT0Y1RGZSamxBNFhDUlJk?=
 =?utf-8?B?b1d1RE15cFRrRFMwZ3FzVnJiOW5GOXo0eUdvaW9pSXJWZFA1MGtvYzJqSGlG?=
 =?utf-8?B?Q2xHQ3V1dTVZUzRlTGhPZUJHUUJNZGtnZDBQTEVRMHJZRFZlK21RaFNvWUZU?=
 =?utf-8?B?RzRJaytNOUNjcjB1cm5RU0R3aTBJMURRMUFLZ2RDTjczaytoTk1DVERZRjcz?=
 =?utf-8?B?UTRncXJKYWN4T210Z0lTTDFGZDMzSGlFR3pHWGh3bEl4ZVZFUnhidG9ONTBV?=
 =?utf-8?B?Y1p3ODFiUDl3b04zdWRZRnFtZnI3VGJHZStBNFB4ajBHYURZN2tydWVvck9k?=
 =?utf-8?B?OU9kOEtPWnVrQitPZHhLbjdOQXJLczQ0czNRWXhuaTJRdEZUVmpnbFBoVzdt?=
 =?utf-8?B?a0NIcFlGV3NDRnR3bDFnUXJXaUVDMlZQUDc5K2JpMld5eHN6a0tQK1ZHQ3BL?=
 =?utf-8?B?dENvNjd5OXJQMktkNlpKTmFuN0N1ZWYwVjdocGhNWmVVUHViVjJGYWZSNkVO?=
 =?utf-8?B?aklsRWVOMUQ5WThoRlNRQ2xKMnlMcVY1L2owMVRPbmJvUEx3aXBLeWJNZVhB?=
 =?utf-8?B?Z3Q4Ni82K0RFWTBNN2tvZnIrZEVETjFkS0dYK1IyZlNCc0d1aktkdW92M1RS?=
 =?utf-8?B?d0lDbkxWTFphM1BOOThlNVh1Ukt1TjZzTHlkSDZvVW1xbXlRb2F4VTF2bExB?=
 =?utf-8?B?V3ZQTEJtN1o5ODgxUThzZTJ4UVBidUl5dEQ5NGZ3bHlTUGFIYmJPSlU1NjNl?=
 =?utf-8?B?TFZpZkt0Y1VhbjdsdzBJRnB5TU1zemU3TURDMnR1OTNqbUtqYlV6aSs5SCth?=
 =?utf-8?B?M0grUEh3RjNTaVJ1ZktFd0V1R2txQVBlMHNpWThBU1FQbkpZczFZSWg0WXIx?=
 =?utf-8?B?bWxabHhDN3BHc0tCdkFRQjZuRnpObzVVd3BXSEwxaGZFYVkzOUtnQnlybmNM?=
 =?utf-8?B?MzZ5ZUNyY2FZRTFIL1NVdElFN0swK1QzNTFNZ1BFTFlPL0FHQVhDWWwrbkkw?=
 =?utf-8?B?U2tzcWV6ZUVGMWRMVjhHMEJUTlhzT3VZNi9sT2ZLUzdRZGt1eEJQdERsdlhr?=
 =?utf-8?B?bFVzek9tZWpkT3IybE4rRzVXaVZzRDIxbDgwMS9zcVFRRnBKRDhKeTFkTlZO?=
 =?utf-8?B?UVZ4ejRDRWQxU1JLOFRhUE13aC9OcmhTV3FSbXpPY3dwd1hZNTh4eU1jUWVZ?=
 =?utf-8?B?czRWKzdIcWVQVDQ4UWFiYllyWTlqZngvOEpYSHNQVzNIazVEZ3NER0VkVklV?=
 =?utf-8?B?aEpGb09lZDhLQmdoYVA1em15SmQxUUlNaktkV3dESHJzSjdnRjlUeVo4UlBs?=
 =?utf-8?B?OTVTcjRUcnE2S3N6ZXNrMVhqeEVIT09IR1dJbTU5UmZxbCtML2JHNDdHTFBw?=
 =?utf-8?B?QXI5a3RNRG96dmpSb1ByMkFCR1c1cE1JT2srTm8xWWxXYU43bmJuYW5wUVpB?=
 =?utf-8?Q?iZ/JSA0W9TzTwtK2boKVzpRAlkAXObRvzDn3YG6ZTs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C08746AA71B56409AC780B5DC9A5783@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f3dff3f-3679-4d12-a1e0-08d9ea5dbbcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2022 17:17:35.2528
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H4F50mGQYAzGkCFg/LL6w3MdpirUkVj9eu0I7DJDZZoJnGCDO71kpfzQeldRITm53XWE/ejPqH59+NnI/5aj+eJKDXFNLYNs1FgPdHmEvWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB3128
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDA3LzAyLzIwMjIgw6AgMTc6NDYsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBP
biBUaHUgMjAyMi0wMi0wMyAxODowMSArMDAwMCwgQ2hyaXN0b3BoZSBMZXJveSB3cm90ZToNCj4+
IEkgZG9uJ3Qga25vdyBleGFjdGx5IHdoYXQgd2FzIHRoZSBtb3RpdmF0aW9uIGZvciBjb21taXQg
OTM2NTFmODBkY2I2DQo+PiAoIm1vZHVsZXM6IGZpeCBjb21waWxlIGVycm9yIGlmIGRvbid0IGhh
dmUgc3RyaWN0IG1vZHVsZSByd3giKSBhdCB0aGUNCj4+IGZpcnN0IHBsYWNlIGJ1dCBpdCBpcyBq
dXN0IHdyb25nIGFuZCB3ZSBzaG91bGQgZml4IGl0Lg0KPiANCj4gQ2hyaXN0b3BoZSwNCj4gDQo+
IEkgdGhpbmsgd2UgYXJlIGluIGFncmVlbWVudC4gSWYgSSB1bmRlcnN0YW5kIGNvcnJlY3RseSwg
aXQgc2hvdWxkIG5vdCBiZQ0KPiBwb3NzaWJsZSB0byBlbmFibGUgQ09ORklHX1NUUklDVF9NT0RV
TEVfUldYIHdpdGhvdXQNCj4gQ09ORklHX0FSQ0hfSEFTX1NUUklDVF9NT0RVTEVfUldYIChvciBp
bnZlcnNlbHkpLCBhcyBwZXIgYXJjaC9LY29uZmlnOg0KPiANCj4gICAgY29uZmlnIFNUUklDVF9N
T0RVTEVfUldYDQo+IAkgIGJvb2wgIlNldCBsb2FkYWJsZSBrZXJuZWwgbW9kdWxlIGRhdGEgYXMg
TlggYW5kIHRleHQgYXMgUk8iIGlmIEFSQ0hfT1BUSU9OQUxfS0VSTkVMX1JXWA0KPiAJICBkZXBl
bmRzIG9uIEFSQ0hfSEFTX1NUUklDVF9NT0RVTEVfUldYICYmIE1PRFVMRVMNCj4gCSAgZGVmYXVs
dCAhQVJDSF9PUFRJT05BTF9LRVJORUxfUldYIHx8IEFSQ0hfT1BUSU9OQUxfS0VSTkVMX1JXWF9E
RUZBVUxUDQo+IA0KPiBUaGUgb2JqZWN0aXZlIG9mIExpbnVzJyBjb21taXQgYWQyMWZjNGZhYTJh
MSAoImFyY2g6IE1vdmUNCj4gQ09ORklHX0RFQlVHX1JPREFUQSBhbmQgQ09ORklHX1NFVF9NT0RV
TEVfUk9OWCB0byBiZSBjb21tb24iKSBhbmQgaW4NCj4gcGFydGljdWxhciBjb21taXQgMGY1YmY2
ZDBhZmU0YiAoImFyY2g6IFJlbmFtZSBDT05GSUdfREVCVUdfUk9EQVRBIGFuZA0KPiBDT05GSUdf
REVCVUdfTU9EVUxFX1JPTlgiKSBkb2VzIHNlZW0gY29ycmVjdC4gU28sIGFyY2hpdGVjdHVyZXMg
dGhhdCB3b3VsZA0KPiBwcmVmZXIgdG8gbWFrZSB0aGlzIGZlYXR1cmUgc2VsZWN0YWJsZSByYXRo
ZXIgdGhhbiBlbmFibGVkIGJ5IGRlZmF1bHQNCj4gc2hvdWxkIGNvbnRpbnVlIHRvIGhhdmUgdGhp
cyBvcHRpb24uDQo+IA0KPj4gbW9kdWxlX2VuYWJsZV94KCkgc2hvdWxkIHdvcmsganVzdCBmaW5l
IHJlZ2FyZGxlc3Mgb2YNCj4+IENPTkZJR19BUkNIX0hBU19TVFJJQ1RfTU9EVUxFX1JXWC4NCj4g
DQo+IEFzIHBlciB0aGUgYWJvdmUsIHdlIHNob3VsZCBmaXggY29tbWl0IDkzNjUxZjgwZGNiNiAo
Im1vZHVsZXM6IGZpeCBjb21waWxlDQo+IGVycm9yIGlmIGRvbid0IGhhdmUgc3RyaWN0IG1vZHVs
ZSByd3giKSBzbyBhIHN0dWIgZm9yIG1vZHVsZV9lbmFibGVfeCgpDQo+IHdvdWxkIG5vIGxvbmdl
ciBiZSByZXF1aXJlZCwgcmlnaHQ/DQo+IA0KDQpZZXMgYW5kIHRoYXQncyB0aGUgcHVycG9zZSBv
ZiB0aGUgcGF0Y2ggSSBwcm9wb3NlZCBhdCANCmh0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcv
cHJvamVjdC9saW51eC1tb2R1bGVzL3BhdGNoLzIwMzM0ODgwNWM5YWM5ODUxZDg5MzlkMTVjYjk4
MDJlZjA0N2I1ZTIuMTY0MzkxOTc1OC5naXQuY2hyaXN0b3BoZS5sZXJveUBjc2dyb3VwLmV1Lw0K
DQpBbGx0aG91Z2ggSSBuZWVkIHRvIGZpbmQgb3V0IHdoYXQncyB0aGUgcHJvYmxlbSByZXBvcnRl
ZCBieSB0aGUgcm9ib3QuDQoNCkFzIHN1Z2dlc3RlZCBieSBMdWlzLCB0aGlzIGZpeCBzaG91bGQg
Z28gb25jZSBhbGwgb25nb2luZyB3b3JrIGlzIGRvbmUuIA0KQnV0IGl0IHdvdWxkIGJlIG5pY2Ug
aWYgeW91IGNvdWxkIGp1c3QgcmVtb3ZlIHBhdGNoIDUgZnJvbSB5b3Ugc2VyaWVzLCANCm90aGVy
d2lzZSB3ZSB3b3VsZCBoYXZlIHRvIHJldmVydCBpdCBsYXRlci4NCg0KVGhhbmtzDQpDaHJpc3Rv
cGhl
