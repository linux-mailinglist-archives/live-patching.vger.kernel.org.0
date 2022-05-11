Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24EA3522896
	for <lists+live-patching@lfdr.de>; Wed, 11 May 2022 02:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiEKAqi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 10 May 2022 20:46:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiEKAqh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 10 May 2022 20:46:37 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCE548E42;
        Tue, 10 May 2022 17:46:36 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24B0aZQ4004989;
        Tue, 10 May 2022 17:46:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=yoyKMiPi1wetcAD+akcsiRfr9PyiXMG/81zxgG04byA=;
 b=TQsGC/7Sf5hFnrJ/4cy1XQYaThcnCKwqbIz7Blr+BfAz3Ww0JRGiZRLyH2Q1MQm/eesf
 JOTnkGF3KNigZVFvTjqeNLETArw0xNvUMpxYXWpLEjU8FZXcCDJ9CY20kNXV5NzpZAxa
 MeAhVbRcp7yWmc8bq+poVzoJnJdQkPrJ0a0= 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fymp4e5gq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 17:46:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aiZdfy54v8xu7TpoKrggjUyqitseO6s2AlFfnwwZQ/MHVq0HRW2Tdrg790DZ4iGB4B6i/OkCyRq23rAUp8umi9MspSaaNjAl5kpBDhTwGU7q3jMsn7QBnXbbVvGnPbv2TUi9Yv5HMq9SROgKuh6Zb0EG8T07rxiHLuJlLGxZfTJAotKAQHmEXFoJbakoSzog9Dbt1k+LnvewgT245qpQs7c+gbTnrd9IAjjOpBvdkvoj25beUFQnlcBTF2M0hUuygwU8l5Aad7JhXDFk02PWzEtEv3uqDWwVrHAO13YsXugBg7MZQlQ/u0uGtkeoQYThPIJGDE2/7rCPDaNML/2zkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yoyKMiPi1wetcAD+akcsiRfr9PyiXMG/81zxgG04byA=;
 b=LYbfaAvAWlj5y0nQcriqdNgjGiptCkKtiHvHsNqHkXp2q5FgIha96bXcaEjKOADkTT7wsNfzh6V5l4z1SRXya81rycNxrm3VvQZSkJVHVm1HI+f4N+d/3QLgHE+lgi1Sk3RX2VGKYJ9zueeGZHdcu/havUXcVPUOnu9SZoRcMqbzjgu/IC2ZsaqB40cxX0Gea4sT0S+MYJ7EqrLztG+c0ncRe/3v84PLD/Sn7PwdZEDeE/4Z1OdznYOolxOoh6Hu85Mbo98zIqCMQIw5oimlzsKrwIS5oaCDA+VZXZMOwuH/+FDGzN8d9Xwqtkvh8rpKgJ9gVimJuyt5UTE76AAGGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO1PR15MB4969.namprd15.prod.outlook.com (2603:10b6:303:e4::23)
 by CY4PR15MB1224.namprd15.prod.outlook.com (2603:10b6:903:10d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Wed, 11 May
 2022 00:46:33 +0000
Received: from CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730]) by CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730%6]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 00:46:33 +0000
From:   Rik van Riel <riel@fb.com>
To:     "jpoimboe@kernel.org" <jpoimboe@kernel.org>
CC:     "song@kernel.org" <song@kernel.org>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pmladek@suse.com" <pmladek@suse.com>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Thread-Topic: [RFC] sched,livepatch: call klp_try_switch_task in
 __cond_resched
Thread-Index: AQHYYjpsdFy2RMM8vk2xmmtLa5gGmK0WqGoAgAAVAICAAQUigIAAXfwAgAAkyICAAAZgAIAADJgAgAAUwACAAAnWgIAAEcWAgAA3YgCAAA7RAIAACqUAgAAAlwCAAAKWAA==
Date:   Wed, 11 May 2022 00:46:32 +0000
Message-ID: <bf682c8874a044a643becbb8704a4dfedadc3321.camel@fb.com>
References: <3a9bfb4a52b715bd8739d8834409c9549ec7f22f.camel@fb.com>
         <YnqIcw+dYsWz/w7g@alley>
         <6bf85ff908377508a5f5bcc7c4e75d598b96f388.camel@fb.com>
         <20220510165244.ikfh64ertnvodxb4@treble>
         <1bd15361edfd4db9fc9271d35e7bbe5edad1b87a.camel@fb.com>
         <20220510184213.l3gjweeleyg7obca@treble>
         <47440502-930F-4CBD-B859-3AC9BBFF8FC6@fb.com>
         <20220510230402.e5ymkwt45sg7bd35@treble>
         <D298A3F1-43A5-4FD5-B198-906364BF4B79@fb.com>
         <6c36c09fbf426280d13f6025f41aed4c65c042d6.camel@fb.com>
         <20220511003716.2lo6gkluwycvauda@treble>
In-Reply-To: <20220511003716.2lo6gkluwycvauda@treble>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 517ad3ba-707a-4f6a-6e5d-08da32e7b1ea
x-ms-traffictypediagnostic: CY4PR15MB1224:EE_
x-microsoft-antispam-prvs: <CY4PR15MB12247B79BA8AD607472F904DA3C89@CY4PR15MB1224.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KKJO9M4sWLnsugm5iBoTE1lB6g+f2DevWa1RLD3xzTaUPdRAXs6u496pUhFxfRKQDFI/aJfMHscsXhHpbLpXEDteiGJVeFbeMYz1MuK/Q2GSun+3JB7LosBE70YbxHpNzJyPUJ6wn/xPe8+mpt6G5kdKs7ECySO/SHqRN+GG5e0M7+e9xX/3fZ9CEGRGrqsFJn2rLsn6JCT3GRg5z1NVXOGzuiN02YkbKd+iuTVgDlDC6tUFyJXyRePjw3qoKyu8YZ4UNeyOQpEA4Pm+30HCyvRrtjrFxdx36HTTUFbv9K78JzDiCPpLpNEvERdM54tcL3VcFy+3jhhlDhqbmJMBHtf8ZvOnGS0GL4f3V4G3M8PYzORW8DTW3FqLnBaiW7VfX4s3uCSuI5w1TDjvXs5ENoVZXKAdrni9BQ22orvnBMlW605dgT8rNX5xOJ9IU4aIg/yFvQ13w82V3vF69DGiFa3d023vEYb9rNv723TY3EmB1hddLgOoNp16NvwDTBSN5AwEJAgcPVZHB+YCBTIXQgLcgpxwDNgKrCBTtq3sf5F3Pm929SoWdnX+ZjzwyfaVPVE9gsWAeKxpalDU0n+3roV55Npu670MJFB0VfbDkTmxRhPWjFVeF5YbsVL9MSDo6K9uL9t3Qn1AknW9Xuco6AhhfQv+e/m+k+5/puOKyRGsC8Ne6dwVLnCzWoIstWYUI1MK93+w2vSYKNkuXIG2eQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB4969.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(6512007)(2616005)(38070700005)(122000001)(36756003)(64756008)(8676002)(66446008)(71200400001)(4326008)(186003)(6916009)(66556008)(76116006)(66946007)(66476007)(316002)(54906003)(91956017)(508600001)(5660300002)(86362001)(6506007)(2906002)(7416002)(6486002)(8936002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TEF1VHl5RC9Rc1RCSUJqQWhVNGgyalJYaG5PUnlTYTk5TkZTTHZ6ZHhRUDNa?=
 =?utf-8?B?ejV5eFUvVEJnZjJUc0hXMDdtRGNmRGs4U1FaT1hDZzYxK0JPNXlyM0lxdkRt?=
 =?utf-8?B?dHlpejQ1em55SXp1VEswUmJ5S2VLQ0Z2ZVlvMDFzLzhSbTlnS1ZwVnhJeDk5?=
 =?utf-8?B?OXFMQ2hEZEs1VjJ1Rm8ySmdYQ2dJcXJybFV2UEJiVkZBMjZkZ0gvOEhrR1ph?=
 =?utf-8?B?Zlg4RTFIc0lXNTBadXg2aUMvdFZmL3BWQ044bUZ0NVY5SkNxNUcrSEl5VHNq?=
 =?utf-8?B?RlpUSmFNRlRCSXBUSXpIK3NNZUY3UndZc0NybHh3aUNkSlV0MlpLVUxaRmpQ?=
 =?utf-8?B?L0lvTUZFK2RmR0I4QXhzSmNjaS92Y3NSUHpkTUhnVHVLOC9HdExFOVJSR2Vl?=
 =?utf-8?B?ZEtyR3A0cTBDYllrWFJFWmFaR3hMd3dydDkwVlRHMVdwMy9LaXQ5WWdmMW55?=
 =?utf-8?B?WW41Z0RmdUlERnNlRnVYNU5UdUI2V0FaVE1YMVJNNlVGR1JCQXlCSWVYT3I2?=
 =?utf-8?B?NzR3ZDN0Q3JnTzBKcTB3dTNrc3dDM3RPeWJnUGFKUm1IMnd1TmVqMGlQRWty?=
 =?utf-8?B?bnFmUXMybVdTVVp5R2c4eEhUTEduL3VHdy9oempNWHlGT2s3Vi9wZysvT1Bi?=
 =?utf-8?B?NGpwTjM2NFVwQ0Z3Z0JxRDZzamowRkZiVWlmYUhqeDgrejJmcWlmaGQwKzhk?=
 =?utf-8?B?V0FnU25OeUpRTmZybGU5RE90WGU3ejhvZ0VOdXJ6V2gzK3N5bVZRajRCRHdX?=
 =?utf-8?B?elpLcVJmV1kvckVSb2tDYnBZQi9QY1NGRVhFendMSzdjQU9sWDVidHoxbkNF?=
 =?utf-8?B?Y1RCbFV1bklZMUZ5OGlZRm9Nam1RTG4wUzdGeEVXOEdrUW1IQ1J2WVpRV0gy?=
 =?utf-8?B?aEpJZXNrQ2pFZW1tNjRHOEZXclZZZExXeGpneE1YeTI5Q1AvSFFDd1lQNXAw?=
 =?utf-8?B?UlU0QTZNeDh6OWFEbmVXREpnUVJlMnAvSDVBOE1OWlZHalJhaTBvTFpnSlF0?=
 =?utf-8?B?VUJsMFNxSVpYdGs4QTNuSE9Za0xTNHFucUFFUzdjZW1zb29DQ0IwTkFqeWEv?=
 =?utf-8?B?SWIxbThYcUl1djJJOXlhelNtZjd4Y0FFN3RlVmJmUjJKYngxcURpNUpRQTVV?=
 =?utf-8?B?RWMySDdZNnlWRG8wc1M2MmlBL0dvbTNzQXJBblFGOXJ6TXRhd2Fzd3NNcTI0?=
 =?utf-8?B?cERHcnBoOU9qQ091Wk9FVXFGK2Jxbm0rb0VMZkx5ZE1HbVcyMzhQWTZreVg5?=
 =?utf-8?B?V29FeHg3bU5Vd29mQ2g1eW5aT3NYQjdmTSt5amE0SitmbnR0cmNiL3JkU1B3?=
 =?utf-8?B?Z2VZMDhnNlNLR0tTSnZOMTJWb0s3Q3N2eGE2d3FFYkhvcUNYbnZrbzljM0ZR?=
 =?utf-8?B?MFhpWXNjZjkyaCtpT3hvTGxqL3U2aWJCZlg4elIvTUkzMld6QXNzSHE3djNZ?=
 =?utf-8?B?aHEzTUpNQTl6bGtHcm1LRTNqdlM2d0RuaWswY2dpRmpHLzdKMVhSblVZVTFW?=
 =?utf-8?B?U01IWDlja0hsNVAydjVyaXZ6cUxKSG9sWkVGTHRWbFBSWlFVUUxOeElCci9z?=
 =?utf-8?B?KzFpQW1oeS9ReHg4NVJ4aW9vdzQxNFpUdFJhT2hZcERFak1MZlhPdmtPYmxu?=
 =?utf-8?B?U3dIRWVCdTRYeEU4Z2JCL1ErTTZkbnoxVjdzT0pZYkcwTHljMzlpcDNnMG45?=
 =?utf-8?B?c1pYelB4UzN0RG16SE5ud0s5UFRzWWs1WUVMbXBvWmNlUDJKdnBNdDlKQVVL?=
 =?utf-8?B?MVBtMzMwb2ZRUWpzcC9YdDFiMzdhOHRvZUR1enU2dGdpaC92SjJwMFY1aGk5?=
 =?utf-8?B?MktFWUpWYnFOaHpiUUJKclJSczd0SWE1alJFYzFWTDZWUmQrUmpIaXRxbnhG?=
 =?utf-8?B?NXBmN0xGclVmUXgvc1VGZ2xGL1p4K1R2Z0NIajNwT1NHYS9KaFJNd2RoTGhs?=
 =?utf-8?B?VFlkMnNHTHRTbFZoR1BGWjU1YVpRRnh3ZW1VY1BLZnVLcThWa2NsaHU2bmJD?=
 =?utf-8?B?ZG94ZDUxNW1mWUJvYkltUDhxU1NuY0RJUTJRM1A2OTIvWVJkV0srN1FOaXdS?=
 =?utf-8?B?ZlRvTGJpWlpiMHBYZ3FxZE8zY1NHYk42OHNSQnJkekFGQzBXaDMyVThUN25n?=
 =?utf-8?B?RkM3ZUdBa2piN2cyNzFGMndyazd5Q1hTMTNmc3B2OXFmcmU0ZW9yemYwcFlL?=
 =?utf-8?B?ak9nOUViT2h2cEQ4clVPUG0rNFZXL0h5UDRIbmdmV1ZXY0d1bnhuTkpEa0pr?=
 =?utf-8?B?ZnpNNDBBbWtBRWZRYko4M0o1ZDdVMWV5N0NnSWQwRDdsMk1nZEpza2pqQStN?=
 =?utf-8?B?R2hFTXVoTFE5S21lZ1FtbXppMW5wWFc2YXZXUnBtVEM2cW1jTEdROW9TeXZj?=
 =?utf-8?Q?JSAMd+kEsCSNYQLM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <92BC0CE81726544A8D828E2B23037CF8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB4969.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 517ad3ba-707a-4f6a-6e5d-08da32e7b1ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 00:46:32.9642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cQN8IgrqShSUGFAnzNwA8tYREdEzOaUoPz3cNGIhT4cfWNH6ROZyb3tuq6egI8HN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1224
X-Proofpoint-GUID: -w7bfGNH9xfHeM-hgD02VQoiD0_Hy9KS
X-Proofpoint-ORIG-GUID: -w7bfGNH9xfHeM-hgD02VQoiD0_Hy9KS
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

T24gVHVlLCAyMDIyLTA1LTEwIGF0IDE3OjM3IC0wNzAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cj4gT24gV2VkLCBNYXkgMTEsIDIwMjIgYXQgMTI6MzU6MTFBTSArMDAwMCwgUmlrIHZhbiBSaWVs
IHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAyMi0wNS0xMCBhdCAyMzo1NyArMDAwMCwgU29uZyBMaXUg
d3JvdGU6DQo+ID4gPiANCj4gPiA+IFNvLCBpZiB3ZSBjb21lIGJhY2sgdG8gdGhlIHNhbWUgcXVl
c3Rpb246IGlzIHRoaXMgYSBidWcgKG9yIGENCj4gPiA+IHN1Ym9wdGltYWwNCj4gPiA+IGJlaGF2
aW9yIHRoYXQgd29ydGggZml4aW5nKT8gSWYgc28sIHdlIGFyZSBvcGVuIHRvIGFueSBzb2x1dGlv
bg0KPiA+ID4gdGhhdCANCj4gPiA+IHdvdWxkIGFsc28gaGVscCBQUkVFTVBUIGFuZC9vciBub24t
eDg2IGFyY2hlcy4gDQo+ID4gPiANCj4gPiBVc2luZyB0aGUgcHJlZW1wdCBub3RpZmllcnMgZHVy
aW5nIEtMUCB0cmFuc2l0aW9uIHNob3VsZA0KPiA+IHdvcmsgZXF1YWxseSB3ZWxsIGZvciBQUkVF
TVBUIGFuZCAhUFJFRU1QVC4gSXQgYWxzbyBkb2VzDQo+ID4gbm90IGluc2VydCBhbnkgYWRkaXRp
b25hbCBjb2RlIGludG8gdGhlIHNjaGVkdWxlciB3aGlsZQ0KPiA+IHRoZXJlIGlzIG5vIEtMUCB0
cmFuc2l0aW9uIGdvaW5nIG9uLg0KPiANCj4gQXMgSSd2ZSBiZWVuIHNheWluZywgdGhpcyBpcyBu
b3QgZ29pbmcgdG8gd29yayBmb3IgUFJFRU1QVCBiZWNhdXNlLA0KPiB3aXRob3V0IE9SQywgd2Ug
Y2FuJ3QgcmVsaWFibHkgdW53aW5kIGZyb20gYW4gSVJRIGhhbmRsZXIsIHNvIHRoZQ0KPiBrdGhy
ZWFkIHdvbid0IGdldCBwYXRjaGVkLg0KPiANCklzbid0IHRoZSBzY2hlZF9vdXQgcHJlZW1wdCBu
b3RpZmllciBhbHdheXMgcnVuIGluDQpwcm9jZXNzIGNvbnRleHQ/DQoNCldoYXQgYW0gSSBtaXNz
aW5nPw0K
