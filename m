Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71A9E32380F
	for <lists+live-patching@lfdr.de>; Wed, 24 Feb 2021 08:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbhBXHsV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 24 Feb 2021 02:48:21 -0500
Received: from mail-eopbgr130090.outbound.protection.outlook.com ([40.107.13.90]:5952
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233594AbhBXHsT (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 24 Feb 2021 02:48:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T2llII49podHStJLFT1ZxXNWz7vJ9g4yIxPNQ0dVPIRzFVh/0vVGeXRrRVfPrqrKPTDVuEp+xPB9u+wNDIie7nrBVJjZ/Uw5J4i9FKAjnvxspMqvtXA0ClkrumCrT0ai0GT0+eluV0XHUlFoknIVLBgwHfSBNoUrH+xD5yLrt58qKvTnDldr0RudbB0AvKyYNqdDFUQ/8qOm4e+m308NXJkxAf45alRR7L0U6pnJLKEcycF0gGWQ2VJt+qEfSPSIvlqaROKcX70vXSPQC+FQ3M5X48j2Q8rHAXBusmr/LFg3OwIY5AN+QFMwPiwiO3K/EdmFhYXHX7Xm+P8CKdiuow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Grl/7XQzh+W6Y9B+Oqm6D1tUARaxHlam2jKFk3MXnRA=;
 b=UCkOwN9qgIRc7co+jfTtGwMKP4EM9iGA7glGSb9NJM0RKUywXr04A8IqtL2CfUBB2n/h3QG/xFuoGIskZaM/6xZ/lt+KhaPfOUfkgR85h1kbvFDuHcAfpKw8nkSQ0doCNZHzigATEDyyM+QIUwSX7qV6IvDPBSyfPuK33SiTCu6wOmveK4mMPdGCvlo9b4FqTXOf6kXny1I7QOep0KQjDEea/9ld2jvtBzs+ALPghDSvWLdjkpB8ADeYDj0DnblD5p1WMvmkMXkiNFRTwl3Ajr4hgdTWCI+DDjclsdXJov7uUwePghuKzw25Y2BAGfyozVji3MoGT3S35qITVXFavg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Grl/7XQzh+W6Y9B+Oqm6D1tUARaxHlam2jKFk3MXnRA=;
 b=wmZTJ977PA9ij1o+R71PIlNV7FD/jJX/2oPMCqCeruZv9GpnlsjyH3m/T5C+cSBj0nFES6b73/7njPe/Bq7zSv1bCm9s49HrNzICemyKJIwsUMyg1965k29Ei1P/k/J33PAWa2+0SPuxqMFE7zgu/8VC989+7nROKrJoMlhkj/c=
Authentication-Results: virtuozzo.com; dkim=none (message not signed)
 header.d=none;virtuozzo.com; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com (2603:10a6:10:e0::21)
 by DB7PR08MB3577.eurprd08.prod.outlook.com (2603:10a6:10:4f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.29; Wed, 24 Feb
 2021 07:47:25 +0000
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::24c3:9243:1877:7631]) by DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::24c3:9243:1877:7631%2]) with mapi id 15.20.3868.031; Wed, 24 Feb 2021
 07:47:24 +0000
Subject: Re: [PATCH] perf-probe: dso: Add symbols in .text.* subsections to
 text symbol map in kenrel modules
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Konstantin Khorenko <khorenko@virtuozzo.com>
References: <20210223000508.cab3cddaa3a3790525f49247@kernel.org>
 <161406587251.969784.5469149622544499077.stgit@devnote2>
 <00abcbd4-e2c2-a699-8eb5-f8804035b46e@virtuozzo.com>
 <YDVhgENpshYqDqiO@kernel.org>
From:   Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Message-ID: <49a63bb9-8f0d-755f-cfec-6ebe58ac9519@virtuozzo.com>
Date:   Wed, 24 Feb 2021 10:47:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <YDVhgENpshYqDqiO@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [85.249.47.245]
X-ClientProxiedBy: AM0PR08CA0017.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::30) To DB8PR08MB5019.eurprd08.prod.outlook.com
 (2603:10a6:10:e0::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.45] (85.249.47.245) by AM0PR08CA0017.eurprd08.prod.outlook.com (2603:10a6:208:d2::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 24 Feb 2021 07:47:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a9bc9d4-e949-42bf-fe23-08d8d8986ce4
X-MS-TrafficTypeDiagnostic: DB7PR08MB3577:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB3577B85C34DDAD5CC966351BD99F9@DB7PR08MB3577.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pk3AI6p2xrEodI/QXQ6chijlKFRyk3CfEyN6ipBNY6rlxF2lLc/rn/IH4lgf4jzWMW0pTw/a9M40r2A5cu24wlb0n016lY/JAViAn3ssexc9uKrAln/KmcQR18IqqC88gvhrALLM1uBC7P8IT71HGzFISek9zT8YKoVLaiG+f4WS0TrQBIhfGLUvPkVvLzlPn2FlDJ0SA4LYKeNGPFc7LvdS6R8IpCPuq2ld5F2S8jRIEfjx/4huu3kkB/7oA8Ic68h8FkYJl1N/C9L1YzyXSTQsDlpHmCwGxHjWWOTct+nFlR+xdsO5JvGZmH5j38oR3eOQ5EG5lj3pAaYmvdn+Ix7fFXVnJrjgphcwZghSZAfsK2iztUK8NXqNNFQBbORgz7wm5wHLWorfp9gIhGQoFODEh0G9u8Z1BJT+orC1EVW/1lFC83Zw0gFC1JnCwVIH8Na1vcdKUkmSUPMWHYR0XVJbehKxVXElRkgZ75PvTvYlG1Lcei2XhmMAli/5FpCHsv2ZCxz05CXkg3J8f7AS94elFmGGZiirVg0f/c6peplWqKloOMdZ+dzfA59VeUpHwo6DIXwC+I6tKBbZDoPjgarZQxe7ozbJTyp42jiGr+UFFzk7ZL5wQHwKnovlYXVWBZpG3Kz7TjMnIyLbkJ22Hg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5019.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(346002)(39830400003)(2906002)(83380400001)(6486002)(8676002)(66946007)(26005)(8936002)(31686004)(16576012)(16526019)(316002)(36756003)(66556008)(31696002)(54906003)(5660300002)(66476007)(107886003)(86362001)(186003)(53546011)(956004)(2616005)(6916009)(4326008)(52116002)(478600001)(142923001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b005ZG1mbU1vWm10emE1RnFBV1dVQTlkQzYwUkI0OG9OdjJoUFVZWGJUMzFj?=
 =?utf-8?B?NWtaREwvQ0NjRDBwcjNQVjZTbFUvNU5oajcrSmVqTW8rSVdMWkNvK0hnS2Uv?=
 =?utf-8?B?R0YyWWZ2ckdRSWZGR0xCWUpOd2M0S1hpNzAxWm81VWJuSjRxUFNPblRiRDhk?=
 =?utf-8?B?bGx1WWRNdWtONTRudk5HQkJENWNQSDlFVDFWdFBlYVM4akRBMERqZ25aOE5j?=
 =?utf-8?B?RDdiSXhGdndaT3QyeitHbnV1cGRCbkp0SkYxbVgxUytydXVlanF2T09xMkQr?=
 =?utf-8?B?c0Vwb2RieU1TdGtDTFBOa2FRU0VZd2VpK3FKd2FWQ0VNci9mZ3BvalNSL3Zl?=
 =?utf-8?B?QnJXckJRY3IwUUMzUE0wdVNQSDNiMnhnQzFRV3VZZzYrN3pRR24zT0h1RVNt?=
 =?utf-8?B?Y0x4bzYzaUJ0cUU5elhuVGxZdVphMDF3NGF2VUxNdlJwQUJ1dDM2MGhkQ080?=
 =?utf-8?B?R3JsOS95Zmw1ZUEvei9aWkEzcmlKY29rZVJESks3SzdnTllLa3gzMXNUZmE0?=
 =?utf-8?B?VjZBOHhUZjZEcHk5V214MzV6S1h5cDExZTlWdTZkUTJ4T3hGY0dpaVBTbW9P?=
 =?utf-8?B?dzhDdjdmSkFTY0xpOWkyNWtwdHg0TXduaFkwLzBBZnVRYUg1ZnJSdWtnM1Jt?=
 =?utf-8?B?OUpsVzRKcytubEVsZ2IxaHAreWYrdDMzSWR0QzlmMjc0ZFNzVk5VazJKSC9o?=
 =?utf-8?B?NnZGVE9iRENRMlZLVi9PdkM2bVBvMG9ZMk9LdSs3RlVSZGN4Q1N1ZFE3UDhS?=
 =?utf-8?B?OUpKdDhwOFVRZDVQZzlCcXZtYUtsV01NdW1wUk1UdDFsZitZY252UXpkSmlL?=
 =?utf-8?B?ejN5aHdISGpBU0xDWE1DQ3Q4aTFSTFRvajRBTmZHOHZacHpsWWpWWlQ3M2Z5?=
 =?utf-8?B?bXFmamtUK1huYXhEOVl0OWFlbjZ2ZEdpR0l2ZmlRdVhYcDkyMkxZbndRcGht?=
 =?utf-8?B?Y3FaR3F5UWNSN2JyeUV4NGVBNExuMGxZTFUxSWlOU0ttNU9wYUVGenlFbUtm?=
 =?utf-8?B?aGp2T0JUL0sxRGwvcWZhQUhlYzZZemUwTDRsUkMxNUMwTXF6YVR3SkhXenBM?=
 =?utf-8?B?bWw1dHlaRkFWMENaMG5QYlJuUWF5OTBzRmlhb2lKcnVWSXRBaVVNcXFsMndE?=
 =?utf-8?B?cmlSM1ZZQ2ZBLzRiY3E4K3h6YStHTERsNnUwVklxVERzalQ2WVdkN3Z2NDdr?=
 =?utf-8?B?aU9CVkR4MXQ1bldHWVhtaGhvZ1FGQ3loN1VoYSt3NmVUZjBRNlI3Z2dXcWxw?=
 =?utf-8?B?cklMa21DaWIyYldHMGlmZEVyMFdnc0cyUXVNdThxelVSekN6L0hSS0RZWnph?=
 =?utf-8?B?bDcxYTVQWmdvN2QzbzA5eUhHMDhqZ3MzT2JZWDdvcEZ1VGtRbkxHZkRwUEg1?=
 =?utf-8?B?KzFJQWdSVXYvSUtDbmtLUDNxTlcxTzJSTTB3b29mZXQyME1GZUZpYmhlUHgw?=
 =?utf-8?B?cFo5UGNHQ1BUdml2anNIcVJYcStLeUtRdmFLUklqcm8zY0phWmY2U1lKd0JN?=
 =?utf-8?B?NWtKWWZMc3hOUnJXV1R0K2ZuMXBOS2lkdVhuNmFMUnFkY0IyWi9MVFFpcHZG?=
 =?utf-8?B?UHNFWmJDbXpEYk1BSDBiL2xqWUVIRVpSTHJ2MjJjY25EeVdQazcwSlN1aURm?=
 =?utf-8?B?c1R2ZTU1RmRjaFFpTmVWd1Q5VkM3RUNJNFFrZTJ5Y2NXYUJ0ZXVQcTVVR2tV?=
 =?utf-8?B?REtDOTFpSmF2SysrNU1HR3hzeTYvcmNQTXJQR1g0UytqQ0NyOFVnZlJhcWpU?=
 =?utf-8?Q?/cLn2fYbKHYFzPzOkJ+otu9HGy16of5r1FHI85y?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a9bc9d4-e949-42bf-fe23-08d8d8986ce4
X-MS-Exchange-CrossTenant-AuthSource: DB8PR08MB5019.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 07:47:24.8359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1S4IJnGXya1RdVn8GfPRlhDDC4l31wH5lwgaEYCAoYzlbhSZNDA/NVHPlnpI3KeONK+MRbQ2iW74yISI3b3fAvpAq/BIoQ6b+iMKoT8MdpE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3577
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 23.02.2021 23:11, Arnaldo Carvalho de Melo wrote:
> Em Tue, Feb 23, 2021 at 06:02:58PM +0300, Evgenii Shatokhin escreveu:
>> On 23.02.2021 10:37, Masami Hiramatsu wrote:
>>> The kernel modules have .text.* subsections such as .text.unlikely.
>>> Since dso__process_kernel_symbol() only identify the symbols in the ".text"
>>> section as the text symbols and inserts it in the default dso in the map,
>>> the symbols in such subsections can not be found by map__find_symbol().
>>>
>>> This adds the symbols in those subsections to the default dso in the map so
>>> that map__find_symbol() can find them. This solves the perf-probe issue on
>>> probing online module.
>>>
>>> Without this fix, probing on a symbol in .text.unlikely fails.
>>>     ----
>>>     # perf probe -m nf_conntrack nf_l4proto_log_invalid
>>>     Probe point 'nf_l4proto_log_invalid' not found.
>>>       Error: Failed to add events.
>>>     ----
>>>
>>> With this fix, it works because map__find_symbol() can find the symbol
>>> correctly.
>>>     ----
>>>     # perf probe -m nf_conntrack nf_l4proto_log_invalid
>>>     Added new event:
>>>       probe:nf_l4proto_log_invalid (on nf_l4proto_log_invalid in nf_conntrack)
>>>
>>>     You can now use it in all perf tools, such as:
>>>
>>>     	perf record -e probe:nf_l4proto_log_invalid -aR sleep 1
>>>
>>>     ----
>>>
>>> Reported-by: Evgenii Shatokhin <eshatokhin@virtuozzo.com>
>>> Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
>>
>> Thanks for the fix!
>>
>> It looks like it helps, at least with nf_conntrack in kernel 5.11:
> 
> So I'm taking this as you providing a:
> 
> Tested-by: Evgenii Shatokhin <eshatokhin@virtuozzo.com>
> 
> ok?

Sure, thanks!

> 
> - Arnaldo
> 
>> ---------------------
>> # ./perf probe -v -m nf_conntrack nf_ct_resolve_clash
>> probe-definition(0): nf_ct_resolve_clash
>> symbol:nf_ct_resolve_clash file:(null) line:0 offset:0 return:0 lazy:(null)
>> 0 arguments
>> Failed to get build-id from nf_conntrack.
>> Cache open error: -1
>> Open Debuginfo file:
>> /lib/modules/5.11.0-test01/kernel/net/netfilter/nf_conntrack.ko
>> Try to find probe point from debuginfo.
>> Matched function: nf_ct_resolve_clash [33616]
>> Probe point found: nf_ct_resolve_clash+0
>> Found 1 probe_trace_events.
>> Opening /sys/kernel/tracing//kprobe_events write=1
>> Opening /sys/kernel/tracing//README write=0
>> Writing event: p:probe/nf_ct_resolve_clash
>> nf_conntrack:nf_ct_resolve_clash+0
>> Added new event:
>>    probe:nf_ct_resolve_clash (on nf_ct_resolve_clash in nf_conntrack)
>>
>> You can now use it in all perf tools, such as:
>>
>>          perf record -e probe:nf_ct_resolve_clash -aR sleep 1
>> ---------------------
>>
>> I guess, the patch is suitable for stable kernel branches as well.
>>
>> Without the patch, the workaround you suggested earlier (using the full path
>> to nf_conntrack.ko) works too.
>>
>>> ---
>>>    tools/perf/util/symbol-elf.c |    4 +++-
>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
>>> index 6dff843fd883..0c1113236913 100644
>>> --- a/tools/perf/util/symbol-elf.c
>>> +++ b/tools/perf/util/symbol-elf.c
>>> @@ -985,7 +985,9 @@ static int dso__process_kernel_symbol(struct dso *dso, struct map *map,
>>>    	if (strcmp(section_name, (curr_dso->short_name + dso->short_name_len)) == 0)
>>>    		return 0;
>>> -	if (strcmp(section_name, ".text") == 0) {
>>> +	/* .text and .text.* are included in the text dso */
>>> +	if (strncmp(section_name, ".text", 5) == 0 &&
>>> +	    (section_name[5] == '\0' || section_name[5] == '.')) {
>>>    		/*
>>>    		 * The initial kernel mapping is based on
>>>    		 * kallsyms and identity maps.  Overwrite it to
>>>
>>> .
>>>
>>
>> Regards,
>> Evgenii
> 

