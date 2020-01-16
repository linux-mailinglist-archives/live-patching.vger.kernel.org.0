Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B9613F980
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2020 20:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgAPT3o (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Jan 2020 14:29:44 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26269 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729044AbgAPT3o (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Jan 2020 14:29:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579202983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XYLUC1KWAgys9j/fksF7kq8Qb7GODq8d0UQf27A4qzo=;
        b=ZZa76D9CE868aTEJaJXTgo/+6qIoE/yLZuZF8MjSYDx/dgh0EnEQlB/Wab5b+rA/9x5Wrm
        lkFC92atPW/ubzl/Qd+cU/2g67ZdIyYbK1wBjUHJZrbu9Ea3tB4LlXjn9dKydBheDRB8Dt
        1lwq+1MnQXY1whxrIZipkVQ3E1qcTYw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-sJOwTwPEN8OLfffbnRrttQ-1; Thu, 16 Jan 2020 14:29:39 -0500
X-MC-Unique: sJOwTwPEN8OLfffbnRrttQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC04118A8C80;
        Thu, 16 Jan 2020 19:29:37 +0000 (UTC)
Received: from [10.18.17.119] (dhcp-17-119.bos.redhat.com [10.18.17.119])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C1DCE100032E;
        Thu, 16 Jan 2020 19:29:36 +0000 (UTC)
Subject: Re: [PATCH 0/4] livepatch/samples/selftest: Clean up show variables
 handling
To:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>
Cc:     Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Nicolai Stange <nstange@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200116153145.2392-1-pmladek@suse.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <e427439b-ed65-3418-e7ca-a60e54bd5544@redhat.com>
Date:   Thu, 16 Jan 2020 14:29:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200116153145.2392-1-pmladek@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 1/16/20 10:31 AM, Petr Mladek wrote:
> Dan Carpenter reported suspicious allocations of shadow variables
> in the sample module, see
> https://lkml.kernel.org/r/20200107132929.ficffmrm5ntpzcqa@kili.mountain
> 
> The code did not cause a real problem. But it was indeed misleading
> and semantically wrong. I got confused several times when cleaning it.
> So I decided to split the change into few steps. I hope that
> it will help reviewers and future readers.
> 
> The changes of the sample module are basically the same as in the RFC.
> In addition, there is a clean up of the module used by the selftest.
> 
> 
> Petr Mladek (4):
>    livepatch/sample: Use the right type for the leaking data pointer
>    livepatch/selftest: Clean up shadow variable names and type
>    livepatch/samples/selftest: Use klp_shadow_alloc() API correctly
>    livepatch: Handle allocation failure in the sample of shadow variable
>      API
> 
>   lib/livepatch/test_klp_shadow_vars.c      | 119 +++++++++++++++++-------------
>   samples/livepatch/livepatch-shadow-fix1.c |  39 ++++++----
>   samples/livepatch/livepatch-shadow-fix2.c |   4 +-
>   samples/livepatch/livepatch-shadow-mod.c  |   4 +-
>   4 files changed, 99 insertions(+), 67 deletions(-)
> 

Hi Petr,

These are good cleanups, thanks for the fixes and tidying up all the 
pointer/value indirections.

Reviewed-by: Joe Lawrence <joe.lawrence@redhat.com>

-- Joe

