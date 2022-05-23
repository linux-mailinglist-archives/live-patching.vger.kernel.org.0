Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFCC5309D3
	for <lists+live-patching@lfdr.de>; Mon, 23 May 2022 09:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiEWHIR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 03:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiEWHIQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 03:08:16 -0400
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-pr2fra01on060d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e18::60d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F007E644CB;
        Mon, 23 May 2022 00:01:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dA6pT0GPrQTZEV3Qx9QowTAUoUC7co0tybDZkFzRUoWWY3F4t/VcmT2BPVMaVfoxYEwfZoYDz1YX4Or2xfmx3a15pivUm7yKmDFcy8USFngf3mBLoSRHi3SskHewqxD/Sr4yjXsto6RQR0AnWE1XjWDNHA93rU8OJL2bQzkAF4aiXtPMfEab2EdbJiJ2PE55ZMz3Fg9oHnwTyZEi2NbzZVsalZwmYsmeSkTKtd7+jKEayXyeCQNu4LwPfYajFO7Nfikr6LMtICVR4V7jV532CNJu6z8/uZyB4blKt4mHOO4q7OcuKc1JpNtVctV4BkF7AAoS/8qojfB+OwGv6PrDnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDHo8F4M8OiD6rdVgokb3VrHgz1GgeMkPtkph7yCv7I=;
 b=AbCiVmYdcYn4p7YqpN+MilvP0AfXKamq1/vbwgbeG1LXMc02D7M4LbVX9CEDVxc5ztIULFcO8niazNgnHL1nenq0FeBvudv5IHaqv8+ZXbX9FlLwcoqEdLsCDj7trgkwosN+WGaueCPPWSpEBql4PPD87IpPgMGF2wgetj3qQt38bBDKLahXARBHlimh9Hgp9fdjhFEzzEtlPARl2HnssBt5bi8Gs/klzY52CTwwmoBixPxz/KesZ9Sa5RzKquROLtbukxo0w7ehKt2JsOBrEghTp1ZI3UnK6Rw8voUxAA3/uAyr30FnMf12xMF/JVfb7IKFPuQ44VUae8tYSGlTIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR1P264MB3845.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:250::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Mon, 23 May
 2022 06:51:47 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ad4e:c157:e9ac:385d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::ad4e:c157:e9ac:385d%8]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 06:51:47 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Petr Mladek <pmladek@suse.com>
CC:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] livepatch: Remove klp_arch_set_pc() and asm/livepatch.h
Thread-Topic: [PATCH] livepatch: Remove klp_arch_set_pc() and asm/livepatch.h
Thread-Index: AQHYQmzcVzwq4WZnpECFcLJ2vYLmSKzWOdSAgFYkdQA=
Date:   Mon, 23 May 2022 06:51:47 +0000
Message-ID: <e1840187-6032-9f75-d7a8-b2b2fc5cbb58@csgroup.eu>
References: <e029c7cfde436f6bbf99148ab14dc2da99add503.1648447981.git.christophe.leroy@csgroup.eu>
 <YkLsEUgxJkYbLZ7Z@alley>
In-Reply-To: <YkLsEUgxJkYbLZ7Z@alley>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c527bfdb-f78c-4be0-1fe0-08da3c88b501
x-ms-traffictypediagnostic: PR1P264MB3845:EE_
x-microsoft-antispam-prvs: <PR1P264MB384520A6C5C2CA586ABF6431EDD49@PR1P264MB3845.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bE/76ad/J78vkdb2LMCK7qPvMC22p/TmUMk6i8dVPu5vn1lxvhMEbxkgpEWdtADCEDE8ys7X+w2+OYMUkGwcll0KyinoxWXdwE1YwaBd7ysdBFKhB0VpqUdKGdsiaYe3IR4+P3falGKubN0fAncEQUUVOm3kLrpcZTj0DOYATlPf8aZXbfUlw2sK8yAqCQ6MgvfpBWaEC8Yopn2mJ5f9ScmhS6eE0mN509IG9sRo/3rdFdABS4/d/JheU+euVKL8iP7v2cIjTljAUFtgPQzf3PW0pB1rxiLRPxhTmI23FGvSUvnyXmMhObRaKxH9UsHAZXu2JBKgsPJs/usVkx8PeHPS33tdxkcxUlF+aJgwBEonf6Yrh8iM+X+HN/tgwN6ifUF+aezAdNZxL6k3YPXtdOdJicmNB/aVA6uNOiUR2y6Zo/jpEFAM3Qx0jthX+BO4SMLWBfA5bl8NvToc7BPiEEjd3dy/8NzOJako/QTC94ZXYilvOw5qQl0OZiN5Y4T5rFJ6se2o6QNAMVdgL6mwSXc1PsUiZ1BC+3cqw3lAfYa9APwygORWGkAux3LGrzcbrrBLGO53+w43YCsNaW+jR0WTom8Mx+pdq5VNMno+Fkn3EJB95X7zft6pzREq6l5UCa7O4A8Brk2H4qmIcyS0A2Eu+svikjFVUjj7l6bK6V39r0bW5GxHt8vr9lpKcTHDejbpmkxAgQ0UfUrDwetz+7jkF3jB+JkZ9vaSal0b5SmqMyrjxskM34Ew7c0jo0oOvIZnYQmurrew13R6+TKeaA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(36756003)(66574015)(2906002)(5660300002)(4744005)(31686004)(7416002)(38070700005)(122000001)(38100700002)(44832011)(31696002)(316002)(54906003)(6916009)(186003)(8936002)(66476007)(66446008)(64756008)(66556008)(8676002)(66946007)(4326008)(76116006)(91956017)(26005)(6512007)(6506007)(6486002)(2616005)(86362001)(71200400001)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?clFlNFNuZHFJRWROSVlmbFY5TnZUSUFmdUdIWHM0dDJVeGFDTCtVc2RNQ0sw?=
 =?utf-8?B?WjYyeTN6RE1vMmFZWmRGamhFNjVXaEN6UlY2UGtiek9icjEzSmhQWldQRWNw?=
 =?utf-8?B?VHlnVWk1SmpqdW1COE9xVDZrY25maXNBVXFJYkdWK3FKM2hpOEVvL04yclBL?=
 =?utf-8?B?WUYxSDV1N08zYXJBYjFadTJ5L2N3UXk1OHI3MFN2Y3hnTjJxTUJFN1AxMTBs?=
 =?utf-8?B?VVZCV3RIRGc4L2tKbmhQQ0VPVFdDaVFMM3lTMTB2UkVUUGtwb204K1U4N0tI?=
 =?utf-8?B?U2IwNk1FSlFNTFRZbWdGQXB5K1YxRVRNbWZaTVM0dWUwa1g5cTFXQjV6TlU0?=
 =?utf-8?B?TmZUZjRIN242QzBFS25yOUd1TEVMNFdIdDV1ZlVqY1BTZmlHRnczQmpiajBp?=
 =?utf-8?B?N2ZPWUYvSkkzNFpwNUt1QU9kTlAvMEFVaFR2WmY4QkdpckFTb1ltMlMwM3Jy?=
 =?utf-8?B?QjhpalhpSDR0TzQ5SVZTMlk1aVdvZkxTVWliNWgxZ2sxZGxnUk1Wdk8yZUR0?=
 =?utf-8?B?azB6Z21janNoaGo4SHowUm9MRmJsQXhteTMwRDVTMVNmSFdBYW5mV1JZdzBF?=
 =?utf-8?B?NGpCNHVJWXk0anVvcXU5eGxHUVNJRXkrQmczdlFZa3ZwMCs4NzQ5YzNyaUdk?=
 =?utf-8?B?L0tzTnVoK2ZiaWJDTkNHT1dKN3VVT1JFQmsvNzhwd2ZNbzJDVE9wUFBBWkx4?=
 =?utf-8?B?NG44TXNyeTNiK2NLelZQaS83U3ExbnAwbkdibjg1eGlsQmJUdW50ZlkxM0lT?=
 =?utf-8?B?MVlzOXBLRERmVjV3b0J3MGQ4U1ZKcEhpQ0Yyd2V2cnl5RFRSc0RkenRBTjhj?=
 =?utf-8?B?cDBkMFhOT0hUbkZXZGdzQWxucEovdmxvOVVRRUFzR1EzVmJqMjZ2eXFGL20x?=
 =?utf-8?B?QklnMERDUmNvWTFuamhKL0ZFaE16WFlXVHBITVM2VHVRWXZWR1hyU2lnVzcx?=
 =?utf-8?B?dTdUWXhXU3hPL0xQYWJWaDRvWlBST3V5aEdWc0tObzhtV2N5RDRqOUZvZnZN?=
 =?utf-8?B?QVdxQVJrM3JxUzkveVFleW04NFI1RVFIdEsxYjBMaG81eXZBa0J4WjVQcW5I?=
 =?utf-8?B?L3hwaTlxWUU3U2pKMWsxOGJZaC9OdHN0VzVuWHoybDErSmxVOG5aSlhZT0th?=
 =?utf-8?B?SkM1eUVZdUhVKytaVEcrUzc4NVR4WThpM1h5cjlCTzJuVjl5V1cyaUNCdWVU?=
 =?utf-8?B?UmtqamJOUGxCWm9hVmVFbHp0RzhyajNRVEkzbXVwaGViWEZoOGdYTWhDM1hP?=
 =?utf-8?B?Yjd5RmlqTG9LeDZqVitacHEwSWI4OVVML3hweW1mNkJiRUptdVdlT243Q2Mr?=
 =?utf-8?B?bnpUSUVjNDNYLy9wQSt2WkhqTXBhUXZmY0IxZHAwL210WEd5UXpDWkVGeHpC?=
 =?utf-8?B?UkVyc1Jqb0dhdktvN2t5WkNxdFZkRkFMd05PYURxNWtSbzV0QUVCU1FHNTZO?=
 =?utf-8?B?eW5YdUFycU42ekRxTTJZZTBTTVBhVjNKT2JSL3NLYnlacVI5MFZsVHRtMXl1?=
 =?utf-8?B?blFOTjVrRkhYQ0M4WU1nVW9YdmMxSjJ5OVdFZzdWQXQyOHVWdzRzdE02Zm13?=
 =?utf-8?B?QUVBN1dadFZIVThXc1V1bnNWQkJ1Mm9PMXZzeWZ2ZkEzQTVhbHB5Z0V6L01o?=
 =?utf-8?B?SVlKYU5icjJaU3VsYlNHRVJiTndrOFR3MmFjZFNxdDVpenhWZFcwVzFST3lR?=
 =?utf-8?B?TmZrVWdmT0dmRkg1eWR2SURrcTdWdXZ3QjQyUmdPaDRiS3g0K0lWekJYU0li?=
 =?utf-8?B?MlZlYVdDT2lRazdlSmRnOG5obEg5VkhJcDZrMUJ3VVo5aVI2TFQ3cHlCMmhw?=
 =?utf-8?B?ZWZzTzc2QUxIN0FsOVFmSmNUZ2ltTmtFVy8rSU1QUDFTelUyVVNzZkxlQXAr?=
 =?utf-8?B?dFRnVEtSdGp4WFNVbSt2OG4vKzdIQ3g2dzRUNXNYZ09uWFROQTBXWkxjSGU1?=
 =?utf-8?B?ZEovWW5JREVHbzVhQnI2cGUwejM0LzJiNHBlUXU0Z0h2NDFaTVVaWDBNZTJr?=
 =?utf-8?B?YzhIbmZCWGlGNWM0cG8zNExNWWJzaVBXWUdVajFKeFpnN2NQNFdGL21jNFF2?=
 =?utf-8?B?ZktzZmV1RTZoN0txL0Z2cERGR1ZZTmtMdHBqV3plTFl6YzZOT1o0YnJoclU0?=
 =?utf-8?B?SGxyN3draENpWUV0MVdwQXZuQXIwelJLeE5FNUpLOGpJTUxiTHhvaE1iY0dC?=
 =?utf-8?B?UEZ0OEljUERockNNeWFxRXNHb2s5Vm1OUGZTRjE2aEJrRGdrcTBZTG5xU3Zt?=
 =?utf-8?B?TzU0VlZEYk03UEZ2R1MxdWhvNkxvdTBlNzdqNHZBRDJtdy94eTU3MjhkNktF?=
 =?utf-8?B?ZDdFc3NCVW1jcEloMHFoY0MwcWJxSmlFVVorRGtFTXZyUHFJbHQ4cU5oV3dP?=
 =?utf-8?Q?afFtHpymTs7VSESLFkUg/jQTaHj0YguUP0iR2?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7C58D048D7717244B5E5F3EBE980332C@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: c527bfdb-f78c-4be0-1fe0-08da3c88b501
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 06:51:47.6003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qxw7U/lymAidckQGiYHVAHuYT9xyTs+0XLn49yQRgsK5B3PdfVGF+ELvjYOKOE9k0dy2XXCqXFsmD2Zyg7TXTXeGWIWMydI8mgcPHOhyXEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1P264MB3845
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDI5LzAzLzIwMjIgw6AgMTM6MjIsIFBldHIgTWxhZGVrIGEgw6ljcml0wqA6DQo+IE9u
IE1vbiAyMDIyLTAzLTI4IDA4OjI2OjQ4LCBDaHJpc3RvcGhlIExlcm95IHdyb3RlOg0KPj4gQWxs
IHRocmVlIHZlcnNpb25zIG9mIGtscF9hcmNoX3NldF9wYygpIGRvIGV4YWN0bHkgdGhlIHNhbWU6
IHRoZXkNCj4+IGNhbGwgZnRyYWNlX2luc3RydWN0aW9uX3BvaW50ZXJfc2V0KCkuDQo+Pg0KPj4g
Q2FsbCBmdHJhY2VfaW5zdHJ1Y3Rpb25fcG9pbnRlcl9zZXQoKSBkaXJlY3RseSBhbmQgcmVtb3Zl
DQo+PiBrbHBfYXJjaF9zZXRfcGMoKS4NCj4+DQo+PiBBcyBrbHBfYXJjaF9zZXRfcGMoKSB3YXMg
dGhlIG9ubHkgdGhpbmcgcmVtYWluaW5nIGluIGFzbS9saXZlcGF0Y2guaA0KPj4gb24geDg2IGFu
ZCBzMzkwLCByZW1vdmUgYXNtL2xpdmVwYXRjaC5oDQo+Pg0KPj4gbGl2ZXBhdGNoLmggcmVtYWlu
cyBvbiBwb3dlcnBjIGJ1dCBpdHMgY29udGVudCBpcyBleGNsdXNpdmVseSB1c2VkDQo+PiBieSBw
b3dlcnBjIHNwZWNpZmljIGNvZGUuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoZSBM
ZXJveSA8Y2hyaXN0b3BoZS5sZXJveUBjc2dyb3VwLmV1Pg0KPiANCj4gQWNrZWQtYnk6IFBldHIg
TWxhZGVrIDxwbWxhZGVrQHN1c2UuY29tPg0KPiANCj4gSSBhbSBnb2luZyB0byB0YWtlIGl0IHZp
YSBsaXZlcGF0Y2gvbGl2ZXBhdGNoLmdpdCBmb3IgNS4xOS4gV2UgYXJlDQo+IGFscmVhZHkgaW4g
dGhlIG1pZGRsZSBvZiB0aGUgbWVyZ2Ugd2luZG93IGFuZCB0aGlzIGlzIG5vdCBjcml0aWNhbC4N
Cj4gDQoNCkkgaGF2ZW4ndCBzZWVuIGl0IGluIGxpbnV4LW5leHQuDQoNCkRvIHlvdSBzdGlsbCBw
bGFuIHRvIHRha2UgaXQgZm9yIDUuMTkgPw0KDQpUaGFua3MNCkNocmlzdG9waGU=
