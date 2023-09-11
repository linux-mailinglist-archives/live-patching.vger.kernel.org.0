Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED4179BB8D
	for <lists+live-patching@lfdr.de>; Tue, 12 Sep 2023 02:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236112AbjIKWd6 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 11 Sep 2023 18:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239696AbjIKO0h (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 11 Sep 2023 10:26:37 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E50F0;
        Mon, 11 Sep 2023 07:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694442392; x=1725978392;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C2kybuQ38v2BvoZNTZCWPzmku3gnusplbnu/mCilM4w=;
  b=BvtLK3aRLdU2zyuTE27NNWUntnkH1xjJN5ZLXEWjlbTVRooTRT03Cs83
   Y4wuTB7BnXGnC8gySndkSUQ8f3ztdcBjUW0692NN1Rr266DQFve52+vvQ
   wKNSJ/huqJEQ7IeuqX4WoGlAVC/1Q1nAHdJWsVoLBDasj0IA0RrUuV8Rs
   BdM4KlfpxMChtpYtbnOC1JJuwKxIcX3uBHcjiG29/QuilLOHSFJEHS8SD
   1VQvt0kBbY46jrUise9GD3qF6Md+Ww+cOihKkZUkPWBqX7PYv3jRzTzvo
   JDRKR+UPA1wWHeYuEIEzq61WzP2r9waf4nLZm/Tl6XGbxNeT2P1uq1L7F
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="378009308"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="378009308"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2023 07:22:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10830"; a="866961648"
X-IronPort-AV: E=Sophos;i="6.02,244,1688454000"; 
   d="scan'208";a="866961648"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2023 07:22:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 11 Sep 2023 07:22:07 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 11 Sep 2023 07:22:07 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 11 Sep 2023 07:22:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4N4++tMDgHMcwDUcQ4XWGqP0Gi2LbgCBAHWJJlSlwyaX1i/oF9AKh3F3BiIb08CD4m5RkiaMNWRedUUrcTeGRXJFjKImP8HkBJqjVz462sAvegEiIOJpXfdtwKkge6EosbMSkDenz+v+7HUzYCAuG7BPbzzFE3KQabI2XzM3ybf49g7FYyLcsib9nIJQ1R/Ak+3kCWEiNkZzhJna6Lpjq/n3raQI42tDEpTPa+EkQOMPjbF2vz2tkeJIg8NTbKvbd+jIfsAh549Yvr2kskXZUqeMWlZPp+JKdtCxo8ys8Be3CgwuTBPiUUzPuWgnYz3eik4esq6a6exzFdyNUDMPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oebg/edzbiiJrL2eKNUYYEv+3y+urtsIGNp6r/2CGxE=;
 b=S5I39jK3jD9Lnegc9SOUjdkMN+HJkizdt/xgi116lzR7HGiUdb+vL6ULU36bpqm12For0ImErPAibJgpxqK8N0iWTrczrqhhhPPiYnZ1OaitqAwo6Utv/Z2Nn9/3FVO1LlJKbI7QvUkXP+2TFjsKQqf0AeRWL2NMLfZ41z+Cn5JmWEuNhsFgtSU7gvFneB8ZPtKhjW9FkLlNcyEMgrAQq9BpPAGaeGvaUntMOB/RgrnLezSGJT1+3dx4a+pJX9jc7DxaoYcy3ajDhQuC3sCPDKcXWzUFNIAJgSqN58VlOCpjBBma+q71BS4YWf+CR3ZL+gKtOpsHsaGOkqnawOg7MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SA1PR11MB8374.namprd11.prod.outlook.com (2603:10b6:806:385::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.30; Mon, 11 Sep
 2023 14:21:58 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::bede:bd20:31e9:fcb4]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::bede:bd20:31e9:fcb4%7]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 14:21:58 +0000
Message-ID: <d385548e-9788-2814-05c9-bb0f275b233f@intel.com>
Date:   Mon, 11 Sep 2023 16:21:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
Content-Language: en-US
To:     "Alessandro Carminati (Red Hat)" <alessandro.carminati@gmail.com>
CC:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Josh Poimboeuf" <jpoimboe@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "Luis Chamberlain" <mcgrof@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Nick Alcock <nick.alcock@oracle.com>,
        Kris Van Hees <kris.van.hees@oracle.com>,
        Eugene Loh <eugene.loh@oracle.com>,
        "Francis Laniel" <flaniel@linux.microsoft.com>,
        Viktor Malik <vmalik@redhat.com>,
        <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>,
        <live-patching@vger.kernel.org>
References: <20230828080423.3539686-1-alessandro.carminati@gmail.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230828080423.3539686-1-alessandro.carminati@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0139.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4bd::14) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SA1PR11MB8374:EE_
X-MS-Office365-Filtering-Correlation-Id: 129ca22d-950b-4253-c3ca-08dbb2d2755b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LYLgtxzGYo+RiisC4f/R4PejQR72teM68o9a5XtJoeIpA9DuzNBh+DalUdciq/yvZ6G7fYvE2j/vH9OQLyL04JxTIjLD+AXxpTTrCt5pg1ulm13rNbaP1TQZK/wuh7XBt5lSUc4zrhBHyTB8j6VjDOZplew8tTKlong6fLKoh4C5ib9zPqb34RKskkmUiQFalKf9FROe/hEiA7EfSPs26oC/LWht7PQh0yw+Ke9fySG9lwlLqWT5vjka2oN2YsapI8Mjnc8lyd1fBXfpjru/PmvpjWlHxvzUaowXf4cHRGbI7fc87BV8cXAINrn5hCGipTED8nvy/MFU+Q/v6W0qsaoAgzH5LWIJtyO/pNdo55sCVVnGiLBklQrEd2MeT2pEKnFmlPLCpLSXb57A+QnrSrLqLKRaaQsKnBt/8TXdRspK2e0es+JpKhNP+SWG5C97zp0QzYzwXv8FeJTuyxXYRAgH8QckspG9YX2ycjA5Y3J/ZLy6iGM0ePGcJ20s3LzilUOHbXmOCnu4zVtZPvRtYm/gnz8fcHcgx4RJA9oaHJKG2a++dPEDbabQzULxklk5pKJJRYxeyap1MINMdSwZAGAAkbP55h4Ib0qTFR6dDgzMaFwfDGlZSc15jFzdc2XI4PzDwBA3HydLJVJC/jEPjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(39860400002)(346002)(376002)(366004)(451199024)(186009)(1800799009)(31686004)(66899024)(2906002)(82960400001)(38100700002)(36756003)(86362001)(31696002)(7416002)(2616005)(8676002)(8936002)(4326008)(6666004)(5660300002)(66476007)(66946007)(478600001)(66556008)(316002)(41300700001)(54906003)(6512007)(6916009)(6506007)(6486002)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFZpL25LaFdGclFNNUZBOE1SblVjangyR3FlYW1PbGdxZWNqUHoxam1WTTRI?=
 =?utf-8?B?OUlmcVBwUkVXTWV5eHhuM0VCd3RuZTQ4ODhxVzNzajBKZlpnbzRoZlVSaWdB?=
 =?utf-8?B?N0tKTk95cEhiYytCOXdjbW1xdjh6UDZjeTJ0NmdyendZbUl5UUdVT0psYlJN?=
 =?utf-8?B?QlJRU3Z1OUJMaHlFM2NjZ2FwZi85THo2S0tjTEZ6dUhEUG1wSzNzMDJHR2Zk?=
 =?utf-8?B?MkFMcW1tWDdIek5xYnhPZjllNGFCZ3QrbTJTditCTlgyMFhtTDVNTzhiL3NW?=
 =?utf-8?B?ejM4RnhTajduWmJEMHEvQTBZVkFXdisrOTVURlJLcFQ2LzhJZ0xuU1ZwUGkw?=
 =?utf-8?B?NHM0OWxFSUJhZ202ZVNLRWx1OE44ZEZRUzEvZUNnc0J2NXJoMWFGOXJ1VHZG?=
 =?utf-8?B?THVqTis4Z1h3RmVTZ0VkT3A1NW02dFh2aGZyUjNuSGZoeEcxeUt0R243UVVW?=
 =?utf-8?B?b1l2cTVqaDVXN0lDbGFHNFM4dDV2UUdRakN0L05Tdm1mT3BWOVV6ZW1CQU1s?=
 =?utf-8?B?dVlhSEV5d0hoNzgyZGpMSDg1MDFNMjZOWmdKR1JobVIrZGMzb1RtZllGdUNR?=
 =?utf-8?B?OFg5RnVZbEk0c0c1azYzRkVUczFQVkNEVDlxbURSQ1JYZUV2c2EwT2V1cndF?=
 =?utf-8?B?S1NMN2pzNEVCWkxDTnIwVk9hTGV5MTNycmRqenk4bEJrdzB2UFZZSEFWQ1Nv?=
 =?utf-8?B?S0RGdHd3dXRPMzU3R3VkZUh1dkNnUG1rbTZ3Uy9TdHVRdlhuZ2psczFnWFRF?=
 =?utf-8?B?Z3o4MmZWMVpIWFRnMzFBNXQ5a2JkTlZtL2licFVtMlllSUhtV3FYT0dDV3BM?=
 =?utf-8?B?NXJJS3F1WUY5bHk2NHhiL3hYRWdkbURpWXVWejVmUzZhUVlyell6VGJvbmxk?=
 =?utf-8?B?b3JwN05RcGxlNUE2NFZWY0ZmSDFaNmhLOEtxUmo4OWdPY2FwWWUwSmdSTElz?=
 =?utf-8?B?dGVRZzNjeGVFY3BtK0tIMzVvTk5tS0FRbnBoYytRbUhXamhsUkk1cnhxc04x?=
 =?utf-8?B?dCtwTEM2ckhONkxBaU9tOUIwZ2gwK2hGZFNjSSsxUDFVcnNmMmsvMjVWS09T?=
 =?utf-8?B?Y0xDNloydU1kays3YmFrd2FOdnJlRzN0OGJSKy9URHZEMm9nNXRwOTBHUlh6?=
 =?utf-8?B?V2w0bEVYaTN2ZXc4RTNabE5raFplVUtLbmR6NmpwY2lkaEtjOXFiV2g2dmlm?=
 =?utf-8?B?cEk0NElHZ2J5VWpvdCs4a1BSY293eEs1VDkxV0NkT1NPNStVWmpGNGNxRllM?=
 =?utf-8?B?L1BsYXFOdzNXeGJJYk5GdnQ3VjNxbWovaU5waXVTREw0OHkyODRlcGowandi?=
 =?utf-8?B?b3dDM3JKTFlVVVBGUWxwK3g3Y0xxZUVIeFV1RnVaODhvVUVCRjd1c0ZCeW5W?=
 =?utf-8?B?LytkSy9oSHI4dnFhRFNXcHgvYVhNVHA1RnBoaG1qY1B3YVA0K0N3akUvVWVv?=
 =?utf-8?B?ZEhMVDVlTGZZazNzL1gxT3RTenJYdDlhSlVCMG9rUGQ5V0tibVVwMkI2eWQ3?=
 =?utf-8?B?YVVWMlQ5WFpkVlF0T3kycktmc283b1JiVFNuMzJIdG1nbDRlNndyQzdVYjZP?=
 =?utf-8?B?MkM5WFpycEJhakxCdmVOWXZMam5SUzlzUDNFS1lUU2VPdWlqS0EzYm9vQVpV?=
 =?utf-8?B?QjBPOENXNm9JeTdTaGh6S3dLT1JGeENNT3NxRU53Z2xOOWRzb0VMS0JiK094?=
 =?utf-8?B?OENQdUtOZldYRjlWODkvQ2l6L3l6L2k5bkVIOGRRZmFYVnVvOXliTXZIRUFC?=
 =?utf-8?B?bGJCQ1FkZGZ6amZERm10WWVXTWpZVFBDdEdRWUQ5ZjdCa3N2YnFmOU9CSUxJ?=
 =?utf-8?B?d04rZTVGMTRMTDF6RkV5aXdyc3pVM2s0d3pyVFBlSVllYVVUOVdibkp2NE5o?=
 =?utf-8?B?SEZMLzhkZGloNWV5NmZNVFpjbEM2TTNVWEpqVmJRQ2J5ekdaMjdqUGZHOXVB?=
 =?utf-8?B?d1FJeENwYnFVaVBFa3UxTG10QTlqWi9iVUsvVWVKOTNiNklHNng3OUVkdFRt?=
 =?utf-8?B?Z0hUUzZlc1U3c1QvVnB1S1FYWVBjbXNqaVRMMERONzhLdGRZOTdnb05naTFt?=
 =?utf-8?B?Uk9pMDJ3LzM4SDVDRXdwOXVlNUlVMzVjYmRDd1hmaWZ4N3N5RmJIa1pzQnF0?=
 =?utf-8?B?RWU4QU9sdy85TGlWalN5blNvdFlsZU5JNGdCcmVLWk5aVHgyUGk0b1QvUHJP?=
 =?utf-8?B?M3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 129ca22d-950b-4253-c3ca-08dbb2d2755b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 14:21:58.7517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 66z0ab7vhhAmy1ru899ow2Ab0jj/izTgG8zGhh+lxv51fd0+jvs1FugFsc4seZgntDuEQxUL4R2qHTUjeSugIcNIApZegUiJD0HzSpSwikM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8374
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Alessandro Carminati (Red Hat) <alessandro.carminati@gmail.com>
Date: Mon, 28 Aug 2023 08:04:23 +0000

> From: Alessandro Carminati <alessandro.carminati@gmail.com>
> 
> It is not uncommon for drivers or modules related to similar peripherals
> to have symbols with the exact same name.

[...]

> Changes from v2:
> - Alias tags are created by querying DWARF information from the vmlinux.
> - The filename + line number is normalized and appended to the original name.
> - The tag begins with '@' to indicate the symbol source.
> - Not a change, but worth mentioning, since the alias is added to the existing
>   list, the old duplicated name is preserved, and the livepatch way of dealing
>   with duplicates is maintained.
> - Acknowledging the existence of scenarios where inlined functions declared in
>   header files may result in multiple copies due to compiler behavior, though
>    it is not actionable as it does not pose an operational issue.
> - Highlighting a single exception where the same name refers to different
>   functions: the case of "compat_binfmt_elf.c," which directly includes
>   "binfmt_elf.c" producing identical function copies in two separate
>   modules.

Oh, I thought you managed to handle this in v3 since you didn't reply in
the previous thread...

> 
> sample from new v3
> 
>  ~ # cat /proc/kallsyms | grep gic_mask_irq
>  ffffd0b03c04dae4 t gic_mask_irq
>  ffffd0b03c04dae4 t gic_mask_irq@_drivers_irqchip_irq-gic_c_167
>  ffffd0b03c050960 t gic_mask_irq
>  ffffd0b03c050960 t gic_mask_irq@_drivers_irqchip_irq-gic-v3_c_404

BTW, why normalize them? Why not just

gic_mask_irq@drivers/irqchip/...

Aaaaand why line number? Line numbers break reproducible builds and also
would make it harder to refer to a particular symbol by its path and
name since we also have to pass its line number which may change once
you add a debug print there, for example.
OTOH there can't be 2 symbols with the same name within one file, so
just path + name would be enough. Or not?

(sorry if some of this was already discussed previously)

[...]

Thanks,
Olek
