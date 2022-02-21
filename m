Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA324BDC14
	for <lists+live-patching@lfdr.de>; Mon, 21 Feb 2022 18:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356220AbiBUL1u (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Feb 2022 06:27:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347284AbiBUL1o (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Feb 2022 06:27:44 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120081.outbound.protection.outlook.com [40.107.12.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D12D59;
        Mon, 21 Feb 2022 03:27:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S54ESz8QAU6Yd09P/fIpF+1xfCsi+PIHDKk3XEXbtb/SkPrAel85L5YpW88j3+Ns9jNsIPOv1e488YERFWhMKQcpDgmSBLCMAXp6BXNXO/tfUPVtH+fTz/aiYwC5kzCKvuCdVfgrCQ8UmzlaRcI9l/tmy4tnDEdMfzrE9FElP+RNH5NRtHRo8G5e+J3mIEJmr3E+/gGKMDmR98JwDF7bE3io20ca/NT+qd9EhhaL7j8YkkkkIHJxwLhXd8y9xPWAnPxldiXEgZNIUK7z26dFT/1R4HTU+bVXcEDsfy19EN0jxM8Yjskui0W7mQCsQhPi3Naz0Tc5N4Gyp8uD98x/3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=36W8Up2PBRi3X6GrP7FYp2gpPq3lfPvQi3msDW7TZs8=;
 b=VVSS8hzpHeU/EOsbicWbFc2ROgBqi4abUhIFdzCtlAyHpJ72UI+kBYSV2f7akG4U6ANTJZG2A9Vopkr50YkR+UehxVWJktix2B8O1kk9nPguiRdAD0oIFzKf5RuQTqEfQFnwJ+kir9zG9hNHNoSZSqRGIs6+iqS9nj4MPfRwuFh6sADR0HAiAjR0IAZ3AVDgsPXIfLEaALuUqLHz40XBtYNhBW5GujkPzHK1EbLYVlwcVrR7+zsPApD1f2iCVSUwbXDKZ2V6+kqkHoeLv506dK41S6SOMyZzYUlmq7fXyk/m1pXQuXS52EgSGvtDLhH1n7NpZhdGzRRo3WvpvdmE8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB3692.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:160::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 11:27:18 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 11:27:17 +0000
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
Thread-Index: AQHYJQ4LXZiUR25fg0yFBOnbimlU7ayd4dqA
Date:   Mon, 21 Feb 2022 11:27:17 +0000
Message-ID: <90ea679d-1277-3823-3031-bff8a65c86e7@csgroup.eu>
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
x-ms-office365-filtering-correlation-id: 6bb79b60-7d03-4caa-697e-08d9f52d1e0f
x-ms-traffictypediagnostic: PR0P264MB3692:EE_
x-microsoft-antispam-prvs: <PR0P264MB3692C17F94EDF83343A8233FED3A9@PR0P264MB3692.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jEIfsvf3M0qYxJIH3lTUbr8QOEi592DALDAjBePzH5ZA8WEGrxXVSxNQ8iYyrODcjyj47L38PHu7gqAM/U3X7y14O/SjOh7Q2lIUZ/sYwlqu7cuCOci77mRRTZEY1x4pao6iZ/k0YrGSsix96OUFeTh0Y0IgD5HfQWiIirNtvWSAw3qW3UFPQaVAZVzoJBO54UzyjBjj/TgewJ4DOaduUS6RaOyH+x2nKQCipj8ONcMXVZ03Gg9Np3H2rYOUvbfrIm+e4B3QQMyR1+SDE++PNj4W7DyXoD7wqqNHdqWjsDr/8UE9U++3liy1g0Gx01mPWvXkpIDf05QD3JnbC6oFvqt4ukArlXnoXvtQJHqm9FyH/6eclGmpiqnEx7ElSZrfucO+NNFriPyRWCT9n9vm6ZiWhQ9w6ozpThr5t8ABhAPfbfIbwz1BcPZIQsdLFSToaiMyroIc8GfDVIjegxU+Lhwa/R5bQ/WyB9+bMlIDC+05SNqPBM/VMbPK1V8477PvUxtHn5I6eJ77kbpYn5UQ4AbRqsbUOyXyZ5v8UX+aSHpzKjLG948nDnylbq7DouE6aV3fU7W9uvJlcEEZt0IeOJZqDqXNVQyEXmJq2uYt2X2QZaFUByVYcAu6JAMeVyPSYnVIdicQqqJ/G+ANOJO+2QM1aMKFheVPYUNfr81JlF3bp13dZohpmxAiNbkqxEiT6QmNAeVxXreaTKPMtH8ZLRUH/9UukSbO0iP6Ml83TXp4D9yJ7kHO/tmqLjX1y8uWLUUZbZSlVMoqxD4kOtRe9g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(31696002)(26005)(38100700002)(71200400001)(83380400001)(2906002)(38070700005)(54906003)(31686004)(8936002)(86362001)(122000001)(110136005)(36756003)(316002)(7416002)(2616005)(5660300002)(44832011)(6512007)(6506007)(4326008)(91956017)(66446008)(66476007)(66556008)(66946007)(76116006)(8676002)(6486002)(64756008)(508600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUppZ0xLQmVhcXp5TzdJNUQxY0pFMlZvbjUvTUJJaVI0OXd4OGEzZVRCbzc1?=
 =?utf-8?B?SjJZeURSekx0RG8xRXJEeE14QXRtRGg2bXliakVoaVJNYVM4L2U4QjdRcXpV?=
 =?utf-8?B?c0RrREkyV2pzV1p2Y0VQdVBsNkVkMk9tTTc5czVLYTBva2J5azIzdW54U3Mr?=
 =?utf-8?B?S3Rsa0l6TXRjRlYxM0ZObWRxdFhOeUQwZS9EV2lZY2l3bFYyZGUvL29pZmcr?=
 =?utf-8?B?RElOTWMwaU1jbDI1OUd4VHRoQzRWcUMvWDdhOFppZG9PVnVwTTIyVFM0YXpn?=
 =?utf-8?B?MWRtWG9ZYWhwTEIyaWp4WjA3SGo2S0k0dDBJNnA0YmtNRWMvcDZuNGhJcmNK?=
 =?utf-8?B?c0xlV0N4Q0lBSmFWZ2x0ZmkzVnZzN3VJVW9ER08rdlo5ekNDeWJCM1Qvek1R?=
 =?utf-8?B?UTFZaWtodTEvL1lMUGdUTkN5bUxyL2txREROSWxrRTY3cXhFVWk2T2RQUm5E?=
 =?utf-8?B?cG9kTzdrQm5pWFN5R1c1bzBmM1U4ZUFWb3FLRnRzN09ENGJWWGtDeDQrSXB0?=
 =?utf-8?B?OVJDK2w4MEJTRGdTWnRZMmZ4SzhoNXlvS05oc2FIbW1vbExYZ1c2cjg4MTZK?=
 =?utf-8?B?aCtuUjQyME9za0FOeFpLNlRmeXBFWENNY1I0RDgxMk5zUVQxL2JMc2xSWTR2?=
 =?utf-8?B?ckJPb0hQclMrOUdRQzVsbjhyYVJzaCs5K3pRck4xQUhQMmVtNW9hbndEdU9K?=
 =?utf-8?B?enJZTzcwV094aVAvZTZGd3BjV0xseWRIa2RURERFSGJSSG03dXpiZHpTNkxt?=
 =?utf-8?B?Z2dSWHJHUjAwN0RHa2NkNFF1ZENmNG1aaXZHRGVVN3psSlZJYmlRditLTm01?=
 =?utf-8?B?NHZGMElJOW0zNThET0VYTFdMeFByc0t4VDlDR21GUm5SOEU1WklUSUhyUGlW?=
 =?utf-8?B?ZkNydDdSTVFtV3ZPRDlOWUsybFQydlgyVldFKyszRmhHTllIVnk4SEdqVnQ3?=
 =?utf-8?B?YVpLTldxMTVrdVpBcEx0K25QY1ZFdjRLWFNFclpVMktLMlhBK2plb1J3MXFl?=
 =?utf-8?B?OU44end4WXpuSElyNi93Q0VPcU14YUl5b3V0Z1pVNitOT3NPQ1VJSFJrRC9W?=
 =?utf-8?B?YmRsYlN2ZUYxZ2d3dGd1QlN0WHpMMnpvaTdLcXYySmRseFhJM3ppS2lIcnRK?=
 =?utf-8?B?bWw2ZkEyT3J0N0lOYUJVSjRLa0lUaTEzWlI2RnpxMERTZXNJVTNkWWk2R1E2?=
 =?utf-8?B?NkhkT3VvdkdTK2xJN3h3WTY2SXZkNTBQUmgwZDBiZDJ3aXU3WWVSRXJ5MFlZ?=
 =?utf-8?B?M05uQVJoZkxLekt6RUFodzF0ejllVHlzUE5mdEZLZjU1R3BqdVlMZUVZaHM4?=
 =?utf-8?B?enRSSDBRZVVuYS9qQ21IcmszdW9oOEtwclhabGV1RkJ1VkdsTC9GTlhBNG9q?=
 =?utf-8?B?NFVlRXN4QzJKUDloMGpZZ2t1U1ZLWWlxdEkwQU1CZ3dBeHZFVDlmOXFtRlk4?=
 =?utf-8?B?bHdHQjMzbi9Jd3FLYkdaRzcweWZ3cExVaTR2NTJ5YWpZUWVITzArRU9YOHYw?=
 =?utf-8?B?QmovV24wNnV5MGJGdHNyWUtyZmtFTC9zUHoxVktYbnJyWTdLYi9GaGVWYjdu?=
 =?utf-8?B?T3MrS2hiSTNSbW1taHFWNXhnUmt2TFNML0wvbko0SGNDajZ4aFVmMkpkbm1t?=
 =?utf-8?B?NjVzcGJORFUwR1VXWkF2bERiTnNsMXBsK0VLYXYweEczMUkzZG15a1BpWVVD?=
 =?utf-8?B?VnhBWjZjSFZkejJMQWMra1hKSS9XcUVzbUZLS2NoQnJ0VE4yQmw0a3lnc1h0?=
 =?utf-8?B?Ty9mc0w0NEpQZ1MxRWcrMGlxK2pSb0huNVFVMjlWaGdoa1QzcnZ5bTRLZ0lD?=
 =?utf-8?B?MHNGSTJhWk0yZlYvU2ZLZzRmSzBvNFhHUThaRm9Jc0JrQUkyN2xCUTEyd0FN?=
 =?utf-8?B?M2lnNnNqNGFKV1dCVzFseGpIeGg4UVI1QUZLVjhKUGhDWm1ZMlNaQVhvZGR2?=
 =?utf-8?B?TFpQL3VvSFhnV0tsVjBQa3QydEFjYk9vVGVkemZsOUdnRG41a2p4WTJFME9B?=
 =?utf-8?B?MXBNOUVrNzFNaFZzcEw2dTFPd2kyYWNHLzVHQmFJUmp6NStiVHFHUU9pQ09F?=
 =?utf-8?B?c1pPVnNvNHptaXFJNXpIQ3JnNG1nOXp6Yy9SSUltMmMrVkZMTGxSVk9ubUpS?=
 =?utf-8?B?SnYyZG9DTnJVRFRYUXBSaEFFdW9YRzZwc2RIUVp0a01WSTQ4WEp4c2tpNDZK?=
 =?utf-8?B?S3dFdkJjZVhnOUs0YitwbUVRSzdlcEo2bUdvYWVLK2l3WkMzQ0tSZ3BPZ1hK?=
 =?utf-8?Q?VJT5fX362/ATJ+8kKl2y4525RqtAIPYYTqwjz1V0BI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CDCE873A90D70D4E9836C4F9D989D5F0@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb79b60-7d03-4caa-697e-08d9f52d1e0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2022 11:27:17.5514
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u8oYdBMRrn0nSznRYK/3d0VPnc+oXsaiggqd1bCm/uu96mljULGplrnabhbLtXH9YMWO93oAuHGeNw5Q16yUynnaNMXm5DgFuQ3W/FR4QDM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB3692
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
dGUgbW9kZSAxMDA2NDQga2VybmVsL21vZHVsZS9zdHJpY3Rfcnd4LmMNCg0KDQprZXJuZWwvbW9k
dWxlL2ludGVybmFsLmg6MTgyOjEyOiBlcnJvcjogJ21vZHVsZV9lbmZvcmNlX3J3eF9zZWN0aW9u
cycgDQpkZWZpbmVkIGJ1dCBub3QgdXNlZCBbLVdlcnJvcj11bnVzZWQtZnVuY3Rpb25dDQprZXJu
ZWwvbW9kdWxlL2ludGVybmFsLmg6MTgxOjEzOiBlcnJvcjogJ21vZHVsZV9lbmFibGVfcm8nIGRl
ZmluZWQgYnV0IA0Kbm90IHVzZWQgWy1XZXJyb3I9dW51c2VkLWZ1bmN0aW9uXQ0Ka2VybmVsL21v
ZHVsZS9pbnRlcm5hbC5oOjE4MDoxMzogZXJyb3I6ICdtb2R1bGVfZW5hYmxlX254JyBkZWZpbmVk
IGJ1dCANCm5vdCB1c2VkIFstV2Vycm9yPXVudXNlZC1mdW5jdGlvbl0NCmNjMTogYWxsIHdhcm5p
bmdzIGJlaW5nIHRyZWF0ZWQgYXMgZXJyb3JzDQptYWtlWzNdOiAqKiogW3NjcmlwdHMvTWFrZWZp
bGUuYnVpbGQ6Mjg4OiBrZXJuZWwvbW9kdWxlL3NpZ25pbmcub10gRXJyb3IgMQ==
