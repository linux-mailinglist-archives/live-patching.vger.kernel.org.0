Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51851280401
	for <lists+live-patching@lfdr.de>; Thu,  1 Oct 2020 18:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732048AbgJAQeX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Oct 2020 12:34:23 -0400
Received: from mail-db8eur05on2136.outbound.protection.outlook.com ([40.107.20.136]:35051
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732046AbgJAQeX (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Oct 2020 12:34:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sjpk7AHmKQ1XoB6njpgRbD5irIL/TXQV+S4NR81h4Z4QcgtEY/yVtbqVD8KAxvHlj85Sg6a/iNN5PC+yE4YR5AW3PjoVXoVuI5Ng/pnnrskehSg6Xi2vF5RqAwJ8h/vv7DcFct/8KRskPKnTa4TVXhByvPyRTkp0ef6TvzuPLdaHHCeyB08LVw8xAzIfnE+pZBVgtBEU3WQ9IgTxu0EcL4s6ia795L0lqeKX6wjrQdfmN1HqlWSvvTQm/vLLx1ygSEvoNG4+ufp8F5uNnMpAOJDMYmJZknVMrZhahVzHXGYnGCOlYI60aAnIY8blV/i2OhoTZJI8t6of2NsfrZ2MxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NKy96+X8aGRCxLQb7my2ZYb8BPRYyAT/55txVCuyWk=;
 b=B3Q+BoLMRyu0tHlXUhJzaBGtDa9XRZpU9pU/tRGAZP44sUcxp7cg50vdA4LlTfZi+WcM7FQNoXRUE/IWadMvHoFkZhu1RnboouKowDSnZcog9WPONKbM1HZB4VFfdXWx1JCr16R4wki/FK19o0fngiynau1EM5IuYncDzwMb62jHEZdFwx59UFMufhWwJ2RDq5nmSKiGbidCBLWwOy9t1kN3HABaf9HmDvHBnDHAU6jLGRLIGRVY4YNWkqBgLXKfaJ8kuSlbHirmzZteYoKlX9q+88BqvORkt2VwPANfK9aAHdkeJucKWLmgCjdP7C/WKI2WtbyzIvO7Mez/aBB5Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9NKy96+X8aGRCxLQb7my2ZYb8BPRYyAT/55txVCuyWk=;
 b=RUhZC92Fh9xkVNMZ7+G4hk/xPKOCH3AlLc5CHHeJcAYE0WYAvjEufSyS9iACxbpsYtd7fNqG2Yt/2ixrPGU//bVfSo6y/TLje6pFMXKliZ7NkxEmi+g7XTpNS6Xeo6/Rz/BoUomqnbPhItHzAUCq7gCjJiU26r93jQcr1F9giGw=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=virtuozzo.com;
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com (2603:10a6:10:e0::21)
 by DB6PR08MB2663.eurprd08.prod.outlook.com (2603:10a6:6:21::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Thu, 1 Oct
 2020 16:34:19 +0000
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::59fa:b54d:8d50:f183]) by DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::59fa:b54d:8d50:f183%6]) with mapi id 15.20.3412.029; Thu, 1 Oct 2020
 16:34:18 +0000
Subject: Re: Patching kthread functions
To:     Petr Mladek <pmladek@suse.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
        nstange@suse.de
References: <9c9e5b82-660e-a666-b55c-a357dd7482cb@virtuozzo.com>
 <alpine.LSU.2.21.2010011300450.6689@pobox.suse.cz>
 <20201001144625.GE17717@alley>
From:   Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Message-ID: <b7f76c10-28a4-8779-c07c-b958955d9077@virtuozzo.com>
Date:   Thu, 1 Oct 2020 19:34:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20201001144625.GE17717@alley>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR08CA0002.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::15) To DB8PR08MB5019.eurprd08.prod.outlook.com
 (2603:10a6:10:e0::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.45] (95.27.164.21) by AM0PR08CA0002.eurprd08.prod.outlook.com (2603:10a6:208:d2::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32 via Frontend Transport; Thu, 1 Oct 2020 16:34:17 +0000
X-Originating-IP: [95.27.164.21]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44baf8a3-4351-40a3-0bf3-08d86627d790
X-MS-TrafficTypeDiagnostic: DB6PR08MB2663:
X-Microsoft-Antispam-PRVS: <DB6PR08MB26630654FF8379E62D2EE165D9300@DB6PR08MB2663.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GAtmuthcMKDkWShCx8VbSOVomJU1810HPvjvT8QMLHgDLZMD4N2ScqBRnMir+Y5LRUBgPf6kzNoxzzVd7PQpN/QJ76P726i2CL56iPDdmoTimqyv8UkKq6qRa9vYLNXL4F3vpY4YOrtJ+zSpnJoodD4fIHcUuhci2OWTj4URQaJ29yGEwN3R7qsJGpOKnLoeIaVV3sfxVDyWxxgOdimJbLCwXVujZRI94KlTuzGdrc8qQX/zDYp/vdtD03+lS344GI/wwsekymZsfrqnGrmjIS9eP7+S0cE4YmCu0zogt3Q9fAIzO1k3Kal4OCmrX6djTuKSpaGFiLi7oftXSn0qAfgq8wpCX/k8sXY/OoAlfcFYc2sPNmftYYSFvczk0UZo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5019.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39840400004)(366004)(136003)(396003)(376002)(4326008)(8936002)(31686004)(3480700007)(83380400001)(52116002)(5660300002)(31696002)(478600001)(53546011)(956004)(316002)(6486002)(2616005)(66946007)(66556008)(36756003)(8676002)(86362001)(16526019)(16576012)(26005)(66476007)(186003)(6916009)(2906002)(7116003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 3lEg0P97chfT5Nbvwg7d/5TUsXbl2lTEKllnK5mmjkgGUyrSYKsnqPiuUWVXe2uyRn8LVS+9mxySkjjCs1R92apo9eURTeiHZaKqP7xZonxfhNG59Tuu2uoe5Kmmm+mSMt7NHRiqHst0v+b/vHX8UY7bpQD43oE7v/6pS639D3YDcjjerl3kLJ6mM9lyd1z5gNNvcvrk0xRhAElFn4XSIJHjUTYP16BU1Bx70nXZVa9gnx7V448m/7c5K++5c53rmwN8X2Qb0KXbUFRqoLgHlqYsCYsGH6bD7ujyjUqTcGisJSN/vKLlAVnmbuEz28fED9cFX/8zqpK7EFHKTmSNMSumL6Q2kdfndIrYe0rpTqFk/DlW6O82qjQ5tsXeHRL1s4fjLeNBZu006P22aLCwEc8Om9dcaWzBMckA2Ajvrf9frJj8da+xxeetfeqXC5GPAz3ici34so6tUv31Snc8t0TJojVnLbZQ9V1WszY0sKqCbrj9hqheMHW9f87VMC9HpEKBwsL2jeWdnjnQ8lIi9RgIrVTTHztKeUHIZl2T4fSA37BIGRi9hiTXdlDko9OkAmxYNFYr6G9Kv3Q+Xs+rX04fdb6xk1SyeQFjwW8pkmS4Ie6hB+l4P2X1d73akFRwhsWOOCTKNfZYNLA/bfCOjA==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44baf8a3-4351-40a3-0bf3-08d86627d790
X-MS-Exchange-CrossTenant-AuthSource: DB8PR08MB5019.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2020 16:34:18.1513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x/O3/UyHiEgPe4txdt14djIhgdPVPFNM5lNbecwhG6D1d6TsI+lYed8Jg9lHLyUgxBFVuEBIqDf63SfVeZQXlKoY8YZkDYl8rW+FKndip9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR08MB2663
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 01.10.2020 17:46, Petr Mladek wrote:
> On Thu 2020-10-01 13:13:07, Miroslav Benes wrote:
>> On Wed, 30 Sep 2020, Evgenii Shatokhin wrote:
>>
>>> Hi,
>>>
>>> I wonder, can livepatch from the current mainline kernel patch the main
>>> functions of kthreads, which are running or sleeping constantly? Are there any
>>> best practices here?
>>
>> No. It is a "known" limitation, "" because we discussed it a couple of
>> times (at least with Petr), but it is not documented :(
>>
>> I wonder if it is really an issue practically. I haven't met a case
>> yet when we wanted to patch such thing. But yes, you're correct, it is not
>> possible.
>>   
>>> I mean, suppose we have a function which runs in a kthread (passed to
>>> kthread_create()) and is organized like this:
>>>
>>> while (!kthread_should_stop()) {
>>>    ...
>>>    DEFINE_WAIT(_wait);
>>>    for (;;) {
>>>      prepare_to_wait(waitq, &_wait, TASK_INTERRUPTIBLE);
>>>      if (we_have_requests_to_process || kthread_should_stop())
>>>        break;
>>>      schedule();
>>>    }
>>>    finish_wait(waitq, &_wait);
>>>    ...
>>>    if (we_have_requests_to_process)
>>>      process_one_request();
>>>    ...
>>> }
> 
> Crazy hack would be to patch only process_one_request() the following way:
> 
> 1. Put the fixed main loop into the new process_one_request() function.
> 
> 2. Put the original process_one_request() code into another function,
>     e.g. do_process_one_request_for_real() and call it from the
>     fixed loop.
> 
> Does it make any sense or should I provide some code?

I think, I get the idea, thanks!

So, the thread would loop in the new process_one_request() and, with 
necessary care taken, would exit both loops correctly when needed.

In our case (kaio_fsync_thread() at the mentioned URL) 
process_one_request() is actually not a separate function but rather 
part of the same thread function. So, in this particular case it would 
not help. If we refactor the function in some future versions, this 
could be an option.

But, yes, such patch would need to remain applied forever, no updates 
and no unloads, which is a downside.

> 
> Be aware that such patch could not get reverted because it would never
> leave the new main loop.
> 
> Best Regards,
> Petr
> .
> 

Regards,
Evgenii
