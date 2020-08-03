Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED4223AC3C
	for <lists+live-patching@lfdr.de>; Mon,  3 Aug 2020 20:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728594AbgHCSR5 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 3 Aug 2020 14:17:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24793 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727076AbgHCSR5 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 3 Aug 2020 14:17:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596478676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VMw7i1cpHh8qkyXWE10tJgStQ1flp9PULSkxAaczHSg=;
        b=UCEO7FRl8sEH8QMcLU7xvv3t9fKlWYiJwYC/PE8ek3G4WbVsNVzNhDjTeITkU8hk4m/JJH
        9i1pyu4zUzaG9WQK1mG7r4zqhn8y5M4lStmoKutTWSbetJUGcjrdXsdgJu5aMYf/wJPOUo
        6yUNthUfZq9mBH0B2TbBcPYhfRs3W/A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-fFB4_STrOvKdjZdsookBXA-1; Mon, 03 Aug 2020 14:17:46 -0400
X-MC-Unique: fFB4_STrOvKdjZdsookBXA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51F418017FB;
        Mon,  3 Aug 2020 18:17:44 +0000 (UTC)
Received: from [10.10.114.255] (ovpn-114-255.rdu2.redhat.com [10.10.114.255])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 45C4274F58;
        Mon,  3 Aug 2020 18:17:42 +0000 (UTC)
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
To:     Kees Cook <keescook@chromium.org>,
        Evgenii Shatokhin <eshatokhin@virtuozzo.com>
Cc:     Kristen Carlson Accardi <kristen@linux.intel.com>,
        Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
        live-patching@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jessica Yu <jeyu@kernel.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
 <202008031043.FE182E9@keescook>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
Date:   Mon, 3 Aug 2020 14:17:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <202008031043.FE182E9@keescook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 8/3/20 1:45 PM, Kees Cook wrote:
> On Mon, Aug 03, 2020 at 02:39:32PM +0300, Evgenii Shatokhin wrote:
>> There are at least 2 places where high-order memory allocations might happen
>> during module loading. Such allocations may fail if memory is fragmented,
>> while physically contiguous memory areas are not really needed there. I
>> suggest to switch to kvmalloc/kvfree there.
> 
> While this does seem to be the right solution for the extant problem, I
> do want to take a moment and ask if the function sections need to be
> exposed at all? What tools use this information, and do they just want
> to see the bounds of the code region? (i.e. the start/end of all the
> .text* sections) Perhaps .text.* could be excluded from the sysfs
> section list?
> 

[[cc += FChE, see [0] for Evgenii's full mail ]]

It looks like debugging tools like systemtap [1], gdb [2] and its 
add-symbol-file cmd, etc. peek at the /sys/module/<MOD>/section/ info.

But yeah, it would be preferable if we didn't export a long sysfs 
representation if nobody actually needs it.


[0] 
https://lore.kernel.org/lkml/e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com/
[1] https://fossies.org/linux/systemtap/staprun/staprun.c
[2] 
https://www.oreilly.com/library/view/linux-device-drivers/0596005903/ch04.html#linuxdrive3-CHP-4-SECT-6.1

-- Joe

