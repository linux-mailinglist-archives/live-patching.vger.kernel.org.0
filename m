Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2514BD654
	for <lists+live-patching@lfdr.de>; Mon, 21 Feb 2022 07:56:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345169AbiBUGbf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Feb 2022 01:31:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235270AbiBUGbd (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Feb 2022 01:31:33 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90079.outbound.protection.outlook.com [40.107.9.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD4F4163D;
        Sun, 20 Feb 2022 22:31:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wr5xNiPoZGnWt9p66BaJb2VrWJIkf+2P8zBFqVehiJ/hA1uIhgGioQPBIaxsKicD0+PaL5aUA7qoqF8RM6HqqKcaZJE1kdfib9eEp61zego1TCCHTusxKAkd5dm/BYdf9QJeFOtp2jknh5GCpMZd7sdD4H7QErMTLsZySyvGk+CMrAkNNdQOHRVNTpbU01RI3IqqbsFb7zE+x9hlnZQIpnz7QqUu4DdoPzjbBXdH2O0C5DybwG43W7QNHjdlyl05HLIrbzsdH7hdofqzKT+tX60ssZlv5GIEtt8R/0G42Hydhmw0W+JJAEicdyjkC/i+e9RsOCxI1hg1kryizYtO2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pii/3P6DI1KrxDhy74s5qXXofvwb+BVV1i9OY62iUns=;
 b=E/POvS3ecQc7KZ+iMgYm/wUozImgFAMG+6IHiNstwW9x8Hbw9Kjg+aWH3klMrTVt8dps753uMWadPUW02JPTdV1RCXKOxlBApa+PDdOtF8EqpyfmMTuBw/YEOAUH6OiqId5/kAu+HUBpc7kT72uZrL+xT17JjsriBc5DKB5HcsGkHen5NLIC7RNbRYI+Cxh7uFMWJFaK7ETpFhUMmMySSSHizqhvUiTsLRWBN5y2pdr2/eHlNF/AqxoPJ00CdWlQqx1M40q+Gawzm1A8VAvbHZzRMa3CbP+ZLaTFKIweOYERryVlXRfmeeeEPX+W428A/2GFeP94sNb75IruZW/ihQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR1P264MB4477.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:23::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Mon, 21 Feb
 2022 06:31:07 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 06:31:07 +0000
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
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Subject: Re: [PATCH v6 06/13] module: Move strict rwx support to a separate
 file
Thread-Topic: [PATCH v6 06/13] module: Move strict rwx support to a separate
 file
Thread-Index: AQHYJQ4LXZiUR25fg0yFBOnbimlU7aydjxwA
Date:   Mon, 21 Feb 2022 06:31:07 +0000
Message-ID: <0555ad08-365c-ae49-0f6b-973fd16866c9@csgroup.eu>
References: <20220218212511.887059-1-atomlin@redhat.com>
 <20220218212511.887059-7-atomlin@redhat.com>
In-Reply-To: <20220218212511.887059-7-atomlin@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95b9b96e-ed87-40cc-4968-08d9f503be40
x-ms-traffictypediagnostic: MR1P264MB4477:EE_
x-microsoft-antispam-prvs: <MR1P264MB44770BCB7336902E3500999FED3A9@MR1P264MB4477.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SlPjUcPsQd0MnQUSgesxy8ACM+qZReTskT4wqCJZ9z1XcqbwjdZLgNlhiay1KJ/shlENMZ52FqpxqaePyYLhRWJQkxdSP+pjNXLNdsyMt2objhxIUeQfCDVYir2gzKeY0Dq75ZPeIe/whmxLa8c3lKxAOFfxM7vwZo9JPkLTZkXR+ZcVSZ7DNaQLZWSbN3vy6es/+0eEV0LQvHVBw/0e2GwqKtz3QHUrLZoOPFxMHh6JrCvumlGJZA2uldzje0Z2SQgbLPTOl7uoTzMB5NsX/XLSAX1TuLyDFIM6iKteZaxfb/Fl/rhkzO5QtijAf/tfs0vCR9afV7dQIH97WusJ7tJ98+i1MQ/Wtx7dRQAbksTfEg1MtSkwmy8AdqiT3TghlwSGSKvRJEt/2Lk7AcKoM1b4gdQTc7jHKWTa/6QHsf38z8FS7IY32idMnRe/iQx8dEw4Hui5fYNWJae+MPDrO3tgTAKYtxDJS/5Gc925IUAXYXX4r/wH6xffemnCO0PUGNPfSx8eQf8Ic55m8yJGqddQa0+WxbPd3ZB1nM041cI/vy8VkRj6HR5HCqmWvjnwbEg5ZuVT1zJgnD9dsSPnBuwL/MQtN6eKvyyVwCpzl6/21kmqoW6i+frZ1w3vUJ6PWAOvuGJ9Os2/iT2aa/G+gJSlVhabQqTsu0Neq8Po20c0tmH8alv7PEIyAkejgT0zlBqjYUZaCg6Fb1UsM98wwf7kzXMrTsP/ZgVBw+WLzCXJITswXmnrO9PCJOlI+jQbY8ukMkKk5Zm/SniZ8aWaCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(316002)(86362001)(6506007)(6486002)(38100700002)(71200400001)(66476007)(66946007)(110136005)(76116006)(54906003)(66556008)(66446008)(4326008)(64756008)(8676002)(91956017)(26005)(186003)(38070700005)(83380400001)(44832011)(31696002)(8936002)(36756003)(122000001)(5660300002)(2616005)(6512007)(7416002)(31686004)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?emJrcVhqNjEwTHZkbzZsaksyV0U2RWNJeExCbm90NUJtaWUxS1F6VXlMWm0r?=
 =?utf-8?B?K3R4TGhlcit6alBNQkdvc3B3UExKUmFyMzA1U1ZTT3pNbm4wdU1SdlRKZ2VW?=
 =?utf-8?B?T0FvVmFMV1FURHV0dzYvSkdZTlVBbEdDdmZpUGw5RVVpUVZab281VnkvNS8x?=
 =?utf-8?B?YkRlUTVYd0RjNVZCVkN0ZTNjdXF1ZlpLTUZhT0N5NjZvNzlKazMyZVMzc3Zr?=
 =?utf-8?B?MW9ZR214TjZncmwxSmY2aFpiL3NmZjN2L0E1VTcxZDB5WnZBKzQxcUlkVlFw?=
 =?utf-8?B?d2JsM2hDaUVjRU56SU90NHJhRmdHWnhBZUhRQUpBalkrNGdzRXhSSGUxK29n?=
 =?utf-8?B?YzJKeGdUMDVaRTEwdnlqNE1nY0V3QnlaZDlVL2VYUXZRSTRpZElreEduYTNv?=
 =?utf-8?B?UWlPWFNHelpTSERJaDJZTHZmRDlEWXlUZkRseURaVzNyc0RBTHBiaTVrK1Jo?=
 =?utf-8?B?Q0lYTFA1Z2JpVmUxTWtjT3ljaGs4QU1IR1dRYzFNZElyY3p1Y0sydHpjaXly?=
 =?utf-8?B?aHNYckljMW9Md3RVWWVaNFlvRW5qeXZzM1NTNVBIQXFFSmhRK0RYck5QTzEr?=
 =?utf-8?B?UWRjUDlqem9LSU9vUEgwdCt0ak1EK0xIQzBCV0dTbE9pOEdlY0VEL2xBbWpw?=
 =?utf-8?B?S3BaMXdKWXIveWU5bXNiYUhrTkJtT0xWaEVwWkFWV3BSVyszcGxHMjlYMXFT?=
 =?utf-8?B?RzBnY3NNc1FuNC8yWS9XMnBIcm5SY0R6bStyVmVhb0hRTDFFNVljejI4MmJS?=
 =?utf-8?B?WjdXOVpuVUZjNndjQWwxNWd3ZzgxZ2hPK2paeFpndkpNWGlmc2RjeDdRTVda?=
 =?utf-8?B?QVd2Q1FSeU5INTlLQnQyZW5UV1FnOFlQZnM1WHVKeitRaGMyM2FGeElURHd5?=
 =?utf-8?B?MlY4aE5XSlZvR3htMWtRSURUOTNBaldEazZJRHRkVjhyS1VQYlJKNHUyS2Zm?=
 =?utf-8?B?QTI5SXRGK3cwTXNXeGFzd3BWKzZ3d0U3eEZDSFVydXZvOVc2N0FMMTBCeUJR?=
 =?utf-8?B?aDVDMkpFREpxQ2JSRnVUM1VJVXlacFdmbnpSMGtsY1JtOUlta0d4aHZLR3Zu?=
 =?utf-8?B?SVlPV2F2WWVBbUpraDU2SjR5V1hLMjVSb0h2U0JuQStQVWFJQmIyRkJGUTBP?=
 =?utf-8?B?RDA4aTJvK0NVeTEzK3JrMGhZNE5IUmJhTG1ab2YyOGtiL0cya3ZpZHMrT3l2?=
 =?utf-8?B?VGtsNkdkc1lsTWQ5aThMTWJaSmRJajByNHJVSkpweXJVeGNqbjc5RVFSLzMr?=
 =?utf-8?B?R2J3YWYvRGE4bWFrYjh3NzRvQm9JWUxuM0V0eDlxekJ1THlodHFhUUZKeWNB?=
 =?utf-8?B?Ly9SeTVPRVovMlBHdXRKZlJjZVRhc2xZZjBCQzMzRk9EYmdJVEN6NTF4QUFY?=
 =?utf-8?B?ZnE0MFpTbmVIb1l3M0dSSFRWWnE1b1ZDWVFNb0l3a0RLVUtUdExKdlRQTER4?=
 =?utf-8?B?S2QyUnVzcHVXbkJNZ0tjZHRpdU1tdzBTOWpINTU4OXRXQ04zTkwrQ0pWQkEx?=
 =?utf-8?B?bVRQd2FBUmx4T01HUWcvMDBaKzlBY2dGSDFQNXBOMEdEZEc5V2crWXRVeWQ1?=
 =?utf-8?B?SmpNMDJ5ODI5VmtXeHVFdGcwL0JwNE81MnJqdzVBUytXU0tlb3NqVmp5dG1m?=
 =?utf-8?B?M1BGT0xkcnpnaXhERjloUTlSTW1DOGZPM1Y1QjgweHgydDhiTHRmZnh1SzNT?=
 =?utf-8?B?SktKam4vbHdvanZSL2R4N0ZWNXFESFBrUTQyaTdaYnRtZjlTM291S3VpOFVF?=
 =?utf-8?B?OEhqQjRhVnNGUHFWOHY4VUdYN2U4TFVmaVQrMjRwd2NsbUtndzFNaFAvTHR1?=
 =?utf-8?B?clhzOHpCZmhnbDR0elVCUHdGTFRvMWRTSkhVbmRUcnBpUkkrSjdjNjFzUGha?=
 =?utf-8?B?UkowU05KMmN4bm1yT2liYjErbm1wbkRyWnVQcEJkbXk4WExaak04a0k2enZo?=
 =?utf-8?B?Zm43TmVjR1ZzSkxJQkx6L2RBRWdxYVZjWVdiK21BcGgzRHhKakdHaUl5ek9H?=
 =?utf-8?B?djRQcnY0cldYN1pENkJhUXFlSGlnTkJLdjd4MFp6M2xaMnZ1TFRuNGM5cDJk?=
 =?utf-8?B?UGZvSVRHVVVPaUNlVUUvL0pkZUsxYTByeGQrL0FwS0YzQlNlM3FENForb1li?=
 =?utf-8?B?alhUTWJjS0xoKzBYVm00b0thZklaeGMvanlZQ2ZWNDVjL1NyalR0b0puUnNk?=
 =?utf-8?B?cXd1TDMrTXIzbldPTm91cU5FUFNldHdtYStsMFJtYUNCdFk1SDR0Z0ltdXZE?=
 =?utf-8?Q?I3uld+oAkolaGDWLNIj38Ee5xZn2TkC7rgSuM6t9G0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <081D554D0501E44289B0ECD47D4D96D8@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b9b96e-ed87-40cc-4968-08d9f503be40
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2022 06:31:07.4445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x3JrDlAbLICE11XMfLothXOPMeyumdJyKIuwTyAmKMKN4G0V8dWYcitFEmuziGdm9UODmBoYw3GinPOJ5b633it9GJgOjHHnNb+3PJP3gGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB4477
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,WEIRD_PORT autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDE4LzAyLzIwMjIgw6AgMjI6MjUsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBO
byBmdW5jdGlvbmFsIGNoYW5nZS4NCj4gDQo+IFRoaXMgcGF0Y2ggbWlncmF0ZXMgY29kZSB0aGF0
IG1ha2VzIG1vZHVsZSB0ZXh0DQo+IGFuZCByb2RhdGEgbWVtb3J5IHJlYWQtb25seSBhbmQgbm9u
LXRleHQgbWVtb3J5DQo+IG5vbi1leGVjdXRhYmxlIGZyb20gY29yZSBtb2R1bGUgY29kZSBpbnRv
DQo+IGtlcm5lbC9tb2R1bGUvc3RyaWN0X3J3eC5jLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQWFy
b24gVG9tbGluIDxhdG9tbGluQHJlZGhhdC5jb20+DQo+IC0tLQ0KPiAgIGtlcm5lbC9tb2R1bGUv
TWFrZWZpbGUgICAgIHwgIDEgKw0KPiAgIGtlcm5lbC9tb2R1bGUvaW50ZXJuYWwuaCAgIHwgMzgg
KysrKysrKysrKysrKysrDQo+ICAga2VybmVsL21vZHVsZS9tYWluLmMgICAgICAgfCA5OSArLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiAgIGtlcm5lbC9tb2R1bGUvc3Ry
aWN0X3J3eC5jIHwgODQgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gICA0IGZp
bGVzIGNoYW5nZWQsIDEyNSBpbnNlcnRpb25zKCspLCA5NyBkZWxldGlvbnMoLSkNCj4gICBjcmVh
dGUgbW9kZSAxMDA2NDQga2VybmVsL21vZHVsZS9zdHJpY3Rfcnd4LmMNCg0KICAgQ0MgICAgICBr
ZXJuZWwvbW9kdWxlL3N0cmljdF9yd3gubw0KSW4gZmlsZSBpbmNsdWRlZCBmcm9tIC4vaW5jbHVk
ZS9saW51eC9idWlsZF9idWcuaDo1LA0KICAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUv
bGludXgvY29udGFpbmVyX29mLmg6NSwNCiAgICAgICAgICAgICAgICAgIGZyb20gLi9pbmNsdWRl
L2xpbnV4L2xpc3QuaDo1LA0KICAgICAgICAgICAgICAgICAgZnJvbSAuL2luY2x1ZGUvbGludXgv
bW9kdWxlLmg6MTIsDQogICAgICAgICAgICAgICAgICBmcm9tIGtlcm5lbC9tb2R1bGUvc3RyaWN0
X3J3eC5jOjg6DQprZXJuZWwvbW9kdWxlL3N0cmljdF9yd3guYzogSW4gZnVuY3Rpb24gJ2Zyb2Jf
cm9kYXRhJzoNCmtlcm5lbC9tb2R1bGUvc3RyaWN0X3J3eC5jOjE2OjE3OiBlcnJvcjogaW1wbGlj
aXQgZGVjbGFyYXRpb24gb2YgDQpmdW5jdGlvbiAnUEFHRV9BTElHTkVEJzsgZGlkIHlvdSBtZWFu
ICdJU19BTElHTkVEJz8gDQpbLVdlcnJvcj1pbXBsaWNpdC1mdW5jdGlvbi1kZWNsYXJhdGlvbl0N
CiAgICAxNiB8ICAgICAgICAgQlVHX09OKCFQQUdFX0FMSUdORUQobGF5b3V0LT5iYXNlKSk7DQog
ICAgICAgfCAgICAgICAgICAgICAgICAgXn5+fn5+fn5+fn5+DQouL2luY2x1ZGUvbGludXgvY29t
cGlsZXIuaDo3ODo0NTogbm90ZTogaW4gZGVmaW5pdGlvbiBvZiBtYWNybyAndW5saWtlbHknDQog
ICAgNzggfCAjIGRlZmluZSB1bmxpa2VseSh4KSAgICBfX2J1aWx0aW5fZXhwZWN0KCEhKHgpLCAw
KQ0KICAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBe
DQprZXJuZWwvbW9kdWxlL3N0cmljdF9yd3guYzoxNjo5OiBub3RlOiBpbiBleHBhbnNpb24gb2Yg
bWFjcm8gJ0JVR19PTicNCiAgICAxNiB8ICAgICAgICAgQlVHX09OKCFQQUdFX0FMSUdORUQobGF5
b3V0LT5iYXNlKSk7DQogICAgICAgfCAgICAgICAgIF5+fn5+fg0KY2MxOiBzb21lIHdhcm5pbmdz
IGJlaW5nIHRyZWF0ZWQgYXMgZXJyb3JzDQptYWtlWzJdOiAqKiogW3NjcmlwdHMvTWFrZWZpbGUu
YnVpbGQ6Mjg4IDoga2VybmVsL21vZHVsZS9zdHJpY3Rfcnd4Lm9dIA0KRXJyZXVyIDENCg0KDQoN
CllvdSBoYXZlIHRvIGluY2x1ZGUgPGxpbnV4L21tLmg+DQoNCkNocmlzdG9waGU=
