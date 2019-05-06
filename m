Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0151C14A92
	for <lists+live-patching@lfdr.de>; Mon,  6 May 2019 15:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725813AbfEFNJR (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 May 2019 09:09:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58868 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbfEFNJR (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 May 2019 09:09:17 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EF7573082EF1;
        Mon,  6 May 2019 13:09:16 +0000 (UTC)
Received: from [10.18.17.208] (dhcp-17-208.bos.redhat.com [10.18.17.208])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A21E611D7;
        Mon,  6 May 2019 13:09:15 +0000 (UTC)
Subject: Re: [PATCH 0/2] livepatch/docs: Convert livepatch documentation to
 the ReST format
To:     Petr Mladek <pmladek@suse.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, live-patching@vger.kernel.org
References: <20190503143024.28358-1-pmladek@suse.com>
 <20190503151730.GC24094@redhat.com>
 <20190506123213.zpgs6byhbgs2cffb@pathway.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <2d751cba-b9c1-c9ef-17d8-76d768e32d46@redhat.com>
Date:   Mon, 6 May 2019 09:09:15 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190506123213.zpgs6byhbgs2cffb@pathway.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 06 May 2019 13:09:17 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 5/6/19 8:32 AM, Petr Mladek wrote:
> On Fri 2019-05-03 11:17:30, Joe Lawrence wrote:
>> On Fri, May 03, 2019 at 04:30:22PM +0200, Petr Mladek wrote:
>>> This is the original Mauro's patch and my extra fixup as a clean
>>> patchset.
>>>
>>> I want to be sure that other livepatching maintainers are fine
>>> with the changes ;-)
>>>
>>>
>>> Mauro Carvalho Chehab (1):
>>>    docs: livepatch: convert docs to ReST and rename to *.rst
>>>
>>> Petr Mladek (1):
>>>    docs/livepatch: Unify style of livepatch documentation in the ReST
>>>      format
>>>
>>>   Documentation/ABI/testing/sysfs-kernel-livepatch   |   2 +-
>>>   .../livepatch/{callbacks.txt => callbacks.rst}     |  45 +--
>>>   ...mulative-patches.txt => cumulative-patches.rst} |  14 +-
>>>   Documentation/livepatch/index.rst                  |  21 ++
>>>   .../livepatch/{livepatch.txt => livepatch.rst}     |  62 ++--
>>>   ...module-elf-format.txt => module-elf-format.rst} | 353 +++++++++++----------
>>>   .../livepatch/{shadow-vars.txt => shadow-vars.rst} |  65 ++--
>>>   tools/objtool/Documentation/stack-validation.txt   |   2 +-
>>>   8 files changed, 307 insertions(+), 257 deletions(-)
>>>   rename Documentation/livepatch/{callbacks.txt => callbacks.rst} (87%)
>>>   rename Documentation/livepatch/{cumulative-patches.txt => cumulative-patches.rst} (89%)
>>>   create mode 100644 Documentation/livepatch/index.rst
>>>   rename Documentation/livepatch/{livepatch.txt => livepatch.rst} (93%)
>>>   rename Documentation/livepatch/{module-elf-format.txt => module-elf-format.rst} (55%)
>>>   rename Documentation/livepatch/{shadow-vars.txt => shadow-vars.rst} (87%)
>>>
>>> -- 
>>> 2.16.4
>>>
>>
>> Hi Petr,
>>
>> >From a quick look at the 'make htmldocs' output, these look good.
> 
> Thanks for the look.
> 
>> I did notice that callbacks.rst updated "commit ("desc")" formatting,
>> but shadow-vars.rst did not.  If you want to defer that nitpick until a
>> larger formatting linting, I'd be fine with that.
> 
> If this is the only problem than I would defer it ;-)
> 

Yeah, we can update next time :)

Thanks to you and Mauro for the conversions.

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

-- Joe
