Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D647D322D18
	for <lists+live-patching@lfdr.de>; Tue, 23 Feb 2021 16:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231410AbhBWPEo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 23 Feb 2021 10:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhBWPED (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 23 Feb 2021 10:04:03 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on072e.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80EDC06174A;
        Tue, 23 Feb 2021 07:03:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMKXg3HgH4MY1RV0eYVEe/t43vf/gCAdxWhz7g8n1UGRxpjLDP8Eoob0ZAef5jVRlHpfjjznVWPkVW7EuxMVcYOz4GcxFPvAFHB5NlldX4YCbkacmlRL0RoLXyR3P1F8Kpto66eHpKEHItUYg11ISJ/eQQVuQkMKM3RtkitPsdjuGUo1CmCyRBAaxlkiWDXCipUiTleUghqjnAVMaAWPogzioFHmckZWGWkeAzC5Q4FIhL4XeCNZkYroVX3wCpsotXz+Cjlm2tRHE/dG0oPHkz8AKLeHLAwVq6IXIXWqu2vOZF/cKKVAsBhfAeYfcO5+JADMd+SN6vALwKXMk3zspA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0h/daXfA1lnbetunYPMBWWinv6FFwUN7cnQRU1yeGKg=;
 b=oSMDTGLjcMO59Q8Rb93Mu7uGaFvNF4DYAdWf+7/tAU5SMYOwRx09LTZXalQv6KgwFNlByMqe5YoFZcQdUPoDkjezGgTBG46t7wkup/tcdWhmo+0+nZjoVLRSY7rxZe6c1TWNoOeaNgIbko/q87P6DLdwoz6NQn76qZJBsNNbPfXtXguEXrpBdC4JJVta9Nie1b2sjmaV8L5D3Ed5G0fC2Ct/g2Rxe+ggn/68kuO3NYigKjAlJAS4IsllEL5nE1/d6fwLEhM+l1PWoILxSnUUQnbVgJfzp07LJLUAaY6Y3+HVNlXmVokY7Rs4uPMHfLdXNS4FRcVHY0pThWAnk6Zvyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0h/daXfA1lnbetunYPMBWWinv6FFwUN7cnQRU1yeGKg=;
 b=rj0Bf7g9/gGVeGvCaNEQ2r8UzPy/33rlrcrpYDqq/BOoVVz7Vsv0eTopYQRQHTO4z/n1IpJ8sDZ6UylKIsaKN0cNZIxyTg3TIbRXsdI252xuJDdch/XhtsnbDeDD0sO0WlZWAlCDfQge/niaUnIajBMRXJzpTCNZsrpin8FFWLs=
Authentication-Results: virtuozzo.com; dkim=none (message not signed)
 header.d=none;virtuozzo.com; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com (2603:10a6:10:e0::21)
 by DB7PR08MB3225.eurprd08.prod.outlook.com (2603:10a6:5:21::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Tue, 23 Feb
 2021 15:03:01 +0000
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::24c3:9243:1877:7631]) by DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::24c3:9243:1877:7631%2]) with mapi id 15.20.3868.031; Tue, 23 Feb 2021
 15:03:01 +0000
Subject: Re: [PATCH] perf-probe: dso: Add symbols in .text.* subsections to
 text symbol map in kenrel modules
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Konstantin Khorenko <khorenko@virtuozzo.com>
References: <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
 <161406587251.969784.5469149622544499077.stgit@devnote2>
From:   Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Message-ID: <00abcbd4-e2c2-a699-8eb5-f8804035b46e@virtuozzo.com>
Date:   Tue, 23 Feb 2021 18:02:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <161406587251.969784.5469149622544499077.stgit@devnote2>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [85.249.47.245]
X-ClientProxiedBy: AM4PR0701CA0010.eurprd07.prod.outlook.com
 (2603:10a6:200:42::20) To DB8PR08MB5019.eurprd08.prod.outlook.com
 (2603:10a6:10:e0::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.45] (85.249.47.245) by AM4PR0701CA0010.eurprd07.prod.outlook.com (2603:10a6:200:42::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.11 via Frontend Transport; Tue, 23 Feb 2021 15:03:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d795f6b3-5f93-4527-67c6-08d8d80c1cdf
X-MS-TrafficTypeDiagnostic: DB7PR08MB3225:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB322571CE1D66190496494A3CD9809@DB7PR08MB3225.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h0/V7/fyVnOsF/Ybr4kUPAZRYNFZKig1T4xHSoIfddCt2XI+E6QWkcTQA2B2/jDrrtJ5/LxYADwy8WwQQxMQylGSqApOZyTkaEpbH2lfoWYFWt2FTpdLCHUWDtVaDACLn3X6qjtJ8N8VXyBkbeQ1iHjWlXMXc37r2uv68tED+VFFKpgzJHfNBcs8aRfJTKHCCqrN4ou4rb37llswW2LqoIE4nWCifuawSWxftKBvQylV27yk6xNnfYy+ugNrzBgctOIJAzArnpNIet4grn0TkA0k3INuv5I+7Bst9I/f6EmReVjjad+Y/EWQuirnOW9oT1n6DZDbD/bkGDKP305dBJl9eyQP04Ive3HjVnBRIim9bG59Ownrewhl59oPKb6FUtusSRaxboJ+d5aInPls/qxgHbdBLcCDlrsbHneC+rIQN5C9uEag9iDb+6Fho+QzDs7PcfTmT0xI8zliDm7Q+78Bmw+4ykNuDoE/5L57EZ8/pu1eHnMGbmsQmqbIlVif3a2W6esCAs1xCsgN99qimqA7/FE1Ohq6xptsR5iyJN301lk9QNvIM+ijUH1xmCqDfqM3vByqMcOpnWOHCtZ7eO2o+Z8J5Uk2wt30GKE5uWkTeYUylaBexY7VexTC5QmMFjLNX6UTul9CqM6IQTRlow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5019.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39840400004)(366004)(346002)(396003)(376002)(478600001)(2616005)(53546011)(66476007)(31696002)(5660300002)(66946007)(52116002)(186003)(16526019)(6916009)(66556008)(83380400001)(4326008)(36756003)(31686004)(8676002)(86362001)(6486002)(2906002)(956004)(8936002)(107886003)(16576012)(26005)(316002)(54906003)(142923001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TCtrcDhGSkpGdTNSdEl0WWxhajBhU0J1dkJmMTJQZmF2WHpCWWRPdENNdi9U?=
 =?utf-8?B?YTN5SGdqQmNIb2htdHpML0RlUlJYWjNiRnFjcVAwaWxoWGUxc29Dcmw0ck1r?=
 =?utf-8?B?R0tXNVZkQ0hFSGx2a2xueFRkeHFGYXVUSVJQT3JmYUNuRGJPbGNjK0pCRE1G?=
 =?utf-8?B?T2E4dEtPVEtHbWdQaDhmcWMrMWVpSkpINnM1SWRVQ01WTTcyTGhxRE1RMzk5?=
 =?utf-8?B?dUpneEJZZ2M4b0NETnlUL0xGNllGUmY3c0Jpc24yT0xFazc3RlJiMWR2UWRj?=
 =?utf-8?B?UW85WFVPN3ZBVTRwNEtjUmo4d3dwcGNYZFpOcGNQQ2xjUExJbHVhY0ZMY0x4?=
 =?utf-8?B?WTVNcjVlSS9teTFmbWFsd0pnbWwxcTJGaDFUNTI0bXdTbDRLbCs1cXMvdng5?=
 =?utf-8?B?aGVvMU5ndk4vMVhNcHhvUFJNOUNNaVZDNHcwa0l4eE1nVk03bklBTEZFbVZ3?=
 =?utf-8?B?MlYyZHk0dW41OU9NVXVxSmtKMlA5ei9EemFtay9YRVdjUzNhcE1mOUc2Z09h?=
 =?utf-8?B?V3JDWU1VaXY3U0tacGtaeVNyRTRGSDdvTDRJckxiR1Y5UW5SUzlMenRoeFdQ?=
 =?utf-8?B?cFdFODFxNjZBQ0JHdmJnMzZOcjJDSTI3QlhMMGpNa3lKSk9ibENIc2hZMU1O?=
 =?utf-8?B?Q0FFaXJmb2ptd1Q5MlRoUGNCN1JoOHp6TytkeVZIeC9oNzVSUG55Uk9BMkp1?=
 =?utf-8?B?VitkM0JXWTQveU45dlY5a2ZBclBsOFU4anlmZyttaFBUQXgwVDhpQWJkUzM3?=
 =?utf-8?B?eXlRQW9uVy8rMFNsdTU5TUJXRGtxRHRJVzd6NUY3Q1d3NGpWK3lSbGdNYnZr?=
 =?utf-8?B?S1lrM0JsNjdkUktkQWJ4cFd2emQ1NGJVOGlUamhpRVc3SkdJUXNSOE9yN2ZJ?=
 =?utf-8?B?ZCtvaE91eGV4VmNQNkxTc1ZDUlJOdXhUdWx0RTRCcFM2WHA3Z3RIZldGeEZi?=
 =?utf-8?B?c3BjZnM5ajFzT1Fzejd4akRLeVFVVDFDa25ETGVPRXdvN0JtdE9rTVpGMnNU?=
 =?utf-8?B?NGZHeno4WUw4d3ZUbkJyZkNTTE0ySkNXZkw3aGxSOFNMNTQzd1dqUjRwUFFM?=
 =?utf-8?B?TXBOdzJsd2dnMlhEZk9wZUFQNDgvamlaWlBrSE4xbGU5cDByWjlUSTZ0WnJl?=
 =?utf-8?B?YnlTcmFqbUVvemxVYWhqMkNxeDBNWDJMTWRLWmlWbFFPb2ZNS2FwdmxCdnVX?=
 =?utf-8?B?VGlIRStIcUVKNVlMZm9ibkdEWmFmSjY0OFB3V0ZZNHNZWmhka3U1ZjJIeEJq?=
 =?utf-8?B?U0ZyMFoxM2ZtNzlGVjBRbmJoUURMV1NjbDAzQllHRyt5YjRjNXpBMm9jL05o?=
 =?utf-8?B?VittTWxuY1VlY1prZE9adE5UK2xZNzMrd2djM1pUanNPQm53MFB0QzE5bUVX?=
 =?utf-8?B?cnJxVHA1eVRTRmYwNDdnNzF0Tnhza1RYUjFBSENGaHJmaG1oTkVybTVaWnBo?=
 =?utf-8?B?bUZTdFRKczVqQ2NWYUJkKzZKQUtBeFRWTEdISGdGYlRuTCtNR0R1M25BQnUy?=
 =?utf-8?B?N0U4ZjVJdHJZb1RTMTF3djI2akRoQTdjYmovY1hCTUhlZjliVldtNm04cXZC?=
 =?utf-8?B?a200dFMwclFDY01ab0liM3FzZURiazhPOE96M0hRU29ZKzlrbXVrREFWRDNZ?=
 =?utf-8?B?WHp6VDV1Ny96Q281blpIV2ZqYTZFeWRVRTZiZ3lyOU10N3kvZWFWSy8zSHJ1?=
 =?utf-8?B?b1hnMldpcURYTnBZZE5qK2dReXIva050WWV1c2tXaWpHZDN4NUdkQ0VtOFNn?=
 =?utf-8?Q?CDdhfEaDvqyw3xc1MS94wUUzA6o0AhABqiSredJ?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d795f6b3-5f93-4527-67c6-08d8d80c1cdf
X-MS-Exchange-CrossTenant-AuthSource: DB8PR08MB5019.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 15:03:01.1883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q/QuY9rxrSfC0wWRzg9H1gxiZkEdCFrSvQopx0hgqn8t5N54U49PZjAYgRMeRLwXT1N6oNhMfYUCgRc9ozlK204JL7JyW6+dPwKufgDicQM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3225
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 23.02.2021 10:37, Masami Hiramatsu wrote:
> The kernel modules have .text.* subsections such as .text.unlikely.
> Since dso__process_kernel_symbol() only identify the symbols in the ".text"
> section as the text symbols and inserts it in the default dso in the map,
> the symbols in such subsections can not be found by map__find_symbol().
> 
> This adds the symbols in those subsections to the default dso in the map so
> that map__find_symbol() can find them. This solves the perf-probe issue on
> probing online module.
> 
> Without this fix, probing on a symbol in .text.unlikely fails.
>    ----
>    # perf probe -m nf_conntrack nf_l4proto_log_invalid
>    Probe point 'nf_l4proto_log_invalid' not found.
>      Error: Failed to add events.
>    ----
> 
> With this fix, it works because map__find_symbol() can find the symbol
> correctly.
>    ----
>    # perf probe -m nf_conntrack nf_l4proto_log_invalid
>    Added new event:
>      probe:nf_l4proto_log_invalid (on nf_l4proto_log_invalid in nf_conntrack)
> 
>    You can now use it in all perf tools, such as:
> 
>    	perf record -e probe:nf_l4proto_log_invalid -aR sleep 1
> 
>    ----
> 
> Reported-by: Evgenii Shatokhin <eshatokhin@virtuozzo.com>
> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>

Thanks for the fix!

It looks like it helps, at least with nf_conntrack in kernel 5.11:
---------------------
# ./perf probe -v -m nf_conntrack nf_ct_resolve_clash
probe-definition(0): nf_ct_resolve_clash
symbol:nf_ct_resolve_clash file:(null) line:0 offset:0 return:0 lazy:(null)
0 arguments
Failed to get build-id from nf_conntrack.
Cache open error: -1
Open Debuginfo file: 
/lib/modules/5.11.0-test01/kernel/net/netfilter/nf_conntrack.ko
Try to find probe point from debuginfo.
Matched function: nf_ct_resolve_clash [33616]
Probe point found: nf_ct_resolve_clash+0
Found 1 probe_trace_events.
Opening /sys/kernel/tracing//kprobe_events write=1
Opening /sys/kernel/tracing//README write=0
Writing event: p:probe/nf_ct_resolve_clash 
nf_conntrack:nf_ct_resolve_clash+0
Added new event:
   probe:nf_ct_resolve_clash (on nf_ct_resolve_clash in nf_conntrack)

You can now use it in all perf tools, such as:

         perf record -e probe:nf_ct_resolve_clash -aR sleep 1
---------------------

I guess, the patch is suitable for stable kernel branches as well.

Without the patch, the workaround you suggested earlier (using the full 
path to nf_conntrack.ko) works too.

> ---
>   tools/perf/util/symbol-elf.c |    4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
> index 6dff843fd883..0c1113236913 100644
> --- a/tools/perf/util/symbol-elf.c
> +++ b/tools/perf/util/symbol-elf.c
> @@ -985,7 +985,9 @@ static int dso__process_kernel_symbol(struct dso *dso, struct map *map,
>   	if (strcmp(section_name, (curr_dso->short_name + dso->short_name_len)) == 0)
>   		return 0;
>   
> -	if (strcmp(section_name, ".text") == 0) {
> +	/* .text and .text.* are included in the text dso */
> +	if (strncmp(section_name, ".text", 5) == 0 &&
> +	    (section_name[5] == '\0' || section_name[5] == '.')) {
>   		/*
>   		 * The initial kernel mapping is based on
>   		 * kallsyms and identity maps.  Overwrite it to
> 
> .
> 

Regards,
Evgenii
