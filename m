Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD3C21ACA23
	for <lists+live-patching@lfdr.de>; Thu, 16 Apr 2020 17:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506129AbgDPPbj (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 16 Apr 2020 11:31:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504592AbgDPPbg (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 16 Apr 2020 11:31:36 -0400
Received: from linux-8ccs.fritz.box (p3EE2C7AC.dip0.t-ipconnect.de [62.226.199.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD59F21927;
        Thu, 16 Apr 2020 15:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587051095;
        bh=SCB+M9/K5bk5wKrZcAzFzoSpybGBfyanXCKWdEgGEbM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WGH6YrLc/B+FvD1kgigsj0IXt0Hmn/LxdTcxRftpJcmYrSeEdnU6J8PM5JK9t09KQ
         5h20NWDDQ1p2nYScKkTMrgSmc5dwRMBZUgFbJyW+NcmRL4OULv7stTobEqI6s2+I+C
         cfeh0cvcBeaYjDPg0ymdZ4f5rxmg2rEpc9T6x1dE=
Date:   Thu, 16 Apr 2020 17:31:31 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] livepatch,module: Remove .klp.arch and
 module_disable_ro()
Message-ID: <20200416153131.GC6164@linux-8ccs.fritz.box>
References: <cover.1586881704.git.jpoimboe@redhat.com>
 <20200414182726.GF2483@worktop.programming.kicks-ass.net>
 <20200414190814.glra2gceqgy34iyx@treble>
 <20200415142415.GH20730@hirez.programming.kicks-ass.net>
 <20200415161706.3tw5o4se2cakxmql@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200415161706.3tw5o4se2cakxmql@treble>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

+++ Josh Poimboeuf [15/04/20 11:17 -0500]:
>On Wed, Apr 15, 2020 at 04:24:15PM +0200, Peter Zijlstra wrote:
>> > It bothers me that both the notifiers and the module init() both see the
>> > same MODULE_STATE_COMING state, but only in the former case is the text
>> > writable.
>> >
>> > I think it's cognitively simpler if MODULE_STATE_COMING always means the
>> > same thing, like the comments imply, "fully formed" and thus
>> > not-writable:
>> >
>> > enum module_state {
>> > 	MODULE_STATE_LIVE,	/* Normal state. */
>> > 	MODULE_STATE_COMING,	/* Full formed, running module_init. */
>> > 	MODULE_STATE_GOING,	/* Going away. */
>> > 	MODULE_STATE_UNFORMED,	/* Still setting it up. */
>> > };
>> >
>> > And, it keeps tighter constraints on what a notifier can do, which is a
>> > good thing if we can get away with it.
>>
>> Moo! -- but jump_label and static_call are on the notifier chain and I
>> was hoping to make it cheaper for them. Should we perhaps weane them off the
>> notifier and, like ftrace/klp put in explicit calls?
>>
>> It'd make the error handling in prepare_coming_module() a bigger mess,
>> but it should work.
>
>So you're wanting to have jump labels and static_call do direct writes
>instead of text pokes, right?  Makes sense.
>
>I don't feel strongly about "don't let module notifiers modify text".
>
>But I still not a fan of the fact that COMING has two different
>"states".  For example, after your patch, when apply_relocate_add() is
>called from klp_module_coming(), it can use memcpy(), but when called
>from klp module init() it has to use text poke.  But both are COMING so
>there's no way to look at the module state to know which can be used.

This is a good observation, thanks for bringing it up. I agree that we
should strive to be consistent with what the module states mean. In my
head, I think it is easiest to assume/establish the following meanings
for each module state:

MODULE_STATE_UNFORMED - no protections. relocations, alternatives,
ftrace module initialization, etc. any other text modifications are
in the process of being applied. Direct writes are permissible.

MODULE_STATE_COMING - module fully formed, text modifications are
done, protections applied, module is ready to execute init or is
executing init.

I wonder if we could enforce the meaning of these two states more
consistently without needing to add another module state.

Regarding Peter's patches, with the set_all_modules_text_*() api gone,
and ftrace reliance on MODULE_STATE_COMING gone (I think?), is there
anything preventing ftrace_module_init+enable from being called
earlier (i.e., before complete_formation()) while the module is
unformed? Then you don't have to move module_enable_ro/nx later and we
keep the MODULE_STATE_COMING semantics. And if we're enforcing the
above module state meanings, I would also be OK with moving jump_label
and static_call out of the coming notifier chain and making them
explicit calls while the module is still writable.

Sorry in advance if I missed anything above, I'm still trying to wrap
my head around which callers need what module state and what module
permissions :/

Jessica

