Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B27BA73378C
	for <lists+live-patching@lfdr.de>; Fri, 16 Jun 2023 19:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjFPRkr (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Jun 2023 13:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjFPRko (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Jun 2023 13:40:44 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB4F2943
        for <live-patching@vger.kernel.org>; Fri, 16 Jun 2023 10:40:43 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 35GFlWRG025131
        for <live-patching@vger.kernel.org>; Fri, 16 Jun 2023 10:40:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : mime-version; s=s2048-2021-q4;
 bh=VZSO5b20kVvn8/Cxtum7HDcn3RbCLmmy9oQ2pGKrfl8=;
 b=azJYEV9LNs4Y3UtYCYwRUYJJCJK/yk4v1/516oOCagCrk4WfihJyz9htt1m6e8n4MOi2
 kxW71qJIn8yd1CXU9asF3mTU7W6U9mrTqN3RsTZjvYROa51KClqXD4KzHKtmKGUm0PrB
 rhwk3UUNwAvt4hBLOWOPWDir6/uTGs1Hp/kan5wPVW5LXIrOO5beMVOJ2LC+zTY/82JA
 fHliHYlVWaQMh0CfuVdIqz0exbUmoR5nlcRAXsVQrFGy+Ksv5k9d3SwDFljyQ01I1UCv
 NEpnxbxtD/WJLH3hmzgB6tr3TljoD8MMH12xWxh1b89itbo5f2TNvYITxFN+2hXsfbln Dg== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by m0001303.ppops.net (PPS) with ESMTPS id 3r8pkvtpj2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <live-patching@vger.kernel.org>; Fri, 16 Jun 2023 10:40:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UIFPWBE8JfrR60Gi5lqq7TETY9Qr8azup33gq+aNQ4squDrf8H8Nli0E6tA0CgEoA0bAK3DnVn1kGLcEuD6eMgpfhv3C0TPdyYFXFVN6ZJ4TtcgHBnLt7HmNDtzuvta37q4R3EMy4rHI9NZiwEdSk3ZSXA0DrOvY6ng+J/7ovqC+SjFzQs2wLyAfE5eI5EzwOzJFM+7Tph3CGf3tMQw/aK6ckmyz7RFw9BxZT6LsgaW3t2vambez8212llZGCtoHcxdvV0GDIKxbJYRpBRZLzNGSZjQ9O8OqhBh0bMYMpVrHnbw5X9X28EMhyJx882MunbefC9Q0B1eXCMobb1W6gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VZSO5b20kVvn8/Cxtum7HDcn3RbCLmmy9oQ2pGKrfl8=;
 b=T1nd9PB/222JuhIoOKDrlEUxIUl7Rz8ZdQS1ZuBZ9KHn70aB45bDuUhEPeiFk+XQ6TEOB3TA+na7Kzbvrkk9UObnyuQEmYGiBSkSpOc8TibnRNzHTkFFDillUirAewf0gmhcZ0wNECZmFpwoSA5ySJy9Ip6GDTWW5fXBx54tGujOVTt0jCLQYk+33Wz6lIsjhqgxFwWUMnii22JM/ADofgyZjpgET3XAvgjQWlYJAb2dLE6NEFvrWQzwbSSdet8FfXxJhICCJwDHWvtPKb9W2Qaf7W3CgcrtqokYDpEm29zaGUmTlyn/5xmn1A6UMcPIp2lUzusDyhZ6Kr5UXRpAvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB5736.namprd15.prod.outlook.com (2603:10b6:510:28c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Fri, 16 Jun
 2023 17:40:39 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::a353:7e78:2a58:dac1%7]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 17:40:39 +0000
From:   Song Liu <songliubraving@meta.com>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
CC:     Song Liu <songliubraving@meta.com>, Song Liu <song@kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match symbols
 exactly
Thread-Topic: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match
 symbols exactly
Thread-Index: AQHZn6r1VuNYFv7wzUinZRrB36Nwc6+MsomAgAAtbQCAADT6AIAACRQAgAACX4CAAJOPgA==
Date:   Fri, 16 Jun 2023 17:40:39 +0000
Message-ID: <A013DCEA-E35C-406B-8EBE-E7AE431B124D@fb.com>
References: <20230615170048.2382735-1-song@kernel.org>
 <4c05c5eb-7a15-484f-8227-55ad95abc295@huawei.com>
 <EE806082-EB5C-49BD-B7A7-FFAB3E6340F4@fb.com>
 <85475c44-d9c4-d5ad-350e-bb5fd713ff26@huawei.com>
 <77d57723-73d3-8837-b2b5-9fc81e482a8d@huawei.com>
 <6eb17ba3-0a20-b6da-2466-016c559d79f3@huawei.com>
In-Reply-To: <6eb17ba3-0a20-b6da-2466-016c559d79f3@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH0PR15MB5736:EE_
x-ms-office365-filtering-correlation-id: d1d76690-c891-4604-1bbb-08db6e90cccd
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eZS/1w1Z9JrNN/BgvHR2Y3AwdZuK7xU/vqYViwZuulUC1osy19G4cj5FCYLTKbJhoiW1tiDZ48Rh05NunpHxYhhGh9GTBRr/rWX7lrsAKiK3JjYYweMVvx7ij4uNuev3tLp8/aJgsDnGfG9MO23y88Nb2OZp0Sa5r/tGfA9l2sef/JYBUOVPNFWvvvQEwB4ZylpxGZ2JHxmaLLHavmweWTzrmRKLb8pFnyxW6pQSb1H7UJ1U3FPTBtjWNBGeXGM1UV489ooSbvgX5VZeaHbC6MrZ5UlG0fh6xS14dd5WGRpBqViqgWfPmyzarwgF9FBBFDUGTTJEnrWrya7HQTymdaFSd37sLeDaQfC3tdufp0zux/zoDS+QnAVzStZcUBJbYRxx7hyw/e9nsITigefL3AIF+H1QUY9oEvIXSqRHgAW6fBIqk/e8D06ZALez/VHHmYnAiqMdGTWNYkP5ZclOwj7s7ivuDesHvM9loi2uzOOQ7YycZbM4i1LWrbrOVcCByu4zXH7UpslJtFls9rMm7MuXwyk06mFtC5a6GhQ6/5z9P1rrIOg4yQCXu3fyO+wuh9zbqosOf4kj/ZtBBbWzxjaBSFjej+jjvbPVo5rWx0BEHxwQDYqkS4a/tEqrljEFvULvguTB5m35LnBKIVK2mQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199021)(122000001)(38070700005)(33656002)(36756003)(86362001)(66476007)(66556008)(64756008)(478600001)(4326008)(66446008)(76116006)(54906003)(66946007)(6916009)(316002)(91956017)(6486002)(8676002)(5660300002)(8936002)(41300700001)(38100700002)(2906002)(53546011)(71200400001)(9686003)(186003)(6512007)(83380400001)(6506007)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gCeogkqOIlmj7oyfsWKXkAHravhBuOKpYq72bAtnLIofJx+GXU3M58D4lZQA?=
 =?us-ascii?Q?Sl0P9yuxFNabUFWIGimKMxr0pvv7ehhAbTV8/cJKHmtF8jiPHjPNy7NyzqIP?=
 =?us-ascii?Q?woDa93YZnRwg9+IivgJ0fvihXjFijFkvkmrPOxZPP7V0m+UM7Km2nghI8Baq?=
 =?us-ascii?Q?+BwVZn84pWGpbB4zQIIIhCbhXeNDO9LwxN9yx9McAMuK6+MlSzsicnj626Qx?=
 =?us-ascii?Q?J6/3lIhkA/mXBfvolb8Se2jXQR9cmkyRD2wC44Iz6AXlwGZuFTl9l8phb+El?=
 =?us-ascii?Q?QkW4F2/mOCIfnjFpCgxr/s5GVd6MQe0sZ1cW1uyEmchvLXykd4vkQHozrfez?=
 =?us-ascii?Q?tK7u/2mbscMRJyqO3lVVxJ1HMwDJ9xDdeqUj19DewkxEcWLN92W8k7hcaN3S?=
 =?us-ascii?Q?KiD7vkjq0xBjxrEWAz/WMEqPUs6h0DyYpZ7P/eP6paN01g/pzMD1Sj1n/OQE?=
 =?us-ascii?Q?Mq9hjo/E1BnQ9AgLEUOAvmmcEwJyeqxwOA44iFcxRCFOBsvWYW7ssEsFJ8OW?=
 =?us-ascii?Q?ZioSM72lFkloV7GmcXiWVHkCayhaM2Ae5c3j3azoN61+0CXrP0egGcYRl6/O?=
 =?us-ascii?Q?TesSoMEs4rQm5cmkbmGrNs+cvOqyctnvhJup6bIZRMP7A08PjAToMTf8JnpQ?=
 =?us-ascii?Q?3ilsnzF9OG5g4IpthUid+hq1kYX9xRsJwLMK/6l+YlViZLHr+KBnKyH3KmnU?=
 =?us-ascii?Q?xf64hhfAMALLOopUoTxMTvy25xZhZ+iqXb9/6kVKiZYMu19BTBbcKmhd9FdQ?=
 =?us-ascii?Q?/QFcci57f/tt/A/gPwRJQwXvyhV1IuN0UCB0/xo0yl1ZcMh1PNA3dooUEHrp?=
 =?us-ascii?Q?CwqaDebaoQQLWsq3lfoCY5cC1f5RgW4uQ6qMfeF3HBsN8rUsEB0K6sqxDC0Y?=
 =?us-ascii?Q?i8C8sYLT7DTsVTPgKRDMTVepVP6z8cmiLy+aBR6ETgZiC15BDcsRmKr3/v06?=
 =?us-ascii?Q?A6roQ/9ek8NxCdjqmQ/mNCUjznDDpqBQP/4/wvTDRvPnkzWG/Vipl3IthKX+?=
 =?us-ascii?Q?1PTCl3hhAmgI4y6LiIif5EHYsE/WQojDtnP+IIHe8kKZt8Or9D0S9f+cTVtS?=
 =?us-ascii?Q?GgeaJC5qZv7qrKxMRjK42uy0xKDj6GMkYyVzH+QPA3SMel/MkBEeTcRFWN1M?=
 =?us-ascii?Q?fYpsa6r03bd/NFzkDpfQmIw0o/bCx5DUVzBNDkO3T0afKiW414Z+CxaCTCCS?=
 =?us-ascii?Q?1ZmdQRlQzwpxZ10bpYL38g2pqf2IlP+fTmOrKVDiBcemywsTtFsXUEM9AXPr?=
 =?us-ascii?Q?xuo5Trs/EptpHWegAiUbH4dlJ8ky/1kTborSPYB6P3WOSP+spTrrlsh1ThXP?=
 =?us-ascii?Q?QVE9f8NBwZZ+NEj5uZKpWvPAQhAVMJsFjoF8ucQuCGyxoqb2LG4Dz3Zhmqmr?=
 =?us-ascii?Q?6U5TInFf8ocC1sG35EXfs8jx6QkJ4hOTTJ9QTCbCV1OuOTkhwd0Z7gq6M/kI?=
 =?us-ascii?Q?S7f8DNeVFIbvXpf1RkV8t6Jon+Xcnq7oKdepxG1pFLMCxAfX4zTThXGxFSSF?=
 =?us-ascii?Q?iQy8rmWKWXhZFQoR6gR3461RcOpbrncxI8c9UVG3IKQEzJzyIfXcNMJfWdVC?=
 =?us-ascii?Q?/bKgs3a8MH9xPxkXE4KQ1pfGWF1OSgEbIOSNdwhemXuFrYvjWDYo/GBPAhYH?=
 =?us-ascii?Q?v9MBwY4xambuGzto+2f3+GQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8D451AFF6A3F3D49A5B60928E9A8F546@namprd15.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1d76690-c891-4604-1bbb-08db6e90cccd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 17:40:39.3232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vE0284hnce7JudRr97X0XySkmfwcFtxMgqp0KD7ZSzzCYJdBjvSskZjZp6QphNj8JG4Pa/dhSf7eJIYZz4vEYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB5736
X-Proofpoint-GUID: W67HPo5K9JFV2OG-RymlFunxNMiV_RPT
X-Proofpoint-ORIG-GUID: W67HPo5K9JFV2OG-RymlFunxNMiV_RPT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-16_12,2023-06-16_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



> On Jun 16, 2023, at 1:52 AM, Leizhen (ThunderTown) <thunder.leizhen@huawei.com> wrote:
> 
> 
> 
> On 2023/6/16 16:43, Leizhen (ThunderTown) wrote:
>> 
>> 
>> On 2023/6/16 16:11, Leizhen (ThunderTown) wrote:
>>> 
>>> 
>>> On 2023/6/16 13:01, Song Liu wrote:
>>>> 
>>>> 
>>>>> On Jun 15, 2023, at 7:19 PM, Leizhen (ThunderTown) <thunder.leizhen@huawei.com> wrote:
>>>>> 
>>>>> On 2023/6/16 1:00, Song Liu wrote:
>>>>>> With CONFIG_LTO_CLANG, kallsyms.c:cleanup_symbol_name() removes symbols
>>>>>> suffixes during comparison. This is problematic for livepatch, as
>>>>>> kallsyms_on_each_match_symbol may find multiple matches for the same
>>>>>> symbol, and fail with:
>>>>>> 
>>>>>> livepatch: unresolvable ambiguity for symbol 'xxx' in object 'yyy'
>>>>> 
>>>>> Did you forget to specify 'old_sympos'? When there are multiple symbols with
>>>>> the same name, we need to specify the sequence number of the symbols to be
>>>>> matched.
>>>> 
>>>> 
>>>> old_sympos is indeed 0 here. However, the issue with CONFIG_LTO_CLANG 
>>>> is different. Here is an example:
>>>> 
>>>> $ grep bpf_verifier_vlog /proc/kallsyms
>>>> ffffffff81549f60 t bpf_verifier_vlog
>>>> ffffffff8268b430 d bpf_verifier_vlog._entry
>>>> ffffffff8282a958 d bpf_verifier_vlog._entry_ptr
>>>> ffffffff82e12a1f d bpf_verifier_vlog.__already_done
>>>> 
>>>> kallsyms_on_each_match_symbol matches "bpf_verifier_vlog" to all of 
>>>> these because of cleanup_symbol_name(). IOW, we only have one 
>>>> function called bpf_verifier_vlog, but kallsyms_on_each_match_symbol() 
>>>> matches it to bpf_verifier_vlog.*. 
>>>> 
>>>> Does this make sense?
>>> 
>>> Sorry. I mistakenly thought you were operating a static function.
>>> 
>>> These suffixes are not mentioned in the comments in the function
>>> cleanup_symbol_name(). So I didn't notice it.
>> We can keep these three suffixes on the kallsyms tool end.
> 
> And modify cleanup_symbol_name() not to cleanup these three suffixes.

I think livepatch should match symbols exactly anyway, so it is not 
necessary to expose more details in cleanup_symbol_name()?

Thanks,
Song

