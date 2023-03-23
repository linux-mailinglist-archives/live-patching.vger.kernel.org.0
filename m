Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A086C6D9C
	for <lists+live-patching@lfdr.de>; Thu, 23 Mar 2023 17:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbjCWQcl (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Mar 2023 12:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbjCWQcR (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Mar 2023 12:32:17 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027E035269
        for <live-patching@vger.kernel.org>; Thu, 23 Mar 2023 09:31:46 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so1520040wms.1
        for <live-patching@vger.kernel.org>; Thu, 23 Mar 2023 09:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679589105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OHS/M9aB7pOi4FIpyBM07soNw5UVYWXbLmn2qD7hAO8=;
        b=P/FZBSYAW2gTmdN3vEGD8cf4u+NCWcHNtGhkRl72/DhtYQj7wQfliEdwno4gKqPWIp
         w6Kj7ZX2r4C2itKRrEBnyec5KLv9L7eV+rBwxbSML8ApowhX34BfrUaBfziQKTTjo+6u
         EzsYty9MadyqNYf3iIfmKghYuqstq4OkbU9kYPCRhQHiImnvlD84wTEbMuXoV6G33YYy
         IfaJai4zzJ27fQ1ftdo6ZhCX4Ani2BlmJ+HhdJoSFuobRdHewgelGZMQtj02laQl2eXA
         yeNB1s7i/Nu4T0+C95YCL9R72hywbjfDIPhZGPkXk5jlsoCp5l/bzXxk0wSQZcjpMAec
         YKKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679589105;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHS/M9aB7pOi4FIpyBM07soNw5UVYWXbLmn2qD7hAO8=;
        b=OhH2bQZJbVqI81OpCSu1Hu6OriQ7RGMIqph8XPGkSHPyjFdlMwCjX0JembjP9/RCnr
         tLDoG5F1jp8V4RGLtdU9Jhx+SGw5YbFaOAPOHjkTxl/8mS9o2sb3yIPl0cWjDICoJsIY
         QJSd/b7pnHPQCWgmUVHSZlbmjXE8rV/9m2o392X1Uc3Z+PU2ZjBLdzzFCwhaBr+ICzxQ
         u8DldSBmnS8HJBKBTLmHcu83g4ZNR78Pp3lfmdE0V4G7FoT4ceZej/MKV2yZhKsfL46g
         ndh5lPgeIhA1e1mBxeHklbe+I5zlX3ahKfduCT0dwOZefcaarTv0Ni2wgApJyYd1ameO
         aakQ==
X-Gm-Message-State: AO0yUKWEqSLs8Ut9JU/YVhegBSCxYlka7UL+5HbLcKWgiycCAko7lymp
        lfSKzf7xZbTbxyvp3lL6GQ==
X-Google-Smtp-Source: AK7set/YPmST4u3SZIwLXsCd4yDcAfNjHnrR0NPnJVRWNGTUi+nhfNDDtaAIx5WGs+GcuuWaKJORKg==
X-Received: by 2002:a05:600c:4f91:b0:3ee:501f:c795 with SMTP id n17-20020a05600c4f9100b003ee501fc795mr3037852wmq.1.1679589104823;
        Thu, 23 Mar 2023 09:31:44 -0700 (PDT)
Received: from p183 ([46.53.251.240])
        by smtp.gmail.com with ESMTPSA id q8-20020a05600c46c800b003eda46d6792sm2428813wmo.32.2023.03.23.09.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 09:31:44 -0700 (PDT)
Date:   Thu, 23 Mar 2023 19:31:42 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, live-patching@vger.kernel.org
Subject: Re: question re klp_transition_work kickoff timeout
Message-ID: <30b0f7e7-165c-4d42-a962-675c836d621a@p183>
References: <c84a0b0c-4232-451e-be0b-a6c29d69c1a8@p183>
 <ZBx5pvZXLv/ikl/f@alley>
 <ZBx8sRTmpljI/i6Z@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZBx8sRTmpljI/i6Z@alley>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Mar 23, 2023 at 05:22:09PM +0100, Petr Mladek wrote:
> On Thu 2023-03-23 17:09:13, Petr Mladek wrote:
> > On Wed 2023-03-22 18:41:40, Alexey Dobriyan wrote:
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
> > > 
> > > I've created trivial patch which changes 2 functions and it takes
> > > ~1.3 seconds to complete transition:
> > > 
> > > 	[   33.829506] livepatch: 'main': starting patching transition
> > > 	[   35.190721] livepatch: 'main': patching complete
> > > 
> > > I don't know what's the correct timeout to retry transition work
> > > but it can be made near-instant:
> > > 
> > > 	[  100.930758] livepatch: 'main': starting patching transition
> > > 	[  100.956190] livepatch: 'main': patching complete
> > > 
> > > 
> > > 	Alexey (CloudLinux)
> > > 
> > > 
> > > --- a/kernel/livepatch/transition.c
> > > +++ b/kernel/livepatch/transition.c
> > > @@ -435,8 +435,7 @@ void klp_try_complete_transition(void)
> > >  		 * later and/or wait for other methods like kernel exit
> > >  		 * switching.
> > >  		 */
> > > -		schedule_delayed_work(&klp_transition_work,
> > > -				      round_jiffies_relative(HZ));
> > > +		schedule_delayed_work(&klp_transition_work, msecs_to_jiffies(1));
> > 
> > Note that this affects all iterations, not only the first one. In
> > practice, it might schedule another klp_transition_work() almost
> > immediately. Servers typically use HZ = 250 and 1ms is less than 1 jiffy.
> > 
> > Now, klp_try_complete_transition() takes tasklist_lock and blocks
> > forking and exiting. It sounds scary to do this so frequently.
> > Is am actually surprised that nobody reported any problems
> > even with the 1sec period.
> > 
> > Please, stop these micro-optimizations!
> > 
> > Livepatching is about security and reliability. It is not about speed!
> > 
> > The fact that the transition is so lazy is a great feature.
> > Livepatching should make the system more safe without breaking it.
> > It is great that it could run in background and do not limit
> > the normal workload too much.
> 
> By other words. It might be interesting to find a way how to migrate
> the idle tasks during the first klp_try_complete_transition() call.
> As a result the 2nd call would not be needed and it would make
> livepatching even more lightweight.
> 
> But just increasing the frequency of klp_try_complete_transition()
> is not the way to go.

1ms is for demo purposes, to show how fast this thing can go.
