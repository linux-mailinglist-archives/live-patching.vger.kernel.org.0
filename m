Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835D4520A31
	for <lists+live-patching@lfdr.de>; Tue, 10 May 2022 02:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbiEJAgF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 May 2022 20:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233762AbiEJAgA (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 May 2022 20:36:00 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7011B14AF44;
        Mon,  9 May 2022 17:32:05 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249MUk7R016553;
        Mon, 9 May 2022 17:32:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=BkzVoTnv4NX7Jwo2xUGpzlElxTPc3+LzKYj869f6iZk=;
 b=lr9UPKWO+yb2Z5xKbb7kJzvTO281FcTU+dlvdU9aV+5IGEnd8ijAfupkwVC63k5n/ell
 6PyYjK38zJL6aqFkkAO1h2L5I3jZRHdKOVJtrkAmqExhmkEcWOa6OE2fwaCgKrdS0Cqg
 4MMtWw3wAZYGsY5yo+Z6KFyxdoBGlfwH+2U= 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fwnvs4rx0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 17:32:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=moStKeBEGuYIzlvQGE8pkC4kA83TnxmxZgAKfJmVDLFdHqz8H+Wl24Nb0v+vyWRnkppLiXysomPhm1LjGmVMXJnR1ozH9infBDwh6OFpi0KD7CdMMxlOnUKkQxnZmGBiTW7DO/MH/T0TqZIO+fQx0eNVeDTfwMlTZIaLGz7hZAi1D1B718T2uCH1WU2oeRz/xq3qxZjUDY+Q9A3UfAZmYIfiGPmxT+TKI0HA75ntBg1f3D+MMtYnTiOuam7DA3cjtJstSkB8Ewq7Ts4hSTVTVdo333YRH4nBK5ERrSdHIyjydxpfFcEW4rBusM99m5+jUfLeotgGY33H7S7ytwQz1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BkzVoTnv4NX7Jwo2xUGpzlElxTPc3+LzKYj869f6iZk=;
 b=hpqQOqLAWHc8NsuKm3HiiCYqYaM7+P7Po1fSQK+Zt35LT9l7PNhIPBTO5RABoLdRoKXSHEPXN/eH13fHLOm31HrkbDqvEVzHQs0fU0hM8Dkoq7vQzULmVpoeq3M4GhgmYKu334VttJvmOuWMuFrNyeiVkCI8vJtlIie5ihGKMklz2zAiHbfzuYLoq2jHXftxxf9PmfXoIg65GsPISByNNvss+QjWBeGTzZ2hp5dYSJFxrKlyX4UNluTRGv/cq/8iE32/LwNWtYIAeGMeQmXv6+mC4nv/jp2QS7tYSRc10Ht61GNym5m/xwOZ8N0hfMICavNfqtmRECbE12yi70boWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB4579.namprd15.prod.outlook.com (2603:10b6:806:19b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 00:32:02 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 00:32:02 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
CC:     Rik van Riel <riel@surriel.com>, Song Liu <song@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [RFC] sched,livepatch: call stop_one_cpu in
 klp_check_and_switch_task
Thread-Topic: [RFC] sched,livepatch: call stop_one_cpu in
 klp_check_and_switch_task
Thread-Index: AQHYY7zTSXNMQhssp0imSrtNeUcDwa0W1b4AgAATnQCAAAIXgIAACPkAgAAFk4CAAElBAA==
Date:   Tue, 10 May 2022 00:32:02 +0000
Message-ID: <AD44A5E5-24BA-481A-AF32-4704A3207245@fb.com>
References: <20220507174628.2086373-1-song@kernel.org>
 <20220509115227.6075105e@imladris.surriel.com>
 <20220509180004.zmvhz65xlncwqrrc@treble>
 <68f91fb233d5bf82e29cc5c6960a62863b297db3.camel@surriel.com>
 <20220509191745.yk2txsa4cv3ypf6k@treble>
 <1f94c48b4e0e7d73a689a076f78f0892095b4d89.camel@surriel.com>
 <20220509200949.vzx4g5xpebomkok4@treble>
In-Reply-To: <20220509200949.vzx4g5xpebomkok4@treble>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf9315cf-2b09-494d-dfd5-08da321c8093
x-ms-traffictypediagnostic: SA1PR15MB4579:EE_
x-microsoft-antispam-prvs: <SA1PR15MB4579650C7BE1543D5F93CE7AB3C99@SA1PR15MB4579.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aqviIbQsoyJ9La918Eq4ZNNXNmo9c8R1TonKdw3O4IAo/mMitfmxM+wR5DS6Bb3fRshMrqTezrrnMdan/pOfhsEYgcuradkuObj4tgZifxYVUU1kgD95zvCjPLBWQuRypOHfV5uF9k7MaeZrZCVMwveGOfDmBsGLUmXBMHd0PuX2hO+3owyq4mSkq0y/+21opgAttwHS9A8HMt9qCz6zeOj/vRg1s7eftihX9w7xVFW1Ageq9ZF7pxit3lpf3/EMww2Hkwn6+MykKAX+ret1HMwWw3ZCmN2GiYPdEAMWC9VdthQZsmDwE2qIaMKFQED/HsWYgiAG4qpyAbklZlNpChbZrTqBnb4enOMEIiXXayw4h3d1LYHcuz8Dl5Ga+iTE7Myb5kAruU1zIWW4wMcTDJGWsrFpFkgDZmJaD+vaWbtioiDVOg9Y9MrYpPbrtXCUI0NlHU320NpZZ/bfWboGSkFO5P/vx/WnzVXDc253jrX81rcGoU7XBvTrtC/UNNYSuGI/rg8QiCgTtySJZuyCRmOVA7ZVZd3QUV/o3g3ktYVUBE7JdQyxcvORv49kpmv5vr4l0N/zQg7PZqtANatoJfok4JZnt+/dVx9/PydzTBe6feB8Ec/iKkKsndo/e2FM5OPph9smIL5+0K3agEJ6IKEbuoZCGRaBeyi/98FgFDgbovvJUxfePuLYZs+ko8h1Y42rK05yn2ZwOmEFoOcHOS/Z3BTzLBRXuspOIgl4bczsq3LaM+S7wo/ahcRDiqDy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66946007)(66556008)(54906003)(64756008)(6916009)(66446008)(76116006)(66476007)(86362001)(4326008)(8936002)(2616005)(8676002)(316002)(91956017)(6512007)(122000001)(53546011)(6506007)(508600001)(71200400001)(6486002)(33656002)(38070700005)(36756003)(83380400001)(7416002)(186003)(5660300002)(2906002)(38100700002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UkFXOWwwRVlVaVBDbXBTZ1JuRkc0Tm9lRzA2S2h4VkRrRFNud0g2N1FGNGZm?=
 =?utf-8?B?TkZLYmlDeUdrZW1SWkVMelhCOTY5M052YlRueDluQ1VDY3RtQUdnZHNqMHBS?=
 =?utf-8?B?NVJTeCtjcy9lcTNYZ1dvRzZEWXZFZGNYY3h1RHo4em1xcWtUbzk0M0Z3ejk2?=
 =?utf-8?B?OC9CT3pZRWJyS2pMU1FQZTJBMTE5MXdnS212WXhZOHo3cG5NYnRpb1NkbVdB?=
 =?utf-8?B?bnZyZ2FWUXozVEV6eXVvb3gzcmF5RHNYY2ZOZ0ZpYkxsZm1oM280S3pLZVo3?=
 =?utf-8?B?TEMrQUtVNFF4NjJUa29xcmQ5RzBCdEQxOVN6T3pFemV3dmYza05tTFpEL2lS?=
 =?utf-8?B?c2lRMVAwS01qRGkvRVYrMm82R3NMQ1luR0MzUXhLdk9hMytPc2xobVIzY0NR?=
 =?utf-8?B?b05hMlJXbGVYWElTeGJwWkg3SVgyTjcrK0Nibi9PZ2xIT0xiOFRjRkhpZFJ1?=
 =?utf-8?B?eUhqYUJPdWFveEd5blY2amxkd2t6bHlXNDAzMHdWVHJzYmZ6cFRnc3hlVHBM?=
 =?utf-8?B?cWNMRmFoaGJGYXIxc1ZEaFUzd2NkbmlNQlhVODFiaWM0MWZnVkpzQThKTkJW?=
 =?utf-8?B?MHlONFd5bWNrTG9DUGJMeUNZalhUNERCV3JRRENwMDd3VnFZTERLNEdhYjZq?=
 =?utf-8?B?UkZ6d0FkVkFqVFRFdmk2anFiUWd2TjA0VVdta28yekJVN2d2WjM5NHZJd0pL?=
 =?utf-8?B?RW90UGhVcC91bVd2YlNMR2phd2RjMjh1QTZHcHdKYzlhSE1CNFMrUEdYNEth?=
 =?utf-8?B?bHJMNUVOK3NVTHQ3N0txYTdaVFU4ZmY1K1FSb2JmZTFJTGlsQjZNdURadVhY?=
 =?utf-8?B?RDZUaXozSXBZSSt2VmdXQ3FDSGQ4RFZNZmcyZGRYczVlREduUW1ZVTIwd1NT?=
 =?utf-8?B?ajNSanZPM2lINGZBdDN1emM1VjJzL0FwWElqWUdlWHRJR0hlZTFEVUhzT3R1?=
 =?utf-8?B?Y3BSZ2x1L0xLUThnekYrb0ZKUUVQNzIwVGN0cUFLaEdGbkV2VllUNWIrU1hF?=
 =?utf-8?B?Q2pxd0M4L2NsZk9TU05YbzdmampjdTNTSjZPM0VYdUpWemU0VzlFMWR1cXhO?=
 =?utf-8?B?QTE1RXhHRTlwdDFuQWJmWGdjaUdTMmIraGhESk9KMVFVbWVkWm5JUzkrcXVX?=
 =?utf-8?B?S2pWYStkM09keDI5SGdzMFZQREk3Z1JtZGRpZWxwK0pINkFBVlYweXc0TTky?=
 =?utf-8?B?OW44TUs3eG9iMW9RTStGNTh2NHFreUF5SmRZLzZBNkRBc1BVbVFQUytLNGhR?=
 =?utf-8?B?R2g3SzVReGJvMXl1ekYxOXcvK0kvR2traTlqcUFsMVBYUDBIQ0o2bEJIQ0I3?=
 =?utf-8?B?ZVNTTnZYOStydU5yZDkyWXh4R0VkaG9QcUFFc0hnZEhYYlVaUVFJQUhyZEo4?=
 =?utf-8?B?ZUNGaC9qeGhCeElSRGpSOFNMRzVsa2lQYWZBUTJxNTNsTllSTUJQL2hReE1s?=
 =?utf-8?B?MUZvY01BZGRBOWhYZGtSUkxjUGFqSk9yQXgxYXdnVjlOdHcvamloRThERE14?=
 =?utf-8?B?VkI1L3kxdUR2MjFCd1pFNGcxNEJtNU5LTGZ3R3VETU1UZHFod3JYRERPZ2ly?=
 =?utf-8?B?ejViVGhwS0hCYTgySEhQbndWTlhqUjViY2dPYmRmN2tYblkzTk5yZ3o2cjlt?=
 =?utf-8?B?Y0M3OU9ORVd2bm9lblZOck5YUjZKbGFCcnJQb3liUmVVMVNoSXltZ2FFamd1?=
 =?utf-8?B?MXFsNFk3TStIQU11c0xxQWRpK0x6a3JPdzVGenNHc0tSNUNsM3ZwcW5takcv?=
 =?utf-8?B?UEo5eCthNjZSN0orb1FkRjJrTWFzc2Zaa0pIaHBDUVNyOHJ2d2NuNkZzMita?=
 =?utf-8?B?NldCaDhtTG9rSjZVWHVqUzF6TUpkc2d0LzY3NVNxcy80dWZUL05wUGd6eWc5?=
 =?utf-8?B?ZERZT1JtcWRkYlBqUTFud056d2tuUVo1elZBblljcXo0L2ptYll4MEtXakd2?=
 =?utf-8?B?bzdKNVgxamZmSmRpdmVpVXRtQVFSdDhYdWhuUDZJSm8rMjlHQ1Q2SG1wWFVR?=
 =?utf-8?B?dGVHVGxaNFNKVndpOEhPR3ZVYWg1b252dktCZlEwa2NncUlidkVYbzhMN1hp?=
 =?utf-8?B?cG5mZXpHa0hWV0hVMS94Z0xCVjNBOW9wVFJBQmgrY2dXaHZKbkU4b2xyb24w?=
 =?utf-8?B?Z2tHa3VoeXNSOWZORzlSMkhFRklRQ0dsUkwxVkxWVHVONVVCS1l0T0c4NGxw?=
 =?utf-8?B?UmtvbW1heDFab0Q4bVR2NlJ0Mk9NRjNlQkNsNVJrdkJZbUFkT3ZHdDQzakgv?=
 =?utf-8?B?akl5VmRZZ01nWW0zU0JjUG0zc21NaTk1My80ZGN6MUtCR0ZvNXVtRzFFd2JY?=
 =?utf-8?B?SWpacUQvRmlzWDJkOXRRWWhKQjJmdy83WE1PS3JnL0EvWmZaNHlNdjlRZFd4?=
 =?utf-8?Q?K3zWOnvwXFzGYbM7o1MgO5AqFFqsbK/syCaOJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <398330B4CB5B554389C899DB46325F68@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf9315cf-2b09-494d-dfd5-08da321c8093
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 00:32:02.3681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WsWhO6ZlDVe3blZNh4avrplkPWUERk03Q8wTGsGecVlZ0izd38T3p+gQxoLCH+7mCE8dq3SPXnbFNijrgf6rOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4579
X-Proofpoint-GUID: CtqYRth_zLpHEDYoqxGy1kuzU2uQMI2y
X-Proofpoint-ORIG-GUID: CtqYRth_zLpHEDYoqxGy1kuzU2uQMI2y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_06,2022-05-09_02,2022-02-23_01
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

DQoNCj4gT24gTWF5IDksIDIwMjIsIGF0IDE6MDkgUE0sIEpvc2ggUG9pbWJvZXVmIDxqcG9pbWJv
ZUBrZXJuZWwub3JnPiB3cm90ZToNCj4gDQo+IE9uIE1vbiwgTWF5IDA5LCAyMDIyIGF0IDAzOjQ5
OjUyUE0gLTA0MDAsIFJpayB2YW4gUmllbCB3cm90ZToNCj4+IE9uIE1vbiwgMjAyMi0wNS0wOSBh
dCAxMjoxNyAtMDcwMCwgSm9zaCBQb2ltYm9ldWYgd3JvdGU6DQo+Pj4gT24gTW9uLCBNYXkgMDks
IDIwMjIgYXQgMDM6MTA6MTZQTSAtMDQwMCwgUmlrIHZhbiBSaWVsIHdyb3RlOg0KPj4+IA0KPj4+
IA0KPj4+PiBTaG91bGQga2VybmVsIHRocmVhZHMgdGhhdCBjYW4gdXNlIGEgbG90IG9mIENQVSBo
YXZlDQo+Pj4+IHNvbWV0aGluZyBpbiB0aGVpciBvdXRlciBsb29wIHRvIHRyYW5zaXRpb24gS0xQ
cywNCj4+Pj4ganVzdCBsaWtlIHRoZSBpZGxlIHRhc2sgZG9lcz8NCj4+PiANCj4+PiBNYXliZSAt
IEkgc3VwcG9zZSB0aGlzIGlzIHRoZSBmaXJzdCB0aW1lIHdlJ3ZlIGhhZCBhbiBpc3N1ZSB3aXRo
DQo+Pj4gQ1BVLWJvdW5kIGt0aHJlYWRzLiAgSSBkaWRuJ3Qga25vdyB0aGF0IHdhcyBhIHRoaW5n
IDstKQ0KPj4+IA0KPj4gS3dvcmtlcnMgaGF2ZSBhcyBtdWNoIHdvcmsgYXMgeW91IHdhbnQgdGhl
bSB0byBkbywgYW5kIHdpdGgNCj4+IHRoaW5ncyBsaWtlIGJ0cmZzIGNvbXByZXNzaW9uIHRoYXQg
Y2FuIGJlIHF1aXRlIGEgYml0Lg0KPiANCj4gVG8gcHJldmVudCBwYXRjaGluZywgaXQgd291bGQg
bmVlZCB0byBiZSBzb21lIGtpbmQgb2Ygc3VzdGFpbmVkIENQVQ0KPiBhY3Rpdml0eSwgcmF0aGVy
IHRoYW4gYSBidXJzdC4gIEkgZ3Vlc3Mgd2UgaGF2ZW4ndCBzZWVuIHRoYXQgc2hvdyB1cCBhcw0K
PiBhIHJlYWwtd29ybGQgcHJvYmxlbSB1bnRpbCBub3cuDQoNClllcywgd2Ugc2VlIHRoaXMgaXNz
dWUgd2l0aCBzdXN0YWluZWQgQ1BVIGFjdGl2aXR5IGZyb20gYSBrZXJuZWwgDQp0aHJlYWQsIHdo
aWNoIG1pZ2h0IGJlIGEgYnVnIGl0c2VsZi4gT1RPSCwgdGhlIGtlcm5lbCB0aHJlYWQgZG9lcyAN
CmNhbGwgY29uZF9zY2hlZCgpLCBzbyBpdCBpcyBub3QgYSBkZWFkbG9jay4gDQoNCj4gDQo+IElm
IHlvdSdyZSBhYmxlIHRvIGlkZW50aWZ5IHdoaWNoIGt0aHJlYWRzIHdvdWxkIGJlIHByb2JsZW1h
dGljLCB0aGVuDQo+IHllYWgsIGRlZmluaW5nIGEgInRyYW5zaXRpb24gcG9pbnQiIGluIHRoZWly
IG91dGVyIGxvb3BzIGNvdWxkIGJlIGFuDQo+IG9wdGlvbi4NCg0KY29uZF9zY2hlZCgpIGZlZWxz
IGxpa2UgYSBuYXR1cmFsIOKAnHRyYW5zaXRpb24gcG9pbnTigJ0gdG8gbWUsIGFuZCBpdCANCnNo
b3VsZCBzb2x2ZSBtYW55IGRpZmZlcmVudCB2YXJpYXRpb25zIG9mIHN1Y2ggcHJvYmxlbS4gSSBh
Z3JlZSB0aGF0DQphZGRpbmcgc29tZXRoaW5nIHRvIGNvbmRfc2NoZWQoKSBtaWdodCBiZSB0b28g
bXVjaCBvdmVyaGVhZCBmb3IgdGhlIA0Kc3lzdGVtLiBTbyB3ZSBhcmUgb3BlbiBmb3Igb3RoZXIg
c3VnZ2VzdGlvbnMuIA0KDQpUaGFua3MsDQpTb25nDQoNCj4gDQo+IFdlIGNvdWxkIGxvb2sgYWxz
byBhdCBhIG1vcmUgZ2VuZXJhbCBhcHByb2FjaCwgbGlrZSBzdGFjayBjaGVja2luZyBmcm9tDQo+
IGFuIGlycSBoYW5kbGVyLiAgQnV0IGFzIFBldHIgYWxsdWRlZCB0bywgdGhhdCB3b3VsZCBiZSBw
cm9ibGVtYXRpYyBmb3INCj4gQ09ORklHX0ZSQU1FX1BPSU5URVIuDQo+IA0KPiBXZSBjb3VsZCBt
YXliZSBkZXByZWNhdGUgZnJhbWUgcG9pbnRlcnMgb24geDg2IGZvciBsaXZlIHBhdGNoaW5nLCBi
dXQgSQ0KPiB0aGluayBvdGhlciBhcmNoZXMgd291bGQgaGF2ZSBhIHNpbWlsYXIgcHJvYmxlbSB1
bmxlc3MgdGhleSB3ZXJlIHRvIGRvDQo+IHNvbWV0aGluZyBsaWtlIHRoZSBPUkMgdW53aW5kZXIu
DQoNCg==
