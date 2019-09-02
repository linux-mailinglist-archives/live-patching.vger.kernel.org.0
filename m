Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1F5A5BA1
	for <lists+live-patching@lfdr.de>; Mon,  2 Sep 2019 19:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfIBRFF (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 2 Sep 2019 13:05:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36796 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbfIBRFF (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 2 Sep 2019 13:05:05 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AE181301E11C;
        Mon,  2 Sep 2019 17:05:04 +0000 (UTC)
Received: from [10.10.122.3] (ovpn-122-3.rdu2.redhat.com [10.10.122.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F03B51001B01;
        Mon,  2 Sep 2019 17:05:03 +0000 (UTC)
Subject: Re: [RFC PATCH 2/2] livepatch: Clear relocation targets on a module
 removal
To:     Miroslav Benes <mbenes@suse.cz>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Petr Mladek <pmladek@suse.com>, jikos@kernel.org,
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
 <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <5c649320-a9bf-ae7f-5102-483bc34d219f@redhat.com>
Date:   Mon, 2 Sep 2019 13:05:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.1909021802180.29987@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Mon, 02 Sep 2019 17:05:04 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 9/2/19 12:13 PM, Miroslav Benes wrote:
>> I can easily foresee more problems like those in the future.  Going
>> forward we have to always keep track of which special sections are
>> needed for which architectures.  Those special sections can change over
>> time, or can simply be overlooked for a given architecture.  It's
>> fragile.
> 
> Indeed. It bothers me a lot. Even x86 "port" is not feature complete in
> this regard (jump labels, alternatives,...) and who knows what lurks in
> the corners of the other architectures we support.
> 
> So it is in itself reason enough to do something about late module
> patching.
> 

Hi Miroslav,

I was tinkering with the "blue-sky" ideas that I mentioned to Josh the 
other day.  I dunno if you had a chance to look at what removing that 
code looks like, but I can continue to flesh out that idea if it looks 
interesting:

   https://github.com/joe-lawrence/linux/tree/blue-sky

A full demo would require packaging up replacement .ko's with a 
livepatch, as well as "blacklisting" those deprecated .kos, etc.  But 
that's all I had time to cook up last week before our holiday weekend here.

Regards,

-- Joe
