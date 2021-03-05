Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8217A32EF83
	for <lists+live-patching@lfdr.de>; Fri,  5 Mar 2021 17:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbhCEQAY (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 5 Mar 2021 11:00:24 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35253 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229465AbhCEQAU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 5 Mar 2021 11:00:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614960019;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tMFDf9/VQqzgB3HMa/pgJ1GSD4Q0k9QkIQ3iQdoAib0=;
        b=YpT4yT7v7tQxCEvqpJ4Eo00+95PgK+lZxmAM11ugBkchEryCFhSSIN8RBgJIMfeDWUyFlC
        48ALPnT3+a743GBKfTM//5Vg2Mx9Pdvg6wvLUay11n/V4byhx9St0MBE2a7vlkDmnsBs2/
        HJRNi7I+uNQ+J6s7M/5H3MmcuLvVANE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-PKFWD34XOImkvUENlYeWug-1; Fri, 05 Mar 2021 11:00:15 -0500
X-MC-Unique: PKFWD34XOImkvUENlYeWug-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 213021005D4F;
        Fri,  5 Mar 2021 16:00:12 +0000 (UTC)
Received: from [10.10.112.212] (ovpn-112-212.rdu2.redhat.com [10.10.112.212])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EFD7218AD6;
        Fri,  5 Mar 2021 16:00:10 +0000 (UTC)
Subject: Re: [PATCH V2] docs: livepatch: Fix a typo and remove the unnecessary
 gaps in a sentence
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Matthew Wilcox <willy@infradead.org>, jpoimboe@redhat.com,
        jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com, corbet@lwn.net,
        live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
References: <20210305100923.3731-1-unixbhaskar@gmail.com>
 <20210305125600.GM2723601@casper.infradead.org> <YEI0EcR5G53IoYzb@Gentoo>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <f8b10ee7-026c-1dc0-fb0c-2a887cd1e953@redhat.com>
Date:   Fri, 5 Mar 2021 11:00:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEI0EcR5G53IoYzb@Gentoo>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 3/5/21 8:37 AM, Bhaskar Chowdhury wrote:
> On 12:56 Fri 05 Mar 2021, Matthew Wilcox wrote:
>> On Fri, Mar 05, 2021 at 03:39:23PM +0530, Bhaskar Chowdhury wrote:
>>> s/varibles/variables/
>>>
>>> ...and remove leading spaces from a sentence.
>>
>> What do you mean 'leading spaces'?  Separating two sentences with
>> one space or two is a matter of personal style, and we do not attempt
>> to enforce a particular style in the kernel.
>>
> The spaces before the "In" .. nor I am imposing anything , it was peter caught
> and told me that it is hanging ..move it to the next line ..so I did. ..
> 

Initially I thought the same as Matthew, but after inspecting the diff I 
realized it was just a line wrap.  Looks fine to me.

>>>   Sometimes it may not be convenient or possible to allocate shadow
>>>   variables alongside their parent objects.  Or a livepatch fix may
>>> -require shadow varibles to only a subset of parent object instances.  In
>>> +require shadow variables to only a subset of parent object instances.
>>
>> wrong preposition, s/to/for/    ..where???

Hi Bhaskar,

Thanks for spotting, I'd be happy with v2 as is or a v3 if you want to 
update s/shadow variables to only/shadow variables for only/  but 
knowing me, I probably repeated the same phrasing elsewhere.  Up to you, 
thanks.

Acked-by: Joe Lawrence <joe.lawrence@redhat.com>

-- Joe

