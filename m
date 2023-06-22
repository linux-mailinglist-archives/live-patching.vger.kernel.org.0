Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E307973A5CA
	for <lists+live-patching@lfdr.de>; Thu, 22 Jun 2023 18:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjFVQMj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 22 Jun 2023 12:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjFVQMj (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 22 Jun 2023 12:12:39 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC129199E
        for <live-patching@vger.kernel.org>; Thu, 22 Jun 2023 09:12:37 -0700 (PDT)
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 35MDXcMQ024542;
        Thu, 22 Jun 2023 09:11:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=1iGjX+vzIAgzUsheH2bL61Xd9kynNLFcgte8PE9Uxco=;
 b=abwmmNqfTf8nI1aHa5nDLO5c15M+oSYzoH0uxPPiEBNKsOEOzOhmZJ6cdyxMlpuMdP/a
 nOVS79baQkyt93y/Oo1i+eOtNzBwa1zq/vRbXlRbUMgU9U/gel9d7KuMb/PSo69iDI5T
 5dIK81BzflFnUhSTdF3ubhiEKDeYpKZHUQFGZg7p/jKWDPdGj+K0fiLNzZ07Jl1RmsN5
 YfyKcgeXcMwCVoC18YuA1SLgzc/sJ21Zma1cX7izeuOn9bpDkol+V6N8sSXAZzmpiiOm
 za/7d2mA01LciK7uZnHET4SAK/0XP80cGN5+xUXSnsckJ8uQWo6o7tCu3Tko2kECaCQE +g== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by m0001303.ppops.net (PPS) with ESMTPS id 3rcq9khbgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 09:11:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aJQsymDeAOyRtkVvL2QsT75zD7pOSXwtAZDlRWpuRDVQsgfzILJZ0tbGp6kp0tPCvMfap+e+AUQ1c9w5CDUUX3MemlrZ3eRtEz4zI+bbwLD4PVb0tHZk+nRdLWWckVZ0tt4skgBRARzpsQArc0qs9CUaTfywCBQpLlf1oqYXIewPkeOkG3yYMvhi7o+HYWIcpV/Gd5JkF9W6u2mLbcOk5nsblwiTEQrdrCVdvwdlvBFHEXLDmlTAhBqC5bkwLqGDI8NzsH+ZqTOizkcRNselIT6xrkOESdh9WcQrTAJHTyHE4fHVMxZJr66qk0Sr+oz5L9f14kEfPK2IRrdbLidmbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1iGjX+vzIAgzUsheH2bL61Xd9kynNLFcgte8PE9Uxco=;
 b=A8ZvD0Wq2e6KuqfhwIx3k0oQzuZifzy388RfmVg7g/nfVLHQ5cl9oHqnZRfzllp4SMf6HgnrkIPybAIJP6xb3zm2hh+tYG5KbjwJJ0exBJ4y+0S3bE5Ef2OUP//sFqocZRtFiN1IFbMoHp8+fRQz8lCxXgVOdLRL2dHSGMYmAhD2NXhU14TwphtCqFH3XPLJX8pWuFfOz5+3NOBmHOe2QLB29uCHYlxaTMINyQx1BRYZrpjk93qI4pNZeUBIvZE0SrKQb8eJEbsTnsKaEgTm7vpx+9W83HCCyuU8rbcq1TcBhsmPzl7KqPAcJWSTIAo/Ykp+O+X8So1OQOodJD8TOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MN6PR15MB6313.namprd15.prod.outlook.com (2603:10b6:208:47e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 22 Jun
 2023 16:10:57 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::428f:acec:2c1f:c812]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::428f:acec:2c1f:c812%7]) with mapi id 15.20.6521.024; Thu, 22 Jun 2023
 16:10:57 +0000
Message-ID: <3c1a953a-c77e-b38c-a7f8-15931ef2d6dd@meta.com>
Date:   Thu, 22 Jun 2023 09:10:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match symbols
 exactly
To:     Petr Mladek <pmladek@suse.com>
Cc:     Song Liu <songliubraving@meta.com>, Song Liu <song@kernel.org>,
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
Content-Language: en-US
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <ZJROPO1ukwMyYFnm@alley>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR06CA0036.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::49) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|MN6PR15MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: e0802779-e4ac-43c3-8e8e-08db733b4323
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rpj2fcYK2ET/AeYVoSz7zH5Uxxi0t12lG8WZ7Vt2CguiFjyJNte2kfJWIANvfQhprjIXZ5gFV9AaWHiLZQ7uvsfeL6qO11vJ47fZXsWfKC7XERUKndUOrtweyfDme4OOc6iQzwdqo3Lu2Y2Yapzem2yFRRiOF3uGxE2DSi6cb6TqxMbPZiN7tV1tWCeiWwfhSv+vm22zS89JuBCRl0uipc3MY2bQIR6Jsd6+eqANycTVsH1rTnd/1siO1n6nJejwSvk3jKEaU5sFHZi4XG1YB4AmSGDbNPfn3A79ZcEKY1ZLhVsOMz/bX0T7tF8wZpnzjlC2sPJRkYwcBYHlOiJ4i20tZCpjeBOjT5aVrDN5ErIruDlrlWz/a9AnFdfgg2N0fgCGo49U93YraFxW0TH/bYyyEerq2XrthQolVmldRDQMbPlJoUkqRq414uQrb2bZSr4DDMwI0A2+K91dzse4ZkOd88BKzUpQVJsRBTQwZibXIdBtId5rCqPmVz9aQ966SxTM69T4Y6Vxlls4OiLfSXnaw86Uw1KkS5ktDarC3hdFRxysjeLEsqLKVbS1R8fu89LTmRA03wZpDidZ9mou37p94Mwq2FqPtKxawroXMzrL1xtgdouBmpew8d+aI8dMef8+NvTdiZILxF/SAnsxCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(346002)(39860400002)(136003)(451199021)(2906002)(6486002)(38100700002)(6666004)(2616005)(83380400001)(6512007)(6506007)(53546011)(186003)(966005)(86362001)(41300700001)(54906003)(31696002)(478600001)(316002)(36756003)(4326008)(6916009)(66556008)(66476007)(66946007)(31686004)(7416002)(5660300002)(8676002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjFxY1ZLOFdTTFBQWEVmTlRZR3NGM1dGTUdHQ0huNVRxVnRXMzVxTHMraEVz?=
 =?utf-8?B?RUMwRTV0ekxsQmpnVlhNTVNVa2toY245UmVVOEtTb01iSEpmT1NoaEFTWlJ4?=
 =?utf-8?B?SlliaG01SjhiY3Z1c3MzU2JyNlVxcmtWWGZyWU5kWkx4WkphOHRIQTVwbEhu?=
 =?utf-8?B?OU9JYUNlQlFxSk9lbFVzSFQ5Rmh1TWJyWUdnK3F4eE1uMFVDUzZyVDJMaDEz?=
 =?utf-8?B?ZjFxUnp1M2JjVmhVYzBucUcydmZsWGNKV0xqTFdDbW5pZE1QNEwvSzRvLzk3?=
 =?utf-8?B?cFVMaVJ1K2diOUVtQ3Q5K0pqTXQ1TXVydlhwRkt4VjNiYjdLTndOQ1BTRXZ5?=
 =?utf-8?B?ZDlXQkE3K2pPZGFkU2UzaEFlUTdaaVl5TWgyNTJTWlhOOTlGSER4K1B2YVNl?=
 =?utf-8?B?a09aMVd5UUhocXcxV1R1UUZWSTN1Tm5xSW9hbmxIbEJ0bnZVTUV5ckluelRP?=
 =?utf-8?B?YTFMUmZORDRGRWRvL2ZYWHpGL1d3aklNZVM3YTVZNDVORndLKzRmUkRhQ2ZS?=
 =?utf-8?B?anZTNVNEV0M5VU90eEE4UVV2RTJrMjVFQXA5RFJZSndqOEtyY1VrUVE4eDdr?=
 =?utf-8?B?NUpIWVlwNkJMMnU3WW9PeUpPdGZ3c2xYUTJ5S1RxNWZ3aVRLMC92ajcycTQx?=
 =?utf-8?B?QzEvU25PMTNqeklIOGlSMGVFVEdnS2o2UkF3dDRCQXlsWDhobXZBMnZBaUF6?=
 =?utf-8?B?ZVZUTWJZMWl4c1NuMmJoMm14ang1djlQbzdERnVhb2FEak8zd3Evck5vQUtX?=
 =?utf-8?B?MDdzZ3NkMmUvOFJ3U3lqWVBMWk1kUENUVzhHWERyTExQL3FtSVdzS3F2WWZO?=
 =?utf-8?B?UVovRGpzTk5hU2pvTlpJSlgyR2gyOXl3bTBvL3o1WkVxb3JLOWpvL255SUxh?=
 =?utf-8?B?SDVmUzFhVW8vTkZCdDFzbVhTUm4xUEJFcTdhaWJOdW54SW0ydlA5Qk0rMWdz?=
 =?utf-8?B?a1lXZnROQitRL0todXZXQnp5cXB5ZlVZZ0RTN1ZsYzczVWF6Sjc0SUZ1L1di?=
 =?utf-8?B?Q0hHdnBKRG56V0Ftc2VHWW1XRkhVNDRtMjVyc0Z4TUthcGI0N1NGeEpwNkxs?=
 =?utf-8?B?cWVOK2lKemF4eGtZSDNZRWUrTnVHMmxGa2FkaWZ3NkNFUkpZYUt2bWxlV3NL?=
 =?utf-8?B?RG5LcjZ4dlE3OEdJYkJiWlJZQnlNbFdvVy9IUXo2SVQzb1U4ZWgza3FodmJj?=
 =?utf-8?B?bnIwYUYrc0VvQVIzNDhWUkw5K2Uvams1MmZ2UzhiZDhUbTFlcTROU3hyVkcz?=
 =?utf-8?B?eThtcHdGTXVCMGFtaTlyTVlqM1pjdHVsUXVnSWRsWGk4VStyMm1XcHVDSXhK?=
 =?utf-8?B?L1pNN045OVcrNXZIcXlJcVA4SlVhSFc0Z0YwUUtaKzBTTFE5TnZmdm85alQ3?=
 =?utf-8?B?bzFVZ2YvZjFLbmhnL3gzRzFaZXVsUzI2aS9UcmI4M0x3a0F5ZWlKOGxqZDVF?=
 =?utf-8?B?Z1pGdTJnRnkxeEtJZFl4eCt3bTcvMUw3K3RnSHBDMmc5MFM4bi82ZUFPY3hu?=
 =?utf-8?B?RFk3cHZUZjNQd0dOcnpnUisxZ1IvOUxLSjVPTGRYMFJiWXQ2YlVpR0lQOVo3?=
 =?utf-8?B?VVJEcUk2M3pQQ3RHWUM1cGxuc28rYTU5NGtrekExZklDUmwwYk56NTdLRlZV?=
 =?utf-8?B?VkNoaGk4cTVvdlIzZDJmQ1BqYzZwNWx0cDlsN2I2Qkx5TnJvZkYyR09QeHho?=
 =?utf-8?B?bTluOHd5U3R6UGdianA5YlRKYjRtYXVsbXRqdlhIRnYrZThOM2F4MVEwa3RR?=
 =?utf-8?B?OFE1MW9BbXZkcXpib0tOZ2N3eEhxVStJSUZLTnZGR2F0dUdFN3pCK3phVCsx?=
 =?utf-8?B?ZDQrMllHNXJiWGtMN1lJV1VKYU5UVk9IQnZya2FwYjc3YTlvcGpLVlZxVE1z?=
 =?utf-8?B?QkltemN0RnVWeVBrWmwrdHNVeXN4MWo0MTgwd0x0ZWk5bjF0bFlacmYweGtZ?=
 =?utf-8?B?VDFzSmc3UThwemhiSlhySUtRL0lvclV3bitmc3JhNm5lQ2U2L2hXdUdHR2Nw?=
 =?utf-8?B?aGtOazJic0FuZ3AraTRaOFpTK1NnQmZxOTdTaWYycHlQZW4xaUQ5SWVTZnMy?=
 =?utf-8?B?U0l2cGk3WHNCbEpWN3dNb2pBc1ZKa1I0RGl5LysvVnUwZmZBbklUQW9xcXdE?=
 =?utf-8?B?ek81UmdRVGZ2S1lyVXhmdWhPWGhyMHk4UFpxL3NlVXFjeGo4NGhZUnpNODVV?=
 =?utf-8?B?bUE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0802779-e4ac-43c3-8e8e-08db733b4323
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2023 16:10:57.1502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ji67UPTtmb4nbssKkv3URe/oG91R8v7mPmhIJ3hSf1wuTMfJKmkW3+E5wZKfbam
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR15MB6313
X-Proofpoint-GUID: kenacb9yyiWfwnaFlN1HPWSaYk4Kw1Hu
X-Proofpoint-ORIG-GUID: kenacb9yyiWfwnaFlN1HPWSaYk4Kw1Hu
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-22_10,2023-06-22_02,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 6/22/23 6:35 AM, Petr Mladek wrote:
> Hi,
> 
> I have added people mentioned in commits which modified
> cleanup_symbol_name() in kallsyms.c.
> 
> I think that stripping ".*" suffix does not work for static
> variables defined locally from symbol does always work,
> see below.
> 
> 
> 
> On Wed 2023-06-21 15:34:27, Yonghong Song wrote:
>> On 6/21/23 12:18 PM, Song Liu wrote:
>>>> On Jun 21, 2023, at 1:52 AM, Petr Mladek <pmladek@suse.com> wrote:
>>>> On Tue 2023-06-20 22:36:14, Song Liu wrote:
>>>>>> On Jun 19, 2023, at 4:32 AM, Petr Mladek <pmladek@suse.com> wrote:
>>>>>> On Sun 2023-06-18 22:05:19, Song Liu wrote:
>>>>>>> On Sun, Jun 18, 2023 at 8:32 PM Leizhen (ThunderTown)
>>>>>>> <thunder.leizhen@huawei.com> wrote:
>>>>> I am not quite following the direction here. Do we need more
>>>>> work for this patch?
>>>>
>>>> Good question. I primary tried to add more details so that
>>>> we better understand the problem.
>>>>
>>>> Honestly, I do not know the answer. I am neither familiar with
>>>> kpatch nor with clang.
> 
>>> This is pretty complicated.
>>>
>>> 1. clang with LTO does not use the suffix to eliminated duplicated
>>> kallsyms, so old_sympos is still needed. Here is an example:
>>>
>>> # grep init_once /proc/kallsyms
>>> ffffffff8120ba80 t init_once.llvm.14172910296636650566
>>> ffffffff8120ba90 t inode_init_once
>>> ffffffff813ea5d0 t bpf_user_rnd_init_once
>>> ffffffff813fd5b0 t init_once.llvm.17912494158778303782
>>> ffffffff813ffbf0 t init_once
>>> ffffffff813ffc60 t init_once
>>> ffffffff813ffc70 t init_once
>>> ffffffff813ffcd0 t init_once
>>> ffffffff813ffce0 t init_once
>>>
>>> There are two "init_once" with suffix, but there are also ones
>>> without them.
>>
>> This is correct. At LTO mode, when a static function/variable
>> is promoted to the global. The '.llvm.<hash>' is added to the
>> static function/variable name to form a global function name.
>> The '<hash>' here is computed based on IR of the compiled file
>> before LTO. So if one file is not modified, then <hash>
>> won't change after additional code change in other files.
> 
> OK, so the ".llvm.<hash>" suffix is added when a symbol is promoted
> from static to global. Right?

Right at lest for llvm >= 15.
There are an alternative format '.llvm.<file_path>' suffix with
a more involved compilation process.
 
https://github.com/llvm/llvm-project/blob/main/llvm/test/ThinLTO/X86/promote-local-name.ll

But for kernel lto build, yes, only '.llvm.<hash>'.

> 
>>> 2. kpatch-build does "Building original source", "Building patched
>>> source", and then do binary diff of the two. From our experiments,
>>> the suffix doesn't change between the two builds. However, we need
>>> to match the build environment (path of kernel source, etc.) to
>>> make sure suffix from kpatch matches the kernel.
>>
>> The goal here is to generate the same IR (hence <hash>) if
>> file content is not changed. This way, <hash> value will
>> change only for those changed files.
> 
> Hmm, how does kpatch match the fixed functions? They are modified
> so that they should get different IR (hash). Or do I miss
> anything, please?

If the static function are promoted to global function and the file
containing static function changed, then that modified static
function will appear to be a *new* function. Live change should
be able to do it, right?

> 
>>> 3. The goal of this patch is NOT to resolve different suffix by
>>> llvm (.llvm.[0-9]+). Instead, we are trying fix issues like:
>>>
>>> #  grep bpf_verifier_vlog /proc/kallsyms
>>> ffffffff81549f60 t bpf_verifier_vlog
>>> ffffffff8268b430 d bpf_verifier_vlog._entry
>>> ffffffff8282a958 d bpf_verifier_vlog._entry_ptr
>>> ffffffff82e12a1f d bpf_verifier_vlog.__already_done
> 
> And <function>.<symbol> notation seems to be used for static symbols
> defined inside a function.

That is correct.

> 
> I guess that it is used when the symbols stay statics. It would
> probably get additional ".llvm.<hash>" when it got promoted
> from static to global. But this probably never happens.

I have not see a case like this yet.

> 
> Do I get it correctly?

yes, that is correct.

> 
> It means that we have two different types of name changes:
> 
>    1. .llvm.<hash> suffix
> 
>       If we remove this suffix then we will not longer distinguish
>       symbols which stayed static and which were promoted to global
>       ones.
> 
>       The result should be basically the same as without LTO.
>       Some symbols might have duplicated name. But most symbols
>       would have an unique one.
> 
> 
>    2. <function>.<symbol> name
> 
>       In this case, <symbol> is _not_ suffix. It is actually
>       the original symbol name.
> 
>       The extra thing is the <function>. prefix.
> 
>       These static variables seem to have special handling even
>       with gcc without LTO. gcc adds an extra id instead,
>       for example:
> 
> 	$> nm vmlinux | grep " _entry_ptr" | head
> 	ffffffff82a2e800 d _entry_ptr.100135
> 	ffffffff82a2e7f8 d _entry_ptr.100178
> 	ffffffff82a32e70 d _entry_ptr.100798
> 	ffffffff82a1e240 d _entry_ptr.10342
> 	ffffffff82a33930 d _entry_ptr.104764
> 	ffffffff82a339c8 d _entry_ptr.104830
> 	ffffffff82a33928 d _entry_ptr.104871
> 	ffffffff82a33920 d _entry_ptr.104877
> 	ffffffff82a33918 d _entry_ptr.104893
> 	ffffffff82a339c0 d _entry_ptr.104905
> 
> 	$> nm vmlinux | grep panic_console_dropped
> 	ffffffff853618e0 b panic_console_dropped.54158

IIRC, yes, these 'id' might change if source code changed.

> 
> 
> Effect from the tracers POV?
> 
>    1. .llvm.<hash> suffix
> 
>       The names without the .llvm.<hash> suffix are the same as without
>       LTO. This is probably why commit 8b8e6b5d3b013b0b ("kallsyms: strip
>       ThinLTO hashes from static functions") worked. The tracers probably
>       wanted to access only the symbols with uniqueue names
> 
> 
>    2. <function>.<symbol> name
> 
>       The name without the .<symbol> suffix is the same as the function
>       name. The result are duplicated function names.
> 
>       I do not understand why this was not a problem for tracers.
>       Note that this is pretty common. _entry and _entry_ptr are
>       added into any function calling printk().
> 
>       It seems to be working only by chance. Maybe, the tracers always
>       take the first matched symbol. And the function name, without
>       any suffix, is always the first one in the sorted list.

Note this only happens in LTO mode. Maybe lto kernel is not used
wide enough to discover this issue?

> 
> 
> Effect from livepatching POV:
> 
>    1. .llvm.<hash> suffix
> 
>        Comparing the full symbol name looks fragile to me because
>        the <hash> might change.
> 
>        IMHO, it would be better to compare the names without
>        the .llvm.<hash> suffix even for livepatches.
> 
> 
>     2. <function>.<symbol> name
> 
>        The removal of <.symbol> suffix is a bad idea. The livepatch
>        code is not able to distinguish the symbol of the <function>
>        and static variables defined in this function.
> 
>        IMHO, it would be better to compare the full
>         <function>.<symbol> name.
> 
> 
> Result:
> 
> IMHO, cleanup_symbol_name() should remove only .llwn.* suffix.
> And it should be used for both tracers and livepatching.
> 
> Does this makes any sense?

Song, does this fix the problem?

I only checked llvm15 and llvm17, not sure what kind of
suffix'es used for early llvm (>= llvm11).
Nick, could you help answer this question? What kind
of suffix are used for lto when promoting a local symbol
to a global one, considering all versions of llvm >= 11
since llvm 11 is the minimum supported version for kernel build.

> 
> Best Regards,
> Petr
