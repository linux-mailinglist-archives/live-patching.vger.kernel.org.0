Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2964BDF17
	for <lists+live-patching@lfdr.de>; Mon, 21 Feb 2022 18:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236007AbiBUQQa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Feb 2022 11:16:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380013AbiBUQQN (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Feb 2022 11:16:13 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120049.outbound.protection.outlook.com [40.107.12.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1396223BD4;
        Mon, 21 Feb 2022 08:15:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBbLuCKTnjrovXQqUcDUE+4ne/tK9A8RdX3mDu/g52dNQ/bUjzGA4rNzQooyKiyatcnv14z0VVoO3+1nlsHILKEwsIc12iAGy985wP7Aghx9PU/L4E4HvMdZqXFYBCzaygOAGe1WU69rQLi62ZwiGZetGUOQeHUn4GIgK0zRN9Ls3++eQz6ifbJU1McegW7r4GOgX1NBdxGP7KBt4/oZlywlzhrdq1r5FuU1GnwicpR21bO7GznpsfNQ9sJvem9hzyZCFdgo6A6dX8A8VXPYGkrr9acAfsutr9jT44yFRwiJpMP8VgeCV47e1RHx5e1zlmZhakf013OO+pGma1NF9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Ua7dOs42iVBW9iuOl4aJKlQoxyopcY3iND+dWabRl4=;
 b=Sqqq2Q8q91yoY0PExwEONThDYikHmQPPhoqNtvGD+dxZTQyTXmpggVCIgAcSbZcxEJTUVVJdquI48klrgC2NQ1mIprIzkwce+MpRXGAW9/OWfRqg4HcNwcAB7j3apUGGgOEln8Sm6nyeBwhrtM5iuTpY8cJK/RWH/z+5xk07mclf7f61rUTjDcU1xK70P8C+YCHAYSBQXYMG5wsxrcjxa2nu+Z1GaRtQ7aFmtOXjLijzt67iVM/IPg1enr6OfrCk9VW2r8ho5/YZfEwweOifplFYsE7WbNis6EGcqDeQGxk7IcDk0odvLlgg3jaXj+AkBQiU0jc/mXV1304lgQqfRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRZP264MB1991.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:e::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.16; Mon, 21 Feb 2022 16:15:46 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 16:15:46 +0000
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
Thread-Index: AQHYJQ4LXZiUR25fg0yFBOnbimlU7ayeMnQA
Date:   Mon, 21 Feb 2022 16:15:46 +0000
Message-ID: <fdbe6e58-429f-d9f3-7ce0-577c732b0246@csgroup.eu>
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
x-ms-office365-filtering-correlation-id: 87238326-b678-4a81-2c5c-08d9f5556b1c
x-ms-traffictypediagnostic: MRZP264MB1991:EE_
x-microsoft-antispam-prvs: <MRZP264MB1991D20377A15864DB34CA6DED3A9@MRZP264MB1991.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mFtJxs20bQQk87gMHBiOPd8HCwzksqKITfU5HKjDmUb0MXx/IHFEtC7/tNBkSBskLf2tzzXC+5Vb2IYbyG0YZYFFhTP18UDlXQ0uGZ3HB7fRwmdzQKnmGzuar5DTm45/QdeSkR2vr8S3mksuCVE8U4w70imSvfYH1svP0uT4nCpcYfSFGMfW06rbdfV1+LBI1mK7SSphnY/NvzonM2wSsGjcnLJqSE8T7bM5rBAdh+fQF9K3TdI7R9IvfjQ1vM4Rcld8Iauukt1GQlPuQ36qH7zs4ivMgprDbbBG3jHuk1khv1VbYVH8VU1thCwjm4yYAUqX0NjbZbl/Vs78IewQz81qOb2s5ay1n6VRQObOGGmj5d2eFKhxMV28tOBZWNgkWw9x1NhbSrP6YIjbvJ3CLxAD0guClenZkoQWcraSkDELK9RsLX/58+LkGoi+p7mJOIiO1iVdHnMhYpffoQoadyEn5dgfy04B8QBb6jqrPtUUjhAltk5CMoXYSpDB32a7tQCtFZbUtqjgvjGQLnszWQTCx/xvcvVH67LMOyotwiGxvzStPSoz9nWQTgSoU8x29TacJwB6fFeA2C0zEzp6v6QlYSaBxfgIzN/4tEq7O4VpXaB8b0RnpSWwiC6KX1a6g4GIp1rdeZQFEmeEbvzr5JhMCBIwOeEZqTGNa2PRrJ6QR7JWyWVb28BkZ35xmwElPW5Jv4CVBBgl+47kg/HbhpSLThT6Zd0kAiRFN44G5v8DyfMTe2E1aRnmYoJOhv8Y0QyhL9Ia4deCYag5xeuEVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(5660300002)(186003)(8936002)(2906002)(2616005)(122000001)(38100700002)(6512007)(31696002)(26005)(7416002)(86362001)(44832011)(316002)(91956017)(66946007)(66446008)(71200400001)(83380400001)(36756003)(110136005)(66476007)(54906003)(6506007)(6486002)(8676002)(508600001)(4326008)(76116006)(64756008)(66556008)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QmpwY3AwMksxOWJVMHhaQzFsdFBhUHdFUDhaZnBIMFVyZkxmRStyQzBrU2Ew?=
 =?utf-8?B?M3BFdk9BcmFCNWFGZEE1amQwcTlwdHN2SGx6OGtrQmZzQUhRYWJZMHE0WTA4?=
 =?utf-8?B?bUZrRUhRSllmUENlUGM3dU5iQkNZOUhQaE1KVkJVaWU5dlJJUVcwTmdkN1Uv?=
 =?utf-8?B?MUhSM2tiR2kxM3FQdVgvbVdVbTQ1alhONFNIREdlUzBveFJXTG8rM2UrYXlX?=
 =?utf-8?B?N2NoTG1qbmZFN21nQ3A4d1lacHFPWW1JZUJTb1VNclFUWnhLRGJVS24vdm44?=
 =?utf-8?B?VGRrMEpJYTUxeWRZNEs5eU0xckkrSDl6K1RRQS9uMXpaUGxqbXlBakE1TnlS?=
 =?utf-8?B?ZGRLMzJKZU1YQThGK1p5dkNTZjQ0VjlYQzJRTnlCRFo5WGY0SXNCOER5dkR4?=
 =?utf-8?B?Q3hhRmo2NVpKOE9RdVRKcGlHZ2VQM0lpVnVHRktrbkJ2K05temxaQjhRTVlw?=
 =?utf-8?B?ODhTaFI2ZHNpVVFFc3BaVkxsVHZCbGJCQ1BCYTJWdEw4WVRiemlSMDYxNHRu?=
 =?utf-8?B?djFEK29Wb2FDdWVTeUNoS2F0R29DbDkyTWhlZklPOVBYUGE3dVRUcUhGNzE3?=
 =?utf-8?B?MG1FRG5mUEQxVVB6eTI3TXI1MUt4VEdDL05Td1h6UXE5dnFSaWNaeFhhUkJa?=
 =?utf-8?B?UUR1TFU1MjZaei9QYTU3SGZ6b1k4Y0hFSUI2NlZ3Ty9FelhtWXB2U1Y2dHFS?=
 =?utf-8?B?WWphRTloLzE5R0pKbzJrZFZhRUFXcGIwc0FHd0VtWHMvR0hxNmlpdkJRSzdI?=
 =?utf-8?B?Umg1QmNUN2JheHBvU2xiVHpTWWNjNU0wUS9MRmJDZTFjVGxNOVc4VFJrZ3Iz?=
 =?utf-8?B?TE9PU1AxWi9hRU0rZXJBeHJTKzhQMUZwN1lnTFY4K2MxcUY5aTF1aDBncUdt?=
 =?utf-8?B?ZERGbEtuTDdnTlFqZlI2OVZObml0OEwyTkoxZWhHYXRoazluMlQ5NW1keEtF?=
 =?utf-8?B?Q21zSllpaWFFZ2lhcXg2cVVnKzZGZnh3VW9kQ25IK3ZYNVRqSUFaU0xnVnZR?=
 =?utf-8?B?cGZJMVhZbkcybFVub1VYd0FLQkhXU1Zyb3V1R0pKRlBTRDVuR0VRck53ZlR6?=
 =?utf-8?B?S1FmUHNvOXJDRnM0NjlyTWpLOUVEZnYvTlY1QlZtL2x3UXczOExNV3p3VzJa?=
 =?utf-8?B?UXp6cTkvR0dlc0F3eXJmVWNBYWZ0RUVMWmtONGRDU3lHOEVhaHp5QXppMDhZ?=
 =?utf-8?B?SDRtejh2eFR3Mk45TjZOdE1MbHVicFFTeGZXVXpzUzJ6eVMzUjNuNGpzUlF0?=
 =?utf-8?B?NCtlTlZLdkVMeWFDR0VLdlVRRFFNMUpQb3ZJTlNlOFZjbXVGMDhuc0FGQzJQ?=
 =?utf-8?B?b2cxNWdjQy9QQ2ZmdFJJSEZGMU5yL05TR3VLTEd2aXBhNW1xRlhkWkFxb2tS?=
 =?utf-8?B?NVpPUUc5V0xvV2Y4UVVZZ2Q4bGtDaHl0RytEMmlWQ1VSNy9ZZXgwRU9GRzNC?=
 =?utf-8?B?bHVDdVl5RmV6dTlQbDNtY3VwakZhS0FpamhLYk1yWForRFBvaW9SUjZoNUtu?=
 =?utf-8?B?RVdROEVCK2k2c1BzSk9yQXV5bldpNlJIbTZmbWdkRU5PMlEwUWNFUDBUWXZy?=
 =?utf-8?B?bnl6aC9IZEFsOUE5VUhsVlB4cGg4RW5sK1pwT1lTNk5BRUk5WHdRNDdsR2M1?=
 =?utf-8?B?NkFjaVNUNlFvaFhoazNHYmF2QmEwc2kzV2dxTnZqYUJ3TS9FTXk2Nmt3NnpG?=
 =?utf-8?B?SU1pbXJ1TFFTQmkzdDkwd2h0cFVoZWYvRjdISi9Ma21jSkxWekZFSDFRRHVC?=
 =?utf-8?B?NlVkNThFYm1QZGJnZnJuc2JVWEJNUUIwbUwvVncvWlJ3eFZpYTBKcGVBRlc3?=
 =?utf-8?B?VEZQRUJLWmpKYk1GQTN4N2VNSWhyRllpTlJSMkRxdFdacUprSnlEUGdiditJ?=
 =?utf-8?B?Z1VLMTNUNGFpbGk4WTZFUStxcmU0SWVLUUpoK2lLTTdINGtFWDdSZW5rdU9Z?=
 =?utf-8?B?Z09OT3RIMHpKSnltVjFFRTlmdWE0WkdxNmloUDllaG9YWGZLMDZOVEFGamR1?=
 =?utf-8?B?c2VKaEtzY2dwaTEzWVJ5c2w5VEl1clZ3czNDb0p4ZHZaMklacTY4MmVPa1F6?=
 =?utf-8?B?TjZzelBCWEhYekp5a3J5SWg0YlpHZnQzRGkrQXRpWmFWU0g3NUNTVjNLekEv?=
 =?utf-8?B?SE44NUZYUFRZUDIrT2RKQVJ3V0paVDRlZ0ErK1JORXRMNDBRRmJjbS9xQ3o1?=
 =?utf-8?B?L0lPZ0hJUm1yQ3M0dU5yYVpRMklMSUxjaEV3ODgxRUdPQkF5TXViK3Z2NzJM?=
 =?utf-8?Q?Sq2TwT+RolqYjMO/uhLLfryocf2X695Z3K6wigJlGE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F26DCDD3F600C54FB016D15CE5805100@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 87238326-b678-4a81-2c5c-08d9f5556b1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2022 16:15:46.7044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q6aq/h7Ztfm9E/RwN6sOOef8jV4aTx4r6qflK80FAYyttl0nzrfLtCYDQgbUaxiDmc96o2j7bBN8SXX/ccizCvpZkVlKm5QU37vm/ZRD8Cs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRZP264MB1991
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
dGUgbW9kZSAxMDA2NDQga2VybmVsL21vZHVsZS9zdHJpY3Rfcnd4LmMNCj4gDQo+IGRpZmYgLS1n
aXQgYS9rZXJuZWwvbW9kdWxlL01ha2VmaWxlIGIva2VybmVsL21vZHVsZS9NYWtlZmlsZQ0KPiBp
bmRleCA2ZmIyMWViZTFhYTMuLjNmNDgzNDM2MzZmZiAxMDA2NDQNCj4gLS0tIGEva2VybmVsL21v
ZHVsZS9NYWtlZmlsZQ0KPiArKysgYi9rZXJuZWwvbW9kdWxlL01ha2VmaWxlDQo+IEBAIC0xMCw0
ICsxMCw1IEBAIG9iai0kKENPTkZJR19NT0RVTEVfU0lHX0ZPUk1BVCkgKz0gc2lnbmF0dXJlLm8N
Cj4gICBvYmotJChDT05GSUdfTElWRVBBVENIKSArPSBsaXZlcGF0Y2gubw0KPiAgIGlmZGVmIENP
TkZJR19NT0RVTEVTDQo+ICAgb2JqLSQoQ09ORklHX01PRFVMRVNfVFJFRV9MT09LVVApICs9IHRy
ZWVfbG9va3VwLm8NCj4gK29iai0kKENPTkZJR19TVFJJQ1RfTU9EVUxFX1JXWCkgKz0gc3RyaWN0
X3J3eC5vDQo+ICAgZW5kaWYNCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9tb2R1bGUvaW50ZXJuYWwu
aCBiL2tlcm5lbC9tb2R1bGUvaW50ZXJuYWwuaA0KPiBpbmRleCA1N2E3MTU0NTRjOWUuLmY0Yjdl
MTIzZDYyNSAxMDA2NDQNCj4gLS0tIGEva2VybmVsL21vZHVsZS9pbnRlcm5hbC5oDQo+ICsrKyBi
L2tlcm5lbC9tb2R1bGUvaW50ZXJuYWwuaA0KPiBAQCAtMjAsNiArMjAsMTcgQEANCj4gICAvKiBN
YXhpbXVtIG51bWJlciBvZiBjaGFyYWN0ZXJzIHdyaXR0ZW4gYnkgbW9kdWxlX2ZsYWdzKCkgKi8N
Cj4gICAjZGVmaW5lIE1PRFVMRV9GTEFHU19CVUZfU0laRSAoVEFJTlRfRkxBR1NfQ09VTlQgKyA0
KQ0KPiAgIA0KPiArLyoNCj4gKyAqIE1vZHVsZXMnIHNlY3Rpb25zIHdpbGwgYmUgYWxpZ25lZCBv
biBwYWdlIGJvdW5kYXJpZXMNCj4gKyAqIHRvIGVuc3VyZSBjb21wbGV0ZSBzZXBhcmF0aW9uIG9m
IGNvZGUgYW5kIGRhdGEsIGJ1dA0KPiArICogb25seSB3aGVuIENPTkZJR19BUkNIX0hBU19TVFJJ
Q1RfTU9EVUxFX1JXWD15DQo+ICsgKi8NCj4gKyNpZmRlZiBDT05GSUdfQVJDSF9IQVNfU1RSSUNU
X01PRFVMRV9SV1gNCj4gKyMgZGVmaW5lIGRlYnVnX2FsaWduKFgpIFBBR0VfQUxJR04oWCkNCj4g
KyNlbHNlDQo+ICsjIGRlZmluZSBkZWJ1Z19hbGlnbihYKSAoWCkNCj4gKyNlbmRpZg0KPiArDQo+
ICAgZXh0ZXJuIHN0cnVjdCBtdXRleCBtb2R1bGVfbXV0ZXg7DQo+ICAgZXh0ZXJuIHN0cnVjdCBs
aXN0X2hlYWQgbW9kdWxlczsNCj4gICANCj4gQEAgLTEyNiwzICsxMzcsMzAgQEAgc3RhdGljIGlu
bGluZSBzdHJ1Y3QgbW9kdWxlICptb2RfZmluZCh1bnNpZ25lZCBsb25nIGFkZHIpDQo+ICAgCXJl
dHVybiBOVUxMOw0KPiAgIH0NCj4gICAjZW5kaWYgLyogQ09ORklHX01PRFVMRVNfVFJFRV9MT09L
VVAgKi8NCj4gKw0KPiArI2lmZGVmIENPTkZJR19BUkNIX0hBU19TVFJJQ1RfTU9EVUxFX1JXWA0K
PiArdm9pZCBmcm9iX3RleHQoY29uc3Qgc3RydWN0IG1vZHVsZV9sYXlvdXQgKmxheW91dCwgaW50
ICgqc2V0X21lbW9yeSkodW5zaWduZWQgbG9uZyBzdGFydCwNCj4gKwkJCQkJCQkJICAgICBpbnQg
bnVtX3BhZ2VzKSk7DQo+ICsjZW5kaWYgLyogQ09ORklHX0FSQ0hfSEFTX1NUUklDVF9NT0RVTEVf
UldYICovDQo+ICsNCj4gKyNpZmRlZiBDT05GSUdfU1RSSUNUX01PRFVMRV9SV1gNCj4gK3ZvaWQg
ZnJvYl9yb2RhdGEoY29uc3Qgc3RydWN0IG1vZHVsZV9sYXlvdXQgKmxheW91dCwNCj4gKwkJIGlu
dCAoKnNldF9tZW1vcnkpKHVuc2lnbmVkIGxvbmcgc3RhcnQsIGludCBudW1fcGFnZXMpKTsNCj4g
K3ZvaWQgZnJvYl9yb19hZnRlcl9pbml0KGNvbnN0IHN0cnVjdCBtb2R1bGVfbGF5b3V0ICpsYXlv
dXQsDQo+ICsJCQlpbnQgKCpzZXRfbWVtb3J5KSh1bnNpZ25lZCBsb25nIHN0YXJ0LCBpbnQgbnVt
X3BhZ2VzKSk7DQo+ICt2b2lkIGZyb2Jfd3JpdGFibGVfZGF0YShjb25zdCBzdHJ1Y3QgbW9kdWxl
X2xheW91dCAqbGF5b3V0LA0KPiArCQkJaW50ICgqc2V0X21lbW9yeSkodW5zaWduZWQgbG9uZyBz
dGFydCwgaW50IG51bV9wYWdlcykpOw0KDQpUaG9zZSB0aHJlZSBmcm9iXygpIGZ1bmN0aW9ucyBh
cmUgb25seSB1c2VkIGluIHN0cmljdF9yd3guYywgdGhleSBzaG91bGQgDQpub3QgYXBwZWFyIGlu
IGludGVybmFsLmggYW5kIHNob3VsZCBiZSBzdGF0aWMgaW4gc3RyaWN0X3J3eC5jDQoNCj4gK3Zv
aWQgbW9kdWxlX2VuYWJsZV9ybyhjb25zdCBzdHJ1Y3QgbW9kdWxlICptb2QsIGJvb2wgYWZ0ZXJf
aW5pdCk7DQo+ICt2b2lkIG1vZHVsZV9lbmFibGVfbngoY29uc3Qgc3RydWN0IG1vZHVsZSAqbW9k
KTsNCj4gK2ludCBtb2R1bGVfZW5mb3JjZV9yd3hfc2VjdGlvbnMoRWxmX0VoZHIgKmhkciwgRWxm
X1NoZHIgKnNlY2hkcnMsDQo+ICsJCQkJY2hhciAqc2Vjc3RyaW5ncywgc3RydWN0IG1vZHVsZSAq
bW9kKTsNCj4gKw0KPiArI2Vsc2UgLyogIUNPTkZJR19TVFJJQ1RfTU9EVUxFX1JXWCAqLw0KPiAr
c3RhdGljIHZvaWQgbW9kdWxlX2VuYWJsZV9ueChjb25zdCBzdHJ1Y3QgbW9kdWxlICptb2QpIHsg
fQ0KPiArc3RhdGljIHZvaWQgbW9kdWxlX2VuYWJsZV9ybyhjb25zdCBzdHJ1Y3QgbW9kdWxlICpt
b2QsIGJvb2wgYWZ0ZXJfaW5pdCkge30NCj4gK3N0YXRpYyBpbnQgbW9kdWxlX2VuZm9yY2Vfcnd4
X3NlY3Rpb25zKEVsZl9FaGRyICpoZHIsIEVsZl9TaGRyICpzZWNoZHJzLA0KPiArCQkJCSAgICAg
ICBjaGFyICpzZWNzdHJpbmdzLCBzdHJ1Y3QgbW9kdWxlICptb2QpDQoNClRob3NlIHRocmVlIG11
c3QgYmUgc3RhdGljIGlubGluZQ0KDQo+ICt7DQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsjZW5k
aWYgLyogQ09ORklHX1NUUklDVF9NT0RVTEVfUldYICovDQoNCg0KQ2hyaXN0b3BoZQ==
