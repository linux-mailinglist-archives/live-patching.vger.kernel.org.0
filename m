Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FB3522346
	for <lists+live-patching@lfdr.de>; Tue, 10 May 2022 20:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348495AbiEJSLH (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 14:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348494AbiEJSLE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 14:11:04 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA002B266;
        Tue, 10 May 2022 11:07:05 -0700 (PDT)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AFLPmK024978;
        Tue, 10 May 2022 11:07:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=dAf29gQLupdEgOxEIZCzHih3S8r+tm+21LMFCv6xCiU=;
 b=SweVhbSjrIHx6RtWSkajxWM/1PvZKjMP4HXvm1fNu+BrTQS3agew2xGv1qpp1E77QtW1
 YqTeIdlBcH2a5UclrgZJgdwRokv0kiPi10yPdApPtwyWcaW/M3c07DMa87V2jDsZRopz
 Hjb3ettNG8JLANGUwrg7t5WCJID2zPDi8Zc= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fyn47ue0e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 11:07:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cq0FIC7y7WxGU9BKJY87eBepW9jHLyOa2EzZk44dRvNAzQWjzUZ4kFk+Ie7UGLPM2H00Fo0iWI1qsuZjgz6qKT+cvfinvX1xg/rM2tVdNoXzH2F/gHiu5LC5aovGBBchG+Mxpsg7+FAz/AVU+VfKc+8O4+c/G/PnoM/CSTIchTwKVhW7IO5rLSNk3UHAE4d91bvHE/PHmvItnaqqo+nJtZMYPI/8cA8WDdOQy1XoEbO05EzJL6MBvziLvVwLFTf1NhGxMv3Ri55J+Qm4qlBJpwAjp+jaM+cN7a3XtflqHNA2RLfoPWGK4FNEujV5nyLCRKw/r9geHARglnYUKVH+tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dAf29gQLupdEgOxEIZCzHih3S8r+tm+21LMFCv6xCiU=;
 b=j6HDs4XcI4wpohluD0seCyhZFb5FR7H4xpBNvl3qwVzXNiljwjPeGXY/x9C1iCnOi2iF93M6cBIuV/4Kf//0bveBGJMrR2bpN2DtBnBqzpnQEjtT8Xznkc3MrC9sOSt5GQEnvJlf2svIl97NMMIVAyyajNKj+3UU4C143BHevaOJhW7h8PMGOThNemU/Ob7EAp7Y++ESMOiw2yJ8zhi15z3EHq+Qa0sJF/7W1X9D6AO6IfNZo3RDiWCgn8kF3rY2Uhqnjyk8xvgGyuoHUH7bGA/OVHxNhnRtfeEpiKLX2W9Ickel3RF3bhSbCmqWKC6CSSE99r6nVL+jzP8gCbbNMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO1PR15MB4969.namprd15.prod.outlook.com (2603:10b6:303:e4::23)
 by PH0PR15MB4216.namprd15.prod.outlook.com (2603:10b6:510::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.23; Tue, 10 May 2022 18:07:01 +0000
Received: from CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730]) by CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730%6]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 18:07:00 +0000
From:   Rik van Riel <riel@fb.com>
To:     "jpoimboe@kernel.org" <jpoimboe@kernel.org>
CC:     "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Song Liu <songliubraving@fb.com>,
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
Thread-Index: AQHYYjpsdFy2RMM8vk2xmmtLa5gGmK0WqGoAgAAVAICAAQUigIAAXfwAgAAkyICAAAZgAIAADJgAgAAUwAA=
Date:   Tue, 10 May 2022 18:07:00 +0000
Message-ID: <1bd15361edfd4db9fc9271d35e7bbe5edad1b87a.camel@fb.com>
References: <20220507174628.2086373-1-song@kernel.org>
         <YnkuFrm1YR46OFx/@alley> <9C7DF147-5112-42E7-9F7C-7159EFDFB766@fb.com>
         <YnoawYtoCSvrK7lb@alley>
         <3a9bfb4a52b715bd8739d8834409c9549ec7f22f.camel@fb.com>
         <YnqIcw+dYsWz/w7g@alley>
         <6bf85ff908377508a5f5bcc7c4e75d598b96f388.camel@fb.com>
         <20220510165244.ikfh64ertnvodxb4@treble>
In-Reply-To: <20220510165244.ikfh64ertnvodxb4@treble>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b1179bd-67d4-4dd5-1bad-08da32afe170
x-ms-traffictypediagnostic: PH0PR15MB4216:EE_
x-microsoft-antispam-prvs: <PH0PR15MB42165B18A043B0848C5E3859A3C99@PH0PR15MB4216.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aE6J2DT5IcakjmwD4DBEg1SFKDohaVl3/1ZFMqTvL3ki9hOf5oCAv4qZF/WaQceBdCnU4+Z+t/JraQjErumF/H4VCKEd/u6F33TawJ1S8xFqOaFOkh5awmKP3IfjCzeIhBzfA430Yd/fQAzniqEHGi5bskEJNzl9xxLIrJQ9qsZeTv5ZWUX4ombUsqqASlayUwTaO04dq40gNbVzZxpJPlIn0xfblGSVlhiIloqPV+EFjlki7aEuaYCK1LIu49/Vxpo/XgQQTbyoTBfLoX3YkEitv/UPr+txr39sxNLSH60L1khzjjsgmd3z5c7wTjIbZayCyopsjBHReAZNQM59LgroG2zSjKi78le6mzH3s5fUTeOoNVNZ09TNgpHXnlYdgarxBMIWO0SlU5Mni2Oy+ytN3wlYlut7LsmdWKA5pisFuEtxqSs0WNw4XzH6dtHqRyRLcZ4iWJwlEOPxeZr5ucOsto2BzogYPXoBwl7xIrK2XYomG/A1FzT+v3J2keezmRkh68VG7Glaz90x0/ye7zBYdwqiQ0dIkOhAyG32xkuln9P4O6Z0Sq1pQ/5sIsDq2765pShftuuGT3lCC2BDfa+KQSvzpgi8S8GK06TpeXBo1pgez8jyfakr2bDZv2W87SKn6TrYvrJnqilYUjzXCDEfc3VmWVQcrfcd6N2Ho0mTNetuiQe9HH/cF+0Kpzd2pEUpGkVF9TWxrLWo/+DZEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB4969.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(38100700002)(38070700005)(36756003)(54906003)(186003)(6916009)(6512007)(508600001)(8676002)(122000001)(316002)(71200400001)(66946007)(5660300002)(6506007)(66476007)(66446008)(64756008)(66556008)(4326008)(83380400001)(76116006)(91956017)(6486002)(8936002)(2616005)(2906002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?REZtOUIzakZxdDRzNHIyMFJ2VHB2NnVDRDBMb2F5Vkp2S0xacmdWa2lNRFNl?=
 =?utf-8?B?bWExZjIyaVR0NmNpRUlmTE9xNFc2ZlZ4ZHJTNFNJdHliRE1hRVJjWHpad2ln?=
 =?utf-8?B?NkhhNk5wQnF5c0RFUXFZYXdFUWFFSUgrTWFDYUdJQldvRGhyOU8vWXo5NDV6?=
 =?utf-8?B?VWh2R081UnMxKzhOQXUwMFB3OG5JUlBIUnF3dnJmU2V2R3B5UXBDWU1jSWxE?=
 =?utf-8?B?Ri84OGtta09WNzZKRWhRQ1pQcFh1Y3p1eGh0YXlUR3hhWUpxUnFmUk5hYkhI?=
 =?utf-8?B?SGxDRFpTckdZVnFiaDI3dFhmVFVFcUJmNUd1MzY0ODVabml3NzlUUVYzZy9l?=
 =?utf-8?B?enBpcmkwdXhhQlJmRFNBL0N6U2E1VkJuV2x5bXJCNVdXcWRpOWNnQ3BBelZN?=
 =?utf-8?B?b1ZWYWoydWZHU2V5ZEU0MHR2ZmRZdld2ak1ZY3JRaHY5Rmlmc1dGQkZCakV6?=
 =?utf-8?B?MmlpNkExaEI1SlNFNGUvWGxOQmpkdC9CSWlkaVRXdWI1dEt6VFFlSlpVOEhh?=
 =?utf-8?B?TlhndVZLa1dmNUhPWllkZVgwNGtKaWZoVGY1ZnhZK242L0Myc3VRT0xvMVJr?=
 =?utf-8?B?L2hEb1FJTUFncFdBRFpJTStBTUJVemorMG53WVJOZ0tFejNtT0JCcktFR01C?=
 =?utf-8?B?emxKK0hnOEJLbmNMODJVQlhCb3FVV1dDYWpiQXAwdUc5eUIvdkpaNDJ0bUNH?=
 =?utf-8?B?ZTZGclVUb2hUYnU3MmE3bDloVTlrVm5mU3Nidm9QKzNJM2JaZ0Q4UHBnQUJw?=
 =?utf-8?B?L2c4VFo1U3luZ2pnTWZwT2JXY1BYSjRibTU5aFRFQVNYc25OUnIwVlVkRDQ0?=
 =?utf-8?B?TXJhVWhjUEJ0L0R4TGNkaWJZQmJjSHN5NXZPQ3g5SzVTei9UVGtVQnZYVGJq?=
 =?utf-8?B?Z3RLTGRkSERpcGJWV0d2bm9CWEtBbE1wNjBEd3BFL3RUSUNndmNMWFNzTXZ0?=
 =?utf-8?B?QUJ4ZFBnOGxjNFBVbWI4MXBZa0pDQWhUbHdFcEJ3VDRqYnovbVpxODhHYVh6?=
 =?utf-8?B?dHA2K256ZXZoVHBtaU1acW10WXR5bk5mRmwya3YxajB1NkJUUGtaQ3VxL042?=
 =?utf-8?B?Y0FLTGVEdVVqMi9lRGNUUExKbnFTZVV0T1g3cHdjOHlTMXU5U2RiZTAzOWFF?=
 =?utf-8?B?SlF4bnRKcGVEVVFvVXFiZ200SDRtM0hPTExHeXJ3UmJIQkw2SGxzV05PdG82?=
 =?utf-8?B?NTVJbG96UlhES2dFQXVWYXlmRVdrV2l1OHY2blo1aFB3ZjRpdjI5bDFDMFVq?=
 =?utf-8?B?NDVVZTlYTWpJS0xsbDNsU0ZHZHEzR3JlYW9XMDR1SkwwTjd4V1hETUlxb0hp?=
 =?utf-8?B?dThtcWZvSHd5c1dLRzBPd2JXN3pNY3FhTVlySXVGdWxzTUYrdTF4TGpvbHZE?=
 =?utf-8?B?ejNXZXRmQnppZ01lVUg2TlpZWnQ1R0h5djc5UU45MHZqRXJrQlZiTVQrZnhF?=
 =?utf-8?B?ei9uZElhMUppRWV4TlRFVk1RWnphV3ZuOTAyV3BvUEVyUkJ1eE1OaWFsMlhp?=
 =?utf-8?B?U2pyZlNMdGRBaW8zZ0E5L1lDN0dhQlc3dUR3cHVQRHJMTFV0WkFscTBhR1No?=
 =?utf-8?B?YWxWM3kxS3MvWG0wT1RlODNLUnBmTUxkZFk2Y2JCRXZCNXBreVpPMSt0VURK?=
 =?utf-8?B?UWx3eldDK1owdXRGUzZ0M1RMd3J3T21SZFdzZFVaMTdOTTNuK21hTHVtNDdp?=
 =?utf-8?B?ajhPc3ZmTWV4R3dLWERmWkZUaHJKODcvdHlLZW1qVjNSNUw0RnFKaEo5U1gr?=
 =?utf-8?B?c0Z2THphKy9xdWUwaXJMdmdYNUtNNzlsRFZWd05VRExvUnVxcjA5aE1NeXNV?=
 =?utf-8?B?MURxb3NoUGxhM0I4Rng5bEpCRk9TcjAzbHAxV0dwVTluTzRVbEMwQ0J5Wjdw?=
 =?utf-8?B?a3IzK3VUTHNKRUVKTnB6d2FmQ1lTcTFteHRHOXdIRTZ2TEMzWk5qN2NHbnpQ?=
 =?utf-8?B?TUdFZ29wNDd0UU1rLzBPeVA4dDhDVEhhZEs4MUR5b3VGWXhrK01ld09pWERn?=
 =?utf-8?B?VGNuWWhMOHduMHIzR01CL2x0d1dnVFhZcWFJSU4xV3JMbGZLcGRqa01OWFlX?=
 =?utf-8?B?N054TTJzOTFYQkVpaklERWZZaWR2SFcveHhPcjZnamxuSk9lUFlqaERYbU1D?=
 =?utf-8?B?QjBUUkRBNExqTGhNSzZ1QlA4Z3BLakpEZFVmaHRPN1BsUXVIbjgrMVdzSWFK?=
 =?utf-8?B?c05jVDdpRzBvd0U5dzJXTXFlYy94RG11N21FLzJXRTQvaiswV3piNUFka2wz?=
 =?utf-8?B?TzdUOWtYSWJsSU1QVlZtVmhIMmFHQnVkTVp4VEdnajRFS1pMck1uUzE1eEcv?=
 =?utf-8?B?WTVpbUhSY2YxUnBEMldEMlBWd2VvQ0ZZdnF1VjFXMklSNXlzZ20zY0pCV09q?=
 =?utf-8?Q?NSO/HSFa+3CyAJU0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7928C4F11EEDB4794A1816E652B7F60@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB4969.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b1179bd-67d4-4dd5-1bad-08da32afe170
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 18:07:00.8764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0HuIJYN97lvqy6jJv8M/QM4fAjdbWtdPq6maujX3JQ7ZxghrPUvUY+EOog0wm2Rf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4216
X-Proofpoint-ORIG-GUID: mzzFFGaxB2Da1nbOqqFG4Bz9xF1S80H4
X-Proofpoint-GUID: mzzFFGaxB2Da1nbOqqFG4Bz9xF1S80H4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_05,2022-05-10_01,2022-02-23_01
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

T24gVHVlLCAyMDIyLTA1LTEwIGF0IDA5OjUyIC0wNzAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cj4gT24gVHVlLCBNYXkgMTAsIDIwMjIgYXQgMDQ6MDc6NDJQTSArMDAwMCwgUmlrIHZhbiBSaWVs
IHdyb3RlOg0KPiA+ID4gDQo+ID4gTm93IEkgd29uZGVyIGlmIHdlIGNvdWxkIGp1c3QgaG9vayB1
cCBhIHByZWVtcHQgbm90aWZpZXINCj4gPiBmb3Iga2VybmVsIGxpdmUgcGF0Y2hlcy4gQWxsIHRo
ZSBkaXN0cm8ga2VybmVscyBhbHJlYWR5DQo+ID4gbmVlZCB0aGUgcHJlZW1wdCBub3RpZmllciBm
b3IgS1ZNLCBhbnl3YXkuLi4NCj4gPiANCj4gDQo+IEkgd291bGRuJ3QgYmUgb3Bwb3NlZCB0byB0
aGF0LCBidXQgaG93IGRvZXMgaXQgc29sdmUgdGhpcyBwcm9ibGVtP8KgDQo+IElmDQo+IGFzIFBl
dGVyIHNhaWQgY29uZF9yZXNjaGVkKCkgY2FuIGJlIGEgTk9QLCB0aGVuIHByZWVtcHRpb24gd291
bGQgaGF2ZQ0KPiB0bw0KPiBiZSBmcm9tIGFuIGludGVycnVwdCwgaW4gd2hpY2ggY2FzZSBmcmFt
ZSBwb2ludGVycyBhcmVuJ3QgcmVsaWFibGUuDQo+IA0KVGhlIHN5c3RlbXMgd2hlcmUgd2UgYXJl
IHNlZWluZyBwcm9ibGVtcyBkbyBub3QsIGFzIGZhcg0KYXMgSSBrbm93LCB0aHJvdyBzb2Z0bG9j
a3VwIGVycm9ycywgc28gdGhlIGt3b3JrZXINCnRocmVhZHMgdGhhdCBmYWlsIHRvIHRyYW5zaXRp
b24gdG8gdGhlIG5ldyBLTFAgdmVyc2lvbg0KYXJlIHNsZWVwaW5nIGFuZCBnZXR0aW5nIHNjaGVk
dWxlZCBvdXQgYXQgdGltZXMuDQoNCkEgS0xQIHRyYW5zaXRpb24gcHJlZW1wdCBub3RpZmllciB3
b3VsZCBoZWxwIHRob3NlDQprZXJuZWwgdGhyZWFkcyB0cmFuc2l0aW9uIHRvIHRoZSBuZXcgS0xQ
IHZlcnNpb24gYXQNCmFueSB0aW1lIHRoZXkgcmVzY2hlZHVsZS4NCg0KSG93IG11Y2ggaXQgd2ls
bCBoZWxwIGlzIGhhcmQgdG8gcHJlZGljdCwgYnV0IEkgc2hvdWxkDQpiZSBhYmxlIHRvIGdldCBy
ZXN1bHRzIGZyb20gYSBmYWlybHkgbGFyZ2Ugc2FtcGxlIHNpemUNCm9mIHN5c3RlbXMgd2l0aGlu
IGEgZmV3IHdlZWtzIDopDQo=
