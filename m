Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB2F522882
	for <lists+live-patching@lfdr.de>; Wed, 11 May 2022 02:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237675AbiEKAfQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 20:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiEKAfO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 20:35:14 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F62E27BC6A;
        Tue, 10 May 2022 17:35:14 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ANMEFK020852;
        Tue, 10 May 2022 17:35:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=g5co3r8q+2XWGfbHrHMeDn3LnUS0V+oSOQLowBRMp7A=;
 b=lst8W/iGRN9LBUL7/yQYlfirGFsO0eFFGl0W+Ils3FZpXoWC+l3YQeT36FjQZPlCl8E/
 Ms3ZouJeI/9tHeD5E5ptqcB1aphe4w0yvHfNHcPWw3SqX32i6ORuAXuUqhSHrTNZm1qq
 GTIME54Skw0sSBS3TpbhHl1hxFBoj6iJ3GI= 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fymp4e477-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 17:35:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MWhiWev1ObW2/jR/SSQ/OTLUKZeLRo8ZqfLJUxoAwFG1WGzaDy9dyyqgOhNh1KMWaK/0sMwnX84M3yISGBA8CMwwzhlwOHygh4cQq2F5rqf+bKXKoktpIQCwxEyrNbj5TelRv76DDzR+vYXJxNQl/qlhQdZcaQ26Ka6uyFRlVU4xpbIlTvCC0bg6xTFpy/54Bfwi0WQ1ckBfe1skCKMNEV2lYmdqmAlwCFqbm/y6kVa6t0+8PZf5jSyiEVwT9z0dYDc6LO4WBrJdHeRt7cap/jZKCRtY1cYjv8Ifb+2VuR63qs8Wc9h46Nd5hMnwkbAeSFc2JZRnglm1nrxr4XG5bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g5co3r8q+2XWGfbHrHMeDn3LnUS0V+oSOQLowBRMp7A=;
 b=F/QFXvrUmwjj+PPB8M32slpLBNwvhs4F1Yiy8saIkdWuF/JLSapMQrhgcWA/GurZB/d5QYPaxvDNQUPeoVJt8AWeedH4pcBVaBDNX8vTMGkmELbOyxqRPl7th7QD6zgqUFuoDiqJZvMwLNsxbBaVwO/OCdzV1arOoVPLUJL6m38jiUN79C+GZCUGe6Pk5JJOKAv9ijRO8EVaimb2ab89jAaiiCU0wPn9XDQXv79m2SbfPSlcydfEpIARnr4P0bXYD3pM6rE/h7oaILVc396Kd69E2DWXzWdQJc5/xub+fGEVEbceHoSioc/OnMuKXMmZERcQAxOCijw/HHAj/Gsirg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO1PR15MB4969.namprd15.prod.outlook.com (2603:10b6:303:e4::23)
 by BN7PR15MB2274.namprd15.prod.outlook.com (2603:10b6:406:8e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Wed, 11 May
 2022 00:35:11 +0000
Received: from CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730]) by CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730%6]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 00:35:11 +0000
From:   Rik van Riel <riel@fb.com>
To:     Song Liu <songliubraving@fb.com>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>
CC:     "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Thread-Topic: [RFC] sched,livepatch: call klp_try_switch_task in
 __cond_resched
Thread-Index: AQHYYjpsdFy2RMM8vk2xmmtLa5gGmK0WqGoAgAAVAICAAQUigIAAXfwAgAAkyICAAAZgAIAADJgAgAAUwACAAAnWgIAAEcWAgAA3YgCAAA7RAIAACqUA
Date:   Wed, 11 May 2022 00:35:11 +0000
Message-ID: <6c36c09fbf426280d13f6025f41aed4c65c042d6.camel@fb.com>
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
         <D298A3F1-43A5-4FD5-B198-906364BF4B79@fb.com>
In-Reply-To: <D298A3F1-43A5-4FD5-B198-906364BF4B79@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 30c6809a-a208-4497-a6dd-08da32e61b82
x-ms-traffictypediagnostic: BN7PR15MB2274:EE_
x-microsoft-antispam-prvs: <BN7PR15MB2274DB84433735704E9BBFA2A3C89@BN7PR15MB2274.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fQ2wPTVJfFpD7QyC8i6/uxLjpsG8SQ9VEgjWWrZXs4gZ0mCt4I21FfN7qwBgaTg1G+hjvHWRsnoCGdSmOmKZK/Pa3QBJuBC3il84DkRTk2pr5u4ZmN9QV4K8zcTLHaFMLg9vcNpr4EA5w0ye3x/3bRUjpztf9pEj9F4fNBbCFf95xVvdbcVkT1qL4sI5ZsDQVjsJ8lYCnHjcPeJmboGkDXxqSAygGvbyattgqeumb2OzC1Y1WWs0vkD/ZTW+9t3QSEIGNPQO0LMNrpnG0dL7/WJPEnDicGQXopXv9yyiKW3BPtFeL2A/0lcaqjntDWvlZGU+terc0KApiE0AuyYU3iNjXg3YQugGU9ZibWAWWS12myBb23J9eTofZ+T4SB3LfKHb+bP7oChCWLaKqJZdeY395V4F2g3hTwXCw6tKR0l3Zwn4ov5KBa3zfjjnHXghvsZJT6YgrwrTsIaRXDGPd0oCDfCIBPxWWGCA59C4UYknLIVtdsb958Ah39cx6Kv0abZaBDpb5Ccq1/MzJnngHPzoZptU2f+0t9CRyUPkGUT8ATLOuslDARk6A00tuC5axEcc2pFJNZzZBOyG6vCq4GEeuBZuo7e+xKTw9uhlQFy7WAeXan6sijcGJp9ePs+X2xWBSzPu/l2OafgXr5yu+LFoR7XG9iX38AiyVvmx1BSpab6u0SpXMVwYJxrDTlhHJkv0P5afanSgLDCxSQwZRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB4969.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(38070700005)(122000001)(8676002)(4326008)(66446008)(64756008)(5660300002)(66476007)(316002)(66556008)(66946007)(76116006)(2906002)(8936002)(4744005)(7416002)(6512007)(6506007)(186003)(2616005)(6486002)(110136005)(54906003)(71200400001)(508600001)(36756003)(91956017)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUhRZkNIVTVWTHJtWHdUdFo0M2dPYTRaQnRMU0xaSGIyWm9Kckk4YWNURWVC?=
 =?utf-8?B?RkI2WUVkNDg4UkxWbnVPUStLcitwL2FFOEJ4Um9TTlhzUzN3SEc3Yk5xdVB4?=
 =?utf-8?B?K2F6cHdwQ3VwR1NzZ0hVOEJBZnJZS011Y0FRSTdnaDFOelBPRDIyT1d6bjVt?=
 =?utf-8?B?bWxZNWlncGNCenVRT2lGTzZNOWt5Uk94Yk5DeDdJbnBVQldvRGxqLy82eWVM?=
 =?utf-8?B?ZnlDdlVtYXZUUDYxcjUwWDQzeU5rQUlHUzBLRzJya1RienlQV2diNUhvZmVz?=
 =?utf-8?B?WFljWkFvVUhFenVrcnJJRU9ZZGxZU3hHMVI3RlVqaVJRZVJ3MGMvQlpWaDZZ?=
 =?utf-8?B?ZVZLQTRBZythdHZ3ejdxNUYwSmFHbHZzNVBzSEJ2T3BaQmk0VDdkcUREVWN4?=
 =?utf-8?B?WSt2Umx5cHk5RXNWQm5ualRtaTBFZUJ6aHhSRk10dDVMMnRqakQ1UTdrKy8y?=
 =?utf-8?B?RlFiNGQwM1Q4RkdLUXNDOHRUSnBmMzNTZ2F4UzBNQnVXaloyVU1XNnpyM3Zj?=
 =?utf-8?B?STBYM0ZKWVNyQ2VtNlZaaTk2VllpL25NZDdjWWdOZGN2czN0Wk5MQmRPNk5E?=
 =?utf-8?B?dnNPOUJHb3BkWFNYN2hKUEhROHBMYngzZmU2MFJyQjlIeGRFS09xekxhN3pX?=
 =?utf-8?B?dHJsUEJTelZRTjNGb1NhVHp0SmhNSnBWTjM3aExSTlhZZm85bnh6NWpEWlNH?=
 =?utf-8?B?NytGd0FZY0JyNmIyNGhOVXR0QyttYkJKRnZrdjRsaWJFRGlGV3hJbHN1Q082?=
 =?utf-8?B?MVNmY285cEJqR3dvRC9QeXlYZHk5aFVqYVpNdk83Y05LbWxVY3dnaTd3STM3?=
 =?utf-8?B?UG5UT1hYbk55SGl3MWlNQ2ttRUU3R3l3U29xQ3ZuMnFFVDZzd3dpWnZPZGZ3?=
 =?utf-8?B?eFJ3K0grOEVvK3Myem1jMWFnWTMyemZDM3ozZmdPbkJTbnJKTnljdUJDaGc4?=
 =?utf-8?B?VlM2dWFNbXoydjVvOGdzOEZCYUwrMUo0NTUzY09jWmk0TjJrdFJ3R0paN3VL?=
 =?utf-8?B?aVZZblQ0STlmSGUvSEJhdGhsZVEzbjUrR0FhYjc3eU52OTMrOXBwbDVyQzBR?=
 =?utf-8?B?MnhyR3lpNTNnd1J4SzhxbmhLUUQxU1FmZ2JVRVhPbkR1WWpDVTJDT2dMdEU5?=
 =?utf-8?B?RjVNdVVuQXpSZEsxVU5wanZxbkxZNkpNSjIzNGpCS3Q5NFVHYU8vS2hnV0Na?=
 =?utf-8?B?MHcyeW5jYU9RTzRpQ0xPQmI4VmYvaW5ybGdqV2NQaTJGUFc2VE9GNWRzWmNS?=
 =?utf-8?B?cngxcTEwS0ZoZlBKKzZQZ1FxN1A5RjVZdmcreEFEV2VlZE53R3M0OGYzM0Q0?=
 =?utf-8?B?djNQZEg4NjJpUWJXZUYveEFnZDBwejVYa0xucGZFakRpWW9YRC80bDd4OTNH?=
 =?utf-8?B?bElVZ2g2WDQybWpyVWpOZm05WmF5ZTZDT2k4aVlzR1BiTW5Ta3pZWmV1Q203?=
 =?utf-8?B?VVA0NkF1emZGRU5QaDk0M1BlT1Q0VmNndEZXaTR2R0ozMEJOYjdtMTVnVU5M?=
 =?utf-8?B?SHlIRHNyZVN2b29SdTh3Nndic2JlS2I4T2txUDNxdHd4OXdBOGVFSHRhU05u?=
 =?utf-8?B?S1UwTk9GQmJYaVI1T2gvazhYdVllZmE5RGtTQlRqTTh2bjNvaENtempxSEZS?=
 =?utf-8?B?cHdkZVJLd0tTdzFTV01XeWp3UXJvWjJQc2dvWUxRVEozTktuc0drSVpPOWIv?=
 =?utf-8?B?ZjJLUkJDM1A1c0YrTmpKeHpkcHYzVTB6ZjRBSnFaVjc4MjJlMmlCM01MZ05Q?=
 =?utf-8?B?L284MzdhYVYxcnFyNjhOR2l4Y0JRY2RDeU5POXZmSndLUXEyWmZyMDhQWWMz?=
 =?utf-8?B?Q3l0UXBNdThSbHNWMmxaWHJpdDVBRFFVOHBNVGUzMlVqNWliU3MyMDJnMUp4?=
 =?utf-8?B?TDViMEU1UU8wbXRnSmVqUFprMC9wMFluRS85MVYrdmVnTmRialo5bFlZVDEv?=
 =?utf-8?B?clhRUjIvd2M2R2FYVEJNZ3NPRW1iWGp0aEs2U1FLT0ZnSkk2aEhRbmJuVG5E?=
 =?utf-8?B?WGFwclJ0TEVoMzBMVEZaakNFU1ovMmJzZTR5ZWZZN2Rrdjh1bnNjcnVoYkxS?=
 =?utf-8?B?TS9IT2xORWVMR3RiQWFBM3EyTkhMdWZobTRiSHNSS01ycDFDTVNsSG45MVpl?=
 =?utf-8?B?NlFqQ29pUDM0VmNSeCs0NXNnNnNjSWlReE9PcUs1MEdqaVQ3THJtVXZwTmc1?=
 =?utf-8?B?RUI5ejhYK3VzWE10c3dPR1VvZUowTW9XeENrOCtiK3U4NUk4U2xsdHpOUWd4?=
 =?utf-8?B?QUdCbkRrQ0NSMmRhSE5RMXBSTHZTeDdrWHRKU1NlVUNXRVFNTnRxelExeXdH?=
 =?utf-8?B?a0xGS0N5QUhGNUxxVjU4SkFJbnNLa29BSzZBbXk2SVN2aDVSbVQ5djJRc2VZ?=
 =?utf-8?Q?KHSHprofrfx99Bxs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4483FD481DE0E8418CC9F6E51122485F@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB4969.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c6809a-a208-4497-a6dd-08da32e61b82
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 00:35:11.1604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gr/JCPPAMXWX8D6k32RDLV+njtwVpYKEyWvY9KgrESvynM2U8QOV3jJROjZc5lDf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR15MB2274
X-Proofpoint-GUID: 90rryDgjSeRUFSDuCvTG1zl9a5xgjYnr
X-Proofpoint-ORIG-GUID: 90rryDgjSeRUFSDuCvTG1zl9a5xgjYnr
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

T24gVHVlLCAyMDIyLTA1LTEwIGF0IDIzOjU3ICswMDAwLCBTb25nIExpdSB3cm90ZToNCj4gDQo+
IFNvLCBpZiB3ZSBjb21lIGJhY2sgdG8gdGhlIHNhbWUgcXVlc3Rpb246IGlzIHRoaXMgYSBidWcg
KG9yIGENCj4gc3Vib3B0aW1hbA0KPiBiZWhhdmlvciB0aGF0IHdvcnRoIGZpeGluZyk/IElmIHNv
LCB3ZSBhcmUgb3BlbiB0byBhbnkgc29sdXRpb24gdGhhdCANCj4gd291bGQgYWxzbyBoZWxwIFBS
RUVNUFQgYW5kL29yIG5vbi14ODYgYXJjaGVzLiANCj4gDQpVc2luZyB0aGUgcHJlZW1wdCBub3Rp
ZmllcnMgZHVyaW5nIEtMUCB0cmFuc2l0aW9uIHNob3VsZA0Kd29yayBlcXVhbGx5IHdlbGwgZm9y
IFBSRUVNUFQgYW5kICFQUkVFTVBULiBJdCBhbHNvIGRvZXMNCm5vdCBpbnNlcnQgYW55IGFkZGl0
aW9uYWwgY29kZSBpbnRvIHRoZSBzY2hlZHVsZXIgd2hpbGUNCnRoZXJlIGlzIG5vIEtMUCB0cmFu
c2l0aW9uIGdvaW5nIG9uLg0KDQo+IExhc3RseSwgbWF5YmUgYSByZWFsbHkgbmFpdmUgcXVlc3Rp
b246IGRvZXMgdGhlIGZvbGxvd2luZyBhbHNvIGhlbHBzDQo+IFBSRUVNUFQ9eSBjb25maWd1cmF0
aW9ucz8NCj4gDQoNCj4gwqBzdGF0aWMgdm9pZCBfX3NjaGVkIG5vdHJhY2UgcHJlZW1wdF9zY2hl
ZHVsZV9jb21tb24odm9pZCkNCj4gwqB7DQo+ICvCoMKgwqDCoMKgwqAgaWYgKHVubGlrZWx5KGts
cF9wYXRjaF9wZW5kaW5nKGN1cnJlbnQpKSkNCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAga2xwX3RyeV9zd2l0Y2hfdGFzayhjdXJyZW50KTsNCj4gKw0KPiDCoMKgwqDCoMKgwqDCoCBk
byB7DQo+IA0KDQpXaGlsZSB0aGlzIHdvdWxkIGFsbW9zdCBjZXJ0YWlubHkgc3BlZWQgdXAgS0xQ
DQp0cmFuc2l0aW9ucywgaXQgd291bGQgYWxzbyBzbG93IGRvd24gc2NoZWR1bGUNCmFsbCB0aGUg
dGltZSwgZXZlbiB3aGlsZSB0aGVyZSBpcyBubyBLTFAgdHJhbnNpdGlvbg0KZ29pbmcgb24uDQoN
ClRoYXQgZG9lcyBub3Qgc2VlbSBsaWtlIGEgd29ydGh3aGlsZSB0cmFkZW9mZi4NCg0K
