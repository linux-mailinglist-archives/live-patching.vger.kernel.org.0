Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76553739298
	for <lists+live-patching@lfdr.de>; Thu, 22 Jun 2023 00:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbjFUWfK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 21 Jun 2023 18:35:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjFUWfH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 21 Jun 2023 18:35:07 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247F61BC3
        for <live-patching@vger.kernel.org>; Wed, 21 Jun 2023 15:34:55 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35LKFij4032465;
        Wed, 21 Jun 2023 15:34:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=0qr6cg0boffKDUoEPJY4ZDxgXO58mFh8+3DvefFJMfE=;
 b=k7EcqMm6sPAYHC9jTCTe7jFJqI54gO0wXrSTn/tgCvRrTpe2u+ny/lkCCpK3lZOw8Iu8
 X6lbF2+Zr07Va0q4VSLcfvQD1qfvNBrV7UE/tRIonfQJ0EINjF7fS0BU9A4MGXCOwx97
 wY420kNxQzfbPl6TqKgLr8ZUzvjQc3P6LyXk0eL5f0BvF/azE+0W03hjaT0EVKva3KQ8
 7AkfLjjb+5tYyD562Wkttam69dwOGZXBSlczwEharIPGtrU/3FXX1BbiPHJGzXzA8nsb
 tkhLS1BWTAFEd8wHY/QQVKAMYJ6Okp2PuZ/SuiLc5/5GtVSPEAgYdq2OOcPFC2GC/Csn oQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3rc832rx74-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Jun 2023 15:34:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIfdzgdv//CCcYGskzSMFzR2HkDbbVmuJfLUrSZyyNKQLmOkL9avfRH3Lqt8eahnuvYbfiWi9pWQwpQlqup1cWRW1MCLLdebBGwUaWBIPchfLbKfxES1uA4rNNuUgdfSraiTE+0+ivjVn6FuQyl1CBUFAYGiuI7AXDsPyPPnAbwWLlHnl7hBQljkRR7xWmDWD6l9t1Er38oWI8nelLdYgi8XLpjwL/4+X87tbwT1lybXs+dSlpWCkwWzSGursx2SpGvGWX/JSrTxWkx1TmIevULPgnSjVdqjS/pGWGIiu+36ay1mO1qWuWjq1Kb328qrd4UrdBFGoPvL0c4pI7lAlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0qr6cg0boffKDUoEPJY4ZDxgXO58mFh8+3DvefFJMfE=;
 b=IcON7FfcJODzBwGWy2lBhpcuk1ZiiGTPFzUzwB0dxwQrnsfRif4MlXEY6uq9lozMo1exfPznFVJFaZxOFg3kcUuCscoNFVhLgloUmLoYCTnXpgiy6a3pcYLV9+Xu5Ob8D9apPhg9AyDgpRk3aFS4wM4Krmhsko0ksY7sWP1KqSWucTwqpE1XV6WpfQM0sses09xDdvh+OGSvcq6geHt+gt/8JPgS1KZ/W70NicVxWpmKiUbKg7oklUd2qLz8o3+hwMrqi3GiMrpufGVJNJn1GegJHl+azPO6D4YaJdhFmGUpFapUk60OUi7yKWL3hUfeFj4+zCZPMlJusXeTKq7nHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by PH7PR15MB6131.namprd15.prod.outlook.com (2603:10b6:510:24a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Wed, 21 Jun
 2023 22:34:31 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::428f:acec:2c1f:c812]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::428f:acec:2c1f:c812%7]) with mapi id 15.20.6521.023; Wed, 21 Jun 2023
 22:34:30 +0000
Message-ID: <6df9b18c-d152-942a-b618-bb8417c7b8cd@meta.com>
Date:   Wed, 21 Jun 2023 15:34:27 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match symbols
 exactly
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>, Petr Mladek <pmladek@suse.com>
Cc:     Song Liu <song@kernel.org>,
        "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>
References: <20230615170048.2382735-1-song@kernel.org>
 <3c0ea20b-fae7-af68-4c45-9539812ee198@huawei.com>
 <07E7B932-4FE1-4EEF-A7F7-ADA3EED5638F@fb.com>
 <b6af071b-ec26-850b-2652-b19b0b14bd4b@huawei.com>
 <CAPhsuW6nrQ-O3qL6TsR3rypEk03+X8z0-scGwO3Z5UAGz72Yzw@mail.gmail.com>
 <ZJA8yohmmf6fKsJQ@alley> <47E4EA81-717E-43A2-8D6D-E7E0F2569944@fb.com>
 <ZJK5tiO3wXHiBeBh@alley> <E47B9D18-299C-4F95-B4F6-24DB6A54A79F@fb.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <E47B9D18-299C-4F95-B4F6-24DB6A54A79F@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:a03:40::47) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|PH7PR15MB6131:EE_
X-MS-Office365-Filtering-Correlation-Id: 73f9141a-cf00-4366-4258-08db72a7adfe
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CtE4QSoowvlpPJHsAlHTbQFs/wGVsTdSnGnhbJh3xpA40ubou6OkZP4XTIYYqLEwP3Vn7zF73kqxfbzEtKsTdjxfAirJzfo9Dkn1g1RmsiJisKKtpNhsGiordfUQyN9JaoZEGJOqn9qEtllhB4hbU+jaUnvAucnUEo2dbcP6kAfNBH4iouJulvGWHwo5phCM8oE0KG0i3yiK83RBVr9Vym82ci4dDSMPp1HIuPGsTkPx8D0IIoJTInH7+ji4+y6URb/uTIl7+rBxGD2y4oXsZVqIomwto0a+Onj/SQ1m0eRtsVZoNOMZTLKCyCY6Os7vhGcwT7vBKC7OkHMqkgbzEP4g7bTUKeJvswJy5ZbpPHsv52DZXdIWF91N80zn/ipEqq54rvwRKbzUO9/BurI06R3YhsCp+42geWjTe0viA6jQoqCy8pJQU9aSIU2Zfx7vxhVaD6bSNL+1wyh0Q2hUz3ekDBqfZqUL+iB4ItBrzVW+4tyEzHVDL7RQqGFksb9XwENG7IJyfIPvhPaPFHKR+4W3MNSuqvJBWWe67fWhwpmJJkBvfXC7jmbdYha8mmKa5hlVkKP9kdqVJY5j1PzEJmfy4YR7BMBm7mPgf+uR449qMkb4aniH9Q8LRU5X2Xg4KfkeJFDvEXHvoFWvonFfdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199021)(110136005)(54906003)(6666004)(6486002)(66946007)(66556008)(66476007)(478600001)(186003)(6512007)(2616005)(6506007)(53546011)(4326008)(66899021)(316002)(41300700001)(8676002)(5660300002)(8936002)(2906002)(38100700002)(36756003)(31696002)(31686004)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXJWL2E1YXgrY0kxRlJhelVqMUplWEdNLzJEM1ZPQjNFbkpCbjdvNDRZVlpQ?=
 =?utf-8?B?MHdLNlU1UGp1NGFodjAyNHVQVWo0SVVXS0U4S204aTVCdG5FNks1bFhjSDBn?=
 =?utf-8?B?VHdXazd3SWRqbHFzSTNCVVllNWNsS3N4ZzdleXFia1NndllKWmEwdzJPN3k5?=
 =?utf-8?B?TmxENS92anQwdy9ocnM2Y29yNFZLQkFhQmZhRUhFMXJBMEt5ajYwdkNWZFB2?=
 =?utf-8?B?SU1tNUpRUVZ2ckJMU2JpUTBUN1pmVHRybjUwSlliT0VhekFvSi8rb1AyeENq?=
 =?utf-8?B?U29hRFZlZnB4T25rQldSUm9aS01JZ3N5bEtRUUdWUFpQV1Jlb3pOYk5qR0Rz?=
 =?utf-8?B?UjVzeWRvQ0Q4dmtjUzRodnZwUlV6MkVHOW94bHpJQjlqZVpxdkZTU1A4WXlR?=
 =?utf-8?B?MW1FR2pKK3YyNGxTVVJkOGtnUHVPYzRQejZ0UVFDM2wrSUtCY05rOCtCbW01?=
 =?utf-8?B?Rk1udkFCVGFLNU9TZ2tqK2wzRlVUeHRCYWhKRm5IVlBmU0lOa2g2VDBHQ3E1?=
 =?utf-8?B?dS9OTGZiQ1NHdE1HKzUreU1FMysxWFRPNTN1YVhmaUJYTDhDa2FZL2FKVElI?=
 =?utf-8?B?TDd4K0J5M2tGR2xoMlh4cjhyc3FIRU9KalY4R3E0YXlTWkljcndMR1NyWmFx?=
 =?utf-8?B?czMzZENtSnRiKysxMG5EZHlqYzZ5Vll0ZWdKYVBGQkU4ZzhKYnliRE5kbzFG?=
 =?utf-8?B?R2JMQlA4U2ZGSzFPUDVkT1FwZlc4VDkrY002OFN6VG40dmZFRU1RamgrMlUr?=
 =?utf-8?B?SmZhWVFWYTZHV2gvSG5uNFUzaVZWOG9VY1l6aWhBK2NIbWZYZzUyMlRLZHd0?=
 =?utf-8?B?VFUzQjdxZ2dNMDV4U2JsY3dPaEk0cVdLdGRRbG45QTNEU2gwSCtCanJpeCtu?=
 =?utf-8?B?YXlTeEs0RkZrUUljM0NFUjNtdG1EcWxLUHU4YnNJa2ZqM3o4ZThNWkZ2RFVk?=
 =?utf-8?B?eEUxQ1BwQ2x5c3AwSmFVOEp0ay9wSHlaYUpKaUZVaTF6QWxMZStKd0NIMnZw?=
 =?utf-8?B?Zk5RZzVpbVNEOHhQSnVWa1hpd1lGZFI0TE5MNWNrenIrZEJCQ3BrazYxdlc2?=
 =?utf-8?B?WUJpeGRjWGpjbjVMS2lINll2VHB2bTNxSk5ic012dTdiSy9rVVlFZGdZdkd4?=
 =?utf-8?B?ZTFuZkJubnF6elFqTjNXTm9TcDBpaVk5Uy9HRnFLQTFtNDFWL1hKMnB0bkM5?=
 =?utf-8?B?ZFdVWm45dzBoZThSaHk0RlQvT2dDbW5yUUJYT2J3ZGpmQVNVMmJvQkRRN2I0?=
 =?utf-8?B?TE8xVHhSWG9nNW9LcWpxSVZudDRqaHdWZjkrY3gweXVSaWlxdjQ4cTkydU0v?=
 =?utf-8?B?NXc4N1c4dmdpSnJ4aGtGVmZ3ZG5VcS9qNGJTRnQwSkJEbU94UityWE12dkpZ?=
 =?utf-8?B?TDJnRWYyMGhiY1R2ZW5MZ3o2aDVoMER5TStQaEFML1pGQml4MWZPSFl6a29s?=
 =?utf-8?B?emRRenNFRWRhMUNSdURJZGJOSEY5dExra1Y1ekpCK0xxTTFOa010bE5UN1pK?=
 =?utf-8?B?T2JhSnY3Qlhna0RUT3V6cXc4YlNRaGp5a0RNTExmVDluQkQ3M0hSblJkUFVR?=
 =?utf-8?B?eW5HNXVVVGtucE5MeVdxdDEycm9WMlpNcWdzSkkwQkpIYzFLclFnYTlNMGJT?=
 =?utf-8?B?dVdqaXVTZWZyd0QrYXFCalB5b1Z4UXVIS21mU1VZZzRqajVGY2hNWGFid3k3?=
 =?utf-8?B?QStFb2RkaGdtaDFQdkUyOXo3eDE2cFhOUWpBczhTVTBPVHgwZ2tvbmxlZmJh?=
 =?utf-8?B?ODF0cUZqMmlLN2JMaVdYUnhHWGtaV0d0bHZiQUdMYmtlU2JmL1I5dnNBQVQ0?=
 =?utf-8?B?L3pxKzg5Rm45MDVMZ3o1dTNlSjcydlNyWDF5NHpnU05Bay9BT3VTRnFPNGVM?=
 =?utf-8?B?L253dHgybGkzNG00VHczWDN2anYzRnRZZkdWc0duS1crOEZTTkdJS1lCMDFn?=
 =?utf-8?B?NVRFbHZmRU1mK2tBekFNelBjclFlTUFtbUVxS0FqOS9KZzcwMDdmMlk3WTdM?=
 =?utf-8?B?cUFtdlFuV05jNWtCczFvTFovelRML1Y1b0gyaEJ5RC92RHhWNVRqY3J3alBJ?=
 =?utf-8?B?WU5PdTExRkFUNVBIWm5aeE1vZnUxdzRETGJaRFViWmwxRnVuZGplWUQzY1Bx?=
 =?utf-8?B?ZklScTZ0aFg2VHExdTdQK25XVDJPYTkvbGhLaWN5SWIvdERpWGozWjdFYjl5?=
 =?utf-8?B?dkE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73f9141a-cf00-4366-4258-08db72a7adfe
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2023 22:34:30.8788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0qUj31Cm++U5AQGDhaV7dXwLOG9ldkrsJmm2dis3qB7tyHwL5NuS5M0GL0hlsKma
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB6131
X-Proofpoint-ORIG-GUID: 72T_ADiOzNoBn3MEgP5wUJUIazVQiVK6
X-Proofpoint-GUID: 72T_ADiOzNoBn3MEgP5wUJUIazVQiVK6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-21_12,2023-06-16_01,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 6/21/23 12:18 PM, Song Liu wrote:
> 
> 
>> On Jun 21, 2023, at 1:52 AM, Petr Mladek <pmladek@suse.com> wrote:
>>
>> On Tue 2023-06-20 22:36:14, Song Liu wrote:
>>>> On Jun 19, 2023, at 4:32 AM, Petr Mladek <pmladek@suse.com> wrote:
>>>>
>>>> On Sun 2023-06-18 22:05:19, Song Liu wrote:
>>>>> On Sun, Jun 18, 2023 at 8:32 PM Leizhen (ThunderTown)
>>>>> <thunder.leizhen@huawei.com> wrote:
>>>
>>> [...]
> 
> [...]
> 
>>>
>>> I am not quite following the direction here. Do we need more
>>> work for this patch?
>>
>> Good question. I primary tried to add more details so that
>> we better understand the problem.
>>
>> Honestly, I do not know the answer. I am neither familiar with
>> kpatch nor with clang. Let me think loudly.
>>
>> kpatch produce livepatches by comparing binaries of the original
>> and fixed kernel. It adds a symbol into the livepatch when
>> the same symbol has different code in the two binaries.
>>
>> So one important question is how clang generates the suffix.
>> Is the suffix the same in every build? Is it the same even
>> after the function gets modified by a fix?
>>
>> If the suffix is always the same then then the full symbol name
>> would be better for kpatch. kpatch would get it for free.
>> And kpatch would not longer need to use "old_sympos".
> 
> This is pretty complicated.
> 
> 1. clang with LTO does not use the suffix to eliminated duplicated
> kallsyms, so old_sympos is still needed. Here is an example:
> 
> # grep init_once /proc/kallsyms
> ffffffff8120ba80 t init_once.llvm.14172910296636650566
> ffffffff8120ba90 t inode_init_once
> ffffffff813ea5d0 t bpf_user_rnd_init_once
> ffffffff813fd5b0 t init_once.llvm.17912494158778303782
> ffffffff813ffbf0 t init_once
> ffffffff813ffc60 t init_once
> ffffffff813ffc70 t init_once
> ffffffff813ffcd0 t init_once
> ffffffff813ffce0 t init_once
> 
> There are two "init_once" with suffix, but there are also ones
> without them.

This is correct. At LTO mode, when a static function/variable
is promoted to the global. The '.llvm.<hash>' is added to the
static function/variable name to form a global function name.
The '<hash>' here is computed based on IR of the compiled file
before LTO. So if one file is not modified, then <hash>
won't change after additional code change in other files.

> 
> 2. kpatch-build does "Building original source", "Building patched
> source", and then do binary diff of the two. From our experiments,
> the suffix doesn't change between the two builds. However, we need
> to match the build environment (path of kernel source, etc.) to
> make sure suffix from kpatch matches the kernel.

The goal here is to generate the same IR (hence <hash>) if
file content is not changed. This way, <hash> value will
change only for those changed files.

> 
> 3. The goal of this patch is NOT to resolve different suffix by
> llvm (.llvm.[0-9]+). Instead, we are trying fix issues like:
> 
> #  grep bpf_verifier_vlog /proc/kallsyms
> ffffffff81549f60 t bpf_verifier_vlog
> ffffffff8268b430 d bpf_verifier_vlog._entry
> ffffffff8282a958 d bpf_verifier_vlog._entry_ptr
> ffffffff82e12a1f d bpf_verifier_vlog.__already_done

Note that these symbols also exist non-LTO mode.

For example, with my particular config, I have


$ grep bpf_verifier_vlog System.map
ffffffff812f9370 T bpf_verifier_vlog
ffffffff82afa440 d bpf_verifier_vlog._entry
ffffffff83404218 d bpf_verifier_vlog._entry_ptr
$ grep bpf_output System.map
ffffffff81359c70 t perf_event_bpf_output
ffffffff821eeba0 t bpf_output
ffffffff82eec720 d bpf_output._entry
ffffffff83412c50 d bpf_output._entry_ptr
ffffffff84b0f334 d bpf_output.__already_done

bpf_output() is defined in net/core/lwt_bpf.c.

The original function:

static int bpf_output(struct net *net, struct sock *sk, struct sk_buff *skb)
{
         struct dst_entry *dst = skb_dst(skb);
         struct bpf_lwt *bpf;
         int ret;

         bpf = bpf_lwt_lwtunnel(dst->lwtstate);
         if (bpf->out.prog) {
                 ret = run_lwt_bpf(skb, &bpf->out, dst, NO_REDIRECT);
                 if (ret < 0)
                         return ret;
         }

         if (unlikely(!dst->lwtstate->orig_output)) {
                 pr_warn_once("orig_output not set on dst for prog %s\n",
                              bpf->out.name);
                 kfree_skb(skb);
                 return -EINVAL;
         }

         return dst->lwtstate->orig_output(net, sk, skb);
}


The function after preprocess:

static int bpf_output(struct net *net, struct sock *sk, struct sk_buff *skb)
{
  struct dst_entry *dst = skb_dst(skb);
  struct bpf_lwt *bpf;
  int ret;

  bpf = bpf_lwt_lwtunnel(dst->lwtstate);
  if (bpf->out.prog) {
   ret = run_lwt_bpf(skb, &bpf->out, dst, false);
   if (ret < 0)
    return ret;
  }

  if (__builtin_expect(!!(!dst->lwtstate->orig_output), 0)) {
   ({ bool __ret_do_once = !!(true); if (({ static bool 
__attribute__((__section__(".data.once"))) __already_done; bool 
__ret_cond = !!(__ret_do_once); bool __ret_once = false; if 
(__builtin_expect(!!(__ret_cond && !__already_done), 0)) { 
__already_done = true; __ret_once = true; } 
__builtin_expect(!!(__ret_once), 0); })) ({ do { if 
(__builtin_constant_p("\001" "4" "orig_output not set on dst for prog 
%s\n") && __builtin_constant_p(((void *)0))) { static const struct 
pi_entry _entry __attribute__((__used__)) = { .fmt = 
__builtin_constant_p("\001" "4" "orig_output not set on dst for prog 
%s\n") ? ("\001" "4" "orig_output not set on dst for prog %s\n") : 
((void *)0), .func = __func__, .file = "net/core/lwt_bpf.c", .line = 
154, .level = __builtin_constant_p(((void *)0)) ? (((void *)0)) : ((void 
*)0), .subsys_fmt_prefix = ((void *)0), }; static const struct pi_entry 
*_entry_ptr __attribute__((__used__)) 
__attribute__((__section__(".printk_index"))) = &_entry; } } while (0); 
_printk("\001" "4" "orig_output not set on dst for prog %s\n", 
bpf->out.name); }); __builtin_expect(!!(__ret_do_once), 0); });

   kfree_skb(skb);
   return -22;
  }

  return dst->lwtstate->orig_output(net, sk, skb);
}

In the above particular case, pr_warn_once() introduced
three static variables inside the funciton '__already_done',
'_entry' and '_entry_ptr'. To differentiate from
other potential static variables inside other functions,
these static variables are renamed to
<func_name>.<static_variable_name> in the above.

> 
> With existing code, compare_symbol_name() will match
> bpf_verifier_vlog to all these with CONFIG_LTO_CLANG.
> 
> We can probably teach compare_symbol_name() to not to match
> these suffix, as Zhen suggested.

This might not be a scalable solution unless there is a
way to capture usage of static variable inside the function
with some tools and feed them into an auto generated table
to be used by live patching.

Current comment in cleanup_symbol_name():

===
         /*
          * LLVM appends various suffixes for local functions and 
variables that
          * must be promoted to global scope as part of LTO.  This can break
          * hooking of static functions with kprobes. '.' is not a valid
          * character in an identifier in C. Suffixes observed:
          * - foo.llvm.[0-9a-f]+
          * - foo.[0-9a-f]+
          */
===

Based on my earlier study from llvm15 and llvm17, I only
observed 'foo.llvm.[0-9a-f]+'. Maybe earlier version of llvm
lto generates 'foo.[0-9a-f]+' format.

Note that CONFIG_CLANG_VERSION should be in the .config file
if the kernel is built with clang, which could be used
to further differentiate suffix format if necessary.

> 
> If this is not ideal, I am open to suggestions that can solve
> the problem.
> 
>> But if the suffix is different then kpatch has a problem.
>> kpatch would need to match symbols with different suffixes.
>> It would be easy for symbols which are unique after removing
>> the suffix. But it would be tricky for comparing symbols
>> which do not have an unique name. kpatch would need to find
>> which suffix in the original binary matches an other suffix
>> in the fixed binary. In this case, it might be easier
>> to use the stripped symbol names.
>>
>> And the suffix might be problematic also for source based
>> livepatches. They define struct klp_func in sources so
>> they would need to hardcode the suffix there. It might
>> be easy to keep using the stripped name and "old_sympos".
>>
>> I expect that this patch actually breaks the livepatch
>> selftests when the kernel is compiled with clang LTO.
> 
> Not really. This patch passes livepatch selftests.
> 
> Thanks,
> Song
> 
