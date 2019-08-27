Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E65C89EBD5
	for <lists+live-patching@lfdr.de>; Tue, 27 Aug 2019 17:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfH0PFx (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 27 Aug 2019 11:05:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52908 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfH0PFx (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 27 Aug 2019 11:05:53 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3094510576DE;
        Tue, 27 Aug 2019 15:05:53 +0000 (UTC)
Received: from [10.18.17.153] (dhcp-17-153.bos.redhat.com [10.18.17.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CA3060126;
        Tue, 27 Aug 2019 15:05:52 +0000 (UTC)
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Petr Mladek <pmladek@suse.com>
Cc:     jikos@kernel.org, Miroslav Benes <mbenes@suse.cz>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
References: <20190719122840.15353-1-mbenes@suse.cz>
 <20190719122840.15353-3-mbenes@suse.cz>
 <20190728200427.dbrojgu7hafphia7@treble>
 <alpine.LSU.2.21.1908141256150.16696@pobox.suse.cz>
 <20190814151244.5xoaxib5iya2qjco@treble>
 <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
 <20190822223649.ptg6e7qyvosrljqx@treble>
 <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz>
 <20190826145449.wyo7avwpqyriem46@treble>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <5efd9f4e-eccb-cbe0-ec2e-0e2a6a34c0ea@redhat.com>
Date:   Tue, 27 Aug 2019 11:05:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826145449.wyo7avwpqyriem46@treble>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Tue, 27 Aug 2019 15:05:53 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 8/26/19 10:54 AM, Josh Poimboeuf wrote:
> On Fri, Aug 23, 2019 at 10:13:06AM +0200, Petr Mladek wrote:
>> On Thu 2019-08-22 17:36:49, Josh Poimboeuf wrote:
>>> On Fri, Aug 16, 2019 at 11:46:08AM +0200, Petr Mladek wrote:
>>>> On Wed 2019-08-14 10:12:44, Josh Poimboeuf wrote:
>>>>> On Wed, Aug 14, 2019 at 01:06:09PM +0200, Miroslav Benes wrote:
>>>>>>> Really, we should be going in the opposite direction, by creating module
>>>>>>> dependencies, like all other kernel modules do, ensuring that a module
>>>>>>> is loaded *before* we patch it.  That would also eliminate this bug.
>>>>>
>>>>> We should look at whether it makes sense to destabilize live patching
>>>>> for everybody, for a small minority of people who care about a small
>>>>> minority of edge cases.
>>>>
>>>> I do not see it that simple. Forcing livepatched modules to be
>>>> loaded would mean loading "random" new modules when updating
>>>> livepatches:
>>>
>>> I don't want to start a long debate on this, because this idea isn't
>>> even my first choice.  But we shouldn't dismiss it outright.
>>
>> I am glad to hear that this is not your first choice.
>>
>>
>>>>    + It means more actions and higher risk to destabilize
>>>>      the system. Different modules have different quality.
>>>
>>> Maybe the distro shouldn't ship modules which would destabilize the
>>> system.
>>
>> Is this realistic? Even the best QA could not check all scenarios.
>> My point is that the more actions we do the bigger the risk is.
> 
> Sure, it introduces risk.  But we have to compare that risk (which only
> affects rare edge cases) with the ones introduced by the late module
> patching code.  I get the feeling that "late module patching" introduces
> risk to a broader range of use cases than "occasional loading of unused
> modules".
> 
> The latter risk could be minimized by introducing a disabled state for
> modules - load it in memory, but don't expose it to users until
> explicitly loaded.  Just a brainstormed idea; not sure whether it would
> work in practice.
> 

Interesting idea.  We would need to ensure consistency between the 
loaded-but-not-enabled module and the version on disk.  Does module init 
run when it's enabled?  Etc.

<blue sky ideas>

What about folding this the other way?  ie, if a livepatch targets 
unloaded module foo, loaded module bar, and vmlinux ... it effectively 
patches bar and vmlinux, but the foo changes are dropped. 
Responsibility is placed on the admin to install an updated foo before 
loading it (in which case, livepatching core will again ignore foo.)

Building on this idea, perhaps loading that livepatch would also 
blacklist specific, known vulnerable (unloaded) module versions.  If the 
admin tries to load one, a debug msg is generated explaining why it 
can't be loaded by default.

</blue sky ideas>

>>>>    + It might open more security holes that are not fixed by
>>>>      the livepatch.
>>>
>>> Following the same line of thinking, the livepatch infrastructure might
>>> open security holes because of the inherent complexity of late module
>>> patching.
>>
>> Could you be more specific, please?
>> Has there been any known security hole in the late module
>> livepatching code?
> 
> Just off the top of my head, I can think of two recent bugs which can be
> blamed on late module patching:
> 
> 1) There was a RHEL-only bug which caused arch_klp_init_object_loaded()
>     to not be loaded.  This resulted in a panic when certain patched code
>     was executed.
> 
> 2) arch_klp_init_object_loaded() currently doesn't have any jump label
>     specific code.  This has recently caused panics for patched code
>     which relies on static keys.  The workaround is to not use jump
>     labels in patched code.  The real fix is to add support for them in
>     arch_klp_init_object_loaded().
> 
> I can easily foresee more problems like those in the future.  Going
> forward we have to always keep track of which special sections are
> needed for which architectures.  Those special sections can change over
> time, or can simply be overlooked for a given architecture.  It's
> fragile.

FWIW, the static keys case is more involved than simple deferred 
relocations -- those keys are added to lists and then the static key 
code futzes with them when it needs to update code sites.  That means 
the code managing the data structures, kernel/jump_label.c, will need to 
understand livepatch's strangely loaded-but-not-initialized variants.

I don't think the other special sections will require such invasive 
changes, but it's something to keep in mind with respect to late module 
patching.

-- Joe
