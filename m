Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6B132E5A
	for <lists+live-patching@lfdr.de>; Mon,  3 Jun 2019 13:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfFCLON (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Jun 2019 07:14:13 -0400
Received: from mail-eopbgr60091.outbound.protection.outlook.com ([40.107.6.91]:27527
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727851AbfFCLON (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Jun 2019 07:14:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mXsAcUf797r8+j8jrJPW7ae/xpBUg2uU7I95I6tXRYw=;
 b=iCZ6dbxGmbRaMTzfvCUXna8bMVFkuxq9n8Xn6V+vyFXEKXXEXk55x5bNHZGpAIXQ8BFsOP4Tk/cHtQGLw/pMzcG5NZQpTC+QmgyDQJ9BA3pNjRBz3bviUIY3QahXhCTh73O4DeGadJ0Y8sy55zrh3Y5DwrnNx2iqrpkU1OqE9cU=
Received: from VI1PR08MB3294.eurprd08.prod.outlook.com (52.134.31.11) by
 VI1PR08MB4607.eurprd08.prod.outlook.com (20.178.15.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.17; Mon, 3 Jun 2019 11:14:08 +0000
Received: from VI1PR08MB3294.eurprd08.prod.outlook.com
 ([fe80::f020:b78e:363d:dac6]) by VI1PR08MB3294.eurprd08.prod.outlook.com
 ([fe80::f020:b78e:363d:dac6%6]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 11:14:08 +0000
From:   Evgenii Shatokhin <eshatokhin@virtuozzo.com>
To:     "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Reducing the number of ELF section in the livepatch modules
Thread-Topic: Reducing the number of ELF section in the livepatch modules
Thread-Index: AQHVGf126Wb7w4ynSEaq5gMhcsBa3w==
Date:   Mon, 3 Jun 2019 11:14:08 +0000
Message-ID: <7ae3d164-1717-e41b-0683-1779f0e666f2@virtuozzo.com>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0102CA0015.eurprd01.prod.exchangelabs.com
 (2603:10a6:7:14::28) To VI1PR08MB3294.eurprd08.prod.outlook.com
 (2603:10a6:803:3e::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=eshatokhin@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [185.231.240.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7ef5d831-ef71-4d95-9972-08d6e8149913
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR08MB4607;
x-ms-traffictypediagnostic: VI1PR08MB4607:
x-microsoft-antispam-prvs: <VI1PR08MB46077583D16212C7E20AC2D2D9140@VI1PR08MB4607.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(396003)(136003)(346002)(39850400004)(199004)(189003)(2501003)(71200400001)(66066001)(71190400001)(68736007)(2351001)(8936002)(36756003)(3846002)(66476007)(2906002)(81166006)(81156014)(8676002)(73956011)(66446008)(64756008)(6916009)(31696002)(86362001)(6116002)(66946007)(66556008)(6512007)(5660300002)(478600001)(25786009)(5640700003)(256004)(14444005)(53936002)(31686004)(6436002)(6486002)(186003)(316002)(486006)(386003)(305945005)(7736002)(2616005)(476003)(102836004)(99286004)(6506007)(14454004)(52116002)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR08MB4607;H:VI1PR08MB3294.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Kcp9nTs0GQk+p5JaVcB3B3oGlJ7T+OGC71c9ZgxjvaBe1/GRhUtmXY4KOkAEh0vlIes7myQW0uXvd4hr93A+n/dt2mW5RCmzE5CkdSX7AiGmyGf7PgNcsK+jHHj5hqtliPT+iGm1bCenB8a3Twiue9QGXWRYpKg7IiLyfhv+nzPx0fywpJje1nnan4zL8uB6dQtOXFWKqdqucZrJp4BrWl4WfeE3YMnHur3WaebF0l94Ooy19+jbg4OjVX+04lM3IE1dIDbYW7XTHCLaW/7pjLfQpZnX4zSeu1wRf6zkxAie6Qpnxt8kuOzbldGqQImkRvYgTEbj9T6CGyLhZqxyVvz+lwDcDevjbsm/Oko2qtPVHo52RbQOToysY950Lz0hZehePHZjFFCiO34l4wwdgRYCrj9wOnQRdoo43+nDJdQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86140D55A3C12342AD75DB6B643BEB69@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef5d831-ef71-4d95-9972-08d6e8149913
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 11:14:08.7400
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eshatokhin@virtuozzo.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB4607
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

SGksDQoNCkl0IGlzIHBvc3NpYmxlIHRoYXQga2VlcGluZyBlYWNoIG5ldyBhbmQgcGF0Y2hlZCBm
dW5jdGlvbiBpbiBhIHNlcGFyYXRlIA0KRUxGIHNlY3Rpb24gaW4gYSBsaXZlcGF0Y2gga2VybmVs
IG1vZHVsZSBjb3VsZCBjYXVzZSBwcm9ibGVtcy4NCg0KRHVyaW5nIHRoZSB0ZXN0aW5nIG9mIGJp
bmFyeSBwYXRjaGVzIGZvciB0aGUga2VybmVscyB1c2VkIGluIFZpcnR1b3p6byANCjcsIEkgZm91
bmQgdGhhdCB0aGUga2VybmVsIG1heSB0cnkgdG8gYWxsb2NhdGUgYSByZWxhdGl2ZWx5IGxhcmdl
IChmb3IgDQprbWFsbG9jKSBtZW1vcnkgYXJlYSB0byBzdXBwb3J0IHN5c2ZzIGZpbGVzIA0KL3N5
cy9tb2R1bGUvPG1vZHVsZV9uYW1lPi9zZWN0aW9ucy8qIGZvciB0aGUgcGF0Y2ggbW9kdWxlcy4g
VGhlIHNpemUgd2FzIA0KMTYgLSAzNSBLQiwgZGVwZW5kaW5nIG9uIHRoZSBwYXRjaCwgaS5lLiAz
cmQgYW5kIDR0aCBvcmRlciBhbGxvY2F0aW9ucy4gDQpUaGUgbnVtYmVycyBkbyBub3QgbG9vayB2
ZXJ5IGJpZyBidXQgc3RpbGwgaW5jcmVhc2UgdGhlIGNoYW5jZSB0aGF0IHRoZSANCnBhdGNoIG1v
ZHVsZSB3aWxsIGZhaWwgdG8gbG9hZCB3aGVuIHRoZSBtZW1vcnkgaXMgZnJhZ21lbnRlZC4NCg0K
a2VybmVsL21vZHVsZS5jLCBhZGRfc2VjdF9hdHRycygpOg0KCS8qIENvdW50IGxvYWRlZCBzZWN0
aW9ucyBhbmQgYWxsb2NhdGUgc3RydWN0dXJlcyAqLw0KCWZvciAoaSA9IDA7IGkgPCBpbmZvLT5o
ZHItPmVfc2hudW07IGkrKykNCgkJaWYgKCFzZWN0X2VtcHR5KCZpbmZvLT5zZWNoZHJzW2ldKSkN
CgkJCW5sb2FkZWQrKzsNCglzaXplWzBdID0gQUxJR04oc2l6ZW9mKCpzZWN0X2F0dHJzKQ0KCQkJ
KyBubG9hZGVkICogc2l6ZW9mKHNlY3RfYXR0cnMtPmF0dHJzWzBdKSwNCgkJCXNpemVvZihzZWN0
X2F0dHJzLT5ncnAuYXR0cnNbMF0pKTsNCglzaXplWzFdID0gKG5sb2FkZWQgKyAxKSAqIHNpemVv
ZihzZWN0X2F0dHJzLT5ncnAuYXR0cnNbMF0pOw0KCXNlY3RfYXR0cnMgPSBremFsbG9jKHNpemVb
MF0gKyBzaXplWzFdLCBHRlBfS0VSTkVMKTsNCg0KU28sIGluIG91ciBjYXNlLCB0aGUgc2l6ZSBv
ZiB0aGUgcmVxdWVzdGVkIG1lbW9yeSBjaHVuayB3YXMNCjQ4ICsgODAgKiA8bnVtYmVyX29mX2xv
YWRlZF9FTEZfc2VjdGlvbnM+Lg0KDQpCb3RoIGxpdmVwYXRjaCBhbmQgb2xkLXN0eWxlIEtQYXRj
aCBrZXJuZWwgbW9kdWxlcyBwbGFjZSBlYWNoIG5ldyBvciANCnBhdGNoZWQgZnVuY3Rpb24gaW4g
YSBzZXBhcmF0ZSBzZWN0aW9uLCBzYW1lIGZvciB0aGUgbmV3IGdsb2JhbCBhbmQgDQpzdGF0aWMg
ZGF0YS4gU28sIGlmIHdlIHBhdGNoIDIwMCsga2VybmVsIGZ1bmN0aW9ucyAod2hpY2ggbm90IHRo
YXQgDQp1bnVzdWFsIGluIGN1bXVsYXRpdmUgcGF0Y2hlcyksIHRoZSBrZXJuZWwgd2lsbCB0cnkg
dG8gYWxsb2NhdGUgYXJvdW5kIA0KMTYgS0Igb2YgbWVtb3J5IGZvciB0aGVzZSBzeXNmcyBkYXRh
IG9ubHkuIFRoZSBsYXJnZXN0IG9mIG91ciBiaW5hcnkgDQpwYXRjaGVzIGhhdmUgYXJvdW5kIDQw
MCBuZXcgYW5kIHBhdGNoZWQgZnVuY3Rpb25zLCBwbHVzIGEgZmV3IGRvemVucyBvZiANCm5ldyBk
YXRhIGl0ZW1zLCB3aGljaCByZXN1bHRzIGluIGEgd2FzdGVkIGtlcm5lbCBtZW1vcnkgY2h1bmsg
b2YgMzUgS0IgDQppbiBzaXplLg0KDQpIZXJlIGFyZSB0aGUgcXVlc3Rpb25zLg0KDQoxLiBUaGUg
ZmlsZXMgL3N5cy9tb2R1bGUvPG1vZHVsZV9uYW1lPi9zZWN0aW9ucy8qIGN1cnJlbnRseSBjb250
YWluIHRoZSANCnN0YXJ0IGFkZHJlc3NlcyBvZiB0aGUgcmVsZXZhbnQgc2VjdGlvbnMsIGkuZS4g
dGhlIGFkZHJlc3NlcyBvZiBuZXcgYW5kIA0KcGF0Y2hlZCBmdW5jdGlvbnMgYW1vbmcgb3RoZXIg
dGhpbmdzLiBJcyB0aGlzIGluZm8gcmVhbGx5IG5lZWRlZCBmb3IgDQpsaXZlcGF0Y2gga2VybmVs
IG1vZHVsZXMgYWZ0ZXIgdGhleSBoYXZlIGJlZW4gbG9hZGVkPw0KDQoyLiBPZiBjb3Vyc2UsIGNy
ZWF0ZS1kaWZmLW9iamVjdCByZWxpZXMgaGVhdmlseSB1cG9uIHBsYWNpbmcgZWFjaCBuZXcgb3Ig
DQpwYXRjaGVkIGZ1bmN0aW9uIGluIGEgc2VwYXJhdGUgc2VjdGlvbi4gQnV0IGlzIGl0IG5lZWRl
ZCB0byBrZWVwIHRoZSANCmZ1bmN0aW9ucyB0aGVyZSBhZnRlciB0aGUgZGlmZiBvYmplY3QgZmls
ZXMgaGF2ZSBiZWVuIHByZXBhcmVkPw0KDQpEb2VzIHRoZSBjb2RlIHRoYXQgbG9hZHMvdW5sb2Fk
cyB0aGUgcGF0Y2hlcyByZXF1aXJlIHRoYXQgZWFjaCBmdW5jdGlvbiANCmlzIGtlcHQgdGhhdCB3
YXk/IExvb2tzIGxpa2Ugbm8sIGJ1dCBJIGFtIG5vdCAxMDAlIHN1cmUuDQoNCkFzIGFuIGV4cGVy
aW1lbnQsIEkgYWRkZWQgdGhlIGZvbGxvd2luZyB0byBrbW9kL3BhdGNoL2twYXRjaC5sZHMuUyB0
byANCm1lcmdlIGFsbCAudGV4dC4qIHNlY3Rpb25zIGludG8gLnRleHQubGl2ZXBhdGNoIGluIHRo
ZSByZXN1bHRpbmcgcGF0Y2ggDQptb2R1bGU6DQoNClNFQ1RJT05TDQp7DQorICAgLnRleHQubGl2
ZXBhdGNoIDogew0KKyAgICAqKC50ZXh0LiopDQorICAgfQ0KDQpNeSB0ZXN0IHBhdGNoIG1vZHVs
ZSB3aXRoIGFyb3VuZCAyMDAgY2hhbmdlZCBmdW5jdGlvbnMgd2FzIGJ1aWx0IE9LIHdpdGggDQp0
aGF0LCB0aGUgZnVuY3Rpb25zIHdlcmUgYWN0dWFsbHkgcGxhY2VkIGludG8gLnRleHQubGl2ZXBh
dGNoIHNlY3Rpb24gYXMgDQpyZXF1ZXN0ZWQuIFRoZSBwYXRjaCB3YXMgbG9hZGVkIGZpbmUgYnV0
IEkgaGF2ZW4ndCB0ZXN0ZWQgaXQgbXVjaCB5ZXQuDQoNCkl0IGFsc28gbWlnaHQgYmUgcmVhc29u
YWJsZSB0byBtZXJnZSAucm9kYXRhLl9fZnVuY19fLiogdGhlIHNhbWUgd2F5Lg0KDQpBcmUgdGhl
cmUgYW55IHBpdGZhbGxzIGluIHN1Y2ggbWVyZ2luZyBvZiBzZWN0aW9ucz8gQW0gSSBtaXNzaW5n
IA0Kc29tZXRoaW5nIG9idmlvdXM/DQoNClJlZ2FyZHMsDQpFdmdlbmlpDQo=
