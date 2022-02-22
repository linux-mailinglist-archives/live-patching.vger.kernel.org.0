Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A1C4BF6CD
	for <lists+live-patching@lfdr.de>; Tue, 22 Feb 2022 11:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbiBVK6q (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 22 Feb 2022 05:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiBVK6p (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 22 Feb 2022 05:58:45 -0500
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-eopbgr90045.outbound.protection.outlook.com [40.107.9.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B71DA145D;
        Tue, 22 Feb 2022 02:58:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRmXCL6sfmG08oQ/5eO1Ks7tHOyOoph8hHdMP9pAuhLixa1QOMqZfJDa7R8J9htz6wWEdXOUs9tEPHX/SJ9L6n1QxFG1VuZG22mw6YJhQOdatTSiTX9qnY/gGCA9Zmg2LEhneMA/VUTFD2COtPEifLPz0/9ow84dCE6/e3kbJguQvGyzgfwCjTlwXR++llCsA4VPtPD8k63GWnssjZyZopTcrKC0u9T12uFbuTFlhmenQJj6tdQ/rkGSJYELHc4L5HaiRmX033ffPqkvsb6dDuC1aFG7B20aKlbcSvjNPTb+9Mt7+GZPRMwPWIuDZiaI4nmYe3rWv0bO0vE4yrBh/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2IalZVOLOCsYnuVYGyiMhVBuilUqABp2wOlZpL833A=;
 b=N/QiZ7KUscvWD20DoVtt/yHH6G1N65NiRuPy9DU1aA9p5g82ApXIzQnCIZDRgqzhpbYOXCvSQc6n70zMdibRFn6GwkKkyuaL1LzmTYocxe13q7UkjPwy/vF55Sij2GD4HXyw5ct63CqSbA1CxGKwtSoR6g6S67Vg4XWqp+jI8hmHRWRNb1ZMTJvKvUyXOgYh8npP07rSAsMJzHFhOX0g5bPzY/kEnnTS8V1WjrZt6Z/Jag10NE6zrtR0NOeREQfEDmuj7lnVgj0xqF383ne1tBd7G3SX2F9Xg4Ff/8VlVUS7i+uI/uZs45+D0MtuN/cjDPIe5dmqcT1uDib+i661rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=csgroup.eu; dmarc=pass action=none header.from=csgroup.eu;
 dkim=pass header.d=csgroup.eu; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by MR2P264MB0002.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.15; Tue, 22 Feb
 2022 10:58:15 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::8142:2e6f:219b:646d%5]) with mapi id 15.20.5017.021; Tue, 22 Feb 2022
 10:58:15 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Aaron Tomlin <atomlin@redhat.com>
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
Subject: Re: [PATCH v6 00/13] module: core code clean up
Thread-Topic: [PATCH v6 00/13] module: core code clean up
Thread-Index: AQHYJQ4IdlGe+fxv00yPa1gxNKU+q6yaIieAgAVJ6gA=
Date:   Tue, 22 Feb 2022 10:58:15 +0000
Message-ID: <f3e5034d-99e1-4cbf-b4c9-36434eb3e18e@csgroup.eu>
References: <20220218212511.887059-1-atomlin@redhat.com>
 <YhBSBzmuiDQ4yMER@bombadil.infradead.org>
In-Reply-To: <YhBSBzmuiDQ4yMER@bombadil.infradead.org>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a264e5dc-7494-468c-6666-08d9f5f23a02
x-ms-traffictypediagnostic: MR2P264MB0002:EE_
x-microsoft-antispam-prvs: <MR2P264MB00026DED5ADE8D860508C33CED3B9@MR2P264MB0002.FRAP264.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7WlgzT8feB0ByULcj8a9kDDhOBKpyPZo3b6pdS9+zPGHpO5lgY98Qo9n8ug5T5uQ58w/m34qYI1wVqG+1gHsjdZdpBh5To2ZbJX7lZ/IJNR0wFDuUWCm9ftpAPhuZtaiveHOwoMz1mIufKhGxirWalq8Bja5BE9A/EbatQXojNylbCNPetFrl02EM602f+QNbuHn1T+TG+ghKtLxHGNX+ucpKXLEeSKYES8LhwG6kRdNcsR2oNfjacpCaqSsTql+YFqr2dwub7gzTpGHuMX9uOYAVjj5rrpveblOQX+m7nVsbczAU4y0M2LyE7gUv/IzHM+ezw/RsjJsYjAB8oGhB1KzgmEBy3YwZn0ZPlBG37TA3Ltl/NWFp+VmHxYdxCiuoMjxffMK+PeQbOZXNFfP60QgbNt9O1JRzE7Xc309y1/zoAveyUXcPT+yAzf0M+OL9ro4kug0QqlzVlYKiX2c2hvuAXbje2QU/+PeTGAgvDenlefPCaLKNGKKeyfe5YTnAZvuuSK02FNyLlCzuq8B12jj4Yn+3GtDYkYXgxFfST6pnVGMN+wkMgJgqOcdLTZ52qNpFO6Y4vC4kaXmT+3IANo1Iyh4mxd9mfM9f/oiTEOsyTxnCG1pTi5jS/5ksQpq1y127aba5Qp3KL4tucRKlB4P05a+36jpv92+2ScTHgDpyu0mzwnMb8kzE6Pytvt3dGvIGryaXwvJ9wtygbiWVri67NzZ7/nlexDqNAHkaxB9j9sfCkLgJocl11zG8XN1RZwNE7b/oG4lhWeU3x/NfqH/6r6L9wdrXHBvuqELNsvplTqaiTaPx68JaKk5bMwytKMRgsGNAPsQiIqSr9ZjOJpHymoNDVaEYsbkYAroFUA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(186003)(5660300002)(2616005)(26005)(122000001)(6512007)(38100700002)(8936002)(7416002)(2906002)(86362001)(44832011)(31696002)(316002)(31686004)(76116006)(64756008)(66946007)(71200400001)(83380400001)(36756003)(91956017)(66446008)(66476007)(110136005)(54906003)(66574015)(6506007)(6486002)(8676002)(508600001)(4326008)(966005)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U1YySEh3NkVWdVlvQzhGdlo5U2xXOE1rVDcyN3piV2c2R3hwVmpXSXhvUDNP?=
 =?utf-8?B?NkNwVVVaSm9qRG4zcW9nUm5DUnkxYk5WYTh6b2ZCc1dmaEFwS1NPanNtVTIy?=
 =?utf-8?B?ZmpLSnVZckMxcTJDMG03dGdJMHdVclBqekhMa0kvM2hPMnJFdXk4Vk5PanhI?=
 =?utf-8?B?d2pNREU5Vlh1SHpONXV5anZZNTA0K3VDSGRXWnpiRng0Ymh0RVNzeHNGdXdl?=
 =?utf-8?B?TkpUU0RabGZrS0t3by9nL0tFNjhrSExVUlZMdUNhOE5rV0I1NkpJQUduTjlX?=
 =?utf-8?B?ZEx2YitIVEw1VS9ZNVIzWXh0K0tFUHZUYWptK0ZSdlgySnkydUY5alNtNEND?=
 =?utf-8?B?K2Y3UGNybnJPWVVUTXpCZXIzTzJ5UmhrdGd6MkZKaVd1ZU1reGIzc0dtMUpl?=
 =?utf-8?B?YWFKb2JVczV0Z1hPTDR2dW1INDJqd0RvUCtzaUM3b21NSkNzVlBtRCtpcGgv?=
 =?utf-8?B?T1lZUlZybVdrTElJbmFCc1JwSE1iTWpGRXJIVEEyUVBrL2d4RG5DSk9HTHJj?=
 =?utf-8?B?TXYzdk5HN3U5clp4YzJ2UjREZ2Q3eWVscjZaQWYweWRSdlZXWkZQeHcwYU83?=
 =?utf-8?B?dU1PMUtFOHNLQVNhN1h4ZnR4SnFVbEtlQVBJallFVi8xSEpGYzhaWFluTzgz?=
 =?utf-8?B?NXpvR2pPK0FCRDByWlFPWHBIZHMySGU5N2JWUzNoVlg2ZjdQT1I1V2M1Kzcv?=
 =?utf-8?B?L2hyVlFWY1gzSGhGRlprOWZnT1lnSnhieVg1RXorY3JwN29IVHFsTDhiVmhm?=
 =?utf-8?B?ZzdodGRVL0krUVRLTGdhandHdjJLY3hxcHdWcGVYVzhUbis2NHlWbENjZmZZ?=
 =?utf-8?B?dmJMMWxrNjJITThZUmQyVlJjVGZZM2RuL2YyS2c1Nmdubit2WG00WklsaDUw?=
 =?utf-8?B?Q0d5Nk9LVzJHTzJQblNSUnhPdHlUZEN3QnNTV1B3TktYcDZkR0E2OWdLOUQ1?=
 =?utf-8?B?Ry9aaXc5TGtyUTByd1gvOE5nazVnVzF1ZHNITVFVZ2d3cTlsOURpQldZRWl1?=
 =?utf-8?B?V1FIeFlwbk04WmdyVW01MGFIYWtUdGFYd3VPblRNNVNVSUhhVmN0OU5qd2dF?=
 =?utf-8?B?VmMrT25LYk9kb3EyTTdGbEtYM0pQcDhhcitUOGdkY3FZeGJhS29QN0tycW9I?=
 =?utf-8?B?aGZuVVY4bDRaVmZFRXoxeFVJN1JGSDNTYjdtR01mdG8zV1Eyc0JZQUVzODdr?=
 =?utf-8?B?UjFxWURMRHFqSjdSMVFFS3gzMkUvb2Mxc29RWW1ZVUo2NC9OSXljRjZTVmNV?=
 =?utf-8?B?Mi9BNXN2RVJiREVNWjJ6M2ZDUituSGQveVR6T3BnTWpNMkExYnhqYVhub0pS?=
 =?utf-8?B?NTArMHdZWUF0cU43UVB1Zlh3RXlReFI0ZmoxYUhnZmRpZ24vc0RKcll2WDU4?=
 =?utf-8?B?MTRmQ0lqQ3J3NkxSLytVSnhCcFZZazI5elZKUTRSSUdZd3ZxdWZzVFYzaVpy?=
 =?utf-8?B?TXdDZ3FuRmlZUTFNNi80bkZUenFNcnM3N0VQOUU5NXBRck80YzFFbm1GTHNQ?=
 =?utf-8?B?WitIL2w2RnJXMldwcTQ3K0UzUGdEMmd3MHg2RGMvTncyNkpUNmVoSnB5cjdZ?=
 =?utf-8?B?MDlSZUM4TmxBeWlNbjdDcmZ2VnB3Q3lrQ0ZqZnFGckNqZEg2cFBHckc1OGs2?=
 =?utf-8?B?bTZFbldMN3JsSlc0UXNvaWI1bWRvelVicmMvZkQ4Ly9zN0hPb3FFZXB4cmY2?=
 =?utf-8?B?TUNlYzU0c0MzNUxuVjdWV0dheGQ4WHBLUmFOZnkwYmJZemg2aUR1TjFxcGpt?=
 =?utf-8?B?YjJJMThDTSs3WE1NdUwxMlBVSk1FM2hPVVZhOFB0eS95L2djUU9pL2FqQmdJ?=
 =?utf-8?B?VUtULzcyTUVNR253TVJZK2JGZVIxNjduMzRWTXhxbDJHMkx6aC95Y2VoR1Ru?=
 =?utf-8?B?cUFzeGQrVktIMm55RGhUamtDc3k4MmdiUTJYL0svTEhWK1hrRFB0bEZrenp2?=
 =?utf-8?B?MHBwTDVrZWpVaVQ5NzlFcm9uVFNPR0szdmYyZW5tVlZvVHNpRFRvNndTcHhQ?=
 =?utf-8?B?MmszNEhMYUpKRVFTTG04NVBVMmxjQzd2UklaUXBvdzFja252S3laaVo3MjBR?=
 =?utf-8?B?S0dzQ2dETUhJd3A3cnlYZUxpSytheldtNzdNVjB4a3dPalBETnZnWitUYnZi?=
 =?utf-8?B?K2FNZ0JvU1lKL3NjR3ZMaG9QMDYwbzBLaVZkT2FZNFVOeXl1VWZvc0xnTC9m?=
 =?utf-8?B?aFZPdXlhaHVVZUtuM2VMbGcwS2NhQ29aMHJDbDFJa2xLYUt6S0NTaE83Zjkr?=
 =?utf-8?Q?v16n73LxbJJrQLAJKMexns503BI4l16O+lvVTtlosc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5B6602CC152D8F4BB37FE8AA81D3C971@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a264e5dc-7494-468c-6666-08d9f5f23a02
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 10:58:15.3293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TBEUrKYOGn544zgptwGOgiiql2FCFZHGPH+2xynriqNVBgNQaVYzSPoRYzPkalm1TMDmaosEjJ+1o8+N3FKdCDS0MDIaGRr0LsCYAf4nW+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR2P264MB0002
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDE5LzAyLzIwMjIgw6AgMDM6MTIsIEx1aXMgQ2hhbWJlcmxhaW4gYSDDqWNyaXTCoDoN
Cj4gT24gRnJpLCBGZWIgMTgsIDIwMjIgYXQgMDk6MjQ6NThQTSArMDAwMCwgQWFyb24gVG9tbGlu
IHdyb3RlOg0KPj4gSGkgTHVpcywNCj4+DQo+PiBBcyBwZXIgeW91ciBzdWdnZXN0aW9uIFsxXSwg
dGhpcyBpcyBhbiBhdHRlbXB0IHRvIHJlZmFjdG9yIGFuZCBzcGxpdA0KPj4gb3B0aW9uYWwgY29k
ZSBvdXQgb2YgY29yZSBtb2R1bGUgc3VwcG9ydCBjb2RlIGludG8gc2VwYXJhdGUgY29tcG9uZW50
cy4NCj4+IFRoaXMgdmVyc2lvbiBpcyBiYXNlZCBvbiBMaW51cycgY29tbWl0IDc5OTNlNjVmZGQw
ZiAoIk1lcmdlIHRhZw0KPj4gJ210ZC9maXhlcy1mb3ItNS4xNy1yYzUnIG9mDQo+PiBnaXQ6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvbXRkL2xpbnV4IikuDQo+PiBQ
bGVhc2UgbGV0IG1lIGtub3cgeW91ciB0aG91Z2h0cy4NCj4gDQo+IEZhbnRhc3RpYywgdGhhbmtz
IGZvciBkb2luZyBhbGwgdGhpcyB3b3JrLCBJJ3ZlIHB1c2hlZCB0aGlzIG91dCB0bw0KPiBtb2R1
bGVzLW5leHQgc28gdGhhdCB0aGUgdGVzdGluZyBjYW4gc3RhcnQgYXMgdGhpcyB3aWxsIGJlIGlu
IGxpbnV4LW5leHQNCj4gc29vbi4gSSdsbCBvYnZpb3VzbHkgd2FpdCBmb3IgbW9yZSByZXZpZXdz
LCB3ZSBoYXZlIGEgbG9uZyB0aW1lIGJlZm9yZSB0aGlzDQo+IGdldHMgbWVyZ2VkIHRvIExpbnVz
LCBzbyBqdXN0IHdhbnQgdG8gc3RhcnQgZ2V0dGluZyB0ZXN0aW5nIGRvbmUgbm93IHJhdGhlcg0K
PiB0aGFuIGxhdGVyLiBBbmQgb3RoZXIgZm9sa3MgYXJlIGRlcGVuZGluZyBvbiB5b3VyIGNoYW5n
ZXMgdG8gc3RhcnQNCj4gZ2V0dGluZyB0aGVpciBvd24gY29kZSB1cCB0b28uDQo+IA0KDQpIaSBM
dWlzLA0KDQptb2R1bGVzLW5leHQgbWlzc2VzIHRoZSAzIGxhc3QgcGF0Y2hlcyBmcm9tIEFhcm9u
Lg0KDQpBYXJvbidzIHNlcmllcyBhcyBidWlsZCBwcm9ibGVtcywgSSBzZW50IDQgZml4dXBzIHdo
aWNoIGFsbG93cyBpdCB0byANCmJ1aWxkLCB0aGVuIEkgcmViYXNlZCBteSBzZXJpZXMgb24gdG9w
IG9mIHRoYXQuDQoNCkFuZCBJIGFkZGVkIG9uIHRvcCBvZiBpdCBzb21lIG1pc2MgY2xlYW51cHMu
DQoNCkFsbCB0aGlzIGhhcyB1bmRlcmdvbmUga2lzc2tiIGJ1aWxkIHRlc3QgYXQgDQpodHRwOi8v
a2lzc2tiLmVsbGVybWFuLmlkLmF1L2tpc3NrYi9oZWFkL2Q4ZWUzNmM1ODI4NGJhZjMxNWU4YWEz
NTMyYThkOTdhYmFlODAyNmQvDQpUaGlzIG9ubHkgYnVpbGQgZmFpbHVyZSAoaW5kZWVkIGEgZmlu
YWwgbGluayBmYWlsdXJlKSBpcyB1bnJlbGF0ZWQgdG8gbXkgDQpzZXJpZXMuDQoNCkV2ZXJ5dGhp
bmcgaXMgYWxzbyBhdmFpbGFibGUgb24gaHR0cHM6Ly9naXRodWIuY29tL2NobGVyb3kvbGludXgu
Z2l0IGluIA0KYnJhbmNoIG1vZHVsZS12NA0KDQpMb29raW5nIGZvcndhcmQgdG8gZ2V0dGluZyBl
dmVyeXRoaW5nIGludG8gbW9kdWxlcy1uZXh0IGhlbmNlIGludG8gDQpsaW51eC1uZXh0Lg0KDQpD
aHJpc3RvcGhl
