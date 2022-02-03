Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A3E4A8B55
	for <lists+live-patching@lfdr.de>; Thu,  3 Feb 2022 19:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353283AbiBCSP4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Feb 2022 13:15:56 -0500
Received: from mail-eopbgr120055.outbound.protection.outlook.com ([40.107.12.55]:31361
        "EHLO FRA01-PR2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229634AbiBCSP4 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Feb 2022 13:15:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AIpUaoL5bZFYoBGh4f8xqDDQSSwIlm5zHaO8T9sK28+p30LNheaIEqMhOzde6Iyh5sStk9sVxhUHuK4xUkWgfO+BfpNQczWOxdt8Me9WVjHwgZEyvaX5OekUb3LEPHUBS67T3NXYU4BpR+TpSHXClBeUdCTpKrcsg4VQxpRiQtIv3eOjElCfWbdjzoHC2rupfl1sKpaDybuxwAMe3Im45JrZY19vDiuChIvmk89+d5QwqozL083hHzsgNqP+xXmH+WzWaCRmN/IzKdpdiM+9Utmq8/KqjIIGNWzk8Axwa2OWdrDeqeiZ3KbIafgxXfos4QQyz7STo49ScYgiU2Hftg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VyxLsvgaie6maUF1hKUEJkiUbrwwaEoXpNtpoXTgRQU=;
 b=b2EhtuCH/wmgp1Qd2r29+x+fL6v6lxpOWotjIXGKdDZttlBQsmzhdnhQCMa9Svk7l/deu0ui5p4No4Pi4HkXAJaLgEus0FPztlTgb6LaSOpmDOL/N80NEtLSFYec7+uQaGRVoC+hLl720AYNl+4F3Dh3oE3aAOghI73lRfU6LO4uEClHhJEfNWU+Hlp8eyLyGmkU1ohhA+nH0F8BypvaCGD+exI20j3PeSofJQ/Y4NUU690OelflTktw9pVFL6g4Xo/ubEL0E6jp2DSeI83QTGS3dFi6hiuX7hnMllUvDPqs2AW2wpJuWhrkV9Ep63Lx6UV1m3vI+PvErTCNW4uW+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR2P264MB0719.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101:d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20; Thu, 3 Feb
 2022 18:15:53 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%9]) with mapi id 15.20.4951.014; Thu, 3 Feb 2022
 18:15:53 +0000
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
Thread-Index: AQHYGJPj0SgwpYxqsU+2qmwMGXXo0qyCIv8A
Date:   Thu, 3 Feb 2022 18:15:53 +0000
Message-ID: <be5db28e-ead0-4bed-d826-06ffba1e96f7@csgroup.eu>
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
x-ms-office365-filtering-correlation-id: a14308ad-ed7c-4316-c499-08d9e7413703
x-ms-traffictypediagnostic: PR2P264MB0719:EE_
x-microsoft-antispam-prvs: <PR2P264MB07194E966517F05116BC4E47ED289@PR2P264MB0719.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dHzXU9mEGRfjXhxw4slRrAWk9qTCFpT41s1OtPvVHVXcQnJ/sbeIzCGiSeoaCDGtNwCBOOsYEypThmPYSZgPfrUnB26R+OjJptMHbhrkzGAQwfTDdIGogeiloFjwI4+GWPucJxNNOok8B3GU8+yzs2y4xTP8CNv6OXyGVaXR+8s3o5wiM4y4oQ/VFlye/eV7s0KOgpADleBj5vrHTR8DilUh63mnIA8gz9yEI2l6+RkUJ+yNCb9Ut1G30vuxT2mGky83lUizUj3WINoYnG7xFm87ZOWI0rIXF6LFmUc4Mm+TmbnKgLwWkBBg8CJijSKuNkT+LE8iVP0joyIV/8DdVaTU7M3/FyvNod935kY8LEIfRNLx8ywGyNsURpsf2OHzUmKIFxpmyjb33ERit9WzFY7uOgki0G+NnVQUZse3QBQGPNeF0xsBVAaO+E+/bSQG3nS1LUgU51el98Mw0C+zB5o16QchT1wv7/xoIyLXYreuTIfRogWIdX/LJpFIdewg24y308WkGk4jt5LmWhA0GBgFepDHzTxk910dMec1pmzZGj3famtmSPRZhslkEvyJfwvImzdK/nvQPEEqCAWzJev8EJbRoz6Z3B87372IMOXI7SuGTyKJ+5vmQ8J3a6Xu3EwL/Ux+ZUO72XVxB4ZKyn78q2QwVZp6aewo+lJXUEf9bHgOzhs6a6k6n4RKqQzny69zB2njuAXM7qf8wbDAPMnF0Kj7ImII6vQmTAT1qhRSTOl210tlfi2Qt/dV0Ns3gm0lLUNqA3XfVeIGoRO4ew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(44832011)(64756008)(71200400001)(186003)(2616005)(2906002)(66556008)(8676002)(508600001)(6486002)(4326008)(7416002)(76116006)(91956017)(26005)(8936002)(36756003)(31686004)(5660300002)(66476007)(66446008)(66946007)(122000001)(38070700005)(38100700002)(31696002)(54906003)(316002)(110136005)(66574015)(6512007)(6506007)(4744005)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NnoyaTNRcURQenpuMzlVNUVScUFKbUxOUzVxRFJ6MlFJVzNHWU92ZzhQTEFP?=
 =?utf-8?B?NVVsQncrb2pVMmdKeEZoVGpFTy9MM2oxYzVDN05jcVg4c2owcnl0aHZJUFE2?=
 =?utf-8?B?Tk9oV3NHS1poMCtzVkNoUWljVkdRcU5KUEd5NHIzaHVnNW9WVDZkUTQwc1Q1?=
 =?utf-8?B?VmxxY3M4REFXcWR6S1lJM2ovOFU3NWNuTlRDQzhUaTBocXIyNW0vNVVqbE1Q?=
 =?utf-8?B?V2t5Zm9uL0hGN2dLOTFXSll5TmJjVE9USWVteTVjMithMGNDcjJFQVJiUjB5?=
 =?utf-8?B?bmRvMm9xazdkVCtzZmJ6S3ZOaFNtLzRPSTFLYmtpTk8zVzJvVkhTVkNac3kv?=
 =?utf-8?B?YURxUnJHSDhUaTZpMktxMW56cU1EQjRsK3d5d1lvdVQ4MjU4MDNNT2dqeUVR?=
 =?utf-8?B?WVlVaU9NMk5kaVdwRnh0ODhYbC9NRWhXODdjZi9GQ1BpMHh0QWQxVWhtMXAr?=
 =?utf-8?B?TnhGOCs3ajVZTG96ZFB2Y1ExNFA0V3k5cUdXVHVRallIMFpwYnE1WjFObFRB?=
 =?utf-8?B?QWF3NDlWOFZOT1dDUTYwS0EvT3cvdkUycmNMUmM0aVJTUWlBWndYOWhBbUpk?=
 =?utf-8?B?NUh5a3BZLzd4R3ZQdnB2aGQraEdVaVZ2a3NVU2psVFZzMXlKRXdTTGtuVXk5?=
 =?utf-8?B?WVhuN3ZnZ3BURjM1Y1p0d1Y0aGxtVTFwRjNyWWtMMU5mTW4vTXBSbU53QTBG?=
 =?utf-8?B?WHp1TnZhQWdiZ2ZhV1FPbFZEVksySjZWb1d1T25HejllWWxIbTdtRDdGV1pB?=
 =?utf-8?B?T01RTUJjaS9uRXdYWUhVYmdrcnJZRFdHNTJqRTA2N3BJd3hzbHk0RjVXa2ZD?=
 =?utf-8?B?ZUlManQzMWljRDZScERzemwwZmNYL1p1dGdqaXpHcEpXaVBGem5iSUhiazJh?=
 =?utf-8?B?Wk94VEtNcTJMWTNYT2tJWGl6Qm14SkFsUFNOK0hTWW16QVcwdWpsWWYyQkZN?=
 =?utf-8?B?QUtOSU41RlIvQnF1OCt5aDZFQWh3eVR6V2RZdkJxbmlrT2poRlQ4cVlrNFBO?=
 =?utf-8?B?dmFlN05sbS94ZlVYWi9nTVNrNU5iQ1pxMUVBVWhhbGJtcysvcEY5Y1RsZmo4?=
 =?utf-8?B?OGlNaHJzaGxQckhEZTJOV1ZSMGpVR3VoT3R5WGdsQUlCais5L3hZRG5QVHJX?=
 =?utf-8?B?eVRYSFA0d1RpSmFFU0JwbGpiV0JzQkdsYU0vaEEzVExmSWpyeVY4Z0ZBZnhK?=
 =?utf-8?B?UHdsOEl4cnhRWVhsRUl5d0lTWW5tamZoTS9MQXNSWjV0RUk3Sk5QWDU0N2Ra?=
 =?utf-8?B?Vk4vOVhwTWNBbjkyNTVGUkJDMDh3eTJDa2F2cEUzNzJ1dURJZEtWcWk4djNS?=
 =?utf-8?B?SHA0VkpLWksyTkplVHB6QS9HenBxK1dBTEVXY0N5WXQwTVFzNVNSNVhiMDh0?=
 =?utf-8?B?TVQ1YVRKUFhtY2NSU1EwTk41K3RjeHd4bndSbHdhZ0hzRTYrZjBZVFRmWFU2?=
 =?utf-8?B?UCt1dWVxY0J6cjJMalVVaWw3aXJOemVLTlRsdHUwQnZ3THdMRzRhMlJVUHRS?=
 =?utf-8?B?anNlOStVK3F0VHV1cVpuWG95TnEwRGx1Snc3UFhUbHMrOFBDRUJMeUxHOHNP?=
 =?utf-8?B?a0pVQXN6dEhTU3dHZmN2ZEQ4VXh6eTVEbGI3TkVES0w2eVN6QVVMVVM3Z0E2?=
 =?utf-8?B?SWtLYWg1YnFFNTNNaXdpbWVXZFpURnlJd0tZTXh2UGRHM2h4ZVZ6czBVbDQ5?=
 =?utf-8?B?eUVjcDdNL3Vxc015ZGhkQjZHRVRKZEZ2SGFKa0xRVnBEWU1mMzkwRXh6RHo5?=
 =?utf-8?B?MmJhK3pGNlZDNXV4di9DQjV4Rmt0VHU0UURwR2ZQdFRwTy9NK3I3VnRkSFU1?=
 =?utf-8?B?R01MVC9kclIyaERvYUFtdFlHVDJhb3c0bzZaYW5NejF1T3FmbUtzcEEzS2sv?=
 =?utf-8?B?QVhmV2FkWU1Ia040c1YvZXpzQ3lndEVFMEx6bitiRnoxdG04dmZ5UWh0Sk9t?=
 =?utf-8?B?UVhDT2s0RStZUUZUNjVuSGN5TFdzZnpEemJ5ZHRUaXUzb0tSSzNTdUw0UlVx?=
 =?utf-8?B?UTZHN2hLUFdVTEM5Nk9zYzUzTENZOU1jSVRsVDRMZFp6dEhwNDJBM09LWmZV?=
 =?utf-8?B?dGh3aEJSdDhpdmhNQk9SS2h3NHplUjVCUlI5UGZteXVTRTZWTEUwS2xYK3c1?=
 =?utf-8?B?UHdYeFZITEZ2TFJHbUk4REZNZ250TEZhZUROWDFwc1hRYjRlTjRyb2VQbGZm?=
 =?utf-8?B?aytsVlpBT0trRG9GRUxXYkhCWS9FV3ZKR0pUOTB3MnFCWnpZZE44cUIxY2Vs?=
 =?utf-8?Q?g2vDENRYTlU1gXV5LYzonqMNLbOc7v0YrBuhavXAKo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BAEE0369B9901E4C81AE10D6EB0DB542@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a14308ad-ed7c-4316-c499-08d9e7413703
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 18:15:53.0739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tsneHECe+oAGTFc1s/STOQ042TNu36TGV5lPz1gWIOCOPAge4rfFXQbk0QeRflYxfKV+28d547l7LgI5T+yc+4rci6bpR/LZdGHV2azmFxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR2P264MB0719
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
bWUga25vdyB5b3VyIHRob3VnaHRzLg0KPj4NCg0KSSBhbHNvIGhhdmUgdGhlIGZlZWxpbmcgdGhh
dCBhIGxvdCBvZiBzdHVmZiBsaWtlIGZ1bmN0aW9uIHByb3RvdHlwZXMgeW91IA0KYWRkZWQgaW4g
aW5jbHVkZS9saW51eC9tb2R1bGUuaCBzaG91bGQgaW5zdGVhZCBnbyBpbiANCmtlcm5lbC9tb2R1
bGUvaW50ZXJuYWwuaCBhcyB0aGV5IGFyZSBub3QgdXNlZCBvdXRzaWRlIG9mIGtlcm5lbC9tb2R1
bGUvDQoNCkNocmlzdG9waGU=
