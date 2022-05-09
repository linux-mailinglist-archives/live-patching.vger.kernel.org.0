Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FE95205CD
	for <lists+live-patching@lfdr.de>; Mon,  9 May 2022 22:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiEIU1L (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 9 May 2022 16:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbiEIU0K (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Mon, 9 May 2022 16:26:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3367D2C2E18;
        Mon,  9 May 2022 13:09:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C983EB8197F;
        Mon,  9 May 2022 20:09:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDF1C385BA;
        Mon,  9 May 2022 20:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652126991;
        bh=vBnibpZgtQL72SAnBoVw33x3OojiEy+kvKl1EOb/oP0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qqx0LGpCCuQVU3Z10ralVXhJdP2qRN+GFmS3ah9SSsGRuEML6xmbkCoznFVMxmlPS
         pmzRMyKSlHS38WqYi+fldTxJljxwoILAU7TFXEmc44r7n+b/tIobQ/Hy8MnKN4FGh6
         Wwp8wBAGnI4nou8V5reu2qz+PR4J4mlZfm0hDp7+nsvCujwpovOAvvLgMgtn/5KFZO
         DipY51NajQusSdB0O4WMeqMh9kS8dqMZhyylsAQGLfMJ24OdhS2B3uRHCUgX9b45vj
         YzU6NELjzyXCmggVVE1e+TSKb/HMV7v/rPIWJThuaUwE5Kxt0MT1+6XlOmP2Q0vh0H
         hG6tUU7Yqk13w==
Date:   Mon, 9 May 2022 13:09:49 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Rik van Riel <riel@surriel.com>
Cc:     Song Liu <song@kernel.org>, linux-kernel@vger.kernel.org,
        live-patching@vger.kernel.org, mingo@redhat.com,
        peterz@infradead.org, vincent.guittot@linaro.org,
        jpoimboe@redhat.com, joe.lawrence@redhat.com, kernel-team@fb.com
Subject: Re: [RFC] sched,livepatch: call stop_one_cpu in
 klp_check_and_switch_task
Message-ID: <20220509200949.vzx4g5xpebomkok4@treble>
References: <20220507174628.2086373-1-song@kernel.org>
 <20220509115227.6075105e@imladris.surriel.com>
 <20220509180004.zmvhz65xlncwqrrc@treble>
 <68f91fb233d5bf82e29cc5c6960a62863b297db3.camel@surriel.com>
 <20220509191745.yk2txsa4cv3ypf6k@treble>
 <1f94c48b4e0e7d73a689a076f78f0892095b4d89.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1f94c48b4e0e7d73a689a076f78f0892095b4d89.camel@surriel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, May 09, 2022 at 03:49:52PM -0400, Rik van Riel wrote:
> On Mon, 2022-05-09 at 12:17 -0700, Josh Poimboeuf wrote:
> > On Mon, May 09, 2022 at 03:10:16PM -0400, Rik van Riel wrote:
> > 
> > 
> > > Should kernel threads that can use a lot of CPU have
> > > something in their outer loop to transition KLPs,
> > > just like the idle task does?
> > 
> > Maybe - I suppose this is the first time we've had an issue with
> > CPU-bound kthreads.  I didn't know that was a thing ;-)
> > 
> Kworkers have as much work as you want them to do, and with
> things like btrfs compression that can be quite a bit.

To prevent patching, it would need to be some kind of sustained CPU
activity, rather than a burst.  I guess we haven't seen that show up as
a real-world problem until now.

If you're able to identify which kthreads would be problematic, then
yeah, defining a "transition point" in their outer loops could be an
option.

We could look also at a more general approach, like stack checking from
an irq handler.  But as Petr alluded to, that would be problematic for
CONFIG_FRAME_POINTER.

We could maybe deprecate frame pointers on x86 for live patching, but I
think other arches would have a similar problem unless they were to do
something like the ORC unwinder.

-- 
Josh
