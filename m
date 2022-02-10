Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53384B1061
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 15:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242914AbiBJO2J (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 09:28:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242920AbiBJO2H (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 09:28:07 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90045.outbound.protection.outlook.com [40.107.9.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EC1101;
        Thu, 10 Feb 2022 06:28:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NVALW1qbaLIRp/50ZA8fs6B7kIzTkQSbOHWfMMvwI96P73SNSKTG+fQdkmlzdkZMSfLD2MUbhQh+BiBPSQMlLJbIQxexZq3Oz74mzUYwgbe6wO9SSIS09Sp5dLsmUEqv4qvGASv2G6cuJJe/773yFeYiKSFxB3yYkmdx7X7K57vTziSV/AbdsfiGylFjrx2zHMYDOUDWz3B0SCsrCpyY0Ljpe1ujUnrsmcV+5iX3Lpm78nvCG/vlEnmq1EM7ajcMH7qxaUEPE9v0yxQDf/3nhrurBjtim2NumzSBDPkGbUvzOPYYM8KqdFDTAH+JytESKYkRmzJ0UwT/bQxdG0lf0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pDzKvvKhANdOAB/9lXkF+A9zgyVhOKR+i+HmwK8pQP8=;
 b=Fyc3nyLZFBQZoxCFU9u3Oe/wgmFyXIaj1PRnyBTrPWdIoLjMVrSPcaKeSnXV7F9GGAfXWU4+iuJlaNozYPUUu41YfpSaN8ONFhIotvndd3tbs6ICu1jPbYr8dIDd/0KuiC/kt1z0aM0rQ9DvHkXO2f7KG+rFewminI736U2AV8TaUB5NaMu9XpZkA3uFbM6mS45dfMv0klkXwBXYaUrIM+HraV7inRQlK/XiWeb+OBfmfmKsjvmWCF2oZKPEtvbLG9DkHFx4AnVxsi7nx3tVxTG6KB17y4kQcgTeNHjEhH7LgKALeAqJnQB5+LbQ9+LLj83po98/5nG3fF27Z8mddg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB3963.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:25a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 14:28:03 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 14:28:03 +0000
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
Subject: Re: [PATCH v5 13/13] module: Move version support into a separate
 file
Thread-Topic: [PATCH v5 13/13] module: Move version support into a separate
 file
Thread-Index: AQHYHdgTxacpqtiy80KvpiF8QXDq16yM2SEA
Date:   Thu, 10 Feb 2022 14:28:03 +0000
Message-ID: <14a1678f-0c56-1237-c5c7-4ca1bac4b42a@csgroup.eu>
References: <20220209171118.3269581-1-atomlin@redhat.com>
 <20220209171118.3269581-3-atomlin@redhat.com>
In-Reply-To: <20220209171118.3269581-3-atomlin@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27399f01-1c1f-46db-1eaf-08d9eca18c43
x-ms-traffictypediagnostic: PR0P264MB3963:EE_
x-microsoft-antispam-prvs: <PR0P264MB39638ADDBE9447B865C4B892ED2F9@PR0P264MB3963.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KCg1BgCmECb8Exe3k9JAkcV4sxDiTiVkx16KbugQzBR9+/4iCIGuIdhoR6FPrPt6JLJ13jXD4KZMgTxPpccWSmL2LkO6ikMMtLP0/r6ptFhzppukYAUPDgPLOULknfgOt5xHiB8V/72FP0KCqcJcWU1G9Oha5Mg523gJxQwozv0V4w0eGHTCGaLEua3WlsQ6insjE+Gz6JVvBxQFStnwJVWo4jwsguGItcuFHlf8flPRAuor6b65pHDuduT8B0RvJmkH4dmkL8EyhEojnmdG3mq0P03zCV7e1KdJT+uIK++bO2mxVAY9byTDArrffZAeqIXl4NQwnHmgTKNgpTIww7/DOujVHI9Djzc30qoNJsgde3t8jHo62FAJphKoQCuEUjY+ibDfb73I//qipcHjojbjSKeFsBfL0tnCJtLCiZwFnVNrzv7f337hJy7fd54PiPIGQrEgDopiqfS5DtRrrakAfJK7jAk15/6TabNTzPObx2wwtGQXpwgj1Pu9dUbm6ZqBx90afUzh2YXlnApdKjZ/p47FGfsNZouOlabB7EIVRmM0F4k7P6l9dYpmaqR/NcmhUmylxHgYrLl6z0jBkmXRBa27gfLmue1eUcb2juXzPbBn8/CuVZ+knBOEeBhUXUW2kjCI5kUS4XS/uF5u/7MTiLLxqblgzuyoHNU6pvg15zX0P6CbIjsCA/qLwmXEI6OjvDkFW7rHb/05/wD5oJh6M2R8WaXqdMy5xSzVm6wq+pTQ08/DLIdoWAGzsZZUOmoa+iM7AcNs0WttJWlS0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(6512007)(6506007)(83380400001)(71200400001)(186003)(508600001)(2616005)(66574015)(26005)(6486002)(36756003)(4326008)(91956017)(44832011)(2906002)(7416002)(38100700002)(316002)(8676002)(76116006)(66556008)(54906003)(110136005)(122000001)(31686004)(66946007)(64756008)(66446008)(66476007)(31696002)(5660300002)(86362001)(38070700005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SjhnMDdvaEtEK21MNDZFVklXbW85c0dFUTRWK3BkNGZ0OEt5NVNDUGg4TEhG?=
 =?utf-8?B?ZjIySGgwSDdiQVZxOU01Qncxa1VIM2hPdlM4RkFWdWgvZzBOd29ITVhmMmxk?=
 =?utf-8?B?L0pkUHR0UElSb1dQYXVPaW4rRzBkRVBNV0xHdDdPNFMzTWZ1MUw5NS9tSnh0?=
 =?utf-8?B?U0VFZE1zSnB4NUpJaXFCSHpXVnpudXB5ZjhYbVUyOUl2OXJiZlpRQjRETDlG?=
 =?utf-8?B?WHlhc3BJWkJwRytyekNzSGpENW9PY2hWVFgzN0w3TTN4cXNUSmwyYmZCNVgv?=
 =?utf-8?B?UW9haVpVQW1JSXBxemthZkFZNExueUFWazlIY2lja1VxOG9zZGJLSlZHc3o1?=
 =?utf-8?B?QWsxM2dJV1BBU3puc2NZdVZOaW1DeC9lUEFHR1c0MFk2KzRqbzYwa0s1a05L?=
 =?utf-8?B?RFZaQkJDY1UvbkR0K1h4UUNwajIzR0hnaHlock8yaFFiOU1tbVhIYlNUK0k2?=
 =?utf-8?B?V3pnMjhyVVVkLzd6L0hkZzR1ZThqNGsrZlpzVUJ4bjJ6ZXpVeXNVSG5qdFI5?=
 =?utf-8?B?RTRrZEV4U3JVRVArRTNnd0lhejllT05NdE52eWVCVTB4MWNuQ3RiQkszbW1y?=
 =?utf-8?B?L04zNWxaOWZFU0hiT1IzSVZjeUtURGNvUDNUa0tEcXJCYWZMTjBCUFVGZTY0?=
 =?utf-8?B?TE9ENC9JZjA1Y3NBRWwrN1E1SG5PNUd1T0hlRzY4VXpUMTFTUDFLV01rL3pz?=
 =?utf-8?B?THRkZjdVK09uSUp1bG9peG1BQ3RiYU56WlJTN1FkOG95R1ZmZ2c5S3pnWUI0?=
 =?utf-8?B?QXVwcnlSNko4bStiNklUaTg0WVBPYVFxeUFFRC8xdURCWGIzWk9MLzhhdVFk?=
 =?utf-8?B?eDlnTjFvL0hNVjJPbjBIT05nNjBzTjdXTDk1a2ZDNEVlV0xhbXNET3Q2L0ps?=
 =?utf-8?B?R3ZMdXhqYUtSdWVOOWhUM1RtMnlGNWhGQXR2RW44Rk9lZkZTK3VqSWl2V0ly?=
 =?utf-8?B?M0RuS0JKeXNGaXdOVVErSnRTbVFSdkE4TkxYN3hzR3FVM0ZrVmRQSFR5eExj?=
 =?utf-8?B?UHp4S3hhanNWMVo2Ky9OV29DbDhpaWZjTEU5bGdVOEEzN1l1MUJ4ZDRtU3JN?=
 =?utf-8?B?ZXpENjNyVjQ2dFNIKzhVL2NIbFBMSzJyK0VkU1hCWWo0NkRDV053eFdFbzR5?=
 =?utf-8?B?SzJ3c0JScG9mMFVNSzRJbUQzbks4VDRSekkzZFpaY1hsdDBlSGU0SmpvdHFN?=
 =?utf-8?B?TitROXo2NCtPcVhTNzgya3dpVUpyRmdiSGxtaFZmMDhac3kwNlQ4ZDJNSHZ6?=
 =?utf-8?B?aExzOWMvSGZubnhwNkJubjM1dEF1MFdQd0sxNmJCUjBDbjZ3b2ZhWW01YkFu?=
 =?utf-8?B?N2VLaVJ1eWZzNWo3N3BrdHNsSEJaeVNPaGFUU21OTnNtenBDK1VXS3M0WTkw?=
 =?utf-8?B?SGVHL1Jiak12Y0d6T0hRTFplNG1rVzRDWVd5Y3d3aHVJOXp3eEVKeVZtSkR2?=
 =?utf-8?B?TGg5b1VqbEVqamU3K2ovMGtDM3BJR2ltWXJ6cFhiMzZOenM1QkNYdHAvMExR?=
 =?utf-8?B?TGJSUTVKR3pqbFgyS2kyd3Yyb1JjT2FvaUJxdkg0UlNEaTdjaXgzTC9SeUN6?=
 =?utf-8?B?dWkzVW5lWmVNK1IvWnVHbWFZcThXcmovN0E1SVdaRDd5MzBuVHFQbFNweVQ5?=
 =?utf-8?B?c3QvMEkwQ3ovYU1qeDVJbjdnSWRUYmJkWFFKSnF3UTJLZzRFejFwQi9McHRM?=
 =?utf-8?B?ckZIVWpaV1JlWnI3Q2c5dElMV1FGTWtxeVptRldFWTYzeUdxdHJGNG5NTDNi?=
 =?utf-8?B?aWIzNnNQNE9jcUk3bXp1OHA2djRFY0FEeWlPN0NYMWJBQXA0eG1XLzl0b2lt?=
 =?utf-8?B?MlhnbUZoUHBnWk0zSmhiUzBDYm5YbHQ4TVRyUFVsM1pBTzNGcUdIdW81UGgx?=
 =?utf-8?B?VnZJaHBkclZHQlUrV3M3RHhucXFPYlBuUVhBMnlNcFQ5dFJIbStoQU96R2Yz?=
 =?utf-8?B?ZXB4SjlVcnlNTzZPZ2cvdTFzVmk0Mk9JdGhQMUxhRC9MTGNLTTlBZDYvYXZS?=
 =?utf-8?B?REVDYjBETm5qOTJXcHROaWpxYng5UWUyQ3JnZUdseGVZMldIZmFZN2pHTVVO?=
 =?utf-8?B?a21uMVpTZ2pyQTdQVUxQeDhUenRnbTJaeGwxeFNtbjNoYkYvSnF0akR4RTZF?=
 =?utf-8?B?YUdhOEE2a2Vib0hyZEtGbEtKd29uNFpwbUJMVkc1a0FwM1E3T0JQQ09FbGNy?=
 =?utf-8?B?WFRlQzEvYmZ5OWZxOFA5cDVZZXd5T3dWbmxTVzl6TGdaV2VyWEVHa0VoZXhv?=
 =?utf-8?Q?1HthQ7OMFGm3RRINXcpjAzQeVKBKZAgcN3ROVnnQlE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5EA79BD98B424C4A8B6B500A0867DC28@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 27399f01-1c1f-46db-1eaf-08d9eca18c43
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 14:28:03.5955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iIxeHhfIsSmxH4f+A6Hff8aqtHf79EqC2pLflcjRcupgrzVfTrKzBRUkIv3yV+JyWmT+L+c3BpepD39XKxqyecrocWAQqCFpaloKzwf1dT0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB3963
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDA5LzAyLzIwMjIgw6AgMTg6MTEsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBO
byBmdW5jdGlvbmFsIGNoYW5nZS4NCj4gDQo+IFRoaXMgcGF0Y2ggbWlncmF0ZXMgbW9kdWxlIHZl
cnNpb24gc3VwcG9ydCBvdXQgb2YgY29yZSBjb2RlIGludG8NCj4ga2VybmVsL21vZHVsZS92ZXJz
aW9uLmMuIEluIGFkZGl0aW9uIHNpbXBsZSBjb2RlIHJlZmFjdG9yaW5nIHRvDQo+IG1ha2UgdGhp
cyBwb3NzaWJsZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFhcm9uIFRvbWxpbiA8YXRvbWxpbkBy
ZWRoYXQuY29tPg0KPiAtLS0NCj4gICBrZXJuZWwvbW9kdWxlL01ha2VmaWxlICAgfCAgIDEgKw0K
PiAgIGtlcm5lbC9tb2R1bGUvaW50ZXJuYWwuaCB8ICA1MCArKysrKysrKysrKysrDQo+ICAga2Vy
bmVsL21vZHVsZS9tYWluLmMgICAgIHwgMTUwICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLQ0KPiAgIGtlcm5lbC9tb2R1bGUvdmVyc2lvbi5jICB8IDExMCArKysrKysrKysr
KysrKysrKysrKysrKysrKysrDQo+ICAgNCBmaWxlcyBjaGFuZ2VkLCAxNjMgaW5zZXJ0aW9ucygr
KSwgMTQ4IGRlbGV0aW9ucygtKQ0KPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBrZXJuZWwvbW9kdWxl
L3ZlcnNpb24uYw0KDQpTcGFyc2UgcmVwb3J0czoNCg0KICAgQ0hFQ0sgICBrZXJuZWwvbW9kdWxl
L3ZlcnNpb24uYw0Ka2VybmVsL21vZHVsZS92ZXJzaW9uLmM6MTAzOjY6IHdhcm5pbmc6IHN5bWJv
bCAnbW9kdWxlX2xheW91dCcgd2FzIG5vdCANCmRlY2xhcmVkLiBTaG91bGQgaXQgYmUgc3RhdGlj
Pw0KDQoNCkNoZWNrcGF0Y2g6DQoNCgl0b3RhbDogMCBlcnJvcnMsIDIgd2FybmluZ3MsIDMgY2hl
Y2tzLCAzMzcgbGluZXMgY2hlY2tlZA0KDQoNCk5vdGUgdGhhdCBldmVyeXdoZXJlIHlvdSBnZXQg
YSB3YXJuaW5nIGZvciBhbGlnbm1lbnQgbm90IG1hdGNoaW5nIG9wZW4gDQpwYXJlbnRoZXNpcywg
Zmlyc3QgYWN0aW9uIHNob3VsZCBiZSB0byBjaGVjayBpZiB3ZSByZWFsbHkgbmVlZCBpdCB0byBi
ZSANCm9uIHR3byBsaW5lcy4gV2hlbiBpdCdzIHNob3J0ZWQgdGhhbiAxMDAgY2hhcnMgaXQgaXMg
dXN1YWxseSBiZXR0ZXIgdG8gDQprZWVwIGl0IG9uIGEgc2luZ2xlIGxpbmUuDQoNCj4gDQo+IGRp
ZmYgLS1naXQgYS9rZXJuZWwvbW9kdWxlL01ha2VmaWxlIGIva2VybmVsL21vZHVsZS9NYWtlZmls
ZQ0KPiBpbmRleCBjMzAxNDFjMzdlYjMuLjFmMTExYWE0N2U4OCAxMDA2NDQNCj4gLS0tIGEva2Vy
bmVsL21vZHVsZS9NYWtlZmlsZQ0KPiArKysgYi9rZXJuZWwvbW9kdWxlL01ha2VmaWxlDQo+IEBA
IC0xNSw0ICsxNSw1IEBAIG9iai0kKENPTkZJR19ERUJVR19LTUVNTEVBSykgKz0gZGVidWdfa21l
bWxlYWsubw0KPiAgIG9iai0kKENPTkZJR19LQUxMU1lNUykgKz0ga2FsbHN5bXMubw0KPiAgIG9i
ai0kKENPTkZJR19QUk9DX0ZTKSArPSBwcm9jZnMubw0KPiAgIG9iai0kKENPTkZJR19TWVNGUykg
Kz0gc3lzZnMubw0KPiArb2JqLSQoQ09ORklHX01PRFZFUlNJT05TKSArPSB2ZXJzaW9uLm8NCj4g
ICBlbmRpZg0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL21vZHVsZS9pbnRlcm5hbC5oIGIva2VybmVs
L21vZHVsZS9pbnRlcm5hbC5oDQo+IGluZGV4IGM0OWI0OTAwYjMwYi4uNDc1YTY2YWE0MmYyIDEw
MDY0NA0KPiAtLS0gYS9rZXJuZWwvbW9kdWxlL2ludGVybmFsLmgNCj4gKysrIGIva2VybmVsL21v
ZHVsZS9pbnRlcm5hbC5oDQo+IEBAIC03MSw3ICs3MSwzMSBAQCBzdHJ1Y3QgbG9hZF9pbmZvIHsN
Cj4gICAJfSBpbmRleDsNCj4gICB9Ow0KPiAgIA0KPiArc3RydWN0IHN5bXNlYXJjaCB7DQo+ICsJ
Y29uc3Qgc3RydWN0IGtlcm5lbF9zeW1ib2wgKnN0YXJ0LCAqc3RvcDsNCj4gKwljb25zdCBzMzIg
KmNyY3M7DQo+ICsJZW51bSBtb2RfbGljZW5zZSB7DQo+ICsJCU5PVF9HUExfT05MWSwNCj4gKwkJ
R1BMX09OTFksDQo+ICsJfSBsaWNlbnNlOw0KPiArfTsNCg0KV2h5IGRvbid0IGxlYXZlIHRoaXMg
aW4gbWFpbi5jID8NCg0KPiArDQo+ICtzdHJ1Y3QgZmluZF9zeW1ib2xfYXJnIHsNCj4gKwkvKiBJ
bnB1dCAqLw0KPiArCWNvbnN0IGNoYXIgKm5hbWU7DQo+ICsJYm9vbCBncGxvazsNCj4gKwlib29s
IHdhcm47DQo+ICsNCj4gKwkvKiBPdXRwdXQgKi8NCj4gKwlzdHJ1Y3QgbW9kdWxlICpvd25lcjsN
Cj4gKwljb25zdCBzMzIgKmNyYzsNCj4gKwljb25zdCBzdHJ1Y3Qga2VybmVsX3N5bWJvbCAqc3lt
Ow0KPiArCWVudW0gbW9kX2xpY2Vuc2UgbGljZW5zZTsNCj4gK307DQo+ICsNCj4gICBpbnQgbW9k
X3ZlcmlmeV9zaWcoY29uc3Qgdm9pZCAqbW9kLCBzdHJ1Y3QgbG9hZF9pbmZvICppbmZvKTsNCj4g
K2ludCB0cnlfdG9fZm9yY2VfbG9hZChzdHJ1Y3QgbW9kdWxlICptb2QsIGNvbnN0IGNoYXIgKnJl
YXNvbik7DQo+ICtib29sIGZpbmRfc3ltYm9sKHN0cnVjdCBmaW5kX3N5bWJvbF9hcmcgKmZzYSk7
DQo+ICAgc3RydWN0IG1vZHVsZSAqZmluZF9tb2R1bGVfYWxsKGNvbnN0IGNoYXIgKm5hbWUsIHNp
emVfdCBsZW4sIGJvb2wgZXZlbl91bmZvcm1lZCk7DQo+ICAgdW5zaWduZWQgbG9uZyBrZXJuZWxf
c3ltYm9sX3ZhbHVlKGNvbnN0IHN0cnVjdCBrZXJuZWxfc3ltYm9sICpzeW0pOw0KPiAgIGludCBj
bXBfbmFtZShjb25zdCB2b2lkICpuYW1lLCBjb25zdCB2b2lkICpzeW0pOw0KPiBAQCAtMjMxLDMg
KzI1NSwyOSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgbW9kdWxlX3JlbW92ZV9tb2RpbmZvX2F0dHJz
KHN0cnVjdCBtb2R1bGUgKm1vZCwgaW50IGVuZCkgeyB9DQo+ICAgc3RhdGljIGlubGluZSB2b2lk
IGRlbF91c2FnZV9saW5rcyhzdHJ1Y3QgbW9kdWxlICptb2QpIHsgfQ0KPiAgIHN0YXRpYyBpbmxp
bmUgdm9pZCBpbml0X3BhcmFtX2xvY2soc3RydWN0IG1vZHVsZSAqbW9kKSB7IH0NCj4gICAjZW5k
aWYgLyogQ09ORklHX1NZU0ZTICovDQo+ICsNCj4gKyNpZmRlZiBDT05GSUdfTU9EVkVSU0lPTlMN
Cj4gK2ludCBjaGVja192ZXJzaW9uKGNvbnN0IHN0cnVjdCBsb2FkX2luZm8gKmluZm8sDQo+ICsJ
CSAgY29uc3QgY2hhciAqc3ltbmFtZSwgc3RydWN0IG1vZHVsZSAqbW9kLCBjb25zdCBzMzIgKmNy
Yyk7DQo+ICtpbnQgY2hlY2tfbW9kc3RydWN0X3ZlcnNpb24oY29uc3Qgc3RydWN0IGxvYWRfaW5m
byAqaW5mbywgc3RydWN0IG1vZHVsZSAqbW9kKTsNCj4gK2ludCBzYW1lX21hZ2ljKGNvbnN0IGNo
YXIgKmFtYWdpYywgY29uc3QgY2hhciAqYm1hZ2ljLCBib29sIGhhc19jcmNzKTsNCj4gKyNlbHNl
IC8qICFDT05GSUdfTU9EVkVSU0lPTlMgKi8NCj4gK3N0YXRpYyBpbmxpbmUgaW50IGNoZWNrX3Zl
cnNpb24oY29uc3Qgc3RydWN0IGxvYWRfaW5mbyAqaW5mbywNCj4gKwkJCQljb25zdCBjaGFyICpz
eW1uYW1lLA0KPiArCQkJCXN0cnVjdCBtb2R1bGUgKm1vZCwNCj4gKwkJCQljb25zdCBzMzIgKmNy
YykNCj4gK3sNCj4gKwlyZXR1cm4gMTsNCj4gK30NCj4gKw0KPiArc3RhdGljIGlubGluZSBpbnQg
Y2hlY2tfbW9kc3RydWN0X3ZlcnNpb24oY29uc3Qgc3RydWN0IGxvYWRfaW5mbyAqaW5mbywNCj4g
KwkJCQkJICBzdHJ1Y3QgbW9kdWxlICptb2QpDQo+ICt7DQo+ICsJcmV0dXJuIDE7DQo+ICt9DQo+
ICsNCj4gK3N0YXRpYyBpbmxpbmUgaW50IHNhbWVfbWFnaWMoY29uc3QgY2hhciAqYW1hZ2ljLCBj
b25zdCBjaGFyICpibWFnaWMsIGJvb2wgaGFzX2NyY3MpDQo+ICt7DQo+ICsJcmV0dXJuIHN0cmNt
cChhbWFnaWMsIGJtYWdpYykgPT0gMDsNCj4gK30NCj4gKyNlbmRpZiAvKiBDT05GSUdfTU9EVkVS
U0lPTlMgKi8NCg0KPiBkaWZmIC0tZ2l0IGEva2VybmVsL21vZHVsZS92ZXJzaW9uLmMgYi9rZXJu
ZWwvbW9kdWxlL3ZlcnNpb24uYw0KPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiBpbmRleCAwMDAw
MDAwMDAwMDAuLjEwYTE0OTBkMWI5ZQ0KPiAtLS0gL2Rldi9udWxsDQo+ICsrKyBiL2tlcm5lbC9t
b2R1bGUvdmVyc2lvbi5jDQo+IEBAIC0wLDAgKzEsMTEwIEBADQo+ICsvLyBTUERYLUxpY2Vuc2Ut
SWRlbnRpZmllcjogR1BMLTIuMC1vci1sYXRlcg0KPiArLyoNCj4gKyAqIE1vZHVsZSB2ZXJzaW9u
IHN1cHBvcnQNCj4gKyAqDQo+ICsgKiBDb3B5cmlnaHQgKEMpIDIwMDggUnVzdHkgUnVzc2VsbA0K
PiArICovDQo+ICsNCj4gKyNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4NCj4gKyNpbmNsdWRlIDxs
aW51eC9zdHJpbmcuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9wcmludGsuaD4NCj4gKyNpbmNsdWRl
ICJpbnRlcm5hbC5oIg0KPiArDQo+ICtzdGF0aWMgdTMyIHJlc29sdmVfcmVsX2NyYyhjb25zdCBz
MzIgKmNyYykNCj4gK3sNCj4gKwlyZXR1cm4gKih1MzIgKikoKHZvaWQgKiljcmMgKyAqY3JjKTsN
Cj4gK30NCj4gKw0KPiAraW50IGNoZWNrX3ZlcnNpb24oY29uc3Qgc3RydWN0IGxvYWRfaW5mbyAq
aW5mbywNCj4gKwkJCSBjb25zdCBjaGFyICpzeW1uYW1lLA0KPiArCQkJIHN0cnVjdCBtb2R1bGUg
Km1vZCwNCj4gKwkJCSBjb25zdCBzMzIgKmNyYykNCj4gK3sNCj4gKwlFbGZfU2hkciAqc2VjaGRy
cyA9IGluZm8tPnNlY2hkcnM7DQo+ICsJdW5zaWduZWQgaW50IHZlcnNpbmRleCA9IGluZm8tPmlu
ZGV4LnZlcnM7DQo+ICsJdW5zaWduZWQgaW50IGksIG51bV92ZXJzaW9uczsNCj4gKwlzdHJ1Y3Qg
bW9kdmVyc2lvbl9pbmZvICp2ZXJzaW9uczsNCj4gKw0KPiArCS8qIEV4cG9ydGluZyBtb2R1bGUg
ZGlkbid0IHN1cHBseSBjcmNzPyAgT0ssIHdlJ3JlIGFscmVhZHkgdGFpbnRlZC4gKi8NCj4gKwlp
ZiAoIWNyYykNCj4gKwkJcmV0dXJuIDE7DQo+ICsNCj4gKwkvKiBObyB2ZXJzaW9ucyBhdCBhbGw/
ICBtb2Rwcm9iZSAtLWZvcmNlIGRvZXMgdGhpcy4gKi8NCj4gKwlpZiAodmVyc2luZGV4ID09IDAp
DQo+ICsJCXJldHVybiB0cnlfdG9fZm9yY2VfbG9hZChtb2QsIHN5bW5hbWUpID09IDA7DQo+ICsN
Cj4gKwl2ZXJzaW9ucyA9ICh2b2lkICopIHNlY2hkcnNbdmVyc2luZGV4XS5zaF9hZGRyOw0KPiAr
CW51bV92ZXJzaW9ucyA9IHNlY2hkcnNbdmVyc2luZGV4XS5zaF9zaXplDQo+ICsJCS8gc2l6ZW9m
KHN0cnVjdCBtb2R2ZXJzaW9uX2luZm8pOw0KPiArDQo+ICsJZm9yIChpID0gMDsgaSA8IG51bV92
ZXJzaW9uczsgaSsrKSB7DQo+ICsJCXUzMiBjcmN2YWw7DQo+ICsNCj4gKwkJaWYgKHN0cmNtcCh2
ZXJzaW9uc1tpXS5uYW1lLCBzeW1uYW1lKSAhPSAwKQ0KPiArCQkJY29udGludWU7DQo+ICsNCj4g
KwkJaWYgKElTX0VOQUJMRUQoQ09ORklHX01PRFVMRV9SRUxfQ1JDUykpDQo+ICsJCQljcmN2YWwg
PSByZXNvbHZlX3JlbF9jcmMoY3JjKTsNCj4gKwkJZWxzZQ0KPiArCQkJY3JjdmFsID0gKmNyYzsN
Cj4gKwkJaWYgKHZlcnNpb25zW2ldLmNyYyA9PSBjcmN2YWwpDQo+ICsJCQlyZXR1cm4gMTsNCj4g
KwkJcHJfZGVidWcoIkZvdW5kIGNoZWNrc3VtICVYIHZzIG1vZHVsZSAlbFhcbiIsDQo+ICsJCQkg
Y3JjdmFsLCB2ZXJzaW9uc1tpXS5jcmMpOw0KPiArCQlnb3RvIGJhZF92ZXJzaW9uOw0KPiArCX0N
Cj4gKw0KPiArCS8qIEJyb2tlbiB0b29sY2hhaW4uIFdhcm4gb25jZSwgdGhlbiBsZXQgaXQgZ28u
LiAqLw0KPiArCXByX3dhcm5fb25jZSgiJXM6IG5vIHN5bWJvbCB2ZXJzaW9uIGZvciAlc1xuIiwg
aW5mby0+bmFtZSwgc3ltbmFtZSk7DQo+ICsJcmV0dXJuIDE7DQo+ICsNCj4gK2JhZF92ZXJzaW9u
Og0KPiArCXByX3dhcm4oIiVzOiBkaXNhZ3JlZXMgYWJvdXQgdmVyc2lvbiBvZiBzeW1ib2wgJXNc
biIsDQo+ICsJICAgICAgIGluZm8tPm5hbWUsIHN5bW5hbWUpOw0KPiArCXJldHVybiAwOw0KPiAr
fQ0KPiArDQo+ICtpbmxpbmUgaW50IGNoZWNrX21vZHN0cnVjdF92ZXJzaW9uKGNvbnN0IHN0cnVj
dCBsb2FkX2luZm8gKmluZm8sDQo+ICsJCQkJCSAgc3RydWN0IG1vZHVsZSAqbW9kKQ0KDQppbmxp
bmUgaXMgcG9pbnRsZXNzIGZvciBhIG5vbiBzdGF0aWMgZnVuY3Rpb24NCg0KDQo+ICt7DQo+ICsJ
c3RydWN0IGZpbmRfc3ltYm9sX2FyZyBmc2EgPSB7DQo+ICsJCS5uYW1lCT0gIm1vZHVsZV9sYXlv
dXQiLA0KPiArCQkuZ3Bsb2sJPSB0cnVlLA0KPiArCX07DQo+ICsNCj4gKwkvKg0KPiArCSAqIFNp
bmNlIHRoaXMgc2hvdWxkIGJlIGZvdW5kIGluIGtlcm5lbCAod2hpY2ggY2FuJ3QgYmUgcmVtb3Zl
ZCksIG5vDQo+ICsJICogbG9ja2luZyBpcyBuZWNlc3NhcnkgLS0gdXNlIHByZWVtcHRfZGlzYWJs
ZSgpIHRvIHBsYWNhdGUgbG9ja2RlcC4NCj4gKwkgKi8NCj4gKwlwcmVlbXB0X2Rpc2FibGUoKTsN
Cj4gKwlpZiAoIWZpbmRfc3ltYm9sKCZmc2EpKSB7DQo+ICsJCXByZWVtcHRfZW5hYmxlKCk7DQo+
ICsJCUJVRygpOw0KPiArCX0NCj4gKwlwcmVlbXB0X2VuYWJsZSgpOw0KPiArCXJldHVybiBjaGVj
a192ZXJzaW9uKGluZm8sICJtb2R1bGVfbGF5b3V0IiwgbW9kLCBmc2EuY3JjKTsNCj4gK30NCj4g
Kw0KPiArLyogRmlyc3QgcGFydCBpcyBrZXJuZWwgdmVyc2lvbiwgd2hpY2ggd2UgaWdub3JlIGlm
IG1vZHVsZSBoYXMgY3Jjcy4gKi8NCj4gK2lubGluZSBpbnQgc2FtZV9tYWdpYyhjb25zdCBjaGFy
ICphbWFnaWMsIGNvbnN0IGNoYXIgKmJtYWdpYywNCj4gKwkJCSAgICAgYm9vbCBoYXNfY3JjcykN
Cg0KU2FtZSwgbm90IHBvaW50IGZvciBpbmxpbmUga2V5d29yZCBoZXJlLg0KDQoNCj4gK3sNCj4g
KwlpZiAoaGFzX2NyY3MpIHsNCj4gKwkJYW1hZ2ljICs9IHN0cmNzcG4oYW1hZ2ljLCAiICIpOw0K
PiArCQlibWFnaWMgKz0gc3RyY3NwbihibWFnaWMsICIgIik7DQo+ICsJfQ0KPiArCXJldHVybiBz
dHJjbXAoYW1hZ2ljLCBibWFnaWMpID09IDA7DQo+ICt9DQo+ICsNCj4gKy8qDQo+ICsgKiBHZW5l
cmF0ZSB0aGUgc2lnbmF0dXJlIGZvciBhbGwgcmVsZXZhbnQgbW9kdWxlIHN0cnVjdHVyZXMgaGVy
ZS4NCj4gKyAqIElmIHRoZXNlIGNoYW5nZSwgd2UgZG9uJ3Qgd2FudCB0byB0cnkgdG8gcGFyc2Ug
dGhlIG1vZHVsZS4NCj4gKyAqLw0KPiArdm9pZCBtb2R1bGVfbGF5b3V0KHN0cnVjdCBtb2R1bGUg
Km1vZCwNCj4gKwkJICAgc3RydWN0IG1vZHZlcnNpb25faW5mbyAqdmVyLA0KPiArCQkgICBzdHJ1
Y3Qga2VybmVsX3BhcmFtICprcCwNCj4gKwkJICAgc3RydWN0IGtlcm5lbF9zeW1ib2wgKmtzLA0K
PiArCQkgICBzdHJ1Y3QgdHJhY2Vwb2ludCAqIGNvbnN0ICp0cCkNCj4gK3sNCj4gK30NCj4gK0VY
UE9SVF9TWU1CT0wobW9kdWxlX2xheW91dCk7
