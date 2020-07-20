Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75FB225630
	for <lists+live-patching@lfdr.de>; Mon, 20 Jul 2020 05:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgGTDf1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Sun, 19 Jul 2020 23:35:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39796 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726161AbgGTDf0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Sun, 19 Jul 2020 23:35:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595216125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D7FqMYqDvd7eDbuQSOuxX0aLldcdVgd76BMYePyueXY=;
        b=T17Vkc70mXKk4ZP0enbSDKVxJkZER+jSyDARcSRr4Ic2gtNEarl1m4nduWemeaFc9xAEy9
        NaRcxA3KRy/S8iZJ6Gk4p4F86ozXF1nvq/p59Jdst3HT8A29/lKpu6MfPjeFQVrRr9b30g
        79k1r/sY/S6zdqUvk+WrEemSNv63yG8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-sByBR4xhPNSvCj3WC_n2Ig-1; Sun, 19 Jul 2020 23:35:23 -0400
X-MC-Unique: sByBR4xhPNSvCj3WC_n2Ig-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CE89E91A;
        Mon, 20 Jul 2020 03:35:21 +0000 (UTC)
Received: from [10.10.114.255] (ovpn-114-255.rdu2.redhat.com [10.10.114.255])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1F3FF7849A;
        Mon, 20 Jul 2020 03:35:21 +0000 (UTC)
Subject: Re: [PATCH] Revert "kbuild: use -flive-patching when CONFIG_LIVEPATCH
 is enabled"
To:     Josh Poimboeuf <jpoimboe@redhat.com>, live-patching@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>
References: <696262e997359666afa053fe7d1a9fb2bb373964.1595010490.git.jpoimboe@redhat.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <fc7d4932-a043-1adc-fd9b-96211c508f64@redhat.com>
Date:   Sun, 19 Jul 2020 23:35:20 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <696262e997359666afa053fe7d1a9fb2bb373964.1595010490.git.jpoimboe@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 7/17/20 2:29 PM, Josh Poimboeuf wrote:
> Use of the new -flive-patching flag was introduced with the following
> commit:
> 
>    43bd3a95c98e ("kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled")
> 
> This flag has several drawbacks:
> 
> [ ... snip ... ]
> 
> - While there *is* a distro which relies on this flag for their distro
>    livepatch module builds, there's not a publicly documented way to
>    create safe livepatch modules with it.  Its use seems to be based on
>    tribal knowledge.  It serves no benefit to those who don't know how to
>    use it.
> 
>    (In fact, I believe the current livepatch documentation and samples
>    are misleading and dangerous, and should be corrected.  Or at least
>    amended with a disclaimer.  But I don't feel qualified to make such
>    changes.)

FWIW, I'm not exactly qualified to document source-based creation 
either, however I have written a few of the samples and obviously the 
kselftest modules.

The samples should certainly include a disclaimer (ie, they are only for 
API demonstration purposes!) and eventually it would be great if the 
kselftest modules could guarantee their safety as well.  I don't know 
quite yet how we can automate that, but perhaps some kind of post-build 
sanity check could verify that they are in fact patching what they 
intend to patch.

As for a more general, long-form warning about optimizations, I grabbed 
Miroslav's LPC slides from a few years back and poked around at some 
IPA-optimized disassembly... Here are my notes that attempt to capture 
some common cases:

http://file.bos.redhat.com/~jolawren/klp-compiler-notes/livepatch/compiler-considerations.html

It's not complete and I lost steam about 80% of the way through today. 
:)  But if it looks useful enough to add to Documentation/livepatch, we 
can work on it on-list and try to steer folks into using the automated 
kpatch-build, objtool (eventually) or a source-based safety checklist. 
The source-based steps have been posted on-list a few times, but I think 
it only needs to be formalized in a doc.

-- Joe

