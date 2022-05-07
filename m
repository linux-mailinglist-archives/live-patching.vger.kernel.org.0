Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308E251E937
	for <lists+live-patching@lfdr.de>; Sat,  7 May 2022 20:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350978AbiEGSau (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 7 May 2022 14:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbiEGSat (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 7 May 2022 14:30:49 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDBD22508;
        Sat,  7 May 2022 11:27:01 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 247BdW3m015199;
        Sat, 7 May 2022 11:27:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=nOcxOsRrWaz7pCoefleVEPKUeM8YGtzstMgGli9Ua64=;
 b=WzLlUqz3VUODyP6sliI6CI+EiCYqs8dIGySldPBh6HUs0xv8UZ/KcoB1pm35UnWWcRug
 9twj8V2bQ8QG1KAkfCxxLA1BOYRzwII7/jkyACHh7yNR/c+84SpxRQ7kPGf3gKJ/5dYd
 bYxdaaO0zE8WlalpVAl4Lr08FOHjkSPjmt0= 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by m0089730.ppops.net (PPS) with ESMTPS id 3fwm97sm9w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 May 2022 11:27:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cflWfAV3Bpk9t4gQb70NJZ1Ekz/RmxKUrs2SMl3oHt26J0slS8Rl4bjX5csPGqkvPzoYkxo3yl1d9REUmuYybmhukgdAKZ0COXNu9Ys4KDIYlq52RfLYcp/GmlE54ewFT1YpXW0cJaBE4mTP8+Icr1zUbgajz/bUHdjbdlfLZkCXO+NOxf1dwMmQRZoOPs77TU3HBeRil/d5HXGIN0AbxvkrdPq5ffGtkslHo57que7CNyBQt9BG4uKWdUe0f2rhsz6mgQ0E6N4LXC/JXhZqedht77ZgIqR8qOWgn7FbnF8PtBLu0aCgkiTSKbzV2yo8HhTo/3p+h8N+wPAQq679jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nOcxOsRrWaz7pCoefleVEPKUeM8YGtzstMgGli9Ua64=;
 b=oNRb5z16Gfe4kXCG+K1Tscu6Qwk+0nA2SsWBLMEr8ELRFRpSfY3xADLv/wzkI8uLWooDHZFsLHbkd6dY2efn2Qm9OR3fjhQiBayxcSo5WZT816zJwyo5YMyH/sX8pAfeisKiqDCNevu1DeffHGpZV068j8AzTxmIkNZlqloyuUpLH5RZtO+LXZKa8u/h9VBY6y1SEUIBEsdWT9gesfrAzwweC97pF95E2EOQnuAUsNDbhd3slsJV9fqfJdAyY1hA6w3ksf8thoudYvDwiJJJam8PDBC1U3nAyQky6lk6O1Qw+eQaw908bCBFHZ7lYrwCpMe/xwg1WHv5MpIiXDyBIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO1PR15MB4969.namprd15.prod.outlook.com (2603:10b6:303:e4::23)
 by PH0PR15MB4768.namprd15.prod.outlook.com (2603:10b6:510:9b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sat, 7 May
 2022 18:26:58 +0000
Received: from CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730]) by CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730%6]) with mapi id 15.20.5227.020; Sat, 7 May 2022
 18:26:58 +0000
From:   Rik van Riel <riel@fb.com>
To:     "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "song@kernel.org" <song@kernel.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Thread-Topic: [RFC] sched,livepatch: call klp_try_switch_task in
 __cond_resched
Thread-Index: AQHYYjpsdFy2RMM8vk2xmmtLa5gGmK0Tu5yA
Date:   Sat, 7 May 2022 18:26:58 +0000
Message-ID: <1b7f0b76b6060b6a0ccd04fec2be6c0323907c8e.camel@fb.com>
References: <20220507174628.2086373-1-song@kernel.org>
In-Reply-To: <20220507174628.2086373-1-song@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2bc89f5-9fda-49fe-dc96-08da30572bf8
x-ms-traffictypediagnostic: PH0PR15MB4768:EE_
x-microsoft-antispam-prvs: <PH0PR15MB476881D7D7F46517A2D8B8F0A3C49@PH0PR15MB4768.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xcz8CMSqPk8m83Us+zB62AQQxjikZRQ+j9l3bqvVJjhUB1xqkul6jVd+8FZAYz0b7w4rmQ3YRmNp90dgWUP6DPCPB80TaSHaUxGxMzzsGmLMzMzoCy5byD1si7uH4a5tok/eOJSdeQKUSQR6Z8SlzR3OqDYSHctDw+xH+6/u9EmN4E1V5OFe0e8O9PtOfcBZ3vJw0WiTakiU8jk4CnTQ0DDEhUz3ycWUEE71Tj7fBMJSb7T2VgdowxojyID9EV/D3Pw9hkEOt/RIVvMm3mTLFzokA6vZ0TloTfGErmhcJkExGOCNmqALIgPtxxTIOysLLmWfq7lb0G4bI4QtcD7A4a5469YsSZh8Kb1VLf+cGnRMp47DEgYd/QyFg3Yj1TtvIHQHFIXo1ubkPEJmfBoZNrjU/Ia2pwrUtgvuWjL3/fiJ8NmdDKfUqAL9cO/c20nNkrvrsIYPzbcCs5Y2x3pr7n5mafM/KQnOysCbQqL2ZkcdgVvLwYDwY/nwZhG1s8pQ1MOAkb4Ot2OaP92tWkP3JtuHr6akO9j5yPljtnURfNSTPNHFJY4pRzdKC4yG7NCIqxgBP7eNrR2MSKIvvL+Y1USFrYhPP1Js7Yw3Hgxyb0rkfn9cO0vNLPeRbabsAPEnnqyMhNaZ6XgEpUzqw2Ng3SNCOtSluhldX0qusfj17gUuu3Ej3mU7khT4GtuqfVUGwBAnWYUUWJMwcufCDSpXPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB4969.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(71200400001)(86362001)(8676002)(4326008)(64756008)(91956017)(76116006)(66476007)(66556008)(66946007)(66446008)(83380400001)(2616005)(6506007)(508600001)(8936002)(5660300002)(4744005)(6512007)(186003)(2906002)(316002)(6486002)(122000001)(36756003)(38100700002)(38070700005)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXhyYmVYbTFPeEJqVWZ5L3VjVS9zVzdCV0RaK245Ty9PSm1WZElrb0gxOFZz?=
 =?utf-8?B?dFN2U1RmemI0SEEwMUVwMTFiMzNxUE5ROXgvUDVIVUVKeDM0N3RMQ2d1d1pt?=
 =?utf-8?B?TzhJOEdnTzRTSWZvdEVTaEIrN0c0M2dEdTFpdmdXU0c5RjZtM0tZSkU0NC9o?=
 =?utf-8?B?UnFJSDVhem9QYjMvZ3FzSVR0UUlTRE9vMHNjaVgrek5VVzFnaCttVnN2ZWFY?=
 =?utf-8?B?N3FUUmhXY0hKcFdVUXZJV2gyZllucVJYTEtoWkE1clRCSFdmdXJpMGFOaWdM?=
 =?utf-8?B?WnM0TXh4OGtuSXh1QWxNazNJdlVDcE81akZwRVhWdmlZUUM2QzcyaXhtWkNq?=
 =?utf-8?B?WGd6My9mYU5TNGZIUlE0bEszdUczbzNHMXR0NjY1alhrMHpBbXgva3NZbEw4?=
 =?utf-8?B?cno5S2lYL3JlK2ZIZEdxeGFoeXhId0RUN3Y3TlRaczE5aUU0c2JDMzdJNGYx?=
 =?utf-8?B?a3hKa0pLNEZBc0ZlbkFJWE9xdytYWjBLYzAvMzJkbFY2a1ZKZTYwSnQ1a3Zk?=
 =?utf-8?B?c1orcDRYL3l4U0xPa05pU0xRaG0zT0FUdDNHbnBucDZrUjE3K2U2TmdKclJG?=
 =?utf-8?B?ZXl4dVFMT3lxRlc1VS94Y2VrdXNIRXQ0VEJiRTc1NHJUVGlDb1FMMk1iNGVV?=
 =?utf-8?B?MzQyY0p6ZXhxSnBFTHYyTXBlakJrMVZQQk13amd6YUxYekxkZTNHa1d5Rzlv?=
 =?utf-8?B?blFLaHJtQ2gyRi9TRFRMSHY4OExlWVF1U1lsTDhRemFkbWxqNWxKZ09kaXFI?=
 =?utf-8?B?L0lDZDlJRk5LaC9qQXM5K2sza1c2bE1lM1V6cWJaL2V6U25ibXBxQXI3OG9t?=
 =?utf-8?B?K0JWcE0yV29HWEtFOEVxb2pvaHZlbkRLMDVEbEF2bDVXN0FaS1R3NG1nMW1I?=
 =?utf-8?B?SFlITFlHTXErZTVKMmIxQXQyRjZXZzZhaVJvZ2RFSnZkZkxaUlc0YkQ4aXNP?=
 =?utf-8?B?MDFwc3B5RFFHcUw2ZTRpQWdDSjRVYlZOVENBR0pnNmZSOTJoa1BhZXdqbXFG?=
 =?utf-8?B?WUg3eDQxNVFjczNUeXRkbWRjVndwcm04bXRMc1BaSjZWK1hyeitYaFNLYnlD?=
 =?utf-8?B?azhTNTFmc1BjNHBjc1l2OVZFMVl6QmxWZVlrS2F2QjdCVXk4TGRBNjNRTGx5?=
 =?utf-8?B?ZkZTODA4dVM4bWpmaWtJZjVPTWJQVjZXcmFISmNoYmV4b21mZjI5WWNLOE5Z?=
 =?utf-8?B?YjFmWFdQSnZtRlovVFFoWk01K0oyUHVHQmFrcE5rcWlEcGg1d2ZLRUczbE5C?=
 =?utf-8?B?MCsvVjRoMUdqT3FRTlNaQWY4MWZYVU1Pam1NRDlzS2ttZ1lpU0RtTGZGMlFG?=
 =?utf-8?B?SU9VVFFDd0VtRGc1MG9vL1c4WjEwbGYxYVM4ZWtUb0ZKL1orc1pzaStzb1d2?=
 =?utf-8?B?K2trYld2cXdHZ0lKQ2ttZVE0QW45a0tzZFVMRnZ4UkVQaHJVeXJSVXU1QXRP?=
 =?utf-8?B?WXhmMi9vbHNEVE1aVUFCVjdUU05abzVYdVNGYzRvRktTOVlrSUF0TUFQVUhQ?=
 =?utf-8?B?K0Nzc00xRTduajVDQzNUTUhKdWdnWGIrQmYwOWVOU0ZZV09UblQ4M1FUNFdt?=
 =?utf-8?B?aFJ6SWFia1VjQndVN01NbWVqVGtOZWJHUW9LamFoOGorSnpoVDVkVmlDT00w?=
 =?utf-8?B?Uk56UzVtQ254Um9Ycmt6OUpub3Njd3A2dFEwdmVIYkhPZStWMnRFT0xrZnNZ?=
 =?utf-8?B?a3lHYkMxYXFGS2lhQyt2eStES1dHdUp6K1BWeSs5ZDFEUEhadFNXTHEwMW9G?=
 =?utf-8?B?bENjWnRUa1AzUEJVMU5IWXM1aEdXMVNVaGFISnYxVUFpRkhkN3JOQWFLcGFO?=
 =?utf-8?B?SjdhQ0hESGtQMWRpT1RYcmdtaldoaGU1dlJ2UnZCc2QyRmt6Sm0xNVJ3d2Fu?=
 =?utf-8?B?TEJ4eUowcERxNFc4Qnl6T0tObjd0a0pScFlhV2N3bzdYUDBVM09qMk1yS1RU?=
 =?utf-8?B?cnBRUi9sN3dZRFRmRGVqczd2eFg2Y3dTNmEwWTdZZ0pBL2lPRVlsNFhOMjlx?=
 =?utf-8?B?enFGS3B1cXlYYW1Jd0lSQ3J1VnVaL0VQb0hJSEF1d3RxNGNPVlIrWDRDTjlt?=
 =?utf-8?B?cWJYb0ZScVp3dCtvVXlJcmlsbDdVMnIxMnhxb3pjeitWcHhpcVZZd0VpOTd1?=
 =?utf-8?B?bWtmZ3BzUGNId0R1ZlI4S3k2WlhXa2UwdTN4Y1FTQXgrNVJLVlRxR0cwVnRT?=
 =?utf-8?B?bHFycWNBY285OFJ4aEUvOEphVms0K2t2Sm1pNjlzeHF2NkZyL2tMZE5JN09E?=
 =?utf-8?B?OGpaVWpFTEFuRVNsK0hvVkFlU1ZFNXJiSXlXbHNKWTFUR3BhSXRubHJTNHhN?=
 =?utf-8?B?OWhsU24wUnJOcEdEZUlXVHhCNDkvR284WHRUL09WRHlaRmhYMkJYdjh1V2FU?=
 =?utf-8?Q?FiK4hEQ6sTUQ9dQE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C042F7CE3516F438A4643AB9323B9FC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB4969.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2bc89f5-9fda-49fe-dc96-08da30572bf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2022 18:26:58.3739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0t5J6UwofR5DYxuLhaWBpzyPW5UUpsURD1LPDk9Sy9rsFYMwFD2g0w8lYoPHUCQp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4768
X-Proofpoint-GUID: DpFbQh8ypAsB4Uk4Yu45XevEXqEi1I4e
X-Proofpoint-ORIG-GUID: DpFbQh8ypAsB4Uk4Yu45XevEXqEi1I4e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-07_06,2022-05-06_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

T24gU2F0LCAyMDIyLTA1LTA3IGF0IDEwOjQ2IC0wNzAwLCBTb25nIExpdSB3cm90ZToNCj4gQnVz
eSBrZXJuZWwgdGhyZWFkcyBtYXkgYmxvY2sgdGhlIHRyYW5zaXRpb24gb2YgbGl2ZXBhdGNoLiBD
YWxsDQo+IGtscF90cnlfc3dpdGNoX3Rhc2sgZnJvbSBfX2NvbmRfcmVzY2hlZCB0byBtYWtlIHRo
ZSB0cmFuc2l0aW9uDQo+IGVhc2llci4NCj4gDQpUaGF0IHNlZW1zIGxpa2UgYSB1c2VmdWwgaWRl
YSBnaXZlbiB3aGF0IHdlJ3JlIHNlZWluZyBvbg0Kc29tZSBzeXN0ZW1zLCBidXQgSSBkbyBoYXZl
IGEgbml0cGljayB3aXRoIHlvdXIgcGF0Y2ggOikNCg0KPiArKysgYi9rZXJuZWwvc2NoZWQvY29y
ZS5jDQo+IEBAIC02OTkwLDYgKzY5OTAsOSBAQCBTWVNDQUxMX0RFRklORTAoc2NoZWRfeWllbGQp
DQo+IMKgI2lmICFkZWZpbmVkKENPTkZJR19QUkVFTVBUSU9OKSB8fCBkZWZpbmVkKENPTkZJR19Q
UkVFTVBUX0RZTkFNSUMpDQo+IMKgaW50IF9fc2NoZWQgX19jb25kX3Jlc2NoZWQodm9pZCkNCj4g
wqB7DQo+ICvCoMKgwqDCoMKgwqDCoGlmICh1bmxpa2VseShrbHBfcGF0Y2hfcGVuZGluZyhjdXJy
ZW50KSkpDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBrbHBfdHJ5X3N3aXRjaF90
YXNrKGN1cnJlbnQpOw0KPiArDQo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoc2hvdWxkX3Jlc2NoZWQo
MCkpIHsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwcmVlbXB0X3NjaGVkdWxl
X2NvbW1vbigpOw0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAxOw0K
DQpXaGlsZSBzaG91bGRfcmVzY2hlZCBhbmQga2xwX3BhdGNoX3BlbmRpbmcgY2hlY2sgdGhlIHNh
bWUNCmNhY2hlIGxpbmUgKHRhc2stPmZsYWdzKSwgbm93IHRoZXJlIGFyZSB0d28gc2VwYXJhdGUN
CmNvbmRpdGlvbmFscyBvbiB0aGlzLg0KDQpXb3VsZCBpdCBtYWtlIHNlbnNlIHRvIGZvbGQgdGhl
IHRlc3RzIGZvciBUSUZfTkVFRF9SRVNDSEVEDQphbmQgVElGX1BBVENIX1BFTkRJTkcgaW50IHNo
b3VsZF9yZXNjaGVkKCksIGFuZCB0aGVuIHJlLWRvDQp0aGUgdGVzdCBmb3IgVElGX1BBVENIX1BF
TkRJTkcgb25seSBpZiBzaG91bGRfcmVzY2hlZCgpDQpyZXR1cm5zIHRydWU/DQo=
