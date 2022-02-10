Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E81C4B0F8A
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 15:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242506AbiBJOAx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 09:00:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237363AbiBJOAw (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 09:00:52 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90081.outbound.protection.outlook.com [40.107.9.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0A19A;
        Thu, 10 Feb 2022 06:00:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2m0Xrbz5BxQoXeXzI1Vw4WhBoDX/HHt3c0YKBa1IaSosm/lsZ3BgT/3oHaxpbf1XuUWmzQ0sSjF0bQEtmxpN7a9sJAjb4xPcBAqw4Sz3hK0fOE8aX/Um+e0Fly9RZqJ4lAXq+YFZcPXpsSmFflt9/5fFuxG7ezDIKDvAxQ7rtmYj3vOGTATyZyD9OVsZsLrnLqIcwTZ+kuVaFvjzmgHM7AbUkxftUQmZj6GLw+wzrn02FceHRzgyqxylzRESGJSlYhLRPKzYHcoaMq6m/z5R0S+kFWBhS75ouInD1rXL5RbbScVVo+eoxEoJhKIOE8NZaKzY5qACsZLQYWEJSptig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJOPRJOiU3QVtV4BgzP4fuHoG09iJk2Wvr9f5ZYJDfg=;
 b=oPLknJdZOUkMQXsgySJj92qsvRRS6W2fykrer1NkFEzT3wzguyFKsfmGhqEX0oIaL1ssgukzkyFdMrw0/IenciPJXWNbfOyrJHIXI2/pHhYf2n+e/BlzbXXrFHBhJuIYgmYrk/3HnM9ItWycrrgCB/HNZjJv1YObfDYo67WemQ3w0ZghKhenHo4UE9o+iSItshVtaVZNQnzHxdIltIVnDDrn14uIAQxA70Vl0ROKiAEK00J4+hx/uOxUL7tyqisQ6jaGBneJez0VoQOkN1HKNIzNW1lht3UnhoPgNUgKiOqcsTcUr+6yu/wJVIdPaueeYEjpppnds4rcL/q3DpDYiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB2245.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1b1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 14:00:48 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 14:00:48 +0000
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
Subject: Re: [PATCH v5 11/13] module: Move sysfs support into a separate file
Thread-Topic: [PATCH v5 11/13] module: Move sysfs support into a separate file
Thread-Index: AQHYHdgU4FENB3fJsUewH5fYF2RteayM0YSA
Date:   Thu, 10 Feb 2022 14:00:48 +0000
Message-ID: <6d6cbfe4-ee1a-ec5f-4249-c25ab6142668@csgroup.eu>
References: <20220209171118.3269581-1-atomlin@redhat.com>
In-Reply-To: <20220209171118.3269581-1-atomlin@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 593825ea-2b64-433d-bb92-08d9ec9dbd84
x-ms-traffictypediagnostic: PR1P264MB2245:EE_
x-microsoft-antispam-prvs: <PR1P264MB22452C9023A811D72045A386ED2F9@PR1P264MB2245.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V3xjtMcewy5T/9IZM+oPW63tcOpdlzZ8NBIOuO7P96FpmWA16wOWbpdM54d/gos3tBR03omoPsOhQHhhBuY2SislhT3dP4eAzvXf5aZ8t8OgTisrH0u8NQcAm6gQU+wBRgnBIg6Sgsl5O7lcGlFLjvlHQpyPXOymO3/ku6P+yrFWQozlRH6WUZm01yN7GueqZu3RMiGP2kjPznILShlZoauhuNb9x/2wVCL1ZfXmsUcaLw61ILfRv/bOngevRuL8FJG5d9M41SaK7iQVBMc1FeI1o1sEqt9YlzW5PajHz2WkAEcg1gUilSmTmHIx5yzOZ/5rE/q/xyePQzPZiomCPCvVspMDbiHx3uQMLZ9nF/9aFHISbPZkbr7RPa8Sun0o7uxp+d5ndpe5ETlDD1+ipnjI6jHsYND3+j/YtbVhF56D9bNi0uUp149y78YrsGGggWdvlT444Z2Sh65cB54s89FWpxqkaBsD1QZ21amngo9wVfvmZJVrLKAepz+sFVQFqiejRi6chHJM4pmOJWpx0Xe6mfI7z0QrBJ50eg6z7uMzRGEBD84nNCk4WO2TBmH5LowmqZ4DUYwYzIv4iIg3fC0clm1Kjjk5Q4ZeQIpFwCMhMFD8GLrOsj2uyaj4mn9ugiR8hfuPRziLQosTsv3bbmaL5xb3zHKIyDfwXFXvSNThvG84uFXvrwRO+7E9AlN9ncDANyPxFj13HeyuSvLfanNHzLH0C+gnx1GwuBldwUOenef4lWz3voTX1qO1Oeb6K53qT4ll78bssmnUalqgWw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(4326008)(83380400001)(76116006)(38100700002)(26005)(8676002)(44832011)(6512007)(2616005)(6506007)(66946007)(66556008)(36756003)(8936002)(91956017)(64756008)(66446008)(7416002)(54906003)(66574015)(186003)(5660300002)(71200400001)(31686004)(316002)(6486002)(508600001)(86362001)(38070700005)(110136005)(31696002)(122000001)(66476007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YjZZNmlhRW5OR2NLMmJxczFuNzBic2t3QmVRWDI2UURJdDFuNFBqZ0pKOUJK?=
 =?utf-8?B?TG10bHNEbEY2aldqM2luaVhjRS9vc0VpRCt1TitIWHM5V1VPMEJqK3lWbnZn?=
 =?utf-8?B?TXNudTdnUWVCYTU5anNPSmNDNnVISUdqUkY5bENZaVZBbVlFM0cvdE9TRVI1?=
 =?utf-8?B?aFl6SlFMNmtuWlVVSWFXemM0MlRidUdsclY0YTFOYzVXc3RXcUZyM2h1Rklx?=
 =?utf-8?B?aXE3TExjb0FVNGdNNFA0Q1dtWXA3TDU1SGJZUVBkZkdwcGxkdE9EWkpUbDVw?=
 =?utf-8?B?bCs0QjRYcDB2M3ZWUjYraXA4UGRNYW01VUNoMWZscUNpc2VJUEdLZi9tME9y?=
 =?utf-8?B?Yi9BbExjcHF5UFhVVk5pck80K0FsU2haVk0yYzhxaElONkVOQW9CdUErT3BW?=
 =?utf-8?B?WmFkOXBQVTIybm8yQThaTUY0OWsxcEdvM2NyQUhvUHhWNW9KeldxdUsraFY0?=
 =?utf-8?B?ZTJDUk9ZOVpqaFViM3ArTiswYmVNS1pnT3Z3WmFZY2tGelBreWttNmFjR2RB?=
 =?utf-8?B?SEZnUGNkclRtU1ZaUm9EVDJaakE1ZEZPNVY4cjJJSnduaFhqZ1dVdjl4Nk9T?=
 =?utf-8?B?N2krK0pRVDJDN3F4ajhNa0lzQ2FmM0d5Q0FlVmNZaVE2L0xFSWlsTDJ0bXdH?=
 =?utf-8?B?RnltdTBGcWdyQlhYZEY4WTZSQTh5U0w0Q3lHR1lBTDFnVGx2eTFzSXlRVHJ0?=
 =?utf-8?B?T0FqVWlSSW9uRzRoTnNEbW5sZmhDT2JuZ0VNSjlUNnIzRm9XZlZlUGtiZ1VN?=
 =?utf-8?B?aks0TlF6aTREdDBWTUdkNFhTRVhBbnNLa2Fna1RBYWwxbkdWYWNmTHdBQW45?=
 =?utf-8?B?aXo4RTlCS0VxaXhSRzczMHd1TzdBWHFrVDBXQW85TWZGb0VFaGVqdTRZbmRW?=
 =?utf-8?B?eks0dENNcFBMeUhWbXRweGFGemM0Q09Na0ZDT2FMenFORjAwbWwyc2l4eTJD?=
 =?utf-8?B?dHZNcUdHeXRUbE51NVpQaUdJYmxoSkdiRHkyZXNGQWcwWEw3L0JVNXEzemQr?=
 =?utf-8?B?SVp0Q2p2N2RhVlVMZmQyWnlIOC9ucVFHcnNaTkQ0Y0xQNkkzOVdoS2pWY3hl?=
 =?utf-8?B?NnFlVlJLZUFtY3duS0ZHcmZyUXFXQmZqSkNaMlpkUnd6N1lPTUY4T0FkLzJJ?=
 =?utf-8?B?ekFzSTVjNGt4b0o0alp2Q0poYkhiTzN4c0J6aVh2SXlPZ216RjNJa1I3WERn?=
 =?utf-8?B?azFQNVp1RHYxUU5DbDVXVXQwWVdHNjlrcmVNMnEvTzdFT2ZBMTV5RTNKNkxt?=
 =?utf-8?B?akEwSXByRDdoNm1BWTc2U1JrR1hSejVGTU9udmVpMlRncUU4Sm1jR1NjNUox?=
 =?utf-8?B?T1VYU1FUQktwcmNtRS9EUERhZDE3NUUyWjFKWndDajZUbVM1ckQxMGx6dWs3?=
 =?utf-8?B?SEhBZ28ydGpZM2xhNzhvK2U3bEFQMWErNlh4T2N3b1I1b3hKT3ZLcWE1Z2Nq?=
 =?utf-8?B?L1EvVVo1NGZhU2xjS3pLbElxcFdieEpMRmhsSUs1Yy9MbzNUaFM4ZDBFdVV3?=
 =?utf-8?B?bnhPS0NTTFFnZnJCZmVxRmRFOHdvSHF3ZnZoOUZTWEh2NC83b1FoTlBNY0lN?=
 =?utf-8?B?UmVJd3dndDJNMFdRaG9BY0EyK0szMEJwSkp3NEYyWDBNRVFidmgwdStDZFVM?=
 =?utf-8?B?U1hSMGVEemVTNW5pQTBuRkxRb3YzeUhzQUJjZDB0TXp1M01qeTFZL01pQlUx?=
 =?utf-8?B?Y1ZOREJUaC9XTFFHcTFGZGtOazR0QUFuQWVad25lazZ2MlM2UlFjZE4vVXQz?=
 =?utf-8?B?RUhXMEgrMldpTjhTNm5RLzVmMXYwbzZYcjBYQ3l6WTFiak9leWpncENScDRF?=
 =?utf-8?B?bVBKZW9QWlFMTVRHR3RCMkVoeGJNWnJQMWROWk96VlphdDJyYUNBUTRHdG5J?=
 =?utf-8?B?S3pYcWFpajc5cWJEd0JUU2FIamRRM0xZcko4R1dscllGelhFNUJ2WGFLQy9w?=
 =?utf-8?B?eGhyVldzNGlsWWJXdjYwUUMycG5IWlZ0d0V2YXllSDBpUzhYbktzMkFuMUlz?=
 =?utf-8?B?NlFZNVd2M0N4NVFOTTFRd3NKaDZVSTFnVjE1OGxIQk5MeHR2UWVoakFaeEJa?=
 =?utf-8?B?eVN0M3JTK0ZNbGZrVTZDRXpxWUV0ZUZmbGpYWFE3Q2ZjR1lCaHZiVGRqNHR4?=
 =?utf-8?B?NEZEYTFyME1zWEdsbG5MQnM3NDJpUGJMOFJ0ZHJlR3J5SmlRMXBTejhHUmpQ?=
 =?utf-8?B?QzdiVVYzWEQ1Y0lyWGtlbFNKY2M0ckE1ODNvLzRoZnMyNzRERStpdS9KSXZj?=
 =?utf-8?Q?ODC13Lqmh80linMIcyNKJDPyjqxTXNf76tGwqj1PAU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <93DE1B4EC9D7CB46AA70C7161C205C10@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 593825ea-2b64-433d-bb92-08d9ec9dbd84
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 14:00:48.2311
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6YXcpqdNxv5yIX29lQuZseugGSdoTY4Vjt8n9a/9glY8KKYsprbTxRHuz7Oyygu2BXpu2ABoH+exvukhM7sw6wUZDM23QrcEWbG34vj2Hso=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB2245
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDA5LzAyLzIwMjIgw6AgMTg6MTEsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBO
byBmdW5jdGlvbmFsIGNoYW5nZS4NCj4gDQo+IFRoaXMgcGF0Y2ggbWlncmF0ZXMgbW9kdWxlIHN5
c2ZzIHN1cHBvcnQgb3V0IG9mIGNvcmUgY29kZSBpbnRvDQo+IGtlcm5lbC9tb2R1bGUvc3lzZnMu
Yy4gSW4gYWRkaXRpb24gc2ltcGxlIGNvZGUgcmVmYWN0b3JpbmcgdG8NCj4gbWFrZSB0aGlzIHBv
c3NpYmxlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWFyb24gVG9tbGluIDxhdG9tbGluQHJlZGhh
dC5jb20+DQo+IC0tLQ0KPiAgIGtlcm5lbC9tb2R1bGUvTWFrZWZpbGUgICB8ICAgMSArDQo+ICAg
a2VybmVsL21vZHVsZS9pbnRlcm5hbC5oIHwgIDI0ICsrDQo+ICAga2VybmVsL21vZHVsZS9tYWlu
LmMgICAgIHwgNDU4ICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAg
IGtlcm5lbC9tb2R1bGUvc3lzZnMuYyAgICB8IDQyNSArKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysNCj4gICA0IGZpbGVzIGNoYW5nZWQsIDQ1MyBpbnNlcnRpb25zKCspLCA0NTUg
ZGVsZXRpb25zKC0pDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGtlcm5lbC9tb2R1bGUvc3lzZnMu
Yw0KDQpDaGVja3BhdGNoOg0KDQoJdG90YWw6IDAgZXJyb3JzLCAyIHdhcm5pbmdzLCAxMCBjaGVj
a3MsIDk0NiBsaW5lcyBjaGVja2VkDQoNCg0KPiANCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9tb2R1
bGUvTWFrZWZpbGUgYi9rZXJuZWwvbW9kdWxlL01ha2VmaWxlDQo+IGluZGV4IGM2YmUwODA2MDI1
Mi4uYzMwMTQxYzM3ZWIzIDEwMDY0NA0KPiAtLS0gYS9rZXJuZWwvbW9kdWxlL01ha2VmaWxlDQo+
ICsrKyBiL2tlcm5lbC9tb2R1bGUvTWFrZWZpbGUNCj4gQEAgLTE0LDQgKzE0LDUgQEAgb2JqLSQo
Q09ORklHX1NUUklDVF9NT0RVTEVfUldYKSArPSBzdHJpY3Rfcnd4Lm8NCj4gICBvYmotJChDT05G
SUdfREVCVUdfS01FTUxFQUspICs9IGRlYnVnX2ttZW1sZWFrLm8NCj4gICBvYmotJChDT05GSUdf
S0FMTFNZTVMpICs9IGthbGxzeW1zLm8NCj4gICBvYmotJChDT05GSUdfUFJPQ19GUykgKz0gcHJv
Y2ZzLm8NCj4gK29iai0kKENPTkZJR19TWVNGUykgKz0gc3lzZnMubw0KPiAgIGVuZGlmDQo+IGRp
ZmYgLS1naXQgYS9rZXJuZWwvbW9kdWxlL2ludGVybmFsLmggYi9rZXJuZWwvbW9kdWxlL2ludGVy
bmFsLmgNCj4gaW5kZXggYjY3Y2U4MzY3NDZhLi41MmQzMGJmNmQ2YjAgMTAwNjQ0DQo+IC0tLSBh
L2tlcm5lbC9tb2R1bGUvaW50ZXJuYWwuaA0KPiArKysgYi9rZXJuZWwvbW9kdWxlL2ludGVybmFs
LmgNCj4gQEAgLTM1LDYgKzM1LDkgQEANCj4gICBleHRlcm4gc3RydWN0IG11dGV4IG1vZHVsZV9t
dXRleDsNCj4gICBleHRlcm4gc3RydWN0IGxpc3RfaGVhZCBtb2R1bGVzOw0KPiAgIA0KPiArZXh0
ZXJuIHN0cnVjdCBtb2R1bGVfYXR0cmlidXRlICptb2RpbmZvX2F0dHJzW107DQo+ICtleHRlcm4g
c2l6ZV90IG1vZGluZm9fYXR0cnNfY291bnQ7DQoNCkNhbid0IHRoaXMgY29tZSBpbiBzeXNmcy5j
IGFzIHdlbGwgPw0KDQo+ICsNCj4gICAvKiBQcm92aWRlZCBieSB0aGUgbGlua2VyICovDQo+ICAg
ZXh0ZXJuIGNvbnN0IHN0cnVjdCBrZXJuZWxfc3ltYm9sIF9fc3RhcnRfX19rc3ltdGFiW107DQo+
ICAgZXh0ZXJuIGNvbnN0IHN0cnVjdCBrZXJuZWxfc3ltYm9sIF9fc3RvcF9fX2tzeW10YWJbXTsN
Cj4gQEAgLTIwNiwzICsyMDksMjQgQEAgc3RhdGljIGlubGluZSBjaGFyICpmaW5kX2thbGxzeW1z
X3N5bWJvbChzdHJ1Y3QgbW9kdWxlICptb2QsIHVuc2lnbmVkIGxvbmcgYWRkciwNCj4gICAJcmV0
dXJuIE5VTEw7DQo+ICAgfQ0KPiAgICNlbmRpZiAvKiBDT05GSUdfS0FMTFNZTVMgKi8NCj4gKw0K
PiArI2lmZGVmIENPTkZJR19TWVNGUw0KPiAraW50IG1vZF9zeXNmc19zZXR1cChzdHJ1Y3QgbW9k
dWxlICptb2QsIGNvbnN0IHN0cnVjdCBsb2FkX2luZm8gKmluZm8sDQo+ICsJCQkgICBzdHJ1Y3Qg
a2VybmVsX3BhcmFtICprcGFyYW0sIHVuc2lnbmVkIGludCBudW1fcGFyYW1zKTsNCj4gK3ZvaWQg
bW9kX3N5c2ZzX2Zpbmkoc3RydWN0IG1vZHVsZSAqbW9kKTsNCj4gK3ZvaWQgbW9kdWxlX3JlbW92
ZV9tb2RpbmZvX2F0dHJzKHN0cnVjdCBtb2R1bGUgKm1vZCwgaW50IGVuZCk7DQo+ICt2b2lkIGRl
bF91c2FnZV9saW5rcyhzdHJ1Y3QgbW9kdWxlICptb2QpOw0KPiArdm9pZCBpbml0X3BhcmFtX2xv
Y2soc3RydWN0IG1vZHVsZSAqbW9kKTsNCg0KV2h5IGRvbid0IHdlIG1vdmUgbW9kX3N5c2ZzX3Rl
YXJkb3duKCkgaGVyZSBhcyB3ZWxsID8NCg0KSXQgbG9va3Mgc3RyYW5nZSB0byBtb3ZlIG1vZF9z
eXNmc19zZXR1cCgpIGFuZCBub3QgbW9kX3N5c2ZzX3RlYXJkb3duKCkNCg0KPiArI2Vsc2UgLyog
IUNPTkZJR19TWVNGUyAqLw0KPiArc3RhdGljIGludCBtb2Rfc3lzZnNfc2V0dXAoc3RydWN0IG1v
ZHVsZSAqbW9kLA0KPiArCQkJICAgY29uc3Qgc3RydWN0IGxvYWRfaW5mbyAqaW5mbywNCj4gKwkJ
CSAgIHN0cnVjdCBrZXJuZWxfcGFyYW0gKmtwYXJhbSwNCj4gKwkJCSAgIHVuc2lnbmVkIGludCBu
dW1fcGFyYW1zKQ0KPiArew0KPiArCXJldHVybiAwOw0KPiArfQ0KPiArc3RhdGljIGlubGluZSB2
b2lkIG1vZF9zeXNmc19maW5pKHN0cnVjdCBtb2R1bGUgKm1vZCkgeyB9DQo+ICtzdGF0aWMgaW5s
aW5lIHZvaWQgbW9kdWxlX3JlbW92ZV9tb2RpbmZvX2F0dHJzKHN0cnVjdCBtb2R1bGUgKm1vZCwg
aW50IGVuZCkgeyB9DQo+ICtzdGF0aWMgaW5saW5lIHZvaWQgZGVsX3VzYWdlX2xpbmtzKHN0cnVj
dCBtb2R1bGUgKm1vZCkgeyB9DQo+ICtzdGF0aWMgaW5saW5lIHZvaWQgaW5pdF9wYXJhbV9sb2Nr
KHN0cnVjdCBtb2R1bGUgKm1vZCkgeyB9DQo+ICsjZW5kaWYgLyogQ09ORklHX1NZU0ZTICov
