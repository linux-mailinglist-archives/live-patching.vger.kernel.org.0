Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 263FF94938
	for <lists+live-patching@lfdr.de>; Mon, 19 Aug 2019 17:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727642AbfHSPzV (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 19 Aug 2019 11:55:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45192 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726373AbfHSPzV (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 19 Aug 2019 11:55:21 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 06BE2301D678;
        Mon, 19 Aug 2019 15:55:21 +0000 (UTC)
Received: from [10.18.17.153] (dhcp-17-153.bos.redhat.com [10.18.17.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 76FE752CE;
        Mon, 19 Aug 2019 15:55:20 +0000 (UTC)
Subject: Re: [PATCH v4 06/10] modpost: Add modinfo flag to livepatch modules
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
References: <20190509143859.9050-1-joe.lawrence@redhat.com>
 <20190509143859.9050-7-joe.lawrence@redhat.com>
 <CAK7LNAQuS-YcXecfJ21BGzc0CimzWxQcYST5-1xRgnCQGtcL4A@mail.gmail.com>
 <20190812155626.GA19845@redhat.com>
 <CAK7LNATRLTBqA9c=b+Y38T-zWc9o5JMq18r9auA=enPC=p10pA@mail.gmail.com>
 <alpine.LSU.2.21.1908161016430.2020@pobox.suse.cz>
 <6c7e4d19-b993-1c14-d6cf-6aa1ee891361@redhat.com>
 <163ad1fb-ccbf-0a3e-d795-2bb748a0e88f@redhat.com>
 <CAK7LNAR-1qXUhZ=cKUK2WEg5WeinXgFf1B2rq-=Oke4CUucp_g@mail.gmail.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <9127bdf6-1daf-0387-88fb-6f1118dd6804@redhat.com>
Date:   Mon, 19 Aug 2019 11:55:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAK7LNAR-1qXUhZ=cKUK2WEg5WeinXgFf1B2rq-=Oke4CUucp_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 19 Aug 2019 15:55:21 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 8/18/19 11:50 PM, Masahiro Yamada wrote:
> Hi Joe,
> 
> On Sat, Aug 17, 2019 at 4:01 AM Joe Lawrence <joe.lawrence@redhat.com> wrote:
>>
>>
>> I didn't realize that we're supposed to be able to still build external
>> modules after "make clean".  If that's the case, then one might want to
>> build an external klp-module after doing that.
> 
> Yes. 'make clean' must keep all the build artifacts
> needed for building external modules.
> 
> 
>> With that in mind, shouldn't Symbols.list to persist until mrproper?
>> And I think modules-livepatch could go away during clean, what do you think?
>>
>> -- Joe
> 
> 
> Symbols.list should be kept by the time mrproper is run.
> So, please add it to MRROPER_FILES instead of CLEAN_FILES.
> 
> modules.livepatch is a temporary file, so you can add it to
> CLEAN_FILES.
> 

OK, I'll add those to their respective lists.

> How is this feature supposed to work for external modules?
> 
> klp-convert receives:
> "symbols from vmlinux" + "symbols from no-klp in-tree modules"
> + "symbols from no-klp external modules" ??
> 

I don't think that this use-case has been previously thought out 
(Miroslav, correct me if I'm wrong here.)

I did just run an external build of a copy of 
samples/livepatch/livepatch-annotated-sample.c:

  - modules.livepatch is generated in external dir
  - klp-convert is invoked for the livepatch module
  - the external livepatch module successfully loads

But that was only testing external livepatch modules.

I don't know if we need/want to support general external modules 
supplementing Symbols.list, at least for the initial klp-convert commit. 
  I suppose external livepatch modules would then need to specify 
additional Symbols.list(s) files somehow as well.

> 
> BTW, 'Symbols.list' sounds like a file to list out symbols
> for generic purposes, but in fact, the
> file format is very specific for the klp-convert tool.
> Perhaps, is it better to rename it so it infers
> this is for livepatching? What do you think?
> 

I don't know if the "Symbols.list" name and leading uppercase was based 
on any convention, but something like symbols.klp would be fine with me.

Thanks,

-- Joe
