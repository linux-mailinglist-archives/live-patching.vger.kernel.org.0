Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD4657CA51
	for <lists+live-patching@lfdr.de>; Thu, 21 Jul 2022 14:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbiGUMLI (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 21 Jul 2022 08:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233201AbiGUMLH (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 21 Jul 2022 08:11:07 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF47985D7C
        for <live-patching@vger.kernel.org>; Thu, 21 Jul 2022 05:11:03 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 8AD0E33B1B;
        Thu, 21 Jul 2022 12:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1658405462; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Za29y0gRWdJnVF8HSuwx/sgnLSaTho3+JjRfZhShpoU=;
        b=DV0KuwOkkaDVZsLyNv5nR9NSeJ88yHOj7v2ChxFRN+Cx5DQXxF9ZamSZH8nkB6M/8T4fsM
        PBEEi7XTMLoy0yNC7SqzyC6oGvNATCOg3lCUf5ZBFxXHo6JvsL8Ik6zk9q/i72Mz251tBm
        wMDRSSJ4UlkxwAwNEHzuArh1zTR6XQM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1658405462;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Za29y0gRWdJnVF8HSuwx/sgnLSaTho3+JjRfZhShpoU=;
        b=QtOghWBXJxlsgiWF0Yr2dYN8CUbH/blHYIvzUxniIVk/TmWY3wcb7vnD1BsSOwRpuvU81z
        ejnoLXE6f4jN/MAA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 3213C2C149;
        Thu, 21 Jul 2022 12:11:02 +0000 (UTC)
Date:   Thu, 21 Jul 2022 14:11:01 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Song Liu <song@kernel.org>
cc:     live-patching@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>, Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Cheng Jian <cj.chengjian@huawei.com>,
        Song Liu <songliubraving@fb.com>
Subject: Re: unload and reload modules with patched function
In-Reply-To: <CAPhsuW6xiWe-WSVtJDhcu0+aLN+bKXd76rNcZzx4cpMig2ryNg@mail.gmail.com>
Message-ID: <alpine.LSU.2.21.2207211348060.1611@pobox.suse.cz>
References: <CAPhsuW6xiWe-WSVtJDhcu0+aLN+bKXd76rNcZzx4cpMig2ryNg@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

On Wed, 20 Jul 2022, Song Liu wrote:

> Hi folks,
> 
> While testing livepatch kernel modules, we found that if a kernel module has
> patched functions, we cannot unload and load it again (rmmod, then insmod).
> This hasn't happened in production yet, but it feels very risky. We use
> automation (chef to be specific) to handle kernel modules and livepatch.
> It is totally possible some weird sequence of operations would cause insmod
> errors on thousands of servers. Therefore, we would like to fix this issue
> before it hits us hard.
>
> A bit of searching with the error message shows it was a known issue [1], and
> a few options are discussed:
> 
> "Possible ways to fix it:
> 
> 1) Remove the error check in apply_relocate_add().  I don't think we
>    should do this, because the error is actually useful for detecting
>    corrupt modules.  And also, powerpc has the similar error so this
>    wouldn't be a universal solution.
> 
> 2) In klp_unpatch_object(), call an arch-specific arch_unpatch_object()
>    which reverses any arch-specific patching: on x86, clearing all
>    relocation targets to zero; on powerpc, converting the instructions
>    after relative link branches to nops.  I don't think we should do
>    this because it's not a global solution and requires fidgety
>    arch-specific patching code.
> 
> 3) Don't allow patched modules to be removed.  I think this makes the
>    most sense.  Nobody needs this functionality anyway (right?).
> "
> 
> I personally think 2) is a better approach, as it doesn't introduce any
> new limitations. (I admit that I only plan to implement the fix for x86).
> 3) seems easier to implement, we just need the livepatch to hold a
> reference to the module, right? But Miroslav mentioned there are
> some issues with 3), which I can't figure out.

If I understand my notes correctly, 3) as implemented would not solve the 
following scenario...

1. a live patch is loaded, it contains a fix for a module M which is not 
   loaded
2. module M is loaded, relocations and things are applied for the live 
   patch, load_module() on M fails later and it is not loaded in the end.
3. another load attempt of M would not succeed.

I am not sure how real the scenario is, but we also deemed the original 
problem as improbable in practice.
 
> So, what would be the right approach to fix this issue? Is anybody
> working on this already? If we can agree the right approach, I am
> more than happy to implement it (well, x86 only for option 2).

No one works on that as far as I know. I abandoned the patch set for 3) 
due to the reason above, and then even the patch set for 2) because it 
was not nice to put it mildly. We decided the problem did not exist in 
practice (till someone says otherwise).

The thread mentions better late module loading infrastructure. If I 
remember correctly, it did not happen in the end. peterz removed all 
issues with the late module loading we had because we had misunderstood a 
couple of things.

Now 3) was submitted as 
https://lore.kernel.org/all/20180607092949.1706-1-mbenes@suse.cz/T/#u

2) as
v1 https://lore.kernel.org/all/20190719122840.15353-1-mbenes@suse.cz/T/#u
v2 https://lore.kernel.org/all/20190905124514.8944-1-mbenes@suse.cz/T/#u

I also pushed all I have to 
https://git.kernel.org/pub/scm/linux/kernel/git/mbenes/linux.git/. 
Branches klp_deny_rmmod* and klp_clear_reloc*.

Feel free to take over and work on that. I am afraid I would not get to it 
anytime soon unfortunately.

Regards
Miroslav
