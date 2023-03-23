Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90BA06C641D
	for <lists+live-patching@lfdr.de>; Thu, 23 Mar 2023 10:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjCWJxs (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 23 Mar 2023 05:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjCWJxE (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 23 Mar 2023 05:53:04 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D29127984
        for <live-patching@vger.kernel.org>; Thu, 23 Mar 2023 02:52:38 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id o7so19773791wrg.5
        for <live-patching@vger.kernel.org>; Thu, 23 Mar 2023 02:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679565156;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WjqLZEdAj6KrT+P+BTSTlYkkrqX1HGkeSv3ZJs5gLIQ=;
        b=B4DwXnK00v51Brp2ypaDAYqV2VJpgukBQoIub6YJL9Bnyx6bWKfCLOB4X4qacxtLlx
         C/gvZabIVW6HLLs5Mvp2loLFbdUh+GNloOr0HEf8PyDlsoPzgfZtwfJC9gpNfHji99Lv
         Ri9rzi5UW2FJszrC7ZgdVCVti7c1+cIY+IFOjucT3IqZDke6gZjKNgJGZ62mMlVHza9t
         kswwqPHZw2k/a6GDuwoUTK8VgfUNsrO41RWK3U34MTGBC56oudeUMkb58bxKW2XlKY16
         WOJYNoJZ07BBKv/MB8Julv6AqCNGkuj3xYUT8uW/MTvzxghmyFk0mgFh8lZVaQf5P9o5
         ePQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679565156;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WjqLZEdAj6KrT+P+BTSTlYkkrqX1HGkeSv3ZJs5gLIQ=;
        b=gKEZzV10Sk5bC/nnEU3q4zTGlPv3KgaQR9eaQ/VSMsW7chyVaVRTL88j7Xl7ZbC4TU
         K0XcKFFk0YAtYru0G5pfD1CnMYOXdDjjyORL/577jS9IiiqEl3W0g/HgmQefVfTvCIz4
         cXOX+JAMA9VRvrOdpi93MYcEBfZzopBXvVcRS0kyuUiJqKtqidystW0G+HpjX4VHwy1l
         /0do6JuUv2KqkcaiNIoNnAsvvEdz+gHJ+GNrP6NiiS4Y7WWEEQWRENe8KfwANf1nhO4y
         ycEy5r8eRsm9YyXbf1uDgWf7RWN+ZRwg0GJPvCR4xWbsdbYxQ62Kx52RJJmAEP8IsBr6
         Y8gQ==
X-Gm-Message-State: AAQBX9et7YDtS9hE1VTGushPFmJNaSA7KTNr3edOnKWbZ41xt5yaS5aH
        OvH7pOycg9kHJdoF2loBOg==
X-Google-Smtp-Source: AKy350YCSaq0KilvKq/FbKTfZfXMlzdEUdVtV3mvgyaIRNvUbnb0rzLj1qdgR6irC3a9OgZMsoYqIg==
X-Received: by 2002:adf:ed4e:0:b0:2d6:4733:c36f with SMTP id u14-20020adfed4e000000b002d64733c36fmr2137730wro.23.1679565156487;
        Thu, 23 Mar 2023 02:52:36 -0700 (PDT)
Received: from p183 ([46.53.251.240])
        by smtp.gmail.com with ESMTPSA id e8-20020adffd08000000b002c592535839sm15769452wrr.17.2023.03.23.02.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 02:52:36 -0700 (PDT)
Date:   Thu, 23 Mar 2023 12:52:34 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>, live-patching@vger.kernel.org
Subject: Re: question re klp_transition_work kickoff timeout
Message-ID: <2ced976a-f801-44fa-98ec-832862ca4984@p183>
References: <c84a0b0c-4232-451e-be0b-a6c29d69c1a8@p183>
 <alpine.LSU.2.21.2303221703540.28751@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.21.2303221703540.28751@pobox.suse.cz>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Mar 22, 2023 at 05:07:09PM +0100, Miroslav Benes wrote:
> On Wed, 22 Mar 2023, Alexey Dobriyan wrote:
> 
> > Hi, Josh.
> > 
> > I've been profiling how much time livepatching takes and I have a question
> > regarding these lines:
> > 
> > 	void klp_try_complete_transition(void)
> > 	{
> > 		...
> > 		if (!complete) {
> > 			schedule_delayed_work(&klp_transition_work, round_jiffies_relative(HZ));
> > 			return;
> > 		}
> > 
> > 	}
> > 
> > The problem here is that if the system is idle, then the previous loop
> > checking idle tasks will reliably sets "complete = false" and then
> > patching wastes time waiting for next second so that klp_transition_work
> > will repeat the same code without reentering itself.
> 
> Only if klp_try_switch_task() cannot switch the idle task right away. We 
> then prod it using wake_up_if_idle() and handle it in the next iteration.
> 
> So the question might be why klp_try_switch_task() did not succeed in the 
> first place.

Yes, sort of. Transitioning never happens on the first try becase of idle
tasks (see debugging patch below). But it should happen immediately
because machine is idle!

> > I've created trivial patch which changes 2 functions and it takes
> > ~1.3 seconds to complete transition:
> > 
> > 	[   33.829506] livepatch: 'main': starting patching transition
> > 	[   35.190721] livepatch: 'main': patching complete
> > 
> > I don't know what's the correct timeout to retry transition work
> > but it can be made near-instant:
> > 
> > 	[  100.930758] livepatch: 'main': starting patching transition
> > 	[  100.956190] livepatch: 'main': patching complete
> 
> There is really no correct timeout. The application of a live patch is 
> a lazy slow path. We generally do not care when it is finished unless it 
> is stuck for some reason or takes really long.
> 
> What is your motivation in measuring it?

Just measuring... :-)

	main: tainting kernel with TAINT_LIVEPATCH
	livepatch: enabling patch 'main'
	livepatch: 'main': starting patching transition
	livepatch: XXX 002 klp_try_switch_task 'swapper/0'
		...
	livepatch: XXX 002 klp_try_switch_task 'swapper/31'
	livepatch: XXX nr_a 0, nr_b 30
	livepatch: 'main': patching complete

--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -386,7 +386,8 @@ void klp_try_complete_transition(void)
 	unsigned int cpu;
 	struct task_struct *g, *task;
 	struct klp_patch *patch;
-	bool complete = true;
+	unsigned int nr_a = 0;
+	unsigned int nr_b = 0;
 
 	WARN_ON_ONCE(klp_target_state == KLP_UNDEFINED);
 
@@ -401,8 +402,10 @@ void klp_try_complete_transition(void)
 	 */
 	read_lock(&tasklist_lock);
 	for_each_process_thread(g, task)
-		if (!klp_try_switch_task(task))
-			complete = false;
+		if (!klp_try_switch_task(task)) {
+			pr_err("XXX 001 klp_try_switch_task '%s'\n", task->comm);
+			nr_a += 1;
+		}
 	read_unlock(&tasklist_lock);
 
 	/*
@@ -413,7 +416,8 @@ void klp_try_complete_transition(void)
 		task = idle_task(cpu);
 		if (cpu_online(cpu)) {
 			if (!klp_try_switch_task(task)) {
-				complete = false;
+				pr_err("XXX 002 klp_try_switch_task '%s'\n", task->comm);
+				nr_b += 1;
 				/* Make idle task go through the main loop. */
 				wake_up_if_idle(cpu);
 			}
@@ -425,7 +429,9 @@ void klp_try_complete_transition(void)
 	}
 	cpus_read_unlock();
 
-	if (!complete) {
+	if (nr_a > 0 || nr_b > 0) {
+		pr_err("XXX nr_a %u, nr_b %d\n", nr_a, nr_b);
+
 		if (klp_signals_cnt && !(klp_signals_cnt % SIGNALS_TIMEOUT))
 			klp_send_signals();
 		klp_signals_cnt++;
