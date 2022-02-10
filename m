Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C40F4B0C2B
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 12:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240777AbiBJLTD (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 06:19:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240788AbiBJLTA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 06:19:00 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90054.outbound.protection.outlook.com [40.107.9.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD22D1020;
        Thu, 10 Feb 2022 03:19:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWRvYd2LtucQO6ZEGUiSERamTiRBeDLNL0xnP+IlmrlgAgsZQ6teJmtnjMyGN0VmZ3BzunEQWBmFYj7lZYTRm5i9fx1faH6Hl+NiRPyUTOwmDFLsMBUbxmnhkCvSeCFlo3Cy7ydAUJkB4oA6ZbZxLbWpiJcnsxuYD5PRKQx/TT0CUSo6gp3aPNW3AMeFZgqrGqIze5/3TrJeCTikO0lX3GbUK9tQZ+uLjgbjbfGMQZlBm0wfAMq1RxT6YaOrSKx/CWcYrII+3+KgFPNQ2RcsSHv2hDAY1T3qFUHVAftAdlJbkb6/jofK7wheF9OnmgCozJb9nMj8s/snOecPjpbCqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n/jesmy8TrqYFLB0KhKw4B84jz5zrQf/Pb9C8r83LHM=;
 b=jX1mChrT5n3SF01kTKdt4vh0qr73rjUHNjJU6W8QFjra24Km9o/fqCt3ht3jQ37CJoXv0dTLB8oxY3up3a6JoRpxP10p+Vt6uOU37v8l3n/DPnTrlS5kQGB150OuWFmHpO6JttnLx8gfcFcRtRmVRlSzS5ZOChF5x357MhJ9HxkIHp3XHSmjMrfaR4V97P1Hsg8lkBqa6KgPQnFIj1XgNd6wnUTFje0vApEJPDwEG/3boNk2KSHCGgXCLBmuCcChpSZWF6uWktmvjbbctoNQ2QKxCJj3hTv1XSMVt5WVCIV+LqTgs+vwAycne63fMia/geWqd61JdGU1oE0lYch65Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MRZP264MB3052.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 11:18:58 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 11:18:58 +0000
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
Subject: Re: [PATCH v5 02/13] module: Simple refactor in preparation for split
Thread-Topic: [PATCH v5 02/13] module: Simple refactor in preparation for
 split
Thread-Index: AQHYHdcMHMPlsS1FPEGWFrJ63apuyqyMpE+A
Date:   Thu, 10 Feb 2022 11:18:58 +0000
Message-ID: <f40fd2b2-2038-a53b-23ec-8f63941a2103@csgroup.eu>
References: <20220209170358.3266629-1-atomlin@redhat.com>
 <20220209170358.3266629-3-atomlin@redhat.com>
In-Reply-To: <20220209170358.3266629-3-atomlin@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 682b45ca-7f86-485e-8cf2-08d9ec8721dd
x-ms-traffictypediagnostic: MRZP264MB3052:EE_
x-microsoft-antispam-prvs: <MRZP264MB3052A06F0F4AB7A374C6034DED2F9@MRZP264MB3052.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lkB0imUnO8mfOvgHRfNG+OazLJFpOz0oX46PNe/90UJRCk1a0MulB/lEGSWLqiq7H/nur9Ykoxty/SB/RdJvQS+6hQFqPVrM7G953SJ0SFVieuuIL5b1y15iY+FZU7BdVPUEkwkOl0kGZJ6Cq+afdjvslm0zfcQRZ83tcCO7it6kJrGAqyrPxg44USOdgdI3hDlUXGJyWQaYsBXZleFoWPBki1Pgci6Ktwx8cEIGChIROzohzFJHgnDYYeiAQi4ekxqnbSodazC4Vadxz2d2SEBehBLKLrtWUfM7mr74L6FbxoVsL9CIbUkyqaeuQe7XiH0J3GyIbWlnWeWFnYjUiBCAFZ8RO8c1Z+6kxluXBSWQSZf48EY/u8fHp1o5LIjbNi+do7MyWzyzh7zg6OR2V7eY6jGoJ7mCrEklXft1yo9Il1iNVxeeMVpaE40WvM5RHbGOZIiPbdvKg46971NgNiEfhQ8BQ5U2Yfm1+Jd5/6ijadOOlc2ccrA8yY97FQ0Q2ZNNZ7FbbpBimQP9sPsy4hSdZBEw8SV/Dd51yZ4RqMkrT7fwcseFMtqQgfAuXtwX8JzTnggMTjdz9EC0IcoJFlzbug2DlpFIvjbJ3dF6aDKjGDmz/bm6QOS6TZvwLeDbey5pQGP6RHYaCZFQLOu+aZYsHNr4QWzi/2jTD68i9x/8ZWYp73IeMzIB9j6I6Nbaeq2sKSRMkuQL+0drC1AWZu/5UO7UmtWb+qMxg2SIccG2M8s2jX59pg5KQYIo8M5xacP88qh92rcMCc/RQV6bcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(2906002)(508600001)(122000001)(316002)(38070700005)(86362001)(31696002)(110136005)(38100700002)(5660300002)(66946007)(7416002)(76116006)(54906003)(6512007)(6506007)(36756003)(4326008)(66574015)(66446008)(64756008)(66476007)(83380400001)(31686004)(2616005)(8936002)(91956017)(26005)(6486002)(8676002)(71200400001)(44832011)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bk9PbVRsS2ZFSW9TK3hBV0tyZ2F3Sit0SEhYYSsxbmhkOGhRNGpuOFZ4LzlK?=
 =?utf-8?B?L3RLZzRieVFIdFk5TWZDWHRZSmxkTU5qRjMzdFFmd0wxS0ZPTFB6b2trREFO?=
 =?utf-8?B?M3ZWMmM2VUQzZ1ZRMXpNdnJLRlVBTm94OGtHaUpIYUorMTJ2dkpyWERLWXEr?=
 =?utf-8?B?b2FETVBpcjRvRWMvMzFoQlBPTEZkTVdIVUF4c1N1SkZxTkZKQndUT1pScU1L?=
 =?utf-8?B?TDhCS1kxU0RHRXAyODVUdDB6QTk4eElRK3FBK1hjQThoaHVqYWowYjZFc2xT?=
 =?utf-8?B?MmpTbzI5dWxkOXpRZjBGN3A4SmpLSHFNVi85Q1dPYTNtL2Jaamt2TWk4YXlo?=
 =?utf-8?B?NnIwS2Z5L3RTdUNPYmg3aDR1WEZ5WGQxSFZMaER0T2x1MFZVd29kb0JNaXpu?=
 =?utf-8?B?THViWHpKYUJyUUgwTXgvUGkxam54eXdYRFljOS9pZkRhZGUwK2NQSUdnc0VE?=
 =?utf-8?B?UkVVN3E2b0ttNis1cFQ4ZHorUnN3KzZPMldFajU4ZEZ2bU0xRHEvTEVLMk0w?=
 =?utf-8?B?NjI0S3N3SWdjNWxyR3hhYmFzbUtjdlhaMlRFak1wRTdscko2N0piYzJ3ZjZR?=
 =?utf-8?B?N3Z0OHRhQldPZlVJdUVVdDFHeVlHZ0E3cjVhd2M1U3B0UlhweVlKdmVkNXBj?=
 =?utf-8?B?TDRFTVd4M1FOVFJOQU95VnNrL2s5bERQZHVSbms5Z0dDdzZ3SXh6SG54L3Z5?=
 =?utf-8?B?aDd5UnVLWWJtZ3RSNjlmbXFjTEJNRnZ5eWJWQmQ3dDFpeE8vdERYTUtiSWZo?=
 =?utf-8?B?WjYzektDa2pjUzU5bmIwUkZuZGJDdFFaSk5XTVc1Z0gvc0N3NmlYTThYS3N4?=
 =?utf-8?B?U2hJZ3Q3ZHpzUnlVb1VUWjJrQ0xIZ2xWdUdIOXhmcGUzb0kxTEFkLzkwZjhW?=
 =?utf-8?B?UHN2U0xUR3ZOSUcycU83Y0g4REtOV0N6WVJxYXN2YjhCVVVxTGJ4NmREN0tu?=
 =?utf-8?B?b0l2MTc3L3ZMckRLeVBLZm9PY1dMZGVMdmFUdnJQYjNWbktoU1NrbDhvVTFv?=
 =?utf-8?B?NDcrL3JObnMvUW5RUlMyeWhlSUE2ajBvRkk3NlJEYzU4OTFFQ0NSVXMzZHhx?=
 =?utf-8?B?Tk8yalRTdWJNcXAwRjFIeitnemlmbkFZOG1pbFZkQ3RSS2ZwR1NBNDExL1Mx?=
 =?utf-8?B?aHU3SkJoWThzQkdDc3JwZXNBcWY0aFF2c3BOTk5EUmtoUTVrOHdEa2lsYm93?=
 =?utf-8?B?YlBjY05SWFBOSzhRTnlSeG5RcHJEQ1ZmVFlzOWVsUXJtMUIrQ01tc1RFUE5K?=
 =?utf-8?B?bW9ZWm56Q0Uwam1ZcjJzQ1VBbW1OKzl2QzIwSmZIZDRJOFZ2cDVLRVJFTUVD?=
 =?utf-8?B?U25iaEVlTy9Cb2lwcFc5eDU0SFlqMTR2MzJXdERZcHpFUnE1RGhmNmJUSTIx?=
 =?utf-8?B?VnRla0V1bURYSDhiYWJBaklBOGl4c0FBS2wvUGNRdTUxaXZma1JGc1dFdGFj?=
 =?utf-8?B?NXc3OGpvK0RXTlZsbWM3UVhOS05scVlwY2ZUNzE3amFoZ0JrSmpyV3dZOUFM?=
 =?utf-8?B?Uy9DdTBzU3VxTXgyd01vQnd4bGw2VEUwdnhwbTBMYmQ1dEsxbTJta3A5Q3Jy?=
 =?utf-8?B?SlFJTTdIL2hmTVgxT3M4Tk8vWTRiSTdOdkR3WnlUNnZtWVlXdm90QnpwVHVi?=
 =?utf-8?B?eWNaeUljdWU5ajBQK2lXSXBtR2pqY00zZUxHeVd4OXZFMm43QmFLUkZYQ015?=
 =?utf-8?B?dWNFa2hRTm10czRjOGxvWXFaNklxZFkxTmVWRENFdnRhWTlRYVB5UjJCWDg4?=
 =?utf-8?B?clp6c09vbnlKRCtxcGNWSkZtMG5ubkhvektqTUJoUTF4cHY3dDBLQ0QvR0Zm?=
 =?utf-8?B?YXpsNHNibVozMXVWRzhKY3BKTzBhRDBpbHVEUWNINGdIbkJrS1IySkdXNFM1?=
 =?utf-8?B?OWxLd1RSNUhWWFdEZzIwcUs2MFIyRTRsT3hRVTk5ZmFOZmtwNFBqMmpLSFE5?=
 =?utf-8?B?VmE4Ryt3Q0I4OXZqNThTTFlnRzl4QlpxNWNhMnpLa2tkZjhGU0tLajJxdGQ4?=
 =?utf-8?B?YytxV1g3dTg3aFdxQ2dCYjdRcXhxYlgzMWxkY2ROa0RrTFc2aUZCcHFLN09L?=
 =?utf-8?B?SzJQN0dVajRuQjRJcWNWQXV3N0o2MVNpSjVjV1liVkQ5UjRWVkxGWU1vYXBJ?=
 =?utf-8?B?RTNJR05PNzFyVkxBWFZtSzBsWmRsTlFzMDdISURJcWIwMi9LbzdPaytpc2Jk?=
 =?utf-8?B?Zkd5NG5RQkl1c2dxQWY5dFZjdUtWQVVPYi9NcHZWRFZZUHpGR2JpRWg4Y1pF?=
 =?utf-8?Q?M3mPe6xHduae7FcXopIN6AXw3sXWj8R6Lm1+T+nLvs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <39C16BA85E9BC746AADB8F9152F030E1@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 682b45ca-7f86-485e-8cf2-08d9ec8721dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 11:18:58.1919
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CKKKCLtHv7WG/oGzOyRIY+W9ob00EKhz07fzKR/VUbd5fV2unturZQQ7V3bbLBqGPFL2dI6Hha+iQoLaKPfg3IBR1QvU6Re94PMWlUKpB2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MRZP264MB3052
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDA5LzAyLzIwMjIgw6AgMTg6MDMsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBO
byBmdW5jdGlvbmFsIGNoYW5nZS4NCj4gDQo+IFRoaXMgcGF0Y2ggbWFrZXMgaXQgcG9zc2libGUg
dG8gbW92ZSBub24tZXNzZW50aWFsIGNvZGUNCj4gb3V0IG9mIGNvcmUgbW9kdWxlIGNvZGUuDQo+
IA0KPiBTaWduZWQtb2ZmLWJ5OiBBYXJvbiBUb21saW4gPGF0b21saW5AcmVkaGF0LmNvbT4NCj4g
LS0tDQo+ICAga2VybmVsL21vZHVsZS9pbnRlcm5hbC5oIHwgMjIgKysrKysrKysrKysrKysrKysr
KysrKw0KPiAgIGtlcm5lbC9tb2R1bGUvbWFpbi5jICAgICB8IDIzICsrLS0tLS0tLS0tLS0tLS0t
LS0tLS0tDQo+ICAgMiBmaWxlcyBjaGFuZ2VkLCAyNCBpbnNlcnRpb25zKCspLCAyMSBkZWxldGlv
bnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9rZXJuZWwvbW9kdWxlL2ludGVybmFsLmggYi9rZXJu
ZWwvbW9kdWxlL2ludGVybmFsLmgNCj4gaW5kZXggYzQ5ODk2MzY4ZjdmLi4xYTRiMzNjZTlmNWYg
MTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC9tb2R1bGUvaW50ZXJuYWwuaA0KPiArKysgYi9rZXJuZWwv
bW9kdWxlL2ludGVybmFsLmgNCj4gQEAgLTcsNiArNywyOCBAQA0KPiAgIA0KPiAgICNpbmNsdWRl
IDxsaW51eC9lbGYuaD4NCj4gICAjaW5jbHVkZSA8YXNtL21vZHVsZS5oPg0KPiArI2luY2x1ZGUg
PGxpbnV4L211dGV4Lmg+DQo+ICsNCj4gKyNpZm5kZWYgQVJDSF9TSEZfU01BTEwNCj4gKyNkZWZp
bmUgQVJDSF9TSEZfU01BTEwgMA0KPiArI2VuZGlmDQo+ICsNCj4gKy8qIElmIHRoaXMgaXMgc2V0
LCB0aGUgc2VjdGlvbiBiZWxvbmdzIGluIHRoZSBpbml0IHBhcnQgb2YgdGhlIG1vZHVsZSAqLw0K
PiArI2RlZmluZSBJTklUX09GRlNFVF9NQVNLICgxVUwgPDwgKEJJVFNfUEVSX0xPTkctMSkpDQo+
ICsvKiBNYXhpbXVtIG51bWJlciBvZiBjaGFyYWN0ZXJzIHdyaXR0ZW4gYnkgbW9kdWxlX2ZsYWdz
KCkgKi8NCj4gKyNkZWZpbmUgTU9EVUxFX0ZMQUdTX0JVRl9TSVpFIChUQUlOVF9GTEFHU19DT1VO
VCArIDQpDQo+ICsjZGVmaW5lIE1PRFVMRV9TRUNUX1JFQURfU0laRSAoMyAvKiAiMHgiLCAiXG4i
ICovICsgKEJJVFNfUEVSX0xPTkcgLyA0KSkNCg0KVGhpcyBpcyB1c2VkIG9ubHkgaW4gc3lzZnMu
Yywgd2h5IG1vdmUgaXQgdG8gaW50ZXJuYWwuaCA/DQoNCg0KPiArDQo+ICtleHRlcm4gc3RydWN0
IG11dGV4IG1vZHVsZV9tdXRleDsNCj4gK2V4dGVybiBzdHJ1Y3QgbGlzdF9oZWFkIG1vZHVsZXM7
DQo+ICsNCj4gKy8qIFByb3ZpZGVkIGJ5IHRoZSBsaW5rZXIgKi8NCj4gK2V4dGVybiBjb25zdCBz
dHJ1Y3Qga2VybmVsX3N5bWJvbCBfX3N0YXJ0X19fa3N5bXRhYltdOw0KPiArZXh0ZXJuIGNvbnN0
IHN0cnVjdCBrZXJuZWxfc3ltYm9sIF9fc3RvcF9fX2tzeW10YWJbXTsNCj4gK2V4dGVybiBjb25z
dCBzdHJ1Y3Qga2VybmVsX3N5bWJvbCBfX3N0YXJ0X19fa3N5bXRhYl9ncGxbXTsNCj4gK2V4dGVy
biBjb25zdCBzdHJ1Y3Qga2VybmVsX3N5bWJvbCBfX3N0b3BfX19rc3ltdGFiX2dwbFtdOw0KPiAr
ZXh0ZXJuIGNvbnN0IHMzMiBfX3N0YXJ0X19fa2NyY3RhYltdOw0KPiArZXh0ZXJuIGNvbnN0IHMz
MiBfX3N0YXJ0X19fa2NyY3RhYl9ncGxbXTsNCj4gICANCj4gICBzdHJ1Y3QgbG9hZF9pbmZvIHsN
Cj4gICAJY29uc3QgY2hhciAqbmFtZTsNCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9tb2R1bGUvbWFp
bi5jIGIva2VybmVsL21vZHVsZS9tYWluLmMNCj4gaW5kZXggMzRhMmIwY2YzYzNlLi43NTBlM2Fk
Mjg2NzkgMTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC9tb2R1bGUvbWFpbi5jDQo+ICsrKyBiL2tlcm5l
bC9tb2R1bGUvbWFpbi5jDQo+IEBAIC02MywxMCArNjMsNiBAQA0KPiAgICNkZWZpbmUgQ1JFQVRF
X1RSQUNFX1BPSU5UUw0KPiAgICNpbmNsdWRlIDx0cmFjZS9ldmVudHMvbW9kdWxlLmg+DQo+ICAg
DQo+IC0jaWZuZGVmIEFSQ0hfU0hGX1NNQUxMDQo+IC0jZGVmaW5lIEFSQ0hfU0hGX1NNQUxMIDAN
Cj4gLSNlbmRpZg0KPiAtDQo+ICAgLyoNCj4gICAgKiBNb2R1bGVzJyBzZWN0aW9ucyB3aWxsIGJl
IGFsaWduZWQgb24gcGFnZSBib3VuZGFyaWVzDQo+ICAgICogdG8gZW5zdXJlIGNvbXBsZXRlIHNl
cGFyYXRpb24gb2YgY29kZSBhbmQgZGF0YSwgYnV0DQo+IEBAIC03OCw5ICs3NCw2IEBADQo+ICAg
IyBkZWZpbmUgZGVidWdfYWxpZ24oWCkgKFgpDQo+ICAgI2VuZGlmDQo+ICAgDQo+IC0vKiBJZiB0
aGlzIGlzIHNldCwgdGhlIHNlY3Rpb24gYmVsb25ncyBpbiB0aGUgaW5pdCBwYXJ0IG9mIHRoZSBt
b2R1bGUgKi8NCj4gLSNkZWZpbmUgSU5JVF9PRkZTRVRfTUFTSyAoMVVMIDw8IChCSVRTX1BFUl9M
T05HLTEpKQ0KPiAtDQo+ICAgLyoNCj4gICAgKiBNdXRleCBwcm90ZWN0czoNCj4gICAgKiAxKSBM
aXN0IG9mIG1vZHVsZXMgKGFsc28gc2FmZWx5IHJlYWRhYmxlIHdpdGggcHJlZW1wdF9kaXNhYmxl
KSwNCj4gQEAgLTg4LDggKzgxLDggQEANCj4gICAgKiAzKSBtb2R1bGVfYWRkcl9taW4vbW9kdWxl
X2FkZHJfbWF4Lg0KPiAgICAqIChkZWxldGUgYW5kIGFkZCB1c2VzIFJDVSBsaXN0IG9wZXJhdGlv
bnMpLg0KPiAgICAqLw0KPiAtc3RhdGljIERFRklORV9NVVRFWChtb2R1bGVfbXV0ZXgpOw0KPiAt
c3RhdGljIExJU1RfSEVBRChtb2R1bGVzKTsNCj4gK0RFRklORV9NVVRFWChtb2R1bGVfbXV0ZXgp
Ow0KPiArTElTVF9IRUFEKG1vZHVsZXMpOw0KPiAgIA0KPiAgIC8qIFdvcmsgcXVldWUgZm9yIGZy
ZWVpbmcgaW5pdCBzZWN0aW9ucyBpbiBzdWNjZXNzIGNhc2UgKi8NCj4gICBzdGF0aWMgdm9pZCBk
b19mcmVlX2luaXQoc3RydWN0IHdvcmtfc3RydWN0ICp3KTsNCj4gQEAgLTQwOCwxNCArNDAxLDYg
QEAgc3RhdGljIF9fbWF5YmVfdW51c2VkIHZvaWQgKmFueV9zZWN0aW9uX29ianMoY29uc3Qgc3Ry
dWN0IGxvYWRfaW5mbyAqaW5mbywNCj4gICAJcmV0dXJuICh2b2lkICopaW5mby0+c2VjaGRyc1tz
ZWNdLnNoX2FkZHI7DQo+ICAgfQ0KPiAgIA0KPiAtLyogUHJvdmlkZWQgYnkgdGhlIGxpbmtlciAq
Lw0KPiAtZXh0ZXJuIGNvbnN0IHN0cnVjdCBrZXJuZWxfc3ltYm9sIF9fc3RhcnRfX19rc3ltdGFi
W107DQo+IC1leHRlcm4gY29uc3Qgc3RydWN0IGtlcm5lbF9zeW1ib2wgX19zdG9wX19fa3N5bXRh
YltdOw0KPiAtZXh0ZXJuIGNvbnN0IHN0cnVjdCBrZXJuZWxfc3ltYm9sIF9fc3RhcnRfX19rc3lt
dGFiX2dwbFtdOw0KPiAtZXh0ZXJuIGNvbnN0IHN0cnVjdCBrZXJuZWxfc3ltYm9sIF9fc3RvcF9f
X2tzeW10YWJfZ3BsW107DQo+IC1leHRlcm4gY29uc3QgczMyIF9fc3RhcnRfX19rY3JjdGFiW107
DQo+IC1leHRlcm4gY29uc3QgczMyIF9fc3RhcnRfX19rY3JjdGFiX2dwbFtdOw0KPiAtDQo+ICAg
I2lmbmRlZiBDT05GSUdfTU9EVkVSU0lPTlMNCj4gICAjZGVmaW5lIHN5bXZlcnNpb24oYmFzZSwg
aWR4KSBOVUxMDQo+ICAgI2Vsc2UNCj4gQEAgLTE0OTAsNyArMTQ3NSw2IEBAIHN0cnVjdCBtb2R1
bGVfc2VjdF9hdHRycyB7DQo+ICAgCXN0cnVjdCBtb2R1bGVfc2VjdF9hdHRyIGF0dHJzW107DQo+
ICAgfTsNCj4gICANCj4gLSNkZWZpbmUgTU9EVUxFX1NFQ1RfUkVBRF9TSVpFICgzIC8qICIweCIs
ICJcbiIgKi8gKyAoQklUU19QRVJfTE9ORyAvIDQpKQ0KDQpUaGlzIGlzIHVzZWQgb25seSBpbiBz
eXNmcy5jLCB3aHkgbW92ZSBpdCB0byBpbnRlcm5hbC5oID8NCg0KPiAgIHN0YXRpYyBzc2l6ZV90
IG1vZHVsZV9zZWN0X3JlYWQoc3RydWN0IGZpbGUgKmZpbGUsIHN0cnVjdCBrb2JqZWN0ICprb2Jq
LA0KPiAgIAkJCQlzdHJ1Y3QgYmluX2F0dHJpYnV0ZSAqYmF0dHIsDQo+ICAgCQkJCWNoYXIgKmJ1
ZiwgbG9mZl90IHBvcywgc2l6ZV90IGNvdW50KQ0KPiBAQCAtNDU0Miw5ICs0NTI2LDYgQEAgc3Rh
dGljIHZvaWQgY2ZpX2NsZWFudXAoc3RydWN0IG1vZHVsZSAqbW9kKQ0KPiAgICNlbmRpZg0KPiAg
IH0NCj4gICANCj4gLS8qIE1heGltdW0gbnVtYmVyIG9mIGNoYXJhY3RlcnMgd3JpdHRlbiBieSBt
b2R1bGVfZmxhZ3MoKSAqLw0KPiAtI2RlZmluZSBNT0RVTEVfRkxBR1NfQlVGX1NJWkUgKFRBSU5U
X0ZMQUdTX0NPVU5UICsgNCkNCj4gLQ0KPiAgIC8qIEtlZXAgaW4gc3luYyB3aXRoIE1PRFVMRV9G
TEFHU19CVUZfU0laRSAhISEgKi8NCj4gICBzdGF0aWMgY2hhciAqbW9kdWxlX2ZsYWdzKHN0cnVj
dCBtb2R1bGUgKm1vZCwgY2hhciAqYnVmKQ0KPiAgIHs=
