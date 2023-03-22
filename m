Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A446C4F99
	for <lists+live-patching@lfdr.de>; Wed, 22 Mar 2023 16:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCVPlq (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 22 Mar 2023 11:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjCVPlp (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 22 Mar 2023 11:41:45 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C277618AD
        for <live-patching@vger.kernel.org>; Wed, 22 Mar 2023 08:41:44 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id y4so74766246edo.2
        for <live-patching@vger.kernel.org>; Wed, 22 Mar 2023 08:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679499703;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JcaSHBOVM7lOp4H4ylkCBQXuh0C+r55dheOxQqbKNMM=;
        b=HDRP6O3rT7SmtHM/3I9fGB1/ySn47HRKVsHKUHldO+yByVEuMruL1BEB5I7tqDRNgF
         K0s///ue6xSbmrVIMmhdxEeBHr/iMuzJkcgrqZzBESBrdNDVVwlP4XTi29vkESo9oiY9
         glEmx+cznacjHimHZCSdp7gEXr9/idZmb+e3ShKjiXba1jxLRhCcKORXfzRUa/kgKw1s
         N4nW9Rzjm+TBbpX4gBzYWEvDTok4y4/Ugc/vJSahTSsedXt3gej+u17/2A8MY9c1ks8V
         7e/uyDCJozbVzL1XsAcOSHkU9WH3UqXsuzu1Rx35CGg6BDNsAJ6hejB0NZUJ4pZhUFkH
         0gfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679499703;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JcaSHBOVM7lOp4H4ylkCBQXuh0C+r55dheOxQqbKNMM=;
        b=r7VHAS7qE9nwxeqw5ibXPuS8gJUUqZcW9jHl8l+742/K1LPfMCwgSSZbK8EMiXBP0x
         epmQheEMarsLxtdOSIAEzAqjOQCJj0VyIXj6XL3i71LENEhND2/VhfaJZuJ2qz0mVBJ9
         yoM+vIgcqME5siMu3UUW0EjrZH8YKz3Xt7QQHSrA0dpnGYAhN4jafGSp8JCkGOa7De0n
         shr67CaN1AYzGe8mZViw3YFAU/Sd6Wj6cFcJRYA5OWwjB/FAEWVxLyMi7sqgMvuLKj+5
         hPqWEIOR7ME7f6/G05OfHbC2yMIcylKRp6y6LeWs4OQlStD1MYcFyFxFG/O1uUiUEgx2
         v1fQ==
X-Gm-Message-State: AO0yUKWV3YWYaEBXJkKWt3lHmB3071XJo50H8+BKfbkCz8zdw91a7KBa
        jd3TprBWi4mOc48TtW83mJiW10S9Yg==
X-Google-Smtp-Source: AK7set9Fzj1TTWcMs9pgOGGVOAQeYKn29zLgjpwFBNEzTfL6XDjxPcpWw8i0tsR8SB/3hR0TrgU8JQ==
X-Received: by 2002:a17:906:6408:b0:8bf:e95c:467b with SMTP id d8-20020a170906640800b008bfe95c467bmr6783215ejm.63.1679499702946;
        Wed, 22 Mar 2023 08:41:42 -0700 (PDT)
Received: from p183 ([46.53.253.128])
        by smtp.gmail.com with ESMTPSA id e9-20020a17090681c900b008cf377e8795sm7388783ejx.199.2023.03.22.08.41.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 08:41:42 -0700 (PDT)
Date:   Wed, 22 Mar 2023 18:41:40 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     live-patching@vger.kernel.org
Subject: question re klp_transition_work kickoff timeout
Message-ID: <c84a0b0c-4232-451e-be0b-a6c29d69c1a8@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi, Josh.

I've been profiling how much time livepatching takes and I have a question
regarding these lines:

	void klp_try_complete_transition(void)
	{
		...
		if (!complete) {
			schedule_delayed_work(&klp_transition_work, round_jiffies_relative(HZ));
			return;
		}

	}

The problem here is that if the system is idle, then the previous loop
checking idle tasks will reliably sets "complete = false" and then
patching wastes time waiting for next second so that klp_transition_work
will repeat the same code without reentering itself.

I've created trivial patch which changes 2 functions and it takes
~1.3 seconds to complete transition:

	[   33.829506] livepatch: 'main': starting patching transition
	[   35.190721] livepatch: 'main': patching complete

I don't know what's the correct timeout to retry transition work
but it can be made near-instant:

	[  100.930758] livepatch: 'main': starting patching transition
	[  100.956190] livepatch: 'main': patching complete


	Alexey (CloudLinux)


--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -435,8 +435,7 @@ void klp_try_complete_transition(void)
 		 * later and/or wait for other methods like kernel exit
 		 * switching.
 		 */
-		schedule_delayed_work(&klp_transition_work,
-				      round_jiffies_relative(HZ));
+		schedule_delayed_work(&klp_transition_work, msecs_to_jiffies(1));
 		return;
 	}
 
