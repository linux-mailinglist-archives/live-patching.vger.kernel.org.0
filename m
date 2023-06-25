Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7B773D31E
	for <lists+live-patching@lfdr.de>; Sun, 25 Jun 2023 21:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjFYTIB (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 25 Jun 2023 15:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjFYTH7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 25 Jun 2023 15:07:59 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1A41AD
        for <live-patching@vger.kernel.org>; Sun, 25 Jun 2023 12:07:58 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 35PCdA6j021667;
        Sun, 25 Jun 2023 12:06:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=el3fWTnxU+JFI5InyXXh+CrLJmZJ51jmHonZ9Uw31EY=;
 b=QyWqTEgWLUDvTrdhQPfEI5O5ntZiMvQ23w3CV+l/OQIpZ7kex9QK03kR6mi2GDhHGbfp
 +kvCBlaKUEQcvkO/w66BERb+mgaNobfqo9OKnLJuS1qWbye8N97nW9Jal/1NlIbifX+5
 LZW0VDNCv792pbHXQqwNpBwr+L1XYWrFNdg2nl9wzRefpaFTKWM96igN0biShXFbKeed
 58sZZj3EAKca0YyedizIH+vGfKEvJLkTEnCCd1FZY+BvpDtiFG37Nzp2br7RGm8Udq+R
 fdj2hyAiyl5CbmMiA42wQslEwKHcVu8MGEax1twIIH+s8SrAzKtWzgAwyqgIKVIJdri1 wQ== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by m0089730.ppops.net (PPS) with ESMTPS id 3rdv098y65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 25 Jun 2023 12:06:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Otk1AhtfYh7uNcxxdDS/wHO7v15wE4iRd0nm227gZIRst+dvnJOqr2VdbNA+4d5FBlUzkCVu+MfqsqQ8ar8WyHz9VF0rdb7S2/o2aroCiENDYKLVH2jReH/F9z0itjMkNwNvrWegFVvf0bKV1zte2LfgsxU1rYlc3N/l/zoNEy6J+Xz7OagJ6HRnkEDzhWNw1x9H4+/kid5JD8WlIb9NX3w6z/5zl3mmlegT0+VvLSkxbXF4rL6eC+PBgm3SfyaFQUwvZCi/B6D5aOgmX3Ih1SxSLkhBcLST5Z9j2enVWTEG6vGr25xaT0ATOo8s9RvrsR8FNUpvo112Fkxd68qWFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=el3fWTnxU+JFI5InyXXh+CrLJmZJ51jmHonZ9Uw31EY=;
 b=FCJd2T1tnOPmT6snMiyO7uE4Gm+sevrHL6+b162ZkkwXNhzw+JDN/c462ASOb++JbQXPlPJILM/++OenQBoDUiRjXzzSQe2/rv99EMuSIoSrxzMfaIvA0Ti31RRLfYEpwlk+voVMuO9iaca7PTFLS4p6ANpSK0OL0HpwdottI2OupSTpjj2bFpuJokpkTUScEN1uh//HJSnl7RJeQx0OqOP0+wNSME5I7sIGhbzVHTNUtPs4BbBSYmRYONhXA1m4tf8JSZroiG1jqndFt1SnfJ73Tfq7LwEY4/t8SeLuFj09Snw/cU3Zab47E0bch7R2XoRx8Fm0wuLhQF7FvIvMPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by PH7PR15MB5666.namprd15.prod.outlook.com (2603:10b6:510:272::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.37; Sun, 25 Jun
 2023 19:06:51 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::428f:acec:2c1f:c812]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::428f:acec:2c1f:c812%7]) with mapi id 15.20.6521.024; Sun, 25 Jun 2023
 19:06:51 +0000
Message-ID: <56ea6446-7a20-a58c-168d-03bf3dc6b51a@meta.com>
Date:   Sun, 25 Jun 2023 12:06:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH] kallsyms: let kallsyms_on_each_match_symbol match symbols
 exactly
Content-Language: en-US
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Petr Mladek <pmladek@suse.com>, Song Liu <songliubraving@meta.com>,
        Song Liu <song@kernel.org>,
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
        Pete Swain <swine@google.com>,
        clang-built-linux <llvm@lists.linux.dev>
References: <20230615170048.2382735-1-song@kernel.org>
 <3c0ea20b-fae7-af68-4c45-9539812ee198@huawei.com>
 <07E7B932-4FE1-4EEF-A7F7-ADA3EED5638F@fb.com>
 <b6af071b-ec26-850b-2652-b19b0b14bd4b@huawei.com>
 <CAPhsuW6nrQ-O3qL6TsR3rypEk03+X8z0-scGwO3Z5UAGz72Yzw@mail.gmail.com>
 <ZJA8yohmmf6fKsJQ@alley> <47E4EA81-717E-43A2-8D6D-E7E0F2569944@fb.com>
 <ZJK5tiO3wXHiBeBh@alley> <E47B9D18-299C-4F95-B4F6-24DB6A54A79F@fb.com>
 <6df9b18c-d152-942a-b618-bb8417c7b8cd@meta.com> <ZJROPO1ukwMyYFnm@alley>
 <3c1a953a-c77e-b38c-a7f8-15931ef2d6dd@meta.com>
 <CAKwvOdkvheeuF66LFAuVuYkO1cMM9ixasrmkBFpd=XSagEWgTQ@mail.gmail.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <CAKwvOdkvheeuF66LFAuVuYkO1cMM9ixasrmkBFpd=XSagEWgTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR13CA0126.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::11) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|PH7PR15MB5666:EE_
X-MS-Office365-Filtering-Correlation-Id: 960736f9-5c86-4451-2fd7-08db75af553f
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TyM4SP9/6uQQLq9kk9thIAM+e7/KxT9YGYD7vWtru6UmALYiPsA/vCQKYTrbvOFvC3Xft9e1fZ6lJWkjAT8WhM1xHAvMVlx8dS46vsd8qL5aHHjgJiLGyGuK4bmO6N/i1ESC4/qD2TqrpRgzfN1eG6WDcXFlu1dyiwBIqBoo4V5rGWEyrh6K89gTr1v3cmQOsRhTrzogi8FDUwHdlJrMZe+/BiKpCY+0TxeHw45MOSWXF8zYm3UCEn9Ah01vDS2996SppoV4oSQUIfRqKk862ndExBLEh7gxt7LnVDoeaIJP/18ia6U3xhaUWYVoEu6wkKbsu2LPjhOySIN+Yr2R+8mO0Rvl5k9ZIGhsORzadPGkihmF6MAnAx9fqY8IF4eI8LjR3lQ0AAm5F/hXgr+UMQXRBcx2UCwOYAOXSc0WoPjWisvkSGy7nrDcO6HhCtah3QpNQcc9hKiPU2YrkhdtJh8XzNnsWfzmkh/ri+H14elJFmra4V8ps0WgRNeWtZxRNvxn+chLAfpkKMRD+lxH9jXmIw3qbBdIrnBoHww4w4VpPhEqcSiRmwTkqwKA4zYZPRQoEy296ovbOg6Ps5gtmIU4vhSEGHTxvcOQPs/H70c8UrxS+anWmskTHJ1zmz1ZXPgmRz34hc8oDrx5C656JXusm3Dme4uOJm90HTwQpKSW1POOjP7h3bHLZAUzMQAC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(39860400002)(136003)(376002)(346002)(451199021)(7416002)(31686004)(5660300002)(6916009)(316002)(66476007)(66946007)(66556008)(478600001)(36756003)(4326008)(8676002)(8936002)(2906002)(966005)(54906003)(31696002)(86362001)(41300700001)(6486002)(53546011)(6512007)(6506007)(186003)(30864003)(6666004)(38100700002)(83380400001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkpZWjZoNWFKOXJUc2l6ZUV5cDdyN2kvcUpPWDRIWmtMRGhEZXFzbDlLV0xk?=
 =?utf-8?B?Y1dGTTVTbUJ5VnRtZ0lTUkRFMWZaVmxGRGl6aUVDSGw5UmQyOFBBYVlOYUJE?=
 =?utf-8?B?YjE4dFQ0czNEWDJuT0txakZpaWh2WmhVeEIzZEpFV090TVJPMkdTdzBBTHVh?=
 =?utf-8?B?eFZQR2dPWGdRVjdjNjU4NVkzZzEwb3VhZFVUdnltcER3MDhGaFFYZFdjRW9y?=
 =?utf-8?B?Qkw5amJxdmV2NENlYzBQRENPclFoSUtJTWUrYmVlYTg4Wjh4RVdnSzlpYTRX?=
 =?utf-8?B?dEttZWl0SkQzYTREY3BnL083TXB1R1pCUDhDYnp3Z0tSZXY5T29yZnJiYVUz?=
 =?utf-8?B?Mzl0ZFRpdWFlTzNQTmhCdEdrZGJwOWRxb2JiME9Jb3dvNDhuMGRuY0wxMzRp?=
 =?utf-8?B?cllNUkY0TTBxbzY4bXowcWRWK1VFUDhpRGppczhhNThmMlk5bHlvekp0R0xZ?=
 =?utf-8?B?ZnliYlVxcVpqbzlVQWZkU2kyRGFQQ1pmSTJ5eUpLY0N3MEw1Nk4zL3hOclZB?=
 =?utf-8?B?cFVBbW4wZW1STUR6Vyt0Q29LejROVGJmakdRM2hxTHYrNUpLV29CYnZMLzQw?=
 =?utf-8?B?ZXh4Qml2RHYwQlhsdDJDclVPME9tNDllV1QveE9XL0FabUNaUTFweUdGQ0ZS?=
 =?utf-8?B?Y3VYYmJzMllHN2NTSkdTRURqVHFiQmMrZ3cwZ2tTN2JIZk5uTlhiMFRWYjRW?=
 =?utf-8?B?L2lDZndWVnhKNDRVaDFac0NsWmJTc0Y1a2hpZUxpUnhiRVpnVVlzR1hEUS9m?=
 =?utf-8?B?RVQyMGliRmxVbVpnSkthaVBCQUp3d3RQeEVyT0pxQUl0QkhHWkFWSzEzdjJl?=
 =?utf-8?B?NThYRmU0Z2ppeFg0R0R3VHBod0dmTmduQ1BiRnZwVjBBZlhUSDFSN1FPRDR5?=
 =?utf-8?B?YlNONkxYMElZVXVvelFLVEpVald0NjRUQ01UT2s0YlZDeDZKby9TajEvUTZj?=
 =?utf-8?B?OTZIcmtjTURlSWd4c0J4TWtmMXMxbkd0NWdwNm43dHhVWkJiQjlaL1FDS3Vx?=
 =?utf-8?B?bmZzMWRBWU9pU0lybFdOQWJFbTNRQkxLcVRER2ZxWmlWZUhwR0dybHUzZnh4?=
 =?utf-8?B?SzV6RHMzdTlXdjRyNko5Sk1XREs2Q3d3bVF1WHlaQTNlRjVOK0VCUGhmcFV4?=
 =?utf-8?B?ejdYZ3JZQk9DOElTb1E1L3dMWS9XUEN1NFo4cFNBY0dNNTBnWjh2bHlvYmVN?=
 =?utf-8?B?OUVVVmVnQThCQ0FvK3dkdndkWjR3S05zZ1E0VFZaZitmd3BSWm1vbUpjSjRk?=
 =?utf-8?B?ZTd4cXcyL2M3V1g2V1RxM0dBTThheURHNENqdkhTRHdUV0ZkU04vMHpyNWZ6?=
 =?utf-8?B?NUVHcVNIcDVldzRteXlwMU1qcWQxMmdSQUkyNzdseGpLcHZWR1U3N253d0hS?=
 =?utf-8?B?TjcrYlJlVG1qNE1jczJCcWJFZ3JaOHZRdUlyV2NJQ2NLVldZTE9zdU5HRkpt?=
 =?utf-8?B?SjdTRGl6SVYyeUJNTHFtSExtYnNFRWFkUDhpSnErK2lJYytrK2JsRjZiQ0x5?=
 =?utf-8?B?QUNXaW9UaGVYWmMvM21sSGEvSHJsOEZTODRDMXYzZ1Z1b0NzZm1KanduUTRk?=
 =?utf-8?B?UjJLU29lelRqeUJGOHBDMm1QVThWQjlRZGpRZFdPSGxZUlIyMVFPS2dyOEtM?=
 =?utf-8?B?eDRWaWM5TkIwSnhJNnNNZ2tkck10WDhRYldzWHRWWncweWpYWWpaTHlRRlY4?=
 =?utf-8?B?ZFlFTHdMbHZ4Vmw4OWIyVHk0SGJaUTJ1WFVXRVQzTXV4d1F4ck5STGdzandQ?=
 =?utf-8?B?SW1XbXJDbi9PTmQ5Mnl3aHg3bkZodjBFZTZtWU1sa1Nhb1NrT1k4cWhKT2d5?=
 =?utf-8?B?R3hmbC9qUWNuZWJTdnNMNlMwUitSeWpyM1E4N1JPQXNXVjZpWTFvNTJZZUdi?=
 =?utf-8?B?WVZIb0gvMFBPRUhsVDB5dEZRSmhJNlgwb0dFY29GTllMUGJaWEM0bTRtcENu?=
 =?utf-8?B?bWxBb1VhTmd1WHM4RWQreGpEdUFlNVB2emdyRlFqcXI0ZHFyWVZ3RExYZVQw?=
 =?utf-8?B?NTNvVWNxZXhTT2dMeWx0SUhqU0YzRDFwN3VGQ1p5MjhYYzZBdTcrTk9oNTAy?=
 =?utf-8?B?ekpuS040OUpsblJLZzZGb2ozM3prM2JlTlpCOWI1QUxXWmNPekNCZytYL1RR?=
 =?utf-8?B?a0hqVC85Y3JyMDNoYldzTnFGM1dWSHpEQnM3aHdPT2hxTENXWHdpdFNqa3NB?=
 =?utf-8?B?N3c9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 960736f9-5c86-4451-2fd7-08db75af553f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2023 19:06:51.4188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pYtuAm2IHFsVZHBLdn77sPRQI22rlj08dkKqDuAJHCQQnlc4ScRhF0m2Cdt9lqvl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5666
X-Proofpoint-GUID: T_wsaJjaWXwRvJJW0Fbpv2o7X6S7JEZa
X-Proofpoint-ORIG-GUID: T_wsaJjaWXwRvJJW0Fbpv2o7X6S7JEZa
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-25_12,2023-06-22_02,2023-05-22_02
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org



On 6/23/23 10:43 AM, Nick Desaulniers wrote:
> On Thu, Jun 22, 2023 at 9:11 AM Yonghong Song <yhs@meta.com> wrote:
>>
>>
>>
>> On 6/22/23 6:35 AM, Petr Mladek wrote:
>>> Hi,
>>>
>>> I have added people mentioned in commits which modified
>>> cleanup_symbol_name() in kallsyms.c.
>>>
>>> I think that stripping ".*" suffix does not work for static
>>> variables defined locally from symbol does always work,
>>> see below.
>>>
>>>
>>>
>>> On Wed 2023-06-21 15:34:27, Yonghong Song wrote:
>>>> On 6/21/23 12:18 PM, Song Liu wrote:
>>>>>> On Jun 21, 2023, at 1:52 AM, Petr Mladek <pmladek@suse.com> wrote:
>>>>>> On Tue 2023-06-20 22:36:14, Song Liu wrote:
>>>>>>>> On Jun 19, 2023, at 4:32 AM, Petr Mladek <pmladek@suse.com> wrote:
>>>>>>>> On Sun 2023-06-18 22:05:19, Song Liu wrote:
>>>>>>>>> On Sun, Jun 18, 2023 at 8:32 PM Leizhen (ThunderTown)
>>>>>>>>> <thunder.leizhen@huawei.com> wrote:
>>>>>>> I am not quite following the direction here. Do we need more
>>>>>>> work for this patch?
>>>>>>
>>>>>> Good question. I primary tried to add more details so that
>>>>>> we better understand the problem.
>>>>>>
>>>>>> Honestly, I do not know the answer. I am neither familiar with
>>>>>> kpatch nor with clang.
>>>
>>>>> This is pretty complicated.
>>>>>
>>>>> 1. clang with LTO does not use the suffix to eliminated duplicated
>>>>> kallsyms, so old_sympos is still needed. Here is an example:
>>>>>
>>>>> # grep init_once /proc/kallsyms
>>>>> ffffffff8120ba80 t init_once.llvm.14172910296636650566
>>>>> ffffffff8120ba90 t inode_init_once
>>>>> ffffffff813ea5d0 t bpf_user_rnd_init_once
>>>>> ffffffff813fd5b0 t init_once.llvm.17912494158778303782
>>>>> ffffffff813ffbf0 t init_once
>>>>> ffffffff813ffc60 t init_once
>>>>> ffffffff813ffc70 t init_once
>>>>> ffffffff813ffcd0 t init_once
>>>>> ffffffff813ffce0 t init_once
>>>>>
>>>>> There are two "init_once" with suffix, but there are also ones
>>>>> without them.
>>>>
>>>> This is correct. At LTO mode, when a static function/variable
>>>> is promoted to the global. The '.llvm.<hash>' is added to the
>>>> static function/variable name to form a global function name.
>>>> The '<hash>' here is computed based on IR of the compiled file
>>>> before LTO. So if one file is not modified, then <hash>
>>>> won't change after additional code change in other files.
>>>
>>> OK, so the ".llvm.<hash>" suffix is added when a symbol is promoted
>>> from static to global. Right?
>>
>> Right at lest for llvm >= 15.
>> There are an alternative format '.llvm.<file_path>' suffix with
>> a more involved compilation process.
>>
>> https://github.com/llvm/llvm-project/blob/main/llvm/test/ThinLTO/X86/promote-local-name.ll
>>
>> But for kernel lto build, yes, only '.llvm.<hash>'.
>>
>>>
>>>>> 2. kpatch-build does "Building original source", "Building patched
>>>>> source", and then do binary diff of the two. From our experiments,
>>>>> the suffix doesn't change between the two builds. However, we need
>>>>> to match the build environment (path of kernel source, etc.) to
>>>>> make sure suffix from kpatch matches the kernel.
>>>>
>>>> The goal here is to generate the same IR (hence <hash>) if
>>>> file content is not changed. This way, <hash> value will
>>>> change only for those changed files.
>>>
>>> Hmm, how does kpatch match the fixed functions? They are modified
>>> so that they should get different IR (hash). Or do I miss
>>> anything, please?
>>
>> If the static function are promoted to global function and the file
>> containing static function changed, then that modified static
>> function will appear to be a *new* function. Live change should
>> be able to do it, right?
>>
>>>
>>>>> 3. The goal of this patch is NOT to resolve different suffix by
>>>>> llvm (.llvm.[0-9]+). Instead, we are trying fix issues like:
>>>>>
>>>>> #  grep bpf_verifier_vlog /proc/kallsyms
>>>>> ffffffff81549f60 t bpf_verifier_vlog
>>>>> ffffffff8268b430 d bpf_verifier_vlog._entry
>>>>> ffffffff8282a958 d bpf_verifier_vlog._entry_ptr
>>>>> ffffffff82e12a1f d bpf_verifier_vlog.__already_done
>>>
>>> And <function>.<symbol> notation seems to be used for static symbols
>>> defined inside a function.
>>
>> That is correct.
>>
>>>
>>> I guess that it is used when the symbols stay statics. It would
>>> probably get additional ".llvm.<hash>" when it got promoted
>>> from static to global. But this probably never happens.
>>
>> I have not see a case like this yet.
>>
>>>
>>> Do I get it correctly?
>>
>> yes, that is correct.
>>
>>>
>>> It means that we have two different types of name changes:
>>>
>>>     1. .llvm.<hash> suffix
>>>
>>>        If we remove this suffix then we will not longer distinguish
>>>        symbols which stayed static and which were promoted to global
>>>        ones.
>>>
>>>        The result should be basically the same as without LTO.
>>>        Some symbols might have duplicated name. But most symbols
>>>        would have an unique one.
>>>
>>>
>>>     2. <function>.<symbol> name
>>>
>>>        In this case, <symbol> is _not_ suffix. It is actually
>>>        the original symbol name.
>>>
>>>        The extra thing is the <function>. prefix.
>>>
>>>        These static variables seem to have special handling even
>>>        with gcc without LTO. gcc adds an extra id instead,
>>>        for example:
>>>
>>>        $> nm vmlinux | grep " _entry_ptr" | head
>>>        ffffffff82a2e800 d _entry_ptr.100135
>>>        ffffffff82a2e7f8 d _entry_ptr.100178
>>>        ffffffff82a32e70 d _entry_ptr.100798
>>>        ffffffff82a1e240 d _entry_ptr.10342
>>>        ffffffff82a33930 d _entry_ptr.104764
>>>        ffffffff82a339c8 d _entry_ptr.104830
>>>        ffffffff82a33928 d _entry_ptr.104871
>>>        ffffffff82a33920 d _entry_ptr.104877
>>>        ffffffff82a33918 d _entry_ptr.104893
>>>        ffffffff82a339c0 d _entry_ptr.104905
>>>
>>>        $> nm vmlinux | grep panic_console_dropped
>>>        ffffffff853618e0 b panic_console_dropped.54158
>>
>> IIRC, yes, these 'id' might change if source code changed.
>>
>>>
>>>
>>> Effect from the tracers POV?
>>>
>>>     1. .llvm.<hash> suffix
>>>
>>>        The names without the .llvm.<hash> suffix are the same as without
>>>        LTO. This is probably why commit 8b8e6b5d3b013b0b ("kallsyms: strip
>>>        ThinLTO hashes from static functions") worked. The tracers probably
>>>        wanted to access only the symbols with uniqueue names
>>>
>>>
>>>     2. <function>.<symbol> name
>>>
>>>        The name without the .<symbol> suffix is the same as the function
>>>        name. The result are duplicated function names.
>>>
>>>        I do not understand why this was not a problem for tracers.
>>>        Note that this is pretty common. _entry and _entry_ptr are
>>>        added into any function calling printk().
>>>
>>>        It seems to be working only by chance. Maybe, the tracers always
>>>        take the first matched symbol. And the function name, without
>>>        any suffix, is always the first one in the sorted list.
>>
>> Note this only happens in LTO mode. Maybe lto kernel is not used
>> wide enough to discover this issue?
> 
> Likely.
> 
>>
>>>
>>>
>>> Effect from livepatching POV:
>>>
>>>     1. .llvm.<hash> suffix
>>>
>>>         Comparing the full symbol name looks fragile to me because
>>>         the <hash> might change.
>>>
>>>         IMHO, it would be better to compare the names without
>>>         the .llvm.<hash> suffix even for livepatches.
>>>
>>>
>>>      2. <function>.<symbol> name
>>>
>>>         The removal of <.symbol> suffix is a bad idea. The livepatch
>>>         code is not able to distinguish the symbol of the <function>
>>>         and static variables defined in this function.
>>>
>>>         IMHO, it would be better to compare the full
>>>          <function>.<symbol> name.
>>>
>>>
>>> Result:
>>>
>>> IMHO, cleanup_symbol_name() should remove only .llwn.* suffix.
>>> And it should be used for both tracers and livepatching.
>>>
>>> Does this makes any sense?
>>
>> Song, does this fix the problem?
>>
>> I only checked llvm15 and llvm17, not sure what kind of
>> suffix'es used for early llvm (>= llvm11).
>> Nick, could you help answer this question? What kind
>> of suffix are used for lto when promoting a local symbol
>> to a global one, considering all versions of llvm >= 11
>> since llvm 11 is the minimum supported version for kernel build.
> 
> For ToT for this case, the call chain backtrace looks like:
> 
> ModuleSummaryIndex::getGlobalNameForLocal
> FunctionImportGlobalProcessing::getPromotedName
> FunctionImportGlobalProcessing::processGlobalForThinLTO
> 
> This has been the case since release/11.x.
> 
> LLVM uses different mangling schemes for different places. For
> example, function specialization (that occurs when sinking a constant
> into a function) may rename a function from foo to something like
> foo.42 where a dot followed by a monotonically increasing counter is
> used. Numbers before may be missing from other symbols (where's .41?)
> if they are DCE'd (perhaps because they were inlined and have no more
> callers).  That is done by:
> 
> ValueSymbolTable::makeUniqueName which is eventually called by
> FunctionSpecializer::createSpecialization.
> 
> That is the cause of common warnings from modpost.
> 
> There are likely numerous other special manglings done through llvm.
> The above two are slightly more generic, but other passes may do
> something more ad-hoc.

Thanks for the information. I checked 
FunctionSpecializer::createSpecialization and this also happens
without LTO. But here, we are discussing at LTO mode.
See 
https://github.com/torvalds/linux/blob/master/kernel/kallsyms.c#L166-L188

Let us say, without LTO, through function specializer,
two functions are generated:
    foo
    foo.58
and live patching for 'foo' can be done correctly
since live patching is able to match 'foo' precisely.

Now, the kernel is built with LTO, and two functions
are still generated
    foo
    foo.58
With current code, live patching searching a 'foo'
function and both function 'foo' and 'foo.58' will
be returned. If live patching intends to search
'foo.58' and actually there will be a mismatch.

There are also another case we discovered above,
    foo
    foo._entry (static variable inside foo)
    foo._entry_ptr (static variable inside foo)

These three symbols will be generated without LTO
and it works fine for tracing and live patching.

But at LTO mode, searching 'foo' will get
three symbols, and at least live patching
won't work any more.

Do you really have a use case that
foo.* (excluding foo.llvm.*) cause a problem?
Could you share it?

> 
>>
>>>
>>> Best Regards,
>>> Petr
> 
> 
> 
