Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAF73FA3EF
	for <lists+live-patching@lfdr.de>; Sat, 28 Aug 2021 08:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhH1GFT (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 28 Aug 2021 02:05:19 -0400
Received: from mail-am6eur05on2111.outbound.protection.outlook.com ([40.107.22.111]:10848
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229555AbhH1GFS (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sat, 28 Aug 2021 02:05:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A3KExzTxe4bgXTxOG/nYnwnnWCPMFe8DrYlFX5Mq/rbMwmooWVV7EqsYqGq6zo+l28y/BllK69HtZoxgqIrVUv5qxk6eYhMglHnfhjQ0uArGh4cdAf87hotTfPxG/NO5rcT/DT9V2P79qXtFHWiPdVGxIWmcGNgsmWc1QiZMw0ZXRC07yNxSaZDrrDyM98NVLTRQLqTDXmVQ515yMNlSabtqa5wTtCFK3YAlMWF1KMzF7gt9B+8yYOpaNM06WrSUQH5kHV91spcu97zskE8qypNF1ZswfwgMMhypAUZws8MDj9grWIc/OjFHpDRtU4OtBRRedrXH6e7dY5hLqKD9xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Da+JX+qnbX74BEc3yKdGt8jXmjbm0fP8HfCzmH/kbiA=;
 b=VFhLGouhAzGidsmTjdo5vbhgP0kJdWfr4spOuKIi3l+MvFbFoG22UMfypYna5Wi05WhxZMCw3XrGyg4HtOzhAZuBSlslkniZylpg6RLiPlxqX1jyUwweGLgTMBswKE0Wdb4TOhd+xU9DOAHevbNnWOnH/HZ7JOHTffEsV4u5zWeZqL8jicIdd127d+yc0HP3Szbi/IgnDWr8ziGVAawVtGrIpwDoidtF/j26aPkxj6G4sMDGiMiBoPirzQWdckZ8kG+h/GuyuqX3PAcjKe1YR7IF6EULSyxd/3DpGwICi8+pmdPmgXbc2ylRwqIRzZFgWkAT5q9kchs1m5SnTxZJaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Da+JX+qnbX74BEc3yKdGt8jXmjbm0fP8HfCzmH/kbiA=;
 b=q9cRV8QTsoVoZtXOrU8y7o++aoaC7GqipNjzUXAfNpAbRjKOyccwvk7LRKCnOR0LTPJhl0eV6VN841ViNVNewtCSfc+XPRkm82E7RzjE3HUQnDn127gzkrxGbGUiDMWddHEvZ2cJhkklqMRqybKGdk7m9/1efgA0DO8CeoykPOI=
Authentication-Results: linux.microsoft.com; dkim=none (message not signed)
 header.d=none;linux.microsoft.com; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com (2603:10a6:10:e0::21)
 by DB6PR08MB2758.eurprd08.prod.outlook.com (2603:10a6:6:1c::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Sat, 28 Aug
 2021 06:04:26 +0000
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::c57c:eb1a:4f8a:210b]) by DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::c57c:eb1a:4f8a:210b%3]) with mapi id 15.20.4457.023; Sat, 28 Aug 2021
 06:04:26 +0000
Subject: Re: announcing LLpatch: arch-independent live-patch creation
To:     Peter Swain <swine@pobox.com>
Cc:     live-patching@vger.kernel.org, madvenka@linux.microsoft.com
References: <CABFpvm2o+d0e-dfmCx7H6=8i3QQS_xyGFt4i3zn8G=Myr_miag@mail.gmail.com>
 <01b7d9fa-d3be-ec36-0863-fd175b62c2b9@virtuozzo.com>
 <CABFpvm1D41RJfYsk4M6SCfogUUZnvuiZ0Xs+CQkr6Zjb1J7u5Q@mail.gmail.com>
From:   Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Message-ID: <b8995525-022c-7293-f306-a56f1c8ef074@virtuozzo.com>
Date:   Sat, 28 Aug 2021 09:04:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <CABFpvm1D41RJfYsk4M6SCfogUUZnvuiZ0Xs+CQkr6Zjb1J7u5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR08CA0024.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::37) To DB8PR08MB5019.eurprd08.prod.outlook.com
 (2603:10a6:10:e0::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.41] (37.144.247.53) by AM0PR08CA0024.eurprd08.prod.outlook.com (2603:10a6:208:d2::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Sat, 28 Aug 2021 06:04:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2eb3b4bc-d891-496f-3b30-08d969e9b090
X-MS-TrafficTypeDiagnostic: DB6PR08MB2758:
X-Microsoft-Antispam-PRVS: <DB6PR08MB27581FAABB0780CCBEAF0048D9C99@DB6PR08MB2758.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W2PQXc39AcB3xWMdN8wHhuFbex2qA3w4QunGY5ba8fUgyMvtOG5HI7kViRe/YMK9za0S08kvKX67tMtTP/dd7nbEo6Smwetuu+2ALD5GbVX7YYwaon+phJeYf9KDYeEYA+JAW/UbBLMhc3f8sHYooC1S2CJZnIcV+gwesQ+lpUv6YkK8zG3QyKgbTIIC6MC7GlNT1hz9ghneJFRN8L1GOyecHMGK4VCYIgTVFCcPe5u8uVg+DNbGY//olLhEsonI9nMOeLmCf/o8v6Zoq3XqFwtHwXxwnu6a0gQmOEFYFV6H0NzMymn6aazKbHSI1MINMeeCstvG6/cXb0yfDr8Ligphpxx1AhUbUq8FV/JZH4wvB51+fdRDcC3psPfv7d8wEJDGjW/yY/CTi8wecyS/KcqMUnwWB0gm2SEntixk55l5BHBzBXg5ZhnFMoId/Xh2OPPdhbqHJejNcEFC54ST7zXtEukJJNkBqU35/6V9aGyGOqxocBoQcKidcjE7INy/YiXb0Cy93ttXEJ08ybbr3ht063ex0mTGk7/8F7uQB48o7aT2hT2wTHDryiTGUExcCNeK6hg8lZ2OfPuvE6uTaJbzlyImY7Aft7KYt/6nT3M9mJ+2wUZARwefT8pauY3bKdrY1FOsuWHSdHUcJt+XYjTTPrCrUIiEEFwkYSTewXZvULYXNyKYGnIm2nrSVoMEz0sC4qgXrHpWcHi4++M25q2ceWzObCv2Rx6GNZAs+y53W8uHfRODDVOFKSRo0L4st1fWuxWOP7LRZptJxEU/2w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5019.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39830400003)(136003)(36756003)(38100700002)(31696002)(6486002)(38350700002)(6916009)(2906002)(52116002)(86362001)(186003)(16576012)(2616005)(4326008)(956004)(316002)(31686004)(26005)(5660300002)(8676002)(66476007)(66946007)(66556008)(478600001)(53546011)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L1RVcHlLUWc1MzZabFdYREszWlkrNEFhUjJDZ3dOMmU4eThyc2FSeVNnbkx5?=
 =?utf-8?B?M1EvWlhaKzZTbnRLZ1BuTEtEaHNQVWhkTGxtNFh1VkRvb3FFMnU4aUhQdEtD?=
 =?utf-8?B?NGhXMGREUGV4R1dwWUNhRnZoSVVKckZvSGpBUDUrVm1DRlF6OGd2eFBkK2h5?=
 =?utf-8?B?K3JYOWdxSUlCZG9KNHBqMlVURDFlMW4rK0c3cnN0cmlSTzljNGZxZnJVOFZH?=
 =?utf-8?B?cXNuOVF0dlNSWFVnUE1XZDhCWkIzc3pudGNjM0NkZmpOY0tnQVlKT2dnVElS?=
 =?utf-8?B?bmJpMUZoUi92QU5PTmREcURGbEpqNzVweEw4KzFLbVoxb1Y3cGpsVWR3S1NK?=
 =?utf-8?B?WWFNSFVnQ0IxYXd1cVlXbnY5ZU9UcVNTS3BGR2o3Wm5nYzMrRjFIU0RyemdZ?=
 =?utf-8?B?Tlh2eVNEY2pHVXFZTXJkUGhIV2N4b3J4S2RvNnlBNWdyRU9QSklJN25ZRDdt?=
 =?utf-8?B?d1RhS3I2eVpuL1RpZjVycUFHQzl0V2FPYkRZS2p6cjdyZUY2SnN2MUN2V0d6?=
 =?utf-8?B?b1Y1QnJmUzRqQ1lpT3ppbXRwS3R5aytxVlNhdEhLRkYrMks1eE1Kb2VKVnFj?=
 =?utf-8?B?bHdyU1ZDWXJuUFJLaE1Ld3FBRGVLMXFmRGNmbG1RRkFQRTNYaGlDaU95N2hr?=
 =?utf-8?B?OFBFczdRQ1hCZG05VVpLVTA5NVNrSVBwajZiV0Z6T2RVdUk0Tno2TEhzWGNO?=
 =?utf-8?B?TDB3bzAvQngwbzBLOFZCampWV2lVbEFOQXV4ZVkwQ3hSd2ZkOWEvNEJ3Skkr?=
 =?utf-8?B?TXlBVkNwN0RlbVAya2pQZWJ0Sml0MEpwSitlR3Zna1VMbTJrQTdjbG8zZm5T?=
 =?utf-8?B?U2Y3bGNiQkl3WEpxK28zQWhza01XekNTWVdlTjRvdHRNTXIwc01ETnNOQ2RQ?=
 =?utf-8?B?YnQ3MTFaaUUrY2k2cGVMeGh5NjhJSng3dVNXc1d3L3N2U08zOHRvbk5MWTNF?=
 =?utf-8?B?K09pL1FnNHdKbkt5RzFoOEkzMVJxUGM5YmtSMi9qdlprUkdTeHh4ck1SbDQx?=
 =?utf-8?B?YVlNbEtBMGFWOWptb1U1NjFIMC8wRk9KQ1VTRzhhS3VEakpVNmsxL09la3pF?=
 =?utf-8?B?ZGVLT1lkWjJzL2lJOExJc3pGRndXak5GallqSm5uTVZWWXY2REhyVmc4c2Vv?=
 =?utf-8?B?NUplWmJkTkZOQ1FDYVh5TVRkNlNVNW9EQXJ6VWtwajZoa3NQQ1ZQVE1WT1o5?=
 =?utf-8?B?RkFaeVI3eVpXSlpzdmZWUkwxMko2QkdrUGVtaUFtMjFQQTJpMEIwM2gzQUdQ?=
 =?utf-8?B?N1VtVFBpQ24rcFRUMVFHZDNhTHRlZmIzM3p0RjZJbjljRmQ0L0luTVhDbWhR?=
 =?utf-8?B?UGdiWlVDSzJycDIxK1lYZVVDeEY5QUFMZnVHamdzME5DbStpUTNicURNUG4y?=
 =?utf-8?B?WTljVTFrem4xVllSSnVlUFBZdkRWODJ3RHl2TkM4cTlBWUNNNWMvRnNIeThC?=
 =?utf-8?B?OVR0bXBMaG1vUHhDSWVsL0FIMGxpWndVd2xORzZPakNaQ0hieldSSDZUNU9R?=
 =?utf-8?B?UHQzYlJDOXc0VDExbUwvZDMzdTFWemdKMVg2QjdLNWV1YWtJV2V4K1d2aE5p?=
 =?utf-8?B?OU1ycWM1UDFoNlVoOVExSmEvWHU3dkhJYVFOdnZNZ2cxOG5SVFdROCtWN1Rt?=
 =?utf-8?B?V2x2S1RiQ0NNallOcnlIVkJtdy9RY1FlTHJDNUtOV1hGaEp2ZG9UOFBMNDY2?=
 =?utf-8?B?M3JtUUFkeGZXeVBVTmM3Yk9haUcxRlhYb0dUNzdxNmt2aEpUR3o3TmJWLy9N?=
 =?utf-8?Q?zOLnokM05y30UjcuM2SFyYwaWxNT3T2t88jdVNu?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eb3b4bc-d891-496f-3b30-08d969e9b090
X-MS-Exchange-CrossTenant-AuthSource: DB8PR08MB5019.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2021 06:04:26.2053
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mMyavwB2bNtb4G0igI2XYG6QsumKFhTt4q1gkzTehImuQFK3Zy9mocsv4eslBJlm8fznGwAgJOfeYyoMxsLB7M15J4a5Sr2BLh5dVL4TLNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR08MB2758
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 27.08.2021 21:33, Peter Swain wrote:
> (apologies for re-post, having trouble enforcing no-HTML mode in gmail)
> 
> On Fri, Aug 27, 2021 at 9:08 AM Evgenii Shatokhin <eshatokhin@virtuozzo.com>
> wrote:
>> LLpatch requires a pre-built kernel tree ("repository"), right?
> Yes.
> It doesn't rebuild existing *.o as a pre-image of the patched code, as
> kpatch does.
> But LLpatch does use the dependency analysis the previous make left in
> *.o.cmd, although the same information could also be extracted by "make -n
> -W changed_file ..."
> 
>> Does that mean that the kernel should be built with clang first?
>> Or, perhaps, clang is only used when building the patch itself, while
>> the kernel can be built with GCC or other compiler used by the given
>> Linux distro?
> We haven't explored this deeply, as all our kernels are clang-built.
> In principle this should work with gcc-built kernels, as long as the
> particular change doesn't intersect with some feature which is expressed
> differently between the gcc/clang worlds, such as some ELF section names.
> But as there are so many such potential incompatibilities, we do not
> recommend this.

I see. Yes, it is safer to use the same toolchain both for the kernel 
and for the patch.

> As a precondition for LLpatch-patchable kernels, I would recommend moving
> to clang-built base kernels

This is not always an option ;-) For example, the kernels in our 
(Virtuozzo) Linux distros are based on those from RHEL. We try to change 
only what we really need to, otherwise we lose the benefits of a 
well-tested code base. So, the compiler and even its version are 
basically fixed for us.

Thanks, anyway.
> .
> 

Regards,
Evgenii

