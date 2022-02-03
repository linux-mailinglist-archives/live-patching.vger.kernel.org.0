Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5C24A8B19
	for <lists+live-patching@lfdr.de>; Thu,  3 Feb 2022 19:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243128AbiBCSBZ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Feb 2022 13:01:25 -0500
Received: from mail-eopbgr90050.outbound.protection.outlook.com ([40.107.9.50]:40096
        "EHLO FRA01-MR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230127AbiBCSBY (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Feb 2022 13:01:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSCnBrdRhoZbptdAD9a7nBF1cm8YEnNKZweTQL0LcbedofagXmeUvMwa7dn91fqv4wmWPlrO/A4VQq7yBS1n78738Ro3sUyU/pmzDujVyDnapoVLz+PEm6cD5ZK6Sq7X1F6R7lQ0V+w9l332I+pO8+wPu05GY8CGDjTtfuVa5XyrjPFn0998uWquf/EVCtDd/rag92ZvbzSga9JPDBuq28v2ArtODBrl96HnBHyJrZEwwDFB05mzg78aYv6jeOTHYg/aH9TD9tHLb03S4tVL3llqOdVr461a5hj/1yW4oNeBF9k6BTzAc+8YKk9MwS1+6sFWXI2MUeoGZvjtrEaCmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cEk+m/KUDNFoyBHqkWRjzZNZUFvm5WEDVg3vzxAyoec=;
 b=cj/+pZRYGR75mxhaSHSsilNLYxyHBmvvnsDnTrT+BmxxZXMxOqjgcN5UzqxPrxWMjZbJ7wtJwSEzIQtAs5gqEj4PniDEpVn+AamsxTU8i3MqYZQN2O9H+6LezI0eLVRJ+tbGxnEWjNKUriApP4ujyv/vly5nCKZsQaln1VVx4qqnm2668MKhTZVxfKHO+qgXPaHoIqqgtq7zyH3QsaMf1AWucPVPomA99y0WeHwlnWECRfAqHFnHM2umsvS2S8xDnhdbcFQ8RSQJg+BpIqAGg4tX201VNJlwyznhzqH2urNKMZQtGeg4Ipv3y5hRMCXmBmeuGRQ527zkQL5HZ6uAbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PAYP264MB4375.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:116::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 3 Feb
 2022 18:01:21 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%9]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 18:01:21 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Aaron Tomlin <atomlin@redhat.com>,
        Michal Suchanek <msuchanek@suse.de>
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
        "joe@perches.com" <joe@perches.com>
Subject: Re: [RFC PATCH v4 00/13] module: core code clean up
Thread-Topic: [RFC PATCH v4 00/13] module: core code clean up
Thread-Index: AQHYGJPj0SgwpYxqsU+2qmwMGXXo0qyCHvGA
Date:   Thu, 3 Feb 2022 18:01:21 +0000
Message-ID: <1ae3a950-8c1e-a212-e557-8f112a16457d@csgroup.eu>
References: <20220130213214.1042497-1-atomlin@redhat.com>
 <Yfsf2SGELhQ71Ovo@bombadil.infradead.org>
In-Reply-To: <Yfsf2SGELhQ71Ovo@bombadil.infradead.org>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 064b2eb8-db7d-449a-baf0-08d9e73f2f9a
x-ms-traffictypediagnostic: PAYP264MB4375:EE_
x-microsoft-antispam-prvs: <PAYP264MB43759EF8E7DA1A6AFEEE0BD0ED289@PAYP264MB4375.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DOYhU9A+jFNnz6N4D1OMoYQJBQdNCd4/YDxiavWBNzVpdkYJyqCUaiByYzus9V1JfP+UUqCi2m0l8LVAet8AXeIr1c1NN75WOK2bRTIyCB/YH9p6CDZmGL7eh2VSh/0y1USyq7+BzsumdKeZ7KgB904cN7fVx57FuuVRYO5x4JlQca5JFS5CG5XdRu+YpXEr0GqzjdrZAygCXUpln1q0nle+d4Y2od1D0rASrxI+rM0gBReJ2HU43BYIjYM2bmQuj+F7kFRcXVO8E3ZoHAjykGyFKnUBEf4u5BbRmVewyJwcpYRENvEE1G8bg42WOA9/mtluQH1MlYsh9xpViGxANq0/6KyLDw3V6d7142lPtAAxO9xNOVxnSlImcnots4tyvOphlEuxzi/ZhXY1BDXWTYhlvItdZF1CZ5eNRe6kiMwecYxFCs5eVu255hxMbdn/L4ZawVDL1r6vSLYtgfgCmP/j8PbMuPRVsEID0A5Q7zCtmdZD7mdpe9NhWgliQlClqTHDT6R6I7HpwxHzw5nHywesszgOZY3ft2mA0WJfkt6aNAyo9pjyNzNMBZIu9OudaJKlsKZz/KY/zXMWQnJXnu6qMiMlPgIKrFXVh+tFUkXes8Q7NGnuQwSyP6i+OXIYZmFvez1pptd4IzJGInRpKb9IrO+qAjVD34nNcaqZ5sjyxKbIijXXUOYKH6+rleMhzrCFTCFXOvsLiRLZJzN+vW3jfORtoA/811qcg3fwec81rhf991XqSHLcOMLqjA+mSM7CjGHX2CL/hRvfYQda2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(38070700005)(122000001)(186003)(66574015)(86362001)(38100700002)(31696002)(8676002)(8936002)(31686004)(66556008)(66476007)(66446008)(4326008)(66946007)(76116006)(110136005)(316002)(54906003)(91956017)(36756003)(5660300002)(2906002)(44832011)(6486002)(508600001)(6506007)(7416002)(6512007)(71200400001)(64756008)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWlKQ3d1citFK3NUc3NKQ2JhWW9zT1ZIOTMwQ2xTdERxZjhYZ01TMnVPQkxW?=
 =?utf-8?B?NFgvN3pjUmowazVGdmZQL0thNUw1RDZZUGs1L1N3aGc1OFQySFlOYnJpa3My?=
 =?utf-8?B?enpxNTBYcUttWG9IM2UzNStrUXQ3KzlXcHJVS3FNc0JGSjVmR0ZTemZvMUxv?=
 =?utf-8?B?OVFrTG5Ob2s1VXpRczZPOGRVMllKQnNIOGFnY2o4cnNETFZFUUVxYUxham1a?=
 =?utf-8?B?RVcxY1JQUFRYR1QzdHJ2SGdObkw2TWgxUkJ3alo5UGRJNUk0b2lnQXBNQkov?=
 =?utf-8?B?M3NHMmFlRWlwU3phU2tDWlFmQ2tFZzMyMnhsVXRjK3RmWlVWb0hrTUlwT21Y?=
 =?utf-8?B?eWZIS2pocmdQZUZIQlZwOTMyQXFqdjFnSWkybWF0VFZ4UmtiVlBmYkt2YS9M?=
 =?utf-8?B?c3hXYVFhQUxmSkhsT21pOU1aQTh6YWZYT0Z3QWxHK3M1aGpvNXY3SmliRm1T?=
 =?utf-8?B?SnJKaFhJZng3THJRMWd0djdKY1puRk4zcWpUbzhrL1A4aDcvZU16SldPckU1?=
 =?utf-8?B?YnVLblAvS2d1dlc2dDRMN2pwRXJaejBocmVUR2tOa0wxM1dkQnViVG0zdWtl?=
 =?utf-8?B?UEowTWM5TENzalBXZWc4M0o5QnRKcU1uZ2NGbGxuVU5OUW9yZ1ZFWlAvN2sy?=
 =?utf-8?B?dVpPN3RjS2VPT0w0WStLRW5PMmtNcXNPU2ZRQzZUc2doTU9paS9GZTR0Sjhp?=
 =?utf-8?B?ZmlUbkY1M0QySEtHYlJNYUFQN2lKNXNHTkwzU2VOWW84WkxLZU41QUpGRjJK?=
 =?utf-8?B?cE8yaUlIQlM2UU1uc2xOa2s0S0NoWlMvUXFvaVJHcHhRaXAvbG1ISkptTVJw?=
 =?utf-8?B?V3puRTErYVVpZnFyOXFmQk90a3pWQlAwbzFrZ3kzMFQrTlpUUGs2WmIrOXhH?=
 =?utf-8?B?ejZya2pHWlBWR1JmUEF2R1oxWWdiS05UUG1TWDRGR0p0QlZ4UEdhSDM0OC95?=
 =?utf-8?B?RE13c2xYTjlHRzl3anV3b3dtZWIvQ1N3eUpyVTBGTDdMNXl1TWxYOXdMaHpV?=
 =?utf-8?B?bE9zc0J0VG5uQmxCdThodFNsK0tlTWd0eDRSUk5PTktSa3dSN0NwYjg5ekww?=
 =?utf-8?B?cXB3WEJIdG4yMDhXMXdKWlc4djg3ck9JbFpBUU5iekU3bklCNlpGT0NzTjcx?=
 =?utf-8?B?akJ2ZlhidDRvZDFBT0tWNk0zNFBxU1ErN3lCZjJOdTgvbmFmSDQveVBJUUEy?=
 =?utf-8?B?NUNwNmpwNDdaR0VZYndKRHVWVDEwazFLZ0hPa3hiMmJJQzJPWkRoWXhNelVF?=
 =?utf-8?B?cDkyV0dJV2prTmdsZ2IzL1BaZnRtSlhuVlQ3SWhnL3Z5UFhRbDVGcmZ4T2pE?=
 =?utf-8?B?SCtBL3ltVHJtSjNjVlprNUVTZzN2NDlQUFRIU1ZtQTFRUGIweWZ6cmJEbEgw?=
 =?utf-8?B?ZDE0cUhKZWExWXBXVDF3VjRWTTRPTmswb3NYK2d3U3hKa2hKNTVFNXRHclJo?=
 =?utf-8?B?a25JSGZ0VitxYnpXMkxTVzdWbUttVktCYUdJNksvdEdGWUh6Y2tFUC9PK3Er?=
 =?utf-8?B?VnVJcXp4V3pZUXRhZE1jeDdQUXZKNnFjNys5YmFqaE5mdnd6QnBsT2VTQUVx?=
 =?utf-8?B?ZFo1YzJzdncrRE1uR01oU3dxQ1FvbUdHZUhtVjlkRi9TeWVidGYwL3diYUEv?=
 =?utf-8?B?MEh5TVZ0aDFieEZPV2twM05DN3VMM0ROYjZDR2x2NFJhT09NRkMvdHBsUWda?=
 =?utf-8?B?M05mSEI1b3BsYThiZnEyU1FZZjRjZ1dPRyt6YnRhMXNqUGxqYmpkMXdXNHhH?=
 =?utf-8?B?eWlEcFZaMjA5U1Njck5xZVMwWXo2T0cwWUNhVkszMVJ5Z0QyZk9nZCs0MTds?=
 =?utf-8?B?RGZGZVVsTTNlMEJlbWtPaVZ6OHpwTEhqNlpBMnZKUEVrTDRUL1NiRS9nQ0d5?=
 =?utf-8?B?ekVjeVlBRStVWmtTSjhNUE5HSDV3d3Y0UXJEZ3creGwySzNwaElCNTNyUGsy?=
 =?utf-8?B?WG5hRTUyUjlIalBPYkhvRzJYUGJvVDRkUndqellXNlpkL0R5S0dBVGEremhV?=
 =?utf-8?B?bENWL1M5MUo1b0JFcjZHbHZ4Z3BOTVhzY0k1ZHZkeTc5TTJGQ0pwa1phNmJO?=
 =?utf-8?B?UFFHOHllVExKbklUYkY3Vzhuc25uVi9ueDl3Ymd6S01aQTM4a1hENlVnUlpx?=
 =?utf-8?B?YTVKWHBGeFNDalB5Z0QvZkVmdlZTNEpkbHRvZGZhWFN0K1JMdzN2bVRkcUoy?=
 =?utf-8?B?Z254OCs2YjVZdDYyRkphc2dJOWowVDduQk9kQkgrSDYrLzRWMmpPWk15MlJs?=
 =?utf-8?Q?Q9iIkX94DEHjguieBdGkY/t2ObGpxEV2/Hwk2OYzP8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <27E6AB1841577B4B81F961A6503F379E@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 064b2eb8-db7d-449a-baf0-08d9e73f2f9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 18:01:21.5709
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0hbyIgEBuWi7SBMT56Zp/Qc2qjnR6rPdhGSdcWrBaFYgCHj3ZcB6A0ykzuQ5ORDEnRVY03KdHNypkZ4St9Uff0Fw6Rm89jfurNqy12T+614=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAYP264MB4375
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDAzLzAyLzIwMjIgw6AgMDE6MjAsIEx1aXMgQ2hhbWJlcmxhaW4gYSDDqWNyaXTCoDoN
Cj4gT24gU3VuLCBKYW4gMzAsIDIwMjIgYXQgMDk6MzI6MDFQTSArMDAwMCwgQWFyb24gVG9tbGlu
IHdyb3RlOg0KPj4gSGkgTHVpcywNCj4+DQo+PiBBcyBwZXIgeW91ciBzdWdnZXN0aW9uIFsxXSwg
dGhpcyBpcyBhbiBhdHRlbXB0IHRvIHJlZmFjdG9yIGFuZCBzcGxpdA0KPj4gb3B0aW9uYWwgY29k
ZSBvdXQgb2YgY29yZSBtb2R1bGUgc3VwcG9ydCBjb2RlIGludG8gc2VwYXJhdGUgY29tcG9uZW50
cy4NCj4+IFRoaXMgdmVyc2lvbiBpcyBiYXNlZCBvbiBicmFuY2ggbWNncm9mL21vZHVsZXMtbmV4
dCBzaW5jZSBhOTdhYzhjYjI0YTMvb3INCj4+IG1vZHVsZXMtNS4xNy1yYzEuIFBsZWFzZSBsZXQg
bWUga25vdyB5b3VyIHRob3VnaHRzLg0KPj4NCj4+IENoYW5nZXMgc2luY2UgdjEgWzJdOg0KPiAN
Cg0KSSBoYXZlIGFub3RoZXIgY29tbWVudDogSSB0aGluayBwYXRjaCA1IHNob3VsZCBiZSBkcm9w
cGVkLg0KDQpIYXZpbmcgc29tZXRoaW5nIGJlaGF2ZSBiYXNlZCBvbiBhIENPTkZJR19BUkNIX0hB
U19TT01FVEhJTkcgaXRlbSBpcyANCndyb25nLiBJdCBpcyBub3QgYmVjYXVzZSBhIHBsYXRlZm9y
bSBzZWxlY3RzIA0KQ09ORklHX0FSQ0hfSEFTX1NUUklDVF9NT0RVTEVfUldYIHRoYXQgdGhlIG1v
ZHVsZSBjb3JlIHNob3VsZCBiZWhhdmUgDQpkaWZmZXJlbnRlbHkgdGhhbiB3aXRoIG90aGVyIHBs
YXRmb3JtcyBhcyBmYXIgYXMgdGhlIHVzZXIgaGFzIG5vdCANCnNlbGVjdGVkIENPTkZJR19TVFJJ
Q1RfTU9EVUxFX1JXWC4NCg0KQW5kIHRoZSB0b3BpYyBoZXJlIGlzIHdyb25nLiBJdCBpcyBhIGNv
aW5jaWRlbmNlIGlmIG1ha2luZyB0aGF0IHN0dWZmIA0KZGVwZW5kIG9uIENPTkZJR19BUkNIX0hB
U19TVFJJQ1RfTU9EVUxFX1JXWCB3b3Jrcy4gVGhpcyBpcyBqdXN0IGJlY2F1c2UgDQp0aGUgb25s
eSBhcmNoaXRlY3R1cmVzIHRoYXQgZG8gdGhlIG1vZHVsZSBhbGxvY2F0aW9uIHdpdGhvdXQgRXhl
YyBmbGFnIA0KYXJlIGFyY2hpdGVjdHVyZXMgdGhhdCBoYXZlIGFsc28gc2VsZWN0ZWQgDQpDT05G
SUdfQVJDSF9IQVNfU1RSSUNUX01PRFVMRV9SV1guIEJ1dCBpdCBzaG91bGQgYWxzbyB3b3JrIG9u
IG90aGVyIA0KYXJjaGl0ZWN0dXJlcy4NCg0KSSBkb24ndCBrbm93IGV4YWN0bHkgd2hhdCB3YXMg
dGhlIG1vdGl2YXRpb24gZm9yIGNvbW1pdCA5MzY1MWY4MGRjYjYgDQooIm1vZHVsZXM6IGZpeCBj
b21waWxlIGVycm9yIGlmIGRvbid0IGhhdmUgc3RyaWN0IG1vZHVsZSByd3giKSBhdCB0aGUgDQpm
aXJzdCBwbGFjZSBidXQgaXQgaXMganVzdCB3cm9uZyBhbmQgd2Ugc2hvdWxkIGZpeCBpdC4NCg0K
bW9kdWxlX2VuYWJsZV94KCkgc2hvdWxkIHdvcmsganVzdCBmaW5lIHJlZ2FyZGxlc3Mgb2YgDQpD
T05GSUdfQVJDSF9IQVNfU1RSSUNUX01PRFVMRV9SV1guDQoNClRoYW5rcw0KQ2hyaXN0b3BoZQ==
