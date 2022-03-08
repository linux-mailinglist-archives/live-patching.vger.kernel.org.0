Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80DD44D14BB
	for <lists+live-patching@lfdr.de>; Tue,  8 Mar 2022 11:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344245AbiCHK3Z (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 8 Mar 2022 05:29:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345845AbiCHK3Y (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 8 Mar 2022 05:29:24 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64C93C489;
        Tue,  8 Mar 2022 02:28:27 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 703C1210F6;
        Tue,  8 Mar 2022 10:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646735306; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UGiJgSe0T0oOiHnAKgTMCIENUpUOw+B4X6790ZHiR4c=;
        b=Q52Uy1TH2pLPefAJDAAWytaJOWwzLthr/Z4rDxlR6aAXBNaOg/c4kj4VfwE6KwBAWe2oU4
        mra52iIeVV2wH6sXJVVCZncr6Su0QomG7ygU2Xg0j3H3J/zpIJweGWYRWkAO5Y9vMApdsc
        zG+VxPgzMJutQ0YgkQKJMx3KA51GzU4=
Received: from suse.cz (unknown [10.100.224.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 538B7A3B87;
        Tue,  8 Mar 2022 10:28:25 +0000 (UTC)
Date:   Tue, 8 Mar 2022 11:28:24 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Chengming Zhou <zhouchengming@bytedance.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>, jpoimboe@redhat.com,
        jikos@kernel.org, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, songmuchun@bytedance.com,
        qirui.001@bytedance.com
Subject: Re: [External] Re: [PATCH] livepatch: Only block the removal of
 KLP_UNPATCHED forced transition patch
Message-ID: <YicvyEbFzZIAut+4@alley>
References: <20220301140840.29345-1-zhouchengming@bytedance.com>
 <alpine.LSU.2.21.2203021052470.5895@pobox.suse.cz>
 <fe2b9225-44c3-2041-f8a3-6f17f9d1be40@bytedance.com>
 <alpine.LSU.2.21.2203030847430.704@pobox.suse.cz>
 <1929669c-7674-035b-8cf1-5b5007ecccec@bytedance.com>
 <c1ab3333-7fea-d2d5-272d-850f4c7afb74@redhat.com>
 <306a5d51-25e5-b7ce-cbdd-ca7e2f3a3ad5@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <306a5d51-25e5-b7ce-cbdd-ca7e2f3a3ad5@bytedance.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-03-04 23:14:15, Chengming Zhou wrote:
> On 2022/3/3 11:43 下午, Joe Lawrence wrote:
> > On 3/3/22 5:33 AM, Chengming Zhou wrote:
> >> On 2022/3/3 3:51 下午, Miroslav Benes wrote:
> >> Apart from this reason, another reason we may use "force" transition
> >> is that we want to speed up the transition process of some patches
> >> when load them, and we can make sure these patches are safe to do so.
> >> (just like a consistency model check disable option when load a patch)
> >>
> > Interesting use case.  Can you share any example livepatches where the
> > transition time was exceptionally long and that lead to requiring this
> > patch?
> 
> Sorry, I haven't easy reproducible testcase on hand, maybe I could try to
> make one to simulate the production environment later.

An artificial test case is not much useful. We would like to know if you
met the problem in the real life. It would be great to know more
details if it really happened.


> > From a kpatch developer's perspective, it would be interesting to read
> > how you go about ensuring forced livepatch safety.  We don't generally
> > build forced livepatches, so I'm curious how the dev/review process goes.
> 
> We also use kpatch-build for some patches too, but for some other patches,
> which need to add new members to some struct type, or fix some kernel function
> bugs, we may need to rewrite the source patch to make a livepatch module.
> 
> There are some types that don't need per-task consistency or even can replace
> the old functions when tasks stack in the old functions. We may want to use
> "force" transition in case load process timeout.

What is the motivation for the timeout, please?

The "force" functionality was introduced as a last resort solution.
It might be useful when the transition gets blocked and another
transition is needed.

"force" should be used carefully. Users should be sure that it is
really safe in the current state.

Note that forced transition does not magically makes the system
patched. If a process is sleeping on a non-patched function then
it will continue running the old code until it returns
the non-patched function.

Best Regards,
Petr
