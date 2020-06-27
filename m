Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD0E20BEE5
	for <lists+live-patching@lfdr.de>; Sat, 27 Jun 2020 07:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgF0Fnm (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sat, 27 Jun 2020 01:43:42 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:40592 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgF0Fnm (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Sat, 27 Jun 2020 01:43:42 -0400
Subject: Re: Live patching MC at LPC2020?
To:     Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Nicolai Stange <nstange@suse.com>,
        Jason Baron <jbaron@akamai.com>,
        Gabriel Gomes <gagomes@suse.com>,
        Alice Ferrazzi <alice.ferrazzi@gmail.com>,
        Michael Matz <matz@suse.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        ulp-devel@opensuse.org, live-patching@vger.kernel.org
References: <nycvar.YFH.7.76.2003271409380.19500@cbobk.fhfr.pm>
 <20200331205204.GA7388@redhat.com> <20200625065943.GB6156@alley>
From:   Alice <alicef@gentoo.org>
Message-ID: <cbf593e7-6484-7f74-5c19-d4936cb604cf@gentoo.org>
Date:   Sat, 27 Jun 2020 14:43:30 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200625065943.GB6156@alley>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hello,

On 6/25/20 3:59 PM, Petr Mladek wrote:
> On Tue 2020-03-31 16:52:04, Joe Lawrence wrote:
>> On Fri, Mar 27, 2020 at 02:20:52PM +0100, Jiri Kosina wrote:
>>> Hi everybody,
>>>
>>> oh well, it sounds a bit awkward to be talking about any conference plans
>>> for this year given how the corona things are untangling in the world, but
>>> LPC planning committee has issued (a) statement about Covid-19 (b) call
>>> for papers (as originally planned) nevertheless. Please see:
>>>
>>> 	https://linuxplumbersconf.org/
>>> 	https://linuxplumbersconf.org/event/7/abstracts/
>>>
>>> for details.
>>>
>>> Under the asumption that this Covid nuisance is over by that time and
>>> travel is possible (and safe) again -- do we want to eventually submit a
>>> livepatching miniconf proposal again?
> The conference is going to be an online event.
>
>
>> As for LPC mini-conf topics, I'd be interested in (at least):
>>
>> - Petr's per-object livepatch POC
>> - klp-convert status
>> - objtool hacking
>> - Nicolai's klp-ccp status
>> - arch update (arm64, etc)
>   
>> Hmm, all good points.  Some conferences have gone virtual to cope with
>> necessary cancellations, but who knows what things will look like even
>> at the end of August.  Perhaps we can still do something remotely if the
>> conditions dictate it.  But my vote would be yes, and let's see what
>> topics interest folks.
> It seems that there is interest into sharing/discussing some topics.
> The question is whether is has to be under the LPC even umbrella.
>
> Advantages of LPC:
>
>     + well defined date
>     + more attendees (ARM people, Steven Rostedt ;-)
>     + access to some powerful video conference tool
>     + access to another LPC content
>     + support for the conference in the long term
>
>
> Advantages of self-organized event:
>
>     + less paperwork?
>     + cheaper?
>     + only interested people invited
>     + date after summer holidays
>     + more time for the discussion

As they are both online events,
I personally have no preference on this.

Thanks,
Alice

