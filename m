Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50DC6BBBD0
	for <lists+live-patching@lfdr.de>; Wed, 15 Mar 2023 19:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbjCOSQm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 15 Mar 2023 14:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjCOSQl (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 15 Mar 2023 14:16:41 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0969B70432;
        Wed, 15 Mar 2023 11:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678904200; x=1710440200;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UoOLGCHElLJHE914g69hMuHVYDgaYmJxD786LnMTNxs=;
  b=iOv06KshZv525NJj/uBVsHddL1J3eJ/86MfxhONT/qO/JxH94QkAQS9Q
   tSeWRhYvFGrTUyjJygqvfWs3ZYCPtgRINnY3WXvi+XpV7O/isgxkz5fdQ
   t3gzAK/1euxv/wEZNJrnjWHZm0UU0M1mxw6RL75EUIgpKObf79Pn0VSo+
   qXwjVaTMIiAEQ4YRYxzHb70uojs0dbuYqVA0ee8LGqOzB9Nn2GdH57F3z
   b1DF5bSSQrLeXd9Lkhr3GUWVlB7FxLuNVJuG5u/isnEWDCG9YkexkAlSY
   w3MsjnPIIctYRcJ421nVi42Bgs7gSh+1SK0M9krC6xg+0ske67/l4qhl+
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="424058432"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="424058432"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 11:16:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="709770009"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="709770009"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 15 Mar 2023 11:16:39 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 11:16:39 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 11:16:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 11:16:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GrJ3LkhyIAekF++Qj5ye9RPnkJ5LpDV863AyXjbVR6sTSLHkjC/Y5RMpTLxgTAUz/xYxB8pd+nevQJWDcgD+Zh+o8OEnQDjlPF5Yg5UOEl9oZ+eAH0sOAtlb5cvVUOQtzG+7SWoRzgNVa5I816CNJpUZcGJUbUVzE68TjKZqQUJsn20EKyycAfqoUNYoPoZFZj61W5Sg2Yq8GjQgGKYLb9KIeqEHM8cZgV3/HPdPYBrZTNS1lAQ4UQda5DsrldnXxtD1/KGjDArHq6iWfDlRpYdaC9W9L3Hsr/4QeIAfOVTqBYAj2SNe+L2/GRrIDxlUs1dxSFB9dUUFWrD0rcVr9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wWlcTC/7MCDM5uFiCCPEH0VVVioGT/bM0uBWO+6CCmQ=;
 b=fl/XtjZHU3fLwHXCw7mdHQZkyavHywLqtgYg4rajfEyBI29XpUwirM3WYXO9bN8PMAfMPvID7ct+il+gyqn7po2cgZ5QD5OoSbj8W5la7ya2Nh5vayJisFH2X94wFNwgoA2iZuM+lTBsE4FAGLOG9zDQ7TXzTKoo49GJDXT2R9tnOWJ7zl18XtELlqVXTDDDfBDw2qv/Sso0DbzwuHG7Glt4HjxJk/VUEUeRaABQgmL8aInitkcq2lrsiT3d1YWfd4v283dcE8xqIr47eURHOk744KK6zx9mYG38zm5mWuDces7y2vRWkqV8ie+11ERe4Z7X6MZ/x3coZ0T2g1YvRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by DM4PR11MB5390.namprd11.prod.outlook.com (2603:10b6:5:395::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 18:16:36 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::84dd:d3f2:6d99:d7ff]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::84dd:d3f2:6d99:d7ff%7]) with mapi id 15.20.6178.024; Wed, 15 Mar 2023
 18:16:36 +0000
Date:   Wed, 15 Mar 2023 11:16:31 -0700
From:   Ira Weiny <ira.weiny@intel.com>
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        "Daniel Thompson" <daniel.thompson@linaro.org>,
        Douglas Anderson <dianders@chromium.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Chris Down <chris@chrisdown.name>,
        Nick Terrell <terrelln@fb.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, <linux-modules@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <kgdb-bugreport@lists.sourceforge.net>,
        <live-patching@vger.kernel.org>, <bpf@vger.kernel.org>,
        <llvm@lists.linux.dev>
CC:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Piotr Gorski <piotrgorski@cachyos.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH] module/decompress: Never use kunmap() for local
 un-mappings
Message-ID: <64120b7f2e123_2513fa294a7@iweiny-mobl.notmuch>
References: <20230315125256.22772-1-fmdefrancesco@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230315125256.22772-1-fmdefrancesco@gmail.com>
X-ClientProxiedBy: SJ0PR13CA0136.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::21) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|DM4PR11MB5390:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c6d3333-c8f5-46c8-e567-08db258169e5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vWChfBLao6nKEH7jMLaaPDg6QB5SzgaXfDsTwU3/82rd2s2IVLOrc7UN3dt/geEG8awyu7BNf1XzMoAmB4gOLOQlt9IAhrfemIuTozlmRI+VAnPQDUubVlxzKM4PNArj9eUExuXPgHPA3v7yws+7i+5puavToOpX/ujwNcJX5RU8nO1zQC6V4DsIwqFulNO9DkrZZ3lR1Iip8QrLDcHXyVDXnfkEDHoQhJx8FuZ18Flvbg9WaMzMDVnrg6Ym725VPJ3Og/MlTnq/eTZlDLJ+hUAztUF7lTn4jQWJiKBJFunw8Fc80m02IY4HD4Bfr710NRwS0qckE/uIPon+PYn8OZ4jMxb+SQkd9aHBlJ4x9FdhSwOmc+rzRtpJTWgPTK4G2NkdNjxk9GPFBIwB5iOB4TCEp7NltyfeadO3VrvJwH9ihICTzHAWEsSd8Hwl/8v9FGCZ7rAF58TNYFlFiXnXc28hyUeRORBl+mm+HDRSODmhKZw7hH8nxoGruSnPG7Z98tkSqEB3cXa1UO9iFmb5Lulnp6rTnywb1+0QRvKQcL8l1w8DRoNUNvJKpFEWuDqduciOGRvHEXnd7lj3YN/HCvu9bE6P+0/Rzc2AYGLkcg4+V9Fj4xopD2erm3HopVJtzuQePCxBFHPkBaWHk+vbjDK2Z5/PhCZwH/L8eAVWTO+CjKoVWbdzQzbiB2G8aAZ4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(39860400002)(366004)(376002)(396003)(451199018)(7416002)(5660300002)(478600001)(2906002)(9686003)(6506007)(26005)(6512007)(6486002)(6666004)(107886003)(186003)(44832011)(86362001)(41300700001)(38100700002)(82960400001)(4326008)(66476007)(8676002)(8936002)(66946007)(921005)(316002)(66556008)(83380400001)(110136005)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GnncIWgTad5+W7x2yjuHWrHTc0pNMjmyOgA8c7bmDKKmCDZY4Be1qf8VO/Ze?=
 =?us-ascii?Q?3W+hzMuppVxAbSKPPEXA91VVjjmRp33BRDE3BKLo4OYZtni9XtNhIVyGixsy?=
 =?us-ascii?Q?l782MEw20UQhm4nNHSnOelhYLggwF9dzWlUGa5bBGHD6EESICmGaQDIjrKWX?=
 =?us-ascii?Q?E1Tjgjnfww8/0vhRWnH8LFdkm8c30xQ2rQcS5mB5jlVhgQCaPejnmBThLX3E?=
 =?us-ascii?Q?V9xjInpl1mMqkqGJTTlXAiyrAhhlUOojwj9OPsHTs3mCCNCVKUyqOn+bMH4P?=
 =?us-ascii?Q?ExNTW/G3LCGsMrFp/mV9hjuS/LHk5ZLWyoHxmnRuZ0Pf7QgBHtcrLcPQsE3b?=
 =?us-ascii?Q?dggjvV7zPYcHLONSEuA9j0/RqN0T2CcjIsJSgk842Qq1X70hPZKMPvG7nvDp?=
 =?us-ascii?Q?my7zzS6lAg6RcOTg7Na+9YR620PPSs+qRVeVU59mHjP8P0x76EVvzP+5jRIY?=
 =?us-ascii?Q?ZqkmeBaexanWpEtYLgQvJFSmUlQk7JG/hcb2vRDfko3CEvbFRaNP3cdu/WxH?=
 =?us-ascii?Q?mw/r3PY01qVsXIjVUh2stj/91twKWprRwSah/QiEJyKwsLw5uMngiy6jyHS8?=
 =?us-ascii?Q?zyiiMmQmeD72Wj1l2XzpaEDTg05xaE2cPCjWpUZfj1L6MS6yA7+Ij2EWPiV0?=
 =?us-ascii?Q?gtcfICm768SfLioahMmHddYw1cwCObIEZeyxmzenWMWe/P1hD1es0GX/cok7?=
 =?us-ascii?Q?P7x7iCrx5FTmlxb+obeiJxAsgUUv+QHhbOLy0fN9E9RsrcgdlHzTwEu5V5Dp?=
 =?us-ascii?Q?7D6PHTO+8R1LlrKFHBo/g73haZh1ETWHsYwqDVFZ7t5UHdYbMdu279XbmR74?=
 =?us-ascii?Q?j7mr1bF5h8UBmMeGGocts1JSNfbhmYGbawFx6S7FVxykH7wI8xkr1EaCDlqE?=
 =?us-ascii?Q?d1RPqvbP3YxBaJ0SrfznAYKCKwxWHVMd6Z0Nr7zRNFgCCF1HEp5fqF6INPlK?=
 =?us-ascii?Q?rYvntlxDKu2S70t/paYkyeNTOohwMLXg3FFofitxQk2PjWqJ7l39sz1LYxT4?=
 =?us-ascii?Q?K/Du5htsn8VL92nR+Nxztu0LJCzwV8Pxp3FbdsN7iMaUjRzcccHI78T7in6T?=
 =?us-ascii?Q?mOcqjBiTScp3JmUJ+trja02zySAEsv2po7R0tfiEl+kfNSwKofOM6HMM+wf2?=
 =?us-ascii?Q?lT4ez5eHmK5oJxfLn3H26cH1iuBgapu8NCqufS13Fcy/bVtKbmFi4gf5zhdR?=
 =?us-ascii?Q?8e6kafDeIPS3t3eDA+bilo9onAngm65C8NFOv1EAYGN3sGE0yIw2ZsN+CI4T?=
 =?us-ascii?Q?1Jsr9OupamEYLSCyvRDHt2dA6jDpKxogMTQ5sUgbM6ZOChjh43hOfjplsxWy?=
 =?us-ascii?Q?mkk0VC37Ha60R+pe+T/olFOruOWIgGwmCuXbqaZIfm/Xs77cB/etR1IsIX8Z?=
 =?us-ascii?Q?P0g0WfduhEplvunUwFYR3u37MbJqmSYlqm96Igh9uaF/9TilR5gn4AJjL4qK?=
 =?us-ascii?Q?5qGSUyAI3B3Sfbyjrjz2/INry4tXQ2MXyNIkirMLRs2+GqkXdDimr3xF4SQy?=
 =?us-ascii?Q?Wi04LlCfTxk9q59TzWy3qIiU85P1u3JMPPfwIqqM1UYV19Q2iAwLxm4iUMqu?=
 =?us-ascii?Q?hQfaMfBe+zNiJC62sbwrvfsp2jH2xKbfzfOTXtkM?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c6d3333-c8f5-46c8-e567-08db258169e5
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 18:16:36.5739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u3wWrCeSHDbz1hN6Q2lZoAjYMOiM+kyUR3VrwvnoiuSK2P+2+uTyCiXOyaUjx/cQlzy53OpKBzlaHDyuu8Rg+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5390
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Fabio M. De Francesco wrote:
> Use kunmap_local() to unmap pages locally mapped with kmap_local_page().
> 
> kunmap_local() must be called on the kernel virtual address returned by
> kmap_local_page(), differently from how we use kunmap() which instead
> expects the mapped page as its argument.
> 
> In module_zstd_decompress() we currently map with kmap_local_page() and
> unmap with kunmap(). This breaks the code and so it should be fixed.
> 
> Cc: Piotr Gorski <piotrgorski@cachyos.org>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Stephen Boyd <swboyd@chromium.org>
> Cc: Ira Weiny <ira.weiny@intel.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> Fixes: 169a58ad824d ("module/decompress: Support zstd in-kernel decompression")
> Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> ---
>  kernel/module/decompress.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/module/decompress.c b/kernel/module/decompress.c
> index bb79ac1a6d8f..7ddc87bee274 100644
> --- a/kernel/module/decompress.c
> +++ b/kernel/module/decompress.c
> @@ -267,7 +267,7 @@ static ssize_t module_zstd_decompress(struct load_info *info,
>  		zstd_dec.size = PAGE_SIZE;
>  
>  		ret = zstd_decompress_stream(dstream, &zstd_dec, &zstd_buf);
> -		kunmap(page);
> +		kunmap_local(zstd_dec.dst);
>  		retval = zstd_get_error_code(ret);
>  		if (retval)
>  			break;
> -- 
> 2.39.2
> 


