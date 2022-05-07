Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6863E51E967
	for <lists+live-patching@lfdr.de>; Sat,  7 May 2022 21:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446840AbiEGTWn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 7 May 2022 15:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359057AbiEGTWm (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 7 May 2022 15:22:42 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED0E2B246;
        Sat,  7 May 2022 12:18:55 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 247E4tAJ025635;
        Sat, 7 May 2022 12:18:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DtJt8fAZfTqsKC1SO+xDCCuoIAjefACXXdD6i58KxOo=;
 b=pbl/NhQ4F3uJMz0rmYLebZo3ctXaNsNyGzHo171xV8bMfcNohKKreLTtM8zKZN+zfiCc
 /MrzYv6AaBgQgxfidTv4CGCzkibzg2RrFoFeTM2whJ2sRK8sVxumY9H+5oIqsWvwCVXS
 f/tVmewN4m4ReJEVwEoRU6Sdn+OUPJn3LNw= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fwpks9dhc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 May 2022 12:18:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PXklqu48x35ngQVaaLFraRMqO/U5kBN9xSxeCVr3h8jzSRmML+0wiCmnAXPo6df/Yhh8DRZFcjBrDngidteCUg3KC0H7xqFVivNeY3w6YPanSJUVq5VLXHV5rkuhsxdGT4BHMEVpjU9vBD8DDLhMsXdkUMLwVeaqtkWzUzWFMfBRRitg1ZcSwMqyForAU4AVhLwqc7eOqRYyZ/NpRfj5awNl/hEKfhrUWVPQzt4kbIXwKK7iJHnFOICrv1TMo6D7YBSKSGQxfsKep3UQ9ZDiB+Mp11gHo/hi0U+NQSCnXfdmV8cfqYqXS+cc97VdpOtuSjwBm8of49anYiAAXHMVPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DtJt8fAZfTqsKC1SO+xDCCuoIAjefACXXdD6i58KxOo=;
 b=NhGjHxdAJRX4Yk/eiRcvAYwT/CCWCQFVGkPLDMpZ9iTz/9pjCaZ1gq2ShVMW3TJe1asv2V80u2CjjNg8mykHtUbVZCZHlvCd+sXLH9H9+DCjY2S5WxxJorIQz4YiHfcHz18JjLcL2zOlxEdDlaUqIN/7tKO2HrmMWr7+hy8J8nEofzADdniK2VlNRyYjwSUtRysj9H/hJGisZdwUQpXwbbE2OU2XmwQ/NrPYat7MGbeXNRrR18QL0FqEua1VMyikN7DzLOkBn/oZbEK744BAFBe5W0cRfajWSNcmaW49wKF2Wr4V39ytbeouPJgneGzMypCxc4iKEOs/XnHyCccNSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO1PR15MB4969.namprd15.prod.outlook.com (2603:10b6:303:e4::23)
 by BL0PR1501MB2178.namprd15.prod.outlook.com (2603:10b6:207:35::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Sat, 7 May
 2022 19:18:51 +0000
Received: from CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730]) by CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730%6]) with mapi id 15.20.5227.020; Sat, 7 May 2022
 19:18:51 +0000
From:   Rik van Riel <riel@fb.com>
To:     Song Liu <songliubraving@fb.com>
CC:     "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Thread-Topic: [RFC] sched,livepatch: call klp_try_switch_task in
 __cond_resched
Thread-Index: AQHYYjpsdFy2RMM8vk2xmmtLa5gGmK0Tu5yAgAAKkoCAAAPtAA==
Date:   Sat, 7 May 2022 19:18:51 +0000
Message-ID: <901aa9a48ef02eeec73dedf051dd0b14436ac22f.camel@fb.com>
References: <20220507174628.2086373-1-song@kernel.org>
         <1b7f0b76b6060b6a0ccd04fec2be6c0323907c8e.camel@fb.com>
         <36BA01F0-F2B7-4290-AB23-E61989262AB3@fb.com>
In-Reply-To: <36BA01F0-F2B7-4290-AB23-E61989262AB3@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 834a6e88-0e0e-4c7c-24d2-08da305e6ba5
x-ms-traffictypediagnostic: BL0PR1501MB2178:EE_
x-microsoft-antispam-prvs: <BL0PR1501MB21782C4CA6DD4BC816922E65A3C49@BL0PR1501MB2178.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AoX+E7JdKl2o3ncI02T47yEuhkM+zjula8skOnazuFlpV0oYtHayokddQnKPP4yFxeDc0Rd9SgdkKkYnUUcTDkkzQMDTyfnI+BvBquXB/Fu6MHqTsq623/QC1dlr252WQBmpyoDcSA0a9bubgkZ0pBNsZoPALyZREJIRiqNF713RR7nMhM/DY2WLYyC3gUL6JO2LCsKujkL/FO9KMs51antDc4NE6wY5G9pwWPplrcjXUeIWPao339SK10d88abcUh7IaOrU0Jl2Ix4dEHDynVLHB7G/GC3qhWyUWwqNvEP6lPLwRdMFEsbDqLcXndp0QusHot4uaJbogE1uMCLZn9/FqyagMgb9CoN3NIGT3lWGRGZrheFACy8Hk/EjeLlfvjlNu7d8q9+AzDyKPGA5rX3NFFZeAHQk2NVL6RHHFoHVvXRc8S6c6ljMRdoI45FWU1RUZPG/QFxsatAmnNINDz1gkBxlv4gTHowp67F027X6NE9YdQUMX54+8Gkw9n2i26oOeyKjp/GhjvHkcSaCEg/8OU7imdKw9ygBkLU7nefhmt1paNewCeWpvpNbGy3WuqsUzd3gyLmqE//ftSg47pzWtS0xs2v8SaX/LfxmQXDmEhwp6o2ssS0b9Lh1d4InpT57EJKSaeWW3Yn2ITR1KZYU0GzoA57iJmQLdja9vP0brwRB6KjLF2VpRXFsk8EWpusBFd2b3SKeCgtQtri/iw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB4969.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(66946007)(66446008)(66556008)(66476007)(6512007)(71200400001)(64756008)(6862004)(8676002)(5660300002)(2906002)(38100700002)(508600001)(38070700005)(53546011)(86362001)(122000001)(6506007)(8936002)(6486002)(36756003)(316002)(186003)(91956017)(76116006)(54906003)(6636002)(37006003)(83380400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d3RSSEVIQ2VYaUFUN3dHQ0VUTndCajRIbDcwcFprVzJKYmFXam1sVE15eHZv?=
 =?utf-8?B?ZDlLUEVUZHIvSE1UclJFdE9RS0lVQ3c2d092SjUyNEJKL01yTkxZYkNnVjBk?=
 =?utf-8?B?YkJFWk1oTHZyQzVBV3F2WDlKOU9MQTFtRWszcC9CTHNqL0VMK2U2NlZLazBB?=
 =?utf-8?B?cVlkc25wNkJzL2J6Z0dWVmh1Ylg0Z29hVmdhTTVOTWp4TlM5L2gvL2hYOStB?=
 =?utf-8?B?QTljQktiL3pFMXVKQ2ZZT2c5dGJVTktXMFZMQjhyUE5YSFJBZUI1TVVlQ2VD?=
 =?utf-8?B?dCttRmRlQnVvQkQ1L29DTFNHT1VJRnNaaHkyT0x0MUIyWW9Sd25qMEovT1pY?=
 =?utf-8?B?QitoSHNFS2cxRnNTVTlHQWF2QzlCWHNIcnhwUUwwcFJhYVBRUmZ5OWgvU3NL?=
 =?utf-8?B?Tzl4RDVqUVpJb3VCZEVmQllKUlplazh4a2diZnptSFFDeTgzOGlvYWZUbzBY?=
 =?utf-8?B?NmVhYjlvUU1zaUdpRlUxRlhJdk1uYjhHT0JqM1RaNE9mUkRBNWtUYTFYZ1Jq?=
 =?utf-8?B?V1hvOHNxeld4U2tEc3lJdmNNRmNuUzNiRnNTNCtOeGxTZDNqSzN3NlpHU2VV?=
 =?utf-8?B?OWlJbHNyQjU0RTBBaXBZd3Q4Vm9ta2MvbEZmZjR2K28zRm5OOFRUSCtMbE1Q?=
 =?utf-8?B?M2ZYcXdOa2lRcUpQZCt2NXhCaUpGa0d5QmV5VERyL3h0OXlFWHV5dDFCT09o?=
 =?utf-8?B?UGRicXlySGpmcEJBbmJUSE5kWkdDRDNHZEFMS3ZTUUo1WUh0OWdSNG1CUDkr?=
 =?utf-8?B?RW44d0hNcWN5UmJkcEtEcXNpQXcwZEU3SXBCOVV0cGZ2dUNiSFdMMzNwMmky?=
 =?utf-8?B?S1BiOWg2aHhYVlNuUmZiSDdjZWFpSno3SWZqVDg0STRxZ2NqVEpDVGM4aG9o?=
 =?utf-8?B?bk9MZFBXLzVLT3lxRG8xb1Bacmp1SXdtVEg4UkNWMFIvcm50WnJPUzJ0Z0Fh?=
 =?utf-8?B?Y1ZzejR6Rk9SZDk5RFlpTDNXNTJDd0xmc28wUWFEeWRwLzJ4VjdsVkQ0MnBa?=
 =?utf-8?B?Q1diaFlaMXZvekNudjBFNGxQYzgyN2hYOUhUWDVZWGY1ckRRUkIvNEc2UlhZ?=
 =?utf-8?B?eVExUGNHOTNrdUtIWFFIQmpKSTNvenVyKzU3SnZwdWJFMGRsZTZvUEhZWVlT?=
 =?utf-8?B?V1lOVVB0bE9DN3h4MzFKMnJSellkZ042djN5RkVlTE5yY1g4cHRPUFNpK1dK?=
 =?utf-8?B?UWp1b2ROUEdiMlROd3lseWU1WU9PeFNOZy9MYzAxUW1sTFRqUHJWSWdVTE5s?=
 =?utf-8?B?RENZYVFSR21wbzFIUEttUnBoMDRkQVBZaFhoM2FyS0RQbG5lanE5ZWZlajR4?=
 =?utf-8?B?Wmh6dnhzd2loREJkc0JXY3VJOW9JZ2pyYzVSWFByQ0hYblE1YlJoenN6RlA5?=
 =?utf-8?B?SGNCdXlnS3h1YjlhRnhYT25tdnBEdE9yckJMZE4wUkhURWVXUVhtZEppV1Fk?=
 =?utf-8?B?VEJwblRLVUd0dXAweFoxdFZRZjJBVFgrOEc1aTh0ZGNtNXkzV3dZTS9udmIw?=
 =?utf-8?B?aVNPc21wZWVWL1FkRGtuQ0k0dlZMVVdtSmFRUTViUHJFUlZJaGxrLzFEMzNt?=
 =?utf-8?B?NlBLeWpRQUFTMi9TVmt4OU15UTNNSy9FNnN0cVl6cGVFcG5rblNTaG0wRm1F?=
 =?utf-8?B?TDFybVc1MTdIcUluOUtvcENXSnduNk5zeTlMSURQakFZVjNCYjZpeFN2NnhH?=
 =?utf-8?B?ckNqL2o2VHN0V3BQWjZ6Y3AyNW85bmVjbStUWW9Mb1VEMFBucVA0bUtjak11?=
 =?utf-8?B?V0J1UU42MTVWVUNTcndvZmc0aTQ0QlkvcEttNnZmdktEajAxQzNSZk1PUjlO?=
 =?utf-8?B?SDRmQlMwSW5OM1JzTUVZdGQ5ZjRXS2Z0SG1OejF5dCtvQU9uT3Q1UmxMTytE?=
 =?utf-8?B?enoxeERjanRCTjNHeTFrbjdpckZQWEZVK0p2c2kwem50dUFaTXlBK3pmTzVi?=
 =?utf-8?B?dlNTbFlGUUp6VXVndzEvZ1pWY2h6cng0SWY3UThZMElqdm96MEFOcU9wRzR6?=
 =?utf-8?B?ZTVxKyt2Ukd2alNrT3pOT3g0endFeDZmc0FpcHM5R0gzNEFtUkRneEdvT0ps?=
 =?utf-8?B?VmZVNFJFUnR0Qjltd2phUW9iZVZVaXRKUnBDeEI4T0tTU1M4bzQvTGMvNzEy?=
 =?utf-8?B?Rk1qSTh0MmUzUTB1bTJzVDEycHZqR25Ib25IeGxObEI0aG42WENmMXR2eVNX?=
 =?utf-8?B?OVBEaEI2ZlJNQTdjem1XWE1tbldwTEs2Z2FobnRCR2V5ZDhtQmZzYVFDMTl6?=
 =?utf-8?B?VXc5bjU3eUFOSkNNdm8rbTJSQ2NLWitxR0R0VWdBbStGTW1UaGszamp3QUIx?=
 =?utf-8?B?UVJRblh2RDg2U0ExOFdEN2tDRlhiMHBSOUJ3TVg5d0NtSXk3L2VzOWk0SkYv?=
 =?utf-8?Q?+onGc0eo95sCXdk0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E52007298055924995258D984EC0A60B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB4969.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 834a6e88-0e0e-4c7c-24d2-08da305e6ba5
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2022 19:18:51.6921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CLRh4WrW2PO4q7cdHyq2Bch+Tk8aZauNQE42mkSCToRG2wRDNrvYqhxqlUyRuF4W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR1501MB2178
X-Proofpoint-GUID: oxhG9eHke-DPNNrjNqBny6gky4kIYRW_
X-Proofpoint-ORIG-GUID: oxhG9eHke-DPNNrjNqBny6gky4kIYRW_
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

T24gU2F0LCAyMDIyLTA1LTA3IGF0IDE5OjA0ICswMDAwLCBTb25nIExpdSB3cm90ZToNCj4gPiBP
biBNYXkgNywgMjAyMiwgYXQgMTE6MjYgQU0sIFJpayB2YW4gUmllbCA8cmllbEBmYi5jb20+IHdy
b3RlOg0KPiA+IA0KPiA+IE9uIFNhdCwgMjAyMi0wNS0wNyBhdCAxMDo0NiAtMDcwMCwgU29uZyBM
aXUgd3JvdGU6DQo+ID4gPiBCdXN5IGtlcm5lbCB0aHJlYWRzIG1heSBibG9jayB0aGUgdHJhbnNp
dGlvbiBvZiBsaXZlcGF0Y2guIENhbGwNCj4gPiA+IGtscF90cnlfc3dpdGNoX3Rhc2sgZnJvbSBf
X2NvbmRfcmVzY2hlZCB0byBtYWtlIHRoZSB0cmFuc2l0aW9uDQo+ID4gPiBlYXNpZXIuDQo+ID4g
PiANCj4gPiBUaGF0IHNlZW1zIGxpa2UgYSB1c2VmdWwgaWRlYSBnaXZlbiB3aGF0IHdlJ3JlIHNl
ZWluZyBvbg0KPiA+IHNvbWUgc3lzdGVtcywgYnV0IEkgZG8gaGF2ZSBhIG5pdHBpY2sgd2l0aCB5
b3VyIHBhdGNoIDopDQo+ID4gDQo+ID4gPiArKysgYi9rZXJuZWwvc2NoZWQvY29yZS5jDQo+ID4g
PiBAQCAtNjk5MCw2ICs2OTkwLDkgQEAgU1lTQ0FMTF9ERUZJTkUwKHNjaGVkX3lpZWxkKQ0KPiA+
ID4gwqAjaWYgIWRlZmluZWQoQ09ORklHX1BSRUVNUFRJT04pIHx8DQo+ID4gPiBkZWZpbmVkKENP
TkZJR19QUkVFTVBUX0RZTkFNSUMpDQo+ID4gPiDCoGludCBfX3NjaGVkIF9fY29uZF9yZXNjaGVk
KHZvaWQpDQo+ID4gPiDCoHsNCj4gPiA+ICvCoMKgwqDCoMKgwqAgaWYgKHVubGlrZWx5KGtscF9w
YXRjaF9wZW5kaW5nKGN1cnJlbnQpKSkNCj4gPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGtscF90cnlfc3dpdGNoX3Rhc2soY3VycmVudCk7DQo+ID4gPiArDQo+ID4gPiDCoMKgwqDC
oMKgwqDCoCBpZiAoc2hvdWxkX3Jlc2NoZWQoMCkpIHsNCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBwcmVlbXB0X3NjaGVkdWxlX2NvbW1vbigpOw0KPiA+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiAxOw0KPiA+IA0KPiA+IFdoaWxlIHNob3VsZF9y
ZXNjaGVkIGFuZCBrbHBfcGF0Y2hfcGVuZGluZyBjaGVjayB0aGUgc2FtZQ0KPiA+IGNhY2hlIGxp
bmUgKHRhc2stPmZsYWdzKSwgbm93IHRoZXJlIGFyZSB0d28gc2VwYXJhdGUNCj4gPiBjb25kaXRp
b25hbHMgb24gdGhpcy4NCj4gPiANCj4gPiBXb3VsZCBpdCBtYWtlIHNlbnNlIHRvIGZvbGQgdGhl
IHRlc3RzIGZvciBUSUZfTkVFRF9SRVNDSEVEDQo+ID4gYW5kIFRJRl9QQVRDSF9QRU5ESU5HIGlu
dCBzaG91bGRfcmVzY2hlZCgpLCBhbmQgdGhlbiByZS1kbw0KPiA+IHRoZSB0ZXN0IGZvciBUSUZf
UEFUQ0hfUEVORElORyBvbmx5IGlmIHNob3VsZF9yZXNjaGVkKCkNCj4gPiByZXR1cm5zIHRydWU/
DQo+IA0KPiB4ODYgaGFzIGEgZGlmZmVyZW50IHZlcnNpb24gb2Ygc2hvdWxkX3Jlc2NoZWQoKSzC
oA0KDQpIdWgsIEkganVzdCBsb29rZWQgYXQgdGhhdCwgYW5kIHRoZSB4ODYgc2hvdWxkX3Jlc2No
ZWQoKQ0Kb25seSBzZWVtcyB0byBjaGVjayB0aGF0IHdlIF9jYW5fIHJlc2NoZWQsIG5vdCB3aGV0
aGVyDQp3ZSBzaG91bGQuLi4NCg0KDQovKg0KICogUmV0dXJucyB0cnVlIHdoZW4gd2UgbmVlZCB0
byByZXNjaGVkIGFuZCBjYW4gKGJhcnJpbmcgSVJRIHN0YXRlKS4NCiAqLw0Kc3RhdGljIF9fYWx3
YXlzX2lubGluZSBib29sIHNob3VsZF9yZXNjaGVkKGludCBwcmVlbXB0X29mZnNldCkNCnsNCiAg
ICAgICAgcmV0dXJuIHVubGlrZWx5KHJhd19jcHVfcmVhZF80KF9fcHJlZW1wdF9jb3VudCkgPT0N
CnByZWVtcHRfb2Zmc2V0KTsNCn0NCg0KSSB3b25kZXIgaWYgdGhhdCB3YXMgaW50ZW5kZWQsIGFu
ZCB3aHksIG9yIHdoZXRoZXINCnRoZSB4ODYgc2hvdWxkX3Jlc2NoZWQgc2hvdWxkIGFsc28gYmUg
Y2hlY2tpbmcgZm9yDQpUSUZfTkVFRF9SRVNDSEVEPw0KDQpJZiB0aGUgbGF0dGVyLCB0aGUgY2hl
Y2sgZm9yIFRJRl9QQVRDSF9QRU5ESU5HIGNvdWxkDQpqdXN0IGJlIG1lcmdlZCB0aGVyZSwgdG9v
LiBQcm9iYWJseSBpbiB0aGUgc2FtZSBtYWNybw0KY2FsbGVkIGZyb20gYm90aCBwbGFjZXMuDQoN
Cg0KPiBzbyBJIGFtIG5vdA0KPiBxdWl0ZSBzdXJlIHdoYXTigJlzIHRoZSByaWdodCB3YXkgbyBt
b2RpZnkgc2hob3VsZF9yZXNjaGVkKCkuIA0KPiBPVE9ILCB3ZSBjYW4gcHJvYmFibHkgc2VlIHNo
b3VsZF9yZXNjaGVkKCkgYXMtaXMgYW5kIGp1c3QgDQo+IG1vdmUga2xwX3BhdGNoX3BlbmRpbmcs
IGxpa2UNCj4gDQo+IGludCBfX3NjaGVkIF9fY29uZF9yZXNjaGVkKHZvaWQpDQo+IHsNCj4gwqDC
oMKgwqDCoMKgwqAgaWYgKHNob3VsZF9yZXNjaGVkKDApKSB7DQo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCBpZiAodW5saWtlbHkoa2xwX3BhdGNoX3BlbmRpbmcoY3VycmVudCkpKQ0K
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGtscF90cnlf
c3dpdGNoX3Rhc2soY3VycmVudCk7DQo+IA0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAgcHJlZW1wdF9zY2hlZHVsZV9jb21tb24oKTsNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIHJldHVybiAxOw0KPiDCoMKgwqDCoMKgwqDCoCB9DQo+ICNpZm5kZWYgQ09ORklHX1BS
RUVNUFRfUkNVDQo+IMKgwqDCoMKgwqDCoMKgIHJjdV9hbGxfcXMoKTsNCj4gI2VuZGlmDQo+IMKg
wqDCoMKgwqDCoMKgIHJldHVybiAwOw0KPiB9DQo+IA0KPiBHaXZlbiBsaXZlIHBhdGNoIHVzZXIg
c3BhY2UgdXN1YWxseSB3YWl0cyBmb3IgbWFueSBzZWNvbmRzLCANCj4gSSBndWVzcyB0aGlzIHNo
b3VsZCB3b3JrPw0KDQpUaGF0IHNob3VsZCBjZXJ0YWlubHkgd29yayBvbiB4ODYsIHdoZXJlIHNo
b3VsZF9yZXNjaGVkDQpzZWVtcyB0byBhbHdheXMgcmV0dXJuIHRydWUgd2hlbiB3ZSBjYW4gcmVz
Y2hlZHVsZT8NCg0KDQo=
