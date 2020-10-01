Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6204E27FFCB
	for <lists+live-patching@lfdr.de>; Thu,  1 Oct 2020 15:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731987AbgJANMl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 1 Oct 2020 09:12:41 -0400
Received: from mail-eopbgr70094.outbound.protection.outlook.com ([40.107.7.94]:56702
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731936AbgJANMk (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 1 Oct 2020 09:12:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmRwZyfLpjBKaAlwdb5p8HEzaM/Pg9JqN3d7fYYmDlwD9oDEZeBaTAk7STot8cExYKjKCqX4c/3pi4ZtZb+dhgWvG8gMdhtuc9rHR+aDThmNhMCULizaxD72h11gYvnZ+BWE73V1jOrBye1QNFNt+gow7hKvkDYkOo1PHbTcq2PuJLOth70TyBIbdwHD/MIGkX9gk5XO2BZQcJiPRWZXLAZvG4/y6g8Faedt66ycfH8ItjuP6w5IDW2uheN2hAaSVc/CI/RLRAXSwNH0Lp6QQfu1hn5/E+SRF630rShj6/6sdc5eaNmzlQrTlA78f2k06NThv/OYXETXFqRcIBPaZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Y3l3sLhpDHXmwWGElRQrdp1ftQ02IomSTisU2uKK8o=;
 b=KW7cpWX8eoodfIUk+HbDvoWU1tLyW8eLvC7olffLZ/RvOQbI0LjawMT7w4OyXpu0TMCZm4g0DeAzVIfgdApQDg1Jd60ZNe5NZo3UdLe78cxmeZXIVH2mIVQp4zj5PKoeB5zq1SwbVyIi7NNWzwjh+2NEOMJb/5LkYyjvCo293vqyEEYaYShtwZpNJXUmHUU0ihTG40lLShG868C+Qh7/ob9a+DtZcadw5GEXJJOuAkUiQsfAAXAyzcsxSuNXJQQs1PHG25UEkFVxdZPACQxqs3CQHsmDiGLzAGPTX7lAlcsfkPE4eoFAroSx3hu5TULiSjanhKpco/atJc6UTjUyRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7Y3l3sLhpDHXmwWGElRQrdp1ftQ02IomSTisU2uKK8o=;
 b=IxF7MFOlSsNlSMZxfP98ZL6mcecz1Cy6jx5Q41WsoGtJbzIrKLSANORfbT5hK8mm9/5bnebnCqkXAw1v4+5JfkKZmyPtB6NhmPl//wGDyuczpEb0lYJZ26Cer0Y6XABGgYp1DxFgn5duRdvUgWmHnLv8hpA09NQK7GdUcljjL0s=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=virtuozzo.com;
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com (2603:10a6:10:e0::21)
 by DB8PR08MB5196.eurprd08.prod.outlook.com (2603:10a6:10:ee::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Thu, 1 Oct
 2020 13:12:36 +0000
Received: from DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::59fa:b54d:8d50:f183]) by DB8PR08MB5019.eurprd08.prod.outlook.com
 ([fe80::59fa:b54d:8d50:f183%6]) with mapi id 15.20.3412.029; Thu, 1 Oct 2020
 13:12:36 +0000
Subject: Re: Patching kthread functions
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     live-patching@vger.kernel.org, pmladek@suse.com, nstange@suse.de
References: <9c9e5b82-660e-a666-b55c-a357dd7482cb@virtuozzo.com>
 <alpine.LSU.2.21.2010011300450.6689@pobox.suse.cz>
From:   Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Message-ID: <05a9533b-4b12-d600-5307-1f4fadb44f2b@virtuozzo.com>
Date:   Thu, 1 Oct 2020 16:12:34 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <alpine.LSU.2.21.2010011300450.6689@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR07CA0027.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::40) To DB8PR08MB5019.eurprd08.prod.outlook.com
 (2603:10a6:10:e0::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.45] (95.27.164.21) by AM0PR07CA0027.eurprd07.prod.outlook.com (2603:10a6:208:ac::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.18 via Frontend Transport; Thu, 1 Oct 2020 13:12:35 +0000
X-Originating-IP: [95.27.164.21]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee3dd790-a7d4-4bad-447d-08d8660baa33
X-MS-TrafficTypeDiagnostic: DB8PR08MB5196:
X-Microsoft-Antispam-PRVS: <DB8PR08MB519693B0151F8752A06B8F87D9300@DB8PR08MB5196.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1FqewWoxTrP90lFVrtqSLfEhoWNu0QE/ngt8LdCdaIsxsqh/CMDnC8rxcAKemRcIe84TGgk1fIsBWAQgAxAVz/wplJNKZfuy9ZsX6jgoLdFxMFCv+2BemSn2CQFs+0ZE9CDhXCQfoTKnKnzkkmnN9BSHXgNFNCjSG8wKKo84YdXEDd10RUfs2WC5+XNwTPoKwUO8xA54dRBh9nwCT4F3ohqlhUsIpJ15d+WhUvh7sX9mORRz83BRHsS0mhP7XzEuD8C6cPnCLQ7Na+1L80pkaCFQ/sIjDGIVCYCJeVeLRILecytU/XFG9ADqZNubWJlhlCflT6r9jmeb8yazSRZOgnDrQunNFygCvpAp64vxLQbA66GLn/HlZibaqwCB+xLui+XXqkm3aw/9oUz13gWFgDn0EQ2JgC9kQFMv6KyxcCAH5NPLQAHi5niU8YBRckyWnIJNqaF48VhIUQufIwEhxYeHOCE5WcoOMnYIPoPAmxlkZXSjLvfB1AEQzhM0VwMa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR08MB5019.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39840400004)(136003)(376002)(346002)(4326008)(31686004)(2906002)(66946007)(8676002)(8936002)(83380400001)(5660300002)(6486002)(66556008)(316002)(16576012)(478600001)(52116002)(6916009)(16526019)(26005)(86362001)(31696002)(53546011)(966005)(186003)(2616005)(7116003)(66476007)(36756003)(3480700007)(956004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: VoTD/TJ85EQLsVo8QNeHqRden8WaPcO0jfVvgUqoDXGitnP/5VwU/UToK+Srz0FSmK4cdf7zd1OKjpPj2qq0Xphux5X8D9gtncI79nOdKRSN3gDKI1/ZryqgxTsDbvv4kxAoaezvIBYszsKlFbmne8lfHxa/r+GppR+QlVV3KkndX6LHNuko+P0UI9yVf7ynpcPRL1kmJmJCDz+E5JtCBokb0JA0RIuhgh87mv9n9mOEnB7xu3DoYd+bNhSiOXU2PijR9t9JiA38AH1/dMJc4kvHzS2GXjCHBIYadiYbl29VZIkxPtDgcU39n5syP+u8uTmd5dQn7jcUFviW/ZWyTUiukA6qljsrlRuwH1kzphhYDssEurMgRCaBVJRLFLfDU1AKi0UWmiJyE9iNVSWr59tFuTtUeEHosPtIOXfS9lDWu8p4srr3lvMq0nMB0DhPzxRQEYrHRNpULtXwI0u5KLVqMEnBv0kJSOW3OhgrNzqRnzWlepk8gYtDhSFMiuqLbEsVVlEqOgYSH1iegEsR5tAJoylwAgzjehI3Rn6pa4jXZOMr9/nFbXMMb3ktpVaEWWitzFZ5poZOF5ZePKr3iHxkqk7Ro6oG3YecGpoZROJkCaWSN3wTivk9JqSL9dDFJUDNOaSiWJLjeBmdzyJm+A==
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee3dd790-a7d4-4bad-447d-08d8660baa33
X-MS-Exchange-CrossTenant-AuthSource: DB8PR08MB5019.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2020 13:12:36.1393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LYpWkv5QYPPsTHcgSco9WZtrmCKq8GbZapYuyjJB0+EfTnOtzs7rEiuftSqnETa1FTZxo+9EJLw+DDmsdhBiAl+rWTcicCwRgbbyT7Bsb3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5196
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 01.10.2020 14:13, Miroslav Benes wrote:
> On Wed, 30 Sep 2020, Evgenii Shatokhin wrote:
> 
>> Hi,
>>
>> I wonder, can livepatch from the current mainline kernel patch the main
>> functions of kthreads, which are running or sleeping constantly? Are there any
>> best practices here?
> 
> No. It is a "known" limitation, "" because we discussed it a couple of
> times (at least with Petr), but it is not documented :(
> 
> I wonder if it is really an issue practically. I haven't met a case
> yet when we wanted to patch such thing. But yes, you're correct, it is not
> possible.

Well, I have recently encountered such case, with kaio_fsync_thread() 
function from our custom kernel, the code at the URL below. Our 
customers were interested in a particular bug fix there: there was a 
race, potentially leading to data corruption.

We still use the old-style kpatch.ko-based patches for that kernel 
version, so we definitely cannot deliver the fix via a live kernel 
patch, only a regular kernel update will do. That made me wonder if the 
modern livepatch could handle it.

>   
>> I mean, suppose we have a function which runs in a kthread (passed to
>> kthread_create()) and is organized like this:
>>
>> while (!kthread_should_stop()) {
>>    ...
>>    DEFINE_WAIT(_wait);
>>    for (;;) {
>>      prepare_to_wait(waitq, &_wait, TASK_INTERRUPTIBLE);
>>      if (we_have_requests_to_process || kthread_should_stop())
>>        break;
>>      schedule();
>>    }
>>    finish_wait(waitq, &_wait);
>>    ...
>>    if (we_have_requests_to_process)
>>      process_one_request();
>>    ...
>> }
>>
>> (The question appeared when I was looking at the following code:
>> https://src.openvz.org/projects/OVZ/repos/vzkernel/browse/drivers/block/ploop/io_kaio.c?at=refs%2Ftags%2Frh7-3.10.0-1127.8.2.vz7.151.14#478)
>>
>> The kthread is always running and never exits the kernel.
>>
>> I could rewrite the function to add klp_update_patch_state() somewhere, but
>> would it help?
> 
> In fact, we used exactly this approach in, now obsolete, kGraft. All
> kthreads had to be manually annotated somewhere safe, where safe meant
> that the thread could be switched to a new universe without the problem
> wrt to calling old/new functions in the loop...
> 
>> No locks are held right before and after "schedule()", and the thread is not
>> processing any requests at that point.
> 
> ... like this.
> 
>> But even if I place
>> klp_update_patch_state(), say, just before schedule(), it would just switch
>> task->patch_state for that kthread.
> 
> Correct.
> 
>> The old function will continue running, right?
> 
> Correct. It will, however, call new functions.

Ah, I see.

So, I guess, our best bet would be to rewrite the thread function so 
that it contains just the event loop and calls other non-inline 
functions to actually process the requests. And, perhaps, - place 
klp_update_patch_state() before schedule().

This will not help with this particular kernel version but could make it 
possible to live-patch the request-processing functions in the future 
kernel versions. The main thread function will remain unpatchable but it 
will call the patched functions once we switch the patch_state for the 
thread.

> 
>> Looks like we can only switch to the patched code of the function at the
>> beginning, via Ftrace hook. So, if the function is constantly running or
>> sleeping, it seems, it cannot be live-patched.
> 
> Yes and no. Normally, a task cannot run indefinitely and if it sleeps, we
> can deal with that (thanks to stack checking or signaling/kicking the
> task), but kthreads' main loops are special.
> 
>> Is that so? Are there any workarounds?
> 
> Petr, do you remember the crazy workarounds we talked about? My head is
> empty now. And I am sure, Nicolai could come up with something.

Interesting. I am all ears.

Thanks!
Evgenii

> 
> Thanks
> Miroslav
> .
> 

