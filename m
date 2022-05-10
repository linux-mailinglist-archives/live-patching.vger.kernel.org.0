Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D79521992
	for <lists+live-patching@lfdr.de>; Tue, 10 May 2022 15:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244113AbiEJNtl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 09:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244988AbiEJNrK (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 09:47:10 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F9234B9B;
        Tue, 10 May 2022 06:33:16 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24A8aBbK004651;
        Tue, 10 May 2022 06:33:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=rr70kz3tMN+wAvb60Yf9sFkhHeiVvxgSevJopvTTIeY=;
 b=c4uHvKbZljsi2gEkr6ADU8gK+3KO8/l3S8fU6el4Gq60PnL7bOAz67IGynlwI0PMTfI9
 QhfiP9QpXi4R/G4QLTvcYEg2mUVDZrpAORAN1mF/G8bFWVpPAyvIP/vxrcmo6354jJA6
 JB/OjXMoudtUwH6LQleHxlyr8C6KQUY8gAY= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fymp49ff4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 06:33:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ca4dA1FCcx+EOxkw3e4u3/wz7R063d4LquwLaBiZEdAFOzD1c7GC8ef+Ld48j0u8kuASkJP6QvFXHpTCMEAgWS6fsqR2U8HFcI6yDxEJqBfo70XQgBolHdbERIkxRqYpRNNMVWOQhkRzhpQW8sUevdEWavM6PSywqFKW0rLV2LKp0zJqq1+yktCXFTN9Y/p/tZyn+5bfX6H2BEqC5cWiE+VGS3lyHeNdHJTShm4e4YKyNPrNkWGSMo1CUG6XXRLNwR7iizaLAKPMQSzs8PRRXaJLhYfBGpbfrULyOxUyr8yToHPsBGTC6kxHANabO/EAoeCi38Ek3SwhIsvz/PTqPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rr70kz3tMN+wAvb60Yf9sFkhHeiVvxgSevJopvTTIeY=;
 b=Hmqrn9egIJZccJEuvkChTFitYXIdD8xOTIiMZm11c+7px7qkTrpZwzecQ4m+DK+6/L4nxXIFGPaimNCrX6Pii+Turo+C7n7LNTwElPYw0P/s+gOFevKAus0vtdfFh/f6ozbpsk+uiBMSLJeetT+yYm8sq3MbrNXN0lB5oJFgsnic0acbPrUF7pgwjESt2dWhkYSjABCTvbox+c7O0CGbYOz6amcmeOsEFV0hlUXeYe8qgQUWzWhgbUryVLsQWHddkIwa2BM7/judc37H70HDe/+83u+Qm3u4znMbvK8QTEcWJ+g1jce2pH1JdRBWlDJoNEw2De2bufPFU22PG4d5dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO1PR15MB4969.namprd15.prod.outlook.com (2603:10b6:303:e4::23)
 by BN6PR15MB1122.namprd15.prod.outlook.com (2603:10b6:404:eb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 13:33:14 +0000
Received: from CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730]) by CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730%6]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 13:33:13 +0000
From:   Rik van Riel <riel@fb.com>
To:     "pmladek@suse.com" <pmladek@suse.com>,
        Song Liu <songliubraving@fb.com>
CC:     "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "song@kernel.org" <song@kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Thread-Topic: [RFC] sched,livepatch: call klp_try_switch_task in
 __cond_resched
Thread-Index: AQHYYjpsdFy2RMM8vk2xmmtLa5gGmK0WqGoAgAAVAICAAQUigIAAXfwA
Date:   Tue, 10 May 2022 13:33:13 +0000
Message-ID: <3a9bfb4a52b715bd8739d8834409c9549ec7f22f.camel@fb.com>
References: <20220507174628.2086373-1-song@kernel.org>
         <YnkuFrm1YR46OFx/@alley> <9C7DF147-5112-42E7-9F7C-7159EFDFB766@fb.com>
         <YnoawYtoCSvrK7lb@alley>
In-Reply-To: <YnoawYtoCSvrK7lb@alley>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 436fdbe0-4159-4098-ad74-08da3289a216
x-ms-traffictypediagnostic: BN6PR15MB1122:EE_
x-microsoft-antispam-prvs: <BN6PR15MB1122495FE5FE0FD33A48FFFAA3C99@BN6PR15MB1122.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vBv9Mw0bYItJpKCyUEn3+hO13CATnOxkfZD5ABMG9vwHpP7022lqV7xUmUYTV/XTTs413yCRVBqL69w3nhocLlgCkg5FUksusyZggH9E20XCsYOxfg9z/IlUUfr06Vnzv/NrdLM/1MTebZev2HyfI34GHhpyi9qoKI2hWmVpOHruFYtQ0M26b1uTOwZZ5QzlYVruia2wpxUrOhextuFJ3AEv4WCJD+jGbDpsKf3YgbKKKVifgCDxhkrbZo+080DwA+GZUsTWQXrD8/5hdTKfJTcOuB5z000rg+hj5VmH2dG9wOMHtCeHwb3ilIIKj38FVvYp82RlOoxak9XHS/FPaelrBqb/kltLDGJbTcwh5anA6eCmn5Z/+NzSwEkSdvvSdXNg5zeMI7tWjBaosRcKugbghpgoLmdvwx38Naavf0lB5xHPU4qqjzwWx8ptUnDtqMlG/YtOzVaHdknANTWJiH4C6GeN5LCBmmSkSGSSG1wDaBACZtOfqpJqhx4cZhDMNE7r8GeFSdJgoGWqbGe0Zv/Rd34oAFB9rNY6ZRDegFZKvLSIWN6Bn3LWU45TEHueuHcJ40iSp1MsnlS7Tbr9/+4KwWR8OxZdmPg5fo5EMMx6IcFzB3vSmtWwDAqIy6IQMCOJ/XCzPLkw1Xa41EwfG49AVeClY0ShfPfcG/I8RfWnp5QeUdB6EQe+K8dVye2R7f2Zq3CXSjvhsauH13P1QQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB4969.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(66574015)(508600001)(71200400001)(316002)(6486002)(186003)(6506007)(86362001)(2906002)(5660300002)(2616005)(122000001)(36756003)(91956017)(6636002)(66946007)(66556008)(4326008)(66476007)(8676002)(54906003)(76116006)(66446008)(64756008)(38100700002)(38070700005)(8936002)(110136005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZzlVZHpEN2s1NWJHeHV3aFY4bzBuRHBLeUE0RWF0cXdTMzRlN2ErM0FRekpq?=
 =?utf-8?B?cjFyU2RLVGVGQUJtR3RCMk96L3RUa2hZV0FjSzhYaGwzcnpENHJmRnhhek9C?=
 =?utf-8?B?UURTL1ZaTlNUZTdjaS9oYmI4UGtRbjhCc2hTdjBnWm9xZVd3N0Zmc3U5VU95?=
 =?utf-8?B?NFVFcEJKbkFBVTZUdDkyM1ZSWG1rVmZmUDl3bXZTMWMxQlNJTXZ3YThubkxx?=
 =?utf-8?B?dWhnTGphZDJmOE1FdU1MTlRGU01JVHkvcTFOcTdYNTdRcDF6S3E5K1N6TTJ3?=
 =?utf-8?B?SVZzNityRElORnlyS0I3SnI4NUpwa0JrTGUzZnpkKys1b3daSm1mdGN1ME9F?=
 =?utf-8?B?b3d3Z2VwVjFIS2xETXJ0dks4S2IwTFZ3RlN6WnA5NGF5WExjTkpjUnA5NjRG?=
 =?utf-8?B?NlNTTGFNMGtqS25DMTFGUHpEQzJ3NjVxeituSVpYU3hEeHg2UiszclJOMEg4?=
 =?utf-8?B?eXY4dHp3OTRRbEQ3S3BxZ09odzZxL2pWSjE1WCtCTURiaWtKeHZXU3FzTGpp?=
 =?utf-8?B?cC9MWDVhU1k1dEllZUxkcXZkVHo5Znd2Q2FPRlBwR0xjZHhSRVR2QWdteVcw?=
 =?utf-8?B?UTV6YlJCSmNBUGJGMklBZVRBQnNtZUlxbHhFTjVwSWp3bmJId3lqbDFjS00r?=
 =?utf-8?B?U0N1ampvd1FOU1poSnU2cm1JdmtJZU9XSmhvRGM0TFJPazRhbHlwazdCbnBR?=
 =?utf-8?B?TVhWZkZVbG5UQUdPd3V2Q1NGQWlESnlBNjZkbGR4OFdmRzBLSk5KektDN3gv?=
 =?utf-8?B?WVIrZUVZdDdCczV2bzllbVluZVdXc0J4T3dtcGlNMDNIVHdiaHRvQWsvUUZl?=
 =?utf-8?B?N0dhZUtKR3IrU3crSEJxU0gvWDNLU296bG9sKy9BU1M0a0ppZ1BkaHN3YXNv?=
 =?utf-8?B?dS9janBtZlo3VkRQRi9KRXhtUWQvTEFIL2Ryd3pKa1lnWVNLclNybEJHTEFY?=
 =?utf-8?B?UmE1UTlIdVdUSFkyZXZ1a3lTUXVFMW0yd1cwSkY4VkRSSzBqbVZIby9kUXRq?=
 =?utf-8?B?eExkajBJbzRmVHhiRVcvSXBJYmtKbm4rcDI0dnhTK2VyK2FvKytSOUNjOFhI?=
 =?utf-8?B?anViN3hERlBUVFdsVURydkJTMy9yWHR2alpWSGRqVFBVK0R0dEdlM2J3N25G?=
 =?utf-8?B?ZkFWVzFtSWVvdzU3RU1FNm5qK3dja3BzUGhPanpTQURud3JYZEd1ZkpqY2Y5?=
 =?utf-8?B?WVpXZ0lwVldSTEF6VjVaYVVDc0l0YmovOWpObFdqSXUrVGNlcGs1ZTRlaFlU?=
 =?utf-8?B?OUFJOVZLc1ZCaHZ5T3NqenZjaHU4b2E4NnNrbWpLQ0pyQXF4aTZodW9mbzdD?=
 =?utf-8?B?TFRqNlNXdXh3dTQvd1ZZTENDSjFEVDVyR1ZqVGo5Z2xMaFlGMGhmNC91VUVI?=
 =?utf-8?B?Vnd0NkpMWFY2MHRWdk9SZmxBVCs0Z3liTmlKUEdMYzQ0ODM2aGkveXBsVUtM?=
 =?utf-8?B?RkFQSWJvdys4akJES2Z2ZEhudk5GeitheFhoeURxelZLdGNTR2d6NkR2SDJB?=
 =?utf-8?B?ZEp3RGVEQmEzZDdVSEM1ODNRY05iT3BsRURaV1lOTlgwZGJmeW9vZG9RVEpq?=
 =?utf-8?B?M0NBZ3lVaUtYRSs5Q3hqZDBDN3J2RytkSzl3Mko4anBrTEprMU1KOVdNazcv?=
 =?utf-8?B?OFdNYnhmczdNdmRCY0RqWkpyeTgrLzJkSHZaVGdkMzBENWxjeFYyWVFTeFFt?=
 =?utf-8?B?S3dHU1lxMjBrQ055blNwQS9seW1MUTBlanJXYmE5RnRMMHFnWWM3ZlRXbXMy?=
 =?utf-8?B?aWJXSnIxOFEzM0Q3ZjkwZjE1VzFRcE9uTlZRR0RhN2tSWmVvRHlmdmdyMVhu?=
 =?utf-8?B?U0FrSzVuYVdseWZnaEVickh4WUptdk9OMS9RZ1V2TjBJUjNwRTREYndPQUVW?=
 =?utf-8?B?N2pGc3JTQjFHQm1jZ05IWURKZjJmYUl0VnJYWXlSaVRXU0NqVEFuQkk5aXVN?=
 =?utf-8?B?Q0NiZjNWMkd2cyt0WWpqY2dGeWdNeW9YcWF1dytENHY3QmRHWXMzZXhqa0Ez?=
 =?utf-8?B?d2J6aTgxSXNPRU52a1NaOVJFdWpJQjJWcklmNUI1K3JpZjRheEljLzA3S2xX?=
 =?utf-8?B?eGIvQUpGOERlZnd5d0xUbVdENGg2ODdBVHJLcjZRSmtMR04yWGE0Q25Td3Z2?=
 =?utf-8?B?b05YcmgydlhobGhYQmpzbWp4MVpOUHMxdFhValhZa3h0NFVFRDU2TmVib3Nz?=
 =?utf-8?B?QkdPR2ZJMGh5eGsyOTNod3EzTmFqcFU3YXJRTDhoQUpPQlhTODU0Ym92d2hk?=
 =?utf-8?B?UWtkM2RmbG9WZDc0UzhyaUQzK2FQeTFCeDViY0Z1RU14QjVsZjQwQ2R4ZUY0?=
 =?utf-8?B?MS8rcUczaEphQ3VsL3hQd3hGczNoTk1vc0hnekhteDFPSEtlOVpNUXBpQk9G?=
 =?utf-8?Q?43+YO/nc2uQyp610=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D3FBE51C9B94C4FB1E92CEED7309250@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB4969.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 436fdbe0-4159-4098-ad74-08da3289a216
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 13:33:13.7181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: e7+YvnZ5/xtQahmjOHGnzVhc+aExMbZcC/AL0CWcdhPbdcowqhM99Ep32vp3sDGA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR15MB1122
X-Proofpoint-GUID: Zq0cosvVC5NkLIkrcjNLBd5OIQOloLcU
X-Proofpoint-ORIG-GUID: Zq0cosvVC5NkLIkrcjNLBd5OIQOloLcU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_01,2022-05-10_01,2022-02-23_01
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

T24gVHVlLCAyMDIyLTA1LTEwIGF0IDA5OjU2ICswMjAwLCBQZXRyIE1sYWRlayB3cm90ZToNCj4g
DQo+IElNSE8sIHRoZSBwcm9ibGVtIGlzIHRoYXQga2xwX3RyYW5zaXRpb25fd29ya19mbigpIHRy
aWVzIHRoZQ0KPiB0cmFuc2l0aW9uICJvbmx5IiBvbmNlIHBlciBzZWNvbmQsIHNlZQ0KPiANCj4g
dm9pZCBrbHBfdHJ5X2NvbXBsZXRlX3RyYW5zaXRpb24odm9pZCkNCj4gew0KPiBbLi4uXQ0KPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHNjaGVkdWxlX2RlbGF5ZWRfd29yaygma2xw
X3RyYW5zaXRpb25fd29yaywNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcm91bmRfamlmZmllc19yZWxh
dGl2ZShIWikpOw0KPiBbLi4uXQ0KPiB9DQo+IA0KPiBJdCBtZWFucyB0aGF0IHRoZXJlIGFyZSAi
b25seSIgNjAgYXR0ZW1wdHMgdG8gbWlncmF0ZSB0aGUgYnVzeQ0KPiBwcm9jZXNzLg0KPiBJdCBm
YWlscyB3aGVuIHRoZSBwcm9jZXNzIGlzIGluIHRoZSBydW5uaW5nIHN0YXRlIG9yIHNsZWVwaW5n
IGluIGENCj4gbGl2ZXBhdGNoZWQgZnVuY3Rpb24uIFRoZXJlIGlzIGEgX25vbi16ZXJvXyBjaGFu
Y2Ugb2YgYSBiYWQgbHVjay4NCj4gDQoNCldlIGFyZSBkZWZpbml0ZWx5IGhpdHRpbmcgdGhhdCBu
b24temVybyBjaGFuY2UgOikNCg0KPiBBbnl3YXksIHRoZSBsaW1pdCA2MHMgbG9va3MgbGlrZSBh
IGJhZCBpZGVhIHRvIG1lLiBJdCBpcyB0b28gbG93Lg0KDQpUaGF0IGhhcyBpdHMgb3duIGlzc3Vl
cywgdGhvdWdoLiBTeXN0ZW0gbWFuYWdlbWVudCBzb2Z0d2FyZQ0KdHJhY2tzIHdoZXRoZXIga3Bh
dGNoIHN1Y2NlZWRzLCBhbmQgYSBydW4gb2YgdGhlIHN5c3RlbQ0KbWFuYWdlbWVudCBzb2Z0d2Fy
ZSB3aWxsIG5vdCBjb21wbGV0ZSB1bnRpbCBhbGwgb2YgdGhlIGNvbW1hbmRzDQppdCBoYXMgcnVu
IGhhdmUgY29tcGxldGVkLg0KDQpPbmUgcmVhc29uIGZvciB0aGlzIGlzIHRoYXQgYWxsb3dpbmcg
c3lzdGVtIG1hbmFnZW1lbnQgc29mdHdhcmUNCnRvIGp1c3QgZm9yayBtb3JlIGFuZCBtb3JlIHRo
aW5ncyB0aGF0IG1pZ2h0IHBvdGVudGlhbGx5IGdldA0Kc3R1Y2sgaXMgdGhhdCB5b3UgbmV2ZXIg
d2FudCB5b3VyIHN5c3RlbSBtYW5hZ2VtZW50IHNvZnR3YXJlDQp0byBjb21lIGV2ZW4gY2xvc2Ug
dG8gcmVzZW1ibGluZyBhIGZvcmsgYm9tYiA6KQ0KDQpSb2xsb3V0IG9mIHRoZSBuZXh0IGNvbmZp
ZyBjaGFuZ2UgdG8gYSBzeXN0ZW0gc2hvdWxkIG5vdCBiZQ0KYmxvY2tlZCBvbiBLTFAgY29tcGxl
dGlvbi4NCg0KSSB0aGluayB0aGUgYmVzdCBhcHByb2FjaCBmb3IgdXMgbWlnaHQgYmUgdG8ganVz
dCB0cmFjayB3aGF0DQppcyBjYXVzaW5nIHRoZSB0cmFuc2l0aW9uIGZhaWx1cmVzLCBhbmQgc2Vu
ZCBpbiB0cml2aWFsIHBhdGNoZXMNCnRvIG1ha2UgdGhlIG91dGVyIGxvb3AgaW4gc3VjaCBrZXJu
ZWwgdGhyZWFkcyBkbyB0aGUgc2FtZSBLTFANCnRyYW5zaXRpb24gdGhlIGlkbGUgdGFzayBhbHJl
YWR5IGRvZXMuDQo=
