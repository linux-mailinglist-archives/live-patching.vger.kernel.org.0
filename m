Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36DB31EF2B
	for <lists+live-patching@lfdr.de>; Thu, 18 Feb 2021 20:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhBRTE2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 18 Feb 2021 14:04:28 -0500
Received: from mail-eopbgr10136.outbound.protection.outlook.com ([40.107.1.136]:18739
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232842AbhBRRKL (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 18 Feb 2021 12:10:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F64W/NhnMJ0mu8k0AziGHJb0U4gYtsr+JgZ6JMGAFTTzt1XG+IAhGRbGxcd0XkBd3nvO+r5iqLhxKXrC2yC5+L2T5ElxhBqjJk649/bu5idCkLALTHhKgHTRA3UJWCRwDbGMH9De83Lj01Y94r61ug6lmfghJ04nTq35rqSRUo10+8uNGEAggAWTnYlLIFlA9z3qQYj/t+NZZQt4SYJY//1JZ1OeYxuFWmNv1atq8widUQ+v9+hBrdvD/+FbpuwQrZiRcWebEgFAHKmqVAUPMO2IuUYKeM33fg/bDKLNwITFO1o+lebizFIBxWwfUEjEFvxt/uNfGZNWyR+l+/5G4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8HEB6Vj3NNXYC0uH6NlgMtAzAjx6GPpoMs5wdB3pXs=;
 b=V6vu0Gr8V34MAeANroHw+yO6g/fRftjujPVkj39/XveYFLDRhWmgRZspqMe2u+4DQLr9h6gv9GwmC+R+pl4yNmMO45DV2Ee/vn+oyXxyeGrBYZwRAEhUBenkXWEGvSVO3NKfjfthN+cOVi4N1VmmYjccSpX/tUnBx3H29YSNi2CZGjeG46XuJE9/+cw6f5WDQwTuYFopyKaN3Ros9OYY+WVoGUys4eYTSDkoqOeZ2pOcTaExeOI+aQZvkLcNEtgyJdu1/Kv5/K6FavY+QMgEJDyd2g5nl4fWXozV/BeXhbK37ELr47IwYvwJdM0WmxVHqbbk2OLLXiHw2NHX7N2e4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8HEB6Vj3NNXYC0uH6NlgMtAzAjx6GPpoMs5wdB3pXs=;
 b=konP1I6p+aUNNDHRR/38341gpxmifRlB/2R6DRy8Dy+8uPBnpwv3ElbI7OM6OQ/te9T3MZDe5Sd5yl15o6JFgXMpz8aLGi2fjwlWUY/MWFHdzY+faLRo80KIjvEVyN8QyYrO5QbpBpIS29GzjhXd2pe1RjwD6J73tJLdAkXSLmE=
Authentication-Results: virtuozzo.com; dkim=none (message not signed)
 header.d=none;virtuozzo.com; dmarc=none action=none
 header.from=virtuozzo.com;
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com (2603:10a6:10:e0::21)
 by DB8PR08MB5515.eurprd08.prod.outlook.com (2603:10a6:10:11f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.28; Thu, 18 Feb
 2021 17:09:21 +0000
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::24c3:9243:1877:7631]) by DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::24c3:9243:1877:7631%2]) with mapi id 15.20.3846.042; Thu, 18 Feb 2021
 17:09:21 +0000
To:     Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Kristen Carlson Accardi <kristen@linux.intel.com>,
        live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Konstantin Khorenko <khorenko@virtuozzo.com>
From:   Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Subject: 'perf probe' and symbols from .text.<something>
Message-ID: <09257fb8-3ded-07b0-b3cc-55d5431698d8@virtuozzo.com>
Date:   Thu, 18 Feb 2021 20:09:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [85.249.47.245]
X-ClientProxiedBy: AM0PR05CA0076.eurprd05.prod.outlook.com
 (2603:10a6:208:136::16) To DB8PR08MB5019.eurprd08.prod.outlook.com
 (2603:10a6:10:e0::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.45] (85.249.47.245) by AM0PR05CA0076.eurprd05.prod.outlook.com (2603:10a6:208:136::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Thu, 18 Feb 2021 17:09:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ba3c7a6-49d9-449d-7e80-08d8d42fef17
X-MS-TrafficTypeDiagnostic: DB8PR08MB5515:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR08MB55150894191F3AD8E821E80FD9859@DB8PR08MB5515.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iuy5y+/eV7CzBduOua07m+s26OBj+Vs2itbajRQv3HM5KaYYS+VEsvEDghxDcQhHAR0x0oQnWsFMgSMZceg0wiO4WWfJYggaY5GUivwwRG6u9nGEt4jEf+v3BdjMcG3XwIjlwcZSoGgANnmPCZZbUvQxM9C4CAgqno6F+yMdkfHLgzXSUDn+CzYUaFwD1OP2bZ1/BjljxtKsKo1DFBJlyVXvSrjpVmaYSVv/+iFAp+yO0CtghLFugPE/eEiG8bd6zWLW8YSHlUcakKm8/SqX1Pu589AypdAImgKzilhfFCbOXuSMPzCH9ArBLeNWB9wsVI2+gzyCpTndWKsdacmZrIOO+WwvyuR1Tx6tXkHPYZIFZOL51jPRsWfo/GwFlW7fM4/Rl3BTl8fAmgqHdV8DST77QvnzGIeHUx6tTeTAb6phYOf28LZhSJRnLqQrHCK6hS6W54LGVWkDtsss/I3vytCweA+aA4WKoRM2VyZseG2KVgGmRJr7Y3ik5D8NQhDVsoG7KocCIvKHBGpayzYnu5ltAduckDqpaODZNXsReXBkEwFtsi3pzENi5LkkuIuIjBLg1tPfMzSs08Xg9uJ5oSYENuLAesPGJbEMoYyZTY62QYwLEJnqwEwH/hE+bluA/1K/SfAly5EsfQl2lJEnk4SX8FY0ED5s/gMHycVAtuJphj78260aaNmAouuEkCsp4tRzkRQUIqQkeH+7J5XNYQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5019.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39850400004)(376002)(396003)(366004)(4326008)(107886003)(52116002)(478600001)(8936002)(31686004)(186003)(110136005)(8676002)(16576012)(54906003)(66946007)(66556008)(956004)(66476007)(16526019)(2616005)(6486002)(86362001)(31696002)(5660300002)(2906002)(36756003)(26005)(316002)(6666004)(142923001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cTNidkt5YmVpWkhPcCtUK1U4OHFiVXo3SkR2RzhPRnJtcVhFSGZ0R1R6OUVj?=
 =?utf-8?B?MmNXZTJObTZEZ0N4dDhSb3pmL1RDaWttMG5VcFR4NHFhYlJ5YnFzTTlrZGVN?=
 =?utf-8?B?UU9GbFQ2Z3c3dEUvK1J3bDZuQWx2RVRMdTBqOUlVZ3diYUdOdStrRklZdEMz?=
 =?utf-8?B?VCtRVW92TTlJUE1VY0F4eS8wR21ZTW0zTjJLOHk0UmlWc0Uzb2hseGR3MlIv?=
 =?utf-8?B?d0dsUndGTng4c01qYnpiSmpTWkpWK2tOTGlMdnk4bi9GdUhtMXdRNlNLSUlv?=
 =?utf-8?B?YkZ1U1ZKcWxiRlNVRC9tMEdxY2hKVmU2WWZFYkc5UGxrTFlkU1J5K1NuaGxZ?=
 =?utf-8?B?V0w0eHhndERZUjJFTndtRTVNTFRTcERZTmtBUWlzRlQzYnZFNkdrZGg4SlhB?=
 =?utf-8?B?M0xJbnNmT0dJMWc4VFlPaTV6OXlHYmQ1UTFCU2FXMXpWL0FZSTVYVnpFODVh?=
 =?utf-8?B?eG9CcGE0SXQ3NTFaQzRIZlBsVmZtV2x4cjA5N25sQjUyR3gxVjB3KzlGSkk4?=
 =?utf-8?B?R0VUZzZBSnU2Z3MzY0pPVG0wZXBpVlFJS0pHa09sMWpkRk81ZU96cC9EVHZx?=
 =?utf-8?B?bUY3U2xkUmxQSWdmUmI2b2VVb1RuWE04aVlHTUhKUk5XbjJDNnl6clFHQ25t?=
 =?utf-8?B?TGQ3ZHdTckF6Sm91dis2cFJHWDI1VTRFSlM3UWRHZ0JBN2R0RDE0YUw4L0ZL?=
 =?utf-8?B?aHBBSUpsaHllRk13dGJGMiszTHBXNVpjWGxzbEFOMm5hMXNOclFpRW5JYnd6?=
 =?utf-8?B?WFRwckxvRFRkeDhkZjRaR2tWOGdLenppS1pDV0draHpJd1hXcnVSU0E0RFZ4?=
 =?utf-8?B?cnQvMEI2c2wxMUF5NFRvb2dVOG5xdDhIYVc5anI2bkdrZWM0Tm94SlBaNDR6?=
 =?utf-8?B?ZVpPVWlLRUZHSEtUZjJmUmNwMmJvYkQ0Yzc5QkRweXBRZGxtQWE0UTdNWHZy?=
 =?utf-8?B?c0ZlQ3BVVTYxNmVKdW94N1Z2RWZpZkNJNFRTamNIK1REelV5QXVSWkptc0Uz?=
 =?utf-8?B?cUFCNVlmK3JZazRUdzBrK3cxRmhOUFpjNjNCM1h6NDYxbXFIOU1iS09Gd0RW?=
 =?utf-8?B?YW9INUxxbm1wSWZGQlVvK3NkNzNwUXY1bytLcjQvQXRCT1NlcElIQmthNjVT?=
 =?utf-8?B?SnBkZ2JDck9HME1WRSt4cEljVXhndHREckR1OUZrVE1GOVVlOERnRVR5Z2ty?=
 =?utf-8?B?TmRSQXhxaTNSNXcxZytwS1UxY01xbHhqRm5ncTQwWHp0Q3Y0RUxraEFzbGpz?=
 =?utf-8?B?Zit5WjhwelZLNlZjSmZLcERFYlpNSnNxSDNqYWpUR0tFWEprZTlJUTJucXpR?=
 =?utf-8?B?OHFqZ0ZjelFscEUwK2RNVnZFT2lndHY0WXUxeFhYc0VvTkxiTTFKY0lmZld2?=
 =?utf-8?B?bzRZVlBCc3ZLVjd3ZlVBd05OSzhEcmVCNlJYK3hqOEgvWUY0Z0EyUTlPZ1J6?=
 =?utf-8?B?Z0lqTXlTRDBZc01vSW8vN0s5eEFQZVRHRDVpeVRPLzVaWXk5dkx4V3k3TDR1?=
 =?utf-8?B?Y3BMNmhzT0RFSFdTWWEzazRUOFVJaWlIV0h0UEZBc2hWN3B3eDNiZG9HRFdX?=
 =?utf-8?B?a2o5L1ZkLy9xRVhjL3FVeWRwYzZha3R5aG9tWk54NW5HVVpjVEZNd2pyM1ox?=
 =?utf-8?B?YXQ1dFRsayttdlNqbm1TNXF0dW5nNksvSW9Ja1FHWmp1TWlVbnR1MWdvSzhI?=
 =?utf-8?B?SmxRQjROQWZjdWtyV280QzJlSSt3SExiZCtjVGQ4M1ZnWUhSRFpicGdPcnFh?=
 =?utf-8?Q?pfCctCGbyVEjvUnW/+zlZHhjpN6ZkFPjEBGjV0V?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ba3c7a6-49d9-449d-7e80-08d8d42fef17
X-MS-Exchange-CrossTenant-AuthSource: DB8PR08MB5019.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2021 17:09:21.3870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zsdr9SWrNE5NRVEbvBRIkuxH7dj72rHMx0nsicdP+SaVW6ouvSj/9XLe78hfaQ/x85j7Ho4HCkKnug75y+IcLFvP+m5jRapdiIgbErFvKZs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5515
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

It seems, 'perf probe' can only see functions from .text section in the 
kernel modules, but not from .text.unlikely or other .text.* sections.

For example, with kernel 5.11 and nf_conntrack.ko with debug info, 'perf 
probe' succeeds for nf_conntrack_attach() from .text and fails for 
nf_ct_resolve_clash() from .text.unlikely:

------------
# perf probe -v -m nf_conntrack nf_ct_resolve_clash
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
Post processing failed or all events are skipped. (-2)
Probe point 'nf_ct_resolve_clash' not found.
   Error: Failed to add events. Reason: No such file or directory (Code: -2)

# perf probe -v -m nf_conntrack nf_conntrack_attach
probe-definition(0): nf_conntrack_attach
symbol:nf_conntrack_attach file:(null) line:0 offset:0 return:0 lazy:(null)
0 arguments
Failed to get build-id from nf_conntrack.
Cache open error: -1
Open Debuginfo file: 
/lib/modules/5.11.0-test01/kernel/net/netfilter/nf_conntrack.ko
Try to find probe point from debuginfo.
Matched function: nf_conntrack_attach [2c8c3]
Probe point found: nf_conntrack_attach+0
Found 1 probe_trace_events.
Opening /sys/kernel/tracing//kprobe_events write=1
Opening /sys/kernel/tracing//README write=0
Writing event: p:probe/nf_conntrack_attach 
nf_conntrack:nf_conntrack_attach+0
Added new event:
   probe:nf_conntrack_attach (on nf_conntrack_attach in nf_conntrack)
------------

Is there a way to allow probing of functions in .text.<something> ?

Of course, one could place probes using absolute addresses of the 
functions but that would be less convenient.

This also affects many livepatch modules where the kernel code can be 
compiled with -ffunction-sections and each function may end up in a 
separate section .text.<function_name>. 'perf probe' cannot be used 
there, except with the absolute addresses.

Moreover, if FGKASLR patches are merged 
(https://lwn.net/Articles/832434/) and the kernel is built with FGKASLR 
enabled, -ffunction-sections will be used too. 'perf probe' will be 
unable to see the kernel functions then.

Regards,
Evgenii
