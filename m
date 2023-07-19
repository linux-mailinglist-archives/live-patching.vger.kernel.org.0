Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3668759940
	for <lists+live-patching@lfdr.de>; Wed, 19 Jul 2023 17:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjGSPOb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 19 Jul 2023 11:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjGSPOa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 19 Jul 2023 11:14:30 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5A8A2;
        Wed, 19 Jul 2023 08:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689779668; x=1721315668;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jf5OtXObfiVIpM5bVfkCCsuksnYqBghgIzb/+6MzTC8=;
  b=jC3Pc6I0oMa3+G03d7xPc7koJNjWSAgC+9goTk8SWHwHQye+hRbJho+Q
   O+sIv7xtij42cnZ2cdX5lU/OKXRq9Uv/ppjthWHas8RujuvOwCzPCRSw1
   W2CqNDC5Hcc9HmY9lRPZGTt1Fl3VjMgZwyjN1Q0xuLJspTu4TyFpByKdt
   Em7l4iLwhXfL3RjZvcBBnsiWsG510u1R4Gffj0rIxlrJuh/VQVJc0TcUx
   42/mkJpwifmCtr2+ZhKPMv/1fMLj7hucwjFiJpKbFj68+L0sLWlqOtw+x
   2ZSn6+O4IzvDt8ET3QmVkxu9KVSxKFhFSCx6jqvDEQKbd6CDR+x5HpZLW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="370051675"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="370051675"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 08:14:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="718008544"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="718008544"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 19 Jul 2023 08:14:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 19 Jul 2023 08:14:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 19 Jul 2023 08:14:26 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 19 Jul 2023 08:14:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OdY84ksAY61Vl8MWittV4ceMY7CdnfDGqxf64EvDpLWDV8csVMqDPoMo/VRdILTVq//+9xt75aFdY7u6gIIkyB/EIuVYulvsAhspKHsjGCViw6m7aaivmJinEPIScsfBDTTd4bo1Q7/5L3s6ELq1thPlXM3fW/XgGxoTWmfeMIm5k+Z/Y4vk7PjdWrQIEjvoekxxlzHS2/wZtFmfSubVHdJM0V/bpfK6nvgE8iZYXBhW9KLRT9ukUTgAPLynwyda8mkgUSK5wMqzKHAzH/D6NMQYXj3LUQHiqeiGzxU/LlYQ6O3x8VSNyrLeDPtFwOP8bMLQm7htpfpDXnkDcQWbeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cc78lH6dyVYC5OJqFdCFKbor1rwyOJztPQ0zOGwOJuE=;
 b=Ocnln10YOrpSLs7Sdwx7h42MswX7QBSbXYjFFgXOtASS8cwkMEfUOOfYKKrIT0/bP/60LMcjlhzf5rgxwq7hHJRtv4T6XN3AQe+DI0/e6Ww7vUqdx+gIkBsOaZ7hPk1WiSVmsjqDxOSD4nFk/9S1m7hypZOqi58e154PyQhWn7Lq8mP2rkpwtYUPp6zIq7J3OdSXCrDPJo1tfIGRltXFAtBWQWN9EZI2MjeO68F06MMr9YA/w9SWeH9khtdoF1NriMwZPx22avB1+1ydcco+RuQFyoiDx9zffvoQq7o6DAEXuzwpJyDFWu+xJ0bt/ci52f4pVvjyudc9oJQ3C9eMew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW3PR11MB4523.namprd11.prod.outlook.com (2603:10b6:303:5b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Wed, 19 Jul
 2023 15:14:24 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::44ff:6a5:9aa4:124a]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::44ff:6a5:9aa4:124a%7]) with mapi id 15.20.6609.024; Wed, 19 Jul 2023
 15:14:24 +0000
Message-ID: <6edbfe7b-aec4-2b3c-2f85-42e418ab3d99@intel.com>
Date:   Wed, 19 Jul 2023 17:12:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
Content-Language: en-US
To:     Nick Alcock <nick.alcock@oracle.com>,
        Alessandro Carminati <alessandro.carminati@gmail.com>
CC:     Luis Chamberlain <mcgrof@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        Viktor Malik <vmalik@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>, <eugene.loh@oracle.com>,
        <kris.van.hees@oracle.com>, <live-patching@vger.kernel.org>
References: <ZLVxUQiC5iF+xTPQ@bombadil.infradead.org>
 <20230714150326.1152359-1-alessandro.carminati@gmail.com>
 <20230717105240.3d986331@gandalf.local.home> <874jm088ah.fsf@esperi.org.uk>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <874jm088ah.fsf@esperi.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BE1P281CA0105.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:79::16) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW3PR11MB4523:EE_
X-MS-Office365-Filtering-Correlation-Id: 15ef76f3-f6a0-4350-8105-08db886ad596
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tbqPCsBwftYyNshO0Ngz/ofsExJjV0nseStwU6CLC2xECdnsuWr4z6c1vNqWktD82sRb6isb4+aVcJtA3BqlmyWvbS7Cr3qrcqw8YAlM55bLIC+qZVYhoCncZ7AoPwrP1xhuIQW6Azbw8fyJ0FLAh7HOzV4DvaaTlEJTaIdwdNZHeEIHrzkynv8r4ae10yUVmUFodE/xNslj8eGUoKUtR9q9AtR7w4B9KMp47HUv8H/dUlz9CtNvHDkFrHVE1ivRZ3e4BpZh9FzU6Ryg9BLh9mQylIIv4Cfk7gZqkLe9Fe5SQ0B87us4UKfDD36jHr7p1rmnjhEW4c4NW+5/PQw1z6K9/iv4p7/Ty3WXeKmBVuSrkrhSSdlIFFYkwcOHhiBRBj4W273MvkfPDybs9hPQKSf5gDIadP2qN0uPAOdQpy6jqL75gOGuYlSl88BewSBDGQvyPyQbaP237mkuIxPSdXJ2cgkjfXn/fzZ6YgSgAWajTt+g4Br9ks4mXGIaSAWYD9qFoRbKdvTKtjROAmLeGWQzP2t74x5blJQqv4reReCQQzTw2rp2FxPvlTr5JkHO2J5tiaMEs0LcS9rIf7niKFs3bk3ZY2rX48ZCTyaGIltqrhBpQkONggHtks2PHl98TugskPJBGSoibR/nAFxj/dD3cQ667W3cPcZ7PRRxH3X7dUUO0BROBNqARz9S+XpS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199021)(110136005)(54906003)(38100700002)(82960400001)(6486002)(6512007)(966005)(6666004)(478600001)(41300700001)(5660300002)(8936002)(8676002)(66946007)(66556008)(66476007)(4326008)(316002)(2616005)(186003)(83380400001)(6506007)(26005)(86362001)(31696002)(36756003)(7416002)(2906002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekxQZHE3T1Y4L3J6aXFtaXFpM09SL2tFc2FSMURkTDJwbDZsa0RsQWZ2S2s1?=
 =?utf-8?B?WGdzei9CRFRQSUJwYWNtTkw0VjM1M2VobnlDMGRiSFhsNWRKNEZ3bXBqWXV1?=
 =?utf-8?B?SGFhM2tGdjhlc2NaSTQ2VVNrNHliOTVMaGN3QTNORHFKRm5lS0Ywa2ZnRk9p?=
 =?utf-8?B?WmxWeHgyS3JkQnZJSFRsdTJGQWJBS0cvK3BUMHh5LytNOWZZVU1KMzJERHkx?=
 =?utf-8?B?WnhLZ1JsNXJ6MmJCRjR4VmxLOEdBbEpMVlhrZVlsblFWOGhCNm1YRHZITnQz?=
 =?utf-8?B?WXhYR3o0dWpjdy85VmVQbnNhd0ZqZWlueTFlbksxN2d0c1NRUXhSeWhUZk1W?=
 =?utf-8?B?anBwT0FpVkUyam4rODdXaEdpQXFtU3BBZXo2cDQremIvcEdwR3NEZ1RwNCtO?=
 =?utf-8?B?SnVtYXc5bkhZcUhyZnc1YlJ6b0RPNTFNd0ZpY3V4cDE5S094NzFkT2pDR1d4?=
 =?utf-8?B?eW9mMkNmTHpFazhvU3ZUMnBOTFQ5VU01cXRmbXB1STFmMUZNU2RBTHlMMWVQ?=
 =?utf-8?B?Q09IUFp0YWw3OUc0UWg0Q2VvRE9vOVl4VHM1eU82THlzYk9VdlBaeGZHSHZN?=
 =?utf-8?B?Q015Uk8rOUVyM0tWSjJKbzlKb3NQdC9Cb0ZWbFVJRGdpQzFXWHc0VFRyRTN2?=
 =?utf-8?B?Q1EzRWJPUk42azl6NjB5ZkRwNzJvT1JudUw5dkVmd3BpMXd2UUk5ZEQyKzJq?=
 =?utf-8?B?UTJRcHNOcXFjK2x5dm9uL0MycDRTaERTcVp0dVJ1TllyMVZYM2E5d3hidmw5?=
 =?utf-8?B?MUhEaXpFTm5BaTdTQml5bVlBTFFWVmZhQVpManhxbUtrQVNXM1hBZ29OZlFR?=
 =?utf-8?B?bVZTK0RBeXlGVzFHZWRmNnBTVFdUNHkvN3dyWnQ2OTV0aytaT0dHQ1FFdlFW?=
 =?utf-8?B?WWxOYU8yZFIxZzU0cGdlVDJhc0dKZlRMUW9hOGo5c0pOTjdUZnRwZXEzZFV5?=
 =?utf-8?B?VWdoU05LYW9YZldUUVJiZncycnM5emtlbE5WNzRQZllpVEJtQnBaSHEvaXBZ?=
 =?utf-8?B?NnpVZ2FnQ1lncmdZR2JuYkZ0QldpSU1MZGg3enh1YUhCamdKNTdKMlJQaFJa?=
 =?utf-8?B?VXIwUGU2dms3MWtpOWxjYnRDSmtteDZuRFBYSHQ0QU5OWm5ubE1qNWpGVWY4?=
 =?utf-8?B?ajVWVUJFN1FiTkdrKzh5VjhmVnE0cWcyUHM2bTF1c3ZwWXVwbWZRK3QwekFH?=
 =?utf-8?B?VERMWVVCNFFIaWM1TTVlUFUvZXVtdW90NlVpQmI2cCtzTmNGendSU1Iybk50?=
 =?utf-8?B?SUg1aVovM2tIQ0ViaThUL0tudkNVM0toUFY3VUIyQ2FHaDdiRWtvT0FOQWZj?=
 =?utf-8?B?d3pja0hkbDg4c2lmRVZNem45K2lVNm9yQ05rT0lGTGtDSVBnQlY1SmFjSVpQ?=
 =?utf-8?B?cnRrUVQweWx1UENZeGhoK1QrQi9tV0VkWUdrS3NIMVo1SXRLQ0xDL29vYzRs?=
 =?utf-8?B?T2hBWVBuY3pIUDduUmVHc2FSSGNvNzRlMnlNbGhZSzdtY0lSRnNXR1EwQml4?=
 =?utf-8?B?cEZDb2ZDR1NoYXgwY3I5RUk5UTVQdEFOZGpSaHV1bklZa0hYUFNYRVFHajJ0?=
 =?utf-8?B?Y2JFcjJ1RkhsVml4WTF2ek03cUM4ZWFFNEp1QU9rQkEvTlJoeG5RazNUeVEr?=
 =?utf-8?B?bXBUOEdnSEZFREwyVTdUa3QwS2YxOGd4YXpRNDdvR1hIV1o2Vzh6K2NIdXMw?=
 =?utf-8?B?Q3pJMUhsYklkdE9GSjFqZWdocGhXWHdod054UUJoRWtuVjdNMkJ5Y1NzbStu?=
 =?utf-8?B?MDM0Tmxhc3h4a0M2RXhRNkpGT3dLc1RoQ21nclkydkR3TnpxdGY3bjM1NHBO?=
 =?utf-8?B?SHRoQjBMNi85K3NWVUt5YmorTE4wVU5VOGkrWE16WWlNTENaL0FXaFdiTUdS?=
 =?utf-8?B?aWVDZEhBUmJBcWw3dnlzZExyclpxcjVHNEMwREtPN3Nvc010NFZRM2Rna2c4?=
 =?utf-8?B?RWd6clhLdzI1VWl1emhOZE4yVEVpNVhZMk5Ua2JramNBdEdnRndrbzRvNElY?=
 =?utf-8?B?dldDb09YdUljdFFBWUk5SmpleVRDc05NbTNkTlN4T2RobUIyVWJBaW9IM3Ju?=
 =?utf-8?B?RjNpd0xHeVVudVhibmN3bUhlb1oxTWRCc0prK24rb2FwQ3NKNkVBaSthWmlZ?=
 =?utf-8?B?L09mK1ZXYWg4c0x1VjNtVkp2c1J5V04velU0K1d4bnpoVHg5c1hiWXFBNkxI?=
 =?utf-8?B?Wnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 15ef76f3-f6a0-4350-8105-08db886ad596
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2023 15:14:23.8441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bG6ED3m7bU2QjLInWUoOwaDTSXyMvrXtMcg4YFn1VC7aaqX88YSNKvZ5ndKwU6tQUxhHt2j7m4lrIoXq3eJhUfd+R6ftx2YdL+k/9vZXfTE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4523
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Nick Alcock <nick.alcock@oracle.com>
Date: Wed, 19 Jul 2023 12:12:06 +0100

> [Reply concocted by hand out of lore.kernel.org archives because this
>  entire thread has seemingly been mis-sorted somewhere into the stygian
>  blackness of my mail spool and I can't find it anywhere: apologies if I
>  messed anything up]
> 
> On Mon, Jul 17, 2023 at 10:52:40AM -0400, Steven Rostedt wrote:
>>> Honestly, I think the "_alias_<some-random-number>" is useless. It doesn't
>>> give you any clue to what function you are actually attaching to. 
>>
>> Agreed.
> 
> Agreed, and not *only* because I have a patch series that I think does
> better. I'm also a consumer of this stuff (that's why I wrote the patch)
> and I'm afraid I couldn't do anything with a bunch of random numbers.
> What user interface are we supposed to show people? All it tells you is
> that two symbols are different, not which is which or where they come
> from.
> 
> This seems to be useful for the one case of "look up a symbol out of a
> trace log and then filter by it or re-trace using it": no other use case
> seems possible, because a number is just so little information. I'm also
> hoping that people can say *before they run a trace* "I know I'm looking
> at a problem with cgroups, I want to look at blah@cgroup/cgroup.o"
> without having to know beforehand that this is blah__alias_19404.
> 
> Actually, you probably *can* get something else out of plain numbers --
> by looking at the aliased symbol name you got back, then looking at
> /proc/kallmodsyms to see what other symbols it's textually close to,
> guessing what object file they're in from their names and then grepping
> around for what module that might be related to. i.e. doing by
> eye-and-grep what my patch series is doing automatically.
> 
> 
> A further problem: doing this using aliases in particular requires
> modifying the tracers to ensure that they always report the aliased
> symbol, not the non-aliased one at the same address. As it is, I suspect
> a lot of them will either report whichever symbol comes first, or pick
> one at random, or even try to disambiguate them themselves a second
> time, leading to blah__alias_19404@something (double disambiguation) or
> in some cases they'll simply hang. You might be lucky and see them pick
> the longest aliased name, or whicheer one comes last, I suppose.
> 
> I think all the hanging tracers have been fixed in the last couple of
> years but they certainly *used* to exist. This is of course a bug in
> those tools, but it is easily overlookable when only a few symbols are
> aliases: less so after this patch. Nonetheless, it is unarguable that
> this series probably requires auditing (all?) kallsyms users, at least
> to be sure they don't misbehave. (Mine doesn't need any of that, but
> only because I'm using a new /proc file for that exact reason. People
> migrating to it would also need adjustment.)
> 
> I know I've got too many concerns in one mail by now, but I'm *also* a
> bit concerned about the space requirements of this: kallsyms's name
> compression won't help compress all those textual numbers much. It's
> certainly higher space requirements than my approach: it's just more
> hidden because it's lumped into the existing kallsyms tables.
> 
> 
> Alessandro: I'll have a look through your patch: after dumping on it
> like this I think I have to. Alternate approaches are always worth
> looking at :)
> 
>>> There's
>>> been other approaches that show module and/or file names. I know there's
>>> still some issues with getting those accepted, but I much rather have them
>>> than this!
>>>
>>> See: https://lore.kernel.org/all/20221205163157.269335-1-nick.alcock@oracle.com/
>>
>> Yes, please coordinate with Nick and review each other's work, now we
>> have two separate efforts with different reasons but hopefully we'll

Three efforts[0] :D Mine went unnoticed unfortunately, so I switched to
other projects then.
My idea was to give relative path from the kernel root to the objfile,
as we have a good bunch of non-unique "filename + symbol name" pairs.

>> come back with one unified solution.
> 
> Yes indeed! I am getting back to this very soon (a few days), after a
> prolonged hiatus getting USDT probing working in DTrace V2. Sorry about
> that. (I suspect you wanted a break from my cover letters too!)
> 
> I think what my series really needs is someone capable of writing less
> convoluted English, because my cover letter skills are still not
> brilliant.
> 
>> Please Cc live-patching also, as they had suggested before just to
>> provide the file filename + line number, that'll make it even more
>> valuable.
> 
> That would be amazing! Nothing obvious occurs to me though.
> 
> My series could easily give objfile + address offset for every symbol
> with little more overhead than we have now (we'd need to encode more
> partial objfile names, that's all, low tens of KiB) -- the problem is
> translating that address offset into a line number without a cripplingly
> expensive storage-per-symbol lookup table. I mean if storing the size of
> each symbol is too expensive (and it is, costing hundreds of KiB),
> storing an offset->line number mapping probably would be too!
> 
> I'll think on it, maybe a trick to avoid representing every offset
> individually will occur to me. (If any occurs to anyone else, I'd be
> fascinated.)
> 

[0]
https://lore.kernel.org/linux-kbuild/20220818115306.1109642-1-alexandr.lobakin@intel.com

Thanks,
Olek
