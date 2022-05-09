Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE71520242
	for <lists+live-patching@lfdr.de>; Mon,  9 May 2022 18:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238946AbiEIQ0Q (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 May 2022 12:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239022AbiEIQ0L (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 May 2022 12:26:11 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FDA14085C;
        Mon,  9 May 2022 09:22:15 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249Ek2sD030113;
        Mon, 9 May 2022 09:22:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=HcK0jWzI1hBt96GMpUxbvOVx7YBAGdE7VScCiujEyCA=;
 b=e6I8VIZvtmvBBaRvkWYXfQbauM99qmkYfHZxGZOHTRH5bJUdjEBOc2r8oZcZwi1a9R0k
 dfbX12SovRve0DTmJm/Hi3XsZPkXR+htxuFb0aT1fnBTjllg7apHxsz6DGfD+WCb9aLn
 ee4Euvjq+20n3ndQXkiBcOtr83rK16e16EE= 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fwp9xskge-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 09:22:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ynhvd1bLPB+ziF6KsTuw6YV12g43NUV1Pe+98JGZ9Gt3ZRkdN1OjYBE1fGuV0d6nF+jg9DGnodGSDWVhPo0DoaAuOCzovNTloZ5zqT3b39NcegNwR2wiCVeHUs2mvOdBNRlgN9nd7SEavm09FYTOSFd3/hPB8uKvVH813aw4Eyj/MCPpoeLJyibU0ERfs8HO/7gvUHY8BtwxL5aSuQJj0lR44BvJfz41Tj9POa3YrLV1Mr/fykAa6fpIhPXwgkARY8AsEIipN8dFQT8jkor5KGwtNI6HjvzmPn85H5SJhP5D+PpKq7yB/Og9Xvtz5YJ00oBsRYBxNUEX1dWfW366Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HcK0jWzI1hBt96GMpUxbvOVx7YBAGdE7VScCiujEyCA=;
 b=d7We3IhJlmoTEmOde2vGfB1joeTSF0mkudm+rQg++7apKlBAgUNZ10GR37xwtGGmr/GpHuJ9OdfCqyw9CuPCE84rRKVef+q1Ohzsk7fhZC/24NLQgOVftUzyD0Zwq6k4E6cuAOLHD/GLJym1bwcJ7wNu8bhH3iXRaVCfMf3VmvON9NmRpyXpAjUmC3saWJoTR9i0NoCg6zDjQ8czbMRuAfCRaBy76fv8bnOGaqFLSJg20p4FT4QwoksAuO7yr00iHTnXKwxJTzzoTc705MSxBDl2o+ZcDGJeZLZor1H3Z3OJXlUKGVeEpv/87faPsgaoGj0zFBpDPFuZNvTiCxgPzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by BN8PR15MB3233.namprd15.prod.outlook.com (2603:10b6:408:74::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 16:22:11 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::3061:40ff:2ad:33aa%4]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 16:22:11 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Petr Mladek <pmladek@suse.com>
CC:     Song Liu <song@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Thread-Topic: [RFC] sched,livepatch: call klp_try_switch_task in
 __cond_resched
Thread-Index: AQHYYjpsu2JIKZQIXUOp7t0Qujiczq0WqGoAgAAU/gA=
Date:   Mon, 9 May 2022 16:22:11 +0000
Message-ID: <9C7DF147-5112-42E7-9F7C-7159EFDFB766@fb.com>
References: <20220507174628.2086373-1-song@kernel.org>
 <YnkuFrm1YR46OFx/@alley>
In-Reply-To: <YnkuFrm1YR46OFx/@alley>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3607977d-92c2-4013-0f43-08da31d81203
x-ms-traffictypediagnostic: BN8PR15MB3233:EE_
x-microsoft-antispam-prvs: <BN8PR15MB32338347BA74E19C0E823FD7B3C69@BN8PR15MB3233.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pk6Iq6WlkPV8a7hYl+tEbteAewf/RGFNV8k2ByDyBdUKf34u3PGT1gQ9l58/HxKHeKp/y1IHLkEKjMog5N6JrUyaACrwmG5WXLSlaReGuu79+g7VHDOtddnDksQBSG/ULyCvfhiPPYKZG1/1uQG4jmK7xYwgMy4oJYY9Ey7C8DNdVrkchNUV1faYHK6oz3oMEoaEEdDbjj6sdD3Lr+LRpW4dPQIKAX3UCfNE53zI+tQGVv6HweUG3+nrMGOoe2by5orocWrEOR5ZLyn8csGNqjz243cWnV4D40DQ2tzexCaldEhJEG2Oz1gp3nWCTHjkoErT2Siq+8c6hBvDoNZYXSo624yLdJuVxCALW7GPDHH2QGUrt+Nx/umTS87AlZs9/ZnAjzSPHf3pB+Sf7fx6DYTEHfuoANIEIjG8M2FcKLIloKu+A+TkxOT1/dzXeYuTeRbYY/CCZdthe193kkoShlCjD9xqcb+CdraI17sb69Z9qNoL9SBg1ZziEgXOtHqktGI7ukkWG9izYLHJXiAkIxEHYvGooUXwGjXLIyMOuF58hZJaVO6Dtz0zSJtSBBd7lOTVLy1rPmLh7kCjuciDaUcrbOx2k2arZJiN/UHE3Ot3IU98mc9VDIPihn++G85WyT248MSFdlDn4Z0BzD+mhjLmNaP2A+V/tQd+XS8lUyxXJEXpSOX/5lb0f1B6AejK6Rf06HVkLW7J3QWGILcns+aHblIGUvFdRp0s6X+Uvww=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6916009)(38070700005)(316002)(508600001)(5660300002)(38100700002)(33656002)(66556008)(66446008)(76116006)(66476007)(91956017)(64756008)(54906003)(186003)(36756003)(66946007)(6512007)(86362001)(2616005)(8676002)(4326008)(71200400001)(2906002)(122000001)(83380400001)(6486002)(6506007)(53546011)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2hNWVk2L3d3MW9henRHbnhreWF0UXVRdjNJSVZyYnRnRjRyaE03c3JDeHRl?=
 =?utf-8?B?bHhhTnRiRHBKUG0zc091Ry91U3NsbDh1UDUxVXVSQ0hTMzdHeUN4QXd6TVNn?=
 =?utf-8?B?MkFiUGdnekZnc083SHlnWXp3alFncTdsU1FjNDAxaHV1S0VLM25uVDRycFBt?=
 =?utf-8?B?YjltZlQ0V1hkYkV2VFpIU1RNK3UvN3VWVzUwYXhFWGNneEtIN1VwSmdwTm9G?=
 =?utf-8?B?dmNOMWRINXFpUWdRczN1SmhpY0x3cTg3eXp5K1dkZllKOWtDQ3BYaCtyRkxm?=
 =?utf-8?B?Qy84TVFHaE5EVlQrUEJkdUZnbnY3ZzhvRUNHT0dNRnVXbXZkS0ZrZjc3d0xh?=
 =?utf-8?B?RnRaZU5nUTZjeGY2ZjJKcC9IaEk0U1JzT0Jkb3YyRzhabmlFdU9uMThUTktB?=
 =?utf-8?B?eE5EaEVCc0JGYXdvVnh0am4vVG1NQjFTWE9Bcmc2eTFhNTFqZFA5dGNQYW1L?=
 =?utf-8?B?UGF5TzBlOGg4L2JTNktUVzlWYUFZdUpZRTBVSFM2bml1UlYveVpJa2xDcUdu?=
 =?utf-8?B?Uldnc0Y4TTN0cXd1UWpKbkFtV1NQcTkrZWRuNEpUSEppQ1BGV1cxRUsvSTA2?=
 =?utf-8?B?K3ZNUkRPWFBhTWlJZ1M5VGp3ZC8xQ2ZkZGlDcjNhY2RsTFB6d04rRkVxM0NK?=
 =?utf-8?B?THFyc3B1Z0pDY0Z0RDBCK2ZwdkZZcUJSdFNVWkdlV0NXWlVuOEdaczdzSE5B?=
 =?utf-8?B?bVZ0M1A2dDg4S0ZySmFzbDdQdHJsb053aU9mWE0vNVpFYkY3aG45Z3pjQWtp?=
 =?utf-8?B?UTBpWEJUZHhteDhjSFo3UmFQdEhOSHRselpkU2ZRVWhxYXQ0VW1NMDJaK1JQ?=
 =?utf-8?B?azhFZmpRV21PeEp4Vk1RRWUzSzZ1Rk4vSzNqYjIwQVZCazdONm5VbVRZL0lF?=
 =?utf-8?B?SlFnbGdvVHVrbVZla3RQdzdNVXNpMmMvRDJXRyt5UWtrN3VoUjE1M2FGVFg2?=
 =?utf-8?B?Q0ZxNi9JQWJ2NmtieXF4ZE9UQnZxZ2ZxazdvenQ0SUk5bFFJWHBtSHh0M09a?=
 =?utf-8?B?WldUNTAxMklFOWtrcDFxVStlaUdsbXM4czJxaUV6REtuV3VvUmN5SmI4YUV6?=
 =?utf-8?B?dThtcktNYlVPLzNpbzJudUlRY3ZxeXpoQVQ4TzNRVTdpK1FmZTFXcU9Lbkl0?=
 =?utf-8?B?NFNrYjlDaEFmMW54ZVpnNmZ4a2RINURaQTN4SmV0MEFpTWVVQ3VEUkNXYTZr?=
 =?utf-8?B?RlUrenB0Wm5abG5qRjNmUFVacVB2SVo4RFA2UGhYdlZhOFh6M0hxVlhJaWR3?=
 =?utf-8?B?dDB0aHgvczBtWTVnc2hXT0ZBNS9sYmduZGxmdmdyN2xPMDVEbXdxMzB2Q2pO?=
 =?utf-8?B?aTFrNzJwWnlxYUFmejhLZnZ1RVRhM2phZW51N0dyYUZ0S1hNUnd6UitqdmFn?=
 =?utf-8?B?YklySVo3Ti9vbm5tdGZiN1d6SmxJYWRnbk5HaTRzWTF0cnZrRmlRTmZwMFVT?=
 =?utf-8?B?N2NYUHNOQTFHUC9mRUR1ek44OGxBaGRGZjBnK0JDeSt1bzdrTzYwMlNVaklD?=
 =?utf-8?B?dlJCcjlBbWR3a2xLb2ZoNm94WWJsc3hSTXEvWmFLN3pmZE13ZThHcjFmTWNK?=
 =?utf-8?B?SzFuSzliZ1ExdEEyZWRZbWxvMzg2dTBhYXdQaDY5Q1pCeU9FTi80WnVYcXRj?=
 =?utf-8?B?amN5SDJJbjlxaU9jY0lKSzBJR2tBNm9UYnJMUEc0Y2UyWC9QNkhWcG05alpM?=
 =?utf-8?B?N2lCRHU4RzUrQkVIQzBGQjZBdEVRREhwd3J6WVcxRzk4UnBVK0tja3JoK2c3?=
 =?utf-8?B?Y29JTXh6N29QUFVrcmVnZjBSNEJDQWtRcXJ5WEYzMGwwZFFDdisrbUNrSE05?=
 =?utf-8?B?MTZ6WjdZeGE3czVpQXlPSWg1TTJzQWRuTWYyWWZ6Qmk1WkJKR3hEdlNxSWtY?=
 =?utf-8?B?KzNibENIaERoQmNNYmxwbWdYbXNlbjIzYVZ3enFCQ3A2L1hVanZwVEJyWjRX?=
 =?utf-8?B?TjRJTktMWVBUR1QwOFVkdWFKYzZtTkdDdWlZYzFMV3pkSVFSU0pWcXBnV2ZC?=
 =?utf-8?B?MzR6RU9leGJwYlB6YzBVUWgzamtCdFpOT1BxL3JxWVBLakFFamxoRUxwcHZY?=
 =?utf-8?B?ZkNEbXRpRk5hMmNyTENnSE5hN1pyR2RTSXpIRmhUUE92OVRzUWxCM09zZHlY?=
 =?utf-8?B?QWF1b0xiazFsK0xwd2FESnZZdExGa0xibUVURldHUi82VGdVRUVJck5SR0VR?=
 =?utf-8?B?L2FlcTJpMDh2RitvVENpSkE4YXhBYmkwZysxMFZLTk16SVZWSGR3aUJuRGE5?=
 =?utf-8?B?RVNlY2pjKzVwSUJrNFVwb2FTdmhzL1FVODM4cmhMelowVjNUUWRTd2o2US9a?=
 =?utf-8?B?Rk5BZCtJM2VNaVQxdWI5ZnhLanViNHBLd1IyZFROR3pkZ2N4V2o3clZKSm80?=
 =?utf-8?Q?+QTfJDBd0UC/DrlqvDYs3iG0ysIJMYzL8LiuJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB2276695277D245B0FDFBF0552FFCB7@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3607977d-92c2-4013-0f43-08da31d81203
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 16:22:11.1077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bU6qBlrI5iKZSjTh/qeYARV5yDYGhD8iujLguSZdYtX/9kaBggVxe6IChml/faKbxBlcXvrBvOZo3SBGD3Hd0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB3233
X-Proofpoint-GUID: YnUnnsWpvqxRVJ_f0WvEjFSljnrvpzXD
X-Proofpoint-ORIG-GUID: YnUnnsWpvqxRVJ_f0WvEjFSljnrvpzXD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_05,2022-05-09_02,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

DQoNCj4gT24gTWF5IDksIDIwMjIsIGF0IDg6MDcgQU0sIFBldHIgTWxhZGVrIDxwbWxhZGVrQHN1
c2UuY29tPiB3cm90ZToNCj4gDQo+IE9uIFNhdCAyMDIyLTA1LTA3IDEwOjQ2OjI4LCBTb25nIExp
dSB3cm90ZToNCj4+IEJ1c3kga2VybmVsIHRocmVhZHMgbWF5IGJsb2NrIHRoZSB0cmFuc2l0aW9u
IG9mIGxpdmVwYXRjaC4gQ2FsbA0KPj4ga2xwX3RyeV9zd2l0Y2hfdGFzayBmcm9tIF9fY29uZF9y
ZXNjaGVkIHRvIG1ha2UgdGhlIHRyYW5zaXRpb24gZWFzaWVyLg0KPiANCj4gRG8geW91IGhhdmUg
c29tZSBudW1iZXJzIGhvdyB0aGlzIHNwZWVkcyB1cCB0aGUgdHJhbnNpdGlvbg0KPiBhbmQgaG93
IGl0IHNsb3dzIGRvd24gdGhlIHNjaGVkdWxlciwgcGxlYXNlPw0KDQpXZSBkb27igJl0IGhhdmUg
bnVtYmVyIG9uIGhvdyBtdWNoIHRoaXMgd291bGQgc2xvdyBkb3duIHRoZSBzY2hlZHVsZXIuIA0K
Rm9yIHRoZSB0cmFuc2l0aW9uLCB3ZSBzZWUgY2FzZXMgd2hlcmUgdGhlIHRyYW5zaXRpb24gY2Fu
bm90IGZpbmlzaA0Kd2l0aCBpbiA2MCBzZWNvbmRzIChob3cgbXVjaCAia3BhdGNoIGxvYWQiIHdh
aXRzIGJ5IGRlZmF1bHQpLiANCg0KPiANCj4gY29uZF9yZXNjaGVkKCkgaXMgdHlwaWNhbGx5IGNh
bGxlZCBpbiBjeWNsZXMgd2l0aCBtYW55IGludGVyYWN0aW9ucw0KPiB3aGVyZSB0aGUgdGFzayBt
aWdodCBzcGVuZCBhIGxvdCBvZiB0aW1lLiBUaGVyZSBhcmUgdHdvIHBvc3NpYmlsaXRpZXMuDQo+
IGNvbmRfcmVzY2hlZCgpIGlzIGNhbGxlZCBpbjoNCj4gDQo+ICAgKyBsaXZlcGF0Y2hlZCBmdW5j
dGlvbg0KPiANCj4gICAgIEluIHRoaXMgY2FzZSwga2xwX3RyeV9zd2l0Y2hfdGFzayhjdXJyZW50
KSB3aWxsIGFsd2F5cyBmYWlsLg0KPiAgICAgQW5kIGl0IHdpbGwgbm9uLW5lY2Vzc2FyaWx5IHNs
b3cgZG93biBldmVyeSBpdGVyYXRpb24gYnkNCj4gICAgIGNoZWNraW5nIHRoZSB2ZXJ5IHNhbWUg
c3RhY2suDQo+IA0KPiANCj4gICArIG5vbi1saXZlcGF0Y2hlZCBmdW5jdGlvbg0KPiANCj4gICAg
IEluIHRoaXMgY2FzZSwgdGhlIHRyYW5zaXRpb24gd2lsbCBzdWNjZWVkIG9uIHRoZSBmaXJzdCBh
dHRlbXB0Lg0KPiAgICAgT0ssIGJ1dCBpdCB3b3VsZCBzdWNjZWVkIGFsc28gd2l0aG91dCB0aGF0
IHBhdGNoLiBUaGUgdGFzayB3b3VsZA0KPiAgICAgbW9zdCBsaWtlbHkgc2xlZXAgaW4gdGhpcyBj
b25kX3Jlc2NoZWQoKSBzbyB0aGF0IGl0IG1pZ2h0DQo+ICAgICBiZSBzdWNjZXNzZnVsbHkgdHJh
bnNpdGlvbmVkIG9uIHRoZSBuZXh0IG9jY2FzaW9uLg0KDQpXZSBhcmUgaW4gdGhlIG5vbi1saXZl
IHBhdGNoZWQgY2FzZS4gQnV0IHRoZSB0cmFuc2l0aW9uIGRpZG7igJl0IGhhcHBlbg0KaW4gdGlt
ZSwgYmVjYXVzZSB0aGUga2VybmVsIHRocmVhZCBkb2VzbuKAmXQgZ28gdG8gc2xlZXAuIFdoaWxl
IHRoZXJlIGlzDQpjbGVhcmx5IHNvbWV0aGluZyB3ZWlyZCB3aXRoIHRoaXMgdGhyZWFkLCB3ZSB0
aGluayBsaXZlIHBhdGNoIHNob3VsZCANCndvcmsgYmVjYXVzZSB0aGUgdGhyZWFkIGRvZXMgY2Fs
bCBjb25kX3Jlc2NoZWQgZnJvbSB0aW1lIHRvIHRpbWUuIA0KDQpUaGFua3MsDQpTb25nDQoNCj4g
DQo+IA0KPiBGcm9tIG15IFBPViB0aGlzIHBhdGNoIHRoaXMgcGF0Y2ggYnJpbmdzIG1vcmUgaGFy
bSB0aGFuIGdvb2QuDQo+IA0KPiBOb3RlIHRoYXQgc2NoZWR1bGluZyBpcyBhIGZhc3QgcGF0aC4g
SXQgaXMgcmVwZWF0ZWQgemlsbGlvbi10aW1lcw0KPiBvbiBhbnkgc3lzdGVtLiBCdXQgbGl2ZXBh
dGNoIHRyYW5zaXRpb24gaXMgYSBzbG93IHBhdGguIEl0IGRvZXMgbm90DQo+IG1hdHRlciBpZiBp
dCB0YWtlcyAxIHNlY29uZCBvciAxIGhvdXIuDQo+IA0KPiBCZXN0IFJlZ2FyZHMsDQo+IFBldHIN
Cg0K
