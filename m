Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8310D5220BE
	for <lists+live-patching@lfdr.de>; Tue, 10 May 2022 18:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347255AbiEJQLq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 12:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347451AbiEJQLn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 12:11:43 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB841B091A;
        Tue, 10 May 2022 09:07:45 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24AFLhP4007147;
        Tue, 10 May 2022 09:07:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=weEpKe7EwKaGM0w9Bo325+KKFyz3plEJs7KelSQcXMc=;
 b=eyE/IJ3SZ5H5wsH1gRVMFRVUPIvUuN6e3RDPfsZHXdKtL/BdLwKRsd0tLfeg+RmousAH
 ZMf7qPAKZ/QquhoMaCbDopsua2MxVV2UA8TPt5mVliKPVggVYxQpPB3n0nCVAgstP+6s
 qbaT9TYv2bKEy15PIzFKWeczX86T0u/ip8M= 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fxywst4ky-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 09:07:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzyN0JR0X6nYd0SdjVgrzNpHNm+T05TFhcwqCo4ivtv4gEO+o/ZC83ItAjiqMar18NYj6P2qOHVlgdC8EoMp1LpiuKlF7v4Z9NtntUrvMUpgbKUYWHCa80GJ7c6c5PWLyksOlmx0EgiLoqYw1eKVrp7DkWReLQB8TfgtneabfGDlU71/TFouZiFOgzt1ha8c4rBD0gQRA3HZgp6B61jgGSnU9z0DRvh05qtorqJKbKvLBqzddMajIh/VKI/7U4VZx+8i4kbveL/pTxivVZSuWG3mZ3gMQGHY2f2lBMu+l/sXY8XncfdMxwLppFrvo5hsAJ7+jP5yo38QFS2TWkT7Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=weEpKe7EwKaGM0w9Bo325+KKFyz3plEJs7KelSQcXMc=;
 b=HAGkXi0uAy/4ZVGFsL4SfuadyyUzpzh7hGlD8VBIjkwIGkusL4g6Excb1fAiU8wWlqKqRfmT39kTrBVDBnIuQueZLGftDIc0oRt9WN0JANzpF0qKhkpv5/6MIevgJdvg88U4lo1/C+1SB0bkZFakJJQHOXIvLdSmQ0odcIM6qp4k1iXqilUi7oK1YyEQc8IyyGQ15fKDsLHn2fa81uSffDPK8GtVcCoruOjpg20J16gNC4yp5cAmuv1qhcVGKUZHJGbBNDptgxP3u8/OFp/UyHXe0Y34qWN+LgXEuGi9EDWUQQt6PKQ44CX9dVnsyZaZmJ9lEosKhpFVkSSpDkZTog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO1PR15MB4969.namprd15.prod.outlook.com (2603:10b6:303:e4::23)
 by CH2PR15MB4295.namprd15.prod.outlook.com (2603:10b6:610:d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 16:07:42 +0000
Received: from CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730]) by CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730%6]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 16:07:42 +0000
From:   Rik van Riel <riel@fb.com>
To:     "pmladek@suse.com" <pmladek@suse.com>
CC:     "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Thread-Topic: [RFC] sched,livepatch: call klp_try_switch_task in
 __cond_resched
Thread-Index: AQHYYjpsdFy2RMM8vk2xmmtLa5gGmK0WqGoAgAAVAICAAQUigIAAXfwAgAAkyICAAAZgAA==
Date:   Tue, 10 May 2022 16:07:42 +0000
Message-ID: <6bf85ff908377508a5f5bcc7c4e75d598b96f388.camel@fb.com>
References: <20220507174628.2086373-1-song@kernel.org>
         <YnkuFrm1YR46OFx/@alley> <9C7DF147-5112-42E7-9F7C-7159EFDFB766@fb.com>
         <YnoawYtoCSvrK7lb@alley>
         <3a9bfb4a52b715bd8739d8834409c9549ec7f22f.camel@fb.com>
         <YnqIcw+dYsWz/w7g@alley>
In-Reply-To: <YnqIcw+dYsWz/w7g@alley>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 80b47cfc-f75f-4301-43e6-08da329f369c
x-ms-traffictypediagnostic: CH2PR15MB4295:EE_
x-microsoft-antispam-prvs: <CH2PR15MB4295379522EB96C68260DF16A3C99@CH2PR15MB4295.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IytI7ALtJ+VHfE9QsgCU6zq3Al3zBv6RZH7lVwYQXyHooJDm8OAK7R1H93jM7kLB/OvH/ZLWZckB+Ur5AS1xjtL0NgODXgnFBvHYdNznCV5C2bOjLPsk0uMYPoJzkGnvbrXDg5gbdqS7giGhOsJFRlw6fAbf5Epub/ro+L3OzPyZhZHsFVSX2a9QgMsTszLwOBXY+c7UTd0L+Smb0MnGLQX7ehGSF3HcHeSmAJtbdkXziZairkDqZA551E9zWFHvopwJ2LXO0iPJ35H/wip/CX0EnNvwbsMgBO5cabltJD5eoNT4C3z+eUwO2gkkpb0QwO6d+9q1o/V8fn3A4tUR4I0WfYSnO9yNjvZ7rW4KY3s/usUNu6PLE50hkbnO92uEJUJ9ZaCgQYgLleOgWD05YgxiD8XsxnMnDrwMKzPBkqwpPH4S/Pst2KfVD5J8pzSPOAgqX97r1aJ5gEOP3o+9BM/xSZZ8sgj4fDErTBX77RNGHHLnLsho2b5Y+6XvrllpY9PGYD4aW8whnxaHsiHSfhG9wSocLH7vPViY3yboWDW/qM+R5mU1dalGZtyX6xLvf1ppmWgpWCxGNUUliZSk25LZCqTfy2rmm37Hr65gCKqUnWDUXe1xE8TkPVnYE+6SV9FiOQ0zfoXFidnAlyvhXZHJJT975Eg63HGUXq+drZBc/c1xjm01diWR8aXUPaVn2BeuOBFZpOWWnNlLzLOyMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB4969.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(6486002)(508600001)(316002)(71200400001)(186003)(86362001)(6506007)(2906002)(5660300002)(2616005)(83380400001)(122000001)(4744005)(91956017)(36756003)(66946007)(66556008)(54906003)(76116006)(66446008)(4326008)(8676002)(64756008)(66476007)(6916009)(8936002)(38100700002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWFmcGlJSlNmUDVLelVPTEczUWVBc3BnQzdyRmJKUGNDQlg3RTFHN0d5dVNF?=
 =?utf-8?B?QzdTeWU4SDkva0FqYWdJNldoQmtSK0hzbVo1aWZyTXB5akE3WitVekQyZ3pL?=
 =?utf-8?B?RGE3Wi9sYlJVdGNwbTdaakxiZEtUbFFkMUZjTzQ3OHJxaEthc0RLWmdzTmNW?=
 =?utf-8?B?dTR6ckpGV3R6bXY1UUtONlB3OWNDbGxrL0NwKzE5K2d3UmpVekE3U1Y4Y1Bu?=
 =?utf-8?B?SWFkcDNPbDNUNmprLzRYL2k4Wi9qQ1haNzl3Y0dPQVpUejF5U3Vhc0pTcUdt?=
 =?utf-8?B?U3haYkJmc0lWWEV6UkQyalJURWk4MzRQcTJkL25XMWpOYk5aSk94TXZ0ajVj?=
 =?utf-8?B?VkhyZ1ZtKzFEdmtlZVgwc0hkYnpaWExlY1FUUVgxMFdWMjV6cnZ4NWlkMlE2?=
 =?utf-8?B?YVRORGJPcUpReWloc1MzNXlvNjlzMGpISVFnSlE1NkNjWTdkUEFObGRaK3NB?=
 =?utf-8?B?MkZoTVBoNzJGaFFYdndmZmdrdVI3cWNrc3dXY2lVV3pVaEFSRmRzVDIzeHBU?=
 =?utf-8?B?c0Y0cXEraUhTUkZiVStnSkY1aTVBM2RBRnRJTlhUU0REN0hkd2FzdkhUUGJu?=
 =?utf-8?B?UzA2S3ZQanhiV0hRNWpsQ2hXenFQWkxzdjVwUEl4LzE0OEVobG1FelNQVnhj?=
 =?utf-8?B?VktuK1dKSnRVWVgyYWR3cjByd3d0WHFSVHA4SEtVUm96aVN0Snh4c1poZm03?=
 =?utf-8?B?M3VzVjhFQmppSCs3TGZtVmcrNEdFZUZiaVBicmVTRkZUa1BxRTU3VGlVbXZm?=
 =?utf-8?B?TWxyNHZZL3NOaStjK3ZFcEtnbGpiWFo3amJBZ0dpQXF2ZCtCS0RIdGt2T1VL?=
 =?utf-8?B?ZC83SzJmTUorMG80c0FBV0xSSDQyai9jSmVRWmJWcUxFMnc5cTZDRmtPMDZv?=
 =?utf-8?B?dW1zamduVVFXclRUZWNRR2EvdUM3c2Y4aG1Rd3prTTBJdkRyRHJnQ1oxK25q?=
 =?utf-8?B?VXI4Nk4wVXlWWDMvcmFISkFEMXY3V3JuOUdwZFJVUFJ2aHdvOWUycFBKalAv?=
 =?utf-8?B?ODByZGw0cmJzaVJ5S09pbC95QUtUNTNEQUFHMnRnVk9tYmQzV1kwVUtQbGR0?=
 =?utf-8?B?UEpwd2FhSDdic0hmOWEreVVBSUo0dkdGN1JyVjFqdHM2SUJUU1ZhcFpUUXZW?=
 =?utf-8?B?VHJsRmI1MFNzbU4yMkZ2YWhmZUQrb05pVGI4WnhrUkhsdWJ5RFB6c1dRNjEx?=
 =?utf-8?B?QWMzSTVnYWVidWwwQjRERDRJdTVjQUI0a05qM1VWQU5ha3VSaXYwRVluclZZ?=
 =?utf-8?B?YklsQkU0ejZ5amhKTC9QWTlXQkFkd3B1cit2c0t0NjVNRjJNOTNkQ2tYRWJn?=
 =?utf-8?B?c2hZUEcrQU04UWl4UnphWlFKUjdaR05kY0JsRm8xRURvZ21nL1MvbkRPSmZT?=
 =?utf-8?B?bElwS2Z0WStrQUlkYmtnQklPdDJueHBSK0NaUjdyUFlGVDdTTmI5dmp1K2ha?=
 =?utf-8?B?Lzl1a0Z0THkwUmRUSmplTzNZNHVScy9PU0h5WXdVcE80QWlMMGxCeEZOTTlH?=
 =?utf-8?B?bGJ5cnE1WS83ZHAzQzBGYnFaaWN2blZna3YwVE9Neisxa2lPVmtoWGVERTFF?=
 =?utf-8?B?MjBmdmNlSTgwUzBZeGl0NVFURWZqbkhjanFvYm9GbUlIeWF5dUZaUVN6SlR1?=
 =?utf-8?B?U29PbzhVTURwR2w1cUFkZS9Ra3FxUEhUM1l5V1duM2lLMkI4Y1RmM0ZCcVVK?=
 =?utf-8?B?QlJJNXpKWElJNy90dWZhWFpGRHlqYUdEMkxxSVVVU2YwUFdJeTlNbnVhdFE3?=
 =?utf-8?B?QUlVREFOMlUwanZQa1cyRVJIRmg1a1o5V1htUUZ1SlQ4YmVENlNPckp1MHdG?=
 =?utf-8?B?NVYwajU1alZMK1BJVW9XK2lkRUJ2ZTFKcjErMWwvSnVNNEtFSWJ1aFYwQXBi?=
 =?utf-8?B?YUUwdjBMV3NhcVliODJwbzBwSWo2L1lCQlh2bHo0cEFjYldLK2xnNmRzNDc3?=
 =?utf-8?B?STlwYXJ3V0twR0U3SGZQVzFyd0FkajJBREtUTFY5L2ZGYVdMZVdzMC9sVUdw?=
 =?utf-8?B?bHFBbWNUQ0RHa3VwR29oWjBPWlBMeHlVUFdzaVFFVjJ5NXdReG4yNWd0NGFm?=
 =?utf-8?B?RFhxNTdIeEdDOS9nWkNJWmlYQldweHBHaWs4R2xFcDc0bmRYbHd4K25vMmpx?=
 =?utf-8?B?QTY2K1RxT0F3cFp3dUJjTkhZWk55QmZ2YUxoMnZKc1RnTXRwakk4Ni85a2Zy?=
 =?utf-8?B?aHlTVjA5T0RFbUZ0b2hTTkVYTmJFK2ZKaUxUcngxNEdWY2NjYmJ5QWVPZ3kr?=
 =?utf-8?B?SE4vZlVhUG9IY0RpWUtHNng3WG9JSzZ1U2VSbDdQZU5DemVzNHRWRlJqeDdh?=
 =?utf-8?B?L1QvdVY2b2FieDhRakNPOC9KNTF3ZHFyK2pxWHRxQVF5REVISGE4Y2M5a3hI?=
 =?utf-8?Q?esxiphvRdptg6J4s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BEDE5EEB2A306D42A5E00C344D05CCB0@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB4969.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b47cfc-f75f-4301-43e6-08da329f369c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 16:07:42.3433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TrrbSRwDiUR22GhOfMMlCT+2F5AZwFn1MyruZiKfK41TEoy5gVJOI/+AjOVfcQOs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR15MB4295
X-Proofpoint-GUID: 5fGFWZIHe0nI7xe3t_T9WqgJTwNs6Cog
X-Proofpoint-ORIG-GUID: 5fGFWZIHe0nI7xe3t_T9WqgJTwNs6Cog
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_04,2022-05-10_01,2022-02-23_01
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

T24gVHVlLCAyMDIyLTA1LTEwIGF0IDE3OjQ0ICswMjAwLCBQZXRyIE1sYWRlayB3cm90ZToNCj4g
T24gVHVlIDIwMjItMDUtMTAgMTM6MzM6MTMsIFJpayB2YW4gUmllbCB3cm90ZToNCj4gPiBPbiBU
dWUsIDIwMjItMDUtMTAgYXQgMDk6NTYgKzAyMDAsIFBldHIgTWxhZGVrIHdyb3RlOg0KPiA+IA0K
PiANCj4gPiBJIHRoaW5rIHRoZSBiZXN0IGFwcHJvYWNoIGZvciB1cyBtaWdodCBiZSB0byBqdXN0
IHRyYWNrIHdoYXQNCj4gPiBpcyBjYXVzaW5nIHRoZSB0cmFuc2l0aW9uIGZhaWx1cmVzLCBhbmQg
c2VuZCBpbiB0cml2aWFsIHBhdGNoZXMNCj4gPiB0byBtYWtlIHRoZSBvdXRlciBsb29wIGluIHN1
Y2gga2VybmVsIHRocmVhZHMgZG8gdGhlIHNhbWUgS0xQDQo+ID4gdHJhbnNpdGlvbiB0aGUgaWRs
ZSB0YXNrIGFscmVhZHkgZG9lcy4NCj4gDQo+IEkgYW0gYWZyYWlkIHRoYXQgaXMgYSB3YXkgdG8g
aGVsbC4gV2UgbWlnaHQgZW5kIHVwIGluIGRvaW5nDQo+IHJlYWxseSBjcmF6eSB0aGluZ3MgaWYg
d2Ugd2FudCB0byBjb21wbGV0ZSB0aGUgdHJhbnNpdGlvbg0KPiBpbiBvbmUgbWludXRlLg0KPiAN
Ck5vdyBJIHdvbmRlciBpZiB3ZSBjb3VsZCBqdXN0IGhvb2sgdXAgYSBwcmVlbXB0IG5vdGlmaWVy
DQpmb3Iga2VybmVsIGxpdmUgcGF0Y2hlcy4gQWxsIHRoZSBkaXN0cm8ga2VybmVscyBhbHJlYWR5
DQpuZWVkIHRoZSBwcmVlbXB0IG5vdGlmaWVyIGZvciBLVk0sIGFueXdheS4uLg0KDQpJcyBpdCBj
cmF6eT8gTWF5YmUgYSBsaXR0bGUuDQoNCklzIGl0IHNlbGYgY29udGFpbmVkLCBhbmQgc29tZXRo
aW5nIHRoYXQgY291bGQgYmUgZG9uZQ0Kd2l0aG91dCBpbnNlcnRpbmcgYW55IGV4dHJhIGNvZGUg
aW50byBhIGhvdCBwYXRoIHdoaWxlDQpub3QgaW4gdGhlIG1pZGRsZSBvZiBhIEtMUCB0cmFuc2l0
aW9uPyBZZXMuDQoNCkknZCBiZSBoYXBweSB0byBjb21lIHVwIHdpdGggYSBwYXRjaCB0aGF0IGRv
ZXMgdGhhdCwNCnVubGVzcyBhbnlib2R5IGhhcyBnb29kIHJlYXNvbnMgSSBzaG91bGQgbm90IDop
DQo=
