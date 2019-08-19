Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188A694953
	for <lists+live-patching@lfdr.de>; Mon, 19 Aug 2019 18:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfHSQC0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 19 Aug 2019 12:02:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726390AbfHSQC0 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 19 Aug 2019 12:02:26 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5383D3018FC6;
        Mon, 19 Aug 2019 16:02:26 +0000 (UTC)
Received: from [10.18.17.153] (dhcp-17-153.bos.redhat.com [10.18.17.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C67C7859D6;
        Mon, 19 Aug 2019 16:02:25 +0000 (UTC)
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
 <6c7e4d19-b993-1c14-d6cf-6aa1ee891361@redhat.com>
 <CAK7LNAS0Z95VT2n1o3V09bKf-rkPBMNdRryF67gpLKtnjAVAiA@mail.gmail.com>
 <alpine.LSU.2.21.1908190928520.31051@pobox.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <42254ffc-6422-19e1-62a2-6abc23fd089a@redhat.com>
Date:   Mon, 19 Aug 2019 12:02:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.1908190928520.31051@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 19 Aug 2019 16:02:26 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 8/19/19 3:31 AM, Miroslav Benes wrote:
> On Mon, 19 Aug 2019, Masahiro Yamada wrote:
> 
>>
>> I can review this series from the build system point of view,
>> but I am not familiar enough with live-patching itself.
>>
>> Some possibilities:
>>
>> [1] Merge this series thru the live-patch tree after the
>>      kbuild base patches land.
>>      This requires one extra development cycle (targeting for 5.5-rc1)
>>      but I think this is the official way if you do not rush into it.
> 
> I'd prefer this option. There is no real rush and I think we can wait one
> extra development cycle.

Agreed.  I'm in no hurry and was only curious about the kbuild changes 
that this patchset is now dependent on -- how to note them for other 
reviewers or anyone wishing to test.

> Joe, could you submit one more revision with all the recent changes (once
> kbuild improvements settle down), please? We should take a look at the
> whole thing one more time? What do you think?
>   

Definitely, yes.  I occasionally force a push to:
https://github.com/joe-lawrence/linux/tree/klp-convert-v5-expanded

as I've been updating and collecting feedback from v4.  Once updates 
settle, I'll send out a new v5 set.

-- Joe
