Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97897175B09
	for <lists+live-patching@lfdr.de>; Mon,  2 Mar 2020 13:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgCBM4r (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 2 Mar 2020 07:56:47 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:36573 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727891AbgCBM4q (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 2 Mar 2020 07:56:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R531e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0TrR9Z6._1583153782;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0TrR9Z6._1583153782)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 02 Mar 2020 20:56:23 +0800
Subject: Re: [help] Confusion on livepatch's per-task consistency model
To:     Petr Mladek <pmladek@suse.com>
Cc:     jpoimboe@redhat.com, live-patching@vger.kernel.org
References: <315f87a7-eb40-67a7-4ab9-4b384fde752a@linux.alibaba.com>
 <20200302101207.57i4opglpgaynfju@pathway.suse.cz>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <b0b335ed-75e5-073f-e9e2-6185cf9a3f0b@linux.alibaba.com>
Date:   Mon, 2 Mar 2020 20:56:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200302101207.57i4opglpgaynfju@pathway.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


On 3/2/20 6:12 PM, Petr Mladek wrote:
> On Mon 2020-03-02 16:45:24, JeffleXu wrote:
>> Hello guys,
>>
>>
>> I'm new to livepatch world and now I'm a little confused with livepatch's
>>
>> per-task consistency model which is introduced by [1]. I've also readed the
>>
>> discussion on mailing list [2], which introduces shadow variable to handle
>>
>> data layout and semantic changes. But there's still some confusion with this
>>
>> per-task consistency model.
>>
>>
>> According to the model, there will be scenario where old function and new
>>
>> function can co-exist, though for a single thread, it sees either all new
>>
>> functions or all old functions.
>>
>>
>> I can't understand why Vojtech said that 'old func processing new data' was
>>
>> impossible. Assuming a scenario where a process calls func-A to submit a
>>
>> work request (inserted into a global list), and then a kthread is
>> responsible
>>
>> for calling func-B to process all work requests in the list. What if this
>> process
>>
>> has finished the transition (sees new func-A) while kthread still sees the
>> old func-B?
>>
>> In this case, old func-B has to process new data. If there's some lock
>> semantic
>>
>> changes in func-A and func-B, then old func-B has no way identifying the
>> shadow
>>
>> variable labeled by new func-A.
>>
>>
>> Please tell me if I missed something, and any suggestions will be
>> appreciated. ;)
> No, you did not miss anything. The consistency is only per-thread,
> If a livepatch is changing semantic of a global variable it must
> allow doing the changes only when the entire system is using
> the new code. And the new code must be able to deal with both
> old and new data.
>
> The new data semantic can be enable by post-patch callback
> that is called when the transition has finished.

Thanks for replying. I didn't consider callback earlier, and yes it 
works in this case.


Thanks.

Jeffle



