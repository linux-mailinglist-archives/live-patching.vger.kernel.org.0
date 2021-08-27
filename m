Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295153F9C23
	for <lists+live-patching@lfdr.de>; Fri, 27 Aug 2021 18:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbhH0QJR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 27 Aug 2021 12:09:17 -0400
Received: from mail-eopbgr60108.outbound.protection.outlook.com ([40.107.6.108]:44934
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245464AbhH0QJP (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 27 Aug 2021 12:09:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6h3otDVawdojCnDa+IPmvu/snxWxKOkFBx1hmo+8RE1zQN4sy5hMZrzGceNWabZ4rV+SyEjb3RcGPHvQQOEgBKTuGQUPT46uW0gUlyQgrda7PJPK2gDXYlky/jK8As78OeJEb657d5qgPUeLPioGBDXM6cq6FdlDpBeNgKuuSnVHzEYGMBB6uNwYqFrxtSZCn5du0mDpkD8rnX80aGwvC3OKjDq7IpfV2oLbFgmtequR8AuDsTAoxu3BN4OPKL8EgPPHGJLoQQMAS2uuORatJww/jPb1idFTLCeWnfRu3v+80aSB1GMv11t7lnvaBH+MA29x/rC0UF5RqnUk2xLVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SOdTyV9nax4/x3X2mxHchgiC8dyKyqTTaCclY+P1uU=;
 b=e3pjg451FUGQ5FvWutGFYxs7tP3kocfPyQAmuOZZqcewZr5PgXxi9tCs060Xa0uH3uy1/AnRbcXovzrZMr39GYSbeBN5P14KEcSI0sxYe3XyNcsKr0CSa5lIMDg99jRlT2GUb51hBrdydpT87MsQIZpHhUeqzWvY3is+9b0BGAFa+6ZCbD7maQz1Q5lUeg3UxB3Pff1RVTZaPVIcYtLx4PQnlOtMMjQDEdNkfs5IcyX/iMkHAjJreEaBNIB0v4de0yGipzLqAYPGtaejVd7FWgUZEPURWGDzB4jQs7TIeRrExdr4086My9FzuUSaXzu7EQsUR2iqNsRJcx3JvyE1qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2SOdTyV9nax4/x3X2mxHchgiC8dyKyqTTaCclY+P1uU=;
 b=CcTHHrwjczLHujChCnsD1Gg2vP3VdH9aoHs5E0uBvbJv65VroUP+nEJe+shi7xY45I4Vj9W9sWMYwhsVn1IxTDxh5spTKGIaKL23IZQ6ki8HuKbriuTqZJDrNZITfD15lcazpdX1omTBcNHKUd6UkIofwXusW7pn7Y0CFeFSByk=
Authentication-Results: linux.microsoft.com; dkim=none (message not signed)
 header.d=none;linux.microsoft.com; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com (2603:10a6:10:e0::21)
 by DBAPR08MB5621.eurprd08.prod.outlook.com (2603:10a6:10:1a3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.23; Fri, 27 Aug
 2021 16:08:24 +0000
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::c57c:eb1a:4f8a:210b]) by DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::c57c:eb1a:4f8a:210b%3]) with mapi id 15.20.4457.023; Fri, 27 Aug 2021
 16:08:24 +0000
Subject: Re: announcing LLpatch: arch-independent live-patch creation
To:     Peter Swain <swine@pobox.com>
References: <CABFpvm2o+d0e-dfmCx7H6=8i3QQS_xyGFt4i3zn8G=Myr_miag@mail.gmail.com>
Cc:     live-patching@vger.kernel.org, madvenka@linux.microsoft.com
From:   Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Message-ID: <01b7d9fa-d3be-ec36-0863-fd175b62c2b9@virtuozzo.com>
Date:   Fri, 27 Aug 2021 19:08:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <CABFpvm2o+d0e-dfmCx7H6=8i3QQS_xyGFt4i3zn8G=Myr_miag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0021.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::11) To DB8PR08MB5019.eurprd08.prod.outlook.com
 (2603:10a6:10:e0::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.41] (37.144.247.53) by FR3P281CA0021.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.10 via Frontend Transport; Fri, 27 Aug 2021 16:08:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98303b4d-220e-48c3-b518-08d96974e5bf
X-MS-TrafficTypeDiagnostic: DBAPR08MB5621:
X-Microsoft-Antispam-PRVS: <DBAPR08MB5621E30F6F4162C248FB3A7CD9C89@DBAPR08MB5621.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XMhvvo7CNG0lXK77l4WvkWOpuCh+jdrdfh2dQd7qiF029CfksInXoTgg2rV5OMgy6OQOR9uFa+90hGx1QCVwlZ5FOap3I79sZkIoURPEEP4swgO3bpdl32CzVvbN0oAi6XWOMuhmiXZ2rcgpjJ/qgMcKt+7tQvrLmo8A0P3tVtR1rWB7vCP87Z8yiKM1HAZxPV1B15FAgLkU8/rCIJpDE3LEjHpJ37MbE20vYvQ42Bs9cJNGk03aUeAV5oJkyulahQdGahOZSU3L4KKvEyb1ryL/2XlJF7A8jVNgYCqx8rFz27Fboc5fPoE9wri2nuOY/kbDArErIgYZgES0Cl0/45nZJmDFbjjQ7rvwe92XhG57Z9+SuxzeeczoDiaqcOQDJwGDO9y58XoqoelxEtWN8NRQ6070TUDj4BqKycMPmiTBWIGILTzkpBm35eEYq5aOu0GZZWrVDuj4fod9oG01r5QDz4sKT0TX70xAyFM8PopXop4Q1YrBoleKrxQsxFOjeHO2RhfH2sieV+z7eFAmya9lUEbT8FHnwKu7TPAMpzzZs2CvNWtPWq9+PWz4lHodrrvy/k4bb5Swuac27s68jLNZzkD8CuMDB8lPhxkMzwNJeRG51NJGZCPpa9r1G0f48hbwgX7Xyy7FmIN1Tz+axw1yczjAw7rYpVrvXa04MOaVf27l6cVmyemLGrZTJV0V8mZNDxe58aBN2LA88JFd09Jr6/s16E/IbAxCYoVFBSG2F2T3JX8+ty+OrNZ46/SFFaDzC7R84xc8l0psFs7Cayjc1KPAsHV9SumY/pp2TkVT9fNAwS819SAmJxHfmCXbx+Gx7KGVGBNLJ9OT/f1NNCDdOfM2hbDCNrKHbyUityM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5019.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(39830400003)(366004)(396003)(2616005)(53546011)(5660300002)(186003)(66476007)(66946007)(26005)(36756003)(66556008)(38350700002)(16576012)(8936002)(8676002)(6486002)(31696002)(956004)(52116002)(38100700002)(478600001)(83380400001)(31686004)(316002)(4326008)(966005)(86362001)(2906002)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aThFZk5DUEI2VHFCTHduYWN3TXNDb1d2OEpkMmFrV082VmIzZVAwa0ltU05x?=
 =?utf-8?B?bmhETzMvN0pPVGQxR0UrYXc2SEU0MEJTWVpGUVpseHk2U2huNHVmUWVHblVQ?=
 =?utf-8?B?Q0ozbTV3blNMY0R6a3hjL1NhQ3B3N2Z1VHpsUTY3QktqT2g5OUdCR3NJWUhw?=
 =?utf-8?B?cWlKUm90MDF4M1NFTGVTSlFTbU9xbXJhbGROdUhVL1UzZ0dUUWxGWGNWSXRx?=
 =?utf-8?B?Vk1GVTMra3hZa1lrSlUwNy9qZjlSRXMrY0w1a0FaK1lxNDg4cmk0c2Q5NWlL?=
 =?utf-8?B?VUNDeERhNHc3d0xuekNrSG1jdXRETlJiSFJ0WEhScmxqYm5wcStieGw0U0J4?=
 =?utf-8?B?TEdZcm14NnVUUmpEYW1hQitLaVowMFZMcDkxejB2RGl5TkFZRGdmREY0czlw?=
 =?utf-8?B?TGczeXBmZGNva2w2d2V2Nk05eXYrOUtxSjVqbFNNd3I2Sis2K2pmeERJczBv?=
 =?utf-8?B?MSt6OUZIajIxZzZva3dkY0ZEU0lkV2NZS0lpcUhRRi9ZVEFiY2N2L21zUk4w?=
 =?utf-8?B?blpUcDFjaWdGaEhsaW5EOFBwQVNzL05QamFWY3lFVEllS3N4eTQ0aCtJcTgy?=
 =?utf-8?B?eGM0MGZ4MmxxTStoSEcxRFlHUVM2c3B0ald0Y0NsNlBBL29aQzJyb1FXT3Z5?=
 =?utf-8?B?VTI4OHZEYzZWMXFrcWhRdGhMRGhsUnFuZkppYmExMnZra1ZUKzRpN0lHSDNK?=
 =?utf-8?B?U3pWOFhEMG9LM2h0d0VOMUFnS0tzeEwrazRKQUtENzBXYkNEL1BRTkE4ZUZr?=
 =?utf-8?B?T24wR2ovTzhPY0IxclVhMDJXTktGWXR5dWRFZkhEWHErcmJIN2llMC9UWEJO?=
 =?utf-8?B?Q2FVWThoRmVMNldEZTUxOFJ4Vjl0em1KS0taRmxJQWh0UGpjOXhNcDAxYzFI?=
 =?utf-8?B?cGtGUlplNGVRZzNBR083YTU2Z3ZlMVBCb2g5MXR2WTNLZmlPRHZVd1dtQTdU?=
 =?utf-8?B?T3Q5ZU9SaVptY0FnWitadnBLaWFmZXFGVjN5MXFxOUNlWXVjdjBXeU1kVHRH?=
 =?utf-8?B?amNnSzhUaDRSeExlOE9zMW9KcHp4UUZtVE45c1JneERlNHltVUplNTZHZFh1?=
 =?utf-8?B?OFoyVHozTWRCNTZvb2phaUpROHdyZk9KOWxZRTExWVEwbzU4ZTd5R1R3d1Nt?=
 =?utf-8?B?cThZTnlvdWJOWFA3dDZObFE0cU92aWh4N09SUFB4T1JMV1UwcXZqRzAvWGpQ?=
 =?utf-8?B?STRISWcrelBpNy84cG5MeXZ2cU1aMEo4ekIyUGJsMVhjVDA5SjhtYkJuSFcz?=
 =?utf-8?B?WHc3ZVNaci9BTjl4U1VjbE1lUll6UU1TWVI2UHhiWlJDc2gvL2UxRTF5RG5E?=
 =?utf-8?B?bjlNOVBTeWF3YUt1U0tuSXRnaHQ0U05ZdU9TMXhqRnhweC9KYkVGVTBJeXV0?=
 =?utf-8?B?YVV1K2xEaUUwT21CYXBGMW9vcHZmeEJKVGtqNGhlVHNCQXNNZUYvQi9vd0wv?=
 =?utf-8?B?WW9zcGhHaWVOZjQzVnhkWElhUXVHbGJrQ0FJMitlMDMwdC9VWnVTbFBGUWNZ?=
 =?utf-8?B?eUphK2ZTRlZWcEdrTjlJSEJqZnZQR2NtZEhXODkra2JTMXVhQ0VpT1NlVDVX?=
 =?utf-8?B?dEZzRlRLbDBudXZReVNiNXFtUjFKeUdjMUtTZ0hTWjZ2SkdSTXNLTis3dmhX?=
 =?utf-8?B?NEg0RzZTN2NVWFJQKzRPNEVTVXVha3lZWFhpRmhUQk5rMDFYNFVsUU1nZVBO?=
 =?utf-8?B?WTZLSUVaR0N3SmFPMUlNTEp4bFhmWlczYTdWWTZEbHQ4RkFJdVVtb213K2VY?=
 =?utf-8?Q?Xyv3HVEMRjaG19K5+NtlWH/aSJob2E9XCgHC7hH?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98303b4d-220e-48c3-b518-08d96974e5bf
X-MS-Exchange-CrossTenant-AuthSource: DB8PR08MB5019.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 16:08:24.2784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CakG0SJDP+eXjw257OrwBbBJX4Ii3CGtdajA5LUCER0bT7f0WYrvPCEYOS2tODblLvZuE63PurXJJb6nsbRSgf9JuYTBmSTLwN6jQMC3L58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR08MB5621
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

On 27.08.2021 01:34, Peter Swain wrote:
> We have a new userspace live-patch creation tool, LLpatch, paralleling
> kpatch-build, but without requiring its arch-specific code for ELF
> analysis and manipulation.
> 
> We considered extending kpatch-build to a new target architecture
> (arm64), cluttering its code with details of another architecture’s
> quirky instruction sequences & relocation modes, and suspected there
> might be a better way.
> 
> 
> The LLVM suite already knows these details, and offers llvm-diff, for
> comparing generated code at the LLVM-IR (internal representation)
> level, which has access to much more of the code’s _intent_ than
> kpatch’s create-diff-object is able to infer from ELF-level
> differences.
> 

Interesting.

LLpatch requires a pre-built kernel tree ("repository"), right?

Does that mean that the kernel should be built with clang first?
Or, perhaps, clang is only used when building the patch itself, while 
the kernel can be built with GCC or other compiler used by the given 
Linux distro?

> 
> Building on this, LLpatch adds namespace analysis, further
> dead/duplicate code elimination, and creation of patch modules
> compatible with kernel’s livepatch API.
> 
> Arm64 is supported - testing against a livepatch-capable v5.12 arm64
> kernel, using the preliminary reliable-stacktrace work from
> madvenka@linux.microsoft.com, LLpatch modules for x86 and arm64 behave
> identically to the x86 kpatch-build modules, without requiring any
> additional arch-specific code.
> 
> On x86, where both tools are available, LLpatch produces smaller patch
> modules than kpatch, and already correctly handles most of the kpatch
> test cases, without any arch-specific code. This suggests it can work
> with any clang-supported kernel architecture.
> 
> 
> Work is ongoing, collaboration is welcome.
> 
> 
> See https://github.com/google/LLpatch for further details on the
> technology and its benefits.
> 
> 
> Yonghyun Hwang (yonghyun@google.com freeaion@gmail.com)
> Bill Wendling (morbo@google.com isanbard@gmail.com)
> Pete Swain (swine@google.com swine@pobox.com)
> .
> 

Regards,
Evgenii
