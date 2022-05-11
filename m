Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D67523C39
	for <lists+live-patching@lfdr.de>; Wed, 11 May 2022 20:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346067AbiEKSJf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 11 May 2022 14:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiEKSJe (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 11 May 2022 14:09:34 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0315E44C3;
        Wed, 11 May 2022 11:09:33 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24BFMR5R004923;
        Wed, 11 May 2022 11:09:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=NBkbFXFzz4Cpr+JyPstXQqhVemuVyzaVHKJWLwXbgBY=;
 b=hhFyMMgOg62OxyV/7T6LrPPHMQVsxZSWTPUf2hVdAc9rbVM4CfONYUOgZUTWUSGRlQ1s
 zzJF6SmVnVlzck5f93OJQ0ryWxGfUoX46BzY2uD/LJi275SbRH+d3nKVjJJrpy6wlwuf
 eibp1l93ZPFgqhiesH6fW+c8u+OzR5TYOaI= 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2044.outbound.protection.outlook.com [104.47.74.44])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fymp4kgvu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 11:09:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6AwIunHlqKWRy1J3GJwVRYA7tIk/GMlRfOlYLdTDmfxmMtGcWfgWhW5OaOFLnUVUaTHbW36jIs6ntB6Sy+uoYlSF8UnepZpuL7BQJH+fFZS/hVGWb4qJbJSUWxW2JMmKBXOExyIj+NsvpQ837ZfeBO0GjszWW6iiuEc3AOui3jfeep5L0PLwO5jOTAi93/a4v/5T477+z1F3EDtsrZyA+XTLtVyHufStV/7ujlKlq6+hSqCGpaH7l4ySWZA6oL/tQfuz0FA9Mk/Wy+PLvjEHqX/XOaKRhewwEW7vqdCqcz7a4kbnt1wRNcji5DoGfoklrqbzT9IIveZbd4J5HCXgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NBkbFXFzz4Cpr+JyPstXQqhVemuVyzaVHKJWLwXbgBY=;
 b=NT9/YULbjiV84xuWYH2I+49v/5ZKUyVWNWp9Ezy+0JFcEs6eeo0RkZ18DkhPR4+OcsNSSDejoTAuSxeKBfUwEgo4vlmr/GVPiHIMEwQ1mPcOrbbp2Nka3hkxOklr+xe8yTl/ujiczN1TPLn2V6zo1PhkLUS8PSyFZtTSPW1GoSE1cdsLk+nOmybW0uc+MpOzho3m6mv0zfLc6Tdt+0ugeI513sXAG0ZgxADlnh06bAIBEVGmjEzyZ3tCTPkywaWgNYEpqhHY9E8dvpj+64toBTxi5SM3jLApwfew16LPH74ts2L7UvH2ULpYyx96mTrFEpMCYkFjFDvllge67YQnsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO1PR15MB4969.namprd15.prod.outlook.com (2603:10b6:303:e4::23)
 by BYAPR15MB3367.namprd15.prod.outlook.com (2603:10b6:a03:105::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Wed, 11 May
 2022 18:09:29 +0000
Received: from CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730]) by CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730%6]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 18:09:29 +0000
From:   Rik van Riel <riel@fb.com>
To:     "jpoimboe@kernel.org" <jpoimboe@kernel.org>
CC:     "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pmladek@suse.com" <pmladek@suse.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Thread-Topic: [RFC] sched,livepatch: call klp_try_switch_task in
 __cond_resched
Thread-Index: AQHYYjpsdFy2RMM8vk2xmmtLa5gGmK0WqGoAgAAVAICAAQUigIAAXfwAgAAkyICAAAZgAIAADJgAgAAUwACAAAnWgIAAEcWAgAA3YgCAAA7RAIAACqUAgAAAlwCAAAKWAIAAB0iAgAEcHQA=
Date:   Wed, 11 May 2022 18:09:28 +0000
Message-ID: <5c146997c0ae4869b55aa1b846e96005cda72949.camel@fb.com>
References: <6bf85ff908377508a5f5bcc7c4e75d598b96f388.camel@fb.com>
         <20220510165244.ikfh64ertnvodxb4@treble>
         <1bd15361edfd4db9fc9271d35e7bbe5edad1b87a.camel@fb.com>
         <20220510184213.l3gjweeleyg7obca@treble>
         <47440502-930F-4CBD-B859-3AC9BBFF8FC6@fb.com>
         <20220510230402.e5ymkwt45sg7bd35@treble>
         <D298A3F1-43A5-4FD5-B198-906364BF4B79@fb.com>
         <6c36c09fbf426280d13f6025f41aed4c65c042d6.camel@fb.com>
         <20220511003716.2lo6gkluwycvauda@treble>
         <bf682c8874a044a643becbb8704a4dfedadc3321.camel@fb.com>
         <20220511011235.f7cdkc6xn7redqa3@treble>
In-Reply-To: <20220511011235.f7cdkc6xn7redqa3@treble>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f8affc70-798d-46bd-f854-08da3379641c
x-ms-traffictypediagnostic: BYAPR15MB3367:EE_
x-microsoft-antispam-prvs: <BYAPR15MB3367021191B860316EAA2277A3C89@BYAPR15MB3367.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BtKjjdPXwh8SP2KGOplwbq0iF+xvxZgsKFwI7h4ZlgUHWEVtqNUQCa1hRC7dyVjxPgyP/eH9KO0tK6ZWn+2Ol3q3smZysaAlx+6EqORbaV1YEsCAadV7W0WbNExxy32uc92I4RfBm4TtNRdlafWSWIGBBc342O08SqoB+W1Lhsw8snoLDZRMqzwmbUnxor5ogFBDWnfO7y8L2Y6c1WrbRUfbDj7ByZ70gMi42rRsE4quvlSN0MoGI94YmiZ1MasXu3304eTsg/j2H08eEmxNk/T7ML49InPaJmOjNUeMeYrqMYOGTYNPx5DWLnqWjFX4tTrrFqF9PkNFmv5ubuFcNCum535VxJqdD9uzWDK1sgqQUHXy6AHOm89R0PA6V2YrtsZmLGe5as4WrS/dsbK9ly59rWuFKlo34O0TRIH6/9nmGpQLAJUhKKSjrgUrl80Rua2hudggdfYU70582Qr6APcXgwgRqVVbYhJSphtFKZ2+4FuTrSoJ2EbMSY24+NamtBkDW03cFN7zo/xXv/QpVePNaRDHUFClkbfXxc9lHCzBJyj2oCOi9kdaEvkxlGSzstgTeMKTNznwSOpQFVB7acFL7Npes8OuM0227iXLvpW6ZcjGz9JHgkqnd1ZxELVBm1UWgT77VGvKjNHr3bpj6bwhVKbbWfqv+2MordvlD0r0PhYRW3z4+9jJoQN2B+mpeXf7WByC2ntrFaSdXq1ZWQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB4969.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(38100700002)(122000001)(6512007)(38070700005)(66446008)(8676002)(4326008)(64756008)(36756003)(6916009)(186003)(316002)(66556008)(76116006)(91956017)(66946007)(54906003)(66476007)(2906002)(71200400001)(508600001)(86362001)(6506007)(5660300002)(7416002)(6486002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2lzYm15OHJDSjhsSzlrbmM3YVBpZmNQK1R1dEJQMllvMmNrcDZ5Q1hkUFNY?=
 =?utf-8?B?NmpXWXJNTXZPNlFQcmdmOVloblBNRVk5dnRNZDJkTUVHY1BDMExZYWUvU3ZV?=
 =?utf-8?B?b3h2Z0oxRjVEY3hmZmF4T0l5ZDE4NG0rUHVwcTYvRXhYWFVZcWdrZUdBbG9r?=
 =?utf-8?B?Y0ErTldhcHl4QlpyUDM4M1EwWkFSRkVJT3ZoVEJZRlduMzh6RzNOcnhURzJX?=
 =?utf-8?B?UElCdHR2d1hhVFQ5NFVlK1dSKzZlOERjYkhpKy9BY21yWkVYaUJtYzJsenZo?=
 =?utf-8?B?T0dXVDVOdGhHK0ZlYnNaUk8zVVFYbTVRUUdMaEpLUFhoTkxJVFAwUVpXdnY2?=
 =?utf-8?B?cnQ2SnRTYlA2T2RSblVtRlVkbGNqb3NyVm5rRy9DM0REYS9uZXN1K2szd3NW?=
 =?utf-8?B?OW5mckNRSFc1RXA2VFJvU3BVUGtEdXBnWjRDOHNxMzJpRFE4cVBOL0dJbUVa?=
 =?utf-8?B?UnJhalc1R1NNcWdZZC9GUExhMzRWNmFIOHh0bmZmdm42RCtQa0paOThlakZj?=
 =?utf-8?B?LzcwSk1GdkVOUzdoTFdBL2M1M05BZmovZWZ0TVc4YmxWWkxkL2pvNHRZYlU0?=
 =?utf-8?B?azcyUTMyRDZKelNLUjF1UHg3YTJTNnZINXhZZlViSEhXMmtncTQwc1NjeUsx?=
 =?utf-8?B?bXIzTkViYVVVTUJLQlVmNHVjcXJIVW9xeHY0WGRacTJSeG5LWWpRSUoxMGN2?=
 =?utf-8?B?eDB0Qk1vS0p6VU9xQ2pSdTN3L0kwckhYTUhSUHpreEoyQWxGOWZyWkJpUHll?=
 =?utf-8?B?d0xDZWpRRENQOVAvU1VxcTV2bHlPK1pFWUQxQnBIQk95RXpneW9yN0hmdlB0?=
 =?utf-8?B?NWhHcDhoTGwzKzNpRzFaelJkRmplTWVIN0NtT2xIajd3K1pCczkwNk5zZStC?=
 =?utf-8?B?elVZK2JGNUJxZUFiTkxVejFFaER2RFJ4b2N1LzhhemFhWGpGakg4TVRNc0VG?=
 =?utf-8?B?RExvNEZhYnZ6c25nam5QYUh6b3FVS3ZjQjh1UTNYOFpRRVdVTUwzcEtMQnpy?=
 =?utf-8?B?ZlU4RXoySE9jQ3gxVHRlRnZiUXhzbzVWdXdiSDdKNWF2b1daWnpYRUNaWE5V?=
 =?utf-8?B?YVlKOWsvYktraWFZK0Q0QmtibXR3ekxNWlg3dmlYWHRBcm1EVEVXVmYxSUpm?=
 =?utf-8?B?TFF3T0pobjVsVytWTHdDVGdKTWJ3WjQ4dDRKL2Y5T2hwT2dCcWJRNXIzQkkr?=
 =?utf-8?B?ZDJvK3dITS9vR0lUQlpDYmtobFNKYkR3bHZER1F2VkNKVWNmc2g1c1RFUUp0?=
 =?utf-8?B?VXJBM3FxMWFHKzNDVTNqa2xqRm90VFowYWg5NGV2b1VUZ0xSb01wRHg2WDhV?=
 =?utf-8?B?aEVhRklwQlhYS3BaVE5TUEpmeUMrdUdhdUhnUG11V3hiRldSQTJ5ZzB1cS9O?=
 =?utf-8?B?b0R2VEltTkRjVTA2Ym85ckVaUWVpZEFvUGhEeVZwZmxUUVc0RnZER0psVXJh?=
 =?utf-8?B?RjJqWGVLQlR4ekZUWjkyaHRUSTA2eEJDNk1POEFzQXFVU3ZaaGUxcm11dmww?=
 =?utf-8?B?MTV0Q0VNOG50K0wxNGhtTElCMHd1Nk1ydjh3UzJUTFhjRkJhYzIrMlREdlo5?=
 =?utf-8?B?a1F6bXZsNVRaNFppeUdUcVFWOSsvM0wrQTRyb0FJUXhiaGh2T1lseEkvUUNJ?=
 =?utf-8?B?RkFRa3FxM0FESllQdCtESG9aRDlGcE9McnAyTlBxbmJzcE01OVE0eFhybFJN?=
 =?utf-8?B?TEsxMDd3WVdTVUMxald3S2xvK2tYOUlCeFhxWmtpZ253L29VSW1nRVJram03?=
 =?utf-8?B?YjBybUgxWnNGQlM3a01NZWQvUnBIMXlhN0xJbUo3NDI5SnVESTVQMVFYQmVH?=
 =?utf-8?B?MkJ5alNoZ3FKNXZsVElIVmtvaGtNMi9WREp3RWxNYlhRblMzVTBMREdFcmp1?=
 =?utf-8?B?c21xeWJKK1pWSEV2bFRpY0o4OXdTdEQ1ZjNyS05XdFA2UTF6KzZ4U3pUZjFs?=
 =?utf-8?B?Q2ZwN2wxOEw1RlMyaXVVMzE0MTFHQko5eEYybm5TRWtBcWZVMlIrRGQxV0d2?=
 =?utf-8?B?MkR4c21RbjVDQzNDUTJFS2p5OS8yMEdiTTZkZDNMeWVFU2VaZ3E5SkxPaWt6?=
 =?utf-8?B?WUlXSW52TWg0TllpYUhvVitGbWpxVzR6dU9OQVdzcGxIaXd2NXpkSnp6aWNw?=
 =?utf-8?B?bWkyZUZwUjZ3S0c4bVh2bXkwK2NUQkJwT0V6RWF3bEdlcDduUStWRXAxT3VG?=
 =?utf-8?B?dEtBZXBWZDNTU3pNYlp4endZS3V1NERFYnJYQ3RRVjM0d3NFem96bkU4bjBo?=
 =?utf-8?B?NkNMcjd4bUlKNDV0L2IyM3R3dGJSRU9kNG1KZXJnRDBzNzA1bkgxdW9LbldR?=
 =?utf-8?B?SkVtakxBb0RMWXNEcnVZTXR6UW5jczJaUDRyTDJ3a2J5TUNDTTlyMXZCY2Fw?=
 =?utf-8?Q?VwRdGR0LTpbpr5rs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4CEF291948ACED47A274E687DAF77793@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB4969.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8affc70-798d-46bd-f854-08da3379641c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 18:09:28.9713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 42qBCEVvTaNjojXcpvVg903S/oVPLhFQil/1N7LjWXmeLaKon3Qq0/8l8Z836+IA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3367
X-Proofpoint-GUID: awen5JaDw5ibK7wzPzfqTVJYwwuHW7ql
X-Proofpoint-ORIG-GUID: awen5JaDw5ibK7wzPzfqTVJYwwuHW7ql
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-11_01,2022-02-23_01
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

T24gVHVlLCAyMDIyLTA1LTEwIGF0IDE4OjEyIC0wNzAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cj4gT24gV2VkLCBNYXkgMTEsIDIwMjIgYXQgMTI6NDY6MzJBTSArMDAwMCwgUmlrIHZhbiBSaWVs
IHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyMi0wNS0xMCBhdCAxNzozNyAtMDcwMCwgSm9zaCBQb2lt
Ym9ldWYgd3JvdGU6DQo+ID4gPiBPbiBXZWQsIE1heSAxMSwgMjAyMiBhdCAxMjozNToxMUFNICsw
MDAwLCBSaWsgdmFuIFJpZWwgd3JvdGU6DQo+ID4gPiA+IE9uIFR1ZSwgMjAyMi0wNS0xMCBhdCAy
Mzo1NyArMDAwMCwgU29uZyBMaXUgd3JvdGU6DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gU28sIGlm
IHdlIGNvbWUgYmFjayB0byB0aGUgc2FtZSBxdWVzdGlvbjogaXMgdGhpcyBhIGJ1ZyAob3IgYQ0K
PiA+ID4gPiA+IHN1Ym9wdGltYWwNCj4gPiA+ID4gPiBiZWhhdmlvciB0aGF0IHdvcnRoIGZpeGlu
Zyk/IElmIHNvLCB3ZSBhcmUgb3BlbiB0byBhbnkNCj4gPiA+ID4gPiBzb2x1dGlvbg0KPiA+ID4g
PiA+IHRoYXQgDQo+ID4gPiA+ID4gd291bGQgYWxzbyBoZWxwIFBSRUVNUFQgYW5kL29yIG5vbi14
ODYgYXJjaGVzLiANCj4gPiA+ID4gPiANCj4gPiA+ID4gVXNpbmcgdGhlIHByZWVtcHQgbm90aWZp
ZXJzIGR1cmluZyBLTFAgdHJhbnNpdGlvbiBzaG91bGQNCj4gPiA+ID4gd29yayBlcXVhbGx5IHdl
bGwgZm9yIFBSRUVNUFQgYW5kICFQUkVFTVBULiBJdCBhbHNvIGRvZXMNCj4gPiA+ID4gbm90IGlu
c2VydCBhbnkgYWRkaXRpb25hbCBjb2RlIGludG8gdGhlIHNjaGVkdWxlciB3aGlsZQ0KPiA+ID4g
PiB0aGVyZSBpcyBubyBLTFAgdHJhbnNpdGlvbiBnb2luZyBvbi4NCj4gPiA+IA0KPiA+ID4gQXMg
SSd2ZSBiZWVuIHNheWluZywgdGhpcyBpcyBub3QgZ29pbmcgdG8gd29yayBmb3IgUFJFRU1QVA0K
PiA+ID4gYmVjYXVzZSwNCj4gPiA+IHdpdGhvdXQgT1JDLCB3ZSBjYW4ndCByZWxpYWJseSB1bndp
bmQgZnJvbSBhbiBJUlEgaGFuZGxlciwgc28gdGhlDQo+ID4gPiBrdGhyZWFkIHdvbid0IGdldCBw
YXRjaGVkLg0KPiA+ID4gDQo+ID4gSXNuJ3QgdGhlIHNjaGVkX291dCBwcmVlbXB0IG5vdGlmaWVy
IGFsd2F5cyBydW4gaW4NCj4gPiBwcm9jZXNzIGNvbnRleHQ/DQo+ID4gDQo+ID4gV2hhdCBhbSBJ
IG1pc3Npbmc/DQo+IA0KPiBNYXliZSBpdCdzIHRlY2huaWNhbGx5IHByb2Nlc3MgY29udGV4dCBh
dCB0aGF0IHBvaW50LsKgIEJ1dCB0aGUNCj4gaW1wb3J0YW50DQo+IHBvaW50IGlzIHRoYXQgdGhl
IGNhbGwgdG8gdGhlIHNjaGVkdWxlciB2aWEgcHJlZW1wdF9zY2hlZHVsZV9pcnEoKQ0KPiBvcmln
aW5hdGVzIGZyb20gdGhlICJyZXR1cm4gZnJvbSBpbnRlcnJ1cHQiIHBhdGguDQoNCkFoaGhoLCBJ
IHRoaW5rIEkgdW5kZXJzdGFuZC4NCg0KRG9lcyB0aGF0IG1lYW4gaWYgdGhlIHNjaGVkdWxpbmcg
b2YgdGhlIGtlcm5lbCB0aHJlYWQgb3JpZ2luYXRlZA0KZnJvbSBhbiBJUlEsIHRoZSBLTFAgdHJh
bnNpdGlvbiB3aWxsIGZhaWwgcHJvYmFibHk/DQoNCkhvd2V2ZXIsIGlmIHRoZSBjYWxsIHRvIHNj
aGVkdWxlIGNhbWUgZnJvbSBhIHZvbHVudGFyeSBwcmVlbXB0aW9uLA0KZm9yIGV4YW1wbGUgdGhy
b3VnaCBhIGNvbmRfcmVzY2hlZCgpIG9yIGR1ZSB0byB0aGUgdGhyZWFkIGdvaW5nDQp0byBzbGVl
cCBhIGxpdHRsZSBiaXQsIHRoZSBzdGFjayB3YWxrIHdpbGwgYmUgcmVsaWFibGUsIGFuZCB0aGUN
CktMUCB0cmFuc2l0aW9uIG1heSBzdWNjZWVkPw0KDQoNCg==
