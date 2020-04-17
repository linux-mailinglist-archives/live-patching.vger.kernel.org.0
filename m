Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8250D1AD90D
	for <lists+live-patching@lfdr.de>; Fri, 17 Apr 2020 10:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbgDQIu4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 Apr 2020 04:50:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729999AbgDQIuz (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 Apr 2020 04:50:55 -0400
Received: from linux-8ccs (p3EE2C7AC.dip0.t-ipconnect.de [62.226.199.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9E4B221EB;
        Fri, 17 Apr 2020 08:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587113454;
        bh=nYJIUvz397RoW000dohQoOjlgX8BMgu1fYRD0R2mKP4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XUiIcFPLoao5vmOJqOavIVIYy65jDSXAdvjog2YzfDygqrmdbw/aRKumjO846rY/2
         i/UO7uxKQZihlD2/vk27AOWYrUy+j4//GuP6yiMcnZ4MTKyjs89ge/MCT839kYN6s5
         gOEZxHEKu92zSRngDj6grK5RLm4m+AWQbmRZygzk=
Date:   Fri, 17 Apr 2020 10:50:50 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] livepatch,module: Remove .klp.arch and
 module_disable_ro()
Message-ID: <20200417085049.GA2582@linux-8ccs>
References: <cover.1586881704.git.jpoimboe@redhat.com>
 <20200414182726.GF2483@worktop.programming.kicks-ass.net>
 <20200414190814.glra2gceqgy34iyx@treble>
 <20200415142415.GH20730@hirez.programming.kicks-ass.net>
 <20200415161706.3tw5o4se2cakxmql@treble>
 <20200416153131.GC6164@linux-8ccs.fritz.box>
 <20200416154514.xqqyvdtm6hjynbx2@treble>
 <alpine.LSU.2.21.2004171025090.31054@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2004171025090.31054@pobox.suse.cz>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Miroslav Benes [17/04/20 10:27 +0200]:
>On Thu, 16 Apr 2020, Josh Poimboeuf wrote:
>
>> On Thu, Apr 16, 2020 at 05:31:31PM +0200, Jessica Yu wrote:
>> > > But I still not a fan of the fact that COMING has two different
>> > > "states".  For example, after your patch, when apply_relocate_add() is
>> > > called from klp_module_coming(), it can use memcpy(), but when called
>> > > from klp module init() it has to use text poke.  But both are COMING so
>> > > there's no way to look at the module state to know which can be used.
>> >
>> > This is a good observation, thanks for bringing it up. I agree that we
>> > should strive to be consistent with what the module states mean. In my
>> > head, I think it is easiest to assume/establish the following meanings
>> > for each module state:
>> >
>> > MODULE_STATE_UNFORMED - no protections. relocations, alternatives,
>> > ftrace module initialization, etc. any other text modifications are
>> > in the process of being applied. Direct writes are permissible.
>> >
>> > MODULE_STATE_COMING - module fully formed, text modifications are
>> > done, protections applied, module is ready to execute init or is
>> > executing init.
>> >
>> > I wonder if we could enforce the meaning of these two states more
>> > consistently without needing to add another module state.
>> >
>> > Regarding Peter's patches, with the set_all_modules_text_*() api gone,
>> > and ftrace reliance on MODULE_STATE_COMING gone (I think?), is there
>> > anything preventing ftrace_module_init+enable from being called
>> > earlier (i.e., before complete_formation()) while the module is
>> > unformed? Then you don't have to move module_enable_ro/nx later and we
>> > keep the MODULE_STATE_COMING semantics. And if we're enforcing the
>> > above module state meanings, I would also be OK with moving jump_label
>> > and static_call out of the coming notifier chain and making them
>> > explicit calls while the module is still writable.
>> >
>> > Sorry in advance if I missed anything above, I'm still trying to wrap
>> > my head around which callers need what module state and what module
>> > permissions :/
>>
>> Sounds reasonable to me...
>>
>> BTW, instead of hard-coding the jump-label/static-call/ftrace calls, we
>> could instead call notifiers with MODULE_STATE_UNFORMED.
>
>That was exactly what I was thinking about too while reading Jessica's
>email. Since (hopefully all if I remember correctly. I checked only
>random subset now) existing module notifiers check module state,
>it should not be a problem.

Agreed, especially with the growing number of callers now that want to
access the module while it is still writable, it seems reasonable.
IIRC, the module notifiers I looked at too checked the module state
value appropriately, so I think we are fine as well (thanks for checking!)

Jessica
