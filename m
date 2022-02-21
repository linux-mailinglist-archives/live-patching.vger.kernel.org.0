Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAF54BE666
	for <lists+live-patching@lfdr.de>; Mon, 21 Feb 2022 19:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358696AbiBUNNa (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Feb 2022 08:13:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358748AbiBUNN2 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Feb 2022 08:13:28 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120071.outbound.protection.outlook.com [40.107.12.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C045C1EEFC;
        Mon, 21 Feb 2022 05:13:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RUlK0KUSjtc4elYs3o+DIfDV6DCfFv4i4MN/iUDusxF6yymVRXsexwKKvYjrX5eIujvXUhrAiPyZgohQ5rjbXzZsyG6kKTykozefs3K/aZ1DDUI1jZf/0i/WM01rZGtuArJat4EpeCzo50vd6RwotIAAEhoS+O8Axk8VfDxbdqsRgE5M1tvuFk0n9LAp7S/yR2l4ax7CdEitZoco96I7MdA9yfqWrWufcCilmikZYoeOZezgx9BEKux3s4J4C2oxxCuAfXNRsIgjzCoMY5vwoHXtjHCP4pfVwXa8DvfnIPioBnXbVTIgvbQfJeatt161PYveM8SsOnAUV4KmUL8C1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wpZOA7KETfMYc9+L9Sseguo6LNHcOy7ycErL7KKmu78=;
 b=W9wGe3aUDBtjWKMiEIGCsm5qkLKi6RmUA05ypB5nQilc/0qp5PbZjynszS7LzKPGd0z+D5QpdnHLDR9TpxhQclREufvfTUaalOTPtUpqYeGhsxZnxuRkIFSLGF4T+3mzHs2Lt38w3ZE7X2+4AY1LjD7kTaFFl8G45CQ8JZjVog0LUlq8ZFUjw6EOa+jj4RvPGSmY+eQ9PjGCvfH9bRMAU885hF9A8w4PEAVRsRXp+XHlBzTxmswyQ4WE7OKfGdxIoDeR0va4iipYs4qvW2Cx/p5TUQOsSyX0SPQXxwceIX6b3kEXqQI2XHuH7A3qhDXuJwwy9Lz00t+V8EGvVYEY5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR2P264MB0050.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Mon, 21 Feb
 2022 13:13:01 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d%4]) with mapi id 15.20.4995.027; Mon, 21 Feb 2022
 13:13:01 +0000
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
Subject: Re: [PATCH v6 01/13] module: Move all into module/
Thread-Topic: [PATCH v6 01/13] module: Move all into module/
Thread-Index: AQHYJQ4Iyc5hoYSPF0yTCd/J8nGTMKyd/2MA
Date:   Mon, 21 Feb 2022 13:13:00 +0000
Message-ID: <fc315ebf-1ddf-13a8-7fc4-c5310e5785d4@csgroup.eu>
References: <20220218212511.887059-1-atomlin@redhat.com>
 <20220218212511.887059-2-atomlin@redhat.com>
In-Reply-To: <20220218212511.887059-2-atomlin@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac2f2ae5-75ba-4fbd-b772-08d9f53be307
x-ms-traffictypediagnostic: MR2P264MB0050:EE_
x-microsoft-antispam-prvs: <MR2P264MB005078B712E5AC652A40FDA1ED3A9@MR2P264MB0050.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +NMttEakYBAn04Mf2LaIEAups77WR+BM6WIhA1+7uNkg2nO65DhqYumXN6hTkd7+FD9PqkU/028kYjmK4TbNAPcSJBNkN9F+EXYAJxcHyx5jHtrTsg0QNNh+kVsjEYLMtIWyp8nSIDSHHGhGUdKgz2XHQ9vpsTK01+xUIQzg5M4xyqMwR5Dyw06G5XS5qsJKd+pX/perogEvXoeBqQkZZiQ0ec4Rp3T6DDkIjnObBwE+cuZSH5UQxQ6oka463F/T9zeKPiGybLhUvgdk7dMibEADTAKw+hXnyFtUF/u5E92xGp79JBrRJKm1W4fo74lnwLTRIhS70z5AXX3rOIgqn0/haneFXK8Jd0Rc+8Ymovcre0W9SsjiQlGyqBBliEhHSeJalHN5l0VPRJPJVu8FWWti041HNTSZ349n4KlcEHHZpRpgXJWMhlXkJcowWlsrkPfZQORRAFjtph/CcgTOm3VTiJbyCwRPFesqHZwRsdnAo3D0TBEDdiEF2hhF9ESN4htcvHHh1WpN6ZZT54dz/5H/2BcHqL2LCQzeyspnwgeqRovkzBPZSopBWVHTcG8WdX/7UoMQ+0f+WqEKmVKgL567gHbVEUgk65sB6sN33979POkXtEXYgtVRd+SyGrbspSZy4UsHTqQ5fZECrOzFXTQoXhccy/cym8sUkFQIhGhIBOnXkvzx7QxbGHnumCVMe5H6xcLEAyJ2/8Ei8c7r2HlPT5jnyJpIogElI0qHxgIBneFP+r3Z9EJHqPcJ2SshS8ZaTxhQDlwQR0Ua3Ki4RQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(36756003)(54906003)(91956017)(66946007)(66446008)(66476007)(83380400001)(71200400001)(8676002)(508600001)(4326008)(64756008)(31686004)(66556008)(76116006)(6506007)(6486002)(8936002)(186003)(2616005)(2906002)(122000001)(5660300002)(38070700005)(44832011)(316002)(31696002)(38100700002)(6512007)(7416002)(86362001)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXVZRmFJbk43dVg0em1PTlg0RjNudUpxTlBXeDNnd3RoUkx2TU1MOGFWYUFQ?=
 =?utf-8?B?WU5VQUlYM1NENm9kYTJPellobStYOFVGS3JSb2xVUExocGs2OUJTT1BiLzNr?=
 =?utf-8?B?YjlKL2VNUHgrNVZxZW1XZ0JwZUwrUDUvejRuNXdyeS85ZE80QnlBT09BZjYy?=
 =?utf-8?B?WG1vbUErTUpBUXIwL0N1YUh3V1BXOGMvVitVekhHZ3pmMm4rWmFreDlBWGFY?=
 =?utf-8?B?U2wwRFgzWEYxYkFBM2puZlhremhGaEZ4bGdkd3ltQ3EwSHBZdVRsYUZVZnZ5?=
 =?utf-8?B?eEhielFTa1FOQ1RPQ3VzZ2EvZjdZV3VaM3JXZGVjV3l6bEp0RitWamd6alRF?=
 =?utf-8?B?WU9FMmF6SWtsZExsczVlWVhZVjJNTzUvM0hDSlRmaEFXQU9jTTEzQkt0ZDZV?=
 =?utf-8?B?eFdaVmhLbWV6TUo5cTlmdEZDRnI3YWdrYURqOUwxLzRNZkw1aGNuYUhncmlx?=
 =?utf-8?B?eUFucG5lZzBFdUl1WUlKT3Y2L0ppVEh3ektYOHJaSndVa3ROdzBiNFR0M29v?=
 =?utf-8?B?dnlJSXFISTFXNjlLME5FY2t2Q1ljNndaZGtPdndKV0tBYkdXZmZ3TzVEci9I?=
 =?utf-8?B?cWI0N254Tm9taDVieXFFRjg2eHdhNEdFQzZCUy9ZMGRHSW1xU1FyZElOWSta?=
 =?utf-8?B?REt3NlN4cmRnZElMOEZWaFNuOVhJaXdQbC8vWklHT3RFbkIvTnhQMUhzM3Jn?=
 =?utf-8?B?TDV2dDM2MStLLzJ2TGJkSWJjVUk1NHhpQzQ3K2phRUpJdTJGTFdLTDN0ZXdS?=
 =?utf-8?B?TWdJYm5JREpXNk1iY25YVTNoQlpSTVBsL0ZXT2QvSEo5Ni9jMnVLUDNIYXlL?=
 =?utf-8?B?dVhTTzR1alRMcnFjRFYvbVpTZ0JTWGZMbHAwTTFGVDBKQW83YURHWGViQWpy?=
 =?utf-8?B?Y2dQcVRiU1VZOG9Fb3FkUW9ybVJZMG9WZXZkLzhRL2F1VlNLZzhuTGd4eDI3?=
 =?utf-8?B?SFBOTmdmby9LY1ZyRFI1NmpxS21udzAyWUpoZjNFMWc3b0VpNG1kNkZEUG16?=
 =?utf-8?B?YlBiZWZzbCtYNUxBN0NDdVBNTDJTMFZhT3cvT3JvV28rSVZqdXM0aG9UMGlo?=
 =?utf-8?B?VXpadnBteHFtNjBpS1YxbjZZL05KTXp3WDRSNWhuT1RNMTUyb2ZNbUhpSlZU?=
 =?utf-8?B?QkxLUW1ONkozcDhNeTY2VURmSEgyc2hsZ3AvcjV6VVZGcXV0ZU1LbGxqTVhm?=
 =?utf-8?B?V3pqbG03YStldzh4VkdvWTh5eDlJNUM3bkMveld1QTR0aHE5QUt4K0o5d3Bs?=
 =?utf-8?B?SUhuYnl3VUkyWTk5MDlta3VjZU9HMW5BbmhJVWZLSEVhSGNVK1IrS2RubE53?=
 =?utf-8?B?bFhtb1ZPQmVjV2owNzh4OUhyOVBiWllZNTkySG14TVJqVWNxQ3RkZHVaSGt6?=
 =?utf-8?B?a1EycVYyL0dlbFhUaEtmK0tNS0hMbUM5R0hzNVdjYTA2SDFtbkZEeDUyckl6?=
 =?utf-8?B?UHpyc1hDditmcjNDczBPZ1RCa1VFTTNzVUNvRGwzNGQvdm15WGxPL2JxUmJF?=
 =?utf-8?B?Q1VyVXpVNG1SUnZvNVhoOW9xTmhhbTZxTHhIYXZVemliK05QYXRLYThwQUI0?=
 =?utf-8?B?c055MFE1QTFjQnhYelYxckNFa01FWXptWG5HbkVHbTJPbHR6UEE4b3pyMktl?=
 =?utf-8?B?VjdZeDdaR2RFSnhMVHZxRGZwRHJpY2JYczI5dy9CQS85SDh1TlhZTjV4UTQ5?=
 =?utf-8?B?SUlIOHhiVEZvV0dUOGRQNk1ZL21jWmdvdUxMTGRETTFsL1Z2eS9LaDJTeG5n?=
 =?utf-8?B?ckFVSXF0Y0VMSGs3VW50anBQTmdKQzRVVWEvVkxyNzZVSmhDUUVlZjBXODg1?=
 =?utf-8?B?bFVZTEp0dkgzY3pTUVZEVjc1NUVRYzUvNDFQMTlPOWhpMVFOQTdaYTZjN3pt?=
 =?utf-8?B?U25kUitUeDEwcVdsRUgwK29hdGtHTkVUYndYM0ova3JGWVFkdXhLVkJzYjAw?=
 =?utf-8?B?dko5cGFvODdsNWJzNHU4QmFGdmZxQXZ4aUFkVUdvMWdORjBnOGVWV05zZXNr?=
 =?utf-8?B?bU1rVHNoMy9vdlFaaVd2NTZTM3dmOHdxQUhxRjBvZGx0UmxkWWhtUDUwM3NH?=
 =?utf-8?B?MWk4c3FXNG1ReDJxMGdsWjlrVjdNaEd2ZHZSbmpkN0NkbmJRSURHQ2lWRVJN?=
 =?utf-8?B?cUNLK00rOStXUXc0STNFb0Q5TVpXbG1BRys1azBvNFljN2RzS3hmS1I2VGEr?=
 =?utf-8?B?UlpnNnlDWFNlclh5dXdHb0crWHdzTnFyRGhHWTkrSGNjOFIxZmxxZkR0RFg3?=
 =?utf-8?Q?ZVBCIOrPhXWqgmxpE0/2FdIu+EXvRVH3sqrZd5LTqQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <23E119D8C531B7419FA02A2CB32938F8@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ac2f2ae5-75ba-4fbd-b772-08d9f53be307
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2022 13:13:00.9351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1TcPxus5qsko0efvClkRogepqzH3AvQGXfpYRPp/FIt7RdojTnaYj6M5x3WnjYmyuZ4L1JvAWXDDfstxKNButOlArStRZI8P1QvIUEKst+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR2P264MB0050
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDE4LzAyLzIwMjIgw6AgMjI6MjQsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBO
byBmdW5jdGlvbmFsIGNoYW5nZXMuDQo+IA0KPiBUaGlzIHBhdGNoIG1vdmVzIGFsbCBtb2R1bGUg
cmVsYXRlZCBjb2RlIGludG8gYSBzZXBhcmF0ZSBkaXJlY3RvcnksDQo+IG1vZGlmaWVzIGVhY2gg
ZmlsZSBuYW1lIGFuZCBjcmVhdGVzIGEgbmV3IE1ha2VmaWxlLiBOb3RlOiB0aGlzIGVmZm9ydA0K
PiBpcyBpbiBwcmVwYXJhdGlvbiB0byByZWZhY3RvciBjb3JlIG1vZHVsZSBjb2RlLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogQWFyb24gVG9tbGluIDxhdG9tbGluQHJlZGhhdC5jb20+DQo+IC0tLQ0K
PiAgIE1BSU5UQUlORVJTICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8
IDIgKy0NCj4gICBrZXJuZWwvTWFrZWZpbGUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgfCA1ICstLS0tDQo+ICAga2VybmVsL21vZHVsZS9NYWtlZmlsZSAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgOSArKysrKysrKysNCj4gICBrZXJuZWwve21vZHVsZV9kZWNvbXBy
ZXNzLmMgPT4gbW9kdWxlL2RlY29tcHJlc3MuY30gfCAyICstDQo+ICAga2VybmVsL3ttb2R1bGUt
aW50ZXJuYWwuaCA9PiBtb2R1bGUvaW50ZXJuYWwuaH0gICAgIHwgMA0KPiAgIGtlcm5lbC97bW9k
dWxlLmMgPT4gbW9kdWxlL21haW4uY30gICAgICAgICAgICAgICAgICB8IDIgKy0NCj4gICBrZXJu
ZWwve21vZHVsZV9zaWduYXR1cmUuYyA9PiBtb2R1bGUvc2lnbmF0dXJlLmN9ICAgfCAwDQo+ICAg
a2VybmVsL3ttb2R1bGVfc2lnbmluZy5jID0+IG1vZHVsZS9zaWduaW5nLmN9ICAgICAgIHwgMiAr
LQ0KPiAgIDggZmlsZXMgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkN
Cj4gICBjcmVhdGUgbW9kZSAxMDA2NDQga2VybmVsL21vZHVsZS9NYWtlZmlsZQ0KPiAgIHJlbmFt
ZSBrZXJuZWwve21vZHVsZV9kZWNvbXByZXNzLmMgPT4gbW9kdWxlL2RlY29tcHJlc3MuY30gKDk5
JSkNCj4gICByZW5hbWUga2VybmVsL3ttb2R1bGUtaW50ZXJuYWwuaCA9PiBtb2R1bGUvaW50ZXJu
YWwuaH0gKDEwMCUpDQo+ICAgcmVuYW1lIGtlcm5lbC97bW9kdWxlLmMgPT4gbW9kdWxlL21haW4u
Y30gKDk5JSkNCj4gICByZW5hbWUga2VybmVsL3ttb2R1bGVfc2lnbmF0dXJlLmMgPT4gbW9kdWxl
L3NpZ25hdHVyZS5jfSAoMTAwJSkNCj4gICByZW5hbWUga2VybmVsL3ttb2R1bGVfc2lnbmluZy5j
ID0+IG1vZHVsZS9zaWduaW5nLmN9ICg5NyUpDQo+IA0KPiBkaWZmIC0tZ2l0IGEvTUFJTlRBSU5F
UlMgYi9NQUlOVEFJTkVSUw0KPiBpbmRleCBiZDg2ZWQ5ZmJjNzkuLjQ2M2JkYjgyOWRiNCAxMDA2
NDQNCj4gLS0tIGEvTUFJTlRBSU5FUlMNCj4gKysrIGIvTUFJTlRBSU5FUlMNCj4gQEAgLTEzMDEy
LDcgKzEzMDEyLDcgQEAgTDoJbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiAgIFM6CU1h
aW50YWluZWQNCj4gICBUOglnaXQgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9r
ZXJuZWwvZ2l0L21jZ3JvZi9saW51eC5naXQgbW9kdWxlcy1uZXh0DQo+ICAgRjoJaW5jbHVkZS9s
aW51eC9tb2R1bGUuaA0KPiAtRjoJa2VybmVsL21vZHVsZS5jDQo+ICtGOglrZXJuZWwvbW9kdWxl
Lw0KPiAgIA0KPiAgIE1PTk9MSVRISUMgUE9XRVIgU1lTVEVNIFBNSUMgRFJJVkVSDQo+ICAgTToJ
U2FyYXZhbmFuIFNla2FyIDxzcmF2YW5ob21lQGdtYWlsLmNvbT4NCj4gZGlmZiAtLWdpdCBhL2tl
cm5lbC9NYWtlZmlsZSBiL2tlcm5lbC9NYWtlZmlsZQ0KPiBpbmRleCA1NmY0ZWU5N2YzMjguLjNh
NjM4MDk3NWM1NyAxMDA2NDQNCj4gLS0tIGEva2VybmVsL01ha2VmaWxlDQo+ICsrKyBiL2tlcm5l
bC9NYWtlZmlsZQ0KDQpUaGlzIGZpbGUgYWxzbyBjb250YWluczoNCg0KS0NPVl9JTlNUUlVNRU5U
X21vZHVsZS5vIDo9IG4NCg0KSXQgbmVlZHMgdG8gZm9sbG93IHRocm91Z2ggaW50byBrZXJuZWwv
bW9kdWxlL01ha2VmaWxlLCB3aXRoIGEgY29weSBvZiANCnRoZSBjb21tZW50LiBBbmQgdGhlbiBp
dCBuZWVkcyB0byBiZSB0YWtlbiBjYXJlIG9mIHdoaWxlIGRpc21hbnRsaW5nIG1haW4uYw0KDQoN
Cj4gQEAgLTUzLDYgKzUzLDcgQEAgb2JqLXkgKz0gcmN1Lw0KPiAgIG9iai15ICs9IGxpdmVwYXRj
aC8NCj4gICBvYmoteSArPSBkbWEvDQo+ICAgb2JqLXkgKz0gZW50cnkvDQo+ICtvYmoteSArPSBt
b2R1bGUvDQo+ICAgDQo+ICAgb2JqLSQoQ09ORklHX0tDTVApICs9IGtjbXAubw0KPiAgIG9iai0k
KENPTkZJR19GUkVFWkVSKSArPSBmcmVlemVyLm8NCj4gQEAgLTY2LDEwICs2Nyw2IEBAIGlmbmVx
ICgkKENPTkZJR19TTVApLHkpDQo+ICAgb2JqLXkgKz0gdXAubw0KPiAgIGVuZGlmDQo+ICAgb2Jq
LSQoQ09ORklHX1VJRDE2KSArPSB1aWQxNi5vDQo+IC1vYmotJChDT05GSUdfTU9EVUxFUykgKz0g
bW9kdWxlLm8NCj4gLW9iai0kKENPTkZJR19NT0RVTEVfREVDT01QUkVTUykgKz0gbW9kdWxlX2Rl
Y29tcHJlc3Mubw0KPiAtb2JqLSQoQ09ORklHX01PRFVMRV9TSUcpICs9IG1vZHVsZV9zaWduaW5n
Lm8NCj4gLW9iai0kKENPTkZJR19NT0RVTEVfU0lHX0ZPUk1BVCkgKz0gbW9kdWxlX3NpZ25hdHVy
ZS5vDQo+ICAgb2JqLSQoQ09ORklHX0tBTExTWU1TKSArPSBrYWxsc3ltcy5vDQo+ICAgb2JqLSQo
Q09ORklHX0JTRF9QUk9DRVNTX0FDQ1QpICs9IGFjY3Qubw0KPiAgIG9iai0kKENPTkZJR19DUkFT
SF9DT1JFKSArPSBjcmFzaF9jb3JlLm8NCj4gZGlmZiAtLWdpdCBhL2tlcm5lbC9tb2R1bGUvTWFr
ZWZpbGUgYi9rZXJuZWwvbW9kdWxlL01ha2VmaWxlDQo+IG5ldyBmaWxlIG1vZGUgMTAwNjQ0DQo+
IGluZGV4IDAwMDAwMDAwMDAwMC4uMjkwMmZjN2QwZWYxDQo+IC0tLSAvZGV2L251bGwNCj4gKysr
IGIva2VybmVsL21vZHVsZS9NYWtlZmlsZQ0KPiBAQCAtMCwwICsxLDkgQEANCj4gKyMgU1BEWC1M
aWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seQ0KPiArIw0KPiArIyBNYWtlZmlsZSBmb3Ig
bGludXgga2VybmVsIG1vZHVsZSBzdXBwb3J0DQo+ICsjDQo+ICsNCj4gK29iai0kKENPTkZJR19N
T0RVTEVTKSArPSBtYWluLm8NCj4gK29iai0kKENPTkZJR19NT0RVTEVfREVDT01QUkVTUykgKz0g
ZGVjb21wcmVzcy5vDQo+ICtvYmotJChDT05GSUdfTU9EVUxFX1NJRykgKz0gc2lnbmluZy5vDQo+
ICtvYmotJChDT05GSUdfTU9EVUxFX1NJR19GT1JNQVQpICs9IHNpZ25hdHVyZS5v
