Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E4B23A387
	for <lists+live-patching@lfdr.de>; Mon,  3 Aug 2020 13:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbgHCLsK (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Aug 2020 07:48:10 -0400
Received: from mail-eopbgr20102.outbound.protection.outlook.com ([40.107.2.102]:35446
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726478AbgHCLj6 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Aug 2020 07:39:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWZTwN/wHlDZtC8NVHY6ToAj1ssyvLWzzZHtQxV8oLKtjXljXoiBgu0copdB7RXw8706zRC0BWcZ2hPDh9UMIX3rup11xLE1Z6Z7xZRvRmDmFxIzWjv10poXl9fGNIlGXzwyY7KBlSJecYcsg+Q2OlFzRrgSlw/e2ig4/nkqHpU0JowT8GJZC0wZH5HIgu4ez+BFkZ/fetK4EnDMI3clvHhDdc8JS3+xPI8v8XTjQm9hQBDjIW42hVRSJ+J17/MfzxrGAj6F/gtahlniZ9sXO0VBu7QfAP7p9wl0xd9CaEZq7v2aIMDE0yDD69haMoo+3dpYKbK0Jb2Mc+oIb1C/Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ljp5JyGi7M+gL51naH3VD0H9kZsTyUyAvcDR2m40Y7Q=;
 b=KS7U1bIJp7NxXDWl7zu2wFG9E9EMQOU1Wj9SxcP8MnewsvGj8HnjHNe17+yBa15A03xu4KOXD4TAsKcvaZu+plxRSCyjPVRyxwRuog5mDKAh2ZOz2Eu9cgpnzUG/E7leqGrqe2dWkUmKVpdgIYZfGwgHmczzShbjs1dBmtZBp0LVZ7RJhQtu0mezyvbE/CpCiGN840Mw4ZA5HnG4HrBBOFmjl9AOCLQvPr2Kvsc+ot9cHCRIloJtBRiFEcCu5N1g6JCaMTV5gaRaFvhdp9slSPHzyQiG4yR/sdKaXMkJ2/HpcSBS1lt6UBhESaxaYAbXagvwaeb5HsYh30iRgSTVuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ljp5JyGi7M+gL51naH3VD0H9kZsTyUyAvcDR2m40Y7Q=;
 b=he33lcPSEljoGyS27S8gDi916bS4Dph9vAw+LYSwbUy4Esb9Dqej7vD4o2S6GBPen9u2e9wIb/35XpquyAFN3pRE+9D7YY4rsWUteqAV2ZlcHjpGyaWqaAUj5Kr/i2aOp372QyjbaSOtQbYrdl0BLAIvNHE4Ng64lU7qiwKAYQk=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=virtuozzo.com;
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com (2603:10a6:10:e0::21)
 by DB7PR08MB3786.eurprd08.prod.outlook.com (2603:10a6:10:79::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Mon, 3 Aug
 2020 11:39:35 +0000
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::b3:b2de:237f:587a]) by DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::b3:b2de:237f:587a%3]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 11:39:34 +0000
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
To:     Kristen Carlson Accardi <kristen@linux.intel.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, keescook@chromium.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        arjan@linux.intel.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        rick.p.edgecombe@intel.com, live-patching@vger.kernel.org,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
From:   Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Message-ID: <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
Date:   Mon, 3 Aug 2020 14:39:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0121.eurprd04.prod.outlook.com
 (2603:10a6:208:55::26) To DB8PR08MB5019.eurprd08.prod.outlook.com
 (2603:10a6:10:e0::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.45] (95.27.164.21) by AM0PR04CA0121.eurprd04.prod.outlook.com (2603:10a6:208:55::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Mon, 3 Aug 2020 11:39:33 +0000
X-Originating-IP: [95.27.164.21]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7b25dfc-36e2-49a5-c836-08d837a1e50c
X-MS-TrafficTypeDiagnostic: DB7PR08MB3786:
X-Microsoft-Antispam-PRVS: <DB7PR08MB3786448D919F6A507296877CD94D0@DB7PR08MB3786.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QrrUTbNpSspdQ9wCgUsdMeID3KSUVdTTlepQ+d2g1/UTMTXsy7SwekizMntsCOz3En1EwYaEbN8FTbiSzkQBq8JYbzmsj17qjEUBmE3sqbP6q72l/5eyiZbSfCkBG9EUoO6NKyoPLPIQ43tFNTfp4W2xMsrKF5wAlMcq25hywvzwadwXhjZn7c8tp+h97sFDQ/np8PHY3DOH8sixpe42hMogDhedXDI2S1l7xKr22lXnXndVotQHwyMYx/4wtbCTdLc5ZRNIBMiCki+9l5EeOSbS8NBEsCx5p+MFvh79bIkz2206NQiuVHDwiLksYREV7vtUEuc4djgBudrrVrjuhZxLNsy/Ie4sPHppUt+IJPLvWPTpCsu0LP3vDoxcyh4arwrG8YbA/zuKibhkfaiYeLhL6jP5beBoI89lnumNQueMkal/GBC1bsu2uDRWjmliuQWG69O2NKLPqShuEXnyNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5019.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(39840400004)(136003)(396003)(31696002)(54906003)(16576012)(86362001)(316002)(186003)(52116002)(16526019)(6486002)(5660300002)(6916009)(8936002)(966005)(66946007)(66556008)(66476007)(8676002)(31686004)(26005)(956004)(2616005)(83380400001)(478600001)(7416002)(2906002)(4326008)(36756003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 3BOIXmR9MFqjNgCHyx8wiFimPbET6srlu28jt5LHPcw0VJ9NYdWm/UqFhP18tQc025/uIqkzC2Cl2GIiHq7hpweqA3aGnwK++PaRLJcRK9+Pbh01t/kluUIYZuPH80I0Bp+0fMPp8qmKLAwuo5L9WIErRfE1LV0Zwmp2TPQVlZUzB/mF6cs92BPV1AOzlVgHMgs5GGUEEvFlWy9KNq7gXTNqf/JcttGUdAvHXOuBkKndoGEYL6Pju6pdEXScwOdWS9urZ9h319Uh3jqVWJIUStgggiB7LqQNmmVuEsoBLQXpJbQbaWxOr9g+HCPbw/xv0345n0M4O0SBNyF8u20oDuMbblUmzUiQNCqcWBRQmf7RE0F+UwPUdFU14V1H3kPmUpsF/+0XSbqk6hhWecjVxVfr9rDQfcw1NrZNCwBtiOX6Qn9gk9MHWz/rtth5msrkft0XDmLCL7gWVtNH1t2cGtZFjLlrzLGfmS9Ipy3ggBWV9cLPRmHIPi9u9t/yPzPkemodFMjgokvEQewqzp5eivYEqX9Qry/NwzA9eZEG57bdfljuQnRE6oj5GeXvm4tA/DrQJduH/k+iqalZ5EvFw3XQCPDxDsx5+WylHUAiV1tp1TEuazc0bWhSTAhSYrmmLsE/8b+01Sr2jC/1pQQP7Q==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b25dfc-36e2-49a5-c836-08d837a1e50c
X-MS-Exchange-CrossTenant-AuthSource: DB8PR08MB5019.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 11:39:34.8005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3TX0iS0WcVmUREVe5zYgWBRYoVr8ExpRgcf1bPMCvg+JFBbQjC0sNzjKnd4iWAE/Uw3GVBjJkmQy3hqLDdIgzkkIEN41356DAsUr//nxkNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3786
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

> On Fri, 17 Jul 2020, Kristen Carlson Accardi wrote:
> 
>> Function Granular Kernel Address Space Layout Randomization (fgkaslr)
>> ---------------------------------------------------------------------
>>
>> This patch set is an implementation of finer grained kernel address space
>> randomization. It rearranges your kernel code at load time
>> on a per-function level granularity, with only around a second added to
>> boot time.
> 
> [...]

>> Modules
>> -------
>> Modules are randomized similarly to the rest of the kernel by shuffling
>> the sections at load time prior to moving them into memory. The module must
>> also have been build with the -ffunction-sections compiler option.

It seems, a couple more adjustments are needed in the module loader code.

With function granular KASLR, modules will have lots of ELF sections due 
to -ffunction-sections.
On my x86_64 system with kernel 5.8-rc7 with FG KASLR patches, for 
example, xfs.ko has 4849 ELF sections total, 2428 of these are loaded 
and shown in /sys/module/xfs/sections/.

There are at least 2 places where high-order memory allocations might 
happen during module loading. Such allocations may fail if memory is 
fragmented, while physically contiguous memory areas are not really 
needed there. I suggest to switch to kvmalloc/kvfree there.

1. kernel/module.c, randomize_text():
	Elf_Shdr **text_list;
	...
	int max_sections = info->hdr->e_shnum;
	...
	text_list = kmalloc_array(max_sections, sizeof(*text_list), GFP_KERNEL);

The size of the allocated memory area is (8 * total_number_of_sections), 
if I understand it right, which is 38792 for xfs.ko, a 4th order allocation.

2. kernel/module.c, mod_sysfs_setup() => add_sect_attrs().

This allocation can be larger than the first one.

We found this issue with livepatch modules some time ago (these modules 
are already built with -ffunction-sections) [1], but, with FG KASLR, it 
affects all kernel modules. Large ones like xfs.ko, btrfs.ko, etc., 
could suffer the most from it.

When a module is loaded sysfs attributes are created for its ELF 
sections (visible as /sys/module/<module_name>/sections/*). and contain 
the start addresses of these ELF sections. A single memory chunk is 
allocated
for all these:

         size[0] = ALIGN(sizeof(*sect_attrs)
                         + nloaded * sizeof(sect_attrs->attrs[0]),
                         sizeof(sect_attrs->grp.attrs[0]));
         size[1] = (nloaded + 1) * sizeof(sect_attrs->grp.attrs[0]);
         sect_attrs = kzalloc(size[0] + size[1], GFP_KERNEL);

'nloaded' is the number of loaded ELF section in the module.

For the kernel 5.8-rc7 on my system, the total size is 56 + 72 * 
nloaded, which is 174872 for xfs.ko, 43 pages, 6th order allocation.

I enabled 'mm_page_alloc' tracepoint with filter 'order > 3' to confirm 
the issue and, indeed, got these two allocations when modprobe'ing xfs:
----------------------------
/sys/kernel/debug/tracing/trace:
         modprobe-1509  <...>: mm_page_alloc: <...> order=4 
migratetype=0 gfp_flags=GFP_KERNEL|__GFP_COMP
         modprobe-1509  <stack trace>
		=> __alloc_pages_nodemask
		=> alloc_pages_current
		=> kmalloc_order
		=> kmalloc_order_trace
		=> __kmalloc
		=> load_module

         modprobe-1509  <...>: mm_page_alloc: <...> order=6 
migratetype=0 gfp_flags=GFP_KERNEL|__GFP_COMP|__GFP_ZERO
         modprobe-1509  <stack trace>
		=> __alloc_pages_nodemask
		=> alloc_pages_current
		=> kmalloc_order
		=> kmalloc_order_trace
		=> __kmalloc
		=> mod_sysfs_setup
		=> load_module
----------------------------

I suppose, something like this can be used as workaround:

* for randomize_text():
-----------
diff --git a/kernel/module.c b/kernel/module.c
index 0f4f4e567a42..a2473db1d0a3 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2433,7 +2433,7 @@ static void randomize_text(struct module *mod, 
struct load_info *info)
  	if (sec == 0)
  		return;

-	text_list = kmalloc_array(max_sections, sizeof(*text_list), GFP_KERNEL);
+	text_list = kvmalloc_array(max_sections, sizeof(*text_list), GFP_KERNEL);
  	if (!text_list)
  		return;

@@ -2466,7 +2466,7 @@ static void randomize_text(struct module *mod, 
struct load_info *info)
  		shdr->sh_entsize = get_offset(mod, &size, shdr, 0);
  	}

-	kfree(text_list);
+	kvfree(text_list);
  }

  /* Lay out the SHF_ALLOC sections in a way not dissimilar to how ld

-----------

* for add_sect_attrs():
-----------
diff --git a/kernel/module.c b/kernel/module.c
index 0f4f4e567a42..a2473db1d0a3 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1541,7 +1541,7 @@ static void free_sect_attrs(struct 
module_sect_attrs *sect_attrs)

  	for (section = 0; section < sect_attrs->nsections; section++)
  		kfree(sect_attrs->attrs[section].battr.attr.name);
-	kfree(sect_attrs);
+	kvfree(sect_attrs);
  }

  static void add_sect_attrs(struct module *mod, const struct load_info 
*info)
@@ -1558,7 +1558,7 @@ static void add_sect_attrs(struct module *mod, 
const struct load_info *info)
  	size[0] = ALIGN(struct_size(sect_attrs, attrs, nloaded),
  			sizeof(sect_attrs->grp.bin_attrs[0]));
  	size[1] = (nloaded + 1) * sizeof(sect_attrs->grp.bin_attrs[0]);
-	sect_attrs = kzalloc(size[0] + size[1], GFP_KERNEL);
+	sect_attrs = kvzalloc(size[0] + size[1], GFP_KERNEL);
  	if (sect_attrs == NULL)
  		return;

-----------

[1] https://github.com/dynup/kpatch/pull/1131

Regards,
Evgenii
