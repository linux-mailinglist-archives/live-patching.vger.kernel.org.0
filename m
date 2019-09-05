Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 584D3AA1A4
	for <lists+live-patching@lfdr.de>; Thu,  5 Sep 2019 13:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730785AbfIELjh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 5 Sep 2019 07:39:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36178 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730753AbfIELjh (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 5 Sep 2019 07:39:37 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BB3FB1DA2;
        Thu,  5 Sep 2019 11:39:36 +0000 (UTC)
Received: from [10.10.125.234] (ovpn-125-234.rdu2.redhat.com [10.10.125.234])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 01BA0600F8;
        Thu,  5 Sep 2019 11:39:35 +0000 (UTC)
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
To:     Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     jikos@kernel.org, Miroslav Benes <mbenes@suse.cz>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org
References: <20190814151244.5xoaxib5iya2qjco@treble>
 <20190816094608.3p2z73oxcoqavnm4@pathway.suse.cz>
 <20190822223649.ptg6e7qyvosrljqx@treble>
 <20190823081306.kbkm7b4deqrare2v@pathway.suse.cz>
 <20190826145449.wyo7avwpqyriem46@treble>
 <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz>
 <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com>
 <alpine.LSU.2.21.1909031447140.3872@pobox.suse.cz>
 <20190904084932.gndrtewubqiaxmzy@pathway.suse.cz>
 <20190905025055.36loaatxtkhdo4q5@treble>
 <20190905110955.wl4lwjbnpqybhkcn@pathway.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <de73b9c6-fa57-8893-d7ae-5256bbb603b5@redhat.com>
Date:   Thu, 5 Sep 2019 07:39:35 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190905110955.wl4lwjbnpqybhkcn@pathway.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.71]); Thu, 05 Sep 2019 11:39:36 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 9/5/19 7:09 AM, Petr Mladek wrote:
> On Wed 2019-09-04 21:50:55, Josh Poimboeuf wrote:
>> On Wed, Sep 04, 2019 at 10:49:32AM +0200, Petr Mladek wrote:
>>> I wonder what is necessary for a productive discussion on Plumbers:
>>>
>>>    + Josh would like to see what code can get removed when late
>>>      handling of modules gets removed. I think that it might be
>>>      partially visible from Joe's blue-sky patches.
>>
>> Yes, and I like what I see.  Especially the removal of the .klp.arch
>> nastiness!
> 
> Could we get rid of it?
> 
> Is there any other way to get access to static variables
> and functions from the livepatched code?
> 

Hi Petr,

I think the question is whether .klp (not-arch specific) relocations 
would be sufficient (without late module patching).  If it would a great 
simplification if those were all we needed.  I'm not 100% sure about 
this quite yet, but am hoping that is the case.

>>>        Anyway, it might rule out some variants so that we could better
>>>        concentrate on the acceptable ones. Or come with yet another
>>>        proposal that would avoid the real blockers.
>>
>> I'd like to hear more specific negatives about Joe's recent patches,
>> which IMO, are the best option we've discussed so far.
> 
> I discussed this approach with our project manager. He was not much
> excited about this solution. His first idea was that it would block
> attaching USB devices. They are used by admins when taking care of
> the servers. And there might be other scenarios where a new module
> might need loading to solve some situation.
> > Customers understand Livepatching as a way how to secure system
> without immediate reboot and with minimal (invisible) effect
> on the workload. They might get pretty surprised when the system > suddenly blocks their "normal" workflow.

FWIW the complete blue-sky idea was that the package delivered to the 
customer (RPM, deb, whatever) would provide:

  - livepatch .ko, blacklists known vulnerable srcversions
  - updated .ko's for the blacklisted modules

The second part would maintain module loading workflow, albeit with a 
new set .ko files.

> As Miroslav said. No solution is perfect. We need to find the most
> acceptable compromise. It seems that you are more concerned about
> saving code, reducing complexity and risk. I am more concerned
> about user satisfaction.
> 
> It is almost impossible to predict effects on user satisfaction
> because they have different workflow, use case, expectation,
> and tolerance.
> 
> We could better estimate the technical side of each solution:
> 
>     + implementation cost
>     + maintenance cost
>     + risks
>     + possible improvements and hardening
>     + user visible effects
>     + complication and limits with creating livepatches
> 
> 
>  From my POV, the most problematic is the arch-specific code.
> It is hard to maintain and we do not have it fully under
> control.
> 
> And I do not believe that we could remove all arch specific code
> when we do not allow delayed livepatching of modules.
> 

No doubt there will probably always be some arch-specific code, and even 
my blue-sky branch didn't move all that much.  But I think the idea 
could be a bigger simplification in terms of the mental model, should 
the solution be acceptable by criteria you mention above.

-- Joe
