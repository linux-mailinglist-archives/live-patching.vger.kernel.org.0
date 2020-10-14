Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7449E28E88E
	for <lists+live-patching@lfdr.de>; Wed, 14 Oct 2020 23:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgJNVsY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 14 Oct 2020 17:48:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21932 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726662AbgJNVsY (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 14 Oct 2020 17:48:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602712103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=snX9o7DRIpAEdg6HdWJTexdGEfZH+xbF9NPXzawREdU=;
        b=jTT5y8dAh0XCKmgvxRHa0/yW2sjj927nZ9S8A+TahwWalbKAk4tW+rVV5fzNkwuOdhe4Vm
        C4mmuwl15v0EyU/hcbsA7//VRSUt2XZWrwnRdIITe8lOVACwlhR+QykTpFsUWCTm6OoAL4
        u6XAu8jjdlcGVVHLhMDBfLjUCBvC9Cw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-UowkHB-JMf6i3WhhTy1oog-1; Wed, 14 Oct 2020 17:48:19 -0400
X-MC-Unique: UowkHB-JMf6i3WhhTy1oog-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 26EB7186DD23;
        Wed, 14 Oct 2020 21:48:18 +0000 (UTC)
Received: from [10.10.116.197] (ovpn-116-197.rdu2.redhat.com [10.10.116.197])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D63010013C1;
        Wed, 14 Oct 2020 21:48:17 +0000 (UTC)
Subject: Re: [PATCH] selftests/livepatch: Do not check order when using "comm"
 for dmesg checking
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Miroslav Benes <mbenes@suse.cz>, jpoimboe@redhat.com,
        pmladek@suse.com, shuah@kernel.org, live-patching@vger.kernel.org
References: <20200827110709.26824-1-mbenes@suse.cz>
 <20200827132058.GA24622@redhat.com>
 <nycvar.YFH.7.76.2008271528000.27422@cbobk.fhfr.pm>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <bd7b15d6-1796-9fb4-bf52-14bcd981458d@redhat.com>
Date:   Wed, 14 Oct 2020 17:48:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <nycvar.YFH.7.76.2008271528000.27422@cbobk.fhfr.pm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 8/27/20 9:28 AM, Jiri Kosina wrote:
> On Thu, 27 Aug 2020, Joe Lawrence wrote:
> 
>>> , "comm" fails with "comm: file 2 is not in sorted order". Suppress the
>>> order checking with --nocheck-order option.
>>>
>>> Signed-off-by: Miroslav Benes <mbenes@suse.cz>
>>
>> Acked-by: Joe Lawrence <joe.lawrence@redhat.com>
>>
>> And not so important for selftests, but helpful for backporting efforts:
>>
>> Fixes: 2f3f651f3756 ("selftests/livepatch: Use "comm" instead of "diff" for dmesg")
> 
> I've added the Fixes: tag and applied to for-5.9/upstream-fixes. Thanks,
> 

Hi Jiri,

I was looking at a list of livepatching commits that went into 5.9 for 
backporting and was wondering if we ever merged this one?

It's not a show-stopper, but would be nice to get this one in for 5.10 
if possible.

Thanks,

-- Joe

