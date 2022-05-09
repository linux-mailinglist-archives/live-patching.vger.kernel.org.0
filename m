Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4940A51FF37
	for <lists+live-patching@lfdr.de>; Mon,  9 May 2022 16:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236927AbiEIORQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 May 2022 10:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236931AbiEIORP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 May 2022 10:17:15 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D821DE540;
        Mon,  9 May 2022 07:13:22 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 249Dgrl9027979;
        Mon, 9 May 2022 07:13:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rAz9GOINI+iCIZTovSI4nYsrh6mRjLtFMmRhCafUf0M=;
 b=PATdAh/dzJEck64hHqUKtvypAkr0JZcXJfbfUO0LZVXbUTQXKQ1uAsd/NEQxrpcJz3K+
 1fCau6l7YjPxTK+ZlsNYCwZ8Uho1UCbkxqRhOTblT1i3JUtscr/UVWuaunTDnc1refXz
 TR0UM9p8kUpv1z80cSvgzUZ3lkbWYompkVw= 
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2044.outbound.protection.outlook.com [104.47.51.44])
        by m0089730.ppops.net (PPS) with ESMTPS id 3fxhwwv0fp-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 07:13:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n4nnBsi/IK++iVhVnZVIIpA+ZK5aYT0lnAcQmJZ7Z0ZlAQ5b31ZpOZpHfVR/ANDMVhldQ4SODT0KgA70m5vyoLbRkqwT1udjfFPp1TwK5NafpEfhznD9vU6i+F94QR4CjzcgZZwHQZPcmdBk2wplVpKTvKgGk3ihnsK+36WQ6YiNIleb9cOEV5vjCR8/C/J2QMrO7TkEkJPp2CycUGerjg74krETMb0Z2kLY+sLtRWHaqKccyOuH5CDbe9bPfbpwy6tVxdAUMKG8FUIHNpOtlBQSgc5ILclwXjEtSQXFmJcop00X/Q9KRRGpsui45oTgBUrfLJCwUJ6HkhQAHmkedA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rAz9GOINI+iCIZTovSI4nYsrh6mRjLtFMmRhCafUf0M=;
 b=obvsw74AyaKr2DCaDU3WJ3mIEgKHLdz/B77F+ySRdH/GFAmLgHC3f0GktqDdq24FNbtnzSZggDd5xFlcAu/2KIgOcSo7MUJxECnohtq1c6KTuuj7Q15VPikW83ZuQwRcWhUVL9kLvtwh8jRPxpT1b8brToOY89ttynIZ6sg2rHW7HDDtkfipxWkR5FO8JNMnj+1X4dPTAQ7iXEHLLyBrzr62UAiNa57Kcxk/5Fteo5LOd35Gz76P//qk2vyQccAz0fwO7e5jnvfKkaLJM0IcBa8I9DVUZjlnEYIxAJ9L7eAMMw5xjhOZ48h4moVGqiZuoTBeOCwLFeh9rb2QG5NdBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO1PR15MB4969.namprd15.prod.outlook.com (2603:10b6:303:e4::23)
 by BYAPR15MB2935.namprd15.prod.outlook.com (2603:10b6:a03:fd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 14:13:17 +0000
Received: from CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730]) by CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730%6]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 14:13:17 +0000
From:   Rik van Riel <riel@fb.com>
To:     "peterz@infradead.org" <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>
CC:     "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "song@kernel.org" <song@kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Kernel Team <Kernel-team@fb.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Thread-Topic: [RFC] sched,livepatch: call klp_try_switch_task in
 __cond_resched
Thread-Index: AQHYYjpsdFy2RMM8vk2xmmtLa5gGmK0WIaGAgAARQQCAABm+AIAATMUA
Date:   Mon, 9 May 2022 14:13:17 +0000
Message-ID: <0f6a45f80d01e9a5054c7973090a479707bda52f.camel@fb.com>
References: <20220507174628.2086373-1-song@kernel.org>
         <20220509070437.GC76023@worktop.programming.kicks-ass.net>
         <9FA1822F-76EE-4174-86DD-B20F1F8CE7FC@fb.com>
         <20220509093830.GH76023@worktop.programming.kicks-ass.net>
In-Reply-To: <20220509093830.GH76023@worktop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d6e5855-1602-4fc6-7dda-08da31c6108f
x-ms-traffictypediagnostic: BYAPR15MB2935:EE_
x-microsoft-antispam-prvs: <BYAPR15MB2935FB7EF28DD6A7E7271AFAA3C69@BYAPR15MB2935.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NIsJB19swaHBxZ4HFl8dVlT78gN8+RHmImbnfXRapNl3Vbbyr/B2yNXgAg9HW0uvcruKpV/d7iFkU4iOlPPMjp/E4Rpy1j4LOfbeIsvMXwC+Non8dUpst6rGzC1ozz3HFlbZAHbEKRRlTKDbMqLB9zxvcYMOwgdsVizHTOgiNDwyeO4I2AB/vZReCnoH3vmts9mHP3FCD1j+WYkF5wFh8kD7wTXyEakbBGHviECJwDm3QdrdTeXcWYxGZfC/voQ8ZTAo1zNFruTeIZhmsKt4ZCDLyUHF6/bAPM8/qbY54c1vQADDlqL05FBK1irJahgeKPOB6OW6ARNoJr4Og/l72RIf3YUZtFrn2pPITmpXkKhyL1YmJw8b6+QRa1uxk2+zqeRmkI/dBwPyO/mszpT5A2DhttybgPW09BxOucBdPxe9AALA0vN+ZDTwt1Ni7Eamn+0jAZMIbWPDHuDag6PnfdYVahlJOD+hkjAOqvzcerqhg3rIUjWYD41x8Xkrn5vcRXQjzkWmgJAeK62c69qGzLIx1rto7yVX5ZQhjUhI75vds1XPGSQQXRRzNYrlMnBQSQQtAwKgW1QVQK0J2N8csoIQEKET98+zxma0YUWtPT3xGNR9V9/jjfjBOrCBI4SyxmFA98e+CL8vSjux9rzoKkfTCzIjlM2K6opqVRhX6cjdJUuPQhRn20u7rIaWiUKpLRMFV+/Lk45aQ5F0w5SJzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB4969.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(53546011)(6512007)(83380400001)(71200400001)(36756003)(66556008)(5660300002)(186003)(2616005)(2906002)(122000001)(38070700005)(38100700002)(8936002)(316002)(508600001)(76116006)(6486002)(66446008)(64756008)(4326008)(66946007)(86362001)(8676002)(66476007)(6636002)(54906003)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NTBDMGtiUkw0bzYxUHdqaGlCVmtUd2YyUGZCM3hkTng5Rm0xUW9qdldqbVA3?=
 =?utf-8?B?TGpsUWJja3dmVnl0My8vM0dpcThpeUNURW1DckJ5Y1Z2YjdSQUMzNVhnRWhi?=
 =?utf-8?B?cnErQTBpY2MxTDNkeEVINlphMysrMThxTUFkTU1FeW1qRm1TejVQajgxQnVT?=
 =?utf-8?B?V2duSEwwem1sc1RxMEc1Rm5GaURmUERpbDJHcm8va0xFOGhNV0JnbDRWYzQ2?=
 =?utf-8?B?KzA5QUVkbUdXOXRGVmQ5bEt5b3ZiZGErbDVoTzh1eCt2NkY4RDVtVXZ6Y2lZ?=
 =?utf-8?B?YnNkVTdocXlzNUcvVk9TbUVpalU5RkljWnROb25LMmlrZllZR0IvdmtXTFcx?=
 =?utf-8?B?T3hRdjljbWVFWkVnZzdVVnN6c201NVNIRER2MlE0Z2YrVTlVWkpkTjVKL1Nv?=
 =?utf-8?B?OHl0a29SRUNBSHZJYnBoZlVudjBHTkZIUzhqdFh5RjU4SU5VUVNvNUJOTHV4?=
 =?utf-8?B?OUNyUGRkYm02K3o2d09rbmNkazdFYzF1NW1VdEhxc3RldzUyZ1R2eUNsVmRY?=
 =?utf-8?B?NlI5UEw3RWc0cEFPblZQaDVqSnNyN29oZ0E2d1ZYMi8vdzZLblRuYWJQSHRp?=
 =?utf-8?B?ZzF1R2pKclRyQm9yT09UNFJOTitjNG5qS2hlbjZFZkcyUVhOVGVLcXVDN3h3?=
 =?utf-8?B?Q2dJNjE4bDZNYVFTTUJZL0RCbVdTbVVUd3E5QXl1KzkxK201NWNPc0xSRUhk?=
 =?utf-8?B?dy9ZelErY01hQUFob1RrbkZ0Mm1VSnRENVFabW9lNnd5eXZpa2VlamdRRlkz?=
 =?utf-8?B?NHpHTWFIeC9GMkJ5clNRYlJFYmtlYXhRd3p6RVJzOGVrMkRtamlSZUdhR1ZX?=
 =?utf-8?B?dHFCYWNmUTNKeUg4RkJsQ0FlMVRuM3NWVnRSWTRYMmc2eUVSVFNvVjM4TytX?=
 =?utf-8?B?N2pDNllYOWRlYTRuSEZQRW9RSmliWjZYQWYwemZKRmZTdWRoVm9KM2JHQWx5?=
 =?utf-8?B?a2V3cFZiTXFoWllzMUNWSzBWMnBpUjBJNENZcXFaUGltb2p2OG55bHJoNERD?=
 =?utf-8?B?Z0dHcXU3dnJ1bTRnMW5La0x2QWlhc2VFYlVaSTViMEkybWxBMmhGT20xZG1m?=
 =?utf-8?B?RnhwUWFtMTFiRVBpU2FRc0xyNis0WDBZQVZsR2ZyT2QxdjdvK1hmSTM4RmM3?=
 =?utf-8?B?VXN4NTAzZWRlVnAxYnpPRzVDblI5cG9mY21DOFg3QktOL1NwZU5hcHFYRDZH?=
 =?utf-8?B?a2lVYldJRnVKSG9PNGJyOEZ1ZVVsWjExUlJIUEtrN05NUmtvcStHMisrVEMz?=
 =?utf-8?B?ZlZ5eUhockxHQVRUTk0wek1ETGhZLzJMTkkrQ1JYZ3JiSE1pbmt0ZDdxVUdh?=
 =?utf-8?B?a3BYYWdBMEZUd0VXSk8wQzRnMm5sZUVOMnhTSk51RVhHUG1MVG1oeXBkaXpk?=
 =?utf-8?B?YThERDY3WFVENTcrQlNINEZCRXJYd3RUcElTSWo1ZUhzZ2lQQ3hjSkw3akZ6?=
 =?utf-8?B?TzhGcEUwckNjK3JsNjNqU1pYZGtMR293cis4ZmJETWpqb29oWWNPUXV5YUlt?=
 =?utf-8?B?RjI2NXdydGxlbEVhSWF4Szc0T0oxOXh0VE90Z1YwdkEvUDlaRTEzQ0tPZWdM?=
 =?utf-8?B?RkNLN2g0UklSdmtDa2NwZ204bFFqek5SYldaUjhpOURteEN0VEFBc3BtVXJj?=
 =?utf-8?B?NjRabklsTW1XL2c4cFJDK1kvaUMrMzZ2MW9BVGUxMzhOTTE0QU0zMmFPWXJL?=
 =?utf-8?B?Y0VxREljaWNJRHFYU3ZwMXNtVWtCRXdHRms0YWVQR3dwR1JuTForNjJUcnBn?=
 =?utf-8?B?TXZRaW42RUYwM05TR0hmc1d0TjN5Vm1yRmRsM1lVSkZyTDhWQ3hmNlU0VjRp?=
 =?utf-8?B?L3NNUlJsSnRQdUdnbU1ILzVuMksrOTdhVmhDdFpBRW5jaEppZGl5T041cjNX?=
 =?utf-8?B?OVV3Z0lRbDh5ZXY1OUt1Q0RMSEdDUTdIRzJVYy9HSi9ncDJlMk9oTWxoTFph?=
 =?utf-8?B?dm0rVTRGc1VZcWxWQm9CdENEbVFIeDN3WllsRzNQU3NaenRPKzByaEdGMlZj?=
 =?utf-8?B?RUJjVldORGY5MWNxVml1MVE1NWlmWXhzTlQrUllDeDlLMzNsaGYra2dsYk9H?=
 =?utf-8?B?bTY0Yi9yRitaNW5ERFlHQnpNdnRibHdrZXFRZkN6QjBObmJ2cVFBMUtucmVh?=
 =?utf-8?B?YTZEQkp3eXAvRVFBRjdwMS9TYVNUYlYwRFBpZUxOckFVVzRiS29lbzRheEp1?=
 =?utf-8?B?aDJJNElxbno2SUpTMmhVYWcrQUF2ZGhnNjkrYTRCOFhubk01TnJmd1YvdXFJ?=
 =?utf-8?B?WTNGZkIwL2tSNjRjZzBNVjlFQlZJOFE1NGQzTG84NGVYK0RZWVp3RXNaa1Vr?=
 =?utf-8?B?dVZpMjJkZGpoNFBpYUFkbGlNbEppN1BVekUwaHFsZ1MzS2RDeDJadjdiNGR2?=
 =?utf-8?Q?WHO2HOfoeA0PxoM8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <704B0FCBF8D8BB43ACDF61C77366E2E1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB4969.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6e5855-1602-4fc6-7dda-08da31c6108f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 14:13:17.7002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nuzWsNfEkx1Edy8Z9OJZIP5+9Ow1UGa57ZBYgYDJ/ZGRJQp8roIg4pfFSNSBbatH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2935
X-Proofpoint-GUID: v514rRbaDtuQq94YEYnFj-mjArW-DTN-
X-Proofpoint-ORIG-GUID: v514rRbaDtuQq94YEYnFj-mjArW-DTN-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_04,2022-05-09_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

T24gTW9uLCAyMDIyLTA1LTA5IGF0IDExOjM4ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gTW9uLCBNYXkgMDksIDIwMjIgYXQgMDg6MDY6MjJBTSArMDAwMCwgU29uZyBMaXUgd3Jv
dGU6DQo+ID4gDQo+ID4gDQo+ID4gPiBPbiBNYXkgOSwgMjAyMiwgYXQgMTI6MDQgQU0sIFBldGVy
IFppamxzdHJhDQo+ID4gPiA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+IHdyb3RlOg0KPiA+ID4gDQo+
ID4gPiBPbiBTYXQsIE1heSAwNywgMjAyMiBhdCAxMDo0NjoyOEFNIC0wNzAwLCBTb25nIExpdSB3
cm90ZToNCj4gPiA+ID4gQnVzeSBrZXJuZWwgdGhyZWFkcyBtYXkgYmxvY2sgdGhlIHRyYW5zaXRp
b24gb2YgbGl2ZXBhdGNoLiBDYWxsDQo+ID4gPiA+IGtscF90cnlfc3dpdGNoX3Rhc2sgZnJvbSBf
X2NvbmRfcmVzY2hlZCB0byBtYWtlIHRoZSB0cmFuc2l0aW9uDQo+ID4gPiA+IGVhc2llci4NCj4g
PiA+IA0KPiA+ID4gV2hhdCB3aWxsIGEgUFJFRU1QVD15IGtlcm5lbCBkbz8gSG93IGlzIGl0IG5v
dCBhIHByb2JsZW0gdGhlcmUsDQo+ID4gPiBhbmQgaWYNCj4gPiA+IGl0IGlzLCB0aGlzIHdpbGwg
bm90IGhlbHAgdGhhdC4NCj4gDQo+IE5vdCByZWFsbHkuIFRoZXJlIGlzIG5vIGRpZmZlcmVuY2Ug
YmV0d2VlbiBhbiBleHBsaWNpdCBwcmVlbXB0aW9uDQo+IHBvaW50DQo+IChjb25kX3Jlc2NoZWQp
IG9yIGFuIGludm9sdW50YXJ5IHByZWVtcHRpb24gcG9pbnQgKFBSRUVNUFQ9eSkuDQo+IA0KPiBT
byB1bmxlc3MgeW91IGNhbiAqZXhhY3RseSogc2F5IHdoeSBpdCBpc24ndCBhIHByb2JsZW0gb24g
UFJFRU1QVD15LA0KPiBub25lIG9mIHRoaXMgbWFrZXMgYW55IHNlbnNlLg0KDQpJIHN1c3BlY3Qg
aXQgaXMgYSBwcm9ibGVtIG9uIFBSRUVNUFQ9eSB0b28sIGJ1dCBpcyB0aGVyZSBzb21lIHNvcnQN
Cm9mIGZhaXJseSBsaWdodCB3ZWlnaHQgKGluIHRlcm1zIG9mIHN0dWZmIHdlIG5lZWQgdG8gYWRk
IHRvIHRoZSBrZXJuZWwpDQpzb2x1dGlvbiB0aGF0IGNvdWxkIHNvbHZlIGJvdGg/DQoNCkRvIHdl
IGhhdmUgc29tZSByZWFsIHRpbWUgcGVyLUNQVSBrZXJuZWwgdGhyZWFkcyB3ZSBjb3VsZCBqdXN0
DQppc3N1ZSBhIE5PT1AgY2FsbCB0bywgd2hpY2ggd291bGQgcHJlZW1wdCBsb25nLXJ1bm5pbmcg
a2VybmVsDQp0aHJlYWRzIChsaWtlIGEga3dvcmtlciB3aXRoIG9vZGxlcyBvZiB3b3JrIHRvIGRv
KT8NCg0KQ291bGQgdGhlIHN0b3BwZXIgd29ya3F1ZXVlIGJlIGEgc3VpdGFibGUgdG9vbCBmb3Ig
dGhpcyBqb2I/DQo=
