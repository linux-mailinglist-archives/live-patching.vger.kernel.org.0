Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AF612628
	for <lists+live-patching@lfdr.de>; Fri,  3 May 2019 03:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfECBqW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 2 May 2019 21:46:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60340 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfECBqW (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 2 May 2019 21:46:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YJQaUOy07zWYs8zVSTxJU7bh0o5le6pfH8RqO6AY0VI=; b=Z5B4A8IJMzU3eUUJU6fm12bf+j
        0iIQZOhqBc8aToHebYQcsHdIs/42x3dJGQNmFB6QNBUb5RmJRBoU14y0E/DvXyrdnlsO+5nf5sj6i
        NsYhxLQGrTq1XgVBAN8run654mgz8duAunnY5EvDuCqJHaNl8Me27BTFd8+zikrPPmcVjjAM/0zjw
        H1Xd85N/Q9W/1OmNEFUoWi9gbwz5lCfoAi4u1QyPmi14boPR7HbNEc1Cr8L86lphEYU9oYDno3s/p
        3uhrhvGCzl07dMS4ZG89yAe48+aobUZq/qfFSGznEpXIXfdfrMcDlPuYSQDKIyCm4KEKeV9WVs4yP
        4iEEPozw==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=midway.dunlab)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hMNHG-0006oZ-Ew; Fri, 03 May 2019 01:46:18 +0000
Subject: Re: [RFC PATCH 3/5] kobject: Fix kernel-doc comment first line
To:     "Tobin C. Harding" <me@tobin.cc>, Johan Hovold <johan@kernel.org>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190502023142.20139-1-tobin@kernel.org>
 <20190502023142.20139-4-tobin@kernel.org> <20190502073823.GQ26546@localhost>
 <20190502082539.GB18363@eros.localdomain> <20190502083922.GR26546@localhost>
 <20190503014015.GC7416@eros.localdomain>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <8e237ab7-681b-dccf-792f-264e3f6fcd2d@infradead.org>
Date:   Thu, 2 May 2019 18:46:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190503014015.GC7416@eros.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 5/2/19 6:40 PM, Tobin C. Harding wrote:
> On Thu, May 02, 2019 at 10:39:22AM +0200, Johan Hovold wrote:
>> On Thu, May 02, 2019 at 06:25:39PM +1000, Tobin C. Harding wrote: > Adding Jon to CC
>>>
>>> On Thu, May 02, 2019 at 09:38:23AM +0200, Johan Hovold wrote:
>>>> On Thu, May 02, 2019 at 12:31:40PM +1000, Tobin C. Harding wrote:
>>>>> kernel-doc comments have a prescribed format.  This includes parenthesis
>>>>> on the function name.  To be _particularly_ correct we should also
>>>>> capitalise the brief description and terminate it with a period.
>>>>
>>>> Why do think capitalisation and full stop is required for the function
>>>> description?
>>>>
>>>> Sure, the example in the current doc happen to use that, but I'm not
>>>> sure that's intended as a prescription.
>>>>
>>>> The old kernel-doc nano-HOWTO specifically did not use this:
>>>>
>>>> 	https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt
>>>>
>>>
>>> Oh?  I was basing this on Documentation/doc-guide/kernel-doc.rst
>>>
>>> 	Function documentation
>>> 	----------------------
>>>
>>> 	The general format of a function and function-like macro kernel-doc comment is::
>>>
>>> 	  /**
>>> 	   * function_name() - Brief description of function.
>>> 	   * @arg1: Describe the first argument.
>>> 	   * @arg2: Describe the second argument.
>>> 	   *        One can provide multiple line descriptions
>>> 	   *        for arguments.
>>>
>>> I figured that was the canonical way to do kernel-doc function
>>> comments.  I have however refrained from capitalising and adding the
>>> period to argument strings to reduce code churn.  I figured if I'm
>>> touching the line to add parenthesis then I might as well make it
>>> perfect (if such a thing exists).
>>
>> I think you may have read too much into that example. Many of the
>> current function and parameter descriptions aren't even full sentences,
>> so sentence case and full stop doesn't really make any sense.
>>
>> Looks like we discussed this last fall as well:
> 
> Ha, this was funny.  By 'we' at first I thought you meant 'we the kernel
> community' but you actually meant we as in 'me and you'.  Clearly you
> failed to convince me last time :)
> 
>> 	https://lkml.kernel.org/r/20180912093116.GC1089@localhost
> 
> I am totally aware this is close to code churn and any discussion is
> bikeshedding ... for me just because loads of places don't do this it
> still looks nicer to my eyes
> 
> /**
> * sfn() - Super awesome function.
> 
> than
> 
> /**
> */ sfn() - super awesome function
> 
> I most likely will keep doing these changes if I am touching the
> kernel-doc comments for other reasons and then drop the changes if the
> subsystem maintainer thinks its code churn.
> 
> I defiantly won't do theses changes in GNSS, GREYBUS, or USB SERIAL.
> 
> Oh, and I'm totally going to CC you know every time I flick one of these
> patches, prepare to get spammed :)

I have seen this discussion before also.  And sometimes it is not even
a discussion -- it's more of an edict.  To which I object/disagree.
The current (or past) comment style is perfectly fine IMO.
No caps needed.  No ending '.' needed.



-- 
~Randy
