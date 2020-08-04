Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7180923BE85
	for <lists+live-patching@lfdr.de>; Tue,  4 Aug 2020 19:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgHDRFj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 4 Aug 2020 13:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:59230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728244AbgHDRFN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 4 Aug 2020 13:05:13 -0400
Received: from linux-8ccs (p57a236d4.dip0.t-ipconnect.de [87.162.54.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 158C4207FC;
        Tue,  4 Aug 2020 17:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596560669;
        bh=NfFOur+2uJBT2CYsYqIKkCO828wrRIoMoBW74zXNLOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n+e1woa8+9O8XHHYjFSWLqeRpRx6enaexRX7sKQfy051cr/iLoAwsezENBZr3mESG
         9Yd/w5qDUouv+KikFNI/PiizqAMJJJ3W9XA2gjAQYEzvSx0NDrGa7B5VTrV1EBeLql
         /bS4aa4q4sAlAv7ki/Tc3yK8cG1ddnNJpRtMF7as=
Date:   Tue, 4 Aug 2020 19:04:21 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Evgenii Shatokhin <eshatokhin@virtuozzo.com>,
        Kristen Carlson Accardi <kristen@linux.intel.com>,
        Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
        live-patching@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
Message-ID: <20200804170419.GA3882@linux-8ccs>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com>
 <202008031043.FE182E9@keescook>
 <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <fc6d2289-af97-5cf8-a4bb-77c2b0b8375c@redhat.com>
X-OS:   Linux linux-8ccs 5.8.0-rc6-lp150.12.61-default+ x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Joe Lawrence [03/08/20 14:17 -0400]:
>On 8/3/20 1:45 PM, Kees Cook wrote:
>>On Mon, Aug 03, 2020 at 02:39:32PM +0300, Evgenii Shatokhin wrote:
>>>There are at least 2 places where high-order memory allocations might happen
>>>during module loading. Such allocations may fail if memory is fragmented,
>>>while physically contiguous memory areas are not really needed there. I
>>>suggest to switch to kvmalloc/kvfree there.

Thanks Evgenii for pointing out the potential memory allocation issues
that may arise with very large modules when memory is fragmented. I was curious
as to which modules on my machine would be considered large, and there seems to be
quite a handful...(x86_64 with v5.8-rc6 with a relatively standard distro config and
FG KASLR patches on top):

./amdgpu/sections 7277
./i915/sections 4267
./nouveau/sections 3772
./xfs/sections 2395
./btrfs/sections 1966
./mac80211/sections 1588
./kvm/sections 1468
./cfg80211/sections 1194
./drm/sections 1012
./bluetooth/sections 843
./iwlmvm/sections 664
./usbcore/sections 524
./videodev/sections 436

So, I agree with the suggestion that we could switch to kvmalloc() to
try to mitigate potential allocation problems when memory is fragmented.

>>While this does seem to be the right solution for the extant problem, I
>>do want to take a moment and ask if the function sections need to be
>>exposed at all? What tools use this information, and do they just want
>>to see the bounds of the code region? (i.e. the start/end of all the
>>.text* sections) Perhaps .text.* could be excluded from the sysfs
>>section list?
>
>[[cc += FChE, see [0] for Evgenii's full mail ]]
>
>It looks like debugging tools like systemtap [1], gdb [2] and its 
>add-symbol-file cmd, etc. peek at the /sys/module/<MOD>/section/ info.
>
>But yeah, it would be preferable if we didn't export a long sysfs 
>representation if nobody actually needs it.

Thanks Joe for looking into this. Hmm, AFAICT for gdb it's not a hard
dependency per se - for add-symbol-file I was under the impression
that we are responsible for obtaining the relevant section addresses
ourselves through /sys/module/ (the most oft cited method) and then
feeding those to add-symbol-file. It would definitely be more
difficult to find out the section addresses without the /sys/module/
section entries. In any case, it sounds like systemtap has a hard
dependency on /sys/module/*/sections anyway.

Regarding /proc/kallsyms, I think it is probably possible to expose
section symbols and their addresses via /proc/kallsyms rather than
through sysfs (it would then live in the module's vmalloc'ed memory)
but I'm not sure how helpful that would actually be, especially since
existing tools depend on the sysfs interface being there.

>[0] https://lore.kernel.org/lkml/e9c4d88b-86db-47e9-4299-3fac45a7e3fd@virtuozzo.com/
>[1] https://fossies.org/linux/systemtap/staprun/staprun.c
>[2] https://www.oreilly.com/library/view/linux-device-drivers/0596005903/ch04.html#linuxdrive3-CHP-4-SECT-6.1
>
>-- Joe
