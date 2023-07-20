Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEED75B52D
	for <lists+live-patching@lfdr.de>; Thu, 20 Jul 2023 19:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjGTREs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 20 Jul 2023 13:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjGTREr (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 20 Jul 2023 13:04:47 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D0EAA;
        Thu, 20 Jul 2023 10:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689872686; x=1721408686;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E9VOofOYYBHS59HWM3o0JzLekLLQhhgpLfKyJb/Db1k=;
  b=UzOam4z9WFesSZiMcPqq2euxeybOQP5FMmdIqWM+dlXq10PDc9WDiPop
   uhCMXOOSMT39/A1tgP9SJFNplhtmdy3q9kTxsvmGPXErVnL9hppFwDCSt
   ygLtvSehyiiyWKHU6laD95E8hwbGGoyUeEgduZhHD89HCKMlBGGzE81FI
   myF2MF5E6G2lx2NrIFNYyt1/CtNs6H+Ble1Tz93UyBFlrFFO0gaKWaG5h
   t+/CpN8ppdxy4yxbLdOALh5K3NghB/veqTMUB1aitY0g69mSYIvRoSSl/
   nFki4YXwz+NYRqUJVDW06CPxOI3sQpGORs8FGfmWQr6HSUnTqbRKIUQpB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="365698248"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="365698248"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 10:02:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="724486048"
X-IronPort-AV: E=Sophos;i="6.01,219,1684825200"; 
   d="scan'208";a="724486048"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 20 Jul 2023 10:02:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 20 Jul 2023 10:02:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Thu, 20 Jul 2023 10:02:23 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Thu, 20 Jul 2023 10:02:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbR3zdoh99lfGzLFe3O9EcI4GNs912mJEV9R8M0Bx67vS4LCAofNMTYlNmPmlYcxsEKirkMSfBN+sx5B7RdmtRHMd9Mvw6l8Ra5qdwAmp6bU6fqh5MauFwOJOqoqe9c2TGzfPHj5b8h+q2JZP8CE50Vf0JGMmIzDZ5coI2+vD1sNU8VpXoJfxABu6qSsJOIMuJdNIGmtF+IEpEmEIjF4Q5GKXbuhFDYtE7K4aZs0c+vWszZ3HYov7HL4omIIxRz7bN8xpUZR5jKlZ1z3UsgEc0nzbTR1jx76mXMgezHqVkIbPxu0doxWijUG93DSi8LMov8u6Dxnv88LNoUH4uSiXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FyKjCUeNMfC1ZRmPVaJktNld53W4sc/MOeWFeDR7RMY=;
 b=SOf2IUbNoiRzf202/oU2Zww3SDSJvEiAfhOiBND064KLiiGcJdah9tKKRXCEamRMIw0aRAWiylOYFweqkYrqePd/VFplvk87yPiwUpcI+UDfpTuto+jJ36e3tBE9GRwNfOgdLQcp3rxsaOk2aDFWgip6Mx4vOt9/ALVGexsgbv8Rm1hE85wwJEma9DN41+3bhXjOs9PXdPqsfq5H9DG2NMptN59tAhBCF6bWAfjdM2BPsYF3F9VoVJpbj0jo7E2EwdioTDyY09RzjEoaIkmL0dikAsaByxT/O5zsNsMEYvaHI+uiBSEple7cSwX/x7DhJ19wt+Fz2KlkowhjVo12tA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by MW4PR11MB6957.namprd11.prod.outlook.com (2603:10b6:303:22a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.25; Thu, 20 Jul
 2023 17:02:22 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::44ff:6a5:9aa4:124a]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::44ff:6a5:9aa4:124a%7]) with mapi id 15.20.6609.024; Thu, 20 Jul 2023
 17:02:22 +0000
Message-ID: <ad01ae6c-5c9c-8183-078c-fffabb2e00d6@intel.com>
Date:   Thu, 20 Jul 2023 19:00:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
Content-Language: en-US
To:     Nick Alcock <nick.alcock@oracle.com>
CC:     Alessandro Carminati <alessandro.carminati@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "Nathan Chancellor" <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
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
 <6edbfe7b-aec4-2b3c-2f85-42e418ab3d99@intel.com>
 <87wmyu7n5t.fsf@esperi.org.uk>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <87wmyu7n5t.fsf@esperi.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BE1P281CA0356.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:82::10) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|MW4PR11MB6957:EE_
X-MS-Office365-Filtering-Correlation-Id: b11eedc0-ee7f-49ab-b424-08db8943155b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yf7rjjGtq8H8Yx8OxhB1X8VX/d4kmSEhM801gsQ+isBx+JXn4EYbHCAUElc9o5rsBZsGvbwqXQb3yldeNroZhtPLrBv6WlY8+xrUU9BURV9mW1KWIRPX0YxDEEF5wz7DJG9Z5RsdvK8jdAt5bceuvc/tri4YpZIBePeNjgzsfbB02x7eDY6UAx6OXA9QOMFpH10u616PNkqytnjMtXYkdYgWjDhkga1egmGE3ULROXh52zQufFETQTrMYp7a7MVA293FXX/Y1LIbpExT6FvQgFYzpnUL0Y0iv1s0g/ytP2TnibDFjAqHPtg3rpGQbcraBvlOIz7kZKCcL+qITKxe1+nS4TLAVEscBDCIaIQTG6KpVl3WRD7PGk/LUodZ4k2XD7oFmWjkYarroRYMPHPaaiwA/KjAKplUrD81+smPZkIWEXVPyu+JcujAPGdZ4InH5VTXaEedpn+1NvxSl+pktCpvAXmoATxu5JtxfeM/ZQPGXMQ0h3hVpYdWqW+ZNtnwCdjX60t6TN6wugIqe3EfvJ9bgDn90UQ7P59ZhEu6rF7Yj36bRSrzXrmg50oRcOrMm1ve37gJcmirI3rl/Xbhsg7IWoWLgQafgORDruuuq94hKGM9S62xwvwVCWzvSrCdSFSjXAzIVwVKMQbrsRB7Yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(136003)(346002)(39860400002)(376002)(451199021)(31686004)(36756003)(38100700002)(86362001)(31696002)(6486002)(54906003)(478600001)(82960400001)(7416002)(83380400001)(186003)(2616005)(6506007)(26005)(6512007)(66946007)(5660300002)(6916009)(45080400002)(8936002)(8676002)(316002)(2906002)(41300700001)(66556008)(66476007)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVEwZm5Vb0xUNWR6Tm5uMmF3dFo1c1h2dDhjcW4yQ2VjNkZIZk51eTN1V2dp?=
 =?utf-8?B?TUsyeTRoTDQwSm1za1dmZEs2dE92VTRTRHFMdXpDdmEvVTVsYjNWdzJWRG5j?=
 =?utf-8?B?ZFdjQjZHTmorYVIvTXNRdTFJbklKaC9xcUIrNjZIc2NsVG40VkpuYVNPZ3Fx?=
 =?utf-8?B?dk5vbWdtQklScWJuamlxNU81WmJ2MHJHZU1TL2dNVHZXdVFHSWxibHZkN0Zj?=
 =?utf-8?B?T1hkWXhjbEZpK2V4K2hCYlpFSG1uTzU3a0pwZktEcVdyM0J4QVV1QTlnTncw?=
 =?utf-8?B?WGgrZGtEZnpHT0NTdEcwVW9mZW1nb0xxUW1hTFdJUXRKRURKb3RETlVXZnpy?=
 =?utf-8?B?Q0R6cDN5L3FyRitEYXBlNFZHbTVIVTlVUldXWHVxeWcvN29lbURrUnNrQ3RQ?=
 =?utf-8?B?R3IveVBkUXQwUTB6MjJkRzB2VlhVZ0dVM0tPWlVmbm9RVjJ5TnA2aGY2RDIw?=
 =?utf-8?B?eEU4bDZOS0JaREV3cmNKWFZKQ0w0bjNKUkZycEp5Rm1VY1d1SjRZaUdaZFJj?=
 =?utf-8?B?ZGZMMk5xbXRSTUpVT21FOXNqRXBLemVFeHN2d1RQTlAxcU9jY3N3TXNjUTdY?=
 =?utf-8?B?eXdVWlFPdCtRMjJUTnhzaC9FbUVTdGFPZTA4Z2NUeWlxakUyUkx3dHRWNitl?=
 =?utf-8?B?bW83TDZZUWR2SnlSb2liUDRtU3FHMGZrYm5xclJRazJZQzJ3NG5wNGJacmd2?=
 =?utf-8?B?bmo1WURHUVZ3Mk8rVTY5UXVVY0Faelozc3d3dGhVSVhsU1dDSkJISVl2bCtk?=
 =?utf-8?B?SXcrcE1STktTWUdTcGJvVlZHTWpHdm5UYUVBdEQ3dlRUVU1SdDg0S041K2oy?=
 =?utf-8?B?N25rQzNlV2l5UG1MREU5MWphYnBwNE1PSGdJeHpnYkQ4VWtiSitZSHZXbzlI?=
 =?utf-8?B?U3NjQVNoNmNycitqcjV4aGFBZXJvNVp3ckdyTnNpNnBJcHp3NkxRMzFiRTJP?=
 =?utf-8?B?ZUtSVUMxQTdrTU1mVDhsQ0QxWC95K1ZtMG04V29KNXdQN09Jb2Z6Rmt1RlVY?=
 =?utf-8?B?T2FyQzZ0bkxmSzV2YUxaTGJwUmJ2NG5reGE3WUpjSzIzMGc1QmhXRGhXSEZK?=
 =?utf-8?B?TDhZT3F0ZjVLaE9wdVNHZ1NuYjVITGhld0VGK0QyWkpYTStEc1VQZUpPdmVp?=
 =?utf-8?B?MWMyUld5azR5bmpzT1VRNlRVYzdZakZnUDlZR1dKczhwMENpRlBRVjNESTdt?=
 =?utf-8?B?TXF4bUkvY0JsZ1NSR3gwc0NtZWRYMllyUFdxcjJpeTlCYytqSkVHc3RMeUpj?=
 =?utf-8?B?RzJvT1BQb241ZW9OYnZMVmF5UDcwK3NzQVJ4STdpNWFBdTA2VlJCY3FZeUlv?=
 =?utf-8?B?aVVIeDB0WGV6REFuREt3L1ErWlMzVDZFbHVuWlFDNGlXNERvU1pSbHBmYklO?=
 =?utf-8?B?aExvY2xnejU3cXZsNzRrYzdkdEx2YlJaRnloOEJqRTZIZllnTnVqQy9hMU52?=
 =?utf-8?B?VjRRa0lyNlY2S1FNK05NMUJkZ200bjgrMTVKTVFkL3JUSG1rckV4K0JHcFRo?=
 =?utf-8?B?elRpZ3ZzbW9PZDcwclEzOVhBQmFNOE9ONUxRaVE5S2kxbU5kK2NrTG9pNUNX?=
 =?utf-8?B?dGRSeUErTm81NU1ITkhBOUNlQytoTzQ0KzFPWm9DVXhpZThON1pjUjZvZVdS?=
 =?utf-8?B?L1F4SytFbW1ITU5SdnZBc2RsWWllckFMN2lYUFNMUkczTjRyOTgvL0J1ejdU?=
 =?utf-8?B?Wm5YRGk1M3pIekpvRVZSdFdFSjRvVHZJM2NtRUcvQXVLa2I1ei92YWVtRGdX?=
 =?utf-8?B?L0xmSjc0aFJaN000RUFiTmo0cHpoUWhwSXZPSnF4QzdxY244dlZMZ3ZEN2c1?=
 =?utf-8?B?cUpnMHQ2S2JSS2lzVFZ1SHNxRSt1MHJaOGRLTmtGYnYxTktrekNaMnZLY0d0?=
 =?utf-8?B?VjFMNldQeVhsaFRkV0o1V3RUTWNsYVJ2WVpSS3RNKzdrc3dTclkxT2R1VzdJ?=
 =?utf-8?B?RjZ0bTl4eEtZNTR0VldTK3JaZUxFKzBKNDQ2VXBIbXk5SDZYWE9jajRjLzNy?=
 =?utf-8?B?OUNRYkdUbXgwMDVIV3VkVFZsMmtiamFxODM0V2pNR1ZMY0ZSaVdlVjZnME9n?=
 =?utf-8?B?V3h1ZWdGeVVCVjUyRXduWUNmYzNGdTJUZ1lKTWhWOTQ1WG84U3JtbnRwZS83?=
 =?utf-8?B?ajlpUGIya0w5SDNYYU9BREVWL01qNm1kbHYvUmhRZUpmOENnYUFIcEJNRUR2?=
 =?utf-8?B?SXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b11eedc0-ee7f-49ab-b424-08db8943155b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 17:02:21.9624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RghtLqP9FY1SNdN/dyUoQirnSVP52Xh02Td3ACOHKQiBeaTyyt6nTOUd7yhQ4OOIUO50moTUL/nyP5bKfRWerMRuBQdeTGt0ZgZtQQEDPTM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6957
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Nick Alcock <nick.alcock@oracle.com>
Date: Thu, 20 Jul 2023 14:00:46 +0100

> On 19 Jul 2023, Alexander Lobakin verbalised:

"verbalised", I like that one :D

> 
>> From: Nick Alcock <nick.alcock@oracle.com>
>> Date: Wed, 19 Jul 2023 12:12:06 +0100
>>>> Yes, please coordinate with Nick and review each other's work, now we
>>>> have two separate efforts with different reasons but hopefully we'll
>>
>> Three efforts[0] :D Mine went unnoticed unfortunately, so I switched to
>> other projects then.
> 
> It's odd, nobody seems to have noticed these until recently and now
> suddenly people are crawling out of the woodwork wanting unique
> addresses :) maybe the ambiguous ones are just getting commonplace
> enough that they're biting people more often?

I read kbuild, modules and livepatching lists time to time. That means,
some small patch with no discussion can be easily missed by me, but not
some big series or when there's a lot of comments.

But it was strange and funny back then, in the FG-KASLR thread some devs
asked me to implement unique kallsyms before moving forward ("symbol
position" means nothing when this "position" is random each boot), I
posted that RFC I linked in the previous reply and then... silence. "We
want it so much so that we don't care" :D

> 
>> My idea was to give relative path from the kernel root to the objfile,
>> as we have a good bunch of non-unique "filename + symbol name" pairs.
> 
> I considered that, but unfortunately that has two problems to a raging
> perfectionist like me:
> 
>  - the objfile probably won't exist except if you're actually doing
>    kernel development, since kernel build trees are big enough that a
>    lot of people delete them after building or ship kernels to other
>    machines: if someone else built your kernel (overwhelmingly common
>    among non-kernel-devs) the objfiles are sure to be absent. (But an
>    option to not truncate the names when you know they won't be absent
>    might be a good idea, though this pushes space requirements up by
>    hundreds of kilobytes so it should probably be off by default.)
> 
>  - even giving a path to the kernel module on disk (much lower
>    resolution and vulnerable to ambiguity again) is unreliable because
>    there's absolutely no guarantee that any given process can see any of
>    them: they might be in a different fs namespace or the modules might
>    only be present in an initramfs (hell, I even know setups which
>    *compile* the modules needed for rootfs mounting in the initramfs!
>    Yes this is borderline insane, yes it happens). More commonly, they
>    might be compressed using any of a number of compressors, changing
>    the name, and the kernel has no idea which compressor might have been
>    used (not unless you want it to go and look, and, well, wandering
>    around over the fs hunting down .ko.* files from kernelspace to get
>    their names right is *not* my idea of a good time! It's hard enough
>    to get that right from userspace, honestly, even with kmod helping.)
> 
>    The most you could do would be to provide a key you could use with
>    kmod to dig the real modules out from userspace. Partial names are as
>    good as anything for that :)
> 
> So all the objfile names are, when it comes down to it, is names with no
> intrinsic meaning: even if they're filenames of some kind, tools can't
> rely on being able to access those files. (For my most common use case,
> using a tracer on an enterprise-built production kernel, they'd almost
> never be able to.)
> 
> So you might as well treat the objfile names as arbitrary string keys
> that might be a memory-jogger for humans, which means you can chop
> boring bits off them to save space :)

Oh, maybe I phrased it badly, I was saving C source file path actually,
not objfile :D Like:

0xdeadbeef net/core/dev.c:napi_complete_done

Thanks,
Olek
