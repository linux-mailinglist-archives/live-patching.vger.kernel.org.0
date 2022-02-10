Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3164B0F1A
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 14:47:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242377AbiBJNrA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 08:47:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242372AbiBJNrA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 08:47:00 -0500
Received: from FRA01-PR2-obe.outbound.protection.outlook.com (mail-eopbgr120070.outbound.protection.outlook.com [40.107.12.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F1EC59;
        Thu, 10 Feb 2022 05:47:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4GVSLIsNa3dYTdtC+n4i0R0/yeHxMUyzf4cIJgVOXTd3MMzDcFzIzP/YI3s5VBHv8yQ14WDRlgAdJfvP1oj8xIaz5EKvaRSY7VUGLZydGomtPxvNl5sARbayaTMzIy992fsWYD9wsTIglE+e/4abUfotr1+MUEdj0vSPxDgAove/qr6AA4132OYk/i6rR+Pj+222K5RdWcbGPAlt2ceTQAWnKb6Us49zXcgi/idOju/mxe0iQwFDnzzyoTBJjnzwMGvf7EdnSAUFrWfpdBQ9izmMC4V6TL7AkRknxxftzKSO6BQTbmASEBIEsP8SV4nAMBJLdOrwdhzNH6cuLwMhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4EsO68W39If1phhc6KfAUcYYb/LXmYCSXg2oSX2Cgpc=;
 b=B6Xjp8hlF4r0beDb4ExsxGmkutAFpCTc7JL4CzSY7t3GtAZOvIEfFqz7PiG76IgI6zRRqYocbOdqqfV9qep1FXlLCleGicptZOxHxU5JX6F0/E8esQ9EAsotYU3m16D4OhyU62cRlnyJSDf4+CbzHeD3hTxdyC37c9HQ8PeJNiig8Ok2nwMLez0u7CYPNYl6dyIQ/MJwkh8qp4T9BI+oe9flhSxD/ymj2UeIF179ngaBhot7eBlPMbGWSHHMRv0xFRTOmrKDRxvdWoP/fYKUpaJsJzk47vKGpMmOKLV9WjoH9yq+AIEcxn3GkwQocgT1B5IZ+dPQ6nG3YqPgnzfMZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:31::15)
 by PR0P264MB2552.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 13:46:58 +0000
Received: from MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1]) by MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
 ([fe80::c9a2:1db0:5469:54e1%9]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 13:46:58 +0000
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
To:     "20220209170358.3266629-1-atomlin@redhat.com" 
        <20220209170358.3266629-1-atomlin@redhat.com>,
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
Subject: Re: [PATCH v5 10/13] module: Move procfs support into a separate file
Thread-Topic: [PATCH v5 10/13] module: Move procfs support into a separate
 file
Thread-Index: AQHYHdemOuA1m4sqZUCK/cQrb729c6yMzaeA
Date:   Thu, 10 Feb 2022 13:46:58 +0000
Message-ID: <c588ef38-9f1f-cc27-c240-b271204e7aad@csgroup.eu>
References: <20220209170814.3268487-1-atomlin@redhat.com>
 <20220209170814.3268487-4-atomlin@redhat.com>
In-Reply-To: <20220209170814.3268487-4-atomlin@redhat.com>
Accept-Language: fr-FR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=csgroup.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49342ce9-b8cc-41e5-9fb5-08d9ec9bcf12
x-ms-traffictypediagnostic: PR0P264MB2552:EE_
x-microsoft-antispam-prvs: <PR0P264MB255282F23F90012D1AA6F169ED2F9@PR0P264MB2552.FRAP264.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:428;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aRmoGgLH/8G84C9UnMWcLVxuTmHeSPrpKdkn8W/MP3sBpGCUSrqXz5it8H3XRlplC6vPXo0H3rb85YU0DEasu5xjCM1MYFtdcrfQzOjoXSaZs1FM25ATaqKN7RBvx/MReYMZdd4y66UmxjQNhKMZ75OiZ8SnlzlGGtFMM1/Tv53va+8+syoBoTLC92dQbBSFOJZSaVhfIfEYilpCVcxmCYw1XJ3oa6fnY+IbgcIQ3lh9j7jGKi/kW1m9rbi7MRmSOGoJMpJ2Q40LujdDRhyVqBBsU9Xo+xB21GkyY46sx0mNZS9spLadITj2cz2NsgJC/QsCypBxhwN3iEAlhK033DmOJsoynEEiSXhf/L4ZVdtTKOdrj+ntEKUT+qO3LRYluUKguWJAof46ezYZ5lW/xGskA0pYLzwcYhr2+QjEhQHCUCrsEtD3aZ6ch/sY0GnUCQSRD0UhLomoDaLhppuzfD7Q7G8fUoaiUevq1l2fYuG9DGsLRZr5PuJ0SAhBzqK9Dly1VKA13oaTDDFiDUX3eWDsFhjPkiONBt9osydquJjgb0yH/wvMCJUpKMpBKJEgOGIU4fPK3DAQ3Tk30EF/gDaLDeLWuZxI57L7GtJD1d7P0v1wt1PCjgyE9P8UfsQQCISNnL4aGQqV2+fpK0mYw4YN8n4z/92rYMZAWrf8VZ1FX6GocbcA2l2ysTQVt0VG+vX+FGA3BSkUt3cx7vxMFPaRB+/jpfKQXlHtf1lVvc63dTdmUgP+GogI6wkg8dw3sPyUbKLnpevMXXnk352N2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(91956017)(6486002)(66556008)(31686004)(508600001)(86362001)(316002)(31696002)(122000001)(110136005)(2616005)(76116006)(186003)(83380400001)(71200400001)(6512007)(6506007)(44832011)(8936002)(38100700002)(26005)(5660300002)(64756008)(8676002)(4326008)(54906003)(2906002)(7416002)(4744005)(66476007)(66946007)(66446008)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWtMVFVJMEtHQWt0dlFuM2NWMHErT09QNlZTV09RWURRbnMrR3NFTVlQVzZP?=
 =?utf-8?B?bEN1SDNQV1dtRmF0eDNaRXpQc3d4eWtIc0NKMFRqMVF1M3F5NWpiVGYwVFBu?=
 =?utf-8?B?STRPSTdIcHZwenlNbGpzSU1qVU1HdXltK2QyeGVaY2o2QUNvN0EwYmhwY0F1?=
 =?utf-8?B?ZTBCOHVXOU1GTG5ra29HRUNYczNQZTlTYTNaZ3U4dkVVNjY0MXdjMzBtVzhu?=
 =?utf-8?B?eC96NUxubU5ZeWpZZGVRSmFpQ2FTZkhNTW40ZXgrdmFHYU1CMm9weEJxMHlM?=
 =?utf-8?B?WE1LeVhuWGFCcm1xQk5pTWRlQzU1VDU3QWVJTE1sRVk1Q2RnUndkNjJ0Tlkr?=
 =?utf-8?B?bTl5VFRLKzNzZ005cXlSa0ZtdGNLVDR6S3I2TmxSalltaFAra0drUDhSYWV1?=
 =?utf-8?B?UGtKQXBuUDJmOWl0UGYvaTgzOVZuaXFYQndoMFpUVFZhMVFheVBPczFtcTY1?=
 =?utf-8?B?Z0pQUkVQbHZKanpsZ0hiNFhKZExhUXpySDltbmFmQnJvbzJJL2tpbi9MdSt6?=
 =?utf-8?B?SkhmVjErM0RrcXVONXhVMXU1dzNLMWNrZ0hzQ3oyQ3lMTytMTlgvb1RMVFZs?=
 =?utf-8?B?Vmx5Y2twbTJrZk1CVTJJQ0VTTjNVTUdnWDVpUkR2MndZMTRONkdac2RnR01D?=
 =?utf-8?B?d0dtMkJiTE1xVmMzRmZuRVZKL0JOWnNMb1kvQnR3R1ZMSUNwa0R0N0pCM2pB?=
 =?utf-8?B?dVJiYlQraWZMZkcyN1o4b3BPbExzbzR6aUtGVHB2U084UXkvWW5vZUx4dXdz?=
 =?utf-8?B?YUw1SzVNR2lEQzZmL3F5VmkvZDVkZWh0R2U2QnNURkUreFNyemljdjluL05q?=
 =?utf-8?B?L1p1QWg0dmFzWGVKSHRLaTROaitkYXZzQ3ppTzROemc5Mk1sTG9nY0hoZ1Fh?=
 =?utf-8?B?R1pnMmx3dUk4N05tVVNrU21jVUh5VVJ0OEl2M1poc0QrdWdZU0lZNTZTbk1L?=
 =?utf-8?B?MUxiNEFsdTBOcmtmVmFuYTlqR3kvSW9UeHpqbmVYbUpXWlJnclhCUUE0ZC9I?=
 =?utf-8?B?WTRoSkhLZ1RzRHhuOEJwTEdrN2VwaTFZdTEvU2MrbmpBbHJKeUpUTWJXZm42?=
 =?utf-8?B?WWJKNlVkTkIxNTgxckJrRHo4UlZPR2R2d3JpL2Y5WXBtTXcxbFFRUG92akVq?=
 =?utf-8?B?eXJKcWQwMC91RzVjSXRrTzUwaTZycWxGL3k0TnJHMFN5TlRNejJRMlNNQlIv?=
 =?utf-8?B?VEF0OEVSMTdNY25zWGE2cGd5R25UNkpXeUZNbUx3WWk2QkFocXZ4NW9IUHZE?=
 =?utf-8?B?V3VwTHlwRUZRRFRjVHhQNVBsQ0tKaG9MTzJSVkNQcWk0ZjlvZG13dGcvLzFN?=
 =?utf-8?B?U0tNTHdMRDZVSm12VTUyM2ZoYXpkdE5hT2dBUlhaZmtxRGlBT1d3U0w4NWU0?=
 =?utf-8?B?MFNZSDU2NzF1aGkxOElaayswaVpFK0pyQjV6TmtNNUc5aEgyeFBDaExaNDZy?=
 =?utf-8?B?TEt4Mm9TQTVlN2tXYWROSXJNL1Iwd1dla3FFNG5WZUlBRWhFNzRSYlBMQm9v?=
 =?utf-8?B?aTZ3YnR4Q3haSU9XZkltQ1Rkci95NTdrNFg0M0VjNCs3b3k4dHB3M2pPVFNR?=
 =?utf-8?B?Zkd0Wmd4Tm0yZ0NQblZjVS93dWJTK2FtY2hjK0RYeW1CTjJPSWE4UlQ4SytC?=
 =?utf-8?B?NkFqQnNyZklNdStaSTM2bUhSWG1FV0M5SldCOWtmVnl3R1lEZzNrbDJkak1R?=
 =?utf-8?B?NGE1aFlwS1JJR094d05aVG55bCt6c2pnbUdFaW9leFBJYm1BU2FQZ3d3RENV?=
 =?utf-8?B?eGt5UzFlVDJsUlNQdE5SR2FyRDhNM1ZBcGZJekp0VUI2MStMOXVsRFdJZURW?=
 =?utf-8?B?UWZnajU0SzFMY3lkTWhlaVFZTmZLczQwU0FtTHRQQlZ4NjFCOUhLY1NRQm1C?=
 =?utf-8?B?azltV2pzejQ2ZGlHL3hNc2ZMYU04d3lTalMxaEVma2pBVTkvSHQ0K3J3azVk?=
 =?utf-8?B?MzV6Z3VUZStiQkIxY0QvQ1g0OFdyWUhjRG9NbkdSdm9VRjdBeElsVGc4cC9V?=
 =?utf-8?B?YkMvZGF2aE16L2p3RGt3aXBuck9NY09VNGxoZjVydDl4VG54M2plcXhwWnox?=
 =?utf-8?B?T3h1L1FRSElSR3VORGFmZWhkRmROZXRrWXVEWHFWT2x5aG13d1NWZ2wxTWhE?=
 =?utf-8?B?MVRCQXliVGR3c2Z5czVwMmpzTEZ0cVFMTXRUaTZ1R2tybUVEMWRLNm40ek5P?=
 =?utf-8?B?QjFNR3FhNTJBcDBhb1BmS1F1ZXVhdTRmalVDVkpwRWRtazlvL0FTVDVOcnBY?=
 =?utf-8?Q?wf853miEwZhbwwTE8rIZwHnEYx6E7E1CB2YR9fZrtY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <626315469E14A842A868CA18411E2521@FRAP264.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: csgroup.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MRZP264MB2988.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 49342ce9-b8cc-41e5-9fb5-08d9ec9bcf12
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2022 13:46:58.7200
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9914def7-b676-4fda-8815-5d49fb3b45c8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9+t+i9OZl4+ocnMwbOmj4inA2WI8Cff/M5oe6gSPsTlndrq0lvL2PsD2r4Eg5GtE5zSBYqdYOa/CtZhbSMUriCW+5aM1vj9nLMml4v3cI6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR0P264MB2552
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCkxlIDA5LzAyLzIwMjIgw6AgMTg6MDgsIEFhcm9uIFRvbWxpbiBhIMOpY3JpdMKgOg0KPiBO
byBmdW5jdGlvbmFsIGNoYW5nZS4NCj4gDQo+IFRoaXMgcGF0Y2ggbWlncmF0ZXMgY29kZSB0aGF0
IGFsbG93cyBvbmUgdG8gZ2VuZXJhdGUgYQ0KPiBsaXN0IG9mIGxvYWRlZC9vciBsaW5rZWQgbW9k
dWxlcyB2aWEgL3Byb2Mgd2hlbiBwcm9jZnMNCj4gc3VwcG9ydCBpcyBlbmFibGVkIGludG8ga2Vy
bmVsL21vZHVsZS9wcm9jZnMuYy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEFhcm9uIFRvbWxpbiA8
YXRvbWxpbkByZWRoYXQuY29tPg0KPiAtLS0NCj4gICBrZXJuZWwvbW9kdWxlL01ha2VmaWxlICAg
fCAgIDEgKw0KPiAgIGtlcm5lbC9tb2R1bGUvaW50ZXJuYWwuaCB8ICAgMSArDQo+ICAga2VybmVs
L21vZHVsZS9tYWluLmMgICAgIHwgMTMxICstLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLQ0KPiAgIGtlcm5lbC9tb2R1bGUvcHJvY2ZzLmMgICB8IDE0MiArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysNCj4gICA0IGZpbGVzIGNoYW5nZWQsIDE0NSBpbnNlcnRp
b25zKCspLCAxMzAgZGVsZXRpb25zKC0pDQo+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGtlcm5lbC9t
b2R1bGUvcHJvY2ZzLmMNCg0KQ2hlY2twYXRjaDoNCg0KCXRvdGFsOiAwIGVycm9ycywgMiB3YXJu
aW5ncywgMiBjaGVja3MsIDMxNSBsaW5lcyBjaGVja2VkDQo=
