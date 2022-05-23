Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D17F53124C
	for <lists+live-patching@lfdr.de>; Mon, 23 May 2022 18:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237988AbiEWP3F (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 23 May 2022 11:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237958AbiEWP3C (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 23 May 2022 11:29:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFC55F24A
        for <live-patching@vger.kernel.org>; Mon, 23 May 2022 08:28:57 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C52B821ADF;
        Mon, 23 May 2022 15:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653319735; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jem8FhQW836UK+ykeN9QiCIY1SDpyQ0+Kmk2n3rFb8k=;
        b=PzD31psqZiMHtmL4hpLVuA2q1udh3VLX/R7tcI1nZM3mTxij5/y29Bp0UmtF3Hr03uh18s
        KENm5SvqIW0DY9iuMb0306jBTXaNZhOUmdrBA2WfPZtcCjmG/MydCeOHQiWWw5RiE9a9j9
        iTSZ0nQsdbDasJAuKbLZug2eEd+Aorw=
Received: from suse.cz (unknown [10.100.208.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id A55972C141;
        Mon, 23 May 2022 15:28:55 +0000 (UTC)
Date:   Mon, 23 May 2022 17:28:55 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Yannick Cote <ycote@suse.com>
Subject: Re: [PATCH] selftests/livepatch: better synchronize
 test_klp_callbacks_busy
Message-ID: <YouoN2OAzvZIKhPa@alley>
References: <20220518173424.911649-1-joe.lawrence@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518173424.911649-1-joe.lawrence@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-05-18 13:34:24, Joe Lawrence wrote:
> The test_klp_callbacks_busy module conditionally blocks a future
> livepatch transition by busy waiting inside its workqueue function,
> busymod_work_func().  After scheduling this work, a test livepatch is
> loaded, introducing the transition under test.
> 
> Both events are marked in the kernel log for later verification, but
> there is no synchronization to ensure that busymod_work_func() logs its
> function entry message before subsequent selftest commands log their own
> messages.  This can lead to a rare test failure due to unexpected
> ordering like:
> 
>   --- expected
>   +++ result
>   @@ -1,7 +1,7 @@
>    % modprobe test_klp_callbacks_busy block_transition=Y
>    test_klp_callbacks_busy: test_klp_callbacks_busy_init
>   -test_klp_callbacks_busy: busymod_work_func enter
>    % modprobe test_klp_callbacks_demo
>   +test_klp_callbacks_busy: busymod_work_func enter
>    livepatch: enabling patch 'test_klp_callbacks_demo'
>    livepatch: 'test_klp_callbacks_demo': initializing patching transition
>    test_klp_callbacks_demo: pre_patch_callback: vmlinux
> 
> Force the module init function to wait until busymod_work_func() has
> started (and logged its message), before exiting to the next selftest
> steps.
> 
> Fixes: 547840bd5ae5 ("selftests/livepatch: simplify test-klp-callbacks busy target tests")
> Signed-off-by: Joe Lawrence <joe.lawrence@redhat.com>
> ---
> 
> Hi Petr, I remember you discouraged against a completion variable the
> first time around [1], but is there any better way with the workqueue
> API to ensure our "enter" message gets logged first?

I think that the code was more complicated at that time.
Or I have got used to it ;-)


> Or should we just drop the msg altogether to avoid the situation?
> I don't think it's absolutely necessary for the tests.

IMHO, the message helps to make sure that the timing is correct.
I would keep it.


> [1] https://lore.kernel.org/live-patching/20200602081654.GI27273@linux-b0ei/
> 
>  lib/livepatch/test_klp_callbacks_busy.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/lib/livepatch/test_klp_callbacks_busy.c b/lib/livepatch/test_klp_callbacks_busy.c
> index 7ac845f65be5..eb502b2bb3ef 100644
> --- a/lib/livepatch/test_klp_callbacks_busy.c
> +++ b/lib/livepatch/test_klp_callbacks_busy.c
> @@ -16,10 +16,16 @@ MODULE_PARM_DESC(block_transition, "block_transition (default=false)");
>  
>  static void busymod_work_func(struct work_struct *work);
>  static DECLARE_WORK(work, busymod_work_func);
> +static DECLARE_COMPLETION(busymod_work_started);
>  
>  static void busymod_work_func(struct work_struct *work)
>  {
> +	/*
> +	 * Hold the init function from exiting until we've started and
> +	 * announced our appearence in the kernel log.
> +	 */

This message would make more sense above the wait_for_completion().
The wait function holds the init function. I would remove the comment here.

>  	pr_info("%s enter\n", __func__);
> +	complete(&busymod_work_started);
>  
>  	while (READ_ONCE(block_transition)) {
>  		/*
> @@ -36,6 +42,7 @@ static int test_klp_callbacks_busy_init(void)
>  {
>  	pr_info("%s\n", __func__);
>  	schedule_work(&work);

Instead, I would add here something like:

	/*
	 * Hold the init function from exiting until the message
	 * about entering the busy loop is printed.
	 */
> +	wait_for_completion(&busymod_work_started);
>  
>  	if (!block_transition) {
>  		/*
> -- 
> 2.26.3

With the updated message:

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

PS: I am sorry for the late review. I have busy times.
