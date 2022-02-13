Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274F54B3CDA
	for <lists+live-patching@lfdr.de>; Sun, 13 Feb 2022 19:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237800AbiBMS3t (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 13 Feb 2022 13:29:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235339AbiBMS3t (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 13 Feb 2022 13:29:49 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120041.outbound.protection.outlook.com [40.107.12.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2992D575F2;
        Sun, 13 Feb 2022 10:29:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYKbyHtHm0i5hscvCrXDqkO2jmGGxcP/eeQ7rAQB47mgbR46XSa7pepR2T9pQF2zbaHaCLtFSmV3c97rfYg+xYl/NDTsskg/g8jHOMOdZ0M5bG6hRbm7J8zZuDW60xsgsJr4jrf7NNvRsLYT2JEw+SpT34CF3gkNDxBr1HKRqIHKZigY+tMndmhJmcgAMnV5mU89NbE5o+G/cZb+InPqRV+p54IYBy8ZjgGkyjHNMkak2BJqdfm9Xzhca3YA9bz6+a4eUU0xdoWDsJPtPKTiY9Rh/YwXTJ7Vkt7DFMk8a1Pf9tIhCOVlyQqucfBRb+QVifBcnXYmYm2QKK5njTumRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yk4ODn7CW5o8US2sfVuQuhiNeq5ZwmaVxy9cU175PWk=;
 b=diB7M+St/I/EwKKlShWMcWsInmHZTA6AOvTEfXO1SAyOp7dP3dKbUjJoNOZc5yYrAgxE4OzuhWoUIlC5MP4yOlQTXO7yhWi3uQOldITifz1N6HedCVsJpI8lQ6RZwraec/miFWND+KQfdo0TUBSOT/1FLCisNVML+Nr1SYLH0xyewKeKGmtHeju0F4qv77YIXWNrtdjd4+JytKNSyo14lSmspfip5HulYKuwJglhpU6DqlJVdvzJhCLzsr3xqJUi2r9Jl530qjoSaKB+MOY+ZE1lGFjRhJsPt0oIzZ8YLAa77YS76zbbbUQ400Z8n6rEg9xlljnu4nJQiw16NX9iIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3d::7) by
 PR2P264MB0525.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101:2::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.11; Sun, 13 Feb 2022 18:29:39 +0000
Received: from MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::3d8b:a9b5:c4cc:8123]) by MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
 ([fe80::3d8b:a9b5:c4cc:8123%6]) with mapi id 15.20.4975.015; Sun, 13 Feb 2022
 18:29:39 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Aaron Tomlin <atomlin@redhat.com>
CC:     "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "cl@linux.com" <cl@linux.com>,
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
Subject: Re: [PATCH v5 13/13] module: Move version support into a separate
 file
Thread-Topic: [PATCH v5 13/13] module: Move version support into a separate
 file
Thread-Index: AQHYHdgTxacpqtiy80KvpiF8QXDq16yM2SEAgATzOQCAAAdHgA==
Date:   Sun, 13 Feb 2022 18:29:39 +0000
Message-ID: <d3d87e3e-e13f-252a-1c06-f18a78af5d98@csgroup.eu>
References: <20220209171118.3269581-1-atomlin@redhat.com>
 <20220209171118.3269581-3-atomlin@redhat.com>
 <14a1678f-0c56-1237-c5c7-4ca1bac4b42a@csgroup.eu>
 <CANfR36gVY+1k7YJy0fn1z+mGv-LqEmZJSvSHXn_BFR4WC+oJrQ@mail.gmail.com>
In-Reply-To: <CANfR36gVY+1k7YJy0fn1z+mGv-LqEmZJSvSHXn_BFR4WC+oJrQ@mail.gmail.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec992470-ee2c-4494-0b6e-08d9ef1ecbcd
x-ms-traffictypediagnostic: PR2P264MB0525:EE_
x-microsoft-antispam-prvs: <PR2P264MB052526120B591A111EBDCBE7ED329@PR2P264MB0525.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:655;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gOrAw7CVpfb81q+fL0LDtT6xj8nxFrMtop98bkgtv5KlVa7q+6HUiTLeLAS/AO+JDbuJaCJs1uL78rSdiZq6K82ut+uXQiLwAxmA3er6nRFnJmA8x8X0AlEEJbHwC8g2kpmCHZ9/ZCMG1gjnny7d2EdlerHLF538TuhkRjpdAe6Y3SSHetfHkbsDHnIKVUxfVgwp9KpQlhf3ZRGzGS7nCjzqBR2iTfX1zAlM8z5LyOAHvPMJEhiKbRTAUjjvFOM8JyNLvGceDJqlvgQIlybz0ZoUc7NqC5Io+09BPhmBwLF+C5dJoDBgKkRINvSQmp57fcKWiWbvdmtb3Ni1oak/hBuozAXq3Lg0T9odRy6Qu6isCGcHAo293PxRViZZjU5OWOLrbyF3Hd7mCIAm99T63wIMR7RZaUG57OpMldwbXbF3Kxf09Se5bosK7YCZj7MVKIlkFj/13QPx9N4Y5P30FW2kGiHn1GUQiei3FWfvx47K2z9zFQ4paYm+zH7GSniGuA9ntCUhi/t7p6OkVk/+pZpziOBFppNSsrgKHGDOYb83+dKfnud5IyRjIkDncYsblD+x8UNFzNtru/c0KGz6drUyk1pSRQaB04xtqdRkxOX/yCo4i3rHkpFpta1bWocpziDi4LtN+xhDLkslXfBKZzvZIUHA5vy+lBI3mhCSX/+O+raFCMhcdA6TFsPBqMb9zqySLtN0uPtXz5nM9+wlHfLFqQDlxvN8y6ekj1WXYBwNZVMAmm7+bNV/p0Hc9/TFR7DPaUVoa+T01ZOXXUSHcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(38070700005)(38100700002)(36756003)(7416002)(66574015)(8676002)(8936002)(4326008)(6506007)(6512007)(44832011)(122000001)(5660300002)(2906002)(6486002)(66556008)(91956017)(83380400001)(2616005)(71200400001)(66476007)(6916009)(54906003)(508600001)(26005)(316002)(66946007)(66446008)(31696002)(76116006)(64756008)(186003)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OVJiaGZFbDBrMTdSb2VpL1V2QTRZdWxEV2swejY0MFdydFE0NFAxdkJROVEy?=
 =?utf-8?B?ejhua0drOHBRYm5CQWY4NjNxQ2EvVFZBRjY5cGVWemk2MXJiRmhRZ2QxWThU?=
 =?utf-8?B?REVmVHFoVFArYlZVS1dwYTRXSnNicG1RMGRnak44eUZIVmZ6dTFCbmtwMGVa?=
 =?utf-8?B?OWZicDZaNzFWMzFWYjNvc3BZQ3AvWGJBUmZaK2RMRUF6VTdzUmZ6VWJGRnpo?=
 =?utf-8?B?RmR0TnB5RkZuWDlxdFE0T0ozZ1hZR2xPZ0ZWNUFKSTE4cUxuYzk4VHJwWlhF?=
 =?utf-8?B?T2NqYzdYTTBuR0kyZmdPNFRQeldqaFVYQUNXT05uYXdMVmh5VUdoSVFmempp?=
 =?utf-8?B?dHZsaExrbjFuUndzVFQ3dGhEV2JRQ3pBc3Y0MFFYNUtHY3RRc1hUQ1lCUDFB?=
 =?utf-8?B?QlIvTzNDclcweUNTcWlGWGkwN1NicWZYNEdBWGU2SGk1OUh2UFkrV1ptc2xo?=
 =?utf-8?B?T25zYStXSDlVZVUzVTZKdFl0empnaDZkOWYrUDdSTWxKMGRTQXlPdTdLNy9M?=
 =?utf-8?B?UWhOZ0lyTnRMUUZOdzIwajRpUVlNNjdiUWNXTm54aDBGL3FEdUZmRHN0TkQ5?=
 =?utf-8?B?RVllbHE4ZVFZSmtSNkZ4OWNpdTBabnkrTVJ4anZLMkVwa1BZem9EZUNhZ0Vn?=
 =?utf-8?B?TjVid0V1ZEttQzFqZTAxSkFUWllhWnJJZkU4R2xVMzhYOXBXZ3BXN1BNM1ph?=
 =?utf-8?B?R0UyRXdlbUNONmVBMG1DR1RheFZHNk1OTkJkZmhTaGtWSWtHTUZXK2s1U1Qz?=
 =?utf-8?B?S1p5bHZ4SnRRaHJzVFpIQkpUaFhwNWc0Y2pjRTdIMWVPeFl1TkhyTXVnWTlE?=
 =?utf-8?B?RnUza00yazVneDRJSmpzZWlRSGpmakIvYlFzdzhRWWFXQ0MyV0hDaVRmS1ZS?=
 =?utf-8?B?SG51dmt4aFJFQ1dyQU42VVNSS2dEendqZ2JTS2pnTENyVjc2TUFUYjVkMlVh?=
 =?utf-8?B?TkdWOEtzSnBoZVBjZEFRZzdTbGZSa0hjWVpCeTlpdUZqU1JXT2FUOU84UDZG?=
 =?utf-8?B?REg1YVV6eGY1N0d0a3k5aXJ0WE9yQUxrYzVMaUVHNkthVW5IdlFuK0dFS2gx?=
 =?utf-8?B?SDd1L3JNck44Z1RwcXpjbnkrRGlsVGdsN0VZTnVsLzA0enZ6VTFhdGhDeWlQ?=
 =?utf-8?B?Q2huQzYya3dsZFYwN0ljcXAxdmN4R01TaW9xZUgvTlYvbDlRTlp6K0xJWlFQ?=
 =?utf-8?B?M1VSQlVZV3ZzS2NTUUJCdWFSTHVXVXJ4d1dzRXhueG1rOVMvaDhaY2ZRUVNr?=
 =?utf-8?B?bjJsWUJncTJabDBkOWdWTnB3ZEtWWkQvVURTRWozazRVRGVjQTR4cDRTSVhG?=
 =?utf-8?B?dWRTQjlLQWtDcXlSWlhEcWJRRUp6YjBveWFyY2V0citsT0xtVDNqTTg4SlJR?=
 =?utf-8?B?aUxWZHhTTk82ZmFJMUpBTDZPVTFwOWh1UTR5aHdKM1Q4bG5RZFNQVUJtUlJV?=
 =?utf-8?B?dSt6Y2MxNHk3WGdTWm1zaEpiLy9melk0aFdnOGtVYjhjU3RDUkhUZFpjVkU4?=
 =?utf-8?B?TVpGL2NnajVtVXdjYzJFL2pHNnRPNEEvc2UwTkhJWWpwbEdNemFwaUpoL0tp?=
 =?utf-8?B?QWkyaVJjazlNNHVPbzFiWFlNZHlZUytFbmsxYXBXa251c040Mm1UNmFkaXM1?=
 =?utf-8?B?YmxGb0FTdVIzRU5nTUZNNG5iMlgvL1ZWdjhGZVRVRjFyVXdNdkZNWHRxdWd3?=
 =?utf-8?B?QkFMSSs2eEMwbXBpZUVOY09RT1ZqQk15QUUvampuU3RQZFNXc2srL0FlRXdB?=
 =?utf-8?B?cWl1ZjlVbFhDaUFpa2ZHT3AxWmtBSGxiSTJTeWpodFRpNm5LQ3VrMjdZYTIv?=
 =?utf-8?B?OWVSendJOHlOc3FKRE5BWTNvWlRJZkJJQjRWcWx5NU5JclVOU1RRSmp5b1M5?=
 =?utf-8?B?ZHBPMDVDL2JvZnBSTklCZWlRamZNYjUvWkRYODhWK0JwTUNuN01Ta1ZWdEt4?=
 =?utf-8?B?Rk9nUUZQUDNsSjZUUXZjNmZUWUM1NEtrREVTeE1yaThlTmdNS3BSbi9XMTNE?=
 =?utf-8?B?SUQwWG8xVkc2M2M4NGFkVkNpNVF2VFJrZEtsTVJHMDZCVmJ2ZTZyb3RWcStW?=
 =?utf-8?B?eUM5c01hZjU4NVo0TFhRM3BjMU1ZdDBaZVJuRW1ac25Nem1WaW9NaitUcTNk?=
 =?utf-8?B?NFViU2IwQXZOanJmN1ZGVnU0VEhsTGttZUVYZXRQMnh1L0M4OXBnN2F3YWR0?=
 =?utf-8?B?SitFUzRNYTdyMzhTQUFMZE5PV3NNSWpGTEpiNEcvN1BwelhuZ3dNWGh1a2hq?=
 =?utf-8?Q?PD4S4MZAW3+yeui7RbKjjCqTzh9LmqtX3NjYKJbiow=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ABE7645032AF9E47AE274C81D074E526@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MR1P264MB2980.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ec992470-ee2c-4494-0b6e-08d9ef1ecbcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2022 18:29:39.6124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mjHdeVU2aStiKpR6N2f1YShyUZFMQtVhj1hJvi2J0S4VN5xODfjS0GOp9PuVndnX4AmFfRSbR4wP0VPOfNwp7pP4p5QZw6cjHMK7WzA47Vw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2P264MB0525
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDEzLzAyLzIwMjIgw6AgMTk6MDMsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBP
biBUaHUgMjAyMi0wMi0xMCAxNDoyOCArMDAwMCwgQ2hyaXN0b3BoZSBMZXJveSB3cm90ZToNCj4+
DQo+Pg0KPj4gTGUgMDkvMDIvMjAyMiDDoCAxODoxMSwgQWFyb24gVG9tbGluIGEgw6ljcml0IDoN
Cj4+PiBObyBmdW5jdGlvbmFsIGNoYW5nZS4NCj4+Pg0KPj4+IFRoaXMgcGF0Y2ggbWlncmF0ZXMg
bW9kdWxlIHZlcnNpb24gc3VwcG9ydCBvdXQgb2YgY29yZSBjb2RlIGludG8NCj4+PiBrZXJuZWwv
bW9kdWxlL3ZlcnNpb24uYy4gSW4gYWRkaXRpb24gc2ltcGxlIGNvZGUgcmVmYWN0b3JpbmcgdG8N
Cj4+PiBtYWtlIHRoaXMgcG9zc2libGUuDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBBYXJvbiBU
b21saW4gPGF0b21saW5AcmVkaGF0LmNvbT4NCj4+PiAtLS0NCj4+PiAgICBrZXJuZWwvbW9kdWxl
L01ha2VmaWxlICAgfCAgIDEgKw0KPj4+ICAgIGtlcm5lbC9tb2R1bGUvaW50ZXJuYWwuaCB8ICA1
MCArKysrKysrKysrKysrDQo+Pj4gICAga2VybmVsL21vZHVsZS9tYWluLmMgICAgIHwgMTUwICst
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPj4+ICAgIGtlcm5lbC9tb2R1
bGUvdmVyc2lvbi5jICB8IDExMCArKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+Pj4gICAg
NCBmaWxlcyBjaGFuZ2VkLCAxNjMgaW5zZXJ0aW9ucygrKSwgMTQ4IGRlbGV0aW9ucygtKQ0KPj4+
ICAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBrZXJuZWwvbW9kdWxlL3ZlcnNpb24uYw0KPj4NCj4+IFNw
YXJzZSByZXBvcnRzOg0KPj4NCj4+ICAgICBDSEVDSyAgIGtlcm5lbC9tb2R1bGUvdmVyc2lvbi5j
DQo+PiBrZXJuZWwvbW9kdWxlL3ZlcnNpb24uYzoxMDM6Njogd2FybmluZzogc3ltYm9sICdtb2R1
bGVfbGF5b3V0JyB3YXMgbm90DQo+PiBkZWNsYXJlZC4gU2hvdWxkIGl0IGJlIHN0YXRpYz8NCj4g
DQo+IFRoZSBmdW5jdGlvbiBtb2R1bGVfbGF5b3V0KCkgZG9lcyBub3QgYXBwZWFyIHRvIGJlIHVz
ZWQuIFNvLCBJJ3ZlIGRlY2lkZWQNCj4gdG8gcmVtb3ZlIGl0Lg0KDQpJJ20gbm90IHN1cmUgeW91
IGNhbiBkbyB0aGF0Lg0KDQogRnJvbSBjb21taXQgOGM4ZWY0MmFlZThmICgibW9kdWxlOiBpbmNs
dWRlIG90aGVyIHN0cnVjdHVyZXMgaW4gbW9kdWxlIA0KdmVyc2lvbiBjaGVjayIpIEkgdW5kZXJz
dGFuZCB0aGF0IG1vZHVsZV9sYXlvdXQgaXMgdGhlcmUgZm9yIHNvbWUgc2lnbmF0dXJlLg0KDQoN
Cj4gDQo+PiBDaGVja3BhdGNoOg0KPj4NCj4+ICAgICAgdG90YWw6IDAgZXJyb3JzLCAyIHdhcm5p
bmdzLCAzIGNoZWNrcywgMzM3IGxpbmVzIGNoZWNrZWQNCj4gDQo+IE9rLg0KPiANCj4+PiArc3Ry
dWN0IHN5bXNlYXJjaCB7DQo+Pj4gKyAgICBjb25zdCBzdHJ1Y3Qga2VybmVsX3N5bWJvbCAqc3Rh
cnQsICpzdG9wOw0KPj4+ICsgICAgY29uc3QgczMyICpjcmNzOw0KPj4+ICsgICAgZW51bSBtb2Rf
bGljZW5zZSB7DQo+Pj4gKyAgICAgICAgTk9UX0dQTF9PTkxZLA0KPj4+ICsgICAgICAgIEdQTF9P
TkxZLA0KPj4+ICsgICAgfSBsaWNlbnNlOw0KPj4+ICt9Ow0KPj4NCj4+IFdoeSBkb24ndCBsZWF2
ZSB0aGlzIGluIG1haW4uYyA/DQo+IA0KPiBZZXMsIHN0cnVjdCAnc3ltc2VhcmNoJyBpcyBub3Qg
dXNlZCBvdXRzaWRlIG9mIGtlcm5lbC9tb2R1bGUvbWFpbi5jLg0KPiANCj4+PiAraW5saW5lIGlu
dCBjaGVja19tb2RzdHJ1Y3RfdmVyc2lvbihjb25zdCBzdHJ1Y3QgbG9hZF9pbmZvICppbmZvLA0K
Pj4+ICsgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IG1vZHVsZSAqbW9kKQ0KPj4NCj4+IGlu
bGluZSBpcyBwb2ludGxlc3MgZm9yIGEgbm9uIHN0YXRpYyBmdW5jdGlvbg0KPiANCj4gVGhpcyB3
YXMgYW4gdW5mb3J0dW5hdGUgb3ZlcnNpZ2h0Lg0KPiANCj4+PiAraW5saW5lIGludCBzYW1lX21h
Z2ljKGNvbnN0IGNoYXIgKmFtYWdpYywgY29uc3QgY2hhciAqYm1hZ2ljLA0KPj4+ICsgICAgICAg
ICAgICAgICAgIGJvb2wgaGFzX2NyY3MpDQo+Pg0KPj4gU2FtZSwgbm90IHBvaW50IGZvciBpbmxp
bmUga2V5d29yZCBoZXJlLg0KPiANCj4gQWdyZWVkLg0KPiANCj4gDQo+IEtpbmQgcmVnYXJkcywN
Cj4g
