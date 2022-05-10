Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEBA5224FC
	for <lists+live-patching@lfdr.de>; Tue, 10 May 2022 21:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiEJTqA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 15:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbiEJTp4 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 15:45:56 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7393D3C70B;
        Tue, 10 May 2022 12:45:54 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.5/8.17.1.5) with ESMTP id 24AHD8lp030190;
        Tue, 10 May 2022 12:45:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=I+Hk63fsaqTFrY6nh1YQuQ8s7DYXEJG/NGnPKuqYWhA=;
 b=bGUpDw3ihZxHBNvVtzmJb5gMgx6P4PffeCNxdH61vgaQKQs/ubcklS17wLRuNidipiFA
 lc6IR0y3PNQqmkTNe3M8nJUFERAgC7ospMYxADoOQ2Tn7CPJMfrLHZbwvv7X63DLEvad
 TMBdPW3Ml1oIen5vUzCG1/2rmWgZ3fwiFBg= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by m0001303.ppops.net (PPS) with ESMTPS id 3fyv8nsafk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 12:45:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ly9Fpn64hl7G0xPEm13hhkTsfOkWUyEeTeYYB9o4HaEn1p+yQtO/isOnK0onczqB/naon+C0ED5BYJmG2xp5Bfkt8+tjxrucaBDUbJElejxT9NcYXEK8R/a/01NhEKJj9Ca6O9uqtIlge+7/1FPJiv6Gico9TlFRxFecyRW+KQjGBaaTnd0hl7g+nP7qVF2SEGlXjQXS3U51kIBK8jhp/rG6kD/90JJFsYpPo+QgotIj+1O7KWQLyLdfZwZ6H5dzp/jKk2l0RMFQz33UYeeTSZo8bQRQXikH7voG2K7FU26QDPoWKj+AX2OLueYxAjKRGFjFTyUgMnARlTIry1rKvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I+Hk63fsaqTFrY6nh1YQuQ8s7DYXEJG/NGnPKuqYWhA=;
 b=F7WgCyeX0/HN593ldJf5JfsB20fIZlDivoujq7rNiUc4K3uNKf5EqIYiHLgzUaODj7HLnjsnMW1oy9Cyxo1oL5Iwhb3SA5VZc0bz3fvjixlbm9IgDSX8FHWMHoKKmd51fWsjtxavH6PG9Rs57KYIKt5Y+8VkMqt9gvxoBD+c+bwmBs63Rc6zUxZGzSxCWNLWKpU0TL9XrOUIWBjryOrOoN7vurpeEjjjRUiBwGAoSc+rFLByRUCZ+9DsOckXoVB8SfocNs4+nS/WnGfMYWPhwrvrCmlahqPmKxktE+DC5FuBFi4wvhPrLpkfFtz+T9rmoQo+prhimpTg9ysvMpIrDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by CO1PR15MB4955.namprd15.prod.outlook.com (2603:10b6:303:e6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 19:45:49 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 19:45:49 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
CC:     Rik van Riel <riel@fb.com>, "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Thread-Topic: [RFC] sched,livepatch: call klp_try_switch_task in
 __cond_resched
Thread-Index: AQHYYjpsu2JIKZQIXUOp7t0Qujiczq0WqGoAgAAU/gCAAQUkgIAAXf2AgAAkx4CAAAZjAIAADJUAgAAUwACAAAnWgIAAEcOA
Date:   Tue, 10 May 2022 19:45:49 +0000
Message-ID: <47440502-930F-4CBD-B859-3AC9BBFF8FC6@fb.com>
References: <20220507174628.2086373-1-song@kernel.org>
 <YnkuFrm1YR46OFx/@alley> <9C7DF147-5112-42E7-9F7C-7159EFDFB766@fb.com>
 <YnoawYtoCSvrK7lb@alley>
 <3a9bfb4a52b715bd8739d8834409c9549ec7f22f.camel@fb.com>
 <YnqIcw+dYsWz/w7g@alley>
 <6bf85ff908377508a5f5bcc7c4e75d598b96f388.camel@fb.com>
 <20220510165244.ikfh64ertnvodxb4@treble>
 <1bd15361edfd4db9fc9271d35e7bbe5edad1b87a.camel@fb.com>
 <20220510184213.l3gjweeleyg7obca@treble>
In-Reply-To: <20220510184213.l3gjweeleyg7obca@treble>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9cbaf3f0-c1a5-4b8f-c6c7-08da32bdaf12
x-ms-traffictypediagnostic: CO1PR15MB4955:EE_
x-microsoft-antispam-prvs: <CO1PR15MB49550429CF2D25DF325D2B8CB3C99@CO1PR15MB4955.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RhwUr1QszSf0aGIyyBDsfPqG+M/UZ7ti7NMK4JxGG+yA6TNa/Zr1MshkfdUthityDmPsGY8rkAM6Ue6JFgITe5/BnYMIo/lPROEnOpZD/vbwVsvh3zaFQ37Qn0ZgWfjxDtb0TxMhxk6/HH4isf/y7JkqZvNOa5UA6oKOpD4rhNKH83+BFiOYNHQhw6h6cQtGtS9ijd0h2rCUWB73vTFdJ2MPkLyE+MSjJPKFIacvU6c8hdEqC6Zmx5gF80rXsakaAXhHyrcFI2siu8d2jjIfPlfC9/kFNYVQbZVn/hVxfhWCrPRi/DyQpJrhBt5uxt4542oO2uuy6Wfov6gNCMcKyCgitfQMlUZG+NVdOVa5ryOrwVAgFIe+nA8PP3L0ks/HIdCodh7GLbrS7eDDdUuTtsKC/Q9It7gqE+BA+Dw1hGZ8o9hRDOsKiOy3/eSJPEoDkmhAtWP/+0o5nbM41kXFWphUE/10AAwp8Cq2Vvqn21eWcaaUiUNq2lmkK0dYKolfMR1VtuE/y9kslb/6tkJt2ybo3MVia7Hd1p1rvdxM4hTLtKj2JpqwDtw6jDEGnffiNnqz3zg+ZpBwz9wyhrqgrF0YXUVMsiYYxmcd/IqKGYZAAS71lJxcphwJpxJZ9sFwY7kPjqKoF07xlsjD1cvm4FnyLQiIB/mFFwRuLcqyJ8YEscKTKP10o9p+vvS76/r/chTvrlaIC+7yOZPE9qUWGL06NuoSghQjKTGNaOvMIXztQPmhuchiU3w+ha/HLgK5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(66556008)(6512007)(71200400001)(66476007)(38070700005)(53546011)(38100700002)(76116006)(91956017)(4326008)(8676002)(64756008)(66946007)(66446008)(6506007)(33656002)(7416002)(5660300002)(6486002)(508600001)(2906002)(8936002)(54906003)(2616005)(6916009)(122000001)(36756003)(316002)(83380400001)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Yjh4TmcrdXpTbE5BNndwbitVbFZBT3VEZWl0OXNXRExhejNqbnZYajR4dEFK?=
 =?utf-8?B?ZHFtTVFFeXAxS05CdXpQSmFGTkR3SEZUN0R0dHJEM1NHZWppME0xSVhRc2xI?=
 =?utf-8?B?TTlHMkpCZGJrTTFKbjJuOVJYOGcyQkpyb1puVGpMUEd4VEwxZzB1cUFPUXpB?=
 =?utf-8?B?ZWVERkJtUTJQRVV0aWx0RkhkbG56WFZjaDdreUtZWDdhMU9pSkVYZ1lmdUhP?=
 =?utf-8?B?OGxQbFpwcUFwaUcxMk1mRmFhTVl6azFLZzlTOEZsL1htZjNGWUt1Z2lmdFFy?=
 =?utf-8?B?a1hPcFRyd0ZVQkRoV1AxTk1Pd2ZFSDVNWDZJU1RsUlRJVU9QeXloa0hJQnl4?=
 =?utf-8?B?ZDV3Y0FTYXFxK1Q0RFk1MmRBVGthZlByS0JJK2duSUdIT0dRSVhzV0tveS9w?=
 =?utf-8?B?TENOUXBuTWZBaHdCcnErMXcrRnZpT2grZmZxRTZGaytTYWFCYjZIbVpJTGMv?=
 =?utf-8?B?QWtuOGNiUDB2ajJQWmNWZFZOSHZTZW1tdGx4eDFwZ2g4dkVrZEIrR3J1M3R0?=
 =?utf-8?B?eUNJNVJzcWRaa3VMTGREUDY2clR3MzhFUVNma3hCSzUwanRNb0k4RmQxU2xn?=
 =?utf-8?B?TWxiNlorN1BmODFJQWwyYjhSZ1g2cHJMQ2JzYTNhcjJlTWlhT1FlVXFHTlF5?=
 =?utf-8?B?cDdKRjNkMW1waDh0S3ZIN3BSbCtYM3E2L0RwS1lIcnFMK1VBUUhvanIzby9i?=
 =?utf-8?B?Wmw1Z1ZidjZodVE4N0Npekw3c1BjcThCdFpqV2VEQzkwNEFvbjgyQ2l4ZStR?=
 =?utf-8?B?OUZlMDdnSEQ1eWN0bjRTTGoybVd6TTNNaWVhQ2c4S0RvZW9teUkvQWxvRWtn?=
 =?utf-8?B?V29jckhHd1NjY3R0UUxJQ2FlL0M0S1g1UkF6MEpKajlneVF5OFhzT3MzWGxS?=
 =?utf-8?B?dW1BZit4b091R3oyTHBjZ1FpdU5NemgwRUZRZGtjcWxLbDRlbVcwY3Qxbk1m?=
 =?utf-8?B?VVdGUE9mZ3p2Y09hODdoMFRxaXdFZWNnZkdJdnFrY1pQR0Vyb29CRm5lRkZl?=
 =?utf-8?B?ZHkzYk1iU1JzV2kreXR6eTFVckdTN29UK3lwRGs0UmRjSGZjZ3FUZXJza0U2?=
 =?utf-8?B?MmZnT3h3UkNPZVF5ejNvU1NYeVh6R2plYW0vanhCUlJ3bHJNbmlUUlVvSC9K?=
 =?utf-8?B?b2dDWElvSXRmcmUrZHFHNURVYnVLc3dZRmJkMFY0bkpUcW9DVmZ2ckFFTGNI?=
 =?utf-8?B?Zk1YUklON0Fzc2NzMzVtd1B0QWlZUDhqRG1Qcm1mREF1N1VOTEJoQThCc3hz?=
 =?utf-8?B?dEdtZmJYcmE5MVU2MStmVkE1RkxpQk8waEZnT3BhWm11ZmFZeG5iUlRnaTJM?=
 =?utf-8?B?S3R5L1JxL1QxL0g2bVE1Slg2QzBLY2w5RlRiRzh5QWVSdGFtRDNqTkZhNXl2?=
 =?utf-8?B?R1JsckhZcFFad05QcGhrbnRrNFlwTkU4UVk3dnlJNncwZ0gyL2pRMWoraGcw?=
 =?utf-8?B?eGlJVEFmYlBUYjJMTDRObEhwL09wODFBdHBWY0xZSXA0SGtsSk9aSXdxSk0v?=
 =?utf-8?B?dWNOMkR6dlNWa2hsMlBlNHM0aE5PMkNoZWk0aHlhVktqSDkrMHFTdTNtYWgv?=
 =?utf-8?B?UVFqQXBoc3g3RjUvZHN6dnpKZDhnaG5HMkx3TW1VcUZjNUdROGRXc1VJaVJW?=
 =?utf-8?B?a0FBT092OGxldVBCR2hRS0NXZXY2ZU5GSml3WUlBYzFralVwWHZBbzlXelhX?=
 =?utf-8?B?QVdyZmhJNThaZ3ZLQ2RJQzdMKzM2ZjZxMFlURENQRlZrWm03a1NBM3ZUd1I5?=
 =?utf-8?B?MENCSWp5S1VLQ3V0aFZRL0VuMWh1UjE1aWs1dVNsem5Na3lMTzExK09KSE1l?=
 =?utf-8?B?OWxmOE9MdnZpWGxQNUpabHMyelBLU0FVT00wM2k1ckNKV00xU1NUVmR3NVZq?=
 =?utf-8?B?MHpZYlZ1TjRjK01zU2kwdFhKRGpZZ3BLaTRDeHBnbkp3WFhna3VzMFE0bnUz?=
 =?utf-8?B?L1ZnSW4yclRWdi9PZ1RQSjNzNU9NQW80SXkwUFhQajMyUzJhN2tMZU16MjY1?=
 =?utf-8?B?R3V6N09mdnd1MHc4VGpkUFIyTWcwdG4yWk1peDJKMFloVXR5UndpMmEzVm1s?=
 =?utf-8?B?VTVKOE1CVVlSZzlBZzYyRFJXQXJEUXh5NjNCNXAxcitNcnB6OGNockZ3a2px?=
 =?utf-8?B?ZEVXVW45ZzlYekRyMjNFc3d5enpBVnRDa0dQQWtqZkZYQ014SElLOUNKZnpX?=
 =?utf-8?B?MmpNd2dLRENqOCtrcGtnaTl5N3lWNGNEeEs2aDNIa0p5SlgrSlFZbXJvbjZR?=
 =?utf-8?B?Zyt0dlN1SnBwVUtQcWtkL1QrZVpvMkIxemVNVk9MSE5oOEt6UWdXSWxaaEhp?=
 =?utf-8?B?UXc0VVdkWStFVjdwd1gvTTMxQkpRaHcwUWNoaXZpUkdKUUduVkFETllVbFov?=
 =?utf-8?Q?emgmo1ay3PhNKVOZQJU/Otn3zntDtO/PxwWE+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB2766D590CEB24EBE5505A6F23C4C81@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cbaf3f0-c1a5-4b8f-c6c7-08da32bdaf12
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 19:45:49.3641
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BA72QxT7BWJP5HhKQjlOvSzXAepJh4B1XAVZXQ2Dc9LpHxLfuLLMQ3bGBObC5nw2HAUsrInCpLqbbvmbkrC9Tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR15MB4955
X-Proofpoint-GUID: WKJus-F50TM_k78qa51CIj3z4qEjwoJY
X-Proofpoint-ORIG-GUID: WKJus-F50TM_k78qa51CIj3z4qEjwoJY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_06,2022-05-10_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCj4gT24gTWF5IDEwLCAyMDIyLCBhdCAxMTo0MiBBTSwgSm9zaCBQb2ltYm9ldWYgPGpwb2lt
Ym9lQGtlcm5lbC5vcmc+IHdyb3RlOg0KPiANCj4gT24gVHVlLCBNYXkgMTAsIDIwMjIgYXQgMDY6
MDc6MDBQTSArMDAwMCwgUmlrIHZhbiBSaWVsIHdyb3RlOg0KPj4gT24gVHVlLCAyMDIyLTA1LTEw
IGF0IDA5OjUyIC0wNzAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToNCj4+PiBPbiBUdWUsIE1heSAx
MCwgMjAyMiBhdCAwNDowNzo0MlBNICswMDAwLCBSaWsgdmFuIFJpZWwgd3JvdGU6DQo+Pj4+PiAN
Cj4+Pj4gTm93IEkgd29uZGVyIGlmIHdlIGNvdWxkIGp1c3QgaG9vayB1cCBhIHByZWVtcHQgbm90
aWZpZXINCj4+Pj4gZm9yIGtlcm5lbCBsaXZlIHBhdGNoZXMuIEFsbCB0aGUgZGlzdHJvIGtlcm5l
bHMgYWxyZWFkeQ0KPj4+PiBuZWVkIHRoZSBwcmVlbXB0IG5vdGlmaWVyIGZvciBLVk0sIGFueXdh
eS4uLg0KPj4+PiANCj4+PiANCj4+PiBJIHdvdWxkbid0IGJlIG9wcG9zZWQgdG8gdGhhdCwgYnV0
IGhvdyBkb2VzIGl0IHNvbHZlIHRoaXMgcHJvYmxlbT8gDQo+Pj4gSWYNCj4+PiBhcyBQZXRlciBz
YWlkIGNvbmRfcmVzY2hlZCgpIGNhbiBiZSBhIE5PUCwgdGhlbiBwcmVlbXB0aW9uIHdvdWxkIGhh
dmUNCj4+PiB0bw0KPj4+IGJlIGZyb20gYW4gaW50ZXJydXB0LCBpbiB3aGljaCBjYXNlIGZyYW1l
IHBvaW50ZXJzIGFyZW4ndCByZWxpYWJsZS4NCj4+PiANCj4+IFRoZSBzeXN0ZW1zIHdoZXJlIHdl
IGFyZSBzZWVpbmcgcHJvYmxlbXMgZG8gbm90LCBhcyBmYXINCj4+IGFzIEkga25vdywgdGhyb3cg
c29mdGxvY2t1cCBlcnJvcnMsIHNvIHRoZSBrd29ya2VyDQo+PiB0aHJlYWRzIHRoYXQgZmFpbCB0
byB0cmFuc2l0aW9uIHRvIHRoZSBuZXcgS0xQIHZlcnNpb24NCj4+IGFyZSBzbGVlcGluZyBhbmQg
Z2V0dGluZyBzY2hlZHVsZWQgb3V0IGF0IHRpbWVzLg0KPiANCj4gQXJlIHRoZXkgc2xlZXBpbmcg
ZHVlIHRvIGFuIGV4cGxpY2l0IGNhbGwgdG8gY29uZF9yZXNjaGVkKCk/DQoNCkluIHRoaXMgY2Fz
ZSwgeWVzLiBUaGUgdGhyZWFkIGNhbGxzIGNvbmRfcmVzY2hlZCgpLiANCg0KPiANCj4+IEEgS0xQ
IHRyYW5zaXRpb24gcHJlZW1wdCBub3RpZmllciB3b3VsZCBoZWxwIHRob3NlDQo+PiBrZXJuZWwg
dGhyZWFkcyB0cmFuc2l0aW9uIHRvIHRoZSBuZXcgS0xQIHZlcnNpb24gYXQNCj4+IGFueSB0aW1l
IHRoZXkgcmVzY2hlZHVsZS4NCj4gDQo+IC4uLiB1bmxlc3MgY29uZF9yZXNjaGVkKCkgaXMgYSBu
by1vcCBkdWUgdG8gQ09ORklHX1BSRUVNUFQ/DQoNCkJhc2VkIG9uIG15IHVuZGVyc3RhbmRpbmcg
KGFuZCBhIGZldyBvdGhlciBmb2xrcyB3ZSBjaGF0dGVkIHdpdGgpLA0KYSBrZXJuZWwgdGhyZWFk
IGNhbiBsZWdhbGx5IHJ1biBmb3IgZXh0ZW5kZWQgdGltZSwgYXMgbG9uZyBhcyBpdCANCmNhbGxz
IGNvbmRfcmVzY2hlZCgpIGF0IGEgcmVhc29uYWJsZSBmcmVxdWVuY3kuIFRoZXJlZm9yZSwgSSAN
CnRoaW5rIHdlIHNob3VsZCBiZSBhYmxlIHRvIHBhdGNoIHN1Y2ggdGhyZWFkIGVhc2lseSwgdW5s
ZXNzIGl0IA0KY2FsbHMgY29uZF9yZXNjaGVkKCkgd2l0aCBiZWluZy1wYXRjaGVkIGZ1bmN0aW9u
IGluIHRoZSBzdGFjaywgDQpvZiBjb3Vyc2UuDQoNCk9UT0gsIFBldHIncyBtaW5kc2V0IG9mIGFs
bG93aW5nIG1hbnkgbWludXRlcyBmb3IgdGhlIHBhdGNoIA0KdHJhbnNpdGlvbiBpcyBuZXcgdG8g
bWUuIEkgbmVlZCB0byB0aGluayBtb3JlIGFib3V0IGl0LiANCkpvc2gsIHdoYXTigJlzIHlvdSBv
cGluaW9uIG9uIHRoaXM/IElJVUMsIGtwYXRjaCBpcyBkZXNpZ25lZCB0byANCm9ubHkgd2FpdCB1
cCB0byA2MCBzZWNvbmRzIChubyBvcHRpb24gdG8gb3ZlcndyaXRlIHRoZSB0aW1lKS4gDQoNCj4g
DQo+PiBIb3cgbXVjaCBpdCB3aWxsIGhlbHAgaXMgaGFyZCB0byBwcmVkaWN0LCBidXQgSSBzaG91
bGQNCj4+IGJlIGFibGUgdG8gZ2V0IHJlc3VsdHMgZnJvbSBhIGZhaXJseSBsYXJnZSBzYW1wbGUg
c2l6ZQ0KPj4gb2Ygc3lzdGVtcyB3aXRoaW4gYSBmZXcgd2Vla3MgOikNCj4gDQo+IEFzIFBldGVy
IHNhaWQsIGtlZXAgaW4gbWluZCB0aGF0IHdlIHdpbGwgbmVlZCB0byBmaXggb3RoZXIgY2FzZXMg
YmV5b25kDQo+IEZhY2Vib29rLCBpLmUuLCBDT05GSUdfUFJFRU1QVCBjb21iaW5lZCB3aXRoIG5v
bi14ODYgYXJjaGVzIHdoaWNoIGRvbid0DQo+IGhhdmUgT1JDIHNvIHRoZXkgY2FuJ3QgcmVsaWFi
bHkgdW53aW5kIGZyb20gYW4gSVJRLg0KDQpJIHRoaW5rIGxpdmVwYXRjaCB0cmFuc2l0aW9uIG1h
eSBmYWlsIGluIGRpZmZlcmVudCBjYXNlcywgYW5kIHdlDQpkb24ndCBuZWVkIHRvIGFkZHJlc3Mg
YWxsIG9mIHRoZW0gaW4gb25lIHNob290LiBGaXhpbmcgc29tZSBjYXNlcw0KaXMgYW4gaW1wcm92
ZW1lbnQgYXMgbG9uZyBhcyB3ZSBkb24ndCBzbG93IGRvd24gb3RoZXIgY2FzZXMuIEkgDQp1bmRl
cnN0YW5kIHRoYXQgYWRkaW5nIHRpbnkgb3ZlcmhlYWQgdG8gX19jb25kX3Jlc2NoZWQoKSBtYXkg
ZW5kIA0KdXAgYXMgYSB2aXNpYmxlIHJlZ3Jlc3Npb24uIEJ1dCBtYXliZSBhZGRpbmcgaXQgdG8g
DQpwcmVlbXB0X3NjaGVkdWxlX2NvbW1vbigpIGlzIGxpZ2h0IGVub3VnaD8NCg0KRGlkIEkgbWlz
cy9taXN1bmRlcnN0YW5kIHNvbWV0aGluZz8NCg0KVGhhbmtzLA0KU29uZw==
