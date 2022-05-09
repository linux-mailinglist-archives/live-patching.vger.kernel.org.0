Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B5451F276
	for <lists+live-patching@lfdr.de>; Mon,  9 May 2022 03:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbiEIBdn (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 8 May 2022 21:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236149AbiEIBLq (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 8 May 2022 21:11:46 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62F6BF6A;
        Sun,  8 May 2022 18:07:54 -0700 (PDT)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2490AcSu004331;
        Sun, 8 May 2022 18:07:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=lsk2iUXikLB26LfYahvdkH5fH8aIyY1iDG/agR70BJ0=;
 b=loAa9zRiRGtsyD55EISRMwNI2n0g5q634ZTqQsLLuc1iCSNIjDZu41EK5NoltcB8if3g
 7elZCZuBXECWt0BzKtbsPlQrMsIHKimbmerMc2ZmAxYK030v5kqwVuV3psZe+mfuWO7I
 j4CyoGW33Nt0R7hsFl4Em5CLHtkfmNtipTk= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fwr33dkpq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 08 May 2022 18:07:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQZ7GHC6Lw35e0wxLvwImfr0wBbUZqwKYywVzjCyJ2gBMTmxxlk8uyIgDwHMjPi8rns+Pl3Jm+8kjZryr4hnMHAZPjSEgt7I+1ARCXLI19kW4SExOw1zXH3Volmy4n3O8BHapfgQiuGxcVKrPaJdE8ZkccnDY1NughA90vkbNvpotgraAc3Vy4Lz8Lg4XXGVcYUP9uZyEvI914gGkaQ+9zFOSVgYDAMwCzDEJ3k46cofmtxrhfF34JbWWwPFN7PrD4Y4+po+yJzsqjDsBatu6p6Uqzrzx+gn1W5KACXGtIPfTRYiq9yEQ3owZk+Edl1aRl6fOqh82jSSu+J7HEbGlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lsk2iUXikLB26LfYahvdkH5fH8aIyY1iDG/agR70BJ0=;
 b=AfIh5WSLKh9xg6wSRl/eMUvmJQaotttdFvi6oGrC7L3U2hD9MP14UdYCJu+CCdppKNI6YrR7H0de8Pl7UjcIc6avUkMIc/cn+ECtTD3bpOqcbNaEdq3Osbjk+01EJPWxl+1Fkzdhgldzy6kcBhLQhSjDK5DA+9UUnWilrmHMUXhfFqPu4kQ7wW+ytmjzT/qFa0AkQZFxd+U7Qbwmb/1ke4S03ohHbmtlxeM91QNDIYkrSPwe3gGdaCOyHVIgVVKwltdQDzkMzJCKQMyTeqqnk9gcLrdyev+vmQYK3B8UBMLTZ5AeDZN0G5PO7+DUpgldcgRUPBBA5Yu/T3tve332kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from CO1PR15MB4969.namprd15.prod.outlook.com (2603:10b6:303:e4::23)
 by DM6PR15MB2747.namprd15.prod.outlook.com (2603:10b6:5:1ac::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Mon, 9 May
 2022 01:07:50 +0000
Received: from CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730]) by CO1PR15MB4969.namprd15.prod.outlook.com
 ([fe80::dde6:b4a5:be4e:b730%6]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 01:07:50 +0000
From:   Rik van Riel <riel@fb.com>
To:     "peterz@infradead.org" <peterz@infradead.org>
CC:     "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        "song@kernel.org" <song@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>
Subject: Re: [RFC] sched,livepatch: call klp_try_switch_task in __cond_resched
Thread-Topic: [RFC] sched,livepatch: call klp_try_switch_task in
 __cond_resched
Thread-Index: AQHYYjpsdFy2RMM8vk2xmmtLa5gGmK0Tu5yAgAAKkoCAAAPtAIABqUuAgABKi4A=
Date:   Mon, 9 May 2022 01:07:50 +0000
Message-ID: <2202e0d211338d7641046fd8f05608b0dbaf7f78.camel@fb.com>
References: <20220507174628.2086373-1-song@kernel.org>
         <1b7f0b76b6060b6a0ccd04fec2be6c0323907c8e.camel@fb.com>
         <36BA01F0-F2B7-4290-AB23-E61989262AB3@fb.com>
         <901aa9a48ef02eeec73dedf051dd0b14436ac22f.camel@fb.com>
         <20220508204101.GB76023@worktop.programming.kicks-ass.net>
In-Reply-To: <20220508204101.GB76023@worktop.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac7a2c1a-1cff-47f8-73e0-08da315856bd
x-ms-traffictypediagnostic: DM6PR15MB2747:EE_
x-microsoft-antispam-prvs: <DM6PR15MB2747D3F08D75309A43921681A3C69@DM6PR15MB2747.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5bYitXyS31r/F2uNpTFLIYwlhhFKWgJhsWNJ6xBnJGnA497NKCa6SECmRm3C0OTyHYDqI0cYuvisQuKGWGIuFggiXGpCLY+Fzdzb33xjw/A2uFhJxwy3Hd/Qdqcd1Q2oRA5XbgGslr7HRcgXkhB5LY5ZqJzMUH96R+TONol5ni91Q9uHRJaamwbqhCNtr+nVU8py+vLH8xg/j590ZmKtCTpqcZUfaDLNLWdfswHD1w0DDcjX4/0W1ha1WVYHLf1/WAQlgOGG3zuRX9YXVKwMx7wZwH8VD59OLYAH4PLuIC+d6za+XF0RHeVr3x7tdY0a+N0lB+Uz1VjqcFWWq/IaPtM/ICuvdDUcZm/3gWncNnJXGOe3uJLqXhZM9FsG6e1F0FJHWsm0OT21b55VJEOyH32VZMY+j55IM4uaAT7v5gERVXRziYcrbeGeULH48cyfqSfaQ1mgmOc41tX3/lnK3qZboxH9Puctv0JjSJV9V+rAyPUQM7W/G2If/2QUz38LxikrgQAsq/6KB1PUPWAoOPgBByHQNLr4IqszLGySkYcHp81OVza/PYBm2of/yY8YSidDyNNG9t6luGhvtAUx/pNY8dEWbbavCIjsLUY2L3u0iTc3owpwaTwoKGAs2V1j/BOQA6+ELhjOO6GQvBR9k9cyrzNXiOsKbNRLxDTVlJ8ikzcheo5aErBdwjrGnXSTavb/ngRyk/mVFMO0D39+6Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR15MB4969.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6506007)(71200400001)(6512007)(122000001)(4744005)(5660300002)(66556008)(36756003)(186003)(2616005)(2906002)(8676002)(8936002)(508600001)(91956017)(316002)(38070700005)(38100700002)(6486002)(76116006)(66446008)(66476007)(64756008)(86362001)(66946007)(4326008)(54906003)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2JpeGpGZHBieGY2d1FOUm9Na0hRVVZZV2dFVU1VWnNiek9zU1lkUXBpN1Ix?=
 =?utf-8?B?UTBFRmI1YUVSaXFEa3prTmxZYUZIbXpQL0krSEM4bE1nZUdISzFJL1hQS0p4?=
 =?utf-8?B?REVucmRMTGNXOHZ4d04zQ2JidllPZzdHbWhLMEVqUkRHQmN2cUZXV2NRVDhY?=
 =?utf-8?B?M2RTdlExMUpCRGxEWHN6eWcvTWdubS9rQm1TMFI0Ky9SL2RTa1NlbVJGcG9Q?=
 =?utf-8?B?M0dZVkRVQitOZXUwdFRuQnZJNDdCcGRSK29JUHNXVXM2TllSUXROVWxuUzRX?=
 =?utf-8?B?MDI1dDBwc05CWjZPNWswU2NOK3B1akoxUjdqb3l4TS9XVVI0cnpNZUhUOEtO?=
 =?utf-8?B?RCtjOE5HNkthK3J6REkyZUphK3BDODRGYnBMYmZMSTJGNGRVTWNNUkVNZFFs?=
 =?utf-8?B?YjZqS2VnVHF4MklzcmNLWUFLQW5nV3RCMmErOUhBRFZqSEk4b2JzT2FUOUty?=
 =?utf-8?B?WDJ1YTRtREE0UTMxTFIvN1N0cytjbm1mOGhFQ3NLWUdSYmE0Vi9zMWV6aXlO?=
 =?utf-8?B?ZzI3NkRheXVYTWNLQkNwNDhURFZibzcvRm05aTljZDhobEN5VW4xcng2bHQv?=
 =?utf-8?B?NGdMNmF5c3FJaVB3TVlaZW5UalJvNlFsN1k3SHhvOEtPVmN1eG1WWTYyeU1K?=
 =?utf-8?B?MVc1bFpCQ3dhNDg0QTRRcGRPK0FlVmQxNk5PUVpGaE1PcHNMUE4zQ3BubEZX?=
 =?utf-8?B?c3VBVFFXcE4ydy9TYnpPTTB6NC83N1VTMDcwYVZVb2RwVHBpb25ZdTBxbXli?=
 =?utf-8?B?Uy83NnRvcmxxai9teU5JdGlqanBtekc0Zi8vSEpnK3NnQnQya00wT0RoVndS?=
 =?utf-8?B?WU9ZMXVvVlYrUGlUVTZudkNMUUNOem11SnJxTE42b1RsVlU3U3doSFFybkVr?=
 =?utf-8?B?WU5IVDNhVTR0d1ovWDdmQWdmb0lHeElWdGlJOXBzT0ozVk8yektrUUdmNFpn?=
 =?utf-8?B?TDhQd21KMG93ZEM0NTlYaVZQUnBZZ0g2T0N5YUFGdjkyN3V5Z3FvZ1lXZ0RO?=
 =?utf-8?B?dXRtT1JvejF4L2Niemp4U1cvMzJCQ2xmMFhReFZ5aXdud213ZW84WHc1cTI1?=
 =?utf-8?B?TFhRdk8wblJEVTVIK3FIZWFtS1RFVlRUUnVZYzR4ZEJNb1VGY1RqSXNpL1lG?=
 =?utf-8?B?REpUc1hxbXlnVkFVUzMxdHdqRDVyZW5vM1V1V1lNQzl0YWpCb1FVeDltNEtt?=
 =?utf-8?B?emVKWjlhck9hMHJwZm5kZCtBOUdIVnNPVndPWkJMM1ZLTDV0UGRDYU5uQURP?=
 =?utf-8?B?c3lxemxzZHFtMS9sOHV1L1p4RFFhSTkvaUtBdmJHcmkxdU91TG9ybGtYa0JH?=
 =?utf-8?B?THBMYVNpOERJVnFFWmZWUGt3Vk5mU2FCYjNiTDlaRUpMOHYzemVxRlV3Mlky?=
 =?utf-8?B?NlhlZDFLWjY5ZDUvUHJMYVhtdFlVOHlMS3F5aWRra1dVYVUyRURtdHVZdWhu?=
 =?utf-8?B?OTlIek1jQU1DbmtmVks4YXZHaGhUdDRxa2FOc2ZFbGxpcXlRSTZtYmFEQU5O?=
 =?utf-8?B?VVZjQ3FLUXUwUGNTemJ5ckZwamFWZjl2eDVVU080RXArU2lrc2pNa2J3RW9p?=
 =?utf-8?B?MUFjeGN6Q3ZGR1ZxclFXRStzUjBDRzU3ZEx4dlRYQ0VtN3A0NjZtazN3RXpj?=
 =?utf-8?B?L0o5UlJFbWhET25wcmVsbnFrNzF2ODJLc0NvQkxCSVQzZkxReEVtQVU3My9y?=
 =?utf-8?B?cnErSk1kbmhKanI5Z3Q4N25BZzFFK0UyVkhiVnFJdUhwMkFmYzVrUUNjV1hh?=
 =?utf-8?B?Y0JSTGQzOE92ZTI2NmZ2ZDNmTmdGR2R5VDFSMmtPYURsSFFoSVFkK3ZXUnVk?=
 =?utf-8?B?a1paVmRZb2hPSFd6RDBVUE9meGtFS1psV1JuN3ZWYlJnb2lhL1kxVEFxVUEw?=
 =?utf-8?B?OUEySkVtcGd4TDVBOWo4SHN2ZDZ2NVpBVmpoeXdHZW10eVpWT01aNFpXWksx?=
 =?utf-8?B?b0E2cGROL1p1d0Z1bjkwcy81bW1vZ0JCa29Md1R6eEY0QllvM0x6TnhFUDQ3?=
 =?utf-8?B?c0VrdVZvT0F5ZFdHcWo4d05UNTZna1ZzaC8vWXBxYitCUlFYaE5DQlEzMWhD?=
 =?utf-8?B?S0RzYnc1Qm1oOEFXSDNNK29MbXJNS0pBcFlacW9yNFFqQXNxaGlsQmZnNG9B?=
 =?utf-8?B?OTNjNUNuRXJEK1hPTlhwNDZIL2hrNU00bFlCN21pN2hsYlFDSVBtSHlGMXkx?=
 =?utf-8?B?VzJRYUQ0eUFQYld2K1licmZBQWJackRyM25WeEtnRHpWOS9yUWVHN29MUnZy?=
 =?utf-8?B?bWwzekxDaHV2YnE4dUMzT2NmMmluTnRsYTRhSGszT2tBYkpVUExxK3RibVZS?=
 =?utf-8?B?N0txeDJtYWs4NU9kOVoybFcwTE42WVNqZEtYTWhNZlJGMkJOZnhaSllpSWtJ?=
 =?utf-8?Q?ki3JgCgxh+OCEEFk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <393F0804B3CA4F4FA2F9C10DDDB9830D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR15MB4969.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac7a2c1a-1cff-47f8-73e0-08da315856bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2022 01:07:50.8330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ysoqD6FO6ko8YTl+hlMEN/vRH1AlYp8d/+QLFqgWTll7+deliO8yxZnJepPXnjR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2747
X-Proofpoint-ORIG-GUID: QgxA0qevG7qinQhs7foMnUGXGTGINzHd
X-Proofpoint-GUID: QgxA0qevG7qinQhs7foMnUGXGTGINzHd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-08_09,2022-05-06_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

T24gU3VuLCAyMDIyLTA1LTA4IGF0IDIyOjQxICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gDQo+IE5vLCBpdCBkb2VzIHdoYXQgeW91IHRoaW5rIGl0IHNob3VsZCBkbywgeW91J3JlIGp1
c3QgZ2V0dGluZyBjb25mdXNlZA0KPiBieQ0KPiB0aGUgaW52ZXJ0ZWQgUFJFRU1QVF9ORUVEX1JF
U0NIRUQgYml0IDotKQ0KDQpGYWlyIGVub3VnaCwgdGhhdCBtYWtlcyBzZW5zZSEgVGhhbmtzIGZv
ciBwb2ludGluZyB0aGF0IG91dC4NClRoYXQgaXMgYSB2ZXJ5IGNsZXZlciBvcHRpbWl6YXRpb24u
DQoNCkkgc3VwcG9zZSB0aGF0IHNob3VsZF9yZXNjaGVkKCkgY2hlY2sgaXMgYWxzbyBzb21ldGhp
bmcgdGhhdA0KS0xQIGNvdWxkIHVzZSBieSBwZXJpb2RpY2FsbHkgcG9raW5nIHRhc2tzIHRoYXQg
Z2V0IHN0dWNrIGluDQp0aGUgS0xQIHRyYW5zaXRpb24gKGFuZCBhcmUgcnVubmluZykgYnkgc2lt
cGx5IGNhbGxpbmcNCnNldF9wcmVlbXB0X25lZWRfcmVzY2hlZCgpLCBhZnRlciB3aGljaCB0aGF0
IGtscF9wYXRjaF9wZW5kaW5nKCkNCmNoZWNrIGNhbiBoYXBwZW4gb25seSBpbiB0aGUgX19jb25k
X3Jlc2NoZWQoKSBwYXRoIHdoZXJlIHdlDQphbHJlYWR5IGNhbGwgcHJlZW1wdF9zY2hlZHVsZV9j
b21tb24oKSBhbnl3YXk/DQoNCklzIHRoYXQgc29tZXRoaW5nIHRoYXQgd291bGQgd29yaywgYW5k
IGJlIGxvdyBlbm91Z2ggb3ZlcmhlYWQNCmluIHRoZSBnZW5lcmFsIGNhc2UgdG8gYmUgYWNjZXB0
YWJsZT8NCg0K
