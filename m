Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73C4E901DF
	for <lists+live-patching@lfdr.de>; Fri, 16 Aug 2019 14:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfHPMnk (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 16 Aug 2019 08:43:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47714 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726075AbfHPMnk (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 16 Aug 2019 08:43:40 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3C907308302F;
        Fri, 16 Aug 2019 12:43:40 +0000 (UTC)
Received: from [10.10.123.64] (ovpn-123-64.rdu2.redhat.com [10.10.123.64])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 751431719E;
        Fri, 16 Aug 2019 12:43:39 +0000 (UTC)
Subject: Re: [PATCH v4 06/10] modpost: Add modinfo flag to livepatch modules
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
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <6c7e4d19-b993-1c14-d6cf-6aa1ee891361@redhat.com>
Date:   Fri, 16 Aug 2019 08:43:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.1908161016430.2020@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 16 Aug 2019 12:43:40 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 8/16/19 4:19 AM, Miroslav Benes wrote:
> Hi,
> 
>> I cleaned up the build system, and pushed it based on my
>> kbuild tree.
>>
>> Please see:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git
>> klp-cleanup
> 
> This indeed looks much simpler and cleaner (as far as I can judge with my
> limited kbuild knowledge). We just need to remove MODULE_INFO(livepatch,
> "Y") from lib/livepatch/test_klp_convert_mod_a.c to make it compile and
> work (test_klp_convert_mod_a is not a livepatch module, it is just a dummy
> module which is then livepatched by lib/livepatch/test_klp_convert1.c).
> 

Yeah, Masahiro this is great, thanks for reworking this!

I did tweak one module like Miroslav mentioned and I think a few of the 
newly generated files need to be cleaned up as part of "make clean", but 
all said, this is a nice improvement.

Are you targeting the next merge window for your kbuild branch?  (This 
appears to be what the klp-cleanup branch was based on.)

Thanks,

-- Joe
