Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A938B5842ED
	for <lists+live-patching@lfdr.de>; Thu, 28 Jul 2022 17:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbiG1PUh (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 28 Jul 2022 11:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiG1PUh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 28 Jul 2022 11:20:37 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A37B10553;
        Thu, 28 Jul 2022 08:20:36 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C401335047;
        Thu, 28 Jul 2022 15:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659021634; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AcsYR6qD6TuHLXpeavIZ6QLFvEQrlgJi0xtottJb0Eg=;
        b=S/8AeuOB+zic4nv6qHyFt5fbM4f4GmOpC98KN3yvQ8nT+knEmHiSpSsatzoCy52wEAb9CM
        0WaRHJ61N3Q6Sw7zLsbo0meQ8uHZFNIJIQYpasSLKZxlr0eUWuSMNjkfi8g6we+5+el0uf
        wnWiAp00nMhYj0bfulzpeYNl2itehKc=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9D8902C141;
        Thu, 28 Jul 2022 15:20:33 +0000 (UTC)
Date:   Thu, 28 Jul 2022 17:20:33 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Rik van Riel <riel@surriel.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, kernel-team@fb.com,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH v3] livepatch: fix race between fork and
 klp_reverse_transition
Message-ID: <YuKpQXl2P3jkOpEy@alley>
References: <20220720121023.043738bb@imladris.surriel.com>
 <YtrCqMLUqJlcoqIo@alley>
 <20220722150106.683f3704@imladris.surriel.com>
 <Yt6bZo5ztnVSjLLC@alley>
 <20220725094919.52bcde19@imladris.surriel.com>
 <20220727001040.vlqnnb4a3um46746@treble>
 <924f1cf4b93ff3e4ff217203bd88448dfa4c0f85.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <924f1cf4b93ff3e4ff217203bd88448dfa4c0f85.camel@surriel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2022-07-26 20:26:41, Rik van Riel wrote:
> On Tue, 2022-07-26 at 17:10 -0700, Josh Poimboeuf wrote:
> > On Mon, Jul 25, 2022 at 09:49:19AM -0400, Rik van Riel wrote:
> > > When a KLP fails to apply, klp_reverse_transition will clear the
> > > TIF_PATCH_PENDING flag on all tasks, except for newly created tasks
> > > which are not on the task list yet.
> > 
> > This paragraph and $SUBJECT both talk about a reverse transition. 
> > Isn't
> > it also possible to race on a normal (forward) transition?
> 
> I don't know whether the race is also possible on a forward
> transition.  If the parent task has transitioned, will
> the child have, as well, by the time we reach the end of fork?

I think that the race should be possible also with the forward
transition. I do not see what would prevent it.


> I suppose the only way the parent task can transition while
> inside fork would be if none of the functions in its stack
> need to be transitioned, and at that point the child process
> would automatically be safe, too?

IMHO, these races might be dangerous only when fork() calls
a function on the way out that is livepatched but it was not
on the stack when the process was copied.

Anyway, the patch should make sure that task->patch_state and
TIF_PATCH_PENTING are always consitent when the child is added
to the global task list. So, we should always be on the safe side.


> However, we have only observed this warning on reverse transitions
> for some reason.

IMHO, it is because the race during the forward transition is
kind of "self-healing":

parent:				worker:

  fork()
    #copy set TIF_PATCH_PENDING
    # schedule


				  klp_try_complete_transition()
				     clear_bit(parent, TIF_PATCH_PENDING);
				     parent->patch_state = klp_target_state;

   # running again
   # copy already migrated parent->patch_state



later:

     clear_bit(child, TIF_PATCH_PENDING);
     child->patch_state = klp_target_state;

As a result, child->patch_state will be updated twice
to klp_target_state.



The problematic situation during revert:


parent:					another process:

   # migrate parent
   clear_bit(parent, TIF_PATCH_PENDING);
   parent->patch_state = klp_target_state;

   fork()
     #copy cleared TIF_PATCH_PENDING

					klp_revert_patch()
					    # invert @klp_target_state
					    set_bit(parent, TIF_PATCH_PENDING)

     # copy parent->patch_state that
       needs migration once again

   # migrated once again after revert
   clear_bit(parent, TIF_PATCH_PENDING);
   parent->patch_state = klp_target_state;

WARNING: child will never get migrated because it copied the cleared
	 TIF_PATCH_PENDING before @klp_target_state was inverted

Resume:

It is great that the race was found and fixed.

Best Regards,
Petr
