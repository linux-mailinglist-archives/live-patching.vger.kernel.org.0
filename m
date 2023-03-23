Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF336C6C0B
	for <lists+live-patching@lfdr.de>; Thu, 23 Mar 2023 16:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbjCWPPy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Mar 2023 11:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbjCWPPx (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Mar 2023 11:15:53 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68118C1
        for <live-patching@vger.kernel.org>; Thu, 23 Mar 2023 08:15:32 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id BA53533799;
        Thu, 23 Mar 2023 15:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1679584530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z/+6qg2Juy1uqkr5OdPXmxZL9ymPH8aeHmaGu+j8D8M=;
        b=VHVAgkSxoQe2XVK1jviT+y3n1r9a9sBnmlKpwgZSkkOZMXFP4rGNCxHYo8cqdo25vvOUYI
        6MENwGDEYCIo+U6E+IXXlPNtm722iyMb9HjEbprkXozhkD6DETBXw5jlAlnJED+z9baYZ5
        fxQzyALazFARw8IlByI55n3Lu2nqKjc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1679584530;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z/+6qg2Juy1uqkr5OdPXmxZL9ymPH8aeHmaGu+j8D8M=;
        b=JS+KuS7a0m+/JjE/enY8KychFykTn6VCdK5teLpSmRFgANKM7ETPgY4rj4lJtn7EUef6x9
        PywUOdOqxs/rRrCA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9CAD62C141;
        Thu, 23 Mar 2023 15:15:30 +0000 (UTC)
Date:   Thu, 23 Mar 2023 16:15:30 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Alexey Dobriyan <adobriyan@gmail.com>
cc:     Josh Poimboeuf <jpoimboe@kernel.org>, live-patching@vger.kernel.org
Subject: Re: question re klp_transition_work kickoff timeout
In-Reply-To: <2ced976a-f801-44fa-98ec-832862ca4984@p183>
Message-ID: <alpine.LSU.2.21.2303231610570.9088@pobox.suse.cz>
References: <c84a0b0c-4232-451e-be0b-a6c29d69c1a8@p183> <alpine.LSU.2.21.2303221703540.28751@pobox.suse.cz> <2ced976a-f801-44fa-98ec-832862ca4984@p183>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, 23 Mar 2023, Alexey Dobriyan wrote:

> On Wed, Mar 22, 2023 at 05:07:09PM +0100, Miroslav Benes wrote:
> > On Wed, 22 Mar 2023, Alexey Dobriyan wrote:
> > 
> > > Hi, Josh.
> > > 
> > > I've been profiling how much time livepatching takes and I have a question
> > > regarding these lines:
> > > 
> > > 	void klp_try_complete_transition(void)
> > > 	{
> > > 		...
> > > 		if (!complete) {
> > > 			schedule_delayed_work(&klp_transition_work, round_jiffies_relative(HZ));
> > > 			return;
> > > 		}
> > > 
> > > 	}
> > > 
> > > The problem here is that if the system is idle, then the previous loop
> > > checking idle tasks will reliably sets "complete = false" and then
> > > patching wastes time waiting for next second so that klp_transition_work
> > > will repeat the same code without reentering itself.
> > 
> > Only if klp_try_switch_task() cannot switch the idle task right away. We 
> > then prod it using wake_up_if_idle() and handle it in the next iteration.
> > 
> > So the question might be why klp_try_switch_task() did not succeed in the 
> > first place.
> 
> Yes, sort of. Transitioning never happens on the first try becase of idle
> tasks (see debugging patch below). But it should happen immediately
> because machine is idle!

Yes. My guess is that swapper task is running and cannot be switched 
through klp_try_switch_task() so we prod it and it migrates itself through 
our hook in do_idle().

You can enable a dynamic debug and see if it helps to confirm it

# echo "file kernel/livepatch/* +p" > /sys/kernel/debug/dynamic_debug/control

Miroslav
