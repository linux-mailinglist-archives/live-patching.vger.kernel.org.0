Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF29375F35A
	for <lists+live-patching@lfdr.de>; Mon, 24 Jul 2023 12:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjGXKcY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 24 Jul 2023 06:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjGXKcX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 24 Jul 2023 06:32:23 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED38A8;
        Mon, 24 Jul 2023 03:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690194743; x=1721730743;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lt4RYDKYShWvY/DNvMQR4dkw+fjyykoYTrkZnSyjjeE=;
  b=dSCgcCsZIl6tDrfrZPiZkrxVeAEGlKBeeJBSsy6jZE1Xih/Q7IzEvqCg
   AbFnfUdeQm8QIWJmSpgrtCPQc9TzXsRGfAv7a8Id/FQYPQV8QUNIpTJrA
   Mg5xgdVQeM1h3wM8lf0+ri6MK0FNO0Jv1mngovf+FIKdfBYMTPaB//qhV
   rKWVdP5q5oMYekpLg+DzsVSVrIAf0nMc0s8CY8aOpU2UOcfrK2y/vysKF
   1o0182LXgwlpmku7BJlzasj+MB3pWCpYKLdqLlT9qhQ4Cynx8pl8Y4Exl
   MyvbrttiM/W998L86CoN2Yxcg8hY8jWVQA3C2f1VBMg86NhjL/mbaFRma
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="398307013"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="398307013"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 03:32:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10780"; a="675782640"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="675782640"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 24 Jul 2023 03:32:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 03:32:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 24 Jul 2023 03:32:21 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 24 Jul 2023 03:32:21 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 24 Jul 2023 03:32:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+KqF0M1olahAHbkULDHkWN7ONBMv9C38hR+ewxsjCJ6AS7jHzlAvj3o2+hBPx/MlmFBXMsDlod4jADluc23zRfGSGfMttVpJ5xPwtrAME37ugQd4hq9V71QlQpYEs9B3RQSGIeTGI/0yswmfo2XFZCDyrzaIeZua4c6/Yo7mE5gJB8C4L6xM7LVU8FVwm7fx2yMkeBQnJb8JqmWtsONFGHsW+bklUsCa3HJTBhHKdi5mpA13iRwb9QRgPDisjrDFymmGLOGdn3r9XBni7IeFFkQjJA6cNVyxPKBuYyAtSQta1mmITWJMAmDjjE2sqqh1TPpDo0EE62dyqM5rfr+Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7T+xG1CgvbTtCIf1LC52917utqo6/df/qVTk76XO38A=;
 b=lX+rf2/aQ5lMSlJq8AN9MavgoRDwtPw5Mh1iLunbpM0KqGa81E0j92Ad1Zk+YKI603tauK4p31N4mEL9ypBckJieicv0sPOFwLqqxJ9JrnNoAXg2ARPvytx4AqcJ/ecTowMfjV/1pra272txWKoAuNNFpix8etdA3HnYbgXQ9YUY1rcEsRhkpCkBpbuqyRzpPUG5vepidu9gnXyu5vsWbb/d8HpN4RJt91B0cEA1LiNPypjj+Fkgu7CRFEEH7YFh1l9HjZFTxPO9OLLVPg8MhR2KeDN94S8KHFA8yf5n9xxynHOR2pq64WTzhGjMCXyn/BgboL5FGHoSrl0wsP94vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH0PR11MB5928.namprd11.prod.outlook.com (2603:10b6:510:144::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.30; Mon, 24 Jul
 2023 10:32:18 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::44ff:6a5:9aa4:124a]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::44ff:6a5:9aa4:124a%7]) with mapi id 15.20.6609.031; Mon, 24 Jul 2023
 10:32:17 +0000
Message-ID: <6ce978c1-825f-c1fd-41e3-eba2324cfd56@intel.com>
Date:   Mon, 24 Jul 2023 12:30:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2] scripts/link-vmlinux.sh: Add alias to duplicate
 symbols for kallsyms
Content-Language: en-US
To:     Alessandro Carminati <alessandro.carminati@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Nick Alcock <nick.alcock@oracle.com>
CC:     Masahiro Yamada <masahiroy@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Nicolas Schier" <nicolas@fjasle.eu>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "Daniel Bristot de Oliveira" <bristot@kernel.org>,
        Viktor Malik <vmalik@redhat.com>,
        Kris Van Hees <kris.van.hees@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>, <eugene.loh@oracle.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        <live-patching@vger.kernel.org>,
        <linux-trace-kernel@vger.kernel.org>
References: <20230718125523.2fc05491@gandalf.local.home>
 <20230721092127.1931028-1-alessandro.carminati@gmail.com>
 <CAPp5cGRBW6WDm9ku3nsr0x=rhEOGAUx==BctCo+DJ+498Tz2Sw@mail.gmail.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <CAPp5cGRBW6WDm9ku3nsr0x=rhEOGAUx==BctCo+DJ+498Tz2Sw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DB8PR03CA0010.eurprd03.prod.outlook.com
 (2603:10a6:10:be::23) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH0PR11MB5928:EE_
X-MS-Office365-Filtering-Correlation-Id: ae45dcff-5f3f-4217-a3f0-08db8c314103
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hs04UAFAs6xaYJM/v0skeRLZEPv1rhmQlUSng3euU2UP9bLqWG23+7/KZ3vFPr3KxizPLXTAEnp+BwFEIeKFFgQqVUtf7LXIcfeg1HKc6sz/EWjLkMFbM4JWRZk8eCewjXlCr/sn+8+BSnTJFJjCoXxH9rZUK7mdon5Dfieu7AwkadVv3qsXo2fknF3i630Z/UHa8btouNvOmxHjjnJpXorsKysnVUtP8+aUZNfI3h1uktHiAqaSuR2oJ/GZFSpN3ehbwLj/i9+QTb8ws8aufzjyaBzPQHnjBynt6IYNUYPTqeisxNdOD9sHctQ7dbDpjkXBu1XE0sHN9Y+0GgJrI7X3mBrFXiVr2pjkbO8V4pTDEHNYWG86XMt5/H4rTASiJajpOyrsMz6IB5P9F9Gjv59+38LXk7GOXhMaNbrhEYDrF35/ciKaFD/m7ZHWUCU1VSXkq6awXvX0qgA4ye9daleu+WGzJFnCksqeAEIL5AfiZhp7FFbnSa1jHM5nQ3K+oiGURXa58amTougARFOqElthaqhRX0euIiENW9d8G34cwuOK1O5rIrP/zc31Cp+L/w20Hr4hBDFr5wee/hAgPirOyurQakuZMY4f1CGJzRsEYuUEGXHIRiQ0df2/jC/lUkH9znCcqdIzC1dfAtEILA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(39860400002)(136003)(366004)(451199021)(2906002)(66946007)(66556008)(66476007)(6666004)(478600001)(6486002)(31696002)(6512007)(966005)(110136005)(86362001)(54906003)(83380400001)(36756003)(186003)(82960400001)(2616005)(6506007)(38100700002)(26005)(4326008)(41300700001)(8936002)(7416002)(31686004)(8676002)(5660300002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1NYUHI1cnAzR25zSjBGQ0ZIbnBaMElhWFdxN3RuQjJGVzQxWk4zSVkrTzBr?=
 =?utf-8?B?ZFhQdElLS2szckpNUWF6SmZ4MG1XNEI3M1FnNXBVZC93YlFlRnVnNDB3Q2NM?=
 =?utf-8?B?VHJRQm1qMkdhUnRkbUFXQ2lpSUc1Ym1QamZLS0lEZElWVGwwNVBhZXYyYUlB?=
 =?utf-8?B?SFd1TjNrS01uSVFqQjU1OFcwdUE3S1dBa2NZTzNRUVJkWitHTzU3Ri8vaTNB?=
 =?utf-8?B?a2x2WVdVZVk4WnNUNWFPb3liRkNSQ1dMT3puUkV4Y3MyWGlyU0g4Z043VE94?=
 =?utf-8?B?V0xKSEE2QmE2VDVPOURCWDVoV0lwS2NrVUs0ZFdFQWEzSkViQ2lPb2JXSmp2?=
 =?utf-8?B?aWNWNmI1NFdaYUpaVHV0MDFhWk5uWEtmenhSTVlFOWQzUVVHYXAwZTVZS1Fr?=
 =?utf-8?B?c3RZSysxdUhvVG1LQWpFMmJENU1TaytUV2xaeFdSbjAxYWpTa3dEc1cwR0Np?=
 =?utf-8?B?dDdUbGFHMC83NjFJY0hoVHZNVXBKbGF6ZTBDeFFhY0VqRlloSUI4b0VieXVL?=
 =?utf-8?B?V3AxUmhqVnlSTDBKTUdFUzhad0NZcXlrb0R6bUtCZit4MmJhVWJEeW1QYjRU?=
 =?utf-8?B?TVZVbGNQbUZIR3dBZmpnWUc1TW1XRVd3cGZZNlVGWE1hcnpoTnpaZzlXN1Rx?=
 =?utf-8?B?aG5ndldlTm5qQmpQZWQ5em9KVEFDZlhxZmhyanFkbExwVXl0dHFhN08wbjll?=
 =?utf-8?B?WjhORDRTbmVicDBOTFk5RDhITkxzS3lldm4rVmliUUU2L0FIUStMNVJzRU0v?=
 =?utf-8?B?Z016MStXZitIREQ3aGlSeU1oTG1JeWIvTkI0RXROeExEbVRVWmxybTJwZUtz?=
 =?utf-8?B?Ylg3anZXeFY1bndjWUhCZjFBcEN2ckhzY3ZJWm1PbnRwdzlKcE1ibW5ySnM5?=
 =?utf-8?B?ZFQyVHF4SEQ5MkMwTysyZG1Udmc3WS9Ba1A3disrVk43TGV0WVhaYVZtU1ZO?=
 =?utf-8?B?ZEs1Wmg1eFRnZ0ZJdC9oM25qQWh0ZDdCalUraExFZkRsdzdYYnNRbndHRUtk?=
 =?utf-8?B?TW5OSk1VVnNOem5SaU5ORDNSaU1welJFRHRmTC9vbEpHZU9aMjFYZ0NQTzlV?=
 =?utf-8?B?VENURjEybjZBM0NRRVFLUWFzZElPb1FHUDhjaGNQbUtvaitIdjdGSnVaMEg0?=
 =?utf-8?B?NzRBYWMzUjBodkcxL3BMRkVmUFg1NFNxYlYrSUJWZWlYcEJsdTdjYTRpdkZG?=
 =?utf-8?B?alhsVXE0Z0JONGg2L3doYzB6RlF3L2d5VDhMT3RSejFqVWJydE0rWnlGRTd1?=
 =?utf-8?B?bEttSTNaTm9KR2NIRGVKU0QrdWwrNEZpd25JMnRIcGhhVWNnNkpJUjU3cjhC?=
 =?utf-8?B?aStzNTFlTFlwRVpvdWRuVHA4RnhMUXh4QzhFUWtTWmI5RDYzY0ZFVWpSd2FC?=
 =?utf-8?B?NmZqbUdPUHVBWFMwTFlqeDJCYk05WUUxaWJpanB0Yk1WKzVHT2RFcDdIY1FG?=
 =?utf-8?B?Y0lEQ0Q0eGQ3MkptQ2NvUmJuVm5sSEFkSVVwZXd1SWFDVGRDelV4Z0lnUlZs?=
 =?utf-8?B?MEpSeFRZdjJtaUNSRDdHMmlCeENQcVVheXNxNmtuU0xtZXBtZE9NbS9wR0Nm?=
 =?utf-8?B?eUJaU2R4THk3MjE1MkxTKzNBTHNSdGhOTFovRjZsTm5oQ1RTUW9qbk5ha3N5?=
 =?utf-8?B?dWFlN3QxWDlqT3lLV1ZBWkhzeGJqLzgwWjZaUG9SWDRtNk5oVEsrRFZ4K2FR?=
 =?utf-8?B?ZW03Rlc4V0NxemxpZ1BpYjRIVDljZ0ZkaUYzdFZvQWVPUVV5TFU5WFFTd2hT?=
 =?utf-8?B?NnJuK1VXd3BiN0NnQUFuclA5bEh0STI1VFhOTUJucmQ2bWxPTzVtbURJSEJ5?=
 =?utf-8?B?U3FEV3NhUlJCanA2MzhMSGxSd0JONlBYSmRzbnAzRDhWV0Z2dk94eDBiTUc1?=
 =?utf-8?B?TTBzb1ZaTG9UNHBiT1hBaUxrTVpIeHZtQUtVSDgreWdyZ3hYOEdaRGF3V2Fl?=
 =?utf-8?B?L1ZOQWhGRERtSmEzbGdzWFQ1UC9veDArd0JqdllrcUswc3ZJdmRBLzhsNzVT?=
 =?utf-8?B?ZzJnVklQTHhScjlIam5rZnNZenFNQ0lVY3hEQ2ZtTVY1MHNFZWM4cW93YmZH?=
 =?utf-8?B?RFNWWGFGdjBEMG03cGN6ZlQzUHhydkNqK0ZPaGpYSGFMSW1RaTdTeW9JQkdL?=
 =?utf-8?B?ai9Jelg2cS9yekNGb1lnelV3a3dTSWcxaktxMHFYbEJaSDU0ZUQvYVRMak9w?=
 =?utf-8?B?T2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ae45dcff-5f3f-4217-a3f0-08db8c314103
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2023 10:32:17.7463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zTxfY+5TP21iBL7F3Uz5jtgI0Iej6H0ZkDfUxq2m4szVepT3g+NuZe27Q6dtZj+CtezFZtyi21DXHqoZRYVKy3+kraatnriy9DORbnVb95M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5928
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

From: Alessandro Carminati <alessandro.carminati@gmail.com>
Date: Fri, 21 Jul 2023 14:40:54 +0200

> Hello,
> 
> I apologize for being noisy today.
> 
> In an effort to be collaborative, I would like to share my thoughts on why I
> see duplicate symbols in fs/binfmt_elf.c.

[...]

> ~ $ nm -n built-in.a | grep set_brk -B100| egrep "set_brk|\.o:$"
> fs/binfmt_elf.o:
> 00000000000000d4 t set_brk
> fs/compat_binfmt_elf.o:
> 00000000000000d4 t set_brk
> ```
> 
> These two symbols come from fs/binfmt_elf.o and fs/compat_binfmt_elf.o, and
> they are just two symbols that happen to share the same name, as is common
> in the kernel.
> 
> at the same time, addr2line reports symbols to be generated from the same file.
> 
> ```
> ~ $ llvm-addr2line-14 -fe vmlinux ffff8000082f1d2c ffff8000082f4454
> set_brk
> /home/alessandro/src/lka64/linux-6.4/fs/binfmt_elf.c:114
> set_brk
> /home/alessandro/src/lka64/linux-6.4/fs/binfmt_elf.c:114
> ~ $
> ~ $ addr2line -fe vmlinux ffff8000082f1d2c ffff8000082f4454
> set_brk
> /home/alessandro/src/lka64/linux-6.4/fs/binfmt_elf.c:114
> set_brk
> /home/alessandro/src/lka64/linux-6.4/fs/binfmt_elf.c:114
> ```
> looking at the source code:
> https://elixir.bootlin.com/linux/v6.4/source/fs/compat_binfmt_elf.c#L144
> the cause of this behavior, which is unexpected but correct.

Oh man, that's some deep investigation!
Let me go back to my old tree I was sending RFC from and check that
particular case there...

$ grep set_brk test_ksyms
ffffffff814b46c0 t fs/binfmt_elf.c:set_brk
ffffffff814b7040 t fs/compat_binfmt_elf.c:set_brk

Looks a bit better :D

> 
> The rationale is that using source file + line number iproduces better kallsyms
> table, but it is still do not produce unique names.
> 
> BR
> Alessandro
>> As a final note, please understand that my patch was not intended to undermine
>> anyone's work. I simply encountered a problem that I wanted to help solve.
>> Attached to this message is my code, in case anyone wants to replicate it.
>> I would appreciate being kept in the loop, as I genuinely want to assist in
>> fixing this problem.

Thanks,
Olek
