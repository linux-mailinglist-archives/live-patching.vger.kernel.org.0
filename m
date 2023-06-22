Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C150F73A9A1
	for <lists+live-patching@lfdr.de>; Thu, 22 Jun 2023 22:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjFVUrA (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 22 Jun 2023 16:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjFVUq7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 22 Jun 2023 16:46:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6FB13E
        for <live-patching@vger.kernel.org>; Thu, 22 Jun 2023 13:46:57 -0700 (PDT)
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35MHQo7Y016750;
        Thu, 22 Jun 2023 13:46:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=cBsyFKTAlSru1x3CBgpHKQAUjsCM4KgLpq5Wz7gcDn4=;
 b=fMvTGuNKOKduvGVFDKZL6NrTP2GtdaOBSsybKLyIg5bCJ0ELo0EQlcHCo6U8QlsJ/dda
 AHLmrRQyTLweFo0JIQYqZ97/Jvl17M6X53iKlLGWfu0lZMiW+TKYMMngxguEGji28DkQ
 u/UIwCX45RFYKUmK9VE3NRvl44/NR5wlFv2IBv9gvj+a/9HFj3NkM/7QyvyH4viILy/4
 NmdW90mWxQ8UTcC4obJkS1yGrAc/1PRCNpQ3tcwLpMd1GawBLwUd60gwNnn0v3tzeaih
 HmA9URr6lgZAT0jWx88UfHZ6S8bcVXDE80dQprLjP+AiAHFBfbwQ5sGI5RzJETh1d7zz RQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3rcqahbgcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 13:46:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcAoklcMisPjP4DJX+70fm+owik2QF44CRDZS1DM0mK0C37fc5yc+9SSfchyPrs2H2LSJ2UjAjr8/2LcubccN4TOtYQkqW6ucXFHsqmqBFSyMdvumwfyKd8f4MAAE3B//ekFS4/YgD7hiVMeCOOyaiIstG0jJvZQh3gW5mB6CwX9AW+upVP4Fh7qgjsWT+MRSmtSM297O/fIrkYPqWhcZb4i0RVJh145GWuF7ZWfqAiUNJ1HehoLQzhJDeo7HYQsOw04uQwlvo1wfxo8KfQih2GbUkBDYOFGYR9CpFBIuh3CB9FvnriMsNR19IxooziAaF7lEBxn8fpswZZL4b414g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cBsyFKTAlSru1x3CBgpHKQAUjsCM4KgLpq5Wz7gcDn4=;
 b=dxV6GDD5CEcZvwsPDHmGe8TdgLqWyXmIvMxtc71fUvhQIn63Gzpt4dKHYSkZ90LdRY9Xj0Dski12jLSJtDwJqkUQEdur3H8jOllrCdaCVWkNMn2m/WkqSkyHTL7n9hSYCT+lO8Svm8lHEFCpF/80Teyd4z85YQJR3eINJjpaXT+MQbruCrDc24RrCx374DGjXjTPk//lwXfUAqJJ5y4KVJGSSLrkMGhjhj6g3F48ScDcl4UBC3aRK6tXjiMoK/ygT4bzMm8wQm1dTotIy3gCIAdBfhTc48LvoUTVMuBc4a91M4ejgTm7NTHfpOj11ul331l26Vfd9GnhUwXRntWEXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4689.namprd15.prod.outlook.com (2603:10b6:806:19c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.23; Thu, 22 Jun
 2023 20:46:00 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::428f:acec:2c1f:c812]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::428f:acec:2c1f:c812%7]) with mapi id 15.20.6521.024; Thu, 22 Jun 2023
 20:46:00 +0000
Message-ID: <cd0eaf00-7cb5-722f-4745-0660f58f22cb@meta.com>
Date:   Thu, 22 Jun 2023 13:45:55 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match symbols
 exactly
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>
Cc:     Petr Mladek <pmladek@suse.com>, Song Liu <song@kernel.org>,
        "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "jpoimboe@kernel.org" <jpoimboe@kernel.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "joe.lawrence@redhat.com" <joe.lawrence@redhat.com>,
        Kernel Team <kernel-team@meta.com>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        Jack Pham <jackp@codeaurora.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Kees Cook <keescook@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "KE.LI" <like1@oppo.com>,
        Padmanabha Srinivasaiah <treasure4paddy@gmail.com>,
        Fangrui Song <maskray@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>
References: <20230615170048.2382735-1-song@kernel.org>
 <3c0ea20b-fae7-af68-4c45-9539812ee198@huawei.com>
 <07E7B932-4FE1-4EEF-A7F7-ADA3EED5638F@fb.com>
 <b6af071b-ec26-850b-2652-b19b0b14bd4b@huawei.com>
 <CAPhsuW6nrQ-O3qL6TsR3rypEk03+X8z0-scGwO3Z5UAGz72Yzw@mail.gmail.com>
 <ZJA8yohmmf6fKsJQ@alley> <47E4EA81-717E-43A2-8D6D-E7E0F2569944@fb.com>
 <ZJK5tiO3wXHiBeBh@alley> <E47B9D18-299C-4F95-B4F6-24DB6A54A79F@fb.com>
 <6df9b18c-d152-942a-b618-bb8417c7b8cd@meta.com> <ZJROPO1ukwMyYFnm@alley>
 <3c1a953a-c77e-b38c-a7f8-15931ef2d6dd@meta.com>
 <4616610E-180A-4417-8592-B864F6298C7F@fb.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <4616610E-180A-4417-8592-B864F6298C7F@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:a03:331::10) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SA1PR15MB4689:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d197334-74e6-4526-3481-08db7361afde
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZlAtShQ7HfRgVB9777qN+Ij680sNAFcykQZT/voSW3wrNXrnIf4MIDxEvcnZPcrdTlLH5Aj8cxNuW1hURy/Z3w2wyJiausWy22rck9duxL0pmkhA5ieItP77fWDcQuMfx9VQYxk9szD6IaiSD7Mc/rPKp/c0Z1Yr0oNKA3b9LHNoXEECKjoA/5kfxZfcNAbZJwAD3f+m7K+q5+gKo2FZDMG/VHptyAsdx9w3s9iuthngZRn/mSA4Tz1Zo3QwGMQ0JUpvaeuDpdgJuB807n5V1/mbbflFvhdzv2ZDnzuExBw0rFAso/g/KnQ0OXtK6+0yEd5Jrreg/DckK5z8IdIWZwTlR9W/BtU4MfxGeqRAxi2cm40a0u7on5T2xTULmSbwbVCVoxJawyj+NDiLCn2SmVq7ESCx6XwoLjAu/yP/eEK40mx3/cThRHlUZp/RLr6QwPtbScnZIADcpqLRuvKdIKFMduDpeTsYmwZeRtjef9IWWSOpaDr/+9FBlxLP6pxHh6SasmlUdlSaAMgwORkSEDSOSI0THOhDtySKbWoD/NF9qKr8EF0/KRWlBkcvXTiZTPrxN78tBe3+AIRxmLSLPWb8eA07zvF0s0u41+3+QOMGTbZyvWoN4eoRUnzoA8rdtgB/XMWzyL+9KdR1G4OSCg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199021)(54906003)(37006003)(53546011)(6486002)(478600001)(6666004)(6512007)(2906002)(66946007)(186003)(66476007)(316002)(8676002)(86362001)(6636002)(4326008)(8936002)(5660300002)(41300700001)(66556008)(7416002)(38100700002)(6506007)(6862004)(36756003)(83380400001)(2616005)(31696002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3ZCNnNJRjVydThCVTJUOEFENVJxWnJqaVlsK241ZE9tKzNxa2VMWll6cVdn?=
 =?utf-8?B?RVJnNU1JSzFWMmJxR0lhRC9UNWtiWWNEeldZbXE4Q2VTajhiRkRya0M0OFh4?=
 =?utf-8?B?ZzFPODRpdWNhOWJoYXBSd1k2NmFCaWxEaFFKblhUcmFwaS9yUE9KVm9tMW9R?=
 =?utf-8?B?aGxNT1Rza1lzOEJ4eFlnNFBHMll1UWYrMms4Zm9LTi83TmFENkcrMkQxTXg0?=
 =?utf-8?B?azVyVWRGRzNLKzFVcW1xTXhFa2RuTjZEb2puci9vR3ovNVI5Z2dvUjJPUW4x?=
 =?utf-8?B?Z2I1eGxmVk1xYXpySnhWemF1NVg2UXlQYkdLb1c1dys4dGJWT3BGTUNQRVhp?=
 =?utf-8?B?SU1YY01uSnFIU1ZOdDlCbDkzZXIvMWJOM0JHbk1oUE9VajFpVDNZR3htMWVG?=
 =?utf-8?B?RU94VmtNQXI0bEpINjdXR2pkUHE3azNsUVBGNDV4UkxaenFvd0dyZWxvMlpj?=
 =?utf-8?B?Q3VHZlJzQlg2VUpNd3oxcFlmVzlvRjBhZjBodnRCQndHbzZVbzM2OUNKaGxQ?=
 =?utf-8?B?aThaWUVJZmo1WWpRdUFLY25jYmhOL1paU1hUUjFJMStKNytaeEtGMEc4a291?=
 =?utf-8?B?bnh4bGVvLysvTENFYmQwVGNFTThRZExNaS9Ocnl6Z1oxeksyU2ZnZ0JrOU1P?=
 =?utf-8?B?UUl6ZHdtRGJ3Yi84SnVXeERJVjZKMGlMNVJpRGdnNkx6bTNTTzJBL1phUkR1?=
 =?utf-8?B?cVVFUm9FcEtOQTNCT0tVOHVrYndlRkdOWjcvdFZKcVNPaVNCY3lqYzREaWNu?=
 =?utf-8?B?R29valZublpMc1VXRzFtWlRZbnFWK1lkWGFuL0RSbjB4SjQvSVQyK01TV0N0?=
 =?utf-8?B?b2tlbmFGb2ZZNUl6V1l4Z1BQS2ZYZzMyaXNEV3Qycjc2MU9ycnB5R3NRNDBH?=
 =?utf-8?B?bk1Yam16MDZCa3ZHNWdLNHJZRzNHbldycmlJQmRkZmF3bW9OenV4c0pSclJm?=
 =?utf-8?B?eG1HOE1RdW8yRTJJcTM2OS9DSStpVDZ4V2RWRng5Q29nOTd6bW1XZjJaaDVE?=
 =?utf-8?B?ekl4QW5kbzFwSVIvN0FEaTQ4MDd5ZTZUQTNKRlZJTVFDQnEyYk5SL2Y0U2li?=
 =?utf-8?B?dTU0c2xtTjRHcC90cElKSDdsOHBOM1lyK2c3aDE1c1RQQVJROEZUSmlPcFhi?=
 =?utf-8?B?U1BQRFRSRzFYVy9jVEE0Q3lZNnBqRGl1Z25Sc280b0kxTU42MmRWaEZFV1Ni?=
 =?utf-8?B?NC9qcGpwRWQ1VEl4dGpYRWFrMUp3dnlFMzV2aGREbVhWRVJya1dJTjFzT0FT?=
 =?utf-8?B?c0pBbENYRThCR2pXVCtrVFRPejNpTG10bnVPdWNNS3R2RHMwNmZRVVRnY3N3?=
 =?utf-8?B?N2pZdys1WExFOVArUTE4cXZrU29xU1R1Vnk0bmxvWE4xdnFSZVBUSUZLdXZk?=
 =?utf-8?B?WHV0Y2E0REF6MUVBTkFuZzBOOFE3WityaXoyMGl5Q3hvMi9rcjloRW9QVHdv?=
 =?utf-8?B?a0tCRjZ3SHpZWUp2ZG12RTRHS3FqaHNBY3FyYmE4b3RUa0l1SXBwcGxsbEli?=
 =?utf-8?B?UG9pY1d2N05aMzZxYmh0SkErd3FDU3FwK0NSUHUxWFVYamJtQ0xUV1NNSndy?=
 =?utf-8?B?MCtMaDZVSVdWdWdTMUoxRzVFbm9nbUtmTElOalhaMU50R0FRaFU3Z1lHcnpz?=
 =?utf-8?B?YXFVWmd6WnhhOEhVaXBIaW5NeVdOSmhHU0pRK3BTMm1PdjlRemdoK1FYcjY2?=
 =?utf-8?B?NHlqcjVrZ0hqblJ4a0ExRTQwSXJaVW9MR2lScWQxL2ZOL0RocHV1SExmK0ZQ?=
 =?utf-8?B?eUoxbEpUUkMzbTFYTEswSFZ2dGc1SnBVaU11R2sxSWoyM3VIWHVyZkh1cVR6?=
 =?utf-8?B?YUVqaTdzbTVuVUkyTjN6WjAvRnpjb09mQ25hYlFuRnkxa2VWWTNEUnU1SUg1?=
 =?utf-8?B?L3ZSSk1ySVNIeVBSWk1NZUFrVVVYa3hnQ3pvUE9Sc0VsL0NvWi9YNWIrbDNF?=
 =?utf-8?B?bTBxN3VBNUxVWVV0T0pUbzVHaGpQR1ZQcEV6SnhCOE92RUhwejlTMTBlRGVG?=
 =?utf-8?B?VFFyL2VyczdNbi9nKzNJbG5icHpOZ29CV2g5NGxCdFJGY0RIVUl0TjlGYUhP?=
 =?utf-8?B?bGhEbmFLbHNmMHR0MTAxVUtiZ3F6YjQzbjFJOEFwdGx2eVU2UDMvZXlqbElv?=
 =?utf-8?B?a3V3Y0tpY3RKLzdsQzdDV25selQyR1p2Z04zbFFCN0VvTmRDZGtRM1B1QW9I?=
 =?utf-8?B?dlE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d197334-74e6-4526-3481-08db7361afde
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2023 20:46:00.4486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iFbmLWeM3ddzXQI9Ov4XAkFAOfv2NKHIVjpxhBrQ2DD2s1Py8IpoFW6Ow8R+WcrW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4689
X-Proofpoint-ORIG-GUID: RAXOxlHzk8kn818gqEJdZAvk8oay4-UE
X-Proofpoint-GUID: RAXOxlHzk8kn818gqEJdZAvk8oay4-UE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-22_16,2023-06-22_02,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 6/22/23 1:33 PM, Song Liu wrote:
> 
> 
>> On Jun 22, 2023, at 9:10 AM, Yonghong Song <yhs@meta.com> wrote:
> 
> [...]
> 
>>
>>> Effect from the tracers POV?
>>>    1. .llvm.<hash> suffix
>>>       The names without the .llvm.<hash> suffix are the same as without
>>>       LTO. This is probably why commit 8b8e6b5d3b013b0b ("kallsyms: strip
>>>       ThinLTO hashes from static functions") worked. The tracers probably
>>>       wanted to access only the symbols with uniqueue names
>>>    2. <function>.<symbol> name
>>>       The name without the .<symbol> suffix is the same as the function
>>>       name. The result are duplicated function names.
>>>       I do not understand why this was not a problem for tracers.
>>>       Note that this is pretty common. _entry and _entry_ptr are
>>>       added into any function calling printk().
>>>       It seems to be working only by chance. Maybe, the tracers always
>>>       take the first matched symbol. And the function name, without
>>>       any suffix, is always the first one in the sorted list.
>>
>> Note this only happens in LTO mode. Maybe lto kernel is not used
>> wide enough to discover this issue?
> 
> I think this is because all these <function>.<symbol> are data, while
> tracers are looking for functions.
> 
>>
>>> Effect from livepatching POV:
>>>    1. .llvm.<hash> suffix
>>>        Comparing the full symbol name looks fragile to me because
>>>        the <hash> might change.
>>>        IMHO, it would be better to compare the names without
>>>        the .llvm.<hash> suffix even for livepatches.
>>>     2. <function>.<symbol> name
>>>        The removal of <.symbol> suffix is a bad idea. The livepatch
>>>        code is not able to distinguish the symbol of the <function>
>>>        and static variables defined in this function.
>>>        IMHO, it would be better to compare the full
>>>         <function>.<symbol> name.
>>> Result:
>>> IMHO, cleanup_symbol_name() should remove only .llwn.* suffix.
>>> And it should be used for both tracers and livepatching.
>>> Does this makes any sense?
>>
>> Song, does this fix the problem?
> 
> I think this should work. We also see .str.<num.>llvm.<hash>.
> But those should not matter.

For some string constants, llvm may create a local symbol with
name like '.str'. If there are more than one such local
symbols, they become '.str.<num>'. Then when they got promoted
to global they become '.str.<num>.llvm.<hash>'.

> 
> Thanks,
> Song
> 
>>
>> I only checked llvm15 and llvm17, not sure what kind of
>> suffix'es used for early llvm (>= llvm11).
>> Nick, could you help answer this question? What kind
>> of suffix are used for lto when promoting a local symbol
>> to a global one, considering all versions of llvm >= 11
>> since llvm 11 is the minimum supported version for kernel build.
> 
