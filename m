Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13ABC90805
	for <lists+live-patching@lfdr.de>; Fri, 16 Aug 2019 21:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfHPTBW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Aug 2019 15:01:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45226 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbfHPTBW (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Aug 2019 15:01:22 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F8DF30821A1;
        Fri, 16 Aug 2019 19:01:22 +0000 (UTC)
Received: from [10.10.123.64] (ovpn-123-64.rdu2.redhat.com [10.10.123.64])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 81D625C1D6;
        Fri, 16 Aug 2019 19:01:21 +0000 (UTC)
Subject: Re: [PATCH v4 06/10] modpost: Add modinfo flag to livepatch modules
From:   Joe Lawrence <joe.lawrence@redhat.com>
To:     Miroslav Benes <mbenes@suse.cz>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
 <20190509143859.9050-7-joe.lawrence@redhat.com>
 <CAK7LNAQuS-YcXecfJ21BGzc0CimzWxQcYST5-1xRgnCQGtcL4A@mail.gmail.com>
 <20190812155626.GA19845@redhat.com>
 <CAK7LNATRLTBqA9c=b+Y38T-zWc9o5JMq18r9auA=enPC=p10pA@mail.gmail.com>
 <alpine.LSU.2.21.1908161016430.2020@pobox.suse.cz>
 <6c7e4d19-b993-1c14-d6cf-6aa1ee891361@redhat.com>
Message-ID: <163ad1fb-ccbf-0a3e-d795-2bb748a0e88f@redhat.com>
Date:   Fri, 16 Aug 2019 15:01:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <6c7e4d19-b993-1c14-d6cf-6aa1ee891361@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Fri, 16 Aug 2019 19:01:22 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 8/16/19 8:43 AM, Joe Lawrence wrote:
> On 8/16/19 4:19 AM, Miroslav Benes wrote:
>> Hi,
>>
>>> I cleaned up the build system, and pushed it based on my
>>> kbuild tree.
>>>
>>> Please see:
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git
>>> klp-cleanup
>>
>> This indeed looks much simpler and cleaner (as far as I can judge with my
>> limited kbuild knowledge). We just need to remove MODULE_INFO(livepatch,
>> "Y") from lib/livepatch/test_klp_convert_mod_a.c to make it compile and
>> work (test_klp_convert_mod_a is not a livepatch module, it is just a dummy
>> module which is then livepatched by lib/livepatch/test_klp_convert1.c).
>>
> 
> Yeah, Masahiro this is great, thanks for reworking this!
> 
> I did tweak one module like Miroslav mentioned and I think a few of the
> newly generated files need to be cleaned up as part of "make clean", but
> all said, this is a nice improvement.
> 

Well actually, now I see this comment in the top-level Makefile:

# Cleaning is done on three levels. 

# make clean     Delete most generated files 

#                Leave enough to build external modules 

# make mrproper  Delete the current configuration, and all generated 
files
# make distclean Remove editor backup files, patch leftover files and 
the like

I didn't realize that we're supposed to be able to still build external 
modules after "make clean".  If that's the case, then one might want to 
build an external klp-module after doing that.

With that in mind, shouldn't Symbols.list to persist until mrproper? 
And I think modules-livepatch could go away during clean, what do you think?

-- Joe
