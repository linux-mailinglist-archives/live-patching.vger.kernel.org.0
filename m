Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64595DEF12
	for <lists+live-patching@lfdr.de>; Mon, 21 Oct 2019 16:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbfJUOO2 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 21 Oct 2019 10:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727755AbfJUOO1 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 21 Oct 2019 10:14:27 -0400
Received: from linux-8ccs (ip5f5ade6e.dynamic.kabel-deutschland.de [95.90.222.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3155B2070B;
        Mon, 21 Oct 2019 14:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571667267;
        bh=98/rw92U38HfDyMvYsaewyrwIf2e6BuR1DViSORVjRQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MnxJeEFB6wdl44jT4E/5wuvnJNxyRNEna/A9nRCk1jowhbtIlOkjQ3m3U3ICPWxHb
         jGq1m9zoRNxCngb4XoSQG4AyM1wulqdzFvFYsACPvtcoqewnv6aZU08MLWtnxcRAvr
         Qzx7knnSRijxzyGwtiwXcrBr/QV0cE8kL6dDlQg8=
Date:   Mon, 21 Oct 2019 16:14:20 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Joe Lawrence <joe.lawrence@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jpoimboe@redhat.com,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
Message-ID: <20191021141419.GB21112@linux-8ccs>
References: <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz>
 <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
 <20191015153120.GA21580@linux-8ccs>
 <7e9c7dd1-809e-f130-26a3-3d3328477437@redhat.com>
 <20191015182705.1aeec284@gandalf.local.home>
 <20191016074951.GM2328@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.1910161216100.7750@pobox.suse.cz>
 <alpine.LSU.2.21.1910161521010.7750@pobox.suse.cz>
 <20191018130342.GA4625@linux-8ccs>
 <20191018134058.7zyls4746wpa7jy5@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191018134058.7zyls4746wpa7jy5@pathway.suse.cz>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.28-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Petr Mladek [18/10/19 15:40 +0200]:
>On Fri 2019-10-18 15:03:42, Jessica Yu wrote:
>> +++ Miroslav Benes [16/10/19 15:29 +0200]:
>> > On Wed, 16 Oct 2019, Miroslav Benes wrote:
>> > Thinking about it more... crazy idea. I think we could leverage these new
>> > ELF .text per vmlinux/module sections for the reinvention I was talking
>> > about. If we teach module loader to relocate (and apply alternatives and
>> > so on, everything in arch-specific module_finalize()) not the whole module
>> > in case of live patch modules, but separate ELF .text sections, it could
>> > solve the issue with late module patching we have. It is a variation on
>> > Steven's idea. When live patch module is loaded, only its section for
>> > present modules would be processed. Then whenever a to-be-patched module
>> > is loaded, its .text section in all present patch module would be
>> > processed.
>> >
>> > The upside is that almost no work would be required on patch modules
>> > creation side. The downside is that klp_modinfo must stay. Module loader
>> > needs to be hacked a lot in both cases. So it remains to be seen which
>> > idea is easier to implement.
>> >
>> > Jessica, do you think it would be feasible?
>>
>> I think that does sound feasible. I'm trying to visualize how that
>> would look. I guess there would need to be various livepatching hooks
>> called during the different stages (apply_relocate_add(),
>> module_finalize(), module_enable_ro/x()).
>>
>> So maybe something like the following?
>>
>> When a livepatch module loads:
>>    apply_relocate_add()
>>        klp hook: apply .klp.rela.$objname relocations *only* for
>>        already loaded modules
>>    module_finalize()
>>        klp hook: apply .klp.arch.$objname changes for already loaded modules
>>    module_enable_ro()
>>        klp hook: only enable ro/x for .klp.text.$objname for already
>>        loaded modules
>
>Just for record. We should also set ro for the not-yet used
>.klp.text.$objname at this stage so that it can't be modified
>easily "by accident".

If we also set ro protection already for .klp.text.$objname for
not-yet loaded modules, I think this would unfortunately mean we would
still have to do the protection flipping for late module patching that
Peter was trying to avoid, right?

That is, we *still* end up having to do the whole module_disable_ro()
-> apply_relocate_add() -> module_finalize() -> module_enable_ro()
thing for late module patching, except now we've moved that work to
the module loader instead of in klp_module_coming.. It sounds just as
complicated as the current way :/

However, I think this complaint would not apply if livepatch switches
to the one patch module per module model..

