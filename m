Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818915227F2
	for <lists+live-patching@lfdr.de>; Wed, 11 May 2022 01:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238890AbiEJX5V (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 19:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236711AbiEJX5K (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 19:57:10 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226FFB2E;
        Tue, 10 May 2022 16:57:07 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ANL9Rt030213;
        Tue, 10 May 2022 16:57:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OeH7cdhm5xo2GGUXXPYVmpsG4mhfNqOB8lblirUqHCI=;
 b=iiPy/EsMx8TXgf5tSr1UwBL3RzGGcjrN0esE3lq8uJzGwpydr1e4B6BivVy/2Z489VtG
 tsg6mqtUOvSflTZUF61W1AyLIBltZksyD6vaaOTtvrfNhAHsvkfV5ak3YNKP6JrrIpFF
 Mr0iEO9FadhKsMeP8lqWSQCZMTjuZs6WINA= 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fyx2n1r2c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 16:57:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foVCvN6K7L1LaxcCW9goA68dbG4Wru4jLCRndG9Iay/0eR40W97/y2/Z5mC3al+VrM7hz9dZHNJ/iPqVcCdSl6920bsuErjV+Ktz0pLQOZJmSb/7zCJbIjD7IOlkjYU5F+9+w7Ki+2ZSxtz534KlpX1xQr31zg2GzuwoU4aWM61c4N5+yGTU+PcvuHy77PhmGPUoPWL0B9nGjwfb/JobzbktNqaRm6m6BFPFHjoMIJAtsu5TEqDY7DKlYnGc3X49grzs00kSnID2MeAUTlx+4xHDHUWolOn/2oWCwauRvHal94HeD6HES3zuBSfqK4dGtpPUNxwSSXa0zd22FQ6naA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OeH7cdhm5xo2GGUXXPYVmpsG4mhfNqOB8lblirUqHCI=;
 b=QBz1LzaQbre4C0c8N3D15Ch1LEwFNnKFLZMLK5KAD9lEo1LXLvvYPYunq8Bouikp/5eVeAtlkzRXpfiO+hR1+IH7YIv/haLYl+uE7WCpXMZKvZ1mWY3zgGwm8bMPYpTd9igI5weZKSGB3+f4sou/LOMCea+Q2oxMtlzXq41ymOPd1nGLBW2FSB/Vu46/n15PEYl0XYfFsHskBCmg4uM+rv9H3Lw3VQ9pkqdVdYyy6ZookTaK/oUAeBb6JdifK1cRYZblR4Jshz3xtEavsZQMOEOH9Y3Bs4YbEQbzX2j05+mhOU16UFyRIzlCM3TGGK2GUpVnL83m+00F0yZGC0iuIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SN6PR1501MB2192.namprd15.prod.outlook.com (2603:10b6:805:12::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 23:57:04 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 23:57:04 +0000
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
Thread-Index: AQHYYjpsu2JIKZQIXUOp7t0Qujiczq0WqGoAgAAU/gCAAQUkgIAAXf2AgAAkx4CAAAZjAIAADJUAgAAUwACAAAnWgIAAEcOAgAA3ZACAAA7PAA==
Date:   Tue, 10 May 2022 23:57:04 +0000
Message-ID: <D298A3F1-43A5-4FD5-B198-906364BF4B79@fb.com>
References: <YnkuFrm1YR46OFx/@alley>
 <9C7DF147-5112-42E7-9F7C-7159EFDFB766@fb.com> <YnoawYtoCSvrK7lb@alley>
 <3a9bfb4a52b715bd8739d8834409c9549ec7f22f.camel@fb.com>
 <YnqIcw+dYsWz/w7g@alley>
 <6bf85ff908377508a5f5bcc7c4e75d598b96f388.camel@fb.com>
 <20220510165244.ikfh64ertnvodxb4@treble>
 <1bd15361edfd4db9fc9271d35e7bbe5edad1b87a.camel@fb.com>
 <20220510184213.l3gjweeleyg7obca@treble>
 <47440502-930F-4CBD-B859-3AC9BBFF8FC6@fb.com>
 <20220510230402.e5ymkwt45sg7bd35@treble>
In-Reply-To: <20220510230402.e5ymkwt45sg7bd35@treble>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5bf80ef8-88cf-4a63-65bf-08da32e0c875
x-ms-traffictypediagnostic: SN6PR1501MB2192:EE_
x-microsoft-antispam-prvs: <SN6PR1501MB2192AEFEC69DF3A36AAEE730B3C99@SN6PR1501MB2192.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d4PL/0KAmDc9YQa+ZU/BnXOmfaPZ0G2ki7fi9Q1QI1f0Mxi3MKjHkcPf3gWuxm+J0imExYouhsw/MCsXG9iwXOGAq9b/86WqwoPAP1ytwTHejZi2fl3oRWfg6p8MyHfNbuCwKbIXJGdXh+2FATTmMuiPjATCDYeuc2yxX0GniN8QBCvNBfH0cqcKQPCB1n6G6XxjWNj01IAcba/VT4lGS03+RiNoFrYi5eURiqJl2f3u8YRxRcJ4BJKQ2U2fLGjviK+mHjC9SgrNob/mZxtHGaMJKRlqGqLq0NXVWQScJowx2z0C7TF9SEtJFBUZVuwl9e43f9Kyjr0ZTvGtBkuVGQfrMIjN2dJD88cBzu612dbhfUemnVNnNhCkjeWTIHx/eCNi9v0YSj2yooMW4NZOadga0QLTPgiYA2mDRZ6TvBPzwaIcoUZfHf8hboIqfIJTsrZTjTwwWINjfCAii/GLxYBYdFjMPUa1BhtYoBKT+lmzmwEnRSCVLOmLfMdh3BtLbKeViSYSJ0ql+zeQG5fxlTb2oPEFKw3/qJbruk6SePCZSKiuN1OXbG0n2/kU83/28lV7tfPjKs+BJsl1O627RrVkAUh/vkLLUlUFYkUsc/yr4zWGoY5ZPjxP1T1Pqx2SomaSTmvYFwaSIXNZZtlWxeZ1w5Kz+FRuRdG8P7s+Ih6evhMaQzbLvXU+vsuKf43TX4eJ4+3I6Bo+MlU0O4GNvHC0NFy/yVfml12h0l95Hx7ADLj1WSkZ+rLOvS4XzBYO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(2906002)(36756003)(122000001)(8936002)(38070700005)(38100700002)(5660300002)(186003)(83380400001)(4326008)(33656002)(508600001)(66476007)(66946007)(91956017)(76116006)(2616005)(66446008)(64756008)(66556008)(8676002)(54906003)(316002)(53546011)(6916009)(6506007)(6512007)(6486002)(86362001)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YnpDVUJlNXdIS25IMXVRRFpRZXJqazBtUjBxWkVSWE5LSEdqdEl1T2tzSUM4?=
 =?utf-8?B?S1hCYnVhVTQ3bmlvTDl5UU1jbEVwOEdGUXUwMC9YbzBid2R6MWNsUExjbk1r?=
 =?utf-8?B?OE96MlQ4WFZreTFtMGhwWkt1d0R0Ui82d2k2OUMwQ0pnTkVJd2p0QkJwWUZ1?=
 =?utf-8?B?OWIxQytOZ1c0SnM3bHZwRVlnT0pMMXZ6RUdoR20wWTN5QVRVZndCZ29ld3lh?=
 =?utf-8?B?TXVhMzIvR2hFNlNPTTFTRFBRNEMra0o3a3o2dDlDMTNxOWY2ZU4yNFZFT0M4?=
 =?utf-8?B?V0Z6UkZGbm5MeXpJTEd3YkFpMEFhSmEweHNzcFF6NzdmWVR5eGFEeVFnL2tC?=
 =?utf-8?B?eUVRNkJ2VDR2OE84S0JPTGVLck9ZK05WM3N0VEtFME9qMWpZTmRUUWNPNDlY?=
 =?utf-8?B?VnVpRXRTdTJFR0FWeUcvMklTbDZEdlA4THg5bEpkVXlSVXRjRUtBaEpMM09k?=
 =?utf-8?B?ejhJR1BEcmtBdkZKVDM4eGxmNTJsRnlwQ2FqTFNyNitoSXpncHVHaEIza29G?=
 =?utf-8?B?N2luN0FhU3hDTHZOVUFYZGdIWDh0Wmh6cHIrWHNVRVJZTE8rZWVyOTJ4Nkkw?=
 =?utf-8?B?U1djUllZcmh1bXlWU0kxTlFyNExDU29hL3lIMTIyZzdjK2tESTFMM21UR0ZX?=
 =?utf-8?B?RVB4clQwNnViSWpxUDdia1pHTzNoMEtkYTd4cUlheVd3eS96OWZ6Z0Fiei9T?=
 =?utf-8?B?bWt3NlNRbTBEZFY5TU9nRnJEcm5aZzdZZ0FvSXJScGJ3NWRCNDVKdW15L1dO?=
 =?utf-8?B?dnRkNUlCem5yVFYxdUFldHRST3pSMFMySzdTNVRNbVhtNzVPUSticlJPRmcr?=
 =?utf-8?B?eWQwU3hsZ09oRFFiSldJVXZUVi9tWitRdG5hNWNGcEZkWUxGc1o2d3JuaGlp?=
 =?utf-8?B?YUl1cHNwQzNzWGJCeWRSM2ZPZGl6alF6a2c5SXdxVVErTjZ5ZnRyVTBrNEZz?=
 =?utf-8?B?R2ZObm4vZldBdEY0TW5BczJ6K3VsMmdMZXg0OVpMYi9lL3M5RzR1OGx5NHBy?=
 =?utf-8?B?anlvS1owZ3EyK21yaG01N3ArNTY5RFVoZGZiWjVZbVBVV05DSU9CTEllazZQ?=
 =?utf-8?B?NnpDZGFHUDlyTlRHQ3ZqeWxNRDJiR2E1b1NqTnJDZnhYN0dpa01qWXdLU1NM?=
 =?utf-8?B?anRwUU5RMTBRb0huajNsS2dJUFR6VjRlTXhjUGlHZUdCQTJSZW9uVm1oRFkr?=
 =?utf-8?B?TkprbExiSmY4UXM0bTFXUzRYRmplc1gyZUpwTldrU3YwcGZ2a01oS1VhaDdN?=
 =?utf-8?B?TUZ6TUJaMEl0a3pqTldVRVNzSk04bVpVd3JuQkZiYkIzakg5YmU3dmVZUTlZ?=
 =?utf-8?B?aGxEZnNMcFpUMHJIMEJwck5yVnIwYkQzWUxFSjBWZzkwY0Q2NHRXdzB2SGV6?=
 =?utf-8?B?Q2UzR1NNZkowRWVucjg5blpCVXRDVWxObUNsYndyRWNaNnhES05oN21YTWJp?=
 =?utf-8?B?cmtKK21CZUR2MjQ5UThCc0lBbXB6RlNSQnhxZlhVWFdVaG9EVVVyVllpYjJk?=
 =?utf-8?B?WXVQMjNpV1JVTWFNeTJzVUlRcC9SNGZDOTJoWDlzdkNock9xOGJLVlp5endo?=
 =?utf-8?B?TkNiSGVyQTVSVkdtQVpNOWN0REZveFA4Tk5jNmRXajV6U2NJVG8wb1NBSFR0?=
 =?utf-8?B?cU9ENlpldGNaY3RsRVJOQmswZUF1a2VpYlJxVUV0T3B2Z3QzQmhWMERsb2NE?=
 =?utf-8?B?MUFtcGdEdE5HT1RldEZ5cVFjTnFGMmszWmpibkcrdGlOZ25OTHE4b3UwTVRE?=
 =?utf-8?B?TllGWXNoRzFPRjVvWGZlZjVZOXFSN3VsNFNpY1dTR0s4MXNJczZ5U3hKa1di?=
 =?utf-8?B?c01CMEc2R09iZ1JsNzlxNlZZcndUMGRnd2NuUFVsYmt6UU1JQmttQUFVcnJG?=
 =?utf-8?B?TE0rU1l5V2t1cytQd3JQbUVCLzV2VEs0QWQ5TnkzQ2ZMTm13cHZpY2k0Szd6?=
 =?utf-8?B?ODVaZ3FmTXV4Q1dQOGduczljaUhOSW52a042VUdXaG85eisxcXkzdW1MQmha?=
 =?utf-8?B?aTdxUmoyemZLUWtJYUxoWWlwb0JuU1FtM2FsQkhGcnFBZ1BRZXQ5VXVmbXpS?=
 =?utf-8?B?WEwxbmNVckQ3T0hhRmpNRjhIbGpJdFRLWEhydXBualh2NWYwZ0I1RFE1WVMx?=
 =?utf-8?B?QlJObTBNQVQ3Y0dzNG8rbGhJaEwranpRcUQxK0FBU1BpNU8ySmd6czNZQm5q?=
 =?utf-8?B?RmRzMXZ3Z3RlNDNYN0NxbEozUjgxS285dGdCa1dYSE1JbWZ4VmY0WXA3bW1r?=
 =?utf-8?B?YUdSQzJBcktQRTVETkgwSFhNQ1VsTU9za290aXZXSjFFY1FRYVl0RzBkKy8w?=
 =?utf-8?B?cmJneElzUi9pc3loT2kyM2x4WlZNa1lEeGhCTVpMRGxEUi8vaVIzZXBQUkJH?=
 =?utf-8?Q?OSq0c7hJpPLT7SOlL80MYX+xC/k/L5vxzgr4k?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <867E0CAD670EB54781925508CBFAA7D9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bf80ef8-88cf-4a63-65bf-08da32e0c875
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 23:57:04.3391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6wu/QRjyB2LElVC4VdQQqubwBHYOK+iLRK/H9ySrzTPKqPuCG1JWiazEOG4jubSLyAdGMr+UG0SpTJHsNETl7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR1501MB2192
X-Proofpoint-GUID: 7lLH4MPUA7P7RuafTQKz9nUXg3QYwYcH
X-Proofpoint-ORIG-GUID: 7lLH4MPUA7P7RuafTQKz9nUXg3QYwYcH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_07,2022-05-10_01,2022-02-23_01
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

DQoNCj4gT24gTWF5IDEwLCAyMDIyLCBhdCA0OjA0IFBNLCBKb3NoIFBvaW1ib2V1ZiA8anBvaW1i
b2VAa2VybmVsLm9yZz4gd3JvdGU6DQo+IA0KPiBPbiBUdWUsIE1heSAxMCwgMjAyMiBhdCAwNzo0
NTo0OVBNICswMDAwLCBTb25nIExpdSB3cm90ZToNCj4+Pj4gQSBLTFAgdHJhbnNpdGlvbiBwcmVl
bXB0IG5vdGlmaWVyIHdvdWxkIGhlbHAgdGhvc2UNCj4+Pj4ga2VybmVsIHRocmVhZHMgdHJhbnNp
dGlvbiB0byB0aGUgbmV3IEtMUCB2ZXJzaW9uIGF0DQo+Pj4+IGFueSB0aW1lIHRoZXkgcmVzY2hl
ZHVsZS4NCj4+PiANCj4+PiAuLi4gdW5sZXNzIGNvbmRfcmVzY2hlZCgpIGlzIGEgbm8tb3AgZHVl
IHRvIENPTkZJR19QUkVFTVBUPw0KPj4gDQo+PiBCYXNlZCBvbiBteSB1bmRlcnN0YW5kaW5nIChh
bmQgYSBmZXcgb3RoZXIgZm9sa3Mgd2UgY2hhdHRlZCB3aXRoKSwNCj4+IGEga2VybmVsIHRocmVh
ZCBjYW4gbGVnYWxseSBydW4gZm9yIGV4dGVuZGVkIHRpbWUsIGFzIGxvbmcgYXMgaXQgDQo+PiBj
YWxscyBjb25kX3Jlc2NoZWQoKSBhdCBhIHJlYXNvbmFibGUgZnJlcXVlbmN5LiBUaGVyZWZvcmUs
IEkgDQo+PiB0aGluayB3ZSBzaG91bGQgYmUgYWJsZSB0byBwYXRjaCBzdWNoIHRocmVhZCBlYXNp
bHksIHVubGVzcyBpdCANCj4+IGNhbGxzIGNvbmRfcmVzY2hlZCgpIHdpdGggYmVpbmctcGF0Y2hl
ZCBmdW5jdGlvbiBpbiB0aGUgc3RhY2ssIA0KPj4gb2YgY291cnNlLg0KPiANCj4gQnV0IGFnYWlu
LCB3aXRoIENPTkZJR19QUkVFTVBULCB0aGF0IGRvZXNuJ3Qgd29yay4NCj4gDQo+PiBPVE9ILCBQ
ZXRyJ3MgbWluZHNldCBvZiBhbGxvd2luZyBtYW55IG1pbnV0ZXMgZm9yIHRoZSBwYXRjaCANCj4+
IHRyYW5zaXRpb24gaXMgbmV3IHRvIG1lLiBJIG5lZWQgdG8gdGhpbmsgbW9yZSBhYm91dCBpdC4g
DQo+PiBKb3NoLCB3aGF04oCZcyB5b3Ugb3BpbmlvbiBvbiB0aGlzPyBJSVVDLCBrcGF0Y2ggaXMg
ZGVzaWduZWQgdG8gDQo+PiBvbmx5IHdhaXQgdXAgdG8gNjAgc2Vjb25kcyAobm8gb3B0aW9uIHRv
IG92ZXJ3cml0ZSB0aGUgdGltZSkuIA0KPiANCj4gSSB3b3VsZG4ndCBiZSBuZWNlc3NhcmlseSBv
cHBvc2VkIHRvIGNoYW5naW5nIHRoZSBrcGF0Y2ggdGltZW91dCB0bw0KPiBzb21ldGhpbmcgYmln
Z2VyLCBvciBlbGltaW5hdGluZyBpdCBhbHRvZ2V0aGVyIGluIGZhdm9yIG9mIGEgV0FSTigpDQo+
IGFmdGVyIHggbWludXRlcy4NCj4gDQo+Pj4+IEhvdyBtdWNoIGl0IHdpbGwgaGVscCBpcyBoYXJk
IHRvIHByZWRpY3QsIGJ1dCBJIHNob3VsZA0KPj4+PiBiZSBhYmxlIHRvIGdldCByZXN1bHRzIGZy
b20gYSBmYWlybHkgbGFyZ2Ugc2FtcGxlIHNpemUNCj4+Pj4gb2Ygc3lzdGVtcyB3aXRoaW4gYSBm
ZXcgd2Vla3MgOikNCj4+PiANCj4+PiBBcyBQZXRlciBzYWlkLCBrZWVwIGluIG1pbmQgdGhhdCB3
ZSB3aWxsIG5lZWQgdG8gZml4IG90aGVyIGNhc2VzIGJleW9uZA0KPj4+IEZhY2Vib29rLCBpLmUu
LCBDT05GSUdfUFJFRU1QVCBjb21iaW5lZCB3aXRoIG5vbi14ODYgYXJjaGVzIHdoaWNoIGRvbid0
DQo+Pj4gaGF2ZSBPUkMgc28gdGhleSBjYW4ndCByZWxpYWJseSB1bndpbmQgZnJvbSBhbiBJUlEu
DQo+PiANCj4+IEkgdGhpbmsgbGl2ZXBhdGNoIHRyYW5zaXRpb24gbWF5IGZhaWwgaW4gZGlmZmVy
ZW50IGNhc2VzLCBhbmQgd2UNCj4+IGRvbid0IG5lZWQgdG8gYWRkcmVzcyBhbGwgb2YgdGhlbSBp
biBvbmUgc2hvb3QuIEZpeGluZyBzb21lIGNhc2VzDQo+PiBpcyBhbiBpbXByb3ZlbWVudCBhcyBs
b25nIGFzIHdlIGRvbid0IHNsb3cgZG93biBvdGhlciBjYXNlcy4gSSANCj4+IHVuZGVyc3RhbmQg
dGhhdCBhZGRpbmcgdGlueSBvdmVyaGVhZCB0byBfX2NvbmRfcmVzY2hlZCgpIG1heSBlbmQgDQo+
PiB1cCBhcyBhIHZpc2libGUgcmVncmVzc2lvbi4gQnV0IG1heWJlIGFkZGluZyBpdCB0byANCj4+
IHByZWVtcHRfc2NoZWR1bGVfY29tbW9uKCkgaXMgbGlnaHQgZW5vdWdoPw0KPj4gDQo+PiBEaWQg
SSBtaXNzL21pc3VuZGVyc3RhbmQgc29tZXRoaW5nPw0KPiANCj4gSWYgaXQncyBhIHJlYWwgYnVn
LCB3ZSBzaG91bGQgZml4IGl0IGV2ZXJ5d2hlcmUsIG5vdCBqdXN0IGZvciBGYWNlYm9vay4NCj4g
T3RoZXJ3aXNlIENPTkZJR19QUkVFTVBUIGFuZC9vciBub24teDg2IGFyY2hlcyBiZWNvbWUgc2Vj
b25kLWNsYXNzDQo+IGNpdGl6ZW5zLg0KDQpJIHRoaW5rICJpcyBpdCBhIHJlYWwgYnVnPyIgaXMg
dGhlIHRvcCBxdWVzdGlvbiBmb3IgbWUuIFNvIG1heWJlIHdlIA0Kc2hvdWxkIHRha2UgYSBzdGVw
IGJhY2suDQoNClRoZSBiZWhhdmlvciB3ZSBzZWUgaXM6IEEgYnVzeSBrZXJuZWwgdGhyZWFkIGJs
b2NrcyBrbHAgdHJhbnNpdGlvbiANCmZvciBtb3JlIHRoYW4gYSBtaW51dGUuIEJ1dCB0aGUgdHJh
bnNpdGlvbiBldmVudHVhbGx5IHN1Y2NlZWRlZCBhZnRlciANCjwgMTAgcmV0cmllcyBvbiBtb3N0
IHN5c3RlbXMuIFRoZSBrZXJuZWwgdGhyZWFkIGlzIHdlbGwtYmVoYXZlZCwgYXMgDQppdCBjYWxs
cyBjb25kX3Jlc2NoZWQoKSBhdCBhIHJlYXNvbmFibGUgZnJlcXVlbmN5LCBzbyB0aGlzIGlzIG5v
dCBhIA0KZGVhZGxvY2suIA0KDQpJZiBJIHVuZGVyc3RhbmQgUGV0ciBjb3JyZWN0bHksIHRoaXMg
YmVoYXZpb3IgaXMgZXhwZWN0ZWQsIGFuZCB0aHVzIA0KaXMgbm90IGEgYnVnIG9yIGlzc3VlIGZv
ciB0aGUgbGl2ZXBhdGNoIHN1YnN5c3RlbS4gVGhpcyBpcyBkaWZmZXJlbnQNCnRvIG91ciBvcmln
aW5hbCBleHBlY3RhdGlvbiwgYnV0IGlmIHRoaXMgaXMgd2hhdCB3ZSBhZ3JlZSBvbiwgd2UgDQp3
aWxsIGxvb2sgaW50byB3YXlzIHRvIGluY29ycG9yYXRlIGxvbmcgd2FpdCB0aW1lIGZvciBwYXRj
aCANCnRyYW5zaXRpb24gaW4gb3VyIGF1dG9tYXRpb25zLiANCg0KT1RPSCwgaWYgd2UgdGhpbmsg
dGhpcyBpcyBhIHN1Ym9wdGltYWwgYmVoYXZpb3IgKG5vdCBuZWNlc3NhcmlseSBhIA0KYnVnLCBJ
SVVDKSwgd2Ugc2hvdWxkIGNvbnNpZGVyIGltcHJvdmUgaXQuIEkgcGVyc29uYWxseSBkb27igJl0
IHRoaW5rIA0Kc2hpcHBpbmcgYW4gaW1wcm92ZW1lbnQgdG8gb25lIGNvbmZpZ3VyYXRpb24gbWFr
ZXMgb3RoZXIgY29uZmlndXJhdGlvbnMNCnNlY29uZC1jbGFzcyBjaXRpemVucy4gQW5kLCBpdCBp
cyBwb3NzaWJsZSBQUkVFTVBUIGtlcm5lbCBkb2VzIE5PVA0KZXZlbiBoYXZlIHN1Y2ggc3Vib3B0
aW1hbCBiZWhhdmlvciwgcmlnaHQ/IChJIHJlYWxseSBkb24ndCBrbm93LikNCg0KU28sIGlmIHdl
IGNvbWUgYmFjayB0byB0aGUgc2FtZSBxdWVzdGlvbjogaXMgdGhpcyBhIGJ1ZyAob3IgYSBzdWJv
cHRpbWFsDQpiZWhhdmlvciB0aGF0IHdvcnRoIGZpeGluZyk/IElmIHNvLCB3ZSBhcmUgb3BlbiB0
byBhbnkgc29sdXRpb24gdGhhdCANCndvdWxkIGFsc28gaGVscCBQUkVFTVBUIGFuZC9vciBub24t
eDg2IGFyY2hlcy4gDQoNCkxhc3RseSwgbWF5YmUgYSByZWFsbHkgbmFpdmUgcXVlc3Rpb246IGRv
ZXMgdGhlIGZvbGxvd2luZyBhbHNvIGhlbHBzDQpQUkVFTVBUPXkgY29uZmlndXJhdGlvbnM/DQoN
ClRoYW5rcywNClNvbmcNCg0KZGlmZiAtLWdpdCBjL2tlcm5lbC9zY2hlZC9jb3JlLmMgdy9rZXJu
ZWwvc2NoZWQvY29yZS5jDQppbmRleCBhNzMwMmI3YjY1ZjIuLmNjOWIxYzljMDJiYSAxMDA2NDQN
Ci0tLSBjL2tlcm5lbC9zY2hlZC9jb3JlLmMNCisrKyB3L2tlcm5lbC9zY2hlZC9jb3JlLmMNCkBA
IC01MjI2LDYgKzUyMjYsOSBAQCB2b2lkIF9fc2NoZWQgc2NoZWR1bGVfcHJlZW1wdF9kaXNhYmxl
ZCh2b2lkKQ0KDQogc3RhdGljIHZvaWQgX19zY2hlZCBub3RyYWNlIHByZWVtcHRfc2NoZWR1bGVf
Y29tbW9uKHZvaWQpDQogew0KKyAgICAgICBpZiAodW5saWtlbHkoa2xwX3BhdGNoX3BlbmRpbmco
Y3VycmVudCkpKQ0KKyAgICAgICAgICAgICAgIGtscF90cnlfc3dpdGNoX3Rhc2soY3VycmVudCk7
DQorDQogICAgICAgIGRvIHsNCiAgICAgICAgICAgICAgICAvKg0KICAgICAgICAgICAgICAgICAq
IEJlY2F1c2UgdGhlIGZ1bmN0aW9uIHRyYWNlciBjYW4gdHJhY2UgcHJlZW1wdF9jb3VudF9zdWIo
KQ==
