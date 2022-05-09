Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4DBC51F6D6
	for <lists+live-patching@lfdr.de>; Mon,  9 May 2022 10:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233525AbiEIIM4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 May 2022 04:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235008AbiEIIL0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 May 2022 04:11:26 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F861D8668;
        Mon,  9 May 2022 01:07:32 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24907eNB013624;
        Mon, 9 May 2022 01:06:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=hMPdG2eBEflYRLRU/B37nwtoui6DIf/xPrQQnMOnw14=;
 b=T8ATkup/TkArBiV1m7IjYOMZMmmCNbn+9Gu89dNayFmZBUsAdq60gepu/+TDd7hZqrtS
 /C+bZzSotXxo4rkY3cK3AdJ7PlQLa7BHKPcdpPlMX91j5ld/6QVkjM/h/jYkRH9mqhs5
 u7I58UtRFfbrXP+zs3BZTqmO7hVv94kt9HA= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fwnvry1xn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 01:06:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iX4fv33a6hLCUco9kC77VHqw9i9TX8ReaggmqvB5gvaPVSEepJ9em0OCMMUMr4U3FBPCrhyfHUy0LaWzbj1OOdRHZVrH03lTUp+1lwkFU8Urxcw7Q5EAwn7qePgtHjQunQpltGQRyiUxB9xGHdOqUS5d3xXbjvUrLoS987ZLIQfisbZsRtUCCyiNc8kG2F6mfCBt59SqUzVuzP23Tu5xTwh95wikU2Xzn7iIu2SE5RUuv/vz+DoKEMyAucudot0HqmW3qWYQcWVcsFPvwp8//V/tqupcLC0TTAunCB58SxAS/qFazaroTe9M7/0DHWpKWMD9maZcrlV7p55OCdALUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hMPdG2eBEflYRLRU/B37nwtoui6DIf/xPrQQnMOnw14=;
 b=k02dIUCF03ugeRAWAS8qFOz3EHqqhPmpfJzFt0K5EMQsF2EFQYuohV311COlDZZ92nwMXievh29Ld6WpVlusMkNA0PCfXP0d70+OAJAuA/c1O67qCCKu8ek5m27zsBVxrVoHhNR1qISFSGSnl2r8jmlN5F4AsmJXoTFw8VERHYnX48Xx3g/TGHgLaviqKdXyEspoRdcNdeYyYqwX8Vy22dnIhNiuZfAUU3abPlobcVxOnHLsB8kQaZJhMcmpOMqXajNX4V9z4ej3jV72hiVSHrHRjr9Mhz7SRez0U1D+2m6KNOdWww/GNqNlSPyzX034Yq9KhC2jeF/eQbNZjdkiVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by MN2PR15MB3165.namprd15.prod.outlook.com (2603:10b6:208:3b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 08:06:22 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%4]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 08:06:22 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Peter Zijlstra <peterz@infradead.org>
CC:     Song Liu <song@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Thread-Topic: [RFC] sched,livepatch: call klp_try_switch_task in
 __cond_resched
Thread-Index: AQHYYjpsu2JIKZQIXUOp7t0Qujiczq0WIaGAgAARPYA=
Date:   Mon, 9 May 2022 08:06:22 +0000
Message-ID: <9FA1822F-76EE-4174-86DD-B20F1F8CE7FC@fb.com>
References: <20220507174628.2086373-1-song@kernel.org>
 <20220509070437.GC76023@worktop.programming.kicks-ass.net>
In-Reply-To: <20220509070437.GC76023@worktop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e807a69d-f2d7-4080-4d29-08da3192ce35
x-ms-traffictypediagnostic: MN2PR15MB3165:EE_
x-microsoft-antispam-prvs: <MN2PR15MB3165E01178A0CA99DB9C334EB3C69@MN2PR15MB3165.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yPbcAZQELn4ZLdMeKrbbDLJtoIUSZWHuquk9zF0zhZ6W97KY+0gSt4PRXtv5wgJf/UXAwRgCCv38v+BhjHAvucmiuorQv762kf+1aJnwIlCxcsyrxc9Qs/dfEjZO14Av2h2LUgkO9IT+s2sgQz8FmnY6NC30wN1uLkvo+h/ZLQb33sxLe6TGYoth6JEzaCMqUlWk+xc14tBNn2mlKWO84En7ZsvXV54iDrlIV12h+jvsOMap2TD26Qfc8QBU4eP/HGkDzj8RNDu+0UPmbDONPeyxPVcsuQ80UvDhpp4VuOrci4qmpgmD3at7zSB4ldlP23uq1TodK6ARfxfRiAfNwBPUYJuiXfS0LoFYxQ3rpmF30Cm370i/1mBU4sFEmRZsIwGy17PznQwhktm8LiGRVcRqBipNRWj1vN2eMIrZGL3Rl/0xxdzGk2b+yUZARgWKYx/xWij1p0cKgyEFKQst+lqWYdx68pT9rwyvi1wq/LMj72CO9HQy3RPZ4pKV980hRyfGsVbGdBDWmDQG5U32Wk3mX7W7/lmUJtEU+ncm4kL6mjZYvCgAjKIVnRUvY88I0DuRypw8i3gRBHamq84BUVwhvWwDTcLibU69bDWqHdlnRZnn0pFe4sPdUIn2WZArQ/5yJ3opbwjyTCJF+SoLIW1ayKV404Tu+YvsmzAH5tHJpRAhLqO8ibcuwNkX9kw24xPvAO23b0+7G+XVl+NyoiAioTFuhmKinO4AgBiiP35swAtPk9L1GMqtXe6iXNIe
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(33656002)(2616005)(38100700002)(86362001)(122000001)(38070700005)(91956017)(36756003)(53546011)(5660300002)(8936002)(6506007)(83380400001)(66556008)(6486002)(66476007)(508600001)(6512007)(4744005)(64756008)(76116006)(66946007)(66446008)(316002)(8676002)(54906003)(4326008)(6916009)(71200400001)(2906002)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MGpvWVgzRmJWY2p4eXgxcjRPdHZTd3VCQklwS25OR25nSkpjZTFHdmc2Q0U1?=
 =?utf-8?B?UkVQVUlIT3V6L09VRjVsUHkvZnJURSsxR3Z3V0VCWWxjR2U2YUZJM0dZY05o?=
 =?utf-8?B?WGxueWN0V0EzTFFOdjJLUndES1lrektrZ3FJZ3YwelU1QXhpbFR1cTRJUC9i?=
 =?utf-8?B?Tjd5aEx4dGsvbFhKeGxuTVNDSVF6bE9rZWZnSDVBOXVsMEJZVzU3bE52dlV2?=
 =?utf-8?B?M0ptbU0wc2ZabUI4VG1GcGNmYWxBYTI2U2J4Wmw2aVUveFBUOFdQeFlrOVNu?=
 =?utf-8?B?R0xtUjFxSFZwRWYvaTM2S0xXSTNqa25acW5oSDYwZ3BDZys4NFpMT1JDQVJP?=
 =?utf-8?B?UGd4L3Q1Ymw2R09kNzNvNzlQdFYzbWh1ZDFqayt5eGo0bzVQdlNJVytJaHNy?=
 =?utf-8?B?b29lalozTnMwelBaZmxDZzg3aGxpYUc0aEw2SnNaRGRoUjVLRHRNMHROMjhs?=
 =?utf-8?B?ZjNXc3E3cFJtMEhmc3hGZDRGT0N1djFTNGFpQ2pzOUNiM2lxZHJtM1pSbHhT?=
 =?utf-8?B?NEpNZ3pYUXAyc3JEaHFkWDlVMnozbVBQWmlsckh2cS9tQ25JeTk4TkNVWWVw?=
 =?utf-8?B?QXlpUXUwUDNwbU5ZUU1PR1IyYTRHbVNBL3gybFVMeU5ENUNtRk1Ia3RBWEVr?=
 =?utf-8?B?bitWSGdPYmxNSThZYUZreDlqclU0MkpyMERSeEVBQi9NeFBUMXppYk04QVox?=
 =?utf-8?B?Rlh6ZGtxZktkcXJtTXkra3NVajlhSHNBQ2VyKzV0cXRxMkUxRFlFazJCQXk5?=
 =?utf-8?B?ZXhnZHQ2WHVnQ1NvWmNqVE1BdHp0WFhYR1FXLzd3Vi9TQnh5SFZ0cFNPV0dl?=
 =?utf-8?B?eWJyRkFZK1dqb2JoTW5DRG4vdWJDdzlSbFhnaGNLcnF4bDA5UzVyQjcxbGV3?=
 =?utf-8?B?OU1wZTREdXdRclhOdHdXQkh5RTUrZkxvam1BcXVyeUhJNWVtNEhNamlEbGRy?=
 =?utf-8?B?OW5YbTJza25uYkVXK0V4cm51ODVFa3N0OXFUU3VtbnJLL25nRXFxcDVHSnJj?=
 =?utf-8?B?bHZaVGJOdGFBNXh3bXJ3S0J4T3Y1YWNJcVFUL1NiQUZ1V1JtLzRVM0xjZUF5?=
 =?utf-8?B?NWdIamsrREI3UVRMQjdvVXpGSDlTL0ZsMDZEaTA3aUpGbE5obTF5M1hBT09Z?=
 =?utf-8?B?UDFuUlNwV0R6N3lCVkFuN0kxWGhBQ3RNRmZRQ2JTVWdQeHJBbVFZL3lmalpK?=
 =?utf-8?B?VW42YmtIYmxMaHptVytrdGxHTEFkYnNFa3lnRUU3WUZDL2gwUjRaZ3RSK2I0?=
 =?utf-8?B?UHA4VzJOZ3g0VzBUOU5xUTNsYzMrV3IxRmc3c1NQcERNS1daQlFaNHdrcWZF?=
 =?utf-8?B?YWk3VytDenFFa044eVI0MUJSRWtLWXdoYlVmbWloazZQbEszVmtXTXRwV2Zt?=
 =?utf-8?B?QVhqVW1iMElpVUhuemU1djVZWHRPQ2F0L094dXhlKysxUERkYUlkSzdNMU9Y?=
 =?utf-8?B?NGNHU1RtQ3pWdTJuUEZISkpFRVRrY1ZERXRUZ1FCQitpL3h4cjhkRjJWZ1Br?=
 =?utf-8?B?TWRuc0pNbitNNVB3bXliTkg1ek0xd3RWWDVpTWFIWmtIakR1VWIySnRTaWtI?=
 =?utf-8?B?RlRXdVYrT09Pa1pCaVVGeWhDZG84MitxS0ZxSTZURGpHWDlQTHJUS0UxS2lG?=
 =?utf-8?B?dEJyMjRIRjVscDhQTTVseHZnczVqdXhMellpSWdHbkxXSEhqSDdzMEhRY2hR?=
 =?utf-8?B?bDhPeE5tYm1kMWxya2dXQXFJeitHUmJnVC9yZWNMYm04RGdJYVdHQjJMQjFZ?=
 =?utf-8?B?cThjelZ0S3VsZHRKa1h3UzVRbmNLMHQ1S2FSQnNwSEdOQk9hbnYyTmhFRy9z?=
 =?utf-8?B?QnF2akZpVGVxN2R6V3AwcDNZNXVCaUpwN2ZUWTNKaUF2dVdtR2NMU3JJWndk?=
 =?utf-8?B?WEg3Y3RUbkx0S2pjOWxpMU1sUGkrSUNiOE5DVkw3OGJQNWV5MHpFa2tjZUVH?=
 =?utf-8?B?R1NrQms4WGFpT1h6SVdzUVM0cW95NEtlaFRSMWFqSSs4b0Vubk5aOTRINTZY?=
 =?utf-8?B?QlozeEZweUY4ZnJyeWVOOFBBcnYzdEFvWlQ4MVl2UVRLVDFlak9Wenp5bkZX?=
 =?utf-8?B?aUtzTFB1TjBMRU9jSm9jNEg2U1I1YTBTdlMwbG9udUwrVzZEMGVwNWU5MzVF?=
 =?utf-8?B?aHZud3dRK3poSUlWc0tIMlQySWZCNXJOc2lYWlZtRS96VklNQ3pKUFBvZ2RT?=
 =?utf-8?B?ZEFzaXRpNlRpREljWWxzaVd0T2NOMXF2WVdKQXlpallTSGtvcitaanBaLzRK?=
 =?utf-8?B?QTF6UmIrdjBwZk8zbzl0cDhqOS9Pck5VVmRTWTIvdnpTZnEyVDRvdnFpS1g0?=
 =?utf-8?B?dkl3VDNQNndPMnNiNkFtSWNRclYyREN4MDhEeGRIY21nYys2c1dRQ3pETXR1?=
 =?utf-8?Q?KI6fTuTQRnr8StjutjGjpYiInN2H+0HDMajPo?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E4F2C4FA1D13AC458DBD24AF0A6D2C3E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e807a69d-f2d7-4080-4d29-08da3192ce35
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 08:06:22.0307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FiTdyeywDs90Y7A8F5p8mU1/YOqMqpbrxIoW+tv3aNJgcduBqIXYTKdCyUnBXOm2VrEMIV0BGXIrREV9NYeGvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3165
X-Proofpoint-GUID: yMvVbPUN5DtndJ9UrDCHEZrt9ysCSg2m
X-Proofpoint-ORIG-GUID: yMvVbPUN5DtndJ9UrDCHEZrt9ysCSg2m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_02,2022-05-09_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCj4gT24gTWF5IDksIDIwMjIsIGF0IDEyOjA0IEFNLCBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6
QGluZnJhZGVhZC5vcmc+IHdyb3RlOg0KPiANCj4gT24gU2F0LCBNYXkgMDcsIDIwMjIgYXQgMTA6
NDY6MjhBTSAtMDcwMCwgU29uZyBMaXUgd3JvdGU6DQo+PiBCdXN5IGtlcm5lbCB0aHJlYWRzIG1h
eSBibG9jayB0aGUgdHJhbnNpdGlvbiBvZiBsaXZlcGF0Y2guIENhbGwNCj4+IGtscF90cnlfc3dp
dGNoX3Rhc2sgZnJvbSBfX2NvbmRfcmVzY2hlZCB0byBtYWtlIHRoZSB0cmFuc2l0aW9uIGVhc2ll
ci4NCj4gDQo+IFdoYXQgd2lsbCBhIFBSRUVNUFQ9eSBrZXJuZWwgZG8/IEhvdyBpcyBpdCBub3Qg
YSBwcm9ibGVtIHRoZXJlLCBhbmQgaWYNCj4gaXQgaXMsIHRoaXMgd2lsbCBub3QgaGVscCB0aGF0
Lg0KPiANCj4gVGhhdCBpczsgSSBkb24ndCB0aGluayB0aGlzIGNhbiBiZSByaWdodC4NCg0KSSBn
dWVzcyBvbiBQUkVFTVBUPXkga2VybmVsLCB3ZSBjYW4gc2ltcGx5IHByZWVtcHQgdGhlIGxvbmcg
cnVubmluZyANCmtlcm5lbCB0aHJlYWQgYW5kIGNoZWNrIHRoZSB0cmFuc2l0aW9uPyANCg0KSW4g
dGhpcyBjYXNlIChQUkVFTVBUPW4pLCB3ZSBzZWUgYSBsb25nIHJ1bm5pbmcga2VybmVsIHRocmVh
ZCBjb3VsZCBub3QNCmZpbmlzaCB0aGUgdHJhbnNpdGlvbi4gSXQgY2FsbHMgY29uZF9yZXNjaGVk
KCkgYW5kIGdldHMgcmVzY2hlZHVsZWQgDQoobW92ZXMgYW1vbmcgZGlmZmVyZW50IGNvcmVzKS4g
SG93ZXZlciwgaXQgbmV2ZXIgZmluaXNoZXMgdGhlIHRyYW5zaXRpb24sDQpiZWNhdXNlIGxpdmUg
cGF0Y2ggZG9lc27igJl0IGdldCBhIGNoYW5jZSB0byBjaGVjayB0aGUgc3RhY2suIA0KDQpEb2Vz
IHRoaXMgYW5zd2VyIHRoZSBxdWVzdGlvbj8NCg0KVGhhbmtzLA0KU29uZw==
