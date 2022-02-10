Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603284B0C34
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 12:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240789AbiBJLUK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 06:20:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbiBJLUJ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 06:20:09 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120080.outbound.protection.outlook.com [40.107.12.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897ABF46;
        Thu, 10 Feb 2022 03:20:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0LntjTMnxRcrNn2DqfCpYIOfaNi8pZ3RqpgZCs0OBgOfUtY6Bwi72cTy7S9ndze+TPCuaqmTyoJCYyeLXxm7QWZi9XkNFfjii7hEecD/nLYOoQJEYRqSXktRj+tX+BO8GdRGCa6rZalBJ+cbZelvsM6KZSnSpvFnnmMkAxS9pA05t4xo6sCsiRc+qq7JBWOYZnjatCIXl6/aB5tuHD1zO7tV3fgFmKJTMAFe3rP1Xat622I96mQvDHyf74Qqq+ci9mI5z4cgMvUu6FuceFbv87F26q2ZAyHF1onbUtrw3rCJQ6DpE1L0phroblU9lD6KSFtUPmo9Vcbn6cGNRlbLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=htv9daUWrZjlmGAkI5AppWOaALtWg3D0Rac4uLpg0sk=;
 b=Nq/JTF9AcDZKUwNxNIM1Qn8Eqwf8KmqjQ6AZ5UIL/KiKi47tsMv/NbPTE6+5ebhrsOG1yGGcrGmCAt8oblML/DJdq/bCYpGnLMT3aL2uCGKpQvOIuEfrhhczthpsQalSakQs23CBOopkn2K+4bfc6JLo4LQ7b50doXv3ar+Uduv5owL6NFkGLHmbXe+nPu0VuaJr88t8t56GZyVJ2Yw2iGFFiZ/1oPDH8szWqDFwo0LxprwB5pTeC/C9Nc1R8xSkBrbPUA+FMG2ix5I2ARePgqOiEbfs7Iw+OYc02MYXpD8k4V+zOxldpW5tYkK/bPA8gLwJv9+fhCpfF/+dr5M8Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRZP264MB3052.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 11:20:08 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 11:20:08 +0000
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
Subject: Re: [PATCH v5 03/13] module: Make internal.h more compliant
Thread-Topic: [PATCH v5 03/13] module: Make internal.h more compliant
Thread-Index: AQHYHdcN1XjmCIdO0k60XpQXa1h+XayMpKKA
Date:   Thu, 10 Feb 2022 11:20:08 +0000
Message-ID: <4591a317-9e4f-3608-2e3b-6c213d295bc0@csgroup.eu>
References: <20220209170358.3266629-1-atomlin@redhat.com>
 <20220209170358.3266629-4-atomlin@redhat.com>
In-Reply-To: <20220209170358.3266629-4-atomlin@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4a780c8-bd93-4296-78f8-08d9ec874bd9
x-ms-traffictypediagnostic: MRZP264MB3052:EE_
x-microsoft-antispam-prvs: <MRZP264MB305245E161A89CDA4B2AA09CED2F9@MRZP264MB3052.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AvstdLE0X5TqJSFpqMjMM6y4A8fgjH4H6DJxGKumNRAARTKWp8VyJtfG5KNXWCXnlE4H/xHJEGJDrBtS67nuTuYS5bZ9wZq+Oot+k4/+uQXaOfIF6dSHSI44zKei05AD+9p5eelKDq7lmn430m4YZhTZVO/p+dih20T5F2flCaZpEqK1IOyCAnCzUtRHProCzeN9WEX9RomIMLwQRxoMF59X1neLU0KEAKFKrzcCxk4rn3vYNwqJ0eZQwS97w/6gf/mnQc2K3Y5YKKtmjYnGaETHsdGX1QsOKns2PV+Zvp/nIFK81pRxyook5gzlaI3J2noQA/DAunmEXlxmlLPm0P9MVbkJnVDj6o+Bief8Vj6fHPKSxsQp40UGmt2612hkfbuAtaBn3e9d0XIYGyGBgr5cML+ilEmEZxMd1kBy/19xn//JEbwTNX+mU24f6T9MlVfgbXe93MZdDlJpK8TyL4W9WuopeZ0buVeTwykBqCQ/UXxaHEWHkWZ4Nc7iFuJIh1NMw2OEx9DOV1fT4mXNskdcJZFykWljTbukKfMIrVxJCuvzNNp21li/KQ6xlDSn0TKrJm7wLHCHyy6XOWD7xBaGn87AxSP0P/rVrM3jnwAGssinDRuIR7qpVE63/0BVHmJAAarOF9LdRF+UF/FPtXCvd+XlwwuKTFkAIWS3x4C+2DJCqMMV7LEdPNSz/GYXJ9LpbiILu3HCOLLNKwbx5kV/a31LopjeAUK/YYcMQNHt9nS3Ue4shpdufmj9LwfgJWqowR9jpeopLbIBzt/EEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(2906002)(508600001)(122000001)(316002)(38070700005)(86362001)(31696002)(110136005)(38100700002)(5660300002)(66946007)(7416002)(76116006)(54906003)(6512007)(6506007)(36756003)(4326008)(66574015)(66446008)(64756008)(66476007)(83380400001)(31686004)(2616005)(8936002)(91956017)(26005)(6486002)(8676002)(71200400001)(44832011)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGJaWGpsb0tsbk55djJuMXhsem50UTFaZCtqWlNNWXZOTkh3YzdGN05KaHU1?=
 =?utf-8?B?VlBUKzdEU01XcXJSVlkxRnBha2F5UGxtNUxGMllhRWVBaWJRTHB0a3VGY2lV?=
 =?utf-8?B?dWRDVTRQMzgyNDRyK2tLTVhmL21hWXZ0Y0pEYUJhdDBOYitOOHZtUVl6RFlP?=
 =?utf-8?B?ZXgzbTIxZ3ZBKzB4enQveWdqaGdlNUU4Q1RvdXUvL3hVSUpvRzVPV2NwQy9L?=
 =?utf-8?B?N044a25sR2VnUVhGUHcrNmdtenJxWXNPYy8xV3A3MzZQbTk3UFEwaGs1d2Js?=
 =?utf-8?B?eTFvN0l6T1BsdEp0eFZkS0h5SXVhbDFGWmNvNUhxZ1pnRnhsTG9LL0NIM0Fz?=
 =?utf-8?B?RGFBN24rTXNDNkF6TTZFVEFpQXIvenB5RDF5RVhidmJhL1g3eWN1RytkbWxy?=
 =?utf-8?B?MlcwSlJEUkJkSFhqeXg5cXZPYVRpdlhpWlQ2dXdyd291K0Y1TW9sSXcvY0cw?=
 =?utf-8?B?SXZzbmIrcXBrNWt3cE9MY1p2aUxQT1hBUXo1MWYzWkVvVXA0MmRnZkZaZEww?=
 =?utf-8?B?S0dqVzVKU1UyUnVnWGR6anYvTS9yY1RUb2t1bHBUT0h1dzEzWHY5YUdoK1gz?=
 =?utf-8?B?MUIxUDdiOEt3YStsZ0lQcDM2NTZGNkkzdlRHVEJtajhmdmNkdnRObUxsWUli?=
 =?utf-8?B?R1ozeWVrSldoaDBhdDRCWFZIUzN5dURlc01UaVI0cUZPSEp3RmQrdFhPcDBw?=
 =?utf-8?B?bG82VlVrdm5WUmpsY3VrbC9TRE1saWNHeGY5SldHemNGSm9zeENmZjFGemhp?=
 =?utf-8?B?bjl0WDlvVTAvSXFrcXBHc081OHlhTDEwdjcwVURXMjlBSTNESnNQV0ovbXFS?=
 =?utf-8?B?VVVTUDlNRnZtL0orMEE1STFVcS9oSm1GYmxjV21SZk8wV1Q4dWRGWVhiM2xs?=
 =?utf-8?B?aEFVT1dMZnA0REhlL3l6cW9CVm5Ld2ZsK1F0bUxBMklrK2hQcG9EVjBuZUZ6?=
 =?utf-8?B?RjlUZkQ5MitvOGhENmptQUFjcnV2YWVqWlpIa3BObkxOSVRybzZCMWI2Wm5J?=
 =?utf-8?B?VVRLdTVLQXNsaTBHZTc4TFBXSUxBdkZiekk3SUQ3dmIyQzY2SmtUdjlZWGhu?=
 =?utf-8?B?ckV4VGNMZnNaVXVmVUwzeGNwNVh4OXc1NGtGMkhSQnNTSFRYeWo4TXMyWEN4?=
 =?utf-8?B?L3ZYUFl3NkR1TjVldUkxTU5aVW9mbExybmZ5bCs1ZkVHdE5NNUx3dnFqUjRn?=
 =?utf-8?B?YTdVbHBTVGdTSk9vM3c5SEdqOS83Q2VxZVFkMUI0SnQwYlpLR3lrcEtNbm5N?=
 =?utf-8?B?aTA3RFNCMjMzWktha1A4VUlYMEtjVDV2WnpwU2wxY3FkYXJtdUNZR3N0UVhV?=
 =?utf-8?B?cVBKRFNmdkR6akRxdVBLZDRhbXp6aS9iNFk5T083dDM3VUtnaFIyQVQreWZQ?=
 =?utf-8?B?OWhQU1A2RmoySUhtRTN6cVFCeVlaSXZ2R25XakJueGhHemVlR21vWUl2YjZD?=
 =?utf-8?B?K2xYVHZGdXJNUUN3cGNBb0s3czFTeWJlUDZIclJwNVFtU0Nob3JkTC83ZWJz?=
 =?utf-8?B?aURnU2Z3djRzVjNhMzNyNnJIbUtwYUo1S1l0amtGOUZvTmdndGp2bmJ3SFJh?=
 =?utf-8?B?SmRjVk5CQVJOanlsakVoQ25zWnBPU0hEbzZWbXM0R2k4T1VLR1ZEVjZhcUwx?=
 =?utf-8?B?Tmg1czhleGVWSGU3VEZZZlUwZStWNHVGSFRnTlJ0dXpxTURSS0N3TUt0dTl6?=
 =?utf-8?B?U0EvdVZkdUxjS0ZBdGNUQ0xnQXZ5YmNxcU9ScUtuZEN5UWRPWmR0ZEtuakY1?=
 =?utf-8?B?WG9JNWxJZEJpYnlzMzRvMjVnckZNOUV3a0JEc3FoK2NXVXd4NlI5UEk0SjRP?=
 =?utf-8?B?eHJVc0dScWhHYk9ZUUQzY3h4cFZNUEJDbW5uOFRWYnZoUHU3c3F4Qi9nU0pU?=
 =?utf-8?B?azdWNnVFaFJqbnZtVlFtQzJHaGdIbEVqc1JscW1NSTN4OVdOaEdSQjMrOGs5?=
 =?utf-8?B?Mk1teHMvajN4UmdrclhQV3IxQVBZT2Y2Ny81cEFzVjRpQW1uWWVnOXpWQWpl?=
 =?utf-8?B?cTRhUHFMcUJTV09BTXBDU3MxajVtZ29rWmg0NHNiQWIwRTdNa2I3WmtTRi9C?=
 =?utf-8?B?OTZaeVpIUTh6QnZnNGNUaXZlRFp5L2hncVR5QWtscWVVSWJNNXpUVEZXTzBa?=
 =?utf-8?B?L2htT3lHMENMQWVqcGRWUWV4NjN1TnZsS3BzbjF5VEF0YVRtdVlaREo0S1E5?=
 =?utf-8?B?UFBOYzJyNlJ5SFVlUzJobWt6THlNdENqOW1OZjRaSXh5S3l5R3FwNVZEYm9O?=
 =?utf-8?Q?DIz9gnN4XolRukWR7auIjaWAtaC9+jLBmmV8XlQApc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <673EE298C079B1459148ADA5A8A8D456@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d4a780c8-bd93-4296-78f8-08d9ec874bd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 11:20:08.6294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: exVhg1TOq0Z8RYtt7IbSlSchn0IyytebTIVA8fSsIADvEcVz78M4x0SKX9skiehzWoMTrLImkPbUq003RwiTLsyoybO7b8bpoekQzpYGy08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRZP264MB3052
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDA5LzAyLzIwMjIgw6AgMTg6MDMsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBU
aGlzIHBhdGNoIHdpbGwgYWRkcmVzcyB0aGUgZm9sbG93aW5nIHdhcm5pbmcgYW5kIHN0eWxlIHZp
b2xhdGlvbnMNCj4gZ2VuZXJhdGVkIGJ5IC4vc2NyaXB0cy9jaGVja3BhdGNoLnBsOg0KPiANCj4g
ICAgV0FSTklORzogVXNlICNpbmNsdWRlIDxsaW51eC9tb2R1bGUuaD4gaW5zdGVhZCBvZiA8YXNt
L21vZHVsZS5oPg0KPiAgICAjMTA6IEZJTEU6IGtlcm5lbC9tb2R1bGUvaW50ZXJuYWwuaDoxMDoN
Cj4gICAgKyNpbmNsdWRlIDxhc20vbW9kdWxlLmg+DQo+IA0KPiAgICBDSEVDSzogc3BhY2VzIHBy
ZWZlcnJlZCBhcm91bmQgdGhhdCAnLScgKGN0eDpWeFYpDQo+ICAgICMxODogRklMRToga2VybmVs
L21vZHVsZS9pbnRlcm5hbC5oOjE4Og0KPiAgICArI2RlZmluZSBJTklUX09GRlNFVF9NQVNLICgx
VUwgPDwgKEJJVFNfUEVSX0xPTkctMSkpDQo+IAkJCQkJCSAgIF4NCj4gICAgQ0hFQ0s6IGV4dGVy
biBwcm90b3R5cGVzIHNob3VsZCBiZSBhdm9pZGVkIGluIC5oIGZpbGVzDQo+ICAgICM4NDogRklM
RToga2VybmVsL21vZHVsZS9pbnRlcm5hbC5oOjg0Og0KPiAgICArZXh0ZXJuIGludCBtb2RfdmVy
aWZ5X3NpZyhjb25zdCB2b2lkICptb2QsIHN0cnVjdCBsb2FkX2luZm8gKmluZm8pOw0KPiANCj4g
Tm90ZTogRm9ydHVuYXRlbHksIHRoZSBtdWx0aXBsZS1pbmNsdWRlIG9wdGltaXNhdGlvbiBmb3Vu
ZCBpbg0KPiBpbmNsdWRlL2xpbnV4L21vZHVsZS5oIHdpbGwgcHJldmVudCBkdXBsaWNhdGlvbi9v
ciBpbmNsdXNpb24gbW9yZSB0aGFuDQo+IG9uY2UuDQo+IA0KPiBGaXhlczogZjMxNGRmZWExNmEg
KCJtb2RzaWduOiBsb2cgbW9kdWxlIG5hbWUgaW4gdGhlIGV2ZW50IG9mIGFuIGVycm9yIikNCj4g
U2lnbmVkLW9mZi1ieTogQWFyb24gVG9tbGluIDxhdG9tbGluQHJlZGhhdC5jb20+DQoNClJldmll
d2VkLWJ5OiBDaHJpc3RvcGhlIExlcm95IDxjaHJpc3RvcGhlLmxlcm95QGNzZ3JvdXAuZXU+DQoN
Cj4gLS0tDQo+ICAga2VybmVsL21vZHVsZS9pbnRlcm5hbC5oIHwgNyArKysrLS0tDQo+ICAgMSBm
aWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9rZXJuZWwvbW9kdWxlL2ludGVybmFsLmggYi9rZXJuZWwvbW9kdWxlL2ludGVybmFs
LmgNCj4gaW5kZXggMWE0YjMzY2U5ZjVmLi4xY2Y1ZDZkYWJjOTcgMTAwNjQ0DQo+IC0tLSBhL2tl
cm5lbC9tb2R1bGUvaW50ZXJuYWwuaA0KPiArKysgYi9rZXJuZWwvbW9kdWxlL2ludGVybmFsLmgN
Cj4gQEAgLTYsNyArNiw4IEBADQo+ICAgICovDQo+ICAgDQo+ICAgI2luY2x1ZGUgPGxpbnV4L2Vs
Zi5oPg0KPiAtI2luY2x1ZGUgPGFzbS9tb2R1bGUuaD4NCj4gKyNpbmNsdWRlIDxsaW51eC9jb21w
aWxlci5oPg0KPiArI2luY2x1ZGUgPGxpbnV4L21vZHVsZS5oPg0KPiAgICNpbmNsdWRlIDxsaW51
eC9tdXRleC5oPg0KPiAgIA0KPiAgICNpZm5kZWYgQVJDSF9TSEZfU01BTEwNCj4gQEAgLTE0LDcg
KzE1LDcgQEANCj4gICAjZW5kaWYNCj4gICANCj4gICAvKiBJZiB0aGlzIGlzIHNldCwgdGhlIHNl
Y3Rpb24gYmVsb25ncyBpbiB0aGUgaW5pdCBwYXJ0IG9mIHRoZSBtb2R1bGUgKi8NCj4gLSNkZWZp
bmUgSU5JVF9PRkZTRVRfTUFTSyAoMVVMIDw8IChCSVRTX1BFUl9MT05HLTEpKQ0KPiArI2RlZmlu
ZSBJTklUX09GRlNFVF9NQVNLICgxVUwgPDwgKEJJVFNfUEVSX0xPTkcgLSAxKSkNCj4gICAvKiBN
YXhpbXVtIG51bWJlciBvZiBjaGFyYWN0ZXJzIHdyaXR0ZW4gYnkgbW9kdWxlX2ZsYWdzKCkgKi8N
Cj4gICAjZGVmaW5lIE1PRFVMRV9GTEFHU19CVUZfU0laRSAoVEFJTlRfRkxBR1NfQ09VTlQgKyA0
KQ0KPiAgICNkZWZpbmUgTU9EVUxFX1NFQ1RfUkVBRF9TSVpFICgzIC8qICIweCIsICJcbiIgKi8g
KyAoQklUU19QRVJfTE9ORyAvIDQpKQ0KPiBAQCAtNTUsNyArNTYsNyBAQCBzdHJ1Y3QgbG9hZF9p
bmZvIHsNCj4gICAJfSBpbmRleDsNCj4gICB9Ow0KPiAgIA0KPiAtZXh0ZXJuIGludCBtb2RfdmVy
aWZ5X3NpZyhjb25zdCB2b2lkICptb2QsIHN0cnVjdCBsb2FkX2luZm8gKmluZm8pOw0KPiAraW50
IG1vZF92ZXJpZnlfc2lnKGNvbnN0IHZvaWQgKm1vZCwgc3RydWN0IGxvYWRfaW5mbyAqaW5mbyk7
DQo+ICAgDQo+ICAgI2lmZGVmIENPTkZJR19NT0RVTEVfREVDT01QUkVTUw0KPiAgIGludCBtb2R1
bGVfZGVjb21wcmVzcyhzdHJ1Y3QgbG9hZF9pbmZvICppbmZvLCBjb25zdCB2b2lkICpidWYsIHNp
emVfdCBzaXplKTs=
