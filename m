Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06401232353
	for <lists+live-patching@lfdr.de>; Wed, 29 Jul 2020 19:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgG2R0E (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Jul 2020 13:26:04 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38311 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726336AbgG2R0E (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Jul 2020 13:26:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596043563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ECKupviQ1aLptZ6EkNAq107u67VqawNacT22OAEjUAo=;
        b=ObaJwPdFTRpBvqKRpd3h1+OzutDoaVjhRHBU+YpmmYye1/d5j09uw5kCy5hWE4Cu8WP94O
        UNz98wTBM6OGjbUzuJeS1M07ybI16WV6w38jzvNxdTVZW1bLB02UNQQdtHLr20k8iQitWs
        1kfNzcQAxRZLvBxgeFiVWJ+hJvmzRKQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-ytXqQt6-MB-0Od1-PiTpdQ-1; Wed, 29 Jul 2020 13:26:01 -0400
X-MC-Unique: ytXqQt6-MB-0Od1-PiTpdQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4016107BEF5;
        Wed, 29 Jul 2020 17:25:59 +0000 (UTC)
Received: from [10.10.114.255] (ovpn-114-255.rdu2.redhat.com [10.10.114.255])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 26D3010098AA;
        Wed, 29 Jul 2020 17:25:59 +0000 (UTC)
Subject: Re: [PATCH 2/7] modules: mark find_symbol static
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jessica Yu <jeyu@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        open list <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org
References: <20200729062711.13016-1-hch@lst.de>
 <20200729062711.13016-3-hch@lst.de> <20200729161318.GA30898@linux-8ccs>
 <20200729162435.GB3664300@kroah.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <486d82d8-0fab-b662-ff6c-fb36c3150ea3@redhat.com>
Date:   Wed, 29 Jul 2020 13:25:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200729162435.GB3664300@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 7/29/20 12:24 PM, Greg Kroah-Hartman wrote:
> On Wed, Jul 29, 2020 at 06:13:18PM +0200, Jessica Yu wrote:
>> +++ Christoph Hellwig [29/07/20 08:27 +0200]:
>>> find_symbol is only used in module.c.
>>>
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> CCing the livepatching ML, as this may or may not impact its users.
>>
>> AFAIK, the out-of-tree kpatch module had used find_symbol() in the
>> past, I am not sure what its current status is. I suspect all of its
>> functionality has been migrated to upstream livepatch already.
> 
> We still have symbol_get(), which is what I thought they were using.
> 

The deprecated (though still in the repo) kpatch.ko still references 
find_symbol(), but that module is no longer officially supported by the 
project.

Jessica is correct that the functionality has been migrated upstream.

I don't see any references to symbol_get() either, so we're good on that 
front, too.

Thanks,

-- Joe

