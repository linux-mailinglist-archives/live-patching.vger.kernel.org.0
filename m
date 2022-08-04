Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E32589C25
	for <lists+live-patching@lfdr.de>; Thu,  4 Aug 2022 15:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiHDNG0 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 4 Aug 2022 09:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiHDNG0 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 4 Aug 2022 09:06:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7750C5F95;
        Thu,  4 Aug 2022 06:06:24 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F3123205C4;
        Thu,  4 Aug 2022 13:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1659618382; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3gPpoOwUEkIJ+ATjFpS4H9/4o1rTRBq+mrao0Dod2bw=;
        b=NRG0H44A8xOtANNH5QwPGhga8gWutFv2PTnz5UYN4c+onzXETxCYBAAVZZa2Y9fevgrPdo
        qpNY4x0dUcJlU6zK4bJFIqHFTGE3sFl9m6VU+2zJ58JF6lWPcsh7yECYGUib8geTdt5M0u
        FFY+ZYwSqeuZzajhW0qDocSQREcgUtQ=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id CEAD82C141;
        Thu,  4 Aug 2022 13:06:21 +0000 (UTC)
Date:   Thu, 4 Aug 2022 15:06:21 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Rik van Riel <riel@surriel.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, kernel-team@fb.com,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH v4] livepatch: fix race between fork and KLP transition
Message-ID: <YuvETeDi56Uv22nS@alley>
References: <20220720121023.043738bb@imladris.surriel.com>
 <YtrCqMLUqJlcoqIo@alley>
 <20220722150106.683f3704@imladris.surriel.com>
 <Yt6bZo5ztnVSjLLC@alley>
 <20220725094919.52bcde19@imladris.surriel.com>
 <20220727001040.vlqnnb4a3um46746@treble>
 <20220727102437.34530586@imladris.surriel.com>
 <YuKtNtOshtRfeMn7@alley>
 <c04f97fc29c4618f137b27ce6537800b53f1d95f.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c04f97fc29c4618f137b27ce6537800b53f1d95f.camel@surriel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2022-08-02 16:07:08, Rik van Riel wrote:
> On Thu, 2022-07-28 at 17:37 +0200, Petr Mladek wrote:
> > On Wed 2022-07-27 10:24:37, Rik van Riel wrote:
> > > v4: address changelog comments by Josh (thank you)
> > > 
> > > ---8<---
> > > When a KLP fails to apply, klp_reverse_transition will clear the
> > > TIF_PATCH_PENDING flag on all tasks, except for newly created tasks
> > > which are not on the task list yet.
> > 
> > It actually is not true. klp_reverse_transtion() clears
> > TIF_PATCH_FLAG only
> > temporary when it waits until all processes leave the ftrace
> > handler. It sets TIF_PATCH_FLAG once again for all tasks by calling
> > klp_start_transition().
> > 
> > The difference is important. The WARN_ON_ONCE() in
> > klp_complete_transition() will be printed when fork() copied
> > TIF_PATCH_FLAG before it was set again.
> > 
> > Anyway, the important thing is that TIF_PATCH_FLAG and task-
> > >patch_state
> > might be incompatible because fork() copies them at different times.
> > 
> > klp_copy_process() must make sure that they are in sync. And
> > it must be done under tasklist_lock when the child is added
> > to the global task list.
> 
> Hmmm, how should this be addressed in the changelog?
> 
> Should I just remove most of that paragraph and leave it
> at "there can be a race"?

It would be nice to somehow summarize what I wrote. I mean to explain
why the problem is easier to see with revert and not with forward
transition.

It is because TIF_PATCH_FLAG might stay cleared in the child even
when it was set again in the parent by the klp_revert_transtion().
As a result, the child will never get transition back to the reverted
state.

The problem is hard to hit during the forward transition because
child might have TIF_PATCH_FLAG still set even when
it might later copy an already migrated task->patch_state
when parent gets migrated in the race window. In this case,
the TIF_PATCH_FLAG will get cleared when the child returns
from fork and all will be good.

In each case, the inconsistent state is there even during
the forward transition. But it would be caught only when
the entire transition is finished during the rather small
race window.

The patch should fix the race in any direction.

I could provide even better description after I am back
from vacation on Aug 22.

Best Regards,
Petr
