Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6A928132D
	for <lists+live-patching@lfdr.de>; Fri,  2 Oct 2020 14:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgJBMw2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 2 Oct 2020 08:52:28 -0400
Received: from mail-eopbgr10135.outbound.protection.outlook.com ([40.107.1.135]:27457
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726017AbgJBMw2 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 2 Oct 2020 08:52:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X3rR+/h7oonpEqzk+tE86RsrfNSolTuYUz4oIFXSyXqWcUWDU4LDGuSSWuLJWNvDnxtxgvVmrM6W0m+DslpdA+WlnS32HpXSRDwpfANQWaFJQ7g0+mQSGa53Gfzr/JKrNSHiSoqwAF2kIXRGjNTt/tjbeMizwNLwkx61Z7S9JCGqJJb5Tz+dDkt1JrgcgOW6F9fCmKnBUvCwy64wXKpRZKNtvAoRTIdfxXuSQiGow8OOeMnsquPUP+pixp8hINNO+QXt941tNGcqXZwPps62I4lzmptUDDUXWM58okK2n6irTFGeAU4GzX23Fr20uxkjNLXGuM4fObVZWE/vDMmdMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSP+EBXVuIeiMCAfcOM91sbDmDLvhno/n4LcN5sYhjg=;
 b=PV83d04TLEzSxlOhx/Ko5K5MN6/c4QOz3kmvoH9QbcOm6je64w2MXzMQdQj1DB/ANkYk4Jv5J3YKArDxs73tBfYiWLp9c3vIlJb/aas9x7Y89MczPhmABoXbrhki9/DtznVJ6b0mlEa72o0whr8GbhTNnrm6CWaTWesJY7H7k6Vx5bK9c3NeVf+uW3BW7a2sWANHMi/TG5iDiBOpW2yBAbbfHX+DfgTaAItctobdKhUAKoFgBrqwiJgllulMKt8iuIePiFIhW2fZbKcj3avRC9ithFVa0peKhZ2iRwk2+3h7vyB1XydQ3/cnuMT7U89u/twAH6gafDrZvfInGwXWLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSP+EBXVuIeiMCAfcOM91sbDmDLvhno/n4LcN5sYhjg=;
 b=JDBBqjfvmYU2nwROhjHs2TuyFHV34ZdwP+uaoHsFchvWCCrxWQ08EAIttTNqziIAp6npsovI4H+gTP3YI7zUij1PbE+jwfPdt5qyTGjBtNqJ3EbgZ33p3Ep16rRtb24/l2pvR815HPjYBml/ppaRwMCPCfYIKRWcDc3fcGURB28=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=virtuozzo.com;
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com (2603:10a6:10:e0::21)
 by DB6PR0801MB2072.eurprd08.prod.outlook.com (2603:10a6:4:79::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Fri, 2 Oct
 2020 12:52:24 +0000
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::59fa:b54d:8d50:f183]) by DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::59fa:b54d:8d50:f183%6]) with mapi id 15.20.3412.029; Fri, 2 Oct 2020
 12:52:24 +0000
Subject: Re: Patching kthread functions
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     live-patching@vger.kernel.org, pmladek@suse.com, nstange@suse.de
References: <9c9e5b82-660e-a666-b55c-a357dd7482cb@virtuozzo.com>
 <alpine.LSU.2.21.2010011300450.6689@pobox.suse.cz>
 <05a9533b-4b12-d600-5307-1f4fadb44f2b@virtuozzo.com>
 <alpine.LSU.2.21.2010021339390.24950@pobox.suse.cz>
From:   Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Message-ID: <1cdecdce-fb34-29aa-1dda-1d02d8a635ef@virtuozzo.com>
Date:   Fri, 2 Oct 2020 15:52:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <alpine.LSU.2.21.2010021339390.24950@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR07CA0128.eurprd07.prod.outlook.com
 (2603:10a6:207:8::14) To DB8PR08MB5019.eurprd08.prod.outlook.com
 (2603:10a6:10:e0::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.45] (95.27.164.21) by AM3PR07CA0128.eurprd07.prod.outlook.com (2603:10a6:207:8::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.19 via Frontend Transport; Fri, 2 Oct 2020 12:52:22 +0000
X-Originating-IP: [95.27.164.21]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a0c6151-f17e-4c20-3646-08d866d201db
X-MS-TrafficTypeDiagnostic: DB6PR0801MB2072:
X-Microsoft-Antispam-PRVS: <DB6PR0801MB20722548D19857D59905A166D9310@DB6PR0801MB2072.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZdYUeet6a+FEViGJZ0R8EdNhl9TXfKRnDSFmC40yb1VIJ3TcBXFIsStMVnq2G2n+kpxNW03r6QxoPairQAHwxTz9J0B0J6PXR3VbzDJZGhBRzsuziFxrh4XFhOoJFuS7lIeRoewp+Sq2kN+VjJNpIieUIkcK8T4iKDqsG4NG0Fhqe/812nPgQvmqPBn4fAEJA4M8DuxR44TssaYIcrCHOcDZg0PBRdfju6LNJRpljw2huix/Fpfu7kNyZl8y2m9/WzrYsgfNgj9Oustg5ZbjKBBs3y0QKOBRApyGVSm8D0VjNa3XzVyLtEmvv3aNSYDeXaEFnJPGeHIa21t7Ps0j8cVySMfJOmWbxymYRV4gqd3BD5LfzxlH3bqkz9kaaO6MMONocMV96+06pYXfNgy1nP7upalteIBr+sYokIRqSVnAG6p1PfF8gCQ6K2tTaGPYPQJbhTtH/EbI2N4E3mPlAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5019.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39840400004)(136003)(376002)(346002)(4326008)(36756003)(26005)(31696002)(83380400001)(16526019)(31686004)(53546011)(966005)(186003)(52116002)(478600001)(2906002)(956004)(2616005)(83080400001)(6916009)(316002)(86362001)(3480700007)(5660300002)(8676002)(8936002)(66556008)(7116003)(66946007)(16576012)(6486002)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: a4CG0NLp2/3RnYv0C5ZNx4AWBO5Xsuj5SgN+UDAC0NBPEpWuADPVg8YTlUuuGZ+Mb7Hmn0699ik/4DzRO8b4zNntl6UDKulAA1QP4QT1nbAMrd+2AB9lp5HtafZ9Amjdzw+CwKiMABCy4pFXHTL9tk0c7Th4jzhWrLVF4d8JkuIRtVyC00dGEBRCLnkfQiLHF1usJ8mveVQWgTBdffI96uG/DTLy03uhmXbkOYGsBu+c3lpoH3j20gMc4Oxw4XBtad8aHhna2ZvatgxIjQDKzDFU70COLcFIP2zwWY/goGbSoB0gLgGOwGsvsRpsUKGNIqnDsWybtO9bTSpUOLs7HHmLs7Nx0AEpZABM4usDkHmwijDWQgpp2zhEVSD8/5mfjgUrgVVzQNnRL5KrWOY41jW/0EIKdpuX2t5fHRsOZRkaNpaLaQxStOA7ZReYyc9/QNtrLxf6YeKQ8MGkWLcaDycBlKOQF2BXuShof7XbMLalMR12JKgHkqBTI1khJZEYbYcmeH/JwpMbVYSGXnrva97zwG4zSri/XgXn0UKTVwiQ9bpzcSUFxazry+yNnC5zbaxaJossyJ/K3Oqe0fBSpUm7Lw8/3HODojfh8DUnZfHbe+W7qJ5nhqDOzsqCdJ2Inpm1uHNQRuepW5o67xiTuA==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0c6151-f17e-4c20-3646-08d866d201db
X-MS-Exchange-CrossTenant-AuthSource: DB8PR08MB5019.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2020 12:52:23.5102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qpmsiZ8RzVRa8Pu8XrcViKa0A2dv7xL0yJi4t0hqao/WtK7J0l0DePkPAyXfp6cPqQeD5/bSosv2QpgoHdEsp3Q4JgH6TAAd1I4G5eLw0Pc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0801MB2072
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 02.10.2020 14:53, Miroslav Benes wrote:
> 
>>>> The old function will continue running, right?
>>>
>>> Correct. It will, however, call new functions.
>>
>> Ah, I see.
>>
>> So, I guess, our best bet would be to rewrite the thread function so that it
>> contains just the event loop and calls other non-inline functions to actually
>> process the requests. And, perhaps, - place klp_update_patch_state() before
>> schedule().
> 
> Yes, that might be the way. klp_update_patch_state() might not be even
> needed. If the callees are live patched, the kthread would be migrated
> thanks to stack checking once a task leaves the callee.

You mean, the task runs the callee, then goes to schedule(), then, while 
it waits, livepatch core checks its stack, sees no target functions 
there and switches patch_state?

>   
>> This will not help with this particular kernel version but could make it
>> possible to live-patch the request-processing functions in the future kernel
>> versions. The main thread function will remain unpatchable but it will call
>> the patched functions once we switch the patch_state for the thread.
> 
> Yes. The only issue is if the intended fix changes the semantics which is
> incompatible between old and new functions (livepatch consistency model is
> LEAVE_PATCHED_SET, SWITCH_THREAD, see
> https://lore.kernel.org/lkml/20141107140458.GA21774@suse.cz/ for the
> explanation if interested).

Yes, I have read that.

In our case, the fix only adds a kind of lock/unlock around the part of 
the function processing actual requests. The implementation is more 
complex, but, essentially, it is lock + unlock. The code not touched by 
the patch already handles such locking OK, so it can work both with old 
and the new versions of patched functions. And - even if some threads 
use the old functions and some - the new ones. So, I guess, it should be 
fine.

> 
> Regards
> Miroslav
> .
> 

Thanks!
Evgenii

