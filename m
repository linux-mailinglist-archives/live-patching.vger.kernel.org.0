Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11D8DD8C9B
	for <lists+live-patching@lfdr.de>; Wed, 16 Oct 2019 11:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389231AbfJPJgS (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 16 Oct 2019 05:36:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:53460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387686AbfJPJgS (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 16 Oct 2019 05:36:18 -0400
Received: from linux-8ccs (unknown [95.90.219.243])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 010D721835;
        Wed, 16 Oct 2019 09:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571218577;
        bh=7iGCiUA8DsfOeZRBbJH2/3JPK3rNLE9Zn4bSFVsNXXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YC57lJR5lzAVNAZ6I1Z2q+ON/NxPLsKhs4WjZNnYHdNb2N+QNNVHpa2OKvnUSskf7
         tEhlUERt0wVM9V+k1cKFZwNmyZ1b3PZanQ75nJb5OjXFxgBRAgUGJ/wBbgn/hldKDz
         eI+og3oTyU1gvPW6uyUJbeiWv+j8IhGesPBPmn18=
Date:   Wed, 16 Oct 2019 11:36:10 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org,
        bristot@redhat.com, jbaron@akamai.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, namit@vmware.com, hpa@zytor.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, jpoimboe@redhat.com,
        live-patching@vger.kernel.org
Subject: Re: [PATCH v3 5/6] x86/ftrace: Use text_poke()
Message-ID: <20191016093610.GA9193@linux-8ccs>
References: <20191010140513.GT2311@hirez.programming.kicks-ass.net>
 <20191010115449.22044b53@gandalf.local.home>
 <20191010172819.GS2328@hirez.programming.kicks-ass.net>
 <20191011125903.GN2359@hirez.programming.kicks-ass.net>
 <20191015130739.GA23565@linux-8ccs>
 <20191015135634.GK2328@hirez.programming.kicks-ass.net>
 <alpine.LSU.2.21.1910151611000.13169@pobox.suse.cz>
 <88bab814-ea24-ece9-2bc0-7a1e10a62f12@redhat.com>
 <alpine.LSU.2.21.1910160843420.7750@pobox.suse.cz>
 <20191016092304.GL2294@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191016092304.GL2294@hirez.programming.kicks-ass.net>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.28-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Peter Zijlstra [16/10/19 11:23 +0200]:
>On Wed, Oct 16, 2019 at 08:51:27AM +0200, Miroslav Benes wrote:
>> On Tue, 15 Oct 2019, Joe Lawrence wrote:
>>
>> > On 10/15/19 10:13 AM, Miroslav Benes wrote:
>> > > Yes, it does. klp_module_coming() calls module_disable_ro() on all
>> > > patching modules which patch the coming module in order to call
>> > > apply_relocate_add(). New (patching) code for a module can be relocated
>> > > only when the relevant module is loaded.
>> >
>> > FWIW, would the LPC blue-sky2 model (ie, Steve's suggestion @ plumber's where
>> > livepatches only patch a single object and updates are kept on disk to handle
>> > coming module updates as they are loaded) eliminate those outstanding
>> > relocations and the need to perform this late permission flipping?
>>
>> Yes, it should, but we don't have to wait for it. PeterZ proposed a
>> different solution to this specific issue in
>> https://lore.kernel.org/lkml/20191015141111.GP2359@hirez.programming.kicks-ass.net/
>>
>> It should not be a problem to create a live patch module like that and the
>> code in kernel/livepatch/ is almost ready. Something like
>> module_section_disable_ro(mod, section) (and similar for X protection)
>> should be enough. Module reloads would still require juggling with the
>> protections, but I think it is all feasible.
>
>Just had a browse around the module code, and while the section info is
>in load_info, it doesn't get retained for active modules.
>
>So I suppose I'll go add that for KLP enabled things.

Elf section info does get saved for livepatch modules though, see
mod->klp_info. And wouldn't this only be needed for livepatch modules?
