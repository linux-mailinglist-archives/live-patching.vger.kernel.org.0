Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3802A51E94E
	for <lists+live-patching@lfdr.de>; Sat,  7 May 2022 21:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446821AbiEGTIl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 7 May 2022 15:08:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiEGTIj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sat, 7 May 2022 15:08:39 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47BF2A251;
        Sat,  7 May 2022 12:04:51 -0700 (PDT)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 247GMtvd019179;
        Sat, 7 May 2022 12:04:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=f4Kqm76GSDYYDBsyIrxHJ6kVgkYWcYHzex/AgLBK+/0=;
 b=rWW0kT6VdpWzX5sAyXUMGlIDyjAIHZsovflpJLf81PNPfQzqSgGtN0lkpzK2oyn6xbfv
 qoF9P6XW/p6OYbdXWwKp7ETAl1fiPVz3tmNrVo+h4nO0+rcR2lC6AHzkDxojSwiWSpzQ
 r3TOjsvEMHzjH5uGGJyry4CAh/lNfC95p7Q= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fwpgw1cg4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 07 May 2022 12:04:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D1YYkWEL+KNN7hB33ND1qEeTvxtRPdUf3nMqd4gxiWnfCY7dmb/sasLSsLpaUB30HMvVuMI5RUMSU+au204dLa8xZjyoXvPCU6Y1aF1qLMlJGPjaFFk6vk2m33EeAJ/A/1gRzObD+kPCHmMTzbWU1Zr3SNogCoKi1FIPCZZHyL80j26UQwC3Xxy6Rrxlo4R8hF1pJBlRDsoRXiaIGlhDU/0iYE2QiCm9Pxt7L7TKJVog+RkrmXGVe0+ZpDd6783E18UvT1aJS5kynheyzzpt9l5yM7D2pvhnlboVDKJBAytPchGxIdvOG70fwYGgh7H8f4TqqTzB114Lb+sbGc3cZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f4Kqm76GSDYYDBsyIrxHJ6kVgkYWcYHzex/AgLBK+/0=;
 b=n+KC/JwKDCYsvmvGETFgmmXFWECIZJhrRATic4JXiCg0bpHAilLi47fk3wvKMgaf/a8xR+tlfegeVKMsUfIiyuXVi/P1MUoLKIBGYqncAjdQ0RVIR8ebyCJIHX8v4JWgl5IeiLZkgZcTbDXPlSYnNG3ZjoZE87h3EoOFQbgI0tMkoViNl+5K0PsCAvgOAF+olnE26yt23/ITJSnTfvRqacxH3qp19lATe4R/u+yypTWYg/rjP5jVAR7Drp8IBoPAjTBd0pJd4sn3kgj+Ba4NSzGjFGLPC/FHQwe3AP+waHRSMB2aTNGYYTZkzAYs08P8Gu6hzEOjKJ7VpwGhx/Z43w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM6PR15MB4140.namprd15.prod.outlook.com (2603:10b6:5:32::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Sat, 7 May
 2022 19:04:48 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::4133:c564:79a7:74d5]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::4133:c564:79a7:74d5%6]) with mapi id 15.20.5206.025; Sat, 7 May 2022
 19:04:47 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Rik van Riel <riel@fb.com>
CC:     "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "song@kernel.org" <song@kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Thread-Topic: [RFC] sched,livepatch: call klp_try_switch_task in
 __cond_resched
Thread-Index: AQHYYjpsu2JIKZQIXUOp7t0Qujiczq0Tu50AgAAKkAA=
Date:   Sat, 7 May 2022 19:04:47 +0000
Message-ID: <36BA01F0-F2B7-4290-AB23-E61989262AB3@fb.com>
References: <20220507174628.2086373-1-song@kernel.org>
 <1b7f0b76b6060b6a0ccd04fec2be6c0323907c8e.camel@fb.com>
In-Reply-To: <1b7f0b76b6060b6a0ccd04fec2be6c0323907c8e.camel@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.80.82.1.1)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 69a81ebd-e952-4695-0ede-08da305c74b4
x-ms-traffictypediagnostic: DM6PR15MB4140:EE_
x-microsoft-antispam-prvs: <DM6PR15MB4140571DFBA42D0CB7F6E1F3B3C49@DM6PR15MB4140.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tFYnOmQVyewvekA085ky1czHzbKyqMZKfD5OTt6Glu1NKvc4D10WXiRho2kUlJrJybkvnAcpZZCg0t77ahreOvQzHW0cboVdm6086T99dDFeiebwqkBlmKC40HRqXf2jt46NuBNjPu0aQ2EGmI8Do/BMxyzLaH4tIesTT897B0jv+0YRlZGYKLWsNZQ77jRaeQHpzvDw8hd77Xl57EhtmoyMeiQywFVZzrIYyGdznfSiglEOeIRxr3QYEjS0+8fT4K8yRsMOcR1q5BugNPSzCkRheS3CqF1L4LxZAaRsWbjT2/b/kYq4Oii4v+4MCD5yM/F/2hQhfIeH3b7TV4EWAN7ODrwIArJugng9IcDcUKmke/Tl+VZBGgDuTK6ZO2fZqmwzL62aQwx1Tmo/dEoTWdbNyQ/ZozAOuv2K+Wzq6BG3MVWwwTP2/S3vj0QhyjwMmJ/TUTnFCaXjr556UKdbMogUffAQMynYlYycnx7FLcgnOJuSNOrylHceFK7+lVWD6thD79t/0tCy+q1FledXK6QJB5yrrPVEYMg/jGWGTxdec1VrVj5NEGngbGrj+A9gy0FzDu+HCoNu8kwVN0DhWHKTEnteBNZGz+zvW/yXsr3v+f5BP+C0OoaRAQYryBqWts52htsjAIRZFIqcbW+vwqKg7LcR62aY07tmDNm7vUKOw2k4BYAX1yPnfHXTu/uBv3ZNqKrJ3SdoQW1fZKWHGxBJHjj8zoqC/axBlR0Kgg8zHNfALaMdFSBQGwniWoSd
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(8676002)(6862004)(4326008)(71200400001)(86362001)(6512007)(53546011)(6506007)(2906002)(122000001)(6486002)(83380400001)(5660300002)(8936002)(508600001)(33656002)(38100700002)(38070700005)(316002)(6636002)(186003)(36756003)(37006003)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(91956017)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TTdyOFJOV1krdUIyaFJDVVo4MExBdTZhM1dLQzhNLzdiKzlxektXZEcwcjl4?=
 =?utf-8?B?eTFnaEdjMjMzU29PUWdGblZBakYxWG43RllRSm8zR0VGa1VlVVFSSURhUXhn?=
 =?utf-8?B?T3Awc0JGdFVQZ3kzTVBUTUJEa3VRWHNZVXVRQmpWZXhPZUxGVVk2UVFHT0NE?=
 =?utf-8?B?S3Z3K0ZuTXJRTFl3VEh1S3NwdDluaDFpU3orTnhPR0ZsU0VWQUEwSFlNWFlP?=
 =?utf-8?B?bU84bkVmRXJLMlZuaXdpdjk0ZDV5TjZaU2tjbERQNHpsazI2ZDB1R1FPTU9s?=
 =?utf-8?B?azljNmdpaUg0OVAwOGkwQmdPOVNQWGpCa3BrbXh1SHREcG15cGNDZHgxNlFD?=
 =?utf-8?B?QkxvS21HZjBUOTZmSGJxcjl1TzRuTmlSM2pRTnZYYWNUTk1hTmhtUUlNNEUx?=
 =?utf-8?B?b1FmR0RlTVJsajN1K291Vkp1N2dCd0FvaE53NDNTU1NjNHB1VXNpM1B2eDds?=
 =?utf-8?B?V0tCbzFzUTdtekZaYlY4cWxyYzMweG9QR1hLS0dLUmwzN0FySDJ3bnlmejlx?=
 =?utf-8?B?dGZZOHhYVEthbk4wSnJNVFVLWGdyaHdjdFFqOXdDNENYd3V2OS9aZUEyYWp4?=
 =?utf-8?B?ZWVDVkxoT0lEK2RGTWd5L2FDN2gwaTFLWlNFYVNhamR3Y0NyT0ZjMldTb3ls?=
 =?utf-8?B?WmgvdXczTUdvN3FRb2Q5bGdZQmtBYkNBRkJvSitBckthOGJnSmtOUlNlY2p3?=
 =?utf-8?B?NmNKeXc3UFV3dVZ3ZmJHdVdxckdtZzhjbnhDeHJ2V0JvbnZDejdYTEZJLytY?=
 =?utf-8?B?MGNFSmVCY3pYcmJUL1NmQU9CVVo4NzIyaWkrTEpsQnlyZ1ZBK05mTmR3aDBP?=
 =?utf-8?B?UnZObkhYbTB1bVlQUjhIc3FYaXl2ZUpGUktaY3JERFVUTDl0WFFRbGpnVWtr?=
 =?utf-8?B?VTJkUUVoRTh6WWY4MytsYVNtV2hDK0U2OWtWK25OZjRYQ3VlY3BUTlhQTm9M?=
 =?utf-8?B?Nmd5QWYvUjhUQzM2eWthNktOYXg1MlI2N2RmeGFiKzNoYU5hVjNSeGVaaE1v?=
 =?utf-8?B?QTdhQXVFVFNmTGlaZXVYODNzcW43MHZJVEc4VjV4Q3ZvT3Z5N21MRGhkV0g2?=
 =?utf-8?B?TUhPemswWG9iQUdEcGVlZjQ5UVZKYVpVRzliUVY0cTB5SXE2UUhraWJORFgy?=
 =?utf-8?B?K1o3eG9OdVhudlYxcEQ1WVhlR1VIQ2JsQTM4K3dzd0tsVHBWSlhFa1RNWGRx?=
 =?utf-8?B?TjN3NFNQM3ZtR2YwL3dXcWk1SjJNKytvMEdvczNWL0kzb05vWDdlTDM1THRG?=
 =?utf-8?B?S0VTL1lwM3V2MnBjMHU2TFcxd3ZuVkhlNXc3VUVaV1NYcnJmanozYjBpQ0hM?=
 =?utf-8?B?Nnc4NXoydHpiNTI5akkyU2ljQ1ljYWtBOTRQZVJNci9Zc2lkcWtEVG1mc3dO?=
 =?utf-8?B?WDQ2M3pjV0VpV05YU05RK3haak93ZDdSZmVlWDdUOXFSZFk3Qk1ETUFXeGVu?=
 =?utf-8?B?QXRrb243S2VQc0tBWVl1T1VHRERrcVRQUkkzYnR4bnRXWFAxOGtmUVZRSlZ1?=
 =?utf-8?B?ZHp1aEFkbjFZNlQwczRlaUg0VnRPejkzRjFnY2Zyb3QwSWs3MlNnWFBOS2FI?=
 =?utf-8?B?bG0zZlRmUFY4UkpQNVIxTUFnY0VSZlNFNCtveUdIbmxFWlh2Q3ZIN0lKbW9s?=
 =?utf-8?B?SWx4aFhZc0dJSk40b3UwTzFZNEFCbFg0QWZPMEZLN2RycHR0OXNTZmxrL0RG?=
 =?utf-8?B?UlhINjhLWDVHUCtndEhBTlpDNG9iL29ubVlIOXlVdnRIVm40UW9ycnd3MThS?=
 =?utf-8?B?Z3FEYlJ2bkREbW5mUzFXNmxmNUxqcjZZcmxjenBYZWhjSjRQUUJOS2xCQVR2?=
 =?utf-8?B?ZkMxU3ZzMW1JbDkzT1NCTGxJRTF4eGRVc0JTUHhUdUxsS2FaZ1JrSlk1ajUx?=
 =?utf-8?B?MzQyN1pBMjF6VUJINk1xeXdHWitBSjR1YXR6VXY0UkZSSk1QNzA2MjhpZ1d6?=
 =?utf-8?B?eXkvc1BDSmdxY0FuNmhlOEdOZ1FNdGpwbnRRbzBmbnJSM2JIRkE4c0FYVHA0?=
 =?utf-8?B?dXNGNnRZYW1aNkpqYm8xdXdNYmNBczFwQ2lNVitiOWEyVDc5YUdUZ3BjMThz?=
 =?utf-8?B?WnhuOUNYNkVpUm1QMjVJdDNXVUU4WXdjRjFGbUpmYTRMTG9IYjNyUEtGWWRP?=
 =?utf-8?B?bXJOQXJHeTNFNWVpR2VyeUNROHZxUGF1VUpxSVZiRURJZktWMnkzM2tTOXQ1?=
 =?utf-8?B?ZFJaZndBNjFkYUJxU3NNOWVvY21URTZ4N2JROHoxTXljZnJrajh5N0xVSUxT?=
 =?utf-8?B?L2hlZFI3Y3hjUW44WlNZUzdOeXdjQUJkdGUrcXAyOG53YTZMaWVrdlpBbWlN?=
 =?utf-8?B?WWs3Y3Y3Q2dWS1BveGFiamlnTHJQYWZkVnM5OGEzRXU3WndpMUo5WUQ0RVJW?=
 =?utf-8?Q?yYUv6rKxX8QWLmTi2yYdyWTP7Fi3yQmdQXHAG?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6A5B500D51CD7141BBA2FFA68900FEBA@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69a81ebd-e952-4695-0ede-08da305c74b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2022 19:04:47.9272
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vz+lLAOwcDC/hHX9EXCXbLqDlIChzqpNzhdsJk7nuNVOIdNKluaQ1zs8t1VqIhdd7PRevqu4pLmIJX+4UrGHmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB4140
X-Proofpoint-ORIG-GUID: mzgJ--Im9xKBfFqFzWuhC6Isiol9MA-b
X-Proofpoint-GUID: mzgJ--Im9xKBfFqFzWuhC6Isiol9MA-b
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

DQoNCj4gT24gTWF5IDcsIDIwMjIsIGF0IDExOjI2IEFNLCBSaWsgdmFuIFJpZWwgPHJpZWxAZmIu
Y29tPiB3cm90ZToNCj4gDQo+IE9uIFNhdCwgMjAyMi0wNS0wNyBhdCAxMDo0NiAtMDcwMCwgU29u
ZyBMaXUgd3JvdGU6DQo+PiBCdXN5IGtlcm5lbCB0aHJlYWRzIG1heSBibG9jayB0aGUgdHJhbnNp
dGlvbiBvZiBsaXZlcGF0Y2guIENhbGwNCj4+IGtscF90cnlfc3dpdGNoX3Rhc2sgZnJvbSBfX2Nv
bmRfcmVzY2hlZCB0byBtYWtlIHRoZSB0cmFuc2l0aW9uDQo+PiBlYXNpZXIuDQo+PiANCj4gVGhh
dCBzZWVtcyBsaWtlIGEgdXNlZnVsIGlkZWEgZ2l2ZW4gd2hhdCB3ZSdyZSBzZWVpbmcgb24NCj4g
c29tZSBzeXN0ZW1zLCBidXQgSSBkbyBoYXZlIGEgbml0cGljayB3aXRoIHlvdXIgcGF0Y2ggOikN
Cj4gDQo+PiArKysgYi9rZXJuZWwvc2NoZWQvY29yZS5jDQo+PiBAQCAtNjk5MCw2ICs2OTkwLDkg
QEAgU1lTQ0FMTF9ERUZJTkUwKHNjaGVkX3lpZWxkKQ0KPj4gICNpZiAhZGVmaW5lZChDT05GSUdf
UFJFRU1QVElPTikgfHwgZGVmaW5lZChDT05GSUdfUFJFRU1QVF9EWU5BTUlDKQ0KPj4gIGludCBf
X3NjaGVkIF9fY29uZF9yZXNjaGVkKHZvaWQpDQo+PiAgew0KPj4gKyAgICAgICBpZiAodW5saWtl
bHkoa2xwX3BhdGNoX3BlbmRpbmcoY3VycmVudCkpKQ0KPj4gKyAgICAgICAgICAgICAgIGtscF90
cnlfc3dpdGNoX3Rhc2soY3VycmVudCk7DQo+PiArDQo+PiAgICAgICAgIGlmIChzaG91bGRfcmVz
Y2hlZCgwKSkgew0KPj4gICAgICAgICAgICAgICAgIHByZWVtcHRfc2NoZWR1bGVfY29tbW9uKCk7
DQo+PiAgICAgICAgICAgICAgICAgcmV0dXJuIDE7DQo+IA0KPiBXaGlsZSBzaG91bGRfcmVzY2hl
ZCBhbmQga2xwX3BhdGNoX3BlbmRpbmcgY2hlY2sgdGhlIHNhbWUNCj4gY2FjaGUgbGluZSAodGFz
ay0+ZmxhZ3MpLCBub3cgdGhlcmUgYXJlIHR3byBzZXBhcmF0ZQ0KPiBjb25kaXRpb25hbHMgb24g
dGhpcy4NCj4gDQo+IFdvdWxkIGl0IG1ha2Ugc2Vuc2UgdG8gZm9sZCB0aGUgdGVzdHMgZm9yIFRJ
Rl9ORUVEX1JFU0NIRUQNCj4gYW5kIFRJRl9QQVRDSF9QRU5ESU5HIGludCBzaG91bGRfcmVzY2hl
ZCgpLCBhbmQgdGhlbiByZS1kbw0KPiB0aGUgdGVzdCBmb3IgVElGX1BBVENIX1BFTkRJTkcgb25s
eSBpZiBzaG91bGRfcmVzY2hlZCgpDQo+IHJldHVybnMgdHJ1ZT8NCg0KeDg2IGhhcyBhIGRpZmZl
cmVudCB2ZXJzaW9uIG9mIHNob3VsZF9yZXNjaGVkKCksIHNvIEkgYW0gbm90DQpxdWl0ZSBzdXJl
IHdoYXTigJlzIHRoZSByaWdodCB3YXkgbyBtb2RpZnkgc2hob3VsZF9yZXNjaGVkKCkuIA0KT1RP
SCwgd2UgY2FuIHByb2JhYmx5IHNlZSBzaG91bGRfcmVzY2hlZCgpIGFzLWlzIGFuZCBqdXN0IA0K
bW92ZSBrbHBfcGF0Y2hfcGVuZGluZywgbGlrZQ0KDQppbnQgX19zY2hlZCBfX2NvbmRfcmVzY2hl
ZCh2b2lkKQ0Kew0KICAgICAgICBpZiAoc2hvdWxkX3Jlc2NoZWQoMCkpIHsNCiAgICAgICAgICAg
ICAgICBpZiAodW5saWtlbHkoa2xwX3BhdGNoX3BlbmRpbmcoY3VycmVudCkpKQ0KICAgICAgICAg
ICAgICAgICAgICAgICAga2xwX3RyeV9zd2l0Y2hfdGFzayhjdXJyZW50KTsNCg0KICAgICAgICAg
ICAgICAgIHByZWVtcHRfc2NoZWR1bGVfY29tbW9uKCk7DQogICAgICAgICAgICAgICAgcmV0dXJu
IDE7DQogICAgICAgIH0NCiNpZm5kZWYgQ09ORklHX1BSRUVNUFRfUkNVDQogICAgICAgIHJjdV9h
bGxfcXMoKTsNCiNlbmRpZg0KICAgICAgICByZXR1cm4gMDsNCn0NCg0KR2l2ZW4gbGl2ZSBwYXRj
aCB1c2VyIHNwYWNlIHVzdWFsbHkgd2FpdHMgZm9yIG1hbnkgc2Vjb25kcywgDQpJIGd1ZXNzIHRo
aXMgc2hvdWxkIHdvcms/DQoNClRoYW5rcywNClNvbmcNCg0K
