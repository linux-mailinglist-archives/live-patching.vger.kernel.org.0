Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A913175B6B
	for <lists+live-patching@lfdr.de>; Mon,  2 Mar 2020 14:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgCBNTX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 2 Mar 2020 08:19:23 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:19148 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727267AbgCBNTX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 2 Mar 2020 08:19:23 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04446;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0TrRUx1a_1583155161;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0TrRUx1a_1583155161)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 02 Mar 2020 21:19:21 +0800
Subject: Re: [help] Confusion on livepatch's per-task consistency model
To:     Nicolai Stange <nstange@suse.de>
Cc:     jpoimboe@redhat.com, live-patching@vger.kernel.org
References: <315f87a7-eb40-67a7-4ab9-4b384fde752a@linux.alibaba.com>
 <87mu8z6o1r.fsf@suse.de>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <cd038cf3-4629-6602-1d23-9f0cabb45083@linux.alibaba.com>
Date:   Mon, 2 Mar 2020 21:19:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <87mu8z6o1r.fsf@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Thanks for replying. ;)


On 3/2/20 6:36 PM, Nicolai Stange wrote:
> Hi,
>
> JeffleXu <jefflexu@linux.alibaba.com> writes:
>
>> According to the model, there will be scenario where old function and new
>>
>> function can co-exist, though for a single thread, it sees either all new
>>
>> functions or all old functions.
> That's correct.
>
>
>> I can't understand why Vojtech said that 'old func processing new
>> data' was impossible.
> Just to make it explicit: Vojtech was talking about data layout
> changes.
Fine
>
> That is, consider you have something like e.g. this in the unmodified
> kernel sources:
>
> struct my_driver_work
> {
> 	struct work_struct work;
>          struct list_head works_list;
>          void *some_payload;
> };
>
> In general, you can't change that struct definition from a live
> patch. So simply extending it like this
>
> struct my_driver_work
> {
> 	struct work_struct work;
>          struct list_head works_list;
>          unsigned long flags /* New */
>          void *some_payload;
> };
>
> won't work.
>
>
>> Assuming a scenario where a process calls func-A to submit a
>>
>> work request (inserted into a global list), and then a kthread is
>> responsible
>>
>> for calling func-B to process all work requests in the list. What if
>> this process
>>
>> has finished the transition (sees new func-A) while kthread still sees
>> the old func-B?
> Going with the example from above, the patched func-A would submit
> instances of the new struct my_driver_work whereas the unpatched func-B
> would expect the ->some_payload pointer at where ->flags is stored now,
> which is bad, obviously.
>
> In this specific example, it could perhaps be possible to make the
> patched func-A associate a shadow variable corresponding to the new
> ->flags member with newly created struct my_driver_work instances (of
> original, unmodified layout). Any unpatched func-B would obviously
> ignore it and consider the shadow only when it becomes patched. It very
> much depends on the specific situation whether or not this is
> acceptable. If not, the ->post_patch() can sometimes be used to achieve
> some notion of a "global consistency" state (in this context,
> c.f. Documentation/livepatch/system-state.rst).

Well, I'm familiar with shadow variable, but didn't consider callbacks 
earlier. Since the version of my

kernel is not new enough, the "system state API" has not been merged in 
my kernel. I will read it later.


> Note however, that the patched func-B must always be able to handle
> the situation where a struct my_driver_work instance does not have such
> a ->flags shadow attached to it, either because the instance had been
> created  when the live patch has not been applied at all or because it
> has been submitted from a not yet transitioned func-A.
>
> There's another subtlety: the deallocation code for struct
> my_driver_work needs to get livepatched as well to make it free the
> ->flags shadow. Consider the case where func-A has been transitioned,
> but the deallocation code hasn't yet. Without any extra measures in
> func-A, it could happen that a stale ->flags shadow from a deallocated
> struct my_driver_work gets (wrongly) reassociated with a fresh struct
> my_driver_work instance allocated at the same address as the old one
> (because shadow variables are keyed on addresses of the data they're
> associated with). Sometimes that's acceptable, sometimes it's not. In
> the latter case you probably had to check for this situation and work
> around it in the allocation code, i.e. the live-patched func-A.

I've never thought about this. It's a valuable suggestion.


> Finally, let me remark that from my experience, most CVEs (>95%) can be
> fixed via live patching without having to resort to either of shadow
> variables, callbacks or the state API. For the rest, things usually tend
> to become really non-trivial, hackish and subtle.

Thanks for your experience.


>> In this case, old func-B has to process new data. If there's some lock
>> semantic
>>
>> changes in func-A and func-B, then old func-B has no way identifying
>> the shadow
>>
>> variable labeled by new func-A.
> I don't understand what you mean by "variable labeled by new func-A"?
> Anyway, it's correct that an unpatched func-B would not consider any
> shadow variables instantiated by patched func-A. And it's also correct
> that changing locking semantics is difficult, if not impossible.

Just means shadow variable allocated by new patched function. I know 
shadow variable can serve

as a flag to enable the new functions, but in this case the post_patch() 
callback is obviously more

appropriate to serve as this role.


So as far as I understand, for all kinds of (data/locking) semantic 
changes, it's the responsibility of the

patch writer to detect the semantic changes, and usually it can only be 
analyzed case by case. Right?



