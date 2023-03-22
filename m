Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B886C5008
	for <lists+live-patching@lfdr.de>; Wed, 22 Mar 2023 17:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjCVQHQ (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Mar 2023 12:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjCVQHP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Mar 2023 12:07:15 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE233019A
        for <live-patching@vger.kernel.org>; Wed, 22 Mar 2023 09:07:11 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2822820FAE;
        Wed, 22 Mar 2023 16:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1679501230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jfv+GXKCSsy2XnIfeJYzq38V0qoMsP1919MQxCfufHs=;
        b=AvA3CfPScr8/lEkrt5bEuxferkzuyTZwEuYxBhVg7ZkkJcew2+6tr/drxDelOrG99YjzDF
        d4/Y6l0UVR0JdZPFnSu/pXN055DuT7Khf47CvaZcp6GiowiNJJ5MHBWbSaFZ0BiahtimuL
        qOHp3N0PGvsmiODva0uiJl1IFOAIKJM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1679501230;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jfv+GXKCSsy2XnIfeJYzq38V0qoMsP1919MQxCfufHs=;
        b=VLe3+Cy+GLCRVC+h+cndvSALgjCiKzov0iZ2Pugit65Hr19GxIYBVuJMu9OvhXNo81/QnM
        iiDQzNeG+p2Oz4Bw==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 06BAF2C141;
        Wed, 22 Mar 2023 16:07:10 +0000 (UTC)
Date:   Wed, 22 Mar 2023 17:07:09 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Alexey Dobriyan <adobriyan@gmail.com>
cc:     Josh Poimboeuf <jpoimboe@kernel.org>, live-patching@vger.kernel.org
Subject: Re: question re klp_transition_work kickoff timeout
In-Reply-To: <c84a0b0c-4232-451e-be0b-a6c29d69c1a8@p183>
Message-ID: <alpine.LSU.2.21.2303221703540.28751@pobox.suse.cz>
References: <c84a0b0c-4232-451e-be0b-a6c29d69c1a8@p183>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

On Wed, 22 Mar 2023, Alexey Dobriyan wrote:

> Hi, Josh.
> 
> I've been profiling how much time livepatching takes and I have a question
> regarding these lines:
> 
> 	void klp_try_complete_transition(void)
> 	{
> 		...
> 		if (!complete) {
> 			schedule_delayed_work(&klp_transition_work, round_jiffies_relative(HZ));
> 			return;
> 		}
> 
> 	}
> 
> The problem here is that if the system is idle, then the previous loop
> checking idle tasks will reliably sets "complete = false" and then
> patching wastes time waiting for next second so that klp_transition_work
> will repeat the same code without reentering itself.

Only if klp_try_switch_task() cannot switch the idle task right away. We 
then prod it using wake_up_if_idle() and handle it in the next iteration.

So the question might be why klp_try_switch_task() did not succeed in the 
first place.

> I've created trivial patch which changes 2 functions and it takes
> ~1.3 seconds to complete transition:
> 
> 	[   33.829506] livepatch: 'main': starting patching transition
> 	[   35.190721] livepatch: 'main': patching complete
> 
> I don't know what's the correct timeout to retry transition work
> but it can be made near-instant:
> 
> 	[  100.930758] livepatch: 'main': starting patching transition
> 	[  100.956190] livepatch: 'main': patching complete

There is really no correct timeout. The application of a live patch is 
a lazy slow path. We generally do not care when it is finished unless it 
is stuck for some reason or takes really long.

What is your motivation in measuring it?

Regards
Miroslav
