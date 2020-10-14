Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCDD28E8B2
	for <lists+live-patching@lfdr.de>; Thu, 15 Oct 2020 00:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbgJNWPO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Oct 2020 18:15:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57605 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726747AbgJNWPO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Oct 2020 18:15:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602713713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JlJsaBWhmIzvkxrz8wAnmAMQ4TeEmSvfpLXmVAXHzMY=;
        b=ILEYsnC7tJwifeSQcaA1RRgOfpvGF88aYTwtJrVRcvxWRQ60kLLh1wXJauTigRkF/FZ2vT
        DxMN3VdO1YmPq8LFUs6P4MK6BDoC9buEMnOmSuee9FIDutH7WsbXm7dH0JH/akduonk4Mx
        qcNIaN+5iH0oX9aJeXx9nDYINTfoR3k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-PGFUK4zOOPKzHHMc66q4tw-1; Wed, 14 Oct 2020 18:15:10 -0400
X-MC-Unique: PGFUK4zOOPKzHHMc66q4tw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 748F61007464;
        Wed, 14 Oct 2020 22:15:09 +0000 (UTC)
Received: from [10.10.116.197] (ovpn-116-197.rdu2.redhat.com [10.10.116.197])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CA0E76666;
        Wed, 14 Oct 2020 22:15:08 +0000 (UTC)
Subject: Re: [PATCH] selftests/livepatch: Do not check order when using "comm"
 for dmesg checking
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Miroslav Benes <mbenes@suse.cz>, jpoimboe@redhat.com,
        pmladek@suse.com, shuah@kernel.org, live-patching@vger.kernel.org
References: <20200827110709.26824-1-mbenes@suse.cz>
 <20200827132058.GA24622@redhat.com>
 <nycvar.YFH.7.76.2008271528000.27422@cbobk.fhfr.pm>
 <bd7b15d6-1796-9fb4-bf52-14bcd981458d@redhat.com>
 <nycvar.YFH.7.76.2010142352470.18859@cbobk.fhfr.pm>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <27dcc2b9-1ff3-1b18-bf90-ecdf0b8e96d8@redhat.com>
Date:   Wed, 14 Oct 2020 18:15:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <nycvar.YFH.7.76.2010142352470.18859@cbobk.fhfr.pm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 10/14/20 5:53 PM, Jiri Kosina wrote:
> On Wed, 14 Oct 2020, Joe Lawrence wrote:
> 
>>>> Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
>>>>
>>>> And not so important for selftests, but helpful for backporting efforts:
>>>>
>>>> Fixes: 2f3f651f3756 ("selftests/livepatch: Use "comm" instead of "diff" for
>>>> dmesg")
>>>
>>> I've added the Fixes: tag and applied to for-5.9/upstream-fixes. Thanks,
>>>
>>
>> Hi Jiri,
>>
>> I was looking at a list of livepatching commits that went into 5.9 for
>> backporting and was wondering if we ever merged this one?
>>
>> It's not a show-stopper, but would be nice to get this one in for 5.10 if
>> possible.
> 
> Hi Joe,
> 
> it was not enough of a trigger to actually send 5.9-rc pull request. But
> in cases like this, for-5.x/upstream-fixes branch gets included in 5.x+1
> pull request. So it absolutely will land in 5.10.
> 

Ah ok, I agree holding onto that one that makes sense.  The branch name 
threw me off, so I thought I'd ping.

Thanks,

-- Joe

